#!/usr/bin/env python3
"""
codegen.py — thin wrapper around aiinterface.chat()/chat_json() that writes
the generated code to a target file path you provide.

Examples:
  python codegen.py -p "Write a C function add(int,int)" -o results/add.c
  python codegen.py -p - -o results/df.c            # read prompt from stdin
  python codegen.py -p "Return JSON {filename,code} for a C func f()" --json -O results/

Notes:
- If --json is used and the model returns {"filename": "...", "code": "..."},
  the final path is: <output-dir>/<filename> (or --filename overrides it).
- Markdown code fences are removed automatically before writing.
"""

from __future__ import annotations
import argparse, os, sys, re, json
from pathlib import Path

# Import your existing helpers
from aiinterface import chat, chat_json, SYSTEM_PROMPT, DEFAULT_MODEL


CODE_BLOCK_RE = re.compile(r"```[a-zA-Z0-9+._-]*\s*\n(.*?)```", re.DOTALL)


def _extract_code(text: str) -> str:
    """
    If the model returns Markdown code fences, extract the code body.
    If multiple code fences exist, join them with a blank line.
    Otherwise, return the raw text.
    """
    blocks = CODE_BLOCK_RE.findall(text)
    if not blocks:
        return text.strip()
    # Join multiple blocks (some models split headers/impl/tests)
    body = "\n\n".join(b.strip("\n\r") for b in blocks).rstrip()
    return body


def _ensure_parent_dir(p: Path, exist_ok: bool = True) -> None:
    if p.suffix:  # looks like a file path
        p.parent.mkdir(parents=True, exist_ok=exist_ok)
    else:
        p.mkdir(parents=True, exist_ok=exist_ok)


def generate_code_to_file(
    prompt: str,
    out_path: str | None = None,
    *,
    model: str = DEFAULT_MODEL,
    system_prompt: str = SYSTEM_PROMPT,
    use_json: bool = False,
    filename_override: str | None = None,
    allow_overwrite: bool = True,
) -> Path:
    """
    Generate code from `prompt` and write it to disk.

    Args:
      prompt:              The model prompt (can be raw text).
      out_path:            File path (or directory if --json and filename comes from model).
      model:               Model name (default from aiinterface.py).
      system_prompt:       System instructions to guide style/quality.
      use_json:            If True, expect {"filename": "...", "code": "..."} from the model.
      filename_override:   If provided, forces this filename even in JSON mode.
      allow_overwrite:     If False, raise if target file exists.

    Returns:
      Path to the written file.
    """
    if use_json:
        obj = chat_json(
            prompt,
            system_prompt=system_prompt,
            model=model,
        )
        # Expect minimal shape
        code = obj.get("code", "")
        model_fname = obj.get("filename", "generated.txt")
        if not code:
            raise ValueError("JSON response did not contain a 'code' field.")
        fname = filename_override or model_fname

        if out_path is None:
            raise ValueError("When --json is used, please provide -O/--out to specify an output directory.")

        outp = Path(out_path)
        if outp.suffix:  # user gave a file path, not a dir
            target = outp
        else:
            _ensure_parent_dir(outp, exist_ok=True)
            target = outp / fname

        code = _extract_code(code)

    else:
        if out_path is None:
            raise ValueError("Please provide -o/--out-file when not using --json.")
        text = chat(
            prompt,
            system_prompt=system_prompt,
            model=model,
        )
        code = _extract_code(text)
        target = Path(out_path)

    # Write the file
    _ensure_parent_dir(target, exist_ok=True)
    if target.exists() and not allow_overwrite:
        raise FileExistsError(f"Refusing to overwrite existing file: {target}")
    target.write_text(code, encoding="utf-8")
    return target


def _parse_args(argv: list[str]) -> argparse.Namespace:
    p = argparse.ArgumentParser(description="Generate code with GPT-5 and save it to a file.")
    p.add_argument("-p", "--prompt", required=True,
                   help="Prompt text. Use '-' to read from stdin.")
    group_out = p.add_mutually_exclusive_group(required=True)
    group_out.add_argument("-o", "--out-file",
                           help="Write to this exact file (non-JSON mode).")
    group_out.add_argument("-O", "--out",
                           help="Output directory (for JSON mode or if you want to control dir).")
    p.add_argument("-m", "--model", default=DEFAULT_MODEL,
                   help=f"Model name (default: {DEFAULT_MODEL})")
    p.add_argument("-s", "--system", default=SYSTEM_PROMPT,
                   help="System prompt/instructions.")
    p.add_argument("--json", action="store_true",
                   help="Expect a JSON object with {filename, code}. Writes to -O/<filename> unless --filename overrides.")
    p.add_argument("--filename", default=None,
                   help="Override filename when using --json.")
    p.add_argument("--no-overwrite", action="store_true",
                   help="Error if target file exists.")
    return p.parse_args(argv)


def main(argv: list[str] | None = None) -> int:
    ns = _parse_args(sys.argv[1:] if argv is None else argv)

    prompt = ns.prompt
    if prompt == "-":
        prompt = sys.stdin.read()

    try:
        target = generate_code_to_file(
            prompt=prompt,
            out_path=ns.out_file or ns.out,
            model=ns.model,
            system_prompt=ns.system,
            use_json=ns.json,
            filename_override=ns.filename,
            allow_overwrite=not ns.no_overwrite,
        )
        print(str(target))
        return 0
    except Exception as e:
        print(f"[codegen error] {e}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())

__author__ = "Usman Ahmad"
