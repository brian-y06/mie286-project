import random
import csv
import os

def generate_schedule():
    # Generate list of 30 participant IDs (p01 to p30)
    participants = [f"p{str(i).zfill(2)}" for i in range(1, 31)]
    
    # Shuffle the participants list randomly
    random.shuffle(participants)
    
    # First 15 go to Auditory, remaining 15 go to Visual
    auditory_group = participants[:15]
    visual_group = participants[15:]
    
    # Re-sort for clean presentation
    assignments = []
    for p in auditory_group:
        assignments.append({"participantId": p, "condition": "auditory"})
    for p in visual_group:
        assignments.append({"participantId": p, "condition": "visual"})
        
    # Sort alphabetically by participantId
    assignments = sorted(assignments, key=lambda x: x["participantId"])
    
    # Define file path
    base_dir = os.path.dirname(os.path.abspath(__file__))
    output_file = os.path.join(base_dir, "participant_assignments.csv")
    
    # Write to CSV
    with open(output_file, mode='w', newline='') as f:
        writer = csv.DictWriter(f, fieldnames=["participantId", "condition"])
        writer.writeheader()
        writer.writerows(assignments)
        
    print(f"Successfully generated a randomized schedule mapping 15 to auditory and 15 to visual.")
    print(f"Saved to: {output_file}")
    
    print("\nAuditory Group (15):")
    print(", ".join(sorted(auditory_group)))
    
    print("\nVisual Group (15):")
    print(", ".join(sorted(visual_group)))

if __name__ == "__main__":
    generate_schedule()
