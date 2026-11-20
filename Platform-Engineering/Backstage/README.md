# Buildin10 Internal Developer Platform

This repository shows how to build a complete Internal Developer Platform with Backstage, GitHub, GitHub Actions, GHCR, Argo CD, and Kubernetes.

The demonstration follows the complete developer path:

**Developer → Backstage → GitHub → GitHub Actions → GHCR → GitOps → Argo CD → Kubernetes**

## Why build this platform

Developers need one place to discover services, understand ownership, create repositories, deploy applications, and inspect Kubernetes without learning every underlying tool.

Buildin10 demonstrates that experience by putting Backstage at the front of the workflow while GitHub, GitHub Actions, GHCR, Argo CD, and Kubernetes handle the delivery lifecycle.

## Architecture

This is the exact platform you will build and showcase in the walkthrough:

![What we build: the complete Buildin10 developer platform architecture](docs/images/buildin10-architecture.png)

The diagram explains where every responsibility lives:

- **Developer and Backstage** — discover services and start self-service creation.
- **GitHub** — stores the catalog, templates, application source, and GitOps repositories.
- **GitHub Actions and GHCR** — build the service and publish its container image.
- **Argo CD** — watches the merged GitOps desired state and reconciles it into the cluster.
- **Kubernetes** — runs the Deployments, Services, and pods.
- **Backstage Kubernetes view** — reads the deployed workloads so developers can see runtime status from the same portal.

## Video

- [Buildin10: Build a Complete Internal Developer Platform with Backstage](https://youtu.be/nGtywbBn7Xo)

## What this demo teaches

- how developers discover services, APIs, ownership, and dependencies in Backstage
- how a Backstage software template creates a service repository
- how GitHub Actions builds and publishes container images to GHCR
- how pull requests introduce Kubernetes desired state through GitOps
- how Argo CD deploys and prunes applications
- how Backstage displays Kubernetes workloads with read-only access
- how to test and clean up the complete workflow safely

## Repository contents

- [`docs/`](docs/) — architecture and step-by-step reproduction guides
- [`scripts/`](scripts/) — host, KIND, Argo CD, RBAC, and validation scripts
- [`infra/`](infra/) — KIND and Backstage Kubernetes access manifests
- [`catalog/`](catalog/) — teams, systems, components, APIs, and OpenAPI example
- [`services/`](services/) — reference Payments and Orders Node.js services
- [`templates/`](templates/) — the six-step Backstage software template
- [`gitops/`](gitops/) — ApplicationSet and sample application manifests
- [`config/`](config/) — safe Backstage and systemd configuration examples

## How to use

1. Read the [architecture](docs/01-architecture.md) and [prerequisites](docs/02-prerequisites.md).
2. Prepare a disposable Ubuntu 24.04 VM with the [host guide](docs/03-host-and-tools.md).
3. Install KIND and Argo CD with the [platform guide](docs/04-kubernetes-and-argocd.md).
4. Publish the five supporting repository examples from the source directories:
   - `catalog`
   - `payments-api`
   - `orders-api`
   - `gitops`
   - `templates`
5. Configure Backstage using the [setup guide](docs/06-backstage-setup.md).
6. Follow the complete [developer journey](docs/07-developer-journey.md).
7. Record evidence with the [end-to-end checklist](docs/08-e2e-test.md).
8. Remove only the temporary service with the [cleanup guide](docs/09-cleanup.md).

## Reference versions

- Ubuntu 24.04.5 LTS
- KIND 0.33.0
- Argo CD 3.6.1
- Node.js 24
- Yarn 4.4.1

The original VM was observed with 32 GiB RAM and 630 GiB disk. These are reference observations, not required provider specifications. Choose capacity based on expected builds, container cache, and concurrent demos.

## Validate locally

```bash
./scripts/validate-local.sh
```

The project is not connected to a live environment. It contains no credentials and does not log in, deploy, or delete remote resources on its own.

## Safety

- Never commit passwords, tokens, private keys, or `.env` files.
- Use a dedicated learning VM; KIND is not a production control plane.
- Replace every `YOUR_*` placeholder before publishing the examples.
- Review every pull request and deployment manifest.
- Cleanup must target `demo-check-service` only.
- Do not create the separate recording service `order-tracking-service` as part of this demo.

## References

- [Backstage](https://backstage.io/docs/)
- [Argo CD ApplicationSets](https://argo-cd.readthedocs.io/en/stable/operator-manual/applicationset/)
- [KIND](https://kind.sigs.k8s.io/)
- [GitHub Container Registry](https://docs.github.com/packages/working-with-a-github-packages-registry/working-with-the-container-registry)

## Connect

- [LinkedIn](https://www.linkedin.com/in/shubham-s-sahoo/)
- [Linktree](https://linktr.ee/1504shubham)
- [Mentoring](https://topmate.io/shubham_suraj_sahoo)
- [Support](https://www.buymeacoffee.com/1504shubhaq)
