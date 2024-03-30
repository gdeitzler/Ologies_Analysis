import pandas as pd
import re
from collections import Counter

# Read the dataset from CSV
df = pd.read_csv(r'Input.csv')

# Regular Expression pattern to match words containing "ology"
pattern_ology = r'\b\w*ology\w*\b'

# Function to extract words containing "ology" from a title
def extract_ology_words(title):
    return re.findall(pattern_ology, title, re.IGNORECASE)

# Apply the parsing function to the 'title' column
df['ology'] = df['title'].apply(lambda x: extract_ology_words(str(x)))

# Count the recurrence of words in the 'ology' category
ology_words = [word for sublist in df['ology'].tolist() for word in sublist]
ology_word_counts = Counter(ology_words)

# Sort the word counts from most to least occurrences
sorted_word_counts = ology_word_counts.most_common()

# Print the sorted word counts
print("Word counts in the 'ology' category (sorted from most to least occurrences):")
for word, count in sorted_word_counts:
    print(f"{word}: {count}")
