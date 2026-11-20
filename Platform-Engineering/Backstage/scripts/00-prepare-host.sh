#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/lib.sh"
require_linux
require_root

. /etc/os-release
[[ "$ID" == "ubuntu" ]] || {
  echo "Expected Ubuntu; found ${ID}." >&2
  exit 1
}

apt-get update
apt-get install -y \
  ca-certificates curl git jq unzip \
  apt-transport-https conntrack socat ebtables ethtool \
  bridge-utils gnupg lsb-release

install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
  -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu ${UBUNTU_CODENAME:-$VERSION_CODENAME} stable" \
  > /etc/apt/sources.list.d/docker.list

apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io \
  docker-buildx-plugin docker-compose-plugin
systemctl enable --now docker

if ! id platform >/dev/null 2>&1; then
  useradd --create-home --shell /bin/bash platform
fi
usermod -aG docker platform

printf 'overlay\nbr_netfilter\n' > /etc/modules-load.d/buildin10.conf
modprobe overlay
modprobe br_netfilter

cat > /etc/sysctl.d/99-buildin10.conf <<'EOF'
net.bridge.bridge-nf-call-iptables = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward = 1
fs.inotify.max_user_watches = 524288
fs.inotify.max_user_instances = 1024
fs.inotify.max_queued_events = 32768
fs.file-max = 2097152
EOF
sysctl --system

echo "Review swap handling for this host. This script intentionally does not alter it."
