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

if __name__ == "__main__":
  PATH_X_TRAIN = '/data/training/input-v0.csv'
  PATH_Y_TRAIN = '/data/training/output-v0.csv'
  PATH_X_TEST = '/data/training/input-v1.csv'
  PATH_Y_TEST = '/data/training/output-v1.csv'
  
  run(PATH_X_TRAIN, PATH_Y_TRAIN, PATH_X_TEST, PATH_Y_TEST)