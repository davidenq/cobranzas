# Databricks notebook source
from pyspark.context import SparkContext
from pyspark.sql.session import SparkSession

sc = SparkContext.getOrCreate()
sc.setLogLevel('OFF')
spark = SparkSession(sc)

def dataframe_to_collection(df):
  data = [list(map(int, dfc)) for dfc in df.collect()]
  return data

# COMMAND ----------

def test_dataframe_to_collection():
  actual = [[1,2,3], [2,3,4]]
  df = sc.parallelize(actual).toDF(("a", "b", "c"))
  expect = dataframe_to_collection(df)
  
  assert actual == expect  