#
source {{.chezmoi.sourceDir}}/.chezmoitemplates/mac_os_tools.sh

{{ range .packages.linux.custom -}}
install_{{ . }}
init_{{ . }}
{{ end -}}
