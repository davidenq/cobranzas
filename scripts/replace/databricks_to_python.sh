#!/bin/bash
cp ./src/notebooks ./src
while IFS=  read -r -d $'\0'; do
    PATH_FILE="$REPLY"
    PROJECT_ROOT=$(eval pwd)
    # DEF_LISTS=$(
    #     echo $(grep -r 'def ' ${PATH_FILE}) |\
    #     #sed "s/def //g" |\
    #     #sed "s/test_[a-zA-Z_]*//g" |\
    #     sed -re "s/\(\):/,/g" |\
    #     sed -re "s/\([a-zA-Z_].+\):/,/g" \
    #     )
    #     echo $DEF_LISTS
    #MAGICRUN="$(echo $(grep -rw ${PATH_FILE} -e 'MAGIC %run') | sed "s/# MAGIC %run \//from src.notebooks./g" | sed "s/\//./g") import ${DEF_LISTS:: -1} #REMOVE"
    #arr[${#arr[@]}]=$MAGICRUN
    #sed -i "1s/^/${MAGICRUN}\n/" $PATH_FILE
    MAGICRUN=($(grep -rw ${PATH_FILE} -e '# MAGIC*.*%run' | sed "s/# MAGIC*.*%run \// src\/notebooks\//g"))
    if [[ "${MAGICRUN}" ]]; then
        #echo $MAGICRUN
        for path in "${MAGICRUN[@]}"
        do
            #echo ${PROJECT_ROOT}/${path}.py
            DEF_LIST=$(
                grep -r 'def ' ${PROJECT_ROOT}/${path}.py | \
                sed "s/def //g" | \
                sed -re "s/\(\):/,/g" |\
                sed -re "s/\([a-zA-Z_].+\):/,/g" \
            )
            FROM=$(echo $path | sed "s/@/_/g" | sed "s/\./_/g" | sed "s/\//./g")
            echo $(echo from ${FROM} import ${DEF_LIST:: -1}) | sed 's/\n//g'
        done
        echo "================="
    fi
done < <(find ./src/notebooks -name "*.py" -print0)