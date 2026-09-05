# Observability

This Phase 5 foundation uses OpenTelemetry Collector for OTLP ingestion, Prometheus for metrics, and Grafana for dashboards. The collector config exports metrics on port `8889`; configure the collector's production exporters with secret-injected vendor endpoints only.

The Java services already expose Actuator health and metrics endpoints. Add the Prometheus registry and Micrometer OpenTelemetry bridge in the Java build before enabling scrape annotations in a real cluster. See [SLO.md](SLO.md) for objectives and error-budget policy.

For a local platform-only stack:

```powershell
docker compose -f observability/compose.yaml up -d
```

Grafana is available on port 3000 and Prometheus on port 9090. Configure local Grafana credentials interactively; no default credentials are committed.
