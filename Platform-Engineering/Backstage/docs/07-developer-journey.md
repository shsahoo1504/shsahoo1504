# Developer Journey

This is the intended user-visible workflow after the platform baseline is working.

## 1. Discover the Payments API

In Backstage:

1. Open the Software Catalog.
2. Find `payments-api`.
3. Confirm owner `team-orders` and system `fulfilment`.
4. Open `payments-rest` to inspect its OpenAPI definition.
5. Open the runbook/TechDocs page.
6. Open the Kubernetes tab and confirm the deployment and pods.
7. Inspect `orders-api` and confirm it consumes `payments-rest`.

## 2. Create a service

Navigate to **Create → Buildin10 Node.js Service** and confirm:

- there is one parameter page;
- there is no repository picker;
- owner choices are team Groups, not a parent organization;
- the following test values are available:

| Field | Value |
| --- | --- |
| Service name | `demo-check-service` |
| Description | `Temporary end-to-end platform validation service` |
| Owner | `team-orders` |
| System | `fulfilment` |

Submit and record the task URL and task ID.

## 3. Follow the six scaffold steps

All six must complete:

1. `fetchService`
2. `fetchWorkflow`
3. `publishService`
4. `fetchGitOps`
5. `openGitOpsPR`
6. `registerService`

## 4. Review delivery artifacts

Verify:

- repository `YOUR_ORG/demo-check-service`;
- public image `ghcr.io/YOUR_ORG/demo-check-service:latest` for a public demo;
- a GitOps pull request containing `apps/demo-check-service/deployment.yaml` and `service.yaml`;
- the expected labels, selector, two replicas, and image reference;
- merge the PR only after the image is pullable and manifests are reviewed.

## 5. Review runtime

After merge, identify the exact generated Argo CD Application from `kubectl get applications -n argocd`. Wait until it reports `Synced` and `Healthy`. Then confirm the Deployment, Service, and two Running/Ready pods.

Finally, open the registered component in Backstage and verify its metadata, source links, GitOps path, Kubernetes workload, and pods.

The real service `order-tracking-service` is intentionally outside this test and must not be created.
