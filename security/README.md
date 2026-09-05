# Security baseline

Baseline controls: encrypted AWS log storage, GCP public-access prevention, Azure NSG internet-ingress denial, AWS VPC flow logs, GCP audit log sink, private app/data subnets, required resource metadata, and static policy checks. Cloud Defender/GuardDuty/Security Command Center activation needs organization-level design and is scheduled for Phase 6.

Phase 2D provides optional POC enablement via `enable_phase2_security`. It enables Azure Defender for Servers Standard and subscription alert contact, AWS GuardDuty and Security Hub, plus GCP Security Command Center and Cloud Asset APIs. Review costs and security ownership first. SCC organization-tier enrollment, findings exports, notification destinations, and organization policy management require separate, explicitly authorized organization-level configuration.
