# Host and Tool Installation

Run these steps on a dedicated Ubuntu 24.04 VM as an administrative user.

## Prepare the host

Review and run:

```bash
sudo ./scripts/00-prepare-host.sh
```

This installs the Docker repository, common utilities, and kernel settings used by KIND. Review the script, especially package installation and swap handling, before changing a shared host.

## Install demo tooling

```bash
sudo ./scripts/01-install-tools.sh
```

Reference versions:

- KIND `0.33.0`
- Argo CD `3.6.1`
- Node.js 24
- Yarn 4.4.1

Verify:

```bash
docker --version
kubectl version --client
kind version
node --version
yarn --version
gh --version
```

## GitHub CLI authentication

Authenticate explicitly on the demo host:

```bash
gh auth login
gh auth status
```

This guide does not contain or request credentials.

## Recommended networking

Keep the services private and use SSH forwarding from the administrator workstation:

```bash
ssh -N \
  -L 3000:127.0.0.1:3000 \
  -L 7007:127.0.0.1:7007 \
  -L 8081:127.0.0.1:8081 \
  platform@YOUR_VM_HOST
```

Only expose ports to the internet when the security model, TLS, authentication, and firewalling have been explicitly designed.
