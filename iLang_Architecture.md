# iLang Architecture

> How `C()` drives GPT-5 codegen with strict instructions, how artifacts are laid out under `.X/`, compiled to **C/ASM**, and linked into a final **C** program. Also: a proposal for cross-language datatypes (e.g., a `pd.DataFrame`-like type) defined in C.

---

## 1. Design Goals

- **Deterministic generation**: code-only outputs; no prose.
- **Reproducible builds**: content-addressed artifacts, explicit toolchains, pinned flags.
- **Language-agnostic→C**: treat **C** as the interchange layer; optional ASM for transparency/optimization.
- **Strict ABI & datatypes**: interoperable C structs for primitives, arrays, and DataFrame-like tables.
- **Secure-by-default**: sandboxed validation/build; no network during generation, tests, or linking.

Non-goals (for now): direct multi-runtime dispatch at execution time; we compile down to C/ASM first.

---

## 2. End-to-End Pipeline

```
   .F (definitions)         GPT-5 Synthesis             Materialization            Build to C/ASM                Integration (.I)             Final
┌───────────────────┐   ┌───────────────────────┐   ┌────────────────────────┐   ┌─────────────────────────┐   ┌────────────────────────┐   ┌──────────────┐
│ f1, f2, ... via   │→  │ C(): strict sys inst. │→  │ .X/: code + shims +    │→  │ clang/gcc → .o / .s     │→  │ include/link in C main │→  │ executable    │
│ C(lang,...)       │   │ + JSON envelope only  │   │ tests + build.json     │   │ (optionally shared lib) │   │ (headers + objects)    │   │ (C binary)   │
└───────────────────┘   └───────────────────────┘   └────────────────────────┘   └─────────────────────────┘   └────────────────────────┘   └──────────────┘
```

---

## 3. `C()` Generation Contract

`C(lang, version, description, result_type, input_types, packages?, constraints?)` MUST yield a valid **artifact bundle**:

**Inputs**
- `lang`: e.g. `"Python" | "C++" | "JavaScript"`
- `version`: e.g. `"3.13" | "20"`
- `description`: precise function intent
- `result_type`, `input_types`: limited to supported C ABI types (see §7)
- `packages` (optional): minimal dependency hints
- `constraints` (optional): `{ time_ms, memory_mb, net_access: false }`

**Outputs (high level)**
- Source file(s) in the chosen language.
- **C shim** (header + implementation) that exposes a stable C ABI.
- Minimal tests for the source language and/or the shim.
- `build.json` describing compilation steps to C/ASM/objects.
- `manifest.json` with provenance (model id, prompt hash, content hashes, toolchain, flags).

---

## 4. GPT‑5 Output Policy — Model Emits *All* Artifacts

**Principle:** The model (GPT‑5) must emit **every artifact** required to build and integrate a function: source code, C shims (headers + impl), tests, build recipe, and provenance. The runner only validates and materializes; it does **not** invent files.

### 4.1 System Instruction (strict)
- Output **code and machine‑readable metadata only** — no prose or commentary.
- Emit a **single JSON envelope** as the entire response.
- Every file must appear as a `files[]` entry with **`path`**, **`language`**, and **`body`** (string).
- Conform to the **C ABI** and **signature** declared in the envelope.
- No network usage; no filesystem I/O beyond function scope; no randomness unless seeded and recorded.
- Prefer portable stdlib usage; avoid OS‑specific calls.
- Provide **deterministic minimal tests** for the generated function (and/or shim).

### 4.2 File/Path Rules
- Paths are **relative** and rooted to the function’s subfolder under `.X/<func>/`.
- C shim files must end with `*_shim.h` and `*_shim.c`.
- Test files live under `tests/`, e.g., `tests/test_<name>.<ext>`.
- Allowed `language` values include: `"c"`, `"cpp"`, `"python"`, `"javascript"`, `"json"`, `"make"`, `"bash"` (others by policy).
- `body` is UTF‑8 text. If binary is unavoidable, base64 encode and set `"encoding": "base64"`.

### 4.3 Required Envelope Schema
```json
{
  "version": "1",
  "signature": {
    "name": "f1_add",
    "result": "int32",
    "inputs": ["int32", "int32"]
  },
  "abi": "c",
  "build": {
    "toolchain": "clang",
    "std": "c17",
    "flags": ["-O2", "-Wall", "-Werror"],
    "targets": [
      {"type": "obj", "inputs": ["example.f1_shim.c"], "output": "example.f1_shim.o"},
      {"type": "asm", "inputs": ["example.f1_shim.c"], "output": "example.f1_shim.s"}
    ]
  },
  "files": [
    {"path": "example.f1.py",       "language": "python", "body": "<python code>"},
    {"path": "example.f1_shim.h",   "language": "c",      "body": "<c header exposing ilang_f1_add>"},
    {"path": "example.f1_shim.c",   "language": "c",      "body": "<c shim implementation>"},
    {"path": "tests/test_f1.py",    "language": "python", "body": "<unit tests for behavior>"},
    {"path": "manifest.json",       "language": "json",   "body": "{ \"model\": \"gpt-5\", \"deps\": [] }"},
    {"path": "build.json",          "language": "json",   "body": "{ \"toolchain\": \"clang\", \"std\": \"c17\" }"}
  ],
  "provenance": {
    "model": "gpt-5",
    "prompt_hash": "…",
    "inputs_hash": "…",
    "created_utc": "2025-10-07T09:00:00Z",
    "deps": []
  }
}
```

### 4.4 Validation Expectations
- The runner **parses** the JSON; rejects on any schema violation or extra prose.
- Files are written into `.X/<func>/...` exactly as specified.
- Static checks + dry‑run compile for `*_shim.c` and header conformance.
- Tests are run in sandboxed interpreters (e.g., Python for `tests/test_f1.py`), with deterministic seeds recorded in `manifest.json` if applicable.

### 4.5 Example (concise, placeholders)
```json
{
  "version": "1",
  "signature": {"name": "f2_square", "result": "int32", "inputs": ["int32"]},
  "abi": "c",
  "build": {"toolchain": "clang", "std": "c17", "flags": ["-O2"]},
  "files": [
    {"path": "example.f2.cpp",     "language": "cpp", "body": "<c++ reference impl>"},
    {"path": "example.f2_shim.h",  "language": "c",   "body": "<extern C header>"},
    {"path": "example.f2_shim.c",  "language": "c",   "body": "<c shim calling/ref impl>"},
    {"path": "tests/test_f2.cpp",  "language": "cpp", "body": "<unit test for square>"}
  ],
  "provenance": {"model": "gpt-5", "prompt_hash": "…", "deps": []}
}
```

> **Result:** GPT‑5 produces **all** scripts, shims, tests, and build recipes — nothing is inferred by the runner. The runner only validates, compiles, and links.
## 5. Validation Before Build

1. **Schema parse** (JSON).
2. **Static analysis/format** where available (e.g. `clang-format`, `ruff`).
3. **Unit tests** for source language (sandboxed).
4. **Dry-run compile** of C shim (headers, symbols, sizes).
5. **Signature/ABI check** vs. declared `signature` in the envelope.
6. **Hash & record** → `.X/<func>/manifest.json`.

Failures are logged; invalid artifacts are not integrated.

---

## 6. Materialization in `.X/`

Per `.F` function `fN`, we create a subdir:

```
example.X/
  f1/
    example.f1.py
    example.f1_shim.h
    example.f1_shim.c
    tests/test_example_f1.py
    build.json
    manifest.json
  f2/
    example.f2.cpp
    example.f2_shim.h
    example.f2_shim.c
    tests/test_example_f2.cpp
    build.json
    manifest.json
```

**Naming**
- Headers/impls end with `_shim.h` / `_shim.c`.
- Exported symbols use a stable prefix, e.g. `ilang_`.
- Paths are deterministic (hashable from inputs) to enable caching and repro.

---

## 7. C ABI & Cross-Language Datatypes

We define a compact, portable ABI with clear ownership rules.

### 7.1 Primitives

```c
#include <stdint.h>
typedef int32_t  i32;
typedef int64_t  i64;
typedef float    f32;
typedef double   f64;

typedef struct { const char *ptr; uint64_t len; } ilang_str;    // UTF-8 view
typedef struct { uint8_t *ptr;  uint64_t len; } ilang_bytes;
```

### 7.2 Arrays & Dynamic Buffers

```c
typedef enum { IL_I32, IL_I64, IL_F32, IL_F64, IL_STR, IL_BYTES } ilang_dtype;

typedef struct {
  void     *data;   // element buffer (e.g., i32*, f64*, ilang_str*)
  uint64_t  len;
  ilang_dtype dtype;
} ilang_array;
```

### 7.3 DataFrame (columnar, pandas-like)

```c
typedef struct {
  ilang_dtype dtype;
  void       *data;     // column buffer
  uint64_t    len;      // rows
  uint8_t    *mask;     // optional null bitmap (1 = null)
  const char *name;     // UTF-8
} ilang_column;

typedef struct {
  ilang_column *cols;
  uint32_t      ncols;
  uint64_t      nrows;
} ilang_dataframe;
```

**Why columnar?** Efficient interop with vectorized libs; easy bridging to Arrow/Parquet later; predictable strides; optional null bitmap.

### 7.4 Ownership & Errors

```c
typedef struct { int32_t code; ilang_str message; } ilang_status;
void ilang_free(void *ptr);  // provided by the runtime shim
```

- Functions return `ilang_status`; outputs via out-params.
- Callee-allocates return buffers; caller frees via `ilang_free`.
- ABI document specifies ownership per parameter.

---

## 8. Build to C or ASM

- **C path**: compile shims and any generated C with `clang/gcc` (`-std=c17 -O2 -Wall -Werror -fPIC`).
- **ASM path**: emit assembly with `-S` for inspection, or to link highly optimized units.
- **C++/Python/JS inputs**:
  - Prefer model to emit a **C implementation** that conforms to the signature PLUS a source-language reference version for validation.
  - If unavoidable, wrap foreign runtimes behind thin shims used only during validation; final artifact uses the C port for execution.

Typical commands:
```
clang -std=c17 -O2 -c f1/example.f1_shim.c -o f1/example.f1_shim.o
clang -std=c17 -O2 -S f1/example.f1_shim.c -o f1/example.f1_shim.s   # optional ASM
```

`build.json` enumerates exact flags and inputs; the sandbox builder executes these steps and records logs/checksums.

---

## 9. Integration via `.I` (Final C Program)

`example.I` (conceptual):

```c
#include "f1/example.f1_shim.h"
#include "f2/example.f2_shim.h"

int main(void) {
  i32 a = 3, b = 4, out = 0;
  ilang_status st = ilang_f1_add(a, b, &out);
  if (st.code != 0) { /* handle error */ }
  printf("%d
", out);
  return 0;
}
```

The build links `*_shim.o` objects into the final binary. We may also produce a shared lib (`.so/.dll/.dylib`) for embedding.

---

## 10. Testing

- **Source-language tests** generated by GPT-5 (unit/property).
- **ABI tests** in C that compile and call shim symbols (sizes, alignments, round-trips).
- **Golden tests** with frozen I/O.
- Optional **fuzzing** (libFuzzer) with strict time/mem caps.

---

## 11. Provenance & Reproducibility

- `manifest.json` per function: content hashes, toolchains, flags, model id, prompt hash, timestamp.
- Central `build.lock` (optional) to pin compilers and versions.
- All logs captured; artifacts content-addressed for cache hits.

---

## 12. Security Notes

- No network during generation/validation/build.
- Seccomp/container sandbox; allowlisted executables.
- Static analysis (clang-tidy) and banned-function checks.
- Optional WASM builds (future) for extra isolation.

---

## 13. Open Questions / Next Steps

- **Arrow-compatible DataFrame**: adopt Arrow C Data Interface to enable zero-copy with many ecosystems.
- **Auto-porting**: require GPT-5 to always emit a C port and verify equivalence vs. reference impl with tests.
- **Typed schemas**: richer IDL for sum types/variants; codegen headers from IDL.
- **Pipelines (`P`)**: scheduling, resource budgeting, and artifact reuse across multiple functions.
- **Diagnostics**: standardized error codes; coverage in provenance; flaky-test detection.

---

**Back to:** [README.md](README.md)
## 5. Validation Before Build

1. **Schema parse** (JSON).
2. **Static analysis/format** where available (e.g. `clang-format`, `ruff`).
3. **Unit tests** for source language (sandboxed).
4. **Dry-run compile** of C shim (headers, symbols, sizes).
5. **Signature/ABI check** vs. declared `signature` in the envelope.
6. **Hash & record** → `.X/<func>/manifest.json`.

Failures are logged; invalid artifacts are not integrated.

---

## 6. Materialization in `.X/`

Per `.F` function `fN`, we create a subdir:

```
example.X/
  f1/
    example.f1.py
    example.f1_shim.h
    example.f1_shim.c
    tests/test_example_f1.py
    build.json
    manifest.json
  f2/
    example.f2.cpp
    example.f2_shim.h
    example.f2_shim.c
    tests/test_example_f2.cpp
    build.json
    manifest.json
```

**Naming**
- Headers/impls end with `_shim.h` / `_shim.c`.
- Exported symbols use a stable prefix, e.g. `ilang_`.
- Paths are deterministic (hashable from inputs) to enable caching and repro.

---

## 7. C ABI & Cross-Language Datatypes

We define a compact, portable ABI with clear ownership rules.

### 7.1 Primitives

```c
#include <stdint.h>
typedef int32_t  i32;
typedef int64_t  i64;
typedef float    f32;
typedef double   f64;

typedef struct { const char *ptr; uint64_t len; } ilang_str;    // UTF-8 view
typedef struct { uint8_t *ptr;  uint64_t len; } ilang_bytes;
```

### 7.2 Arrays & Dynamic Buffers

```c
typedef enum { IL_I32, IL_I64, IL_F32, IL_F64, IL_STR, IL_BYTES } ilang_dtype;

typedef struct {
  void     *data;   // element buffer (e.g., i32*, f64*, ilang_str*)
  uint64_t  len;
  ilang_dtype dtype;
} ilang_array;
```

### 7.3 DataFrame (columnar, pandas-like)

```c
typedef struct {
  ilang_dtype dtype;
  void       *data;     // column buffer
  uint64_t    len;      // rows
  uint8_t    *mask;     // optional null bitmap (1 = null)
  const char *name;     // UTF-8
} ilang_column;

typedef struct {
  ilang_column *cols;
  uint32_t      ncols;
  uint64_t      nrows;
} ilang_dataframe;
```

**Why columnar?** Efficient interop with vectorized libs; easy bridging to Arrow/Parquet later; predictable strides; optional null bitmap.

### 7.4 Ownership & Errors

```c
typedef struct { int32_t code; ilang_str message; } ilang_status;
void ilang_free(void *ptr);  // provided by the runtime shim
```

- Functions return `ilang_status`; outputs via out-params.
- Callee-allocates return buffers; caller frees via `ilang_free`.
- ABI document specifies ownership per parameter.

---

## 8. Build to C or ASM

- **C path**: compile shims and any generated C with `clang/gcc` (`-std=c17 -O2 -Wall -Werror -fPIC`).
- **ASM path**: emit assembly with `-S` for inspection, or to link highly optimized units.
- **C++/Python/JS inputs**:
  - Prefer model to emit a **C implementation** that conforms to the signature PLUS a source-language reference version for validation.
  - If unavoidable, wrap foreign runtimes behind thin shims used only during validation; final artifact uses the C port for execution.

Typical commands:
```
clang -std=c17 -O2 -c f1/example.f1_shim.c -o f1/example.f1_shim.o
clang -std=c17 -O2 -S f1/example.f1_shim.c -o f1/example.f1_shim.s   # optional ASM
```

`build.json` enumerates exact flags and inputs; the sandbox builder executes these steps and records logs/checksums.

---

## 9. Integration via `.I` (Final C Program)

`example.I` (conceptual):

```c
#include "f1/example.f1_shim.h"
#include "f2/example.f2_shim.h"

int main(void) {
  i32 a = 3, b = 4, out = 0;
  ilang_status st = ilang_f1_add(a, b, &out);
  if (st.code != 0) { /* handle error */ }
  printf("%d\n", out);
  return 0;
}
```

The build links `*_shim.o` objects into the final binary. We may also produce a shared lib (`.so/.dll/.dylib`) for embedding.

---

## 10. Testing

- **Source-language tests** generated by GPT-5 (unit/property).
- **ABI tests** in C that compile and call shim symbols (sizes, alignments, round-trips).
- **Golden tests** with frozen I/O.
- Optional **fuzzing** (libFuzzer) with strict time/mem caps.

---

## 11. Provenance & Reproducibility

- `manifest.json` per function: content hashes, toolchains, flags, model id, prompt hash, timestamp.
- Central `build.lock` (optional) to pin compilers and versions.
- All logs captured; artifacts content-addressed for cache hits.

---

## 12. Security Notes

- No network during generation/validation/build.
- Seccomp/container sandbox; allowlisted executables.
- Static analysis (clang-tidy) and banned-function checks.
- Optional WASM builds (future) for extra isolation.

---

## 13. Open Questions / Next Steps

- **Arrow-compatible DataFrame**: adopt Arrow C Data Interface to enable zero-copy with many ecosystems.
- **Auto-porting**: require GPT-5 to always emit a C port and verify equivalence vs. reference impl with tests.
- **Typed schemas**: richer IDL for sum types/variants; codegen headers from IDL.
- **Pipelines (`P`)**: scheduling, resource budgeting, and artifact reuse across multiple functions.
- **Diagnostics**: standardized error codes; coverage in provenance; flaky-test detection.

---

**Back to:** [README.md](README.md)
