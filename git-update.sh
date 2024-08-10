#!/bin/bash

base_dir="."

ignore_list=("eipp-api-adapter" "sandbox-core-adapter" "db-migration" "signup-request-processor")


for dir in "$base_dir"/*; do
    dir_name=$(basename "$dir")
    # Check if the directory is in the ignore list
    if [[ " ${ignore_list[*]} " =~ " ${dir_name} " ]]; then
        echo "Skipping ignored directory: $dir"
        continue  # Skip this iteration and move to the next directory
    fi
    
    if [ -d "$dir" ]; then  # Check if $dir is a directory and contains go.mod
        project=$(basename "$dir")
        cd "$dir" || exit  # Change to the directory or exit on failure
        echo "Updating $project"
        git reset --hard
        git clean -df
        git pull origin
        cd ..  # Return to the parent directory
    else
        echo "Skipping non-project directory: $dir"
    fi
done
