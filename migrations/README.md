# Migration framework

This framework supports planning for Azure↔AWS, Azure↔GCP, and AWS↔GCP migrations. It does not impersonate AWS MGN/DMS, Azure Migrate, or Google migration APIs. Production adapters must be configured with real service endpoints, OIDC/workload identity, approval IDs, and audit logging.

Every migration follows: discovery → dependency mapping → assessment → target provisioning → replication → deployment → testing → approved cutover → validation → rollback readiness.
