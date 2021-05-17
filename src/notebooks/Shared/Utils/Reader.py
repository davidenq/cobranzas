# Databricks notebook source
def read_csv_from_file(path: str):
  data = spark.read.csv(path,header=False)
  return data