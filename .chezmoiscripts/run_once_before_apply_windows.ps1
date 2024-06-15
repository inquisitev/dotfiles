# Windows specific configuration
if ($env:OS -eq "Windows_NT") {
  # Move nvim config to the correct location
  Move-Item -Path "$env:LOCALAPPDATA\nvim" -Destination "$env:LOCALAPPDATA\nvim_backup_windows" -Force
  chezmoi apply --source-path ~/.local/share/chezmoi/dot_config/nvim_windows $env:LOCALAPPDATA\nvim
}
