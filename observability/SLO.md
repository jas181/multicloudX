# Service-level objectives

| Indicator | Objective | Error budget |
| --- | --- | --- |
| Availability | 99.9% successful requests in a rolling 30 days | 43m 50s unavailable/month |
| Latency | 95% of requests complete within 500ms | 5% may exceed threshold |
| Error rate | Fewer than 1% 5xx responses over 5 minutes | Alert at breach; page after 10 minutes |

Prometheus alert rules provide the operational signal; teams must attach their approved PagerDuty, email, Teams, or equivalent notification channel outside the repository. Dynatrace can ingest OpenTelemetry data through an OTLP endpoint, and Splunk can consume collector-exported logs/metrics using the Splunk HEC exporter after credentials are supplied through a secret manager.
