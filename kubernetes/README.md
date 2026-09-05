# Kubernetes baseline

Apply the base only after installing a supported ingress controller, metrics-server, a CSI driver, and an external secret provider. `platform-runtime` is intentionally referenced but not created: populate it using Azure Key Vault CSI, AWS Secrets Manager/External Secrets, or GCP Secret Manager/External Secrets. Do not commit Kubernetes Secret manifests.

The sample container is a temporary non-root workload validating platform controls, not the Phase 4 Java application. It expects private ingress and intentionally denies ingress traffic by default; add narrowly scoped NetworkPolicies when the real service topology is defined.

```powershell
kubectl apply -k kubernetes/base
```

Use the matching cloud overlay to supply the CSI-backed encrypted storage class:

```powershell
kubectl apply -k kubernetes/overlays/azure
helm lint kubernetes/charts/platform-sample
```

Read [secret provider integration](docs/secret-providers.md) before deploying a workload that needs credentials.
