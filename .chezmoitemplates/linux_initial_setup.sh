
sudo apt update
{{ range .packages.linux.apt -}}
sudo apt install -y {{ . | quote }}
{{ end -}}

source {{.chezmoi.sourceDir}}/.chezmoitemplates/linux_tools.sh

{{ range .packages.linux.custom -}}
init_{{ . }}
{{ end -}}
