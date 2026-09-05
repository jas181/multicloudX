# Disaster recovery

The reference scenario is AWS primary with Azure secondary. It defines a 60-minute RTO and 15-minute RPO; these are targets to test, not guarantees. Read the [failover/failback runbook](runbooks/aws-primary-azure-secondary.md) and validate the scenario before an exercise:

```powershell
python dr/scripts/validate_scenario.py dr/scenarios/aws-primary-azure-secondary.yaml
```

No automated DR, DNS cutover, database restoration, or traffic switching is implemented. Every production DR event requires a declared incident, approvals, data-integrity checks, and a recorded recovery outcome.
