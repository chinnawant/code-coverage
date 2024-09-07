#!/bin/bash

dir_report="coverage_report"
coverage_summary_file="coverage_summary.txt"
error_file="outfile_error.txt"
total_coverage=0.0
count=0
ignore_list=("$dir_report")
path_test_dir="./pkg/service"


# Check if the coverage report directory exists
if [ -d "$dir_report" ]; then
  rm  ./$dir_report/*
else
  mkdir $dir_report
fi



# Loop through all directories in the current directory
for dir in "."/*; do

    dir_name=$(basename "$dir")
    # Check if the directory is in the ignore list
    if [[ " ${ignore_list[*]} " =~ " ${dir_name} " ]]; then
        echo "Skipping ignored directory: $dir"
        continue  # Skip this iteration and move to the next directory
    fi

    # Check if the directory is a project directory
    if [ -d "$dir" ]; then

        project=$(basename "$dir")
        echo "Entering directory $dir"

        cd "$dir" || exit
        echo "Running tests for $project"

        # Run the tests and calculate the coverage
        go test $path_test_dir -coverprofile cover.out
        if [ ! -f cover.out ]; then
            echo "Error: cover.out file not found" >> "../$dir_report/$error_file"
            cd ..  # Return to the parent directory
            continue
        fi

        # Extract the total coverage percentage from the coverage profile file (cover.out)
        coverage=$(go tool cover -func cover.out | grep total: | awk '{print $3}' | tr -d '%')


        # Check if the coverage is a valid number
        if [[ $coverage =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
            echo "$project: $coverage%" >> "../$dir_report/project.txt"
            total_coverage=$(echo "$total_coverage + $coverage" | bc)
            ((count++))
            echo "Coverage: $coverage%"

        else
            echo "Error: Invalid coverage percentage: $coverage" >> "../$dir_report/$coverage_summary_file"
        fi

        cd ..  # Return to the parent directory
    fi


done


# Calculate the average coverage
average=$(echo "$total_coverage / $count" | bc)
echo "Summary: Average coverage: $average%"
echo "Summary: Average coverage: $average%" >> "./$dir_report/$coverage_summary_file"