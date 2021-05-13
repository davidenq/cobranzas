#!/bin/bash
cat > ~/.databrickscfg  <<EOF 
[DEFAULT] 
host = ${DATABRICKS_HOST}
token = ${DATABRICKS_TOKEN} 
EOF