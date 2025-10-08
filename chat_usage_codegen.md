# 🧠 iLang Chat Client — Code Generation Usage Guide

This guide shows how to use **chat.py** for generating and streaming **code functions** using GPT‑5 within iLang.

---

## ⚙️ Overview

`chat.py` is a compact CLI tool that connects iLang to GPT‑5 for **code synthesis**.  
You can use it to generate functions in C, Python, JavaScript, and more, directly from structured natural‑language prompts.

---

## 📦 Setup

```bash
pip install openai>=1.0
```

Set your API key once:

```bash
setx OPENAI_API_KEY "sk‑your‑key"    # Windows
# or
export OPENAI_API_KEY="sk‑your‑key"  # macOS / Linux
```

---

## 🚀 Basic Code Generation

### 1️⃣ Generate a simple Python function

```bash
python chat.py -p "Write a Python function called square that returns the square of an integer input. Just provide the code." -m gpt-5
```

_Output example:_

```python
def square(x: int) -> int:
    return x * x
```

---

### 2️⃣ Generate a C function

```bash
python chat.py -p "Write a C function named add that adds two integers and returns the result. Just provide the code." -m gpt-5
```

_Output:_

```c
int add(int a, int b) {
    return a + b;
}
```

---

### 3️⃣ Generate a C function that reads a CSV file

```bash
python chat.py -p "Write a C function that reads a CSV file and returns a dataframe‑type structure. The CSV filename should come from argv[1]. Just provide the code." -m gpt-5
```

This produces a fully functional program similar to the one that defines:
```c
DataFrame *read_csv(const char *filename, char delimiter);
```

---

## 💬 System Instruction Override

You can specialize GPT‑5’s behavior:

```bash
python chat.py -p "Write a robust C++ class to manage CSV parsing." -s "You are a senior systems engineer focused on C and C++ performance and memory safety."
```

---

## 🧩 Generate Structured Code Snippets (JSON)

Ask GPT‑5 to return code in JSON format for easy parsing:

```bash
python chat.py -p "Return a JSON object with a 'filename' and a 'code' field containing a Python function that prints 'Hello, iLang'." --json
```

_Output example:_

```json
{
  "filename": "hello_ilang.py",
  "code": "def hello():\n    print('Hello, iLang')"
}
```

---

## 🌊 Stream Generated Code (token‑by‑token)

```bash
python chat.py -p "Write a JavaScript function that reverses a string." --stream
```

You’ll see the code appear live as GPT‑5 generates it.

---

## 🧠 Advanced Model Options

| Flag | Description |
|------|--------------|
| `--temp` | Adjust creativity (0 = deterministic) |
| `--effort` | Reasoning level (`low`, `medium`, `high`) |
| `--verbosity` | Control explanation verbosity |
| `--json` | Structured JSON output |
| `--stream` | Stream output in real time |

Example:

```bash
python chat.py -p "Write a C function to calculate factorial recursively." --effort high --verbosity low
```

---

## 📂 Reading Prompt from a File

Put your code request in a text file, e.g. `prompt.txt`:

```
Write a C function that reads a text file and prints its contents to stdout.
Just provide the code, no explanations.
```

Run it:

```bash
cat prompt.txt | python chat.py -p - -m gpt-5
```

*(The `-p -` flag tells chat.py to read the prompt from stdin.)*

---

## 🧱 Programmatic Use

You can import and call GPT‑5 directly from Python:

```python
from chat import chat, chat_json

# Generate a code snippet
code = chat("Write a C function that returns the max of two integers. Just provide the code.")
print(code)

# Generate structured code output
data = chat_json("Return JSON with filename and code for a Python factorial function.")
print(data["filename"], data["code"])
```

---

## 🧩 Example Workflow for iLang Function Creation

```bash
python chat.py -p "Write a C function called multiply that multiplies two integers. Just provide the code." -m gpt-5
python chat.py -p "Write a Python function that calculates factorial. Just provide the code." -m gpt-5
python chat.py -p "Write a JavaScript function that reverses a string. Just provide the code." -m gpt-5
```

These outputs can then be saved into `.X/` folders for compilation or orchestration in the iLang pipeline.

---

## 🧭 Summary

| Mode | Command Example | Output |
|------|------------------|---------|
| Generate Code | `python chat.py -p "Write a C function..."` | Full code |
| JSON Code | `python chat.py -p "Return JSON..." --json` | Code wrapped in JSON |
| Stream | `python chat.py -p "Write Python code..." --stream` | Real‑time output |
| From File | `cat prompt.txt | python chat.py -p -` | Reads prompt from file |

---

© 2025 **iLang / Selphaware – Usman Ahmad**
