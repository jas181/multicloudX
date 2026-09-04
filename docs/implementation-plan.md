# Phase 1 implementation plan

1. Establish a Terraform root per environment with provider version pinning, required tags, approved regions, and no local state committed.
2. Implement small composable landing-zone and private-network modules for Azure, AWS, and GCP.
3. Wire the `dev` environment as a POC reference; use variable files to isolate `test`, `stage`, and `prod`.
4. Enforce guardrails with OPA policy tests, static-scanner configuration, and CI checks. No CI apply occurs except a manually dispatched, approval-gated development apply.
5. Document deployment, rollback, cost controls, assumptions, and the explicit Phase 2 boundary.

Success criteria: `terraform fmt`, `terraform init -backend=false`, `terraform validate`, and Conftest tests pass locally; cloud plans/applies remain credential-dependent and are not claimed as executed here.
