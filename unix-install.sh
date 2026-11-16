#!/bin/sh
# One-command setup for macOS / Linux / Raspberry Pi:
#   sh -c "$(curl -fsSL https://raw.githubusercontent.com/inquisitev/dotfiles/main/unix-install.sh)"
# Installs a pinned chezmoi (sha256-verified) to ~/.local/bin, then applies the
# dotfiles, which install packages, mise + every dev tool, and plugins.
# Re-run any time, or just `chezmoi update`.
set -eu

VERSION="2.74.0"
os="$(uname -s | tr '[:upper:]' '[:lower:]')"
arch="$(uname -m)"
case "$os/$arch" in
   darwin/arm64)          asset=darwin_arm64; sha=9d89672a597a9333ab47ea5173fcececb85c04864205686a7aa5699c3d8bd98c ;;
   darwin/x86_64)         asset=darwin_amd64; sha=3d30cb05efae2f4a68519d6d0e8856765f2b21a0686e66498ee6d2de7707e5e6 ;;
   linux/x86_64)          asset=linux_amd64;  sha=1b98a567f726f41540414aea4caf912699d53e248b29ccf8369cf553657b2374 ;;
   linux/aarch64|linux/arm64) asset=linux_arm64; sha=bf89495d1aab5e4fa0fc1ba9457837b34ee8dec9b787570f2de3e1c12a5835a5 ;;
   linux/armv7l|linux/armv6l) asset=linux_armv6; sha=f83b50985f2ad1e4563d46936a7a06aa94e46c6c8c8fa05c611e7a306ed04fe7 ;;
   *) echo "unsupported platform: $os/$arch" >&2; exit 1 ;;
esac

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
curl -fsSL -o "$tmp/chezmoi.tgz" \
   "https://github.com/twpayne/chezmoi/releases/download/v$VERSION/chezmoi_${VERSION}_${asset}.tar.gz"
if command -v sha256sum >/dev/null 2>&1; then actual="$(sha256sum "$tmp/chezmoi.tgz" | awk '{print $1}')"
else actual="$(shasum -a 256 "$tmp/chezmoi.tgz" | awk '{print $1}')"; fi
if [ "$actual" != "$sha" ]; then
   echo "chezmoi checksum mismatch (expected $sha, got $actual) - aborting" >&2
   exit 1
fi
mkdir -p "$HOME/.local/bin"
tar -xzf "$tmp/chezmoi.tgz" -C "$tmp" chezmoi
install -m 0755 "$tmp/chezmoi" "$HOME/.local/bin/chezmoi"

exec "$HOME/.local/bin/chezmoi" init --apply inquisitev "$@"
