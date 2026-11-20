# ${{ values.name }}

${{ values.description }}

## Runbook

Check the Argo CD Application, Deployment, Service, and pod events in the Kubernetes `buildin10` namespace. The workload is discovered with the label `app.kubernetes.io/name=${{ values.name }}`.
