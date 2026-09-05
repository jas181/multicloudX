# DR pair matrix

| Primary | Secondary | Reference restoration path |
| --- | --- | --- |
| Azure | AWS | PostgreSQL logical backup/restore, object synchronization, EKS deployment |
| AWS | GCP | RDS export/restore, S3-to-GCS synchronization, GKE deployment |
| GCP | Azure | Cloud SQL export/restore, GCS-to-Azure Blob synchronization, AKS deployment |

Each path needs its own tested replication tooling, identity permissions, DNS cutover plan, and change approval. These are runbook patterns—not automated failover implementations.
