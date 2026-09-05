# Secret-provider integration

The workload references `platform-runtime` / `database-url` but does not create the secret. Populate it from the cloud-native secret manager after the cluster and its workload identity are configured:

- AKS: Azure Key Vault Provider for Secrets Store CSI Driver, using a user-assigned or workload identity with `Key Vault Secrets User` on the target vault.
- EKS: External Secrets Operator or Secrets Store CSI Driver with IRSA; grant the service account narrowly scoped `secretsmanager:GetSecretValue` access.
- GKE: External Secrets Operator or Secrets Store CSI Driver with Workload Identity; grant the Kubernetes service account only `secretmanager.versions.access` on the named secret.

Use a cloud-specific `SecretProviderClass`/ExternalSecret in the target overlay, never a committed `kind: Secret` containing values. Validate rotation behavior and namespace/RBAC boundaries before production use.
