#!/usr/bin/env python3
"""Create a deterministic FinOps report from normalized CSV export data."""
import csv
import json
import sys
from collections import defaultdict
from pathlib import Path

REQUIRED = {"cloud", "account_or_project", "environment", "application", "owner", "cost_center", "resource_type", "resource_id", "monthly_cost", "utilization_percent", "state"}

def main(source: Path, destination: Path) -> None:
    with source.open(newline="", encoding="utf-8") as handle:
        rows = list(csv.DictReader(handle))
    if not rows or not REQUIRED.issubset(rows[0]):
        missing = sorted(REQUIRED - set(rows[0] if rows else []))
        raise ValueError(f"CSV missing required columns: {', '.join(missing)}")
    totals = defaultdict(float)
    findings = []
    for row in rows:
        cost = float(row["monthly_cost"])
        utilization = float(row["utilization_percent"])
        totals[row["cloud"]] += cost
        if row["state"].lower() == "running" and utilization < 10:
            findings.append({"resource": row["resource_id"], "cloud": row["cloud"], "reason": "under 10% utilization", "estimated_monthly_savings_usd": round(cost * 0.7, 2)})
    report = {"monthly_cost_by_cloud_usd": {key: round(value, 2) for key, value in sorted(totals.items())}, "idle_or_oversized_resources": findings, "estimated_monthly_savings_usd": round(sum(item["estimated_monthly_savings_usd"] for item in findings), 2)}
    destination.parent.mkdir(parents=True, exist_ok=True)
    destination.write_text(json.dumps(report, indent=2) + "\n", encoding="utf-8")

if __name__ == "__main__":
    if len(sys.argv) != 3:
        raise SystemExit("usage: analyze_costs.py INPUT.csv OUTPUT.json")
    main(Path(sys.argv[1]), Path(sys.argv[2]))
