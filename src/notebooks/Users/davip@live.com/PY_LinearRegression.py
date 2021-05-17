# Databricks notebook source
from sklearn.linear_model import LinearRegression
import mlflow.sklearn
mlflow.sklearn.autolog()

linearReg = LinearRegression(n_jobs=1)

# COMMAND ----------

def train_model(train_input, train_output):
  linearReg.fit(X=train_input, y=train_output)

# COMMAND ----------

def predictor(x_test):
  outcome = linearReg.predict(X=x_test)
  return int(outcome[0][0])