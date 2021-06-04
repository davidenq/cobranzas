# Databricks notebook source
from sklearn.linear_model import LinearRegression
from sklearn import metrics
import mlflow
import mlflow.sklearn
import numpy as np
mlflow.sklearn.autolog()

linearReg = LinearRegression(n_jobs=1)

# COMMAND ----------

def model():
  return linearReg

# COMMAND ----------

def train_model(X_train, y_train):
  linearReg.fit(X=X_train, y=y_train)

# COMMAND ----------

def predictor(X_test):
  predictions = linearReg.predict(X=X_test)
  return predictions

# COMMAND ----------

# log coefs
def log_coefs():
  coef = linearReg.coef_[0]
  mlflow.log_metric("a", coef[0])
  mlflow.log_metric("b", coef[1])
  mlflow.log_metric("c", coef[2])
  
  return coef

# COMMAND ----------

def log_metrics(y_test, predictions):
  #capture metrics
  mae = metrics.mean_absolute_error(y_test, predictions)
  mse = metrics.mean_squared_error(y_test, predictions)
  rmse = np.sqrt(metrics.mean_squared_error(y_test, predictions))
  
  #log metrics
  mlflow.log_metric("MAE", mae)
  mlflow.log_metric("MSE", mse)
  mlflow.log_metric("RMSE", rmse)
    
  return mae, mse, rmse