#!/usr/bin/env bash
set -euo pipefail

readonly BUILDIN10_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

require_command() {
  local command_name="$1"
  command -v "$command_name" >/dev/null 2>&1 || {
    printf 'Missing required command: %s\n' "$command_name" >&2
    exit 1
  }
}

require_linux() {
  [[ "$(uname -s)" == "Linux" ]] || {
    echo "This host setup script must run on Linux." >&2
    exit 1
  }
}

require_root() {
  [[ "${EUID}" -eq 0 ]] || {
    echo "Run this host setup script with sudo." >&2
    exit 1
  }
}
