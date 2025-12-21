echo "Setting up linux tools"

run_cmd() {
    local name="$1"           # logical name for logging (e.g. "curl", "docker")
    local cmd="$2"           # logical name for logging (e.g. "curl", "docker")
    shift                     # remaining args are apt packages

    local log_dir="/tmp/chezmoi/apt/${name}"
    local log_file="${log_dir}/log.txt"

    mkdir -p "$log_dir"

    # Colors
    local BLUE="\033[0;34m"
    local GREEN="\033[0;32m"
    local RED="\033[0;31m"
    local NC="\033[0m"

    echo -e "${BLUE}Installing apt packages: $*${NC}"

    if $cmd "$@" 2> "$log_file"; then
        echo -e "${GREEN}Successfully installed: $*${NC}"
        return 0
    else
        echo -e "${RED}Error occurred while installing: $*${NC}"
        echo -e "${RED}See log: ${log_file}${NC}"
        return 1
    fi
}

sudo apt update

{{ range .packages.linux.apt -}}
run_cmd "Installing  {{ . | quote }}" " sudo apt install -y {{ . | quote }}"
{{ end -}}

source {{.chezmoi.sourceDir}}/.chezmoitemplates/linux_tools.sh

{{ range .packages.linux.custom -}}
run_cmd "Installing package {{.}}" "install_{{ . }}"
{{ end -}}

{{ range .packages.linux.custom -}}
init_{{ . }}
{{ end -}}
