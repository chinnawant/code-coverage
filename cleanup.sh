#!/bin/bash

# Output file for coverage summaries
output_file="coverage_summary.txt"
base_dir="."


# Variables to calculate average
total=0.0
count=0

# Navigate to each project, run tests, print coverage percentage, and calculate running average
for dir in "$base_dir"/*; do
    dir_name=$(basename "$dir")
    # Check if the directory is in the ignore list
 
    
    if [ -d "$dir" ] && [ -f "$dir/go.mod" ]; then  # Check if $dir is a directory and contains go.mod
        project=$(basename "$dir")
        cd "$dir" || exit  # Change to the directory or exit on failure
        echo "Running tests for $project"
        truncate -s 0 "$output_file"  
        cd ..  # Return to the parent directory
    else
        echo "Directory $dir does not contain a Go module."
    fi
done


truncate -s 0 "coverage_summary.txt"  
truncate -s 0 "project.txt"  
truncate -s 0 "outfile_error.txt"  