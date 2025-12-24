#! /bin/bash

# This is intended for devcontainers where the repository is cloned into ~/.local/share/chezmoi
run_cmd() {
    local name="$1"           # logical name for logging (e.g. "curl", "docker")
    local cmd="$2"           # logical name for logging (e.g. "curl", "docker")

    local log_dir="/tmp/chezmoi/setup/${name}"
    local log_file="${log_dir}/log.txt"

    mkdir -p "$log_dir"

    # Colors
    local BLUE="\033[0;34m"
    local GREEN="\033[0;32m"
    local RED="\033[0;31m"
    local NC="\033[0m"

    echo -e "${BLUE}Installing: $1${NC}"

    if $cmd > "$log_file" 2>&1; then
        echo -e "${GREEN}-->    Successfully installed: $1${NC}"
        return 0
    else
        echo -e "${RED}-->     Error occurred while installing: $*${NC}"
        echo -e "${RED}            See log: ${log_file}${NC}"
        return 1
    fi
}

( 
   cd /usr
   run_cmd "chezmoi" 'sudo sh -c "$(curl -fsLS get.chezmoi.io)"'
)

(
   run_cmd "chezmoi init" '/usr/bin/chezmoi init'
   /usr/bin/chezmoi apply --no-tty --force
)

echo "\033[0;32mSetup Finished."
