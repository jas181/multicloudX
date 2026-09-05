# Spring Boot microservices

This Maven reactor provides `customer-service`, `order-service`, `payment-service`, and `notification-service`. Every service exposes `/health` and Spring Boot `/actuator/health`; actuator metrics are exposed at `/actuator/prometheus` when the Prometheus registry is added in Phase 5.

Customer service is configured for PostgreSQL, payment service for Redis, and order/notification for Kafka. Runtime connection settings come exclusively from environment variables or workload identity-backed secret injection—never committed values.

```powershell
cd applications
mvn verify
docker build -t multicloudx/customer-service:dev customer-service
```

Use Java 21 and Maven 3.9+. Dockerfiles expect `mvn package` to have produced each module's JAR.

## Local dependencies

Copy `.env.example` to an uncommitted `.env`, set a development-only PostgreSQL password, then start only backing services:

```powershell
docker compose up -d postgres redis kafka
```

Run services from separate terminals with `DATABASE_PASSWORD`, `REDIS_HOST`, and `KAFKA_BOOTSTRAP_SERVERS` environment variables as appropriate. The compose configuration is for local development only; production uses the private managed data services provisioned by Terraform.
