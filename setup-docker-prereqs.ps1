# Run this script AS ADMINISTRATOR.
# It enables WSL + virtualization features required by Docker Desktop.

$ErrorActionPreference = 'Stop'

Write-Host 'Enabling required Windows features for Docker Desktop...' -ForegroundColor Cyan

dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

Write-Host 'Installing WSL runtime...' -ForegroundColor Cyan
wsl --install --no-distribution

Write-Host ''
Write-Host 'Prerequisites applied. Reboot is required.' -ForegroundColor Green
Write-Host 'After reboot, run:' -ForegroundColor Green
Write-Host '  cd "c:\LIM CHU JUN\Fintech_innovator"' -ForegroundColor Green
Write-Host '  .\start-mit.ps1' -ForegroundColor Green
