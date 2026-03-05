Set-Location -Path "$PSScriptRoot"

$docker = 'C:\Program Files\Docker\Docker\resources\bin\docker.exe'
if (!(Test-Path $docker)) {
  Write-Host 'Docker CLI not found. Install Docker Desktop first.' -ForegroundColor Red
  exit 1
}

try {
  $wslStatus = (wsl --status) 2>&1 | Out-String
  if ($LASTEXITCODE -ne 0) {
    Write-Host 'WSL is not installed. Run .\setup-docker-prereqs.ps1 as Administrator, reboot, then retry.' -ForegroundColor Yellow
    exit 1
  }

  if ($wslStatus -match 'WSL2 is not supported' -or $wslStatus -match 'Virtual Machine Platform' -or $wslStatus -match 'enable virtualization') {
    Write-Host 'WSL2 prerequisites are missing (Virtual Machine Platform and/or BIOS virtualization).' -ForegroundColor Yellow
    Write-Host 'Run .\setup-docker-prereqs.ps1 as Administrator, reboot, then ensure virtualization is enabled in BIOS.' -ForegroundColor Yellow
    exit 1
  }
} catch {
  Write-Host 'Unable to validate WSL state. Run .\setup-docker-prereqs.ps1 as Administrator.' -ForegroundColor Yellow
  exit 1
}

if (!(Test-Path '.env')) {
  Copy-Item '.env.example' '.env'
}

Write-Host 'Waiting for Docker engine...' -ForegroundColor Cyan
$ready = $false
for ($i = 0; $i -lt 90; $i++) {
  & $docker info *> $null
  if ($LASTEXITCODE -eq 0) { $ready = $true; break }
  Start-Sleep -Seconds 2
}

if (-not $ready) {
  Write-Host 'Docker engine is not ready. Open Docker Desktop and wait until it shows Running.' -ForegroundColor Yellow
  exit 1
}

& $docker compose up --build
