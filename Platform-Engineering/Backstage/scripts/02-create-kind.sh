#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/lib.sh"
require_command docker
require_command kind
require_command kubectl

CLUSTER_NAME="${BUILDIN10_CLUSTER_NAME:-buildin10}"
if kind get clusters | grep -Fxq "$CLUSTER_NAME"; then
  echo "KIND cluster '$CLUSTER_NAME' already exists; leaving it unchanged."
else
  kind create cluster \
    --name "$CLUSTER_NAME" \
    --config "$BUILDIN10_ROOT/infra/kind-config.yaml" \
    --wait 5m
fi

kubectl wait --for=condition=Ready nodes --all --timeout=300s
kubectl apply -f "$BUILDIN10_ROOT/infra/namespaces.yaml"
kubectl apply -f "$BUILDIN10_ROOT/infra/backstage-rbac.yaml"
kubectl get nodes
