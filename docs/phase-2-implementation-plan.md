# Phase 2 implementation plan

## 2A — storage security baseline (this increment)

1. Add cloud-specific storage modules with encryption, public-access denial, resource metadata, and Azure private endpoint/DNS wiring.
2. Gate creation behind `enable_phase2_storage`; it defaults to `false` to avoid unreviewed charges.
3. Validate syntax and retain Phase 1 policy/CI gates.

## 2B — private data services (this increment)

Add PostgreSQL subnet delegation/subnet groups, private DNS, secret-manager references, backups, and parameter guardrails. Database resources require the explicit `enable_phase2_databases` flag. AWS uses RDS-managed Secrets Manager credentials; Azure requires a password supplied through an approved secret-injection mechanism; GCP instance administration is deferred to workload identity/database-user setup.

## 2C — compute and traffic (this increment)

Add hardened VM/EC2/Compute Engine templates, autoscaling/MIG/VMSS, health checks, and internal load balancers. No public management ports will be introduced. Creation is gated by `enable_phase2_compute`; Azure needs an SSH public key and AWS needs an approved AMI ID.

## 2D — cloud-native security (this increment)

Add opt-in Defender, GuardDuty/Security Hub, and Security Command Center enablement after permissions and billing ownership are confirmed. `enable_phase2_security` enables Defender for Servers pricing/contact, GuardDuty, Security Hub, and the GCP Security Command Center API. Organization-wide SCC tiers, findings export, and notifications require explicit organization-level authority and remain intentionally outside this project-level POC.

Each increment requires a reviewed plan, cost check, rollback procedure, and cloud execution before Kubernetes work starts.

### Phase 2C deployment notes

Use approved image baselines only. Azure VMSS uses Ubuntu 22.04 LTS and an SSH public key; AWS requires an explicit AMI ID; GCP uses the Debian 12 family image with OS Login enabled. Internal health checks expect `GET /health` on port `8080`. The sample bootstrap does not install an application, so a real deployment must supply an image/bootstrap that serves that endpoint before registering workloads in the load balancers.
