#!/usr/bin/env python3
"""Guarded migration-plan adapter; intentionally makes no cloud API calls."""
import sys
from pathlib import Path

SUPPORTED = {("azure", "aws"), ("azure", "gcp"), ("aws", "azure"), ("aws", "gcp"), ("gcp", "aws"), ("gcp", "azure")}

def main(plan: Path) -> None:
    body = plan.read_text(encoding="utf-8")
    source = next((c for c in ("azure", "aws", "gcp") if f"source: {c}" in body), None)
    target = next((c for c in ("azure", "aws", "gcp") if f"target: {c}" in body), None)
    if (source, target) not in SUPPORTED or "approval_required: true" not in body:
        raise SystemExit("plan must be an approved supported cross-cloud migration")
    print(f"validated migration plan: {source} -> {target}; no cloud operation executed")

if __name__ == "__main__":
    if len(sys.argv) != 2: raise SystemExit("usage: migration_adapter.py PLAN.yaml")
    main(Path(sys.argv[1]))
