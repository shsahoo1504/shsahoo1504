# Cleanup

Clean up only `demo-check-service`, after recording test evidence. Use a reviewed branch and pull request for GitOps changes.

## 1. Remove GitOps desired state

In a branch of the GitOps repository:

```bash
git switch -c cleanup/demo-check-service
git rm -r apps/demo-check-service
git commit -m "Remove demo check service"
git push -u origin HEAD
```

Open and review a cleanup PR. It must remove only `apps/demo-check-service/`. Merge it and record the merge commit SHA.

## 2. Verify Argo CD pruning

```bash
kubectl get applications -n argocd
kubectl get deployment,service,pods -n buildin10 \
  -l app.kubernetes.io/name=demo-check-service
```

There must be no generated Application or matching Kubernetes resource. Diagnose ApplicationSet/controller state before any manual deletion. Do not create a duplicate Application.

## 3. Unregister Backstage

Use the catalog unregister action for `demo-check-service`. If it was registered through a distinct catalog location, unregister that location too. Verify the entity no longer appears or refreshes into the catalog.

## 4. Remove GitHub resources

Delete only:

- `YOUR_ORG/demo-check-service`;
- its temporary GHCR package and versions;
- stale scaffolder-created branches, if any;
- stale test pull request, if unmerged.

Use the GitHub UI or appropriately permissioned CLI/API calls. Review the resource name immediately before every destructive operation.

## 5. Final assertions

```bash
kubectl get applications -n argocd
kubectl get deployment,service,pods -n buildin10 \
  -l app.kubernetes.io/name=demo-check-service
gh repo view YOUR_ORG/demo-check-service
gh api /orgs/YOUR_ORG/packages/container/demo-check-service
```

The last two commands must report that the resources do not exist. Also verify:

- `apps/demo-check-service` is absent from GitOps `main`;
- Backstage no longer lists the component or location;
- no open or unmerged test pull request/branch remains;
- Payments and Orders services are unchanged.
