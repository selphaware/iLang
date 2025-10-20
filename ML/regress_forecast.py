# regress_forecast.py
import sys, math
import pandas as pd
import numpy as np

from sklearn.linear_model import LinearRegression, Ridge, Lasso
from sklearn.ensemble import RandomForestRegressor, GradientBoostingRegressor
from sklearn.svm import SVR
from sklearn.neural_network import MLPRegressor
from sklearn.metrics import mean_absolute_error, mean_squared_error, r2_score

def prompt(msg, cast=str, default=None, choices=None):
    while True:
        raw = input(f"{msg}" + (f" [{default}]" if default is not None else "") + ": ").strip()
        if not raw and default is not None:
            return default
        try:
            val = cast(raw)
            if choices and val not in choices:
                print(f"Choose one of: {choices}")
                continue
            return val
        except Exception:
            print(f"Invalid input; expected {cast.__name__}")

def load_csv(path):
    df = pd.read_csv(path)
    # Try to set a DatetimeIndex if there is an obvious date column
    for cand in ["date","datetime","timestamp","time"]:
        if cand in df.columns:
            try:
                df[cand] = pd.to_datetime(df[cand])
                df = df.set_index(cand).sort_index()
                break
            except Exception:
                pass
    return df

def make_lagged(df: pd.DataFrame, target: str, n_lags: int):
    if target not in df.columns:
        raise ValueError(f"Target '{target}' not found. Available: {list(df.columns)}")
    y = df[target].astype(float).copy()
    X = pd.DataFrame(index=df.index)
    for k in range(1, n_lags+1):
        X[f"{target}_lag{k}"] = y.shift(k)
    # drop initial rows with NaNs due to shifting
    valid = X.dropna().index
    X = X.loc[valid]
    y = y.loc[valid]
    return X, y

def split_time(X: pd.DataFrame, y: pd.Series, train_pct: float):
    n = len(X)
    n_train = max(1, int(math.floor(n * train_pct / 100.0)))
    X_train, X_test = X.iloc[:n_train], X.iloc[n_train:]
    y_train, y_test = y.iloc[:n_train], y.iloc[n_train:]
    if len(X_test)==0:
        raise ValueError("Test split produced 0 rows; lower train % or provide more data.")
    return X_train, X_test, y_train, y_test

def choose_model(code: str):
    code = code.lower()
    if code == "lr":   return "LinearRegression", LinearRegression()
    if code == "ridge":return "Ridge", Ridge(alpha=1.0)
    if code == "lasso":return "Lasso", Lasso(alpha=0.001, max_iter=10000)
    if code == "rf":   return "RandomForestRegressor", RandomForestRegressor(n_estimators=300, random_state=42)
    if code == "gbr":  return "GradientBoostingRegressor", GradientBoostingRegressor(random_state=42)
    if code == "svr":  return "SVR", SVR(C=10.0, epsilon=0.1, kernel="rbf")
    if code == "mlp":  return "MLPRegressor", MLPRegressor(hidden_layer_sizes=(128,64), max_iter=500, random_state=42)
    raise ValueError("Unknown model code")

def evaluate(y_true, y_pred):
    mae = mean_absolute_error(y_true, y_pred)
    rmse = math.sqrt(mean_squared_error(y_true, y_pred))
    r2 = r2_score(y_true, y_pred)
    return mae, rmse, r2

def recursive_forecast(model, last_values: np.ndarray, steps: int):
    """
    last_values: 1D array of length n_lags (ordered oldest..newest)
    Returns array of length 'steps' with forecasts produced recursively.
    """
    history = list(last_values.astype(float))
    preds = []
    for _ in range(steps):
        # build feature vector from most recent n_lags values
        x = np.array(history[-len(last_values):], dtype=float).reshape(1, -1)
        yhat = float(model.predict(x)[0])
        preds.append(yhat)
        history.append(yhat)
    return np.array(preds, dtype=float)

def try_export_onnx(model_name, model, n_lags):
    ans = input("Export model to ONNX for C-inference later? [y/N]: ").strip().lower()
    if ans != "y":
        return
    try:
        from skl2onnx import convert_sklearn
        from skl2onnx.common.data_types import FloatTensorType
        initial_types = [("input", FloatTensorType([None, n_lags]))]
        onx = convert_sklearn(model, initial_types=initial_types, target_opset=13)
        with open("model.onnx", "wb") as f:
            f.write(onx.SerializeToString())
        print("Saved ONNX to model.onnx")
        print("Next: use ONNX Runtime C API to run inference from C/C++.")
    except Exception as e:
        print(f"[ONNX export failed] {e}\nTip: pip install skl2onnx onnx onnxruntime")

def try_export_m2cgen(model_name, model):
    # Works best for linear/tree models; not for SVR/MLP reliably.
    ans = input("Generate C++ code with m2cgen (where supported)? [y/N]: ").strip().lower()
    if ans != "y":
        return
    try:
        import m2cgen as m2c
        cpp_code = m2c.export_to_c(model)  # C code (C89-style); compiles as C/C++
        with open("model_generated.c", "w", encoding="utf-8") as f:
            f.write(cpp_code)
        print("Wrote model_generated.c")
        print("Compile example:\n  gcc -O3 -c model_generated.c -o model_generated.o\n(then link into your app)")
    except Exception as e:
        print(f"[m2cgen export failed] {e}\nTip: pip install m2cgen")

def main():
    print("=== Time-series Regression Forecaster (sklearn) ===")
    csv_path   = prompt("Enter CSV filename to read")
    df = load_csv(csv_path)
    print(f"Columns: {list(df.columns)}")
    target     = prompt("Enter target column name")
    train_pct  = prompt("Enter train % (e.g., 80)", float, 80.0)
    n_lags     = prompt("Enter number of lags (e.g., 12)", int, 12)
    steps_ahead= prompt("Forecast how many steps ahead (future)?", int, 12)

    print("Choose a regressor:")
    print("  lr   = LinearRegression")
    print("  ridge= Ridge")
    print("  lasso= Lasso")
    print("  rf   = RandomForestRegressor")
    print("  gbr  = GradientBoostingRegressor")
    print("  svr  = SVR (rbf)")
    print("  mlp  = MLPRegressor")
    model_code = prompt("Enter model code", str, "rf")
    model_name, model = choose_model(model_code)

    X, y = make_lagged(df, target, n_lags)
    X_train, X_test, y_train, y_test = split_time(X, y, train_pct)

    model.fit(X_train.values, y_train.values)
    y_pred = model.predict(X_test.values)

    mae, rmse, r2 = evaluate(y_test.values, y_pred)
    print("\n=== Evaluation on test set ===")
    print(f"Model: {model_name}")
    print(f"MAE  : {mae:.6f}")
    print(f"RMSE : {rmse:.6f}")
    print(f"R^2  : {r2:.6f}")

    # Save backtest predictions
    out_test = pd.DataFrame({
        "index": X_test.index.astype(str),
        "y_true": y_test.values,
        "y_pred": y_pred
    })
    out_test.to_csv("predictions_test.csv", index=False)
    print("Saved test predictions -> predictions_test.csv")

    # Future forecast (X steps beyond end)
    last_window = y.values[-n_lags:]  # last n_lags actual values
    future = recursive_forecast(model, last_window, steps_ahead)
    out_future = pd.DataFrame({"step": np.arange(1, steps_ahead+1), "y_forecast": future})
    out_future.to_csv("forecast_future.csv", index=False)
    print(f"Saved {steps_ahead}-step future forecast -> forecast_future.csv")

    # Optional exports for C/C++ integration
    try_export_onnx(model_name, model, n_lags)
    try_export_m2cgen(model_name, model)

if __name__ == "__main__":
    try:
        main()
    except Exception as e:
        print(f"[error] {e}", file=sys.stderr)
        sys.exit(1)
