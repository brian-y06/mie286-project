import pandas as pd
import os

def split_data():
    base_dir = os.path.dirname(os.path.abspath(__file__))
    master_file = os.path.join(base_dir, 'master_data.csv')
    assignments_file = os.path.join(base_dir, 'participant_assignments.csv')
    
    # Check if files exist
    if not os.path.exists(master_file):
        print("Error: master_data.csv not found.")
        return
    if not os.path.exists(assignments_file):
        print("Error: participant_assignments.csv not found.")
        return

    # Load the data
    print("Loading data...")
    master_df = pd.read_csv(master_file)
    assignments_df = pd.read_csv(assignments_file)

    # 1. We only want the experimental trials for the T-Test
    experimental_df = master_df[master_df['phase'] == 'experimental']

    # 2. Filter master_df strictly based on the participant_assignments.csv mapping
    # By merging on both 'participantId' AND 'condition', we automatically filter out 
    # the unassigned condition for each participant.
    filtered_df = pd.merge(experimental_df, assignments_df, on=['participantId', 'condition'], how='inner')

    # 3. Drop rows with invalid logReactionTime
    filtered_df = filtered_df.dropna(subset=['logReactionTime'])

    # 4. Split into two DataFrames
    auditory_df = filtered_df[filtered_df['condition'] == 'auditory']
    visual_df = filtered_df[filtered_df['condition'] == 'visual']

    # 5. Save to new CSVs
    auditory_out = os.path.join(base_dir, 'ttest_auditory_data.csv')
    visual_out = os.path.join(base_dir, 'ttest_visual_data.csv')
    
    auditory_df.to_csv(auditory_out, index=False)
    visual_df.to_csv(visual_out, index=False)

    print("\nSuccessfully split the data for the T-Test!")
    print(f"Auditory CSV saved to: {auditory_out} (Rows: {len(auditory_df)}, Participants: {auditory_df['participantId'].nunique()})")
    print(f"Visual CSV saved to: {visual_out} (Rows: {len(visual_df)}, Participants: {visual_df['participantId'].nunique()})")

    # Quick T-Test preview using scipy if available
    try:
        from scipy import stats
        t_stat, p_val = stats.ttest_ind(visual_df['logReactionTime'], auditory_df['logReactionTime'])
        print("\n=== Quick T-Test Preview (Python) ===")
        print(f"T-statistic: {t_stat:.4f}")
        print(f"P-value: {p_val:.4f}")
    except ImportError:
        pass

if __name__ == "__main__":
    split_data()
