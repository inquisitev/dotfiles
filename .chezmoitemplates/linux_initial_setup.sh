echo "Setting up linux tools"

run_cmd() {
    local name="$1"           # logical name for logging (e.g. "curl", "docker")
    local cmd="$2"           # logical name for logging (e.g. "curl", "docker")

    local log_dir="/tmp/chezmoi/apt/${name}"
    local log_file="${log_dir}/log.txt"

    mkdir -p "$log_dir"

    # Colors
    local BLUE="\033[0;34m"
    local GREEN="\033[0;32m"
    local RED="\033[0;31m"
    local NC="\033[0m"

    echo -e "${BLUE}Installing package: $*${NC}"

    if $cmd > "$log_file" 2>&1; then
        echo -e "${GREEN}-->    Successfully installed: $*${NC}"
        return 0
    else
        echo -e "${RED}-->     Error occurred while installing: $*${NC}"
        echo -e "${RED}            See log: ${log_file}${NC}"
        return 1
    fi
}

mkdir -p /tmp/chezmoi/apt/update
sudo apt update > "/tmp/chezmoi/apt/update/log.txt" 2>&1;

{{ range .packages.linux.apt -}}
run_cmd "Installing {{ . | quote }}" " sudo apt install -y {{ . | quote }}"
{{ end -}}

source {{.chezmoi.sourceDir}}/.chezmoitemplates/linux_tools.sh

{{ range .packages.linux.custom -}}
run_cmd "Installing package {{.}}" "install_{{ . }}"
{{ end -}}

{{ range .packages.linux.custom -}}
init_{{ . }}
{{ end -}}
