# Backstage Setup

This repository supplies configuration examples rather than a prebuilt Backstage distribution. Start a standard Backstage application with the Backstage `create-app` path supported by your chosen Backstage release, then apply the plugins and configuration described below.

## Required plugins

Enable and configure:

- Software Catalog;
- Scaffolder;
- GitHub integration and publisher;
- TechDocs (local/built-in generation is adequate for the demo);
- Kubernetes plugin.

Use versions compatible with the same Backstage release rather than mixing independently selected packages.

## Configuration

Use [`config/app-config.example.yaml`](../config/app-config.example.yaml) as a reviewed starting point. Replace every `YOUR_*` placeholder and provide secrets through environment variables:

```bash
export GITHUB_TOKEN='set-in-secret-manager-or-terminal'
export BACKSTAGE_APP_BASE_URL='http://YOUR_VM_IP:3000'
export BACKSTAGE_BACKEND_BASE_URL='http://YOUR_VM_IP:7007'
```

Register:

- the catalog location;
- the template location;
- `fulfilment` as the system;
- `team-orders` as a `Group` with `spec.type: team`;
- the Payments and Orders components/APIs.

## Kubernetes authentication

Create a local kubeconfig containing the KIND cluster, then give the Backstage backend access to the `backstage-k8s-reader` service account. Production deployments should use workload-appropriate identity rather than copying administrator kubeconfig credentials.

The RBAC definitions grant only get/list/watch access required for the visible resource types, including `limitranges`, `resourcequotas`, and `horizontalpodautoscalers`.

## Template contract

Verify the template before use:

1. one parameter page;
2. name, description, owner, and system parameters;
3. `OwnerPicker` filters to Groups where `spec.type=team`;
4. no repository picker;
5. repository URL derives from `parameters.name`;
6. exactly six steps: `fetchService`, `fetchWorkflow`, `publishService`, `fetchGitOps`, `openGitOpsPR`, `registerService`;
7. generated services use `lifecycle: experimental`;
8. generated Kubernetes objects include both compatibility and discovery labels.

## systemd

Use [`config/buildin10-backstage.service`](../config/buildin10-backstage.service) after adapting its environment file and executable path. Do not put credentials directly in the unit:

```bash
sudo cp config/buildin10-backstage.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable --now buildin10-backstage
sudo systemctl status buildin10-backstage --no-pager
```
