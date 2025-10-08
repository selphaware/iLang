# `codegen.py` — Usage Guide

_Last updated: 2025-10-08 15:18 UTC_

`codegen.py` is a thin wrapper around your `aiinterface.py` chat helpers that sends a prompt to the model and **writes the generated code to disk**. It supports plain-text responses and a JSON mode where the model returns both a filename and code body.

---

## Quick Start

```bash
# 1) Generate code to a specific file (plain text mode)
python codegen.py -p "Write a C function add(int a,int b)" -o chat/results/add.c

# 2) Compile with MSYS2 / gcc
gcc -S -O2 -masm=intel -fverbose-asm chat/results/add.c -o chat/results/add.s
gcc chat/results/add.s -o chat/results/add.exe
```

> **Note:** `-o` is for an exact file path (plain-text mode). Use `-O` when you want to provide an **output directory** (commonly paired with `--json`).

---

## Installation & Requirements

- Python 3.10+
- Your repo’s `aiinterface.py` (with `chat()` and/or `chat_json()`)
- Optional: MSYS2 with `gcc` to compile generated C/C++ code

Place `codegen.py` next to `aiinterface.py` (or ensure it’s on `PYTHONPATH`).

---

## CLI Overview

```
usage: codegen.py [-h] -p PROMPT (-o OUT_FILE | -O OUT) [-m MODEL] [-s SYSTEM] [--json] [--filename FILENAME] [--no-overwrite]

Generate code with GPT-5 and save it to a file.

options:
  -p, --prompt TEXT        Prompt text. Use '-' to read from stdin.
  -o, --out-file PATH      Write to this exact file (non-JSON mode).
  -O, --out PATH           Output directory (for JSON mode or if you want to control dir).
  -m, --model NAME         Model name (defaults from aiinterface.DEFAULT_MODEL).
  -s, --system TEXT        System prompt/instructions (defaults from aiinterface.SYSTEM_PROMPT).
  --json                   Expect a JSON object with {filename, code} from the model.
  --filename NAME          Override filename when using --json.
  --no-overwrite           Refuse to overwrite an existing target file.
```

---

## Modes

### 1) Plain-Text Mode (default)

Use when the model will return **just code** or a Markdown code block. You must supply a concrete output file path with `-o/--out-file`.

```bash
python codegen.py -p "Write a C function that sums an int array." -o chat/results/sum_array.c
```

`codegen.py` automatically strips Markdown code fences (```...```) and writes the cleaned source to the target file.

### 2) JSON Mode (`--json`)

Use when the model returns a JSON object with both a `filename` and `code` field:

```json
{"filename":"dataframe.c","code":"/* C source here */"}
```

Provide an output **directory** with `-O`, and the script will write to `<out-dir>/<filename>`. You can override the filename with `--filename`.

```bash
python codegen.py -p "Return JSON with filename and code for a C DataFrame API" --json -O chat/results/
# Force a specific name while still using JSON response:
python codegen.py -p "Return JSON {filename,code} for a CSV reader" --json -O chat/results/ --filename dataframe.c
```

---

## Reading Prompts from Files (stdin)

Pass `-` to `-p/--prompt` to read the prompt from **stdin**:

```bash
# Windows (PowerShell)
type prompt.txt | python codegen.py -p - -o chat/results/df.c

# MSYS2 / Git Bash / Linux / macOS
cat prompt.txt | python codegen.py -p - -o chat/results/df.c
```

This is handy for long prompts you keep under version control.

---

## End-to-End Pipelines

### Generate → Assemble → Link (MSYS2, x86-64)

```bash
# 1) Generate
python codegen.py -p "Write a C function that reads a CSV and returns a DataFrame struct. Just provide the code." -o chat/results/dataframe.c

# 2) Assemble (to Intel syntax with verbose comments)
gcc -S -O2 -masm=intel -fverbose-asm chat/results/dataframe.c -o chat/results/dataframe.s

# 3) Link
gcc chat/results/dataframe.s -o chat/results/dataframe.exe
```

### Generate Multiple Files with JSON Mode

```bash
python codegen.py -p "Generate JSON with {filename,code} for: header, impl, and tests for a CSV DataFrame API." --json -O chat/results/
# Repeat or loop per logical unit (e.g., one model call per file).
```

> Tip: For multi-file projects, call `codegen.py` repeatedly with targeted prompts (e.g., “emit only the header now”, “emit only tests now”).

---

## Error Handling & Safety

- If you pass `--no-overwrite`, `codegen.py` will **refuse** to overwrite an existing file.
- In JSON mode, the script raises an error if the model response lacks a `code` field.
- On any error, it prints a message to **stderr** prefixed with `[codegen error]` and exits non‑zero.
- The script ensures parent directories exist (creates them if missing).

---

## Best Practices

- **Be explicit** in your prompts (language, standard, function signature, constraints, tests).
- Prefer JSON mode when generating multiple related files and you want the model to propose filenames.
- Keep a **system prompt** tuned for code style and determinism; pass it via `-s/--system` when needed.
- Check the generated code into source control before compiling; it makes diffs and iteration easier.
- Add a CI step that calls `codegen.py` deterministically for reproducibility when practical.

---

## Examples Cheatsheet

```bash
# Plain text → exact path
python codegen.py -p "C17 function add(int,int)" -o chat/results/add.c

# Long prompt from file via stdin
cat spec.md | python codegen.py -p - -o chat/results/engine.c

# JSON mode → write into directory (filename from model)
python codegen.py -p "Return JSON with filename and code for a C hashmap" --json -O chat/results/

# JSON mode with forced filename
python codegen.py -p "Return JSON {filename,code} for a C hashmap" --json -O chat/results/ --filename map.c

# Generate & compile (MSYS2)
python codegen.py -p "C17 program that prints 'ok'" -o chat/results/ok.c
gcc -O2 chat/results/ok.c -o chat/results/ok.exe
```

---

## Troubleshooting

- **The file contains Markdown fences (` ``` `)**  
  `codegen.py` already strips them. If you still see fences, your model might have embedded them in strings—check the prompt.
- **Overwrites a file unexpectedly**  
  Use `--no-overwrite` to make it fail fast if the target exists.
- **JSON mode wrote to the wrong place**  
  Remember: `-O` expects a directory; `-o` is a concrete file path (non‑JSON mode).
- **Model returns multiple code blocks**  
  The script concatenates them with a blank line. Consider asking the model to return a single block or switch to JSON mode.
- **MSYS2 `gcc` not found**  
  Ensure you’re in the correct shell (e.g., “MSYS2 UCRT64”) and `gcc --version` works.

---

## Appendix: Minimal Prompt Templates

**Plain-text mode (single file):**
```
Write a C17 function `add(int a,int b)` that returns their sum.
Just provide the code; no explanations or Markdown.
```

**JSON mode (filename + code):**
```
Return ONLY a JSON object with fields "filename" and "code".
- filename: "dataframe.c"
- code: C17 implementation of a CSV reader that returns a DataFrame struct.
No Markdown code fences, no extra keys.
```

---

Happy generating!
