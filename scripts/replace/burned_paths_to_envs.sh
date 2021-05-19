#!/bin/bash
PROJECT_ROOT=$(eval pwd)
MAIN_PATH=/src/main.py
echo ${PROJECT_ROOT}${MAIN_PATH}
BURNED_PATHS=($(grep -E '*.*_PATH.*' ${PROJECT_ROOT}${MAIN_PATH}))
for path in "${BURNED_PATHS[@]}"
do
    echo $path
done
#sed -i 's/_PATH*.*/sss/g' ./src/main.py