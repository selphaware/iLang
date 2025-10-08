#!/usr/bin/env python3
"""
aiinterface.py — tiny, modular wrapper around OpenAI Responses API (GPT-5).

AI Interface

- Set SYSTEM_PROMPT below or pass at runtime.
- Call `chat()`, `chat_json()`, or `stream_chat()` from your code, or use CLI.
- Only standard lib + official OpenAI SDK required.

Usage (CLI):
  python ilang_gpt5_client.py -p "Explain iLang in 2 bullets."
  python ilang_gpt5_client.py -p "Return a JSON object with {title, bullets[]}." --json
  python ilang_gpt5_client.py -p "Stream a short haiku." --stream

Env:
  export OPENAI_KEY=sk-...
"""
from __future__ import annotations
import argparse, json, os, sys, time
from typing import Any, Dict, Iterable, Optional

try:
    from openai import OpenAI
except ImportError:
    print("Please install the official SDK: pip install openai>=1.0", file=sys.stderr)
    sys.exit(1)

# ---- Defaults (override via function args or CLI) ----------------------------
DEFAULT_MODEL = os.getenv("ILANG_MODEL", "gpt-5")  # pick a GPT-5 family default
SYSTEM_PROMPT = os.getenv("ILANG_SYSTEM_PROMPT", "You are a concise, precise AI software engineer.")

# ---- Client factory ----------------------------------------------------------
def make_client() -> OpenAI:
    """
    Returns a ready-to-use OpenAI client.
    Reads OPENAI_API_KEY from the environment.
    """
    return OpenAI()  # uses env vars; supports sync/async under the hood

# ---- Core call helpers -------------------------------------------------------
def _mk_input(system_prompt: str, user_text: str) -> list[dict]:
    """Builds the minimal chat-style input list for the Responses API."""
    return [
        {"role": "system", "content": system_prompt},
        {"role": "user", "content": user_text},
    ]

def chat(
    prompt: str,
    *,
    system_prompt: str = SYSTEM_PROMPT,
    model: str = DEFAULT_MODEL,
    temperature: float = 0.2,
    top_p: float = 1.0,
    max_output_tokens: Optional[int] = None,
    reasoning_effort: Optional[str] = None,   # e.g. "low" | "medium" | "high" (GPT-5)
    verbosity: Optional[str] = None,          # e.g. "low" | "medium" | "high" (GPT-5)
) -> str:
    """
    One-shot non-streaming text call.
    Returns the model's text output (already concatenated).
    """
    client = make_client()
    kwargs: Dict[str, Any] = {
        "model": model,
        "input": _mk_input(system_prompt, prompt),
        "temperature": temperature,
        "top_p": top_p,
    }

    # Skip unsupported sampling params for reasoning models
    if model.lower().startswith(("gpt-5", "o1", "o3")):
        kwargs.pop("temperature", None)
        kwargs.pop("top_p", None)

    if max_output_tokens is not None:
        kwargs["max_output_tokens"] = max_output_tokens
    if reasoning_effort:
        kwargs["reasoning"] = {"effort": reasoning_effort}
    if verbosity:
        kwargs["verbosity"] = verbosity

    resp = client.responses.create(**kwargs)
    # Most convenient property for plain text:
    return getattr(resp, "output_text", "").strip()

def chat_json(
    prompt: str,
    *,
    system_prompt: str = SYSTEM_PROMPT,
    model: str = DEFAULT_MODEL,
    schema_hint: Optional[Dict[str, Any]] = None,
) -> Dict[str, Any]:
    """
    Ask the model to return JSON. Minimal, reliable approach using JSON mode.
    For stricter schemas, upgrade later to Structured Outputs/parse().
    """
    client = make_client()
    kwargs: Dict[str, Any] = {
        "model": model,
        "response_format": {"type": "json_object"},
        "input": _mk_input(system_prompt, prompt),
        "temperature": 0,  # nudge toward determinism when asking for JSON
    }
    # You can optionally include a schema hint in the prompt itself.
    if schema_hint:
        prompt_with_hint = prompt + "\n\nReturn JSON matching this shape:\n" + json.dumps(schema_hint)
        kwargs["input"] = _mk_input(system_prompt, prompt_with_hint)

    resp = client.responses.create(**kwargs)
    text = getattr(resp, "output_text", "{}")
    try:
        return json.loads(text)
    except json.JSONDecodeError:
        # Fall back: attempt to extract JSON substring
        start = text.find("{")
        end = text.rfind("}")
        if start >= 0 and end > start:
            return json.loads(text[start : end + 1])
        raise

def stream_chat(
    prompt: str,
    *,
    system_prompt: str = SYSTEM_PROMPT,
    model: str = DEFAULT_MODEL,
    temperature: float = 0.2,
    on_token: Optional[callable] = None,
) -> str:
    """
    Streaming text call. If on_token is provided, it's called with each text delta.
    Returns the full accumulated string.
    """
    client = make_client()
    full_text: list[str] = []
    with client.responses.stream(
        model=model,
        input=_mk_input(system_prompt, prompt),
        temperature=temperature,
    ) as stream:
        for event in stream:
            if event.type == "response.output_text.delta":
                chunk = event.delta or ""
                if on_token:
                    on_token(chunk)
                full_text.append(chunk)
            elif event.type == "response.completed":
                break
    return "".join(full_text).strip()

# ---- Simple CLI --------------------------------------------------------------
def _parse_args(argv: Iterable[str]) -> argparse.Namespace:
    p = argparse.ArgumentParser(description="Minimal GPT-5 client for iLang")
    p.add_argument("-p", "--prompt", required=True, help="User prompt")
    p.add_argument("-s", "--system", default=SYSTEM_PROMPT, help="System instructions")
    p.add_argument("-m", "--model", default=DEFAULT_MODEL, help="Model name (e.g., gpt-5, gpt-5-mini)")
    p.add_argument("--json", action="store_true", help="Request JSON output (non-streaming)")
    p.add_argument("--stream", action="store_true", help="Stream output tokens to stdout")
    p.add_argument("--temp", type=float, default=0.2, help="Temperature")
    p.add_argument("--max_tokens", type=int, default=None, help="Max output tokens")
    p.add_argument("--effort", choices=["low", "medium", "high"], default=None, help="GPT-5 reasoning effort")
    p.add_argument("--verbosity", choices=["low", "medium", "high"], default=None, help="GPT-5 verbosity")
    return p.parse_args(list(argv))

def main(argv: Iterable[str] = None) -> int:
    ns = _parse_args(argv or sys.argv[1:])
    if ns.prompt == "-":
        ns.prompt = sys.stdin.read()
    if ns.stream:
        start = time.time()
        def printer(tok: str) -> None:
            print(tok, end="", flush=True)
        out = stream_chat(
            ns.prompt,
            system_prompt=ns.system,
            model=ns.model,
            temperature=ns.temp,
            on_token=printer,
        )
        if not out.endswith("\n"):
            print()
        print(f"\n[streamed in {time.time()-start:.2f}s]", file=sys.stderr)
        return 0

    if ns.json:
        obj = chat_json(
            ns.prompt,
            system_prompt=ns.system,
            model=ns.model,
        )
        print(json.dumps(obj, ensure_ascii=False, indent=2))
        return 0

    text = chat(
        ns.prompt,
        system_prompt=ns.system,
        model=ns.model,
        temperature=ns.temp,
        max_output_tokens=ns.max_tokens,
        reasoning_effort=ns.effort,
        verbosity=ns.verbosity,
    )
    print(text)
    return 0

if __name__ == "__main__":
    raise SystemExit(main())

__author__ = "Usman Ahmad"
