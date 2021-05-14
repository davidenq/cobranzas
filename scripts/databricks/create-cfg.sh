#!/bin/bash
echo $DATABRICKS_HOST
echo ${{env.DATABRICKS_HOST}}
echo ${DATABRICKS_HOST}
cat > ~/.databrickscfg  <<EOF 
[DEFAULT] 
host = ${DATABRICKS_HOST}
token = ${DATABRICKS_TOKEN} 
EOF