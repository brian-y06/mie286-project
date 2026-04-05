import os
import glob
import pandas as pd
import numpy as np

def main():
    # Define paths relative to this script
    BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    DATA_DIR = os.path.join(BASE_DIR, 'data')
    OUTPUT_FILE = os.path.join(BASE_DIR, 'analysis', 'master_data.csv')

    print(f"Scanning for data in {DATA_DIR}...")
    
    # 1. Find all CSV files in the data directory (data/p*/*.csv)
    # Using recursive glob or just standard glob
    file_pattern = os.path.join(DATA_DIR, 'p*', '*.csv')
    csv_files = glob.glob(file_pattern)

    if not csv_files:
        print("No CSV files found in the data directory. Make sure participants have completed trials.")
        return

    print(f"Found {len(csv_files)} dataset(s). Aggregating...")

    # 2. Read and merge all CSVs into one DataFrame
    df_list = []
    for f in csv_files:
        try:
            df = pd.read_csv(f)
            df_list.append(df)
        except Exception as e:
            print(f"Error reading {f}: {e}")
            
    master_df = pd.concat(df_list, ignore_index=True)
    
    print(f"Total rows collected: {len(master_df)}")

    # 3. Calculate Baseline Typing Speed (Covariate)
    # Filter only control trials to calculate the baseline
    control_df = master_df[master_df['phase'] == 'control']
    
    if not control_df.empty:
        # Group by participant and calculate the mean typing time
        baseline_speeds = control_df.groupby('participantId')['typingTimeMs'].mean().reset_index()
        baseline_speeds.rename(columns={'typingTimeMs': 'baselineTypingSpeedMs'}, inplace=True)
        
        # Merge this baseline speed back into the main dataframe
        master_df = pd.merge(master_df, baseline_speeds, on='participantId', how='left')
        print("Calculated and added baseline typing speeds.")
    else:
        print("Warning: No control phase data found to calculate baselines.")
        master_df['baselineTypingSpeedMs'] = np.nan

    # 4. Data Cleaning & Transformation target: reactionTimeMs
    # Ensure reactionTimeMs is numeric (errors='coerce' turns non-numbers into NaN)
    master_df['reactionTimeMs'] = pd.to_numeric(master_df['reactionTimeMs'], errors='coerce')
    
    # Optional filtering of extreme outliers before log transform (e.g. less than 100ms or over 5000ms)
    # You can adjust these thresholds based on your standard deviation checks
    valid_rt_mask = (master_df['reactionTimeMs'] > 100) & (master_df['reactionTimeMs'] < 5000)
    
    # 5. Log-Transformation
    # Create log transform column (only calculates for valid_rt_mask where true)
    master_df['logReactionTime'] = np.nan
    master_df.loc[valid_rt_mask, 'logReactionTime'] = np.log(master_df.loc[valid_rt_mask, 'reactionTimeMs'])
    
    # 6. Save the aggregated master dataset
    # Ensure analysis directory exists
    os.makedirs(os.path.dirname(OUTPUT_FILE), exist_ok=True)
    
    master_df.to_csv(OUTPUT_FILE, index=False)
    print(f"\nSuccess! Master dataset saved to: {OUTPUT_FILE}")
    print("\nData summary:")
    print(f"- Participants: {master_df['participantId'].nunique()}")
    print(f"- Conditions: {master_df['condition'].unique()}")
    print(f"- Processed Rows: {len(master_df)}")

if __name__ == "__main__":
    main()
