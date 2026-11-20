# Security

## Reporting

Do not include real credentials, private infrastructure details, or production secrets in a report. Replace them with minimal reproductions.

## Demo boundaries

This repository is a learning environment, not production infrastructure. KIND, the public sample packages, and simplified Backstage access are suitable only for isolated demonstrations.

Before production use:

- use managed or independently hardened Kubernetes;
- enable TLS and identity-aware access;
- replace shared tokens with scoped GitHub Apps/workload identity;
- use private image registries and namespace-scoped pull secrets where required;
- encrypt secrets with an approved external secret manager;
- apply network policies, Pod Security, audit logging, and supply-chain controls;
- pin and continuously update dependencies and actions;
- protect main branches and require review.
