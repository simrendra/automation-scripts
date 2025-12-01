#!/bin/bash

# This script iterates over a list of YouTube URLs provided in an external file
# and executes yt-dlp for each one to download and convert the audio to MP3 format.

# --- Configuration ---

# The base command: -x extracts the audio, --audio-format mp3 converts it.
BASE_COMMAND="yt-dlp -x --audio-format mp3"

# --- Script Execution ---

# 1. Check if a filename was provided as the first argument
if [ -z "$1" ]; then
    echo "Error: Please provide a file containing the list of URLs as an argument." >&2
    echo "Usage: $0 <url_list_file>" >&2
    exit 1
fi

URL_FILE="$1"

# 2. Check if the file exists and is readable
if [ ! -f "$URL_FILE" ]; then
    echo "Error: File not found or is not a regular file: $URL_FILE" >&2
    exit 1
fi

echo "Starting batch download for videos listed in: $URL_FILE"
echo "---"

# 3. Read the URLs from the provided file, filter for unique entries, and process them.
# The 'cat' command reads the file content.
cat "$URL_FILE" | sort -u | while IFS= read -r URL; do
    # Skip lines that are empty or contain only whitespace
    [ -z "$URL" ] && continue

    echo "Processing URL: $URL"
    
    # Execute the command. The URL is wrapped in double quotes for safety.
    $BASE_COMMAND "$URL"
    
    # Check the exit status of the previous command ($?)
    if [ $? -eq 0 ]; then
        echo "SUCCESS: Audio downloaded and converted."
    else
        echo "ERROR: Failed to process URL $URL. Check yt-dlp output for details." >&2
    fi
    echo "---"
done

echo "Batch processing complete."

# To use this script:
# 1. Create a file (e.g., 'urls.txt') and paste your YouTube links into it (one per line).
# 2. Run the script: ./download_audio.sh urls.txt

# Note: The output MP3 files will be saved in the directory where you run this script.
