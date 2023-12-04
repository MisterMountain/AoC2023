#/bin/bash
# Check if a limit argument is provided, otherwise default to 5
LIMIT=${2:-5}

# read file - defaults to example - and replaces points with underscores.
A=($(tr '*.' X_ < "${1:-example}"))
# sets B to A, but with every single character as an underscore, and one underscore at the and the beginning
B=(_${A//?/_}_)
for i in "${A[@]}"; do 
  B+=(_${i}_)
done
B+=(${B[0]})
n=${#A} N=${#A[@]} NUMS=() GEARS=()
# Loop through the first N elements in array A and echo each element on a new line
for ((i = 0; i < LIMIT && i < ${#A[@]}; i++)); do
    echo "${A[i]} ${B[i]}" > /dev/null
done
declare -A STAR
for ((y=1; y<=N; ++y)); do # iterate over every row
    for ((x=1; x<=n; ++x)); do # iterate over every char
        [[ ${B[y]:x:1} != [0-9] ]] && continue # if char is not a digit skip
        i=1 num= 
        while [[ ${B[y]:x+i:1} == [0-9] ]]; do
          ((++i))
        done # 
        X=${B[y-1]:x-1:i+2}${B[y]:x-1:i+2}${B[y+1]:x-1:i+2}
        # part 1
        if ! [[ ${X} =~ ^[_0-9]*$ ]]; then
            NUMS+=(${B[y]:x:i})
        fi

        # part 2
        if [[ $X == *X* ]]; then
            Y=${X/X*}
            pos=$((x-1+${#Y}%(i+2))),$((y-1+${#Y}/(i+2)))
            if [[ -n ${STAR[$pos]} ]]; then
                GEARS+=(${STAR[$pos]}*${NUMS[-1]})
            else
                STAR[$pos]=${NUMS[-1]}
            fi
        fi
        ((x+=i))
    done
done
printf -v sum "+%s" "${NUMS[@]}"
echo "9A: $((sum))"
printf -v sum "+%s" "${GEARS[@]}"
echo "9B: $((sum))"