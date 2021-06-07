#!/bin/bash

echo $MLFLOW_TRACKING_URI

EXPERIMENT_ID=$(mlflow experiments list | tail -1 | awk '{print $1}')
RUN_ID=$(mlflow runs list --experiment-id $EXPERIMENT_ID | head -n3 | tail -n1 | awk '{print $4}')
echo $EXPERIMENT_ID
echo $RUN_ID
ARTIFACT_PATH="${AZURE_WASB_LINK}/$EXPERIMENT_ID/$RUN_ID/${MODEL_NAME}"
echo $ARTIFACT_PATH
#mlflow artifacts list --run-id $RUN_ID --artifact-path diabetes
#ARTIFACT_PATH=$(mlflow artifacts download --run-id $RUN_ID --artifact-path diabetes)

python ./artifacts/predict.py $ARTIFACT_PATH