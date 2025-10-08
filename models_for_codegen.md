# `-m` Model Options — Reference for `codegen.py`

_Last updated: 2025-10-08 15:26 UTC_

This page explains how the `-m/--model` flag works in `codegen.py`, how to **discover models available to your account**, and gives a practical menu of commonly used models for code generation and reasoning.

> ⚠️ Model availability varies by account, org, and region. Always verify against your own account (see **Discover models on your account** below).

---

## How `-m` works

`codegen.py` passes the exact string from `-m/--model` into your `aiinterface.py` client, which then calls the OpenAI API. If the model name is unknown to your account, the API returns an error.

Examples:

```bash
# Use project default (as set in aiinterface.py)
python codegen.py -p "Write a C17 function add(int,int)" -o chat/results/add.c

# Override explicitly
python codegen.py -p "Generate a header-only C hashmap (C17)." -o chat/results/map.h -m gpt-5
python codegen.py -p "Explain what this function does" -o chat/results/explain.txt -m gpt-4o
```

---

## Discover models on your account

### 1) Via OpenAI CLI

```bash
# List all models visible to your API key
openai models list

# Filter a few common families
openai models list | grep -E "gpt-5|gpt-4|4o|o1|o3|o4|mini|nano"
```

### 2) Via Python

```python
from openai import OpenAI
client = OpenAI()
models = client.models.list()
print([m.id for m in models.data])
```

> Tip: Bake a small helper like `list_models.py` in your repo to snapshot available models during CI.

---

## Common model families (quick menu)

Below is a practical, **non‑exhaustive** guide to frequently used models. Treat this as a starting point; use the discovery commands above for the authoritative list.

| Family | Example IDs (illustrative) | Good for | Notes |
|---|---|---|---|
| GPT‑5 | `gpt-5`, `gpt-5-mini`, `gpt-5-nano` | Highest quality codegen, refactors, complex tasks | Larger context and best reasoning; higher cost/latency vs. mini/nano |
| GPT‑4o | `gpt-4o`, `gpt-4o-mini` | Strong general chat, multimodal inputs, decent code | Great balance of cost/quality; fast |
| GPT‑4.1 | `gpt-4.1`, `gpt-4.1-mini` | Robust instruction following, tool use | Often generous context; solid for agents |
| Reasoning (o‑series) | `o1`, `o3`, `o4-mini` (snapshots) | Deliberate reasoning on hard problems | Higher latency; great for validation/critique passes |
| Lightweight | `*-mini`, `*-nano` variants | Cheap/fast code scaffolding | Use for drafts, then upgrade for final pass |

> **Snapshots**: Some models have snapshot suffixes (e.g., `-2025-06-01`). Snapshots lock behavior for reproducibility.

---

## Recommendations for `codegen.py`

- **Single-file codegen**: `gpt-5` or `gpt-4o` → highest quality; fall back to `gpt-5-mini` for speed.
- **Multi-file projects (JSON mode)**: prefer `gpt-5` for planning + filenames; switch to `*-mini` for iterative emissions.
- **Verification pass**: run a second pass with an o‑series model (e.g., `o1`/`o3`) to review for bugs and undefined behavior.
- **Tight budgets / many iterations**: start with `gpt-4o-mini` or `gpt-5-mini`, then upgrade for the final polish.

---

## Feature checklist by need

- **Very long prompts / repos** → pick families with large context (e.g., GPT‑5 / GPT‑4.1).  
- **JSON / structured outputs** → all modern GPTs support this well; include clear schemas.  
- **Multimodal (images)** → GPT‑4o family is a safe bet.  
- **Determinism** → prefer snapshot model IDs and set temperature low (e.g., `-t 0.1`).

---

## Fallback logic (optional pattern)

You can add a simple fallback in `codegen.py`:

```text
Try gpt-5 → if unavailable, try gpt-4o → if unavailable, try gpt-5-mini → else error.
```

Implement by catching the OpenAI error and retrying with the next candidate.

---

## Examples

```bash
# Highest quality, single file
python codegen.py -p "C17 JSON parser, no third‑party deps" -o chat/results/json.c -m gpt-5

# Budget iteration
python codegen.py -p "Generate stubs for a C test harness" -o chat/results/harness.c -m gpt-5-mini

# Reasoning review of produced code (ask for critique, not generation)
python codegen.py -p "Review and identify UB in this code: ..." -o chat/results/review.md -m o1
```

---

## Keep this list accurate

- Run `openai models list` regularly and update this page.  
- Prefer **snapshot IDs** in production to lock behavior.  
- Track cost & latency in your repo’s docs to guide model selection.

---

**Appendix: Auto‑generate a local list**

```bash
python - << 'PY'
from openai import OpenAI
c = OpenAI()
ids = sorted(m.id for m in c.models.list().data)
for mid in ids:
    print(mid)
PY > chat/models_snapshot.txt
```

Save this alongside a date stamp (e.g., `models_snapshot_2025‑10‑08.txt`).
