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
            IMPORTS=$(echo $(echo from ${FROM:1} import ${DEF_LIST:: -1}) | sed 's/\n//g')
            
            sed -i "1s/^/${IMPORTS}\n/" $NEW_PATH
        done


        sed -i "1s/^/\
 ############################################################\n\
#                        IMPORTANT!                          #\n\
#     THIS CODE IS CREATED AUTOMATICALLY FROM NOTEBOOKS      #\n\
#                                                            #\n\
# You can modify any line of code to make some tests, even   #\n\
# you can push the changes to the repository but, it will    #\n\
# not persist since in the next push or pull execution,      #\n\
# automatically will be generated all the code having in     #\n\
# mind the original notebook code. This is because the work  #\n\
# made by Data Scientst will not be modify in any way.       #\n\
#                                                            #\n\
# If you want to persist the information, you should work    #\n\
# on thecorresponding notebook and push those changes from   #\n\
# the notebook.                                              #\n\
#                                                            #\n\
# This generated code not depend on notebooks principles in  #\n\
# any way (for instance,  magic rules to import notebooks).  #\n\
# Instead, magic command are replaces by the natural python  #\n\
# imports.                                                   #\n\
 ############################################################\n\
\n/" $NEW_PATH

    fi
done < <(find ./notebooks -name "*.py" -print0)


