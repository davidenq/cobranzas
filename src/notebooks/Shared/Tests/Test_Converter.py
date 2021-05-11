# Databricks notebook source
# MAGIC %run /Shared/Utils/Converter

# COMMAND ----------

def test_dataframe_to_collection():
  actual = [[1,2,3], [2,3,4]]
  df = sc.parallelize(actual).toDF(("a", "b", "c"))
  expect = dataframe_to_collection(df)
  assert actual == expect  

test_dataframe_to_collection()