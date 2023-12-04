#!/bin/bash

# Check if the input file exists
input_file="puzzle"
if [ ! -f "$input_file" ]; then
    echo "Error: Input file '$input_file' not found."
    exit 1
fi

# Read the cards from the input file
mapfile -t cards < "$input_file"

# Initialize total points
total_points=0

# Iterate through each card
for card in "${cards[@]}"; do
    card_data=$(echo "$card" | cut -d ":" -f 2-)

    # Split the card into left and right parts
    left_part=$(echo "$card_data" | cut -d "|" -f 1)
    right_part=$(echo "$card_data" | cut -d "|" -f 2)


    # Convert the space-separated numbers into sorted arrays
    left_array=($(echo "$left_part" | tr ' ' '\n' | sort -n))
    right_array=($(echo "$right_part" | tr ' ' '\n' | sort -n))

    # Compare the sorted numbers on the left and right
    common_numbers=()
    for num in "${right_array[@]}"; do
        if [[ " ${left_array[@]} " =~ " $num " ]]; then
            common_numbers+=($num)
        fi
    done

    # Calculate points based on the number of common numbers
    num_common=${#common_numbers[@]}
    points=1

    for ((i=1; i<num_common; i++)); do
        points=$((points * 2))
    done
    
    if [ "$num_common" -eq 0 ]; then
        points=0
    elif [ "$num_common" -eq 1 ]; then
        points=1
    fi

    # Update total points
    total_points=$((total_points + points))

    # Print the result
    echo "${left_array[@]} | ${right_array[@]}"
    echo "Numbers on the right that are also on the left: ${common_numbers[@]}"
    echo "Number of matches: $num_common"
    echo "Points for this card: $points"
    echo
done

# Print the total points
echo "Total points: $total_points"
