# Buildin10 GitOps

This directory is intended to become its own `gitops` repository.

- `platform/appproject.yaml` limits applications to the intended repository and namespace.
- `platform/applicationset.yaml` creates one Argo CD Application per `apps/*` directory.
- `apps/payments-api` and `apps/orders-api` represent the baseline workloads.
- A scaffolded service is added through a pull request and removed through a cleanup pull request.

Replace `YOUR_GITHUB_ORG`, validate changes in a pull request, and merge reviewed desired state. Argo CD automated sync, prune, and self-heal remain enabled for the learning environment.
