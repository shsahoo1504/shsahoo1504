# Architecture

Buildin10 separates the developer experience, source control, delivery pipeline, desired state, and runtime.

```text
Developer
   |
   v
Backstage ---- catalog providers ----> GitHub catalog/templates repositories
   |
   +---- software template ----> service repository
   |                                 |
   |                                 v
   |                          GitHub Actions
   |                                 |
   |                                 v
   |                               GHCR
   |
   +---- GitOps pull request ---> GitOps repository
                                      |
                                      v
                                    Argo CD
                                      |
                                      v
                                    Kubernetes
                                      |
Backstage <---- read-only service account ----+
```

## Responsibilities

- **Backstage**: discover components/APIs, display ownership and documentation, run software templates, register catalog entities, and query Kubernetes read-only.
- **GitHub**: store service and platform repositories, provide pull-request workflows, and host actions.
- **GitHub Actions**: test services and publish OCI images to GHCR using the workflow token.
- **GHCR**: store the built service images. Demo packages may be public; production packages should usually be private.
- **GitOps repository**: contain declarative Kubernetes manifests and create an auditable deployment review.
- **Argo CD ApplicationSet**: generate one Application for each `apps/*` directory and reconcile it.
- **KIND/Kubernetes**: provide the isolated demo runtime.

## Trust boundaries and credentials

Backstage needs a GitHub token for repository creation and pull requests. GitHub Actions uses a repository-scoped `GITHUB_TOKEN` for package publication. Kubernetes and Argo CD credentials remain separate. Use environment variables or a secret manager and do not store credential values in this repository.

## Key conventions

- A service name becomes the GitHub repository name.
- New scaffolded services use `lifecycle: experimental`.
- Team ownership is represented by Group entities of `spec.type: team`.
- Kubernetes discovery uses `app.kubernetes.io/name=<service-name>`.
- Existing `app=<service-name>` labels/selectors remain for compatibility.
- The template has one parameter page and six ordered steps.
