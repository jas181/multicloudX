# Security release gate

Every pull request must pass Terraform formatting/validation, Conftest policy tests, Checkov, Semgrep, Trivy configuration scanning, Maven unit tests, container image scanning, Kubernetes schema validation, and OWASP dependency scanning.

Block a release for any unapproved critical/high finding, policy denial, secret exposure, failed test, or unreviewed infrastructure plan. Remediation exceptions must have an owner, expiry date, compensating control, and a tracked issue. Production requires an approved GitHub Environment and reviewed artifact/plan; no destructive operation is part of CI.
