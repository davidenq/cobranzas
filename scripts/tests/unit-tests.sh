#!/bin/bash


# if [ -f .env ]
# then
#   export $(cat .env | sed 's/#.*//g' | xargs)
# fi


# add imports
while IFS=  read -r -d $'\0'; do
    PATH_FILE="$REPLY"
    DEF_LISTS=$(echo $(grep -r '^def test*' ${PATH_FILE}) | sed "s/def test_//g" | sed -re "s/\(\):/,/g")
    MAGICRUN="$(echo $(grep -rw ${PATH_FILE} -e 'MAGIC %run') | sed "s/# MAGIC %run \//from src.notebooks./g" | sed "s/\//./g") import ${DEF_LISTS:: -1} #REMOVE"
    #arr[${#arr[@]}]=$MAGICRUN
    sed -i "1s/^/${MAGICRUN}\n/" $PATH_FILE
done < <(find . -name "Test_*.py" -print0)

# activate environment with conda
source $(echo $(conda info --base))/etc/profile.d/conda.sh
conda activate $PROJECT_ENVIRONMENT --no-stack

# running unit tests
python -m pytest src/notebooks/Tests/*.py

# remove imports
# for value in "${arr[@]}"
# do
#     find ./src -type f -exec sed -i "s/$value//g" {} \;
# done

find ./src -type f -exec sed -i "/#REMOVE/d" {} \;
#sed '/REGULAR/d'