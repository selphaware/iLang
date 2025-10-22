# 🧩 iLang Modules with Separate ABIs — `x` (ML in Python) and `y` (DataFrame in Rust)

This note refines the design so **each language block is its *own module*** with a **C ABI surface**, and iLang orchestrates them together. We are **not** merging both code sets into one module `x`. Instead:

- **Module `x`**: Python (Seagress) trains & serves predictions — exported as a **C ABI** (e.g., `libx.a/.so` + `x.h`).
- **Module `y`**: Rust ingests large CSVs and exposes a DataFrame handle — exported as a **C ABI** (e.g., `liby.a/.so` + `y.h`).

iLang then composes them in the `.I` phase: load data with `y`, train/predict with `x`.

---

## 🧭 iLang Pseudocode (refined)

```ilang
begin lang: x, py;
    # Python / Seagress: define train/predict (exposed via C ABI)
    # Internally uses sklearn, exports m2cgen/ONNX as needed.
    # iLang compiles/exports to: x.h, libx.a/.so
end lang;

begin lang: y, rust;
    // Rust: high-performance CSV loader + DataFrame handle
    // Exposes a C ABI for DataFrame creation and column access.
    // iLang compiles/exports to: y.h, liby.a/.so
end lang;

# Integration script (conceptual)
y.DataFrame data;
data = y.read_csv("some_big_file.csv");

# (Optional) choose target & feature columns
x.train(data, target="sales", train_pct=80);
pred = x.predict([/* lag or feature vector */]);

print(pred);
```

**Key idea:** each module publishes a **C ABI** that iLang can call. The ABIs are stable, versioned, and language-agnostic.

---

## 🧱 C ABI Surfaces

### Module `x` — ML (Python → C ABI)

**Header (`x.h`):**

```c
#ifndef X_H
#define X_H
#ifdef __cplusplus
extern "C" {
#endif

#define X_ABI_VERSION 0x00010000  // 1.0.0
typedef struct x_ctx x_ctx;
typedef enum { X_OK=0, X_ERR=1, X_BADARG=2, X_UNSUPPORTED=3 } x_status;

// Create/destroy context (holds model, settings)
x_status x_create(x_ctx** out);
void     x_destroy(x_ctx* ctx);

// Train a model using rows from y.DataFrame (opaque handle from module y)
typedef void* y_df_handle;   // y exposes this as its public handle type
x_status x_train(x_ctx* ctx, y_df_handle df,
                 const char* target_col,
                 int train_pct);

// Predict using feature vector (caller-allocated buffers)
x_status x_predict(x_ctx* ctx,
                   const double* features, int n_features,
                   double* out, int out_len);  // out_len >= 1

unsigned int x_get_abi_version(void);

#ifdef __cplusplus
} // extern "C"
#endif
#endif // X_H
```

**Implementation notes:**
- Inside `x_train`, Python/Seagress path can export a trained estimator to **m2cgen C** or **ONNX**. The C ABI remains the same.
- If SVR/MLP are used and math functions are emitted, link with `-lm`.

---

### Module `y` — DataFrame (Rust → C ABI)

**Header (`y.h`):**

```c
#ifndef Y_H
#define Y_H
#ifdef __cplusplus
extern "C" {
#endif

#define Y_ABI_VERSION 0x00010000  // 1.0.0
typedef struct y_df y_df;         // opaque
typedef y_df* y_df_handle;

typedef enum { Y_OK=0, Y_ERR=1, Y_BADARG=2, Y_IO=3 } y_status;

// Load CSV as a DataFrame (Rust optimizations under the hood)
y_status y_read_csv(const char* path, y_df_handle* out_df);

// Query schema
int      y_ncols(y_df_handle df);
int      y_nrows(y_df_handle df);
y_status y_col_index(y_df_handle df, const char* name, int* out_idx);

// Column access (double view; returns pointer valid until DF is mutated/freed)
y_status y_col_as_f64(y_df_handle df, int col_idx, const double** out_ptr, int* out_len);

// Free
void     y_free(y_df_handle df);

unsigned int y_get_abi_version(void);

#ifdef __cplusplus
} // extern "C"
#endif
#endif // Y_H
```

**Implementation notes:**
- Rust exports `#[no_mangle] extern "C"` functions, compiled as `cdylib` or `staticlib`.
- For safety, keep `y_df` opaque and manage memory inside module `y`.

---

## 🔗 Orchestration Example (C/C++)

A tiny integration executable (built in `.I`) can look like this:

```c
// main_integrate.c
#include <stdio.h>
#include "x.h"
#include "y.h"

int main(void) {
    // Load data in Rust-backed module y
    y_df_handle df = NULL;
    if (y_read_csv("some_big_file.csv", &df) != Y_OK || !df) {
        fprintf(stderr, "Failed to read CSV\n");
        return 1;
    }
    printf("Loaded DF: rows=%d cols=%d\n", y_nrows(df), y_ncols(df));

    // Train in Python-backed module x (C ABI front)
    x_ctx* x = NULL;
    if (x_create(&x) != X_OK || !x) { fprintf(stderr, "x_create failed\n"); return 1; }
    if (x_train(x, (void*)df, "sales", 80) != X_OK) {
        fprintf(stderr, "x_train failed\n"); return 1;
    }

    // Predict
    double features[] = { /* lag/features consistent with training */ };
    double out[1];
    if (x_predict(x, features, (int)(sizeof(features)/sizeof(features[0])), out, 1) != X_OK) {
        fprintf(stderr, "x_predict failed\n"); return 1;
    }
    printf("Prediction: %.6f\n", out[0]);

    x_destroy(x);
    y_free(df);
    return 0;
}
```

> The **ABI handshake**: `x_train` accepts a `y_df_handle`. Module `x` uses `y.h` functions (e.g., `y_col_as_f64`) to pull arrays without copying, or iLang can pass data down via a small adapter layer.

---

## 🛠️ Build Outputs and Commands

Each module produces its own artifacts (platform naming may vary):

```
x/          y/
├─ x.h      ├─ y.h
├─ libx.a   ├─ liby.a
├─ libx.so  ├─ liby.so
└─ x.abi.json └─ y.abi.json
```

**Static link (Linux/MSYS2):**

```bash
# Build/link your integration app (ensure -lm if needed by x)
gcc -O3 main_integrate.c -L./x -L./y -lx -ly -o app -lm
```

**Shared link (Linux):**

```bash
gcc -O3 main_integrate.c -o app -Wl,-rpath,'$ORIGIN' -L./x -L./y -lx -ly -lm
```

**Windows (MSYS2/MinGW):**

```bash
gcc -O3 main_integrate.c -L./x -L./y -lx -ly -o app.exe -lm
```

> If `x` uses SVR/MLP math (`exp`, `tanh`, etc.), keep `-lm`. C++ builds can use `g++` similarly.

---

## 🧠 iLang Responsibilities

- **Case 1 (AI‑generated)**: call GPT to write `x.c/.h`, emit `x.abi.json`, compile to `libx.a/.so`.
- **Case 2 (user‑written)**: compile Rust/Python blocks to expose a C ABI and produce `y.h`, `liby.*`, and `y.abi.json`.
- **Register** both modules in the runtime so the integration step knows which header & library to include/link.
- **Validate** ABI versions at runtime (`x_get_abi_version`, `y_get_abi_version`).

---

## ✅ Benefits of Separate ABIs

- Clear separation of concerns (ML vs. data I/O).
- Hot‑swappable implementations (swap Rust `y` for a C++ `y` without touching `x`).
- No cross‑language entanglement; composition happens via **C ABI** only.
- Predictable performance & memory ownership semantics.

---

## ⚠️ Practical Notes

- Ensure both modules agree on **feature ordering** and **preprocessing** (documented in the ABI manifest).
- If `x` expects lagged features, either:
  - Have `x_train`/`x_predict` build lags internally given a target column; **or**
  - Have `y` expose column slicing so an adapter layer assembles the feature vector.
- Keep data transfers **zero‑copy** where possible (e.g., expose column views as `const double*`).

---

**Current status:** This design mirrors your intent precisely: **two independent modules** with **separate ABIs**, orchestrated by iLang at the integration layer.
