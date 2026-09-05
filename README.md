# MultiCloudX

MultiCloudX is a deployable Phase 1 reference landing zone for Azure, AWS, and GCP. It provisions a small, private-network-first development foundation and validates policy before changes reach a cloud account.

## Phase 1 scope

- Environment-separated Terraform root configurations (`dev`, `test`, `stage`, `prod`)
- Reusable Azure, AWS, and GCP networking and landing-zone modules
- Private application and database subnets; databases are deliberately out of scope until Phase 2
- Encrypted centralized-log storage foundations, security baselines, tagging, and cost guardrails
- OPA/Conftest policy tests and GitHub Actions validation/scanning

This is intentionally not a production deployment. It creates chargeable networking and logging resources when applied. `prod` is never applied by CI; production must use an approved GitHub Environment and an explicit manual workflow dispatch.

## Implementation plan

See [docs/implementation-plan.md](docs/implementation-plan.md). The plan is deliberately limited to Phase 1.

## Quick start

Prerequisites: Terraform >= 1.7, Azure CLI, AWS CLI, gcloud CLI, Conftest, and optionally Checkov/Trivy/Semgrep for local security checks.

```powershell
# Authenticate only to the cloud(s) you will deploy.
az login
aws sso login --profile multicloudx-dev
gcloud auth application-default login

cd terraform/environments/dev
Copy-Item terraform.tfvars.example terraform.tfvars
terraform init -backend=false
terraform fmt -check -recursive ../..
terraform validate
terraform plan -out=tfplan
# Explicitly review then apply only the selected development configuration.
terraform apply tfplan
```

To use remote state, copy `backend.hcl.example`, configure a cloud-specific state backend, then run `terraform init -backend-config=backend.hcl -reconfigure`. Never commit `backend.hcl`, plans, or state.

## Authentication and deployment safety

- Azure: use `az login` locally; GitHub Actions uses Azure federated OIDC credentials.
- AWS: use AWS IAM Identity Center/role credentials locally; GitHub Actions uses `AssumeRoleWithWebIdentity`.
- GCP: use ADC locally; GitHub Actions uses Workload Identity Federation.
- `enabled_clouds` defaults to an empty set; explicitly enable only the clouds you intend to deploy.
- Production requires `environment = "prod"`, a reviewed variable file, GitHub Environment approval, and a manual `terraform apply` workflow dispatch.
- There is no automated `destroy` workflow.

## Validation

```powershell
terraform -chdir=terraform/environments/dev init -backend=false
terraform -chdir=terraform/environments/dev validate
conftest test policies/tests
checkov -d terraform
trivy config terraform
semgrep --config .semgrep.yml
```

## Costs and limits

The low-cost defaults avoid NAT gateways, VPN gateways, managed databases, and Kubernetes in Phase 1. Storage, logging, public IPs (if later enabled), and CloudTrail/monitoring retention can still incur charges. Apply one cloud at a time, configure budgets before deployment, and set `enabled_clouds` conservatively. See [finops/README.md](finops/README.md).

## What requires real cloud access

Terraform syntax, module wiring, policy tests, and static scans run without cloud credentials. `plan` and `apply` require valid subscriptions/accounts/projects, permissions, quotas, and globally unique resource-name suffixes. Organization, management-group, and folder administration stays opt-in because those operations require tenant-level authority.

## Phase 2

Add private compute, load balancing, encrypted object storage/data services, private endpoints, and cloud-native security-service enablement. Details are in [docs/phase-2-plan.md](docs/phase-2-plan.md).

Phase 2 is in progress. The first increment adds optional secure object-storage modules; see [the Phase 2 implementation plan](docs/phase-2-implementation-plan.md). It is disabled by default with `enable_phase2_storage = false`.

Phase 2B adds optional private PostgreSQL foundations with `enable_phase2_databases = false`. Never place database passwords in `terraform.tfvars`; inject them from an approved secret store or CI secret at deployment time.

Phase 2C adds optional private VMSS/ASG/MIG and internal load-balancer foundations with `enable_phase2_compute = false`. Enabling Azure requires an SSH public key; enabling AWS requires an approved AMI ID. No public IPs or public management ports are created by these modules.

Phase 2D adds optional cloud-native security services with `enable_phase2_security = false`. Review subscriptions, billing, regional availability, and organization-level permissions before enabling it.

Phase 3 is in progress. Private AKS, EKS, and GKE foundations are behind `enable_phase3_kubernetes = false`; see [the Phase 3 implementation plan](docs/phase-3-implementation-plan.md).

Phase 4 is in progress. The Spring Boot service reactor lives in [applications](applications); GitHub Actions builds, tests, containerizes, and scans it with Java 21.

Phase 5 observability foundations are in [observability](observability): OpenTelemetry Collector, Prometheus alerts, Grafana provisioning, and documented SLOs.

Phase 7 FinOps foundations are in [finops](finops): normalized cost data, budget threshold examples, tag controls, and an idle-resource savings report.

Phase 8 DR foundations are in [dr](dr): an AWS-primary/Azure-secondary scenario, RTO/RPO targets, and approved-manual failover/failback runbooks.

Phase 9 migration foundations are in [migrations](migrations): cross-cloud planning adapters, workload runbooks, and a six-direction migration matrix.
