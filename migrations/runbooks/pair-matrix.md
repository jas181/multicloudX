# Directional migration matrix

| Source → target | VM | PostgreSQL | Object storage | Kubernetes |
| --- | --- | --- | --- | --- |
| Azure → AWS | AWS MGN | AWS DMS/native replication | AzCopy/approved sync | AKS manifests → EKS |
| Azure → GCP | Azure Migrate/export | logical replication | Storage Transfer | AKS manifests → GKE |
| AWS → Azure | Azure Migrate | DMS/export | Data Box/AzCopy | EKS manifests → AKS |
| AWS → GCP | MGN/export | DMS/export | Storage Transfer | EKS manifests → GKE |
| GCP → AWS | AWS MGN | AWS DMS/native replication | Storage Transfer | GKE manifests → EKS |
| GCP → Azure | Azure Migrate/export | logical replication | Storage Transfer/AzCopy | GKE manifests → AKS |

Tool selection depends on source versions, downtime tolerance, network bandwidth, identity constraints, and contractual requirements. Perform a pilot and explicit rollback test for each application.
