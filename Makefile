.PHONY: test
.ONESHELL:
SHELL=/bin/bash

-include .env

### commands for installing dependencies in order to prepare the environment
install-dependencies:
	@ pip install databricks-cli

### commands for Databricks
connect-with-databricks:
	@ echo $(DATABRICKS_TOKEN) > ./token
	@ databricks configure --token-file ./token --host $(DATABRICKS_HOST)
	@ cat ./token
	@ rm -rf ./token

update-file-dependencies:
	@ databricks libraries list --cluster-name $(CLUSTER_NAME) | grep "package" |  sed -e "s/\"//g" | awk '{print "\n  - "$$2}' >> conda.yml
	@ echo "$$(awk '!a[$$0]++' conda.yml)" > conda.yml
	@ databricks libraries list --cluster-name $(CLUSTER_NAME) | grep "package" |  sed -e "s/\"//g" | awk '{print $$2}' >> requirements.txt
	@ echo "$$(awk '!a[$$0]++' requirements.txt)" > requirements.txt

### commands for Conda
create-env:
	@ conda env remove --name $(PROJECT_ENVIRONMENT)
	@ awk -v envhash=$(PROJECT_ENVIRONMENT) '{gsub(/__NAME__/, envhash);print}' conda.yml > _temp.yml
	@ conda env create -f ./_temp.yml ; rm -rf _temp.yml

### commands for Testing
unit-test:
	@ python -m pytest ./src/Tests/Unit/*.py

copy-data-training:
	@ dbfs cp -r ./data dbfs:/data

run-on-local:
	@ $(#eval export MLFLOW_TRACKING_URI=$(AZURE_WASB_LINK))
	@ mlflow run . --backend local  \
	-P path_x_train=./data/training/input-v0.csv \
	-P path_y_train=./data/training/output-v0.csv \
	-P path_x_test=./data/training/input-v1.csv \
	-P path_y_test=./data/training/output-v1.csv \
	--no-conda

run-on-databricks:
	@ $(eval export MLFLOW_TRACKING_URI=databricks)
	@ mlflow run . --backend databricks --backend-config ./infra/databricks/cluster.json --experiment-id 3950676691218687 \
	-P path_x_train=/data/input-v0.csv \
	-P path_y_train=/data/output-v0.csv \
	-P path_x_test=/data/input-v1.csv \
	-P path_y_test=/data/output-v1.csv \
	--no-conda

run-on-kubernetes:
	@ mlflow run . --backend kubernetes --backend-config ./infra/databricks/cluster.json --no-conda


refactor-notebooks-to-python:
	@ ./scripts/replace/databricks_to_python.sh
	@ echo now run 'make refactor-burned-paths-to-args'

refactor-burned-paths-to-args:
	@ ./scripts/replace/burned_paths_to_envs.sh

run:
	@ $(eval ROOT_COBRANZAS_PATH=$(shell pwd)/data/training)
	@ python src/main.py \
	${ROOT_COBRANZAS_PATH}/input-v4.csv \
	${ROOT_COBRANZAS_PATH}/output-v4.csv \
	${ROOT_COBRANZAS_PATH}/input-v5.csv \
	${ROOT_COBRANZAS_PATH}/output-v5.csv


run-mlflow-server:

	@ $(eval export AZURE_STORAGE_CONNECTION_STRING=$(AZURE_STORAGE_CONNECTION_STRING))
	@ $(eval export AZURE_STORAGE_ACCESS_KEY=$(AZURE_STORAGE_ACCESS_KEY))
	mlflow server \
    # --backend-store-uri mysql://user:password@127.0.0.1:3306/mlflow-backend-store \
    --default-artifact-root wasbs://mlflow-storage@mlflowcobranzas.blob.core.windows.net/artifacts \
    --host 0.0.0.0

run-local:
	@ $(eval export MLFLOW_TRACKING_URI=$(MLFLOW_TRACKING_URI))
	@ $(eval export AZURE_STORAGE_CONNECTION_STRING=$(AZURE_STORAGE_CONNECTION_STRING))
	@ $(eval export AZURE_STORAGE_ACCESS_KEY=$(AZURE_STORAGE_ACCESS_KEY))
	@ echo $$MLFLOW_TRACKING_URI
	@ mlflow run . --no-conda

get-last-model:
	@ $(eval export AZURE_WASB_LINK=$(AZURE_WASB_LINK))
	@ $(eval export MODEL_NAME=$(MODEL_NAME))
	@ $(eval export MLFLOW_TRACKING_URI=$(MLFLOW_TRACKING_URI))
	@ $(eval export AZURE_STORAGE_CONNECTION_STRING=$(AZURE_STORAGE_CONNECTION_STRING))
	@ $(eval export AZURE_STORAGE_ACCESS_KEY=$(AZURE_STORAGE_ACCESS_KEY))
	./scripts/mlflow/get-latest-model.sh



