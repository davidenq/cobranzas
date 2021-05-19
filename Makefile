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
	@ PROJECT_ENVIRONMENT=$(PROJECT_ENVIRONMENT) ./scripts/tests/unit-tests.sh

copy-data-training:
	@ dbfs cp -r ./data dbfs:/data

run-on-local:
	@ mlflow run . --backend local


run-on-databricks:
	@ $(eval export MLFLOW_TRACKING_URI=databricks)
	@ mlflow run . --backend databricks --backend-config ./infra/databricks/cluster.json --experiment-id 47629144257743
run-on-kubernetes:
	@ mlflow run . --backend kubernetes --backend-config ./infra/databricks/cluster.json