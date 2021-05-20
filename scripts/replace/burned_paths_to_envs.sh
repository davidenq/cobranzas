#!/bin/bash
PROJECT_ROOT=$(eval pwd)
MAIN_PATH=/src/main.py
BURNED_PATHS=$(grep -rw ${PROJECT_ROOT}${MAIN_PATH} -e '[a-zA-Z_].*_PATH*.*=')

ARRAY_BURNED_PATHS=( $(echo ${BURNED_PATHS} | sed "s/ = /=/g"))
index=1
for i in "${!ARRAY_BURNED_PATHS[@]}"
do
    BURNED_PATH=$(echo ${ARRAY_BURNED_PATHS[i]} | sed "s/=.*/ = /g")
    echo $BURNED_PATH
    index=$(($i+1))
    sed -i "s/${BURNED_PATH}.*/${BURNED_PATH}sys.argv[${index}]/g" ./src/main.py
done

sed -i "1s/^/import sys\n/" ${PROJECT_ROOT}${MAIN_PATH}
