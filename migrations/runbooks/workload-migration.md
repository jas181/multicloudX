# Workload migration runbook

## VM

Inventory OS, disks, network dependencies, licenses, and recovery requirements. Use AWS Application Migration Service, Azure Migrate, or Google migration tooling where appropriate. Validate boot, private addressing, IAM, monitoring, and rollback before cutover.

## PostgreSQL

Assess version/extensions, size, encryption, network reachability, and downtime tolerance. Provision a private target first. Use DMS/native logical replication where supported; reconcile row counts/checksums, freeze writes, then promote only with explicit approval.

## Object storage

Inventory versioning, retention/legal hold, encryption keys, ACLs, and lifecycle rules. Synchronize, validate object count/checksums and metadata, freeze writes, perform a delta sync, then redirect clients.

## Kubernetes

Export declarative manifests/Helm values, rebuild images in the approved target registry, map secrets through the target secret manager, deploy to an isolated namespace, and validate probes/network policies/PVC migration before DNS or traffic cutover.
