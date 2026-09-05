# Phase 3 implementation plan

## 3A — private cluster foundations (this increment)

Create gated Terraform modules for AKS, EKS, and GKE with private control-plane endpoints, workload identity/IAM, managed node pools, policy integration where available, and encrypted/default cloud storage.

## 3B — workload baseline

Create a cloud-neutral Kubernetes baseline: namespace, ConfigMap, secret-provider reference, Deployment, Service, Ingress, HPA, PDB, probes, resource limits, NetworkPolicy, PVC, StorageClass, and Helm chart metadata. Validate manifests in CI without needing a cluster.

## Deployment conditions

Set `enable_phase3_kubernetes = true` only after private DNS, egress/NAT or approved private registry endpoints, IAM/OIDC, quotas, and cloud billing are reviewed. Do not apply all clouds simultaneously for a POC.
