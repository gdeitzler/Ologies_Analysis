# Ologies_Analysis
Statistical analysis of the popular sci-comm podcast Ologies, hosted by Alie Ward.

Ever wondered what types of "Ologies" appear most frequently on the podcast? We're doing an analysis to assess prevalence of different fields and subfields and their representation on the Ologies show. This started as just a fun project to learn more data science skills.

This project is a collaboration between Grace Deitzler, PHD and Nick Bira, PHD, two long-time Ologies enthusiasts.

# Results Markdown

Ologies_Analysis_Markdown.md contains the Rmarkdown file with all generated plots integrated. Very user-friendly to read. Feel free to check it out!

# Ologies Dataset Parsing using Spotify

Datascraping from Spotify to create this dataset of the Ologies podcast was accomplished using four simple python files.

## Spotify_API_Call

This first script utilizes the Spotipy library, along with an account created with Spotify to get access to the Spotify API, to retrieve information about the Ologies podcast.
For this to work, you need all the correct Spotify API credentials, which you will need to generate/find on your own (client ID, client secret, and redirect URI).
Once established, it retrieves the available data for all episodes of Ologies from Spotify.
From this data, it extracts relevant information such as title, release data, and duration.
Then, it exports this data to a .csv file using the pandas library.

## Parse Titles

This second script reads through the newly generated csv and labels some additional information.
In particular, it extracts the specific "ology" from the title and adds that to a new column, and creates columns for flags if the episode is a smology, part 2, or encore.

## Extract Duplicates

This simple script checks for duplicate episodes using the flags from earlier, and removes them from the dataset to get a simpler csv focused purely on the different, original episodes.

From here, the final Ologies_Dataset.csv was cleaned up and then manually labeled with the branch of science label for each episode to get additional sorting labels.

## Ologies Analysis R

This file includes all of the R code used to visualize the curated dataset. ggplot2 is used to create plots to investigate differences in primary topic distribution, episode length, frequency, and patterns over time.
