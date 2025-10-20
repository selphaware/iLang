# 🧩 Understanding the ABI Bridge — Seagress ↔ iLang Integration

## 📘 Overview

This document summarizes the current state of the **Seagress → iLang** integration and the learning progress around **Application Binary Interfaces (ABI)**.

The goal:  
> Build a unified system where AI-generated and ML-compiled code (from Python/scikit-learn) can be **compiled to C**, **linked via headers**, and **executed natively** — all interoperating within iLang’s `.F`, `.X`, and `.I` structure.

---

## 🧠 1. Concept Recap — What is an ABI?

**ABI (Application Binary Interface)** = *the binary-level “language” shared between compiled programs.*

It defines:
- How functions are named and found in compiled binaries (symbol names)
- How parameters and return values are passed (registers vs. stack)
- How data structures and memory layouts are organized

If two programs obey the same ABI, they can call each other directly — regardless of which language or compiler built them.

---

## ⚙️ 2. ABI in Practice — Seagress Example

When Seagress trains a regression model and exports it via `m2cgen`, it produces:

- `model_generated.c` → the implementation (compiled code)
- `model_generated.h` → the ABI definition (header file)
- `model_generated.o` → the object file (machine code)

**Header (ABI Declaration):**
```c
#ifndef MODEL_GENERATED_H
#define MODEL_GENERATED_H
#ifdef __cplusplus
extern "C" {
#endif

#define MODEL_N_FEATURES 12
double score(const double *input);

#ifdef __cplusplus
}
#endif
#endif
```

**Object File (ABI Implementation):**
```bash
gcc -O3 -c model_generated.c -o model_generated.o
```

**Link Both in Your App:**
```bash
gcc predictor.c model_generated.o -o predictor.exe
```

✅ At compile time:
- The header defines the ABI contract.
- The object file implements it.
- The linker connects both into one executable.

---

## 🧩 3. ABI as the “Contract”

| Layer | Role | Example |
|--------|------|---------|
| `.h` file | ABI Declaration | `double score(const double *input);` |
| `.o` file | ABI Implementation | Contains the compiled `score()` machine code |
| `.exe` | Linked Program | Combines all ABIs into one binary |
| `.so` / `.dll` | Shared Library | Dynamic ABI for use by other languages |

---

## 🔗 4. ABI in the iLang Pipeline

| Layer | Purpose | Relation to ABI |
|--------|----------|----------------|
| **.F** | Abstract function definition | Defines the interface conceptually |
| **.X** | Generated code (C, Python, JS, etc.) | Compiles to `.o` using the declared ABI |
| **.I** | Integrated binary or orchestrator | Links all `.o` files through shared headers |

---

## ⚡ 5. Seagress and iLang Synergy

| Component | Description |
|------------|--------------|
| **Seagress** | Builds regression/forecasting models using scikit-learn and exports them as C code |
| **ABI (model_generated.h)** | Acts as the handshake between ML model and native C execution |
| **iLang** | Generates and compiles multi-language code that can directly call the model through the ABI |
| **Result** | Fast, portable AI-generated + ML-compiled executables |

---

## 🧱 6. Example Workflow

```bash
# 1. Run Seagress to train + export model
python seagress.py

# 2. Compile model and app
gcc -O3 -c model_generated.c -o model_generated.o
gcc -O3 predictor.c model_generated.o -o predictor.exe

# 3. Run the executable
./predictor.exe 101.2 102.0 99.8 100.5 101.1 100.9 101.7 102.2 101.8 102.5 102.0 101.6
```

---

## 🧭 7. Key Takeaways

- The **ABI** is the *binary handshake* that allows Python-generated ML code to run inside C or C++ natively.  
- The **`.h` file** is the *declaration* of the ABI (the promise).  
- The **`.o` file** is the *implementation* of that ABI (the fulfillment).  
- Together, they form the bridge connecting Seagress models with iLang’s C-level execution environment.

---

**Current Status:**  
✅ Seagress exports fully functional `.c` + `.h` models  
✅ Compilation to `.o` and `.exe` verified  
✅ ABI understanding achieved and documented  
🚧 Next: automate `.I` integration for model linking inside iLang

---

*© 2025 Selphaware / Usman Ahmad — Seagress & iLang Research Branch*
