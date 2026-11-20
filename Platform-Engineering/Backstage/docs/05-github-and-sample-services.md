# GitHub Repositories and Sample Services

Create these repositories in a controlled lab organization:

- `catalog`
- `payments-api`
- `orders-api`
- `gitops`
- `templates`

The repository names are examples; consistently set `BUILDIN10_GITHUB_OWNER`.

## Publish each source tree

For each source directory, initialize a repository and push through your normal reviewed process. Example:

```bash
export BUILDIN10_GITHUB_OWNER=YOUR_GITHUB_ORG
gh repo create "$BUILDIN10_GITHUB_OWNER/catalog" --public \
  --description "Buildin10 software catalog"
git -C catalog init
git -C catalog add .
git -C catalog commit -m "Seed Buildin10 catalog"
git -C catalog branch -M main
git -C catalog remote add origin \
  "https://github.com/$BUILDIN10_GITHUB_OWNER/catalog.git"
git -C catalog push -u origin main
```

Repeat for the `payments-api`, `orders-api`, `gitops`, and `templates` directories. Review repository default-branch and branch-protection settings according to your lab requirements.

## Service image publication

The sample services include a workflow that:

1. checks out source;
2. installs dependencies;
3. runs checks;
4. authenticates to GHCR with `GITHUB_TOKEN`;
5. publishes `latest` and a short commit-SHA tag.

Set package visibility according to the learning exercise. Public is simplest for anonymous pulls; private is more representative of organizations and requires `imagePullSecrets`.

## Baseline services

Deploy the `apps/payments-api` and `apps/orders-api` examples from the GitOps repository. Confirm:

```bash
kubectl get deployment,service,pods -n buildin10
```

Expected ownership and API relationship:

- `payments-api` owns the `payments-rest` API.
- `orders-api` consumes `payments-rest`.
- Both belong to `fulfilment`.
- `team-orders` owns the sample components.
