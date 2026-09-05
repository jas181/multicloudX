# AWS primary → Azure secondary DR runbook

## Preconditions

- Confirm the declared RTO of 60 minutes and RPO of 15 minutes remain approved.
- Confirm Azure standby infrastructure is provisioned, private DNS works, and the Kubernetes image/artifact is available in the approved registry.
- Verify the most recent RDS backup/logical export and object-replication checkpoint. Do not start a DR event if backup integrity is unknown.

## Failover

1. Incident commander declares a DR event and records the time, scope, and approved change ticket.
2. Freeze AWS writes or fence the primary application to prevent split brain.
3. Restore/import the approved PostgreSQL recovery point into Azure PostgreSQL Flexible Server; record the recovered timestamp against the RPO.
4. Verify object-data synchronization and integrity checks.
5. Deploy the known-good image/version to Azure AKS using the approved, reviewed manifest.
6. Run smoke tests: `/health`, database connectivity, critical read/write flow, and telemetry delivery.
7. With incident-commander approval, update the private/global traffic-management target to Azure. Monitor errors, latency, and replication lag.

## Failback

1. Stabilize AWS and provision a clean recovery target; never reconnect the original primary without confirming it is fenced.
2. Replicate/export data from Azure to AWS, validate reconciliation, and agree a write-freeze window.
3. Deploy and smoke-test AWS before switching traffic back through the same approval process.
4. Restore normal backup/replication schedules, document actual RTO/RPO, and hold a DR review.

## Rollback

Before traffic cutover, retain the previous traffic target and recovery artifacts. If Azure smoke tests fail, keep traffic fenced or directed to the last verified healthy target; do not switch traffic merely to meet an elapsed-time target.
