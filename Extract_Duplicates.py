import pandas as pd

# Read the dataset from CSV
df = pd.read_csv(r'Input.csv')

# Filter out rows with 1 in any of the 'smologies', 'encore', or 'part_2' columns
df_filtered = df[(df['smologies'] != 1) & (df['encore'] != 1) & (df['part_2'] != 1)]

# Write the filtered dataset to a new CSV file
df_filtered.to_csv(r'Output.csv', index=False)

print("New CSV file with filtered entries created successfully.")