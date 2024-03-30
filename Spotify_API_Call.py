import spotipy
import json
from spotipy.oauth2 import SpotifyOAuth

import pandas as pd

# Set up authentication
sp = spotipy.Spotify(auth_manager=SpotifyOAuth(client_id='ID_GOES_HERE',
                                               client_secret='SECRET_GOES_HERE',
                                               redirect_uri='https://localhost:8888/callback',
                                               scope='user-library-read'))

# Podcast ID
podcast_id = 'EXAMPLE_ID_GOES_HERE'  # Example podcast ID

# Access podcast episodes
def get_all_episodes(podcast_id):
    episodes = []
    offset = 0
    limit = 50  # Max limit per request

    while True:
        response = sp.show_episodes(podcast_id, limit=limit, offset=offset)
        episodes.extend(response['items'])
        if len(response['items']) < limit:
            break
        offset += limit

    return episodes

all_episodes = get_all_episodes(podcast_id)

# Print the total number of episodes retrieved
print("Total episodes:", len(all_episodes))

# Now you can process or export these episodes as needed

def create_dataset(episodes):
    """Create dataset from podcast episodes."""
    dataset = []
    for episode in episodes:
        episode_data = {
            'title': episode['name'],
            'release_date': episode['release_date'],
            'duration_ms': episode['duration_ms'],
            # Add more fields as needed
        }
        dataset.append(episode_data)
    return dataset

def export_to_csv(dataset, filename):
    """Export dataset to a CSV file using pandas."""
    df = pd.DataFrame(dataset)
    df.to_csv(filename, index=False)

dataset = create_dataset(all_episodes)
# print(dataset)

export_to_csv(dataset, 'podcast_episodes.csv')