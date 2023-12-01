#!/bin/bash

while read line
do
  [ -z "$line" ] && break
  CURRENTLINE=""
  linewithspaces=$(echo "$line" | fold -w 1)
  for char in ${linewithspaces} ; do
    CURRENTLINE="$CURRENTLINE$char"
    CURRENTLINE=$(echo "$CURRENTLINE" | sed -e 's/one/1ne/;s/two/2wo/;s/three/3hree/;s/four/4our/;s/five/5ive/;s/six/6ix/;s/seven/7even/;s/eight/8ight/;s/nine/9ine/')
  done
  result1=$(echo $line | tr -d '/a-z,A-Z/' | sed -E 's/([0-9])$/\1\1/g; s/([0-9])[0-9]+([0-9])/\1\2/g')
  result2=$(echo $CURRENTLINE | tr -d '/a-z,A-Z/' | sed -E 's/([0-9])$/\1\1/g; s/([0-9])[0-9]+([0-9])/\1\2/g')

  cumresult1=$((cumresult1 + result1))
  cumresult2=$((cumresult2 + result2))

done
echo $cumresult1, $cumresult2
