#!/bin/bash

dir="coverage_report"
input_file1="./$dir/project.txt"
input_file2="./$dir/coverage_summary.txt"
out_file="./$dir/sandbox_orchestrator.csv"

# Check if input1 file exists
if [ -f "$input_file1" ]; then
    # Process input1 file and convert to CSV format
    sed 's/: /,/' "$input_file1" > $out_file

    # Add header to the CSV file
    echo "Service,Percentage" | cat - $out_file > temp && mv temp $out_file

    echo "Processed $input_file1 and created sandbox_orchestrator.csv"
else
    echo "File $input_file1 not found!"
fi

# Check if input2 file exists
if [ -f "$input_file2" ]; then

    # Extract the coverage percentage from input2 using awk (more compatible)
    coverage=$(awk -F'[:]' '/Average coverage/ {print $3}' "$input_file2")

    # Append the extracted value to the CSV file
    echo "Average Coverage,$coverage" >> $out_file

    echo "Appended coverage data from $input_file2 to sandbox_orchestrator.csv"
else
    echo "File $input_file2 not found!"
fi