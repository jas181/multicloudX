# FinOps baseline

The FinOps baseline normalizes cloud exports into the fields `cloud`, account/subscription/project, environment, application, owner, cost center, monthly cost, utilization, and state. The included data is synthetic and never requires billing credentials.

```powershell
python finops/scripts/analyze_costs.py finops/sample-resources.csv finops/report.json
```

The report identifies running resources below 10% utilization and estimates 70% of their cost as potential savings; it is an investigation queue, not an automatic deletion list. Use `budgets.yaml` to create equivalent Azure Cost Management, AWS Budgets, and GCP Billing Budget notifications through approved cloud/account ownership processes.

Required resource metadata is already supplied by Terraform: `application`, `environment`, `owner`, `cost_center`, and `managed_by`. Enforce missing-tag exceptions through the existing OPA policy gate.
