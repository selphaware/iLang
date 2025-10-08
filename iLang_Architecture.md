# iLang Architecture (Indicative)

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

## 4A) Multi‑call Synthesis Orchestration per `C()`

A single `C(...)` **does not** rely on one giant model response. Instead, it orchestrates a **series of GPT‑5 calls**, each producing **one focused artifact** (plan, source, shim, tests, build recipe, manifest), followed by validation and optional self‑repair. Below is the **step‑by‑step** flow using our two functions from `example.F`:

```txt
example.F
f1 = C(Python, "add two numbers", int, [int, int])
f2 = C(C++,    "square number",   int, [int])
```

### 4A.1 High‑level sequence (per function)

```
┌──────────┐     ┌───────────────┐     ┌──────────┐     ┌──────────┐     ┌──────────┐
│  Runner  │────▶│ GPT‑5: PLAN   │────▶│ GPT‑5:   │────▶│ GPT‑5:   │────▶│ GPT‑5:   │
│ (C call) │     │ (files/schema)│     │ SOURCE   │     │ SHIM     │     │ TESTS    │
└────┬─────┘     └──────┬────────┘     └────┬─────┘     └────┬─────┘     └────┬─────┘
     │                  │                  │               │               │
     │                  │                  ▼               ▼               ▼
     │                  │             write .X/       write .X/        write .X/
     │                  │
     │                  └────────────▶ GPT‑5: BUILD recipe (build.json) + manifest
     │
     ├─────────▶ Validate (schema, lint, dry‑compile shim, run tests)
     │
     ├─────────▶ If failure: GPT‑5 REPAIR (patch specific file) → re‑validate (N attempts)
     │
     └─────────▶ Finalize `.X/<func>/` artifacts
```

> **Principle:** Each call has a **tight prompt** and **narrow output** to keep responses deterministic and auditable.

---

### 4A.2 Concrete walk‑through — `f1` (Python: “add two numbers”)

**Stage 0 — PLAN (GPT‑5 call)**
_Request (summary)_: “Produce a JSON plan listing files to generate for `f1` with C ABI signature.”
_Response (JSON extract)_:
```json
{
  "name": "f1_add",
  "signature": { "result": "int32", "inputs": ["int32","int32"] },
  "files": [
    {"path": "example.f1.py",      "language": "python"},
    {"path": "example.f1_shim.h",  "language": "c"},
    {"path": "example.f1_shim.c",  "language": "c"},
    {"path": "tests/test_f1.py",   "language": "python"},
    {"path": "build.json",         "language": "json"},
    {"path": "manifest.json",      "language": "json"}
  ]
}
```

**Stage 1 — SOURCE (GPT‑5 call)**
_Constraint_: pure function `int32 add(int32,int32)` semantics.
_Output file_: `example.f1.py` (actual Python code body).

**Stage 2 — SHIM (GPT‑5 call)**
_Output files_: `example.f1_shim.h`, `example.f1_shim.c` exposing
```c
int ilang_f1_add(int32_t a, int32_t b, int32_t* out);
```

**Stage 3 — TESTS (GPT‑5 call)**
_Output file_: `tests/test_f1.py` (deterministic, minimal).

**Stage 4 — BUILD + MANIFEST (GPT‑5 call)**
_Output files_: `build.json` (toolchain, flags, targets) and `manifest.json` (provenance).

**Stage 5 — VALIDATE & (optional) REPAIR (Runner + GPT‑5)**
- Schema parse, static checks, **dry‑compile** the C shim, run tests.
- On failure, send **targeted logs + failing file** to GPT‑5 **REPAIR** call (patch only that file).
- Re‑validate (bounded attempts).

**Stage 6 — FINALIZE**
Artifacts for `f1` are written under `.X/f1/` and marked **valid**.

---

### 4A.3 Concrete walk‑through — `f2` (C++: “square number”)

**Stage 0 — PLAN (GPT‑5 call)** → list `example.f2.cpp`, `example.f2_shim.h`, `example.f2_shim.c`, `tests/test_f2.cpp`, `build.json`, `manifest.json`.

**Stage 1 — SOURCE (GPT‑5 call)** → `example.f2.cpp` with a function (C linkage available to shim).

**Stage 2 — SHIM (GPT‑5 call)** → `example.f2_shim.h/.c` exposing
```c
int ilang_f2_square(int32_t x, int32_t* out);
```

**Stage 3 — TESTS (GPT‑5 call)** → `tests/test_f2.cpp` (asserts `square`).

**Stage 4 — BUILD + MANIFEST (GPT‑5 call)** → `build.json`, `manifest.json`.

**Stage 5 — VALIDATE & REPAIR** → same cycle as f1.

**Stage 6 — FINALIZE** → `.X/f2/` complete.

---

### 4A.4 Integration after both functions are valid

- Compile to objects (and optionally ASM), per each function’s `build.json`.
- Link `f1/*.o` and `f2/*.o` with your final C program declared in `.I`:
```c
#include "f1/example.f1_shim.h"
#include "f2/example.f2_shim.h"
int main(void){
  int out;
  ilang_f1_add(3,4,&out);   // -> 7
  ilang_f2_square(5,&out);  // -> 25
  return 0;
}
```
- Produce the final **single C executable** (or shared library).

---

### 4A.5 Notes on determinism & provenance

- Each GPT‑5 call is recorded with: purpose (PLAN/SOURCE/SHIM/TESTS/BUILD/REPAIR), prompts, hashes, and outputs.
- Deterministic options: seeded randomness captured in `manifest.json` if used.
- **Repair budget** is bounded (e.g., 2–3 attempts) to prevent unbounded loops.
- Only the **model** emits code; the runner never “fills in” files.

---

### 4A.6 Cross‑language datatypes reminder

All shims speak the C ABI (§7), including `ilang_dataframe` for DataFrame‑like data. For Python/C++ sources that internally use native types (e.g., `pd.DataFrame`), GPT‑5 generates **marshal/unmarshal** code between the native representation and the C structs at the shim boundary.


## 4B) Stage‑by‑Stage Call Reference (per function)

This reference specifies *exactly* what each GPT‑5 call must do, what the runner provides, and what files must be returned. It complements §4 and §4A and applies to **every** function declared in a `.F` file (e.g., `f1`, `f2`).

> **Contract:** The **model emits all artifacts**. The runner only validates, repairs (by asking the model to patch a single file), compiles, and links.

### 4B.1 Summary Table

| Stage ID | Call kind | Purpose | Inputs (Runner → Model) | Required Outputs (Model → Runner) | Validation (Runner) | On Failure |
|---|---|---|---|---|---|---|
| **PLAN** | GPT‑5 | Plan and enumerate artifacts with signature & ABI | Function spec (lang, ver, description, `result_type`, `input_types`), global policy (no net, code‑only), naming seed | JSON with: `name`, `signature`, `abi:"c"`, `files[]` (paths + languages), **no bodies yet** | JSON schema parse; allowed languages; file/path rules | Ask for corrected PLAN (rare) |
| **SOURCE** | GPT‑5 | Produce reference implementation in the source language | PLAN + function spec; file path to fill (e.g., `example.f1.py`); constraints | `files[]` with **exactly one** entry for the source file containing **full code** | Lint/format (if available); quick static checks | REPAIR_SOURCE (return same path with corrected body) |
| **SHIM** | GPT‑5 | Emit C ABI boundary (header + impl) | PLAN; signature; naming; ABI rules (§7) | `files[]` with **two** entries: `*_shim.h`, `*_shim.c` | **Dry‑compile** shim; check symbols, sizes; header guard | REPAIR_SHIM (patch the offending file only) |
| **TESTS** | GPT‑5 | Emit minimal, deterministic tests | PLAN; signature; source language; example I/O | `files[]` with **one** test file (e.g., `tests/test_f1.py` or `.cpp`) | Run tests in sandbox interpreter/runtime | REPAIR_TESTS |
| **BUILD+MANIFEST** | GPT‑5 | Provide build recipe and provenance | PLAN; toolchain policy; target formats (obj/asm) | `build.json` (toolchain, flags, targets) + `manifest.json` (model, hashes, deps) | JSON schema; commands allowlist | REPAIR_BUILD |
| **VALIDATE** | Runner | Verify, compile, and test (no model call) | All generated files | Build logs; status | Dry‑compile shim; run tests; audit flags | If failing: trigger targeted REPAIR call |
| **FINALIZE** | Runner | Mark function artifacts valid & ready | N/A | N/A | Record hashes; store status | N/A |

**Envelope shape per call:** All GPT‑5 calls return a JSON object. For PLAN, `files[]` contains **names only**. For SOURCE/SHIM/TESTS/BUILD+MANIFEST, `files[]` contains **bodies**. If a call produces multiple outputs (e.g., SHIM, BUILD+MANIFEST), `files[]` must contain exactly the listed paths and nothing else. Bodies are UTF‑8 text; binaries require base64 with `"encoding":"base64"`.

---

### 4B.2 Naming & Path Conventions (recap)

- Per function `fN`, artifacts live in `.X/fN/`.
- Shim files: `example.fN_shim.h`, `example.fN_shim.c`. C headers are **C‑only** (not C++), with `extern "C"` guards where needed.
- Tests live in `.X/fN/tests/` as `test_fN.<ext>`; additional tests may be `test_fN_*.ext`.
- Build artifacts: `.X/fN/build.json`, `.X/fN/manifest.json`.
- Exported ABI symbol prefix: `ilang_` (e.g., `ilang_f1_add`, `ilang_f2_square`).

---

### 4B.3 Example: Files per Stage (f1 & f2)

**`f1 = C(Python, "add two numbers", int, [int, int])`**

- PLAN → declare: `example.f1.py`, `example.f1_shim.h`, `example.f1_shim.c`, `tests/test_f1.py`, `build.json`, `manifest.json`
- SOURCE → writes `example.f1.py`
- SHIM → writes `example.f1_shim.h`, `example.f1_shim.c` (exposes `int ilang_f1_add(int32_t a, int32_t b, int32_t* out)`)
- TESTS → writes `tests/test_f1.py`
- BUILD+MANIFEST → writes `build.json`, `manifest.json`
- VALIDATE → lint+dry‑compile shim; run tests
- FINALIZE → mark `.X/f1/` valid

**`f2 = C(C++, "square number", int, [int])`**

- PLAN → declare: `example.f2.cpp`, `example.f2_shim.h`, `example.f2_shim.c`, `tests/test_f2.cpp`, `build.json`, `manifest.json`
- SOURCE → writes `example.f2.cpp` (C linkage for ref impl as needed)
- SHIM → writes `example.f2_shim.h`, `example.f2_shim.c` (exposes `int ilang_f2_square(int32_t x, int32_t* out)`)
- TESTS → writes `tests/test_f2.cpp`
- BUILD+MANIFEST → writes `build.json`, `manifest.json`
- VALIDATE → compile shim; run tests
- FINALIZE → mark `.X/f2/` valid

---

### 4B.4 Repair Protocol (targeted patches)

- **Trigger:** Any validation error (schema, lint, compile error, failed test).
- **Inputs to GPT‑5:** failing file **path**, the **exact failing body**, and **minimal logs** (compiler/test excerpt).
- **Output:** a JSON envelope with `files[]` containing **exactly one** entry (the same path) with a **corrected body**.
- **Budget:** bounded attempts (e.g., max 3 per stage).
- **Determinism:** no randomness added unless seeded and captured in `manifest.json`.

---

### 4B.5 Test & Build Requirements (minimums)

- Tests must be **deterministic** and run under constrained resources.
- For C/C++ shims, build with `-std=c17` and `-Wall -Werror` (C) and conservative C++ standard if used in tests.
- ASM targets via `-S` are optional but recommended for auditability.
- Disallow network and OS‑specific syscalls in generated code unless explicitly permitted by policy.

---

### 4B.6 Cross‑Language Datatypes (reminder from §7)

All shims use the C ABI and the iLang datatypes, including `ilang_dataframe` for DataFrame‑like data. When a source language uses native structures (e.g., pandas `DataFrame`), GPT‑5 is responsible for emitting **marshal/unmarshal** code at the shim boundary.

---

### 4B.7 Provenance & Reproducibility

Every GPT‑5 call records in `manifest.json` (or a per‑function call log):

- `model`, `prompt_hash`, `inputs_hash`
- toolchain versions, compiler/linker flags
- timestamps (UTC), content hashes
- pass/fail status per stage and repair count

This ensures that any artifact can be reproduced or audited.


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
