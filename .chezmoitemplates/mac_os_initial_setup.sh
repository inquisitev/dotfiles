#
source {{.chezmoi.sourceDir}}/.chezmoitemplates/mac_os_tools.sh

{{ range .packages.linux.custom -}}
install_{{ . }}
{{ end -}}

{{ range .packages.linux.custom -}}
init_{{ . }}
{{ end -}}
