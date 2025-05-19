
if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
  if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
    $CommandLine = "-NoExit -File `"" + $MyInvocation.MyCommand.Path + "`" " + $MyInvocation.UnboundArguments
    Start-Process -Wait -FilePath PowerShell.exe -Verb Runas -ArgumentList $CommandLine
    Exit
  }
}
# Check if SQLite3 is already in the PATH
Write-Host "Checking if SQLite3 is in PATH..."

$sqliteDllPath = (Get-Command libsqlite3.dll -ErrorAction SilentlyContinue)

if ($sqliteDllPath) {
    Write-Host "SQLite3 is already in the PATH."
} else {
    Write-Host "SQLite3 not found in PATH. Proceeding with download..."

    # Define the URL for the SQLite3 Windows DLL (64-bit)
    $sqliteDownloadUrl = "https://sqlite.org/2024/sqlite-dll-win-x64-3470200.zip"
    
    # Define the directory for downloading and extracting SQLite3
    $downloadDir = "$env:USERPROFILE\Downloads\sqlite"
    $extractDir = "C:\Tools\sqlite3"
    
    # Create download directory if it doesn't exist
    if (-Not (Test-Path -Path $downloadDir)) {
        New-Item -ItemType Directory -Path $downloadDir
    }
    
    # Download SQLite3 ZIP file
    Write-Host "Downloading SQLite3 from $sqliteDownloadUrl..."
    Invoke-WebRequest -Uri "https://sqlite.org/2024/sqlite-dll-win-x64-3470200.zip" -OutFile "$downloadDir\sqlite.zip"

    # Extract the ZIP file
    Write-Host "Extracting SQLite3 ZIP file..."
    Expand-Archive -Path "$downloadDir\sqlite.zip" -DestinationPath $extractDir -Force

    # Define the destination folder for the SQLite3 DLL
    $sqliteDestFolder = "C:\sqlite"
    
    # Create the destination folder if it doesn't exist
    if (-Not (Test-Path -Path $sqliteDestFolder)) {
        New-Item -ItemType Directory -Path $sqliteDestFolder
    }
    
    # Copy the DLL file to C:\sqlite
    Copy-Item "$extractDir\sqlite3.dll" "$sqliteDestFolder\libsqlite3.dll"
    Write-Host "libsqlite3.dll copied to C:\sqlite."

    # Add C:\sqlite to the system PATH
    $currentPath = [System.Environment]::GetEnvironmentVariable("PATH", [System.EnvironmentVariableTarget]::Machine)
    if ($currentPath -notlike "*C:\sqlite*") {
        Write-Host "Adding C:\sqlite to PATH..."
        [System.Environment]::SetEnvironmentVariable("PATH", "$currentPath;C:\sqlite", [System.EnvironmentVariableTarget]::Machine)
    }

    Write-Host "SQLite3 installed and added to PATH successfully."
}
