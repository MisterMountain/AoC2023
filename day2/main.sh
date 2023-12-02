#!/bin/bash

calculate_factor() {
    local red=$1
    local green=$2
    local blue=$3

    local factor=$((red * green * blue))
    powersum=$((powersum + factor))
}

# Function to process each line
problem1() {
    local line="$1"
    
    # split lines into gameID and key:value pair part
    local game_number=$(echo "$line" | grep -oP '^Game \K\d+')
    local trimmed_string=$(echo "$line" | sed 's/Game [0-9]*: //')
    
    # Split trimmed_string into semicolon-separated parts
    IFS=';' read -ra parts <<< "$trimmed_string"
    
    # Initialize maximum values for each color
    local max_red=0
    local max_green=0
    local max_blue=0

    # Initialize sums for the entire game
    local red_sum=0
    local green_sum=0
    local blue_sum=0

    # Loop through each part and calculate sums
    for part in "${parts[@]}"; do
        # Extract numbers for each color
        local red=$(echo "$part" | grep -oP '\d+ red' | awk '{print $1}')
        local green=$(echo "$part" | grep -oP '\d+ green' | awk '{print $1}')
        local blue=$(echo "$part" | grep -oP '\d+ blue' | awk '{print $1}')

        ((max_red = red > max_red ? red : max_red))
        ((max_green = green > max_green ? green : max_green))
        ((max_blue = blue > max_blue ? blue : max_blue))
        ((red_sum += red))
        ((green_sum += green))
        ((blue_sum += blue))
    done

    for part in "${parts[@]}"; do
        echo "$game_number Maximum Red: $max_red, Maximum Green: $max_green, Maximum Blue: $max_blue" > /dev/null
    done

    calculate_factor "$max_red" "$max_green" "$max_blue"
}
problem2() {
    local input_file="$1"
    local max="$2"
    
    local counter=0
    local valid_game_sum=0

    while IFS= read -r line && ((counter < max)); do
        ((counter++))
        game_number=$(echo "$line" | grep -oP '^Game \K\d+')
        trimmed_string=$(echo "$line" | sed 's/Game [0-9]*: //')
        
        IFS=';' read -ra parts <<< "$trimmed_string"
        
        game_valid=true

        for part in "${parts[@]}"; do
            red_sum=0
            green_sum=0
            blue_sum=0

            red=$(echo "$part" | grep -oP '\d+ red' | awk '{print $1}')
            green=$(echo "$part" | grep -oP '\d+ green' | awk '{print $1}')
            blue=$(echo "$part" | grep -oP '\d+ blue' | awk '{print $1}')

            ((red_sum += red))
            ((green_sum += green))
            ((blue_sum += blue))

            # Check if sums exceed thresholds for the entire game
            if ((red_sum > 12)) || ((green_sum > 13)) || ((blue_sum > 14)); then
                game_valid=false
                break
            fi
        done

        if $game_valid; then
            ((valid_game_sum += game_number))
            for part in "${parts[@]}"; do
                echo "Game $game_number" > /dev/null
            done
        fi
    done < "$input_file"

    echo "Sum of Valid Game Numbers: $valid_game_sum"
}

input_file="puzzle"
max=100
echo "red 12 green 13 blue 14"
counter=0
valid_game_sum=0
powersum=0

while IFS= read -r line && ((counter < $max)); do
    ((counter++))
    problem1 "$line"
done < "$input_file"

echo "Factor of Maximum Values: $powersum"
problem2 "$input_file" "$max"