#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/lib.sh"
require_command kubectl

ARGOCD_VERSION="${ARGOCD_VERSION:-3.6.1}"
kubectl create namespace argocd --dry-run=client -o yaml | kubectl apply -f -
kubectl apply -n argocd --server-side --force-conflicts \
  -f "https://raw.githubusercontent.com/argoproj/argo-cd/v${ARGOCD_VERSION}/manifests/install.yaml"
kubectl wait --for=condition=Ready pods --all -n argocd --timeout=600s
kubectl get pods -n argocd
