# Kubernetes and Argo CD

## Create the KIND cluster

Review `infra/kind-config.yaml`, then run:

```bash
./scripts/02-create-kind.sh
kubectl wait --for=condition=Ready nodes --all --timeout=300s
kubectl get nodes -o wide
```

The configuration creates one control-plane and two worker nodes.

## Install Argo CD

```bash
./scripts/03-install-argocd.sh
kubectl get pods -n argocd
```

The script installs Argo CD 3.6.1 and waits for workloads. For private local access, start a deliberate port-forward:

```bash
kubectl -n argocd port-forward svc/argocd-server 8081:443
```

Retrieve the initial password only when needed:

```bash
kubectl -n argocd get secret argocd-initial-admin-secret \
  -o jsonpath='{.data.password}' | base64 --decode
```

Change it immediately and do not record it in project files.

## Configure the project and ApplicationSet

Publish this repository's `gitops/` content as the `gitops` repository in your organization. Replace `YOUR_GITHUB_ORG` in the manifests first.

```bash
kubectl apply -f gitops/platform/appproject.yaml
kubectl apply -f gitops/platform/applicationset.yaml
kubectl get appprojects,applicationsets -n argocd
```

The ApplicationSet watches `apps/*`. When a GitOps path is merged, Argo CD generates an Application. Removing the path allows Argo CD pruning to remove the generated application resources.

## Configure Backstage Kubernetes access

```bash
kubectl apply -f infra/backstage-rbac.yaml
```

Validate the nine required resource/verb checks:

```bash
./scripts/verify-backstage-rbac.sh
```

Every check must return `yes`. The service account is read-only; it must not receive write access.
