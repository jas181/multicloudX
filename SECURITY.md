# Security

Report vulnerabilities privately to the repository maintainers; do not open public issues containing exploit details or credentials. Never commit cloud credentials, state, plans, private keys, or `.env` files. CI is designed for OIDC/WIF federation and least-privilege roles only.

The enforced checks and release policy are documented in [security-release-gate.md](docs/security-release-gate.md). Never suppress a scanner finding by changing a policy without a reviewed exception and expiry.
