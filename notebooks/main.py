# Databricks notebook source
import mlflow
import mlflow.sklearn

# COMMAND ----------

# MAGIC %run /Shared/Utils/Reader

# COMMAND ----------

# MAGIC %run /Shared/Utils/Converter

# COMMAND ----------

# MAGIC  %run /Users/davip@live.com/PY_LinearRegression

# COMMAND ----------

def run(path_x_train, path_y_train, path_x_test, path_y_test, threshold):
  # load the train data and transform it from dataframew to python collection
  df_x_train = read_csv_from_file(path_x_train)
  X_train = dataframe_to_collection(df_x_train)
  
  df_y_train = read_csv_from_file(path_y_train)
  y_train = dataframe_to_collection(df_y_train)
  
  df_x_test = read_csv_from_file(path_x_test)
  X_test = dataframe_to_collection(df_x_test)
  
  df_y_test = read_csv_from_file(path_y_test)
  y_test = dataframe_to_collection(df_y_test)
  
  # train model
  train_model(X_train, y_train)
  # get predictions
  predictions = predictor(X_test)
  # log coefficients
  log_coefs()
  # log metrics
  m1,m2,m3 = log_metrics(y_test, predictions)
  if m3 < threshold:
    mlflow.sklearn.log_model(
        sk_model=model(),
        artifact_path="sklearn-model",
        registered_model_name="sk-learn-linear-regression"
    )
    print("Model saved in run %s" % mlflow.active_run().info.run_uuid)
  else:
    mlflow.sklearn.log_model(
      model(), 
      "sk-learn-linear-regression"
    )
    print("Experiment saved in run %s" % mlflow.active_run().info.run_uuid)

# COMMAND ----------

# main function
# new message
if __name__ == "__main__":
  X_TRAIN_PATH = '/data/training/input-v4.csv'
  Y_TRAIN_PATH = '/data/training/output-v4.csv'
  X_TEST_PATH = '/data/training/input-v5.csv'
  Y_TEST_PATH = '/data/training/output-v5.csv'
  THRESHOLD = 6.217e-13
  

  run(X_TRAIN_PATH, Y_TRAIN_PATH, X_TEST_PATH, Y_TEST_PATH, THRESHOLD)