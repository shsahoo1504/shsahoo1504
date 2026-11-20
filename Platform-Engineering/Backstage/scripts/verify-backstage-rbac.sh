#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/lib.sh"
require_command kubectl

SERVICE_ACCOUNT="system:serviceaccount:backstage:backstage-k8s-reader"
failed=0
for resource in limitranges resourcequotas horizontalpodautoscalers; do
  for verb in get list watch; do
    result="$(kubectl auth can-i "$verb" "$resource" \
      --as="$SERVICE_ACCOUNT" --all-namespaces)"
    printf '%-28s %-5s %s\n' "$resource" "$verb" "$result"
    [[ "$result" == "yes" ]] || failed=1
  done
done
exit "$failed"
