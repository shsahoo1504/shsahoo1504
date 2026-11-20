# Troubleshooting

## Template repository has the wrong name

Stop before image deployment. Confirm `publish:github` uses:

```yaml
repoUrl: github.com?owner=YOUR_ORG&repo=${{ parameters.name }}
```

There must be no separate repository picker.

## Workflow cannot publish to GHCR

Verify repository or organization Actions settings, `permissions.packages: write`, and that the workflow uses `ghcr.io` with `github.actor` and `secrets.GITHUB_TOKEN`. Diagnose visibility separately; workflow authentication does not imply public pull access.

## Application not generated

Inspect the merged GitOps path, ApplicationSet resource, generator status, and `applicationset-controller` logs. Do not manually create a duplicate Application.

## Pods cannot pull the image

Inspect the pod events:

```bash
kubectl describe pod -n buildin10 -l app.kubernetes.io/name=demo-check-service
```

Confirm the exact image tag exists and package visibility/authentication matches the cluster. Public package access is a test convenience; private images require a namespace-scoped pull secret.

## Kubernetes plugin returns 403

Run `scripts/verify-backstage-rbac.sh` and inspect the Backstage logs. The ClusterRole must include the required resource and verb. Recheck the ClusterRoleBinding subject namespace/name rather than granting cluster-admin.

## Resources remain after GitOps cleanup

Confirm the cleanup commit removed the generator directory and that Argo CD Applications auto-delete synchronization/pruning is enabled. Inspect Argo CD controller and ApplicationSet logs before manually removing any resource.
