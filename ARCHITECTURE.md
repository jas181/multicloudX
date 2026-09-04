# Architecture

## Phase 1 topology

```text
Azure: Hub VNet ── peering-ready spokes (app, data)
AWS:   VPC ── public (reserved), private-app, private-db subnets
GCP:   VPC ── app and data subnets (Shared VPC-ready)
             │
      encrypted logging / monitoring foundations
```

Each cloud uses non-overlapping CIDRs, private application/data tiers, flow/logging baselines, tags/labels, and a separately named environment. Public database exposure is prohibited by policy. NAT, site-to-site VPN, Kubernetes, compute, and databases are deferred to later phases to minimize POC cost and avoid partial implementations.

## Decisions

| Decision | Rationale |
| --- | --- |
| One Terraform root per environment | Separates state, blast radius, and promotion inputs. |
| Separate cloud modules | Keeps provider-specific semantics explicit while retaining a consistent module contract. |
| Optional organization resources | Management groups, AWS Organizations, and GCP folders require exceptional tenant privileges. |
| OIDC/WIF over stored secrets | Avoids long-lived CI credentials. |
| No automated destroy or prod apply | Makes destructive and production actions explicit. |

## Connectivity roadmap

Phase 1 reserves non-overlapping address space. Phase 2/6 will add Azure VPN Gateway, AWS Transit Gateway/VPN, and GCP Cloud VPN using separately supplied peer addresses and shared secrets from secret managers. Enterprise deployments should replace POC VPN tunnels with ExpressRoute, Direct Connect, or Cloud Interconnect.

## Rollback

Before apply, retain the reviewed plan and the prior variable file in approved artifact storage. For a failed apply, correct configuration and re-apply; do not use `destroy` as rollback. Resource removal requires a separately approved, manually run destroy plan.
