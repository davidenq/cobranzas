# Databricks notebook source
# MAGIC %run /Shared/Utils/Converter

# COMMAND ----------

# MAGIC %run /Shared/Utils/Reader

# COMMAND ----------

# MAGIC  %run /Users/davip@live.com/PY_LinearRegression

# COMMAND ----------

def run(path_x_data, path_y_data, data_test):
  # load the train data and transform it from dataframew to python collection
  df_x_data = read_csv_from_file(path_x_data)
  x_data_collection = dataframe_to_collection(df_x_data)
  df_y_data = read_csv_from_file(path_y_data)
  y_data_collection = dataframe_to_collection(df_y_data)
  
  # train model
  train_model(x_data_collection, y_data_collection)
  return predictor(data_test)

# COMMAND ----------

PATH_X_DATA = '/data/training/input-v0.csv'
PATH_Y_DATA = '/data/training/output-v0.csv'
test = [[419, 773, 185]]

outcome = run(x_data_collection, y_data_collectiontest)
print(outcome)