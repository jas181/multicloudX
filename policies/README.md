# Policy as code

Conftest evaluates Terraform plan JSON. Generate a plan and run `terraform show -json tfplan > plan.json; conftest test plan.json -p policies`. The included fixtures demonstrate an accepted encrypted/tagged resource and a rejected public database. CI runs policy unit fixtures; policy against real plans occurs in the plan job.
