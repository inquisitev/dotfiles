# Windows specific configuration
if ($env:OS -eq "Windows_NT") {
  # Define the nvim configuration path
  $nvimConfigPath = "$env:LOCALAPPDATA\nvim"

  # Create the directory if it doesn't exist
  if (-Not (Test-Path -Path $nvimConfigPath)) {
    New-Item -ItemType Directory -Path $nvimConfigPath
  }

  # Apply the chezmoi nvim configuration
  chezmoi apply -v --source-path ~/.local/share/chezmoi/dot_config/nvim $env:LOCALAPPDATA\nvim
}
