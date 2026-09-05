#!/usr/bin/env python3
"""Validate that a DR scenario has explicit objectives and does not claim automation."""
import sys
from pathlib import Path

def main(path: Path) -> None:
    text = path.read_text(encoding="utf-8")
    required = ["rto_minutes:", "rpo_minutes:", "primary:", "secondary:", "automation: none"]
    missing = [item for item in required if item not in text]
    if missing:
        raise SystemExit("invalid DR scenario, missing: " + ", ".join(missing))
    print(f"DR scenario validated: {path.name}")

if __name__ == "__main__":
    if len(sys.argv) != 2:
        raise SystemExit("usage: validate_scenario.py SCENARIO.yaml")
    main(Path(sys.argv[1]))
