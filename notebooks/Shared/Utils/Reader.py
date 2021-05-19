# Databricks notebook source
from pyspark.context import SparkContext
from pyspark.sql.session import SparkSession
sc = SparkContext.getOrCreate()
sc.setLogLevel('OFF')
spark = SparkSession(sc)

def read_csv_from_file(path: str):
  data = spark.read.csv(path,header=False)
  return data