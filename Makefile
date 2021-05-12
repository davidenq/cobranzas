.PHONY: test
.ONESHELL:
SHELL=/bin/bash

include .env
### commands for Conda
create-env:
	@ conda env remove --name $(PROJECT_ENVIRONMENT)
	@ awk -v envhash=$(PROJECT_ENVIRONMENT) '{gsub(/__NAME__/, envhash);print}' conda.yml > _temp.yml
	@ conda env create -f ./_temp.yml ; rm -rf _temp.yml

### commands for Databricks
connect-with-databricks:
	@ echo $(DATABRICKS_TOKEN) > token.txt
	@ echo databricks configure --token-file ./token --host $(DATABRICKS_HOST)
	@ # rm -rf token.txt
update-file-dependencies:
	@ databricks libraries list --cluster-name $(CLUSTER_NAME) | grep "package" |  sed -e "s/\"//g" | awk '{print "\n  - "$$2}' >> conda.yml
	@ echo "$$(awk '!a[$$0]++' conda.yml)" > conda.yml

### commands for Testing
unit-test:
	@ source $$CONDA_PREFIX/etc/profile.d/conda.sh
	@ conda activate $(PROJECT_ENVIRONMENT) --no-stack
	@ pytest src/notebooks/Shared/Utils/*.py

ut:
	@ ./scripts/tests/coder-refactor.sh
	@ source $$CONDA_PREFIX/etc/profile.d/conda.sh
	@ conda activate $(PROJECT_ENVIRONMENT) --no-stack
	@ conda env list
	@ python -m pytest src/notebooks/Shared/Tests/*.py
