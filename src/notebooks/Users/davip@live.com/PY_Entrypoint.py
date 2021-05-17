# Databricks notebook source
# MAGIC %run /Shared/Utils/Converter

# COMMAND ----------

# MAGIC %run /Shared/Utils/Reader

# COMMAND ----------

# MAGIC  %run /Users/davip@live.com/PY_LinearRegression

# COMMAND ----------

PATH_X_DATA = '/data/training/input-v0.csv'
PATH_Y_DATA = '/data/training/output-v0.csv'

# COMMAND ----------

# load train input data
df_x_data = read_csv_from_file(PATH_X_DATA)
# transform from dataframe to python collection
x_data_collection = dataframe_to_collection(df_x_data)

# load train output data
df_y_data = read_csv_from_file(PATH_X_DATA)
# transform from dataframe to python collection
y_data_collection = dataframe_to_collection(df_y_data)

# load test data
df_test_data = read_csv_from_file(PATH_X_DATA)
# transform from dataframe to python collection
test_data_collection = dataframe_to_collection(df_test_data)

# COMMAND ----------

def run(data_test):
  train_model(x_data_collection, y_data_collection)
  return predictor(data_test)

# COMMAND ----------

test = [[419, 773, 185]]
outcome = run(test)
print(outcome)