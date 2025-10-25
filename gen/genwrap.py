#!/usr/bin/env python3
"""
genwrap.py — YAML-driven wrapper for generate_abi_package()

Reads a file like coderequests.ai (YAML) and calls generate_abi_package()
with a composed functions_prompt.

Example:
  python genwrap.py --prompt-file coderequests.ai
  python genwrap.py --prompt-file coderequests.ai --module sq --emit-smoke
"""

from __future__ import annotations
import argparse, json, sys
from pathlib import Path

try:
    import yaml  # PyYAML
except Exception as e:
    print("ERROR: PyYAML is required. Try: pip install pyyaml", file=sys.stderr)
    raise

# Import your library-first generator from genmod.py
from genmod import generate_abi_package, emit_smoke_main

def load_prompt_file(path: Path) -> dict:
    with path.open("r", encoding="utf-8") as f:
        return yaml.safe_load(f)

def build_functions_prompt(data: dict) -> str:
    """
    Expect structure:
      functions:
        - signature: "int sq_square(int in, int* out);"
          description: "Compute the square of 'in' into *out."
        - signature: "unsigned int sq_get_abi_version(void);"
          description: "Return ABI version 0x00010000."
    """
    funcs = data.get("functions") or []
    if not funcs:
        raise ValueError("YAML must contain a top-level 'functions' list.")
    lines = []
    for f in funcs:
        sig = f.get("signature")
        desc = f.get("description", "").strip()
        if not sig:
            raise ValueError("Each function needs a 'signature'.")
        # Compose: "<signature> // <description>"
        if desc:
            lines.append(f"{sig} // {desc}")
        else:
            lines.append(sig)
    return "\n".join(lines)

def main(argv=None) -> int:
    ap = argparse.ArgumentParser(description="YAML wrapper for genmod.generate_abi_package()")
    ap.add_argument("--prompt-file", required=True, help="YAML file describing functions (e.g., coderequests.ai)")
    ap.add_argument("--module", help="Override module name (else read from YAML or infer)")
    ap.add_argument("--abi-version", help="Override ABI version (else read from YAML or default 1.0.0)")
    ap.add_argument("--guard", help="Override header guard")
    ap.add_argument("--out-dir", help="Output directory (default: project/<module>.X)")
    ap.add_argument("--status-pattern", action="store_true", help="Force status+out-param style in header")
    ap.add_argument("--emit-smoke", action="store_true", help="Emit main_<module>.c test file")
    ns = ap.parse_args(argv)

    pf = Path(ns.prompt_file)
    data = load_prompt_file(pf)

    # Pull optional fields from YAML (can be overridden by CLI)
    module = ns.module or data.get("module") or "m"
    abi_version = ns.abi_version or data.get("abi_version") or "1.0.0"
    guard = ns.guard or data.get("guard")
    out_dir = ns.out_dir or data.get("out_dir")
    status_pattern = ns.status_pattern or bool(data.get("status_pattern", False))

    functions_prompt = build_functions_prompt(data)

    out = generate_abi_package(
        module=module,
        functions_prompt=functions_prompt,
        abi_version=abi_version,
        out_dir=out_dir,
        guard=guard,
        status_pattern=status_pattern,
    )

    if ns.emit_smoke or data.get("emit_smoke"):
        emit_smoke_main(module=module, out_dir=out)

    print(f"[OK] Generated in: {out.resolve()}")
    print(f"     - {module}.h")
    print(f"     - {module}.c")
    print(f"     - {module}.abi.json")
    if ns.emit_smoke or data.get("emit_smoke"):
        print(f"     - main_{module}.c")
    return 0

if __name__ == "__main__":
    raise SystemExit(main())
