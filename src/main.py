import sys
from Users.daviplivecom.PY_Entrypoint import run

if __name__ == "__main__":
    path_x_train = sys.argv[1]
    path_y_train = sys.argv[2]
    path_x_test = sys.argv[3]
    path_y_test = sys.argv[4]
    run(path_x_train, path_y_train, path_x_test, path_y_test)