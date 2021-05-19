# Databricks notebook source
# MAGIC %run /Shared/Utils/Reader

# COMMAND ----------

from pyspark.context import SparkContext
from pyspark.sql.session import SparkSession

sc = SparkContext.getOrCreate()
sc.setLogLevel('OFF')
spark = SparkSession(sc)

def test_read_csv_from_file():
  outcome = read_csv_from_file("dbfs:/data/training/input-v0.csv")
  print(outcome)

test_read_csv_from_file()