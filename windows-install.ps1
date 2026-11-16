# One-command setup for Windows (run from an elevated PowerShell to also get
# choco/winget packages; non-elevated installs mise tools + configs only):
#   irm https://raw.githubusercontent.com/inquisitev/dotfiles/main/windows-install.ps1 | iex
$ErrorActionPreference = "Stop"
$Version = "2.74.0"
$Sha = "13dee2831d371c6ce2ac30fc9ae1aad4f70c68e7d44700f6129fe4b244ee7a95"

$bin = Join-Path $HOME ".local\bin"
$tmp = Join-Path ([System.IO.Path]::GetTempPath()) ("chezmoi-" + [guid]::NewGuid())
New-Item -ItemType Directory -Force -Path $bin, $tmp | Out-Null
try {
    $zip = Join-Path $tmp "chezmoi.zip"
    Invoke-WebRequest -UseBasicParsing -OutFile $zip "https://github.com/twpayne/chezmoi/releases/download/v$Version/chezmoi_$($Version)_windows_amd64.zip"
    if ((Get-FileHash -Algorithm SHA256 $zip).Hash.ToLower() -ne $Sha) { throw "chezmoi checksum mismatch - aborting" }
    Expand-Archive $zip -DestinationPath $tmp -Force
    Copy-Item (Join-Path $tmp "chezmoi.exe") (Join-Path $bin "chezmoi.exe") -Force
} finally { Remove-Item -Recurse -Force $tmp -ErrorAction SilentlyContinue }

$userPath = [Environment]::GetEnvironmentVariable("Path", "User")
if (($userPath -split ';') -notcontains $bin) { [Environment]::SetEnvironmentVariable("Path", "$bin;$userPath", "User") }
$env:Path = "$bin;$env:Path"

& (Join-Path $bin "chezmoi.exe") init --apply inquisitev
