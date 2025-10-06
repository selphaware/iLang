<p align="center">
  <img src="logo.png" alt="I Programming Language Logo" width="120" />
</p>

<h1 align="center">🧠 i (I) Programming Language, iLang</h1>

<p align="center">
  <b>AI-driven, language-agnostic code synthesis framework for exploratory and research use</b><br/>
  <sub>Generate • Integrate • Orchestrate • Execute</sub>
</p>

---

## 🔍 Overview

**I Programming Language** is an experimental framework for **AI-driven software creation**.
It generates, integrates, and orchestrates code across multiple programming languages using large language models (LLMs).
The goal is to enable **exploratory and research use** in **cross-language code synthesis**, where hybrid, language-agnostic scripts are created and executed seamlessly.

---

## ⚙️ Core Workflow

| Function | Purpose |
|-----------|----------|
| **C()** | Create — Generate a function in a chosen language via LLM |
| **E()** | Execute — Run the generated function in a sandboxed interpreter |
| **P()** | (Planned) Pipeline — Compose multiple generated functions |

---

### 🧩 Example

```python
# Create a simple function
myfunc = C(
    "Python",
    "3.13",
    "return the square of the input integer",
    int,
    [int]
)

# Execute it
result = E(myfunc, [3])
# -> 9
```

---

## 🧠 Under the Hood

Each `C()` call:
1. Builds a structured LLM prompt (e.g., “You are an expert Python developer”).
2. Generates code, dependencies, and unit tests.
3. Performs static and sandboxed validation.
4. Produces a **GeneratedFunction** object with:
   - Source code
   - Interpreter metadata
   - Provenance (model, prompt hash, dependencies)

Each `E()` call:
- Validates input/output schemas.
- Runs in an isolated, resource-limited environment.
- Returns structured results and execution logs.

---

## 🧱 Function Specification

```txt
FunctionSpec:
  lang: "python" | "c" | "javascript" | ...
  version: "3.13" | "17" | "20" | ...
  description: string
  result_type: Schema
  input_types: Schema[]
  packages?: string[]
  constraints?: { time_ms, memory_mb, net_access: false }
```

---

## 🧪 Example: ML Function Generation

```python
train_model = C(
    "Python",
    "3.13",
    "build a linear regression model from input DataFrame and target column, "
    "with random search hyperparameter optimization",
    "sklearn.linear_model.LinearRegression",
    ["pd.DataFrame", "str", "float", "float"]
)

model = E(train_model, [df, "target", 0.8, 0.2])
```

---

## 🧩 Roadmap

| Milestone | Goal |
|------------|------|
| **M0** | Implement Python-only `C` and `E` with sandboxed execution |
| **M1** | Add C language integration and Python↔C interoperability |
| **M2** | Add JavaScript language integration and Python↔JavaScript interoperability |
| **M3** | Introduce pipeline composition (`P`) and cross-language stitching |
| **M4** | Policy layer: dependency allowlists, no-network mode |
| **M5** | Research layer: self-repair, prompt variants, reproducibility |

---

## 🔐 Safety & Isolation

All code runs in a **secure sandbox** (containerized or WASM-based).
- 🚫 No default network access
- ⏱️ Time and memory limits
- 📦 Dependency pinning
- 🧾 Provenance tracking (prompt, model, deps, hash)

---

## 🧭 Vision

> “Describe what you want — I will build it.”

**I Programming Language** aims to:
- Bridge human intent and machine execution
- Enable AI-native programming paradigms
- Explore reproducible, explainable AI code generation
- Serve as a foundation for **self-constructing software systems**

---

## 🧩 Author
**Usman Ahmad** <span style="color:limegreen">Selphaware</span>

---

<p align="center">
  <sub>© 2025 I Programming Language — Intelligent Language for AI-driven Software Creation</sub>
</p>
