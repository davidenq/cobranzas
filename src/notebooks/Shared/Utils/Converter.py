# Databricks notebook source
def dataframe_to_collection(df):
  data = [list(map(int, dfc)) for dfc in df.collect()]
  return data