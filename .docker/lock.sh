#!/usr/bin/env bash
# Regenerate dot_config/mise/mise.lock for every platform, inside a throwaway
# container (so nothing touches your machine's mise state):
#   .docker/lock.sh            # re-lock current pins
# Review the diff before committing - checksums changing for an unchanged
# version is a red flag.
set -euo pipefail
REPO="$(cd "$(dirname "$0")/.." && pwd)"
IMAGE="$(grep -m1 '^FROM ' "$REPO/.docker/Dockerfile" | awk '{print $2}')"
MISE_VERSION="$(awk '/^  mise:/{f=1} f&&/version:/{gsub(/"/,"",$2); print $2; exit}' "$REPO/.chezmoidata/pins.yaml")"

docker run --rm -i \
  -e MISE_GITHUB_TOKEN="${MISE_GITHUB_TOKEN:-$(gh auth token 2>/dev/null || true)}" \
  -e MISE_VERSION="$MISE_VERSION" \
  -v "$REPO/dot_config/mise:/src" \
  "$IMAGE" bash -s <<'IN'
set -euo pipefail
apt-get update -qq >/dev/null && apt-get install -y -qq curl ca-certificates xz-utils >/dev/null 2>&1
arch=$(uname -m); case $arch in x86_64) p=linux-x64;; aarch64) p=linux-arm64;; esac
curl -fsSL "https://github.com/jdx/mise/releases/download/v$MISE_VERSION/mise-v$MISE_VERSION-$p.tar.gz" | tar -xz -C /tmp
export PATH="/tmp/mise/bin:$PATH" MISE_CONFIG_DIR=/cfg MISE_LOCKED=0
mkdir -p /cfg/conf.d
cp /src/config.toml /cfg/config.toml
cp /src/conf.d/no-root.toml /src/conf.d/work.toml /cfg/conf.d/
# armv7 overlay: lock its cargo tools, but not its disable_tools setting
sed '/^\[settings\]/,/^$/d' /src/conf.d/armv7.toml > /cfg/conf.d/armv7.toml
cd /root
mise lock -g --platform linux-x64,linux-arm64,macos-arm64,macos-x64,windows-x64
cp /cfg/mise.lock /src/mise.lock
IN
echo "wrote dot_config/mise/mise.lock"
