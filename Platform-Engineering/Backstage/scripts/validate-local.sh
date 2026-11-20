#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/lib.sh"

failed=0
for script in "$BUILDIN10_ROOT"/scripts/*.sh; do
  if ! bash -n "$script"; then
    failed=1
  fi
done

if command -v ruby >/dev/null 2>&1; then
  while IFS= read -r -d '' file; do
    if ! ruby -e 'require "yaml"; YAML.load_stream(File.read(ARGV[0]))' "$file"; then
      failed=1
    fi
  done < <(find "$BUILDIN10_ROOT" -type f \( -name '*.yaml' -o -name '*.yml' \) -print0)
else
  echo "Ruby unavailable; YAML parse checks skipped." >&2
fi

if grep -R -nE '(gh[pousr]_[A-Za-z0-9_]{20,}|-----BEGIN .*PRIVATE KEY-----)' \
  "$BUILDIN10_ROOT" --exclude-dir=.git --exclude=validate-local.sh; then
  echo "Potential secret found." >&2
  failed=1
fi

step_count="$(
  sed -n '/^  steps:/,/^[^ ]/p' \
    "$BUILDIN10_ROOT/templates/template.yaml" |
  grep -c '^    - id:'
)"
if [[ "$step_count" != "6" ]]; then
  echo "Expected exactly six template steps; found $step_count." >&2
  failed=1
fi

if ! grep -Fq 'repoUrl: github.com?owner=YOUR_GITHUB_ORG&repo=${{ parameters.name }}' \
  "$BUILDIN10_ROOT/templates/template.yaml"; then
  echo "Template repository must derive from the service name." >&2
  failed=1
fi

for manifest in \
  "$BUILDIN10_ROOT/templates/skeleton-gitops/deployment.yaml" \
  "$BUILDIN10_ROOT/templates/skeleton-gitops/service.yaml"; do
  if ! grep -Fq 'app.kubernetes.io/name: ${{ values.name }}' "$manifest"; then
    echo "Missing Kubernetes discovery label in $manifest." >&2
    failed=1
  fi
done

required_docs=(
  README.md docs/01-architecture.md docs/02-prerequisites.md
  docs/03-host-and-tools.md docs/04-kubernetes-and-argocd.md
  docs/05-github-and-sample-services.md docs/06-backstage-setup.md
  docs/07-developer-journey.md docs/08-e2e-test.md docs/09-cleanup.md
)
for file in "${required_docs[@]}"; do
  [[ -s "$BUILDIN10_ROOT/$file" ]] || {
    echo "Missing or empty: $file" >&2
    failed=1
  }
done

exit "$failed"
