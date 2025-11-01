#!/usr/bin/env python3
"""
genmod.py — Library-first generator for C ABI packages (.h, .c, .abi.json)

Design:
- Library entry: generate_abi_package(...)
- Optional helper: emit_smoke_main(...)
- CLI entry: cli() parses args and calls the library function

Artifacts (default): project/<module>.X/<module>.h|.c|.abi.json
Optionally: project/<module>.X/main_<module>.c (smoke test)
"""

from __future__ import annotations
from pathlib import Path
import argparse, json, re, textwrap
from typing import Dict, Optional

# Reuse your existing wrappers
from aiinterface import chat_json, DEFAULT_MODEL   # GPT-5 client I/O
from codegen import generate_code_to_file          # writes code safely


# -------------------------- System prompts --------------------------

SYSTEM_ABI = (
    "You are a strict, portable C ABI author. "
    "Headers must compile as C and C++. Prefer simple C99 types and caller-owned buffers. "
    "No extra commentary—produce only the requested code."
)

SYSTEM_SRC = (
    "You are a precise systems programmer writing portable C99. "
    "No global state, no I/O, no printf, no comments except function headers. "
    "Return explicit error codes where applicable."
)


# -------------------------- Templates --------------------------

HEADER_TEMPLATE = """Write a C header for module '{module}' with these rules:
- Use header guard: {guard}
- Provide extern "C" guards for C++.
- C99-compatible; portable; do not include non-standard headers.
- Define only the function prototypes and minimal forward decls/types needed.
- ABI functions to provide (interpret precisely, matching signatures):
{functions_bullets}
- Keep one-line doc comments above each function.
"""

SOURCE_TEMPLATE = """Implement '{module}.c' for the ABI declared below.
===== BEGIN {module}.h =====
{header_text}
===== END {module}.h =====
- Implement all functions declared in the header (C99 only).
- If a function returns a status code and uses an out-parameter, validate pointers and return nonzero on error.
- No printing, no globals.
- If an ABI version function exists, return 0x{abi_hex} for version {abi_version}.
"""


# -------------------------- Helper functions --------------------------

def derive_guard(module: str) -> str:
    s = re.sub(r"[^A-Za-z0-9]", "_", module).upper()
    if not s.endswith("_H"):
        s += "_H"
    return s


def bullets_from_functions_prompt(fp: str, status_pattern: bool) -> str:
    """Turn raw prompt into bullet points, optionally enforcing status+out-param ABI style."""
    lines = [ln.strip() for ln in fp.splitlines() if ln.strip()]
    if not lines:
        lines = [fp.strip()]
    bullets = "\n".join(f"- {ln}" for ln in lines)
    if status_pattern:
        bullets += (
            "\n- Enforce the 'status code + out-params' pattern where possible: "
            "functions return int (0=OK, nonzero=ERR) and place outputs in caller-provided pointers/buffers."
        )
    return bullets


def parse_semver_hex(abi_version: str) -> str:
    """Encode MAJOR.MINOR.PATCH as 0x00MMmmpp (like 1.2.3 → 0x00010203)."""
    try:
        maj, minr, pat = (int(x) for x in abi_version.split(".", 2))
    except Exception:
        maj, minr, pat = (1, 0, 0)
    return f"{(maj<<16) | (minr<<8) | pat:08x}"


def _parse_symbols_from_header(header_text: str):
    """
    Simple regex-based C prototype parser.
    Extracts return type, name, and argument list.
    """
    rx = re.compile(
        r'^[ \t]*([A-Za-z_][\w \t\*]*?[ \t\*])'   # return type
        r'([A-Za-z_]\w*)'                          # name
        r'[ \t]*\(([^\)]*)\)[ \t]*;'               # args
        r'[ \t]*$', re.M)
    symbols = []
    for m in rx.finditer(header_text):
        ret = m.group(1).strip()
        name = m.group(2).strip()
        args = m.group(3).strip()
        if args in ("", "void"):
            arglist = []
        else:
            parts = [a.strip() for a in args.split(",")]
            cleaned = []
            for p in parts:
                toks = p.split()
                if len(toks) >= 2:
                    cleaned.append(" ".join(toks[:-1]))
                else:
                    cleaned.append(p)
            arglist = cleaned
        symbols.append({"name": name, "ret": ret, "args": arglist})
    return symbols


# -------------------------- Prompt builders --------------------------

def build_prompts(
    module: str,
    guard: str,
    functions_prompt: str,
    abi_version: str,
    status_pattern: bool,
) -> Dict[str, str]:
    hdr = HEADER_TEMPLATE.format(
        module=module,
        guard=guard,
        functions_bullets=bullets_from_functions_prompt(functions_prompt, status_pattern),
    )
    # source and manifest built later
    return {"header": hdr, "source": None, "manifest": None}


# -------------------------- Core generator --------------------------

def generate_abi_package(
    *,
    module: str,
    functions_prompt: str,
    abi_version: str = "1.0.0",
    out_dir: Path | str | None = None,
    model: str = DEFAULT_MODEL,
    guard: Optional[str] = None,
    status_pattern: bool = False,
) -> Path:
    """
    Core function: generates <module>.h, <module>.c, <module>.abi.json into out_dir.

    Returns the output directory path.
    """
    out = Path(out_dir or f"project/{module}.X")
    out.mkdir(parents=True, exist_ok=True)

    guard = guard or derive_guard(module)
    prompts = build_prompts(module, guard, functions_prompt, abi_version, status_pattern)

    # 1) Header
    generate_code_to_file(
        prompt=prompts["header"],
        out_path=str(out / f"{module}.h"),
        model=model,
        system_prompt=SYSTEM_ABI,
    )

    # 2) Source — inline header text so the model can’t ask for it
    header_text = (out / f"{module}.h").read_text(encoding="utf-8")
    abi_hex = parse_semver_hex(abi_version)
    source_prompt = SOURCE_TEMPLATE.format(
        module=module,
        header_text=header_text,
        abi_hex=abi_hex,
        abi_version=abi_version,
    )
    generate_code_to_file(
        prompt=source_prompt,
        out_path=str(out / f"{module}.c"),
        model=model,
        system_prompt=SYSTEM_SRC,
    )

    # 3) Manifest — derive directly from header
    symbols = _parse_symbols_from_header(header_text)
    manifest_obj = {
        "module": module,
        "abi_version": abi_version,
        "headers": [f"{module}.h"],
        "sources": [f"{module}.c"],
        "symbols": symbols,
        "memory_policy": "caller-alloc-out-buffers",
        "link": {
            "cflags": ["-std=c99", "-O3", "-Wall", "-Wextra"],
            "ldflags": []
        }
    }
    (out / f"{module}.abi.json").write_text(
        json.dumps(manifest_obj, indent=2), encoding="utf-8"
    )

    return out


# -------------------------- Smoke test emitter --------------------------

def emit_smoke_main(
    *,
    module: str,
    header_includes: Optional[list[str]] = None,
    example_body: Optional[str] = None,
    out_dir: Path | str | None = None,
) -> Path:
    """
    Optional helper: write project/<module>.X/main_<module>.c that includes <module>.h
    and calls the exported functions minimally—useful for quick build/link checks.
    """
    out = Path(out_dir or f"project/{module}.X")
    out.mkdir(parents=True, exist_ok=True)

    hdrs = header_includes or [f"{module}.h"]
    body = example_body or textwrap.dedent(f"""\
        unsigned int v = {module}_get_abi_version();
        (void)v;  // normally you'd assert or print
        return 0;
    """)
    src = (
        "#include <stdio.h>\n"
        + "\n".join(f"#include \"{h}\"" for h in hdrs)
        + "\n\nint main(void) {\n"
        + textwrap.indent(body, "    ")
        + "\n}\n"
    )
    p = out / f"main_{module}.c"
    p.write_text(src, encoding="utf-8")
    return p


# -------------------------- CLI --------------------------

def cli(argv: list[str] | None = None) -> int:
    ap = argparse.ArgumentParser(description="Generate a C ABI package (.h/.c/.abi.json)")
    ap.add_argument("--module", required=True, help="Module/package name (e.g., sq, x, y)")
    ap.add_argument("--functions-prompt", required=True, help="Describe the ABI functions & signatures")
    ap.add_argument("--abi-version", default="1.0.0", help="ABI version (default: 1.0.0)")
    ap.add_argument("--out-dir", help="Output dir (default: project/<module>.X)")
    ap.add_argument("--guard", help="Header guard (default: <MODULE>_H)")
    ap.add_argument("--model", default=DEFAULT_MODEL, help="Model (default from aiinterface)")
    ap.add_argument("--status-pattern", action="store_true", help="Enforce status+out-param style in header")
    ap.add_argument("--emit-smoke", action="store_true", help="Also emit a main_<module>.c for quick builds")
    ns = ap.parse_args(argv)

    out_dir = generate_abi_package(
        module=ns.module,
        functions_prompt=ns.functions_prompt,
        abi_version=ns.abi_version,
        out_dir=ns.out_dir,
        model=ns.model,
        guard=ns.guard,
        status_pattern=ns.status_pattern,
    )

    if ns.emit_smoke:
        emit_smoke_main(module=ns.module, out_dir=out_dir)

    print(f"[OK] Wrote ABI package → {Path(out_dir).resolve()}")
    print(f"     - {ns.module}.h")
    print(f"     - {ns.module}.c")
    print(f"     - {ns.module}.abi.json")
    if ns.emit_smoke:
        print(f"     - main_{ns.module}.c")

    return 0


if __name__ == "__main__":
    raise SystemExit(cli())
