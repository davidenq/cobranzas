#!/bin/bash
while IFS=  read -r -d $'\0'; do
    PATH_FILE="$REPLY"
    PROJECT_ROOT=$(eval pwd)
    NOTEBOOK_FOLDER_PATH=$(echo $PATH_FILE | sed -r 's/\/[a-zA-Z_]*.py//g' | sed "s/@//g" | sed "s/\.//g" | sed "s/\/notebooks/\.\/src/g")
    mkdir -p $NOTEBOOK_FOLDER_PATH
    cp $PATH_FILE $NOTEBOOK_FOLDER_PATH

    MAGICRUN=($(grep -rw ${PATH_FILE} -e '# MAGIC*.*%run' | sed "s/# MAGIC*.*%run//g"))
    NEW_PATH=.$(echo $PATH_FILE  | sed "s/\.py//g"| sed "s/\.//g" | sed "s/@//g" | sed "s/notebooks/src/g").py  

    sed -i 's/#[ a-zA-Z0-9 -]*.*//g' $NEW_PATH
    sed -i '/^  $/d' $NEW_PATH
    sed -i '/^$/d' $NEW_PATH
    if [[ "${MAGICRUN}" ]]; then
        for path in "${MAGICRUN[@]}"
        do
            DEF_LIST=$(
                grep -r 'def ' ${PROJECT_ROOT}/notebooks/${path}.py | \
                sed "s/def //g" | \
                sed -re "s/\(\):/,/g" |\
                sed -re "s/\([a-zA-Z_].+\):/,/g" \
            )

            FROM=$(echo $path | sed "s/@//g" | sed "s/\.//g" | sed "s/\//./g")
            echo $path
            IMPORTS=$(echo $(echo from ${FROM:1} import ${DEF_LIST:: -1}) | sed 's/\n//g')
            
            sed -i "1s/^/${IMPORTS}\n/" $NEW_PATH
        done


        sed -i "1s/^/\
########################################################\n\
# IMPORTANT!                                           #\n\
# THIS CODE IS CREATED AUTOMATICALLY FROM NOTEBOOKS    #\n\
# If you add some code\, it will be delete in the next  #\n\
# push\/pull executions                                #\n\
# If you want to persist the information\, work on the #\n\
# corresponding notebook and push those changes        #\n\
# THIS CODE NOT DEPEND ON NOTEBOOK PRINCIPLES OR       #\n\
# MAGIC RULES TO IMPORT NOTEBOOKS\, INSTEAD, MAGIC     #\n\
# COMMANDS ARE REPLACE BY THE NATURALLY IMPORT PYTHON  #\n\
# LIBRARIES                                            #\n\
########################################################\n\
\n/" $NEW_PATH

    fi
done < <(find ./notebooks -name "*.py" -print0)


