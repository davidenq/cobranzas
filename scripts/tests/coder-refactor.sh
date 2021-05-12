#!/bin/sh

arr=()
while IFS=  read -r -d $'\0'; do
    PATH_FILE="$REPLY"
    DEF_LISTS=$(echo $(grep -r '^def test*' ${PATH_FILE}) | sed "s/def test_//g" | sed -re "s/\(\):/,/g")
    MAGICRUN="$(echo $(grep -rw ${PATH_FILE} -e 'MAGIC %run') | sed "s/# MAGIC %run \//from src.notebooks./g" | sed "s/\//./g") import ${DEF_LISTS:: -1}"
    arr[${#arr[@]}]=$MAGICRUN
    sed -i "1s/^/${MAGICRUN}\n/" $PATH_FILE
done < <(find . -name "Test_*.py" -print0)
git chekcout -- .

#for value in "${arr[@]}"
#do
#     echo $value
#sdone