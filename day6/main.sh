#!/bin/bash

input_file="$1"
speed=0
time_array=()
distance_array=()

total1=1
total2=1
total3=1
total4=1

while IFS=':' read -r label values; do
    case $label in
        "Time")
            time_array+=($values)
            ;;
        "Distance")
            distance_array+=($values)
            ;;
    esac
done < "$input_file"

for ((i = 1; i <= ${time_array[0]}; i++)); do
    speed=$(($i))  
    remaining_time=$((${time_array[0]} - $i))
    distance_traveled=$((speed * remaining_time))
    if [ "$distance_traveled" -gt "${distance_array[0]}" ]; then
	    ((total1++))
	fi
done
for ((i = 1; i <= ${time_array[1]}; i++)); do
    speed=$(($i))
    remaining_time=$((${time_array[1]} - $i))
    distance_traveled=$((speed * remaining_time))
    if [ "$distance_traveled" -gt "${distance_array[1]}" ]; then
	    ((total2++))
	fi
done
for ((i = 1; i <= ${time_array[2]}; i++)); do
    speed=$(($i))
    remaining_time=$((${time_array[2]} - $i))
    distance_traveled=$((speed * remaining_time))
    if [ "$distance_traveled" -gt "${distance_array[2]}" ]; then
	    ((total3++))
	fi
done
for ((i = 1; i <= ${time_array[3]}; i++)); do
    speed=$(($i))
    remaining_time=$((${time_array[3]} - $i))
    distance_traveled=$((speed * remaining_time))
    if [ "$distance_traveled" -gt "${distance_array[3]}" ]; then
	    ((total4++))
	fi
done

((total1--))
((total2--))
((total3--))
((total4--))

exampletotal=$((total1*total2*total3))
total=$((total1*total2*total3*total4))



## part 2
total_ways=1

bignumber() {
    local result=""
    for element in "$@"; do
        result="${result}${element}"
    done
    echo "$result"
}

bigtime=$(bignumber "${time_array[@]}")
bigdist=$(bignumber "${distance_array[@]}")

echo $bigtime
echo $bigdist

calculate_ways_to_win() {
    local time=${1}
    local distance=${2}
    local total=1
    
    for ((i = 1; i <= time; i++)); do
        speed=$((i))
        remaining_time=$((time - i))
        distance_traveled=$((speed * remaining_time))
        
        if [ "$distance_traveled" -gt "$distance" ]; then
            ((total++))
            echo "success"
        fi
    done
    
    return $total
}

calculate_ways_to_win "$bigtime" "$bigdist"
if [ "$input_file" = "example" ]; then
    echo "++++++++++++EXAMPLE ONE $exampletotal++++++++++++++++++"
else
    echo "++++++++++++PART ONE $total++++++++++++++++++"
fi