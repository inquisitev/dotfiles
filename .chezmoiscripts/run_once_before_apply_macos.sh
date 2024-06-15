# Windows specific configuration
if ($env:OS -eq "Windows_NT") {
  # Define the nvim configuration path
  $nvimConfigPath = "$env:LOCALAPPDATA\nvim"

  # Create the directory if it doesn't exist
  if (-Not (Test-Path -Path $nvimConfigPath)) {
    New-Item -ItemType Directory -Path $nvimConfigPath
  }

  # Backup existing nvim configuration if it exists
  if (Test-Path -Path $nvimConfigPath) {
    Move-Item -Path $nvimConfigPath -Destination "$nvimConfigPath_backup_windows" -Force
  }

  # Apply the chezmoi nvim configuration
  chezmoi apply --source-path ~/.local/share/chezmoi/dot_config/nvim_windows -destination $nvimConfigPath
}
