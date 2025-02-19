#!/bin/bash

# Define directories and file path
cq500_dir="$HOME/capsule/data/CQ500"
input_file="$HOME/capsule/code/cq500_samples.txt"

# Ensure the CQ500 directory exists
mkdir -p "$cq500_dir"

# Change to the CQ500 directory
cd "$cq500_dir" || exit

# Download files from the list
wget -i "$input_file"

# Unzip and delete successfully extracted ZIP files
for zipfile in *.zip; do
    if [ -f "$zipfile" ]; then
        unzip -o "$zipfile" && rm -f "$zipfile"
    fi
done

echo "Download, extraction, and cleanup complete!"