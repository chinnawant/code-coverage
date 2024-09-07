#!/bin/bash

ignore_list=()


for dir in "."/*; do

    # Check if the directory is in the ignore list
  if [[ "${ignore_list[*]}" ]]; then
        echo "===> Skipping ignored directory: $dir <==="
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
        echo "===> Skipping  not directory: $dir <==="
  fi

done
