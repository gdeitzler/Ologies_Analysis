import pandas as pd
import re

# Read the dataset from CSV
df = pd.read_csv(r'Input.csv')

# Regular Expression pattern to match words containing "ology"
pattern_ology = r'\b\w*ology\w*\b'

# Regular Expression pattern to match the word "Smologies"
pattern_smologies = r'\bPart 2\b'

# Function to extract words containing "ology" from a title
def extract_ology_words(title):
    return re.findall(pattern_ology, title, re.IGNORECASE)

# Function to check if the word "Smologies" appears in the title
def check_smologies(title):
    return 1 if re.search(pattern_smologies, title, re.IGNORECASE) else 0

# Apply the parsing functions to the 'title' column
df['ology'] = df['title'].apply(lambda x: extract_ology_words(str(x)))
df['Smologies'] = df['title'].apply(lambda x: check_smologies(str(x)))

# Write the modified dataset to a new CSV file
df.to_csv(r'Output.csv', index=False)

print("New CSV file with 'ology' and 'Smologies' columns created successfully.")