# Multi-Cloud Command Center

The Phase 10 API provides a minimal command-center view backed by safe mock data. It deliberately does not trigger Terraform, deployments, migration tools, or cloud APIs. Its OpenAPI documentation is at `/docs`.

```powershell
python -m venv .venv
.\.venv\Scripts\Activate.ps1
pip install -r requirements.txt
uvicorn app.main:app --port 8080
```

Live data adapters must use workload identity/OIDC, read-only cloud roles where possible, audit logging, input validation, and explicit approvals for state-changing automation.
