#!/bin/bash

# Clear the output files
echo "" > "project.txt"
echo "" > "coverage_summary.txt"
echo "" > "outfile_error.txt"


# Output file for coverage summaries
output_file="coverage_summary.txt"
oytput_file_error="outfile_error.txt"
base_dir="."

# Define an array of directories to ignore
ignore_list=("eipp-api-adapter" "sandbox-core-adapter" "db-migration" "signup-request-processor")

# Variables to calculate average
total=0.0
count=0

test="./pkg/service"


# Navigate to each project, run tests, print coverage percentage, and calculate running average
for dir in "$base_dir"/*; do
    dir_name=$(basename "$dir")
    # Check if the directory is in the ignore list
    if [[ " ${ignore_list[*]} " =~ " ${dir_name} " ]]; then
        echo "Skipping ignored directory: $dir"
        continue  # Skip this iteration and move to the next directory
    fi
    
    if [ -d "$dir" ] && [ -f "$dir/go.mod" ]; then  # Check if $dir is a directory and contains go.mod
        project=$(basename "$dir")
        echo "Entering directory $dir"
        cd "$dir" || exit  # Change to the directory or exit on failure
        echo "Running tests for $project"
        go test  $test -coverprofile cover.out

        coverage=$(go tool cover -func cover.out | grep total: | awk '{print $3}' | tr -d '%')

        # Check if the coverage is a valid number
        if [[ $coverage =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
            echo "$project: $coverage%" >> "../project.txt"
            total=$(echo "$total + $coverage" | bc)
            ((count++))
            echo "Coverage: $coverage%"
        else
            echo "$project: Error in coverage data" >> "../$oytput_file_error"
        fi
        cd ..  # Return to the parent directory
    else
        echo "Skipping non-project directory: $dir"
    fi
done

average=$(echo "$total / $count" | bc)
echo "Summary: Average coverage: $average%"
echo "Summary: Average coverage: $average%" >> "$output_file"