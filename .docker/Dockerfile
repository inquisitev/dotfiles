# syntax=docker/dockerfile:1
# Throwaway env + CI test image: a fresh Ubuntu with these dotfiles applied by
# the real chezmoi scripts.
#   docker build -f .docker/Dockerfile -t dotfiles .
#   docker run --rm -it dotfiles
# Build args:  IS_WORK=true   NO_ROOT=true (user has no sudo)   XPRA=true
FROM ubuntu:24.04@sha256:2198e4c65076e9cb0b3d695219df667c0e3b0072da64ca3c2648aca17dcecaf5

ARG TARGETARCH
ARG IS_WORK=false
ARG NO_ROOT=false
ARG XPRA=false
ARG CHEZMOI_VERSION=2.74.0
ARG CHEZMOI_SHA256_amd64=1b98a567f726f41540414aea4caf912699d53e248b29ccf8369cf553657b2374
ARG CHEZMOI_SHA256_arm64=bf89495d1aab5e4fa0fc1ba9457837b34ee8dec9b787570f2de3e1c12a5835a5

ENV DEBIAN_FRONTEND=noninteractive LANG=C.UTF-8 LC_ALL=C.UTF-8 TERM=xterm-256color

# Minimal base: what the one-line bootstrap needs on a fresh machine.
RUN apt-get update \
 && apt-get install -y --no-install-recommends ca-certificates curl git sudo xz-utils \
 && rm -rf /var/lib/apt/lists/* \
 && (userdel -r ubuntu 2>/dev/null || true) \
 && useradd -m -u 1000 -s /bin/bash dev \
 && if [ "$NO_ROOT" != "true" ]; then echo 'dev ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/dev; fi

# Pinned chezmoi, verified against the checksum committed here.
RUN set -eu; \
    eval "sha=\$CHEZMOI_SHA256_${TARGETARCH}"; \
    curl -fsSL -o /tmp/chezmoi.tgz \
      "https://github.com/twpayne/chezmoi/releases/download/v${CHEZMOI_VERSION}/chezmoi_${CHEZMOI_VERSION}_linux_${TARGETARCH}.tar.gz"; \
    echo "${sha}  /tmp/chezmoi.tgz" | sha256sum -c -; \
    tar -xzf /tmp/chezmoi.tgz -C /usr/local/bin chezmoi; \
    rm /tmp/chezmoi.tgz

USER dev
WORKDIR /home/dev
ENV PATH=/home/dev/.local/bin:/home/dev/.local/share/mise/shims:$PATH
COPY --chown=dev:dev . /home/dev/.local/share/chezmoi

# The real setup. The GitHub token (optional) only avoids API rate limits; it's
# a BuildKit secret, so it never lands in an image layer.
RUN --mount=type=secret,id=gh_token,uid=1000 \
    set -eu; \
    if [ -s /run/secrets/gh_token ]; then export MISE_GITHUB_TOKEN="$(cat /run/secrets/gh_token)"; fi; \
    DOTFILES_STRICT=1 DOTFILES_WORK="$IS_WORK" DOTFILES_NO_ROOT="$NO_ROOT" DOTFILES_XPRA="$XPRA" \
      chezmoi init --apply --no-tty

# Pre-install nvim plugins (at the nvim-pack-lock.json commits) and treesitter
# parsers, so the first `nvim` in a fresh container opens straight away.
# Mason's LSP servers are large and still install on first start.
RUN nvim --headless \
      -c 'lua vim.wait(300000, function() local want = { "lua", "python", "cpp", "c", "javascript", "qmljs" }; local have = require("nvim-treesitter").get_installed(); for _, p in ipairs(want) do if not vim.tbl_contains(have, p) then return false end end; return true end, 1000)' \
      -c 'qa!'

CMD ["fish", "-l"]
