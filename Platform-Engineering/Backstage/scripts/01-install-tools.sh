#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/lib.sh"
require_linux
require_root

KIND_VERSION="${KIND_VERSION:-0.33.0}"
ARCH="$(dpkg --print-architecture)"
KUBECTL_ARCH="$ARCH"
case "$ARCH" in
  amd64|arm64) KIND_ARCH="$ARCH" ;;
  *) echo "Unsupported architecture: $ARCH" >&2; exit 1 ;;
esac

KUBECTL_VERSION="$(curl -fsSL https://dl.k8s.io/release/stable.txt)"
curl -fsSL -o /usr/local/bin/kubectl \
  "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/${KUBECTL_ARCH}/kubectl"
chmod +x /usr/local/bin/kubectl

curl -fsSL -o /usr/local/bin/kind \
  "https://kind.sigs.k8s.io/dl/v${KIND_VERSION}/kind-linux-${KIND_ARCH}"
chmod +x /usr/local/bin/kind

install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
  -o /etc/apt/keyrings/githubcli-archive-keyring.gpg
chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
  > /etc/apt/sources.list.d/github-cli.list
apt-get update
apt-get install -y gh build-essential python3

NODE_MAJOR="${NODE_MAJOR:-24}"
curl -fsSL "https://deb.nodesource.com/setup_${NODE_MAJOR}.x" \
  -o /tmp/nodesource-setup.sh
bash /tmp/nodesource-setup.sh
rm -f /tmp/nodesource-setup.sh
apt-get install -y nodejs
npm install --global corepack@0.34.0
corepack enable
corepack prepare yarn@4.4.1 --activate

kubectl version --client
kind version
node --version
npm --version
yarn --version
gh --version
