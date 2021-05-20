# Databricks notebook source
# MAGIC %run /Shared/Utils/Reader

# COMMAND ----------

# MAGIC %run /Shared/Utils/Converter

# COMMAND ----------

# MAGIC  %run /Users/davip@live.com/PY_LinearRegression

# COMMAND ----------

def run(path_x_train, path_y_train, path_x_test, path_y_test):
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
  log_metrics(y_test, predictions)
  # log model
  log_model()

# COMMAND ----------

# main function
# new message
if __name__ == "__main__":
  X_TRAIN_PATH = '/data/training/input-v0.csv'
  Y_TRAIN_PATH = '/data/training/output-v0.csv'
  X_TEST_PATH = '/data/training/input-v1.csv'
  Y_TEST_PATH = '/data/training/output-v1.csv'

  run(X_TRAIN_PATH, Y_TRAIN_PATH, X_TEST_PATH, Y_TEST_PATH)