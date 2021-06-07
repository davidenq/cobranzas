import sys
import pandas as pd
import mlflow
logged_model = sys.argv[1]
data = sys.argv[2]


# Load model as a PyFuncModel.
loaded_model = mlflow.pyfunc.load_model(logged_model)

# Predict on a Pandas DataFrame.
outcome = loaded_model.predict(pd.DataFrame(data))

print(outcome)
