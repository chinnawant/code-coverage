#!/bin/bash

# List all untracked files
for file in $(git ls-files --others --exclude-standard); do
    # Remove each file
    rm -rf "$file"
done