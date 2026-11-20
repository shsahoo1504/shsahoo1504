# End-to-End Test Evidence

Run one stage at a time. Do not mark a stage successful until actual output, a workflow URL, or a reviewed UI view supports it.

## Baseline evidence

Capture:

- three Ready KIND nodes;
- existing Payments and Orders rollouts;
- Backstage service health;
- current Argo CD Applications;
- existing public/private package policy.

## Required checks

| Stage | Evidence |
| --- | --- |
| Template execution | task ID, task URL, six completed step names |
| GitHub repository | exact URL and catalog metadata |
| GitHub Actions | run URL, result, image tags |
| GHCR | package URL, visibility, pull result |
| GitOps PR | PR URL/number, reviewed manifests, merge SHA |
| Argo CD | exact generated Application, namespace, Synced/Healthy |
| Kubernetes | Deployment, Service, replica count, pod readiness, image |
| Backstage catalog | component URL and metadata |
| Backstage Kubernetes | cluster, workload, and pod visibility |
| RBAC | nine `yes` results and absence of Kubernetes 403 logs |
| Cleanup | no residual repository, package, PR/branch, catalog location, GitOps path, Application, or Kubernetes resource |

Use [`docs/e2e-results-template.md`](e2e-results-template.md) to record the run.

## Failure discipline

When a stage fails:

1. stop dependent stages;
2. preserve the exact output and timestamp;
3. inspect logs and object state;
4. identify the causal failure;
5. change configuration only after the cause is understood;
6. rerun that stage.

Do not silently skip failures or substitute a green proxy for the required evidence.
