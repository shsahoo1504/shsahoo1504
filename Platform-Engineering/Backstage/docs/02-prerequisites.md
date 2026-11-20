# Prerequisites

## Local workstation

- A modern terminal with OpenSSH.
- `git`.
- A GitHub account and permission to create repositories in a chosen organization.
- A GitHub organization or namespace in which you can create packages.
- An editor capable of reviewing YAML and TypeScript.

## Demo host

Use a dedicated Ubuntu 24.04 LTS VM. Suggested starting capacity is 8 vCPU, 16 GiB RAM, and 100 GiB SSD. Increase memory and disk for parallel builds or multiple clusters. Monitor actual CPU, memory, disk I/O, and image-cache usage rather than selecting a provider plan by name.

Open only the ports required by your network design:

- 22 for administrative SSH, ideally source-restricted.
- 3000 for Backstage frontend.
- 7007 for Backstage backend.
- 8081 only if you deliberately expose an Argo CD port-forward/proxy.

For learning, SSH tunnels are safer than publicly exposing all control-plane services.

## GitHub permissions

The setup operator needs permission to create repositories. Backstage's token requires repository creation, pull-request, contents, and relevant organization access for the organizations being demonstrated. A workflow needs `contents: read` and `packages: write`. Prefer a GitHub App in a durable deployment; a fine-grained token is sufficient for a local demonstration.

## Required values

Copy `.env.example` to a private `.env` file and fill in values:

```bash
cp .env.example .env
```

Do not commit `.env`. Keep the token empty in `.env.example`.

## Host-only safety

All commands that change infrastructure are manual steps intended for a disposable demo host. Review scripts before execution. Nothing in this repository logs into GitHub, creates a VM, or deploys without an explicit operator command.
