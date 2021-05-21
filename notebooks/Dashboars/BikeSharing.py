# Databricks notebook source
# For this example, we use the bike sharing dataset available on `dbfs`.
df = spark.read.format("csv").option("inferSchema", "true").option("header", "true").load("dbfs:/FileStore/tables/day.csv")

df.registerTempTable("bikeshare")

# COMMAND ----------

# MAGIC %md 
# MAGIC ### Biking Conditions Across the Seasons

# COMMAND ----------

display(spark.sql("SELECT season, MAX(temp) as temperature, MAX(hum) as humidity, MAX(windspeed) as windspeed FROM bikeshare GROUP BY season ORDER BY SEASON"))


# COMMAND ----------

# MAGIC %md
# MAGIC ### Average Biking Conditions

# COMMAND ----------

display(spark.sql("SELECT mnth as month, AVG(temp) as temperature, AVG(hum) as humidity, AVG(windspeed) as windspeed FROM bikeshare GROUP BY month ORDER BY month"))

# COMMAND ----------

# MAGIC %md
# MAGIC #### Extreme Biking Conditions

# COMMAND ----------

# MAGIC %sql SELECT mnth as month, MAX(temp) as max_temperature, MAX(hum) as max_humidity, MAX(windspeed) as max_windspeed FROM bikeshare GROUP BY mnth ORDER BY mnth