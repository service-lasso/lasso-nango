param([string]$ArtifactRoot = $env:SERVICE_ARTIFACT_ROOT, [string]$ServiceRoot = $env:SERVICE_ROOT)
$ErrorActionPreference = 'Stop'
if (-not $ArtifactRoot) { $ArtifactRoot = Split-Path -Parent $PSScriptRoot }; if (-not $ServiceRoot) { $ServiceRoot = $ArtifactRoot }
$envFile = Join-Path $ServiceRoot '.state\nango.env'; $compose = Join-Path $ArtifactRoot 'runtime\docker-compose.yaml'; $project = if ($env:NANGO_COMPOSE_PROJECT) { $env:NANGO_COMPOSE_PROJECT } else { 'lasso-nango' }
if (-not (Test-Path $envFile)) { Write-Host 'Nango has not been initialized; nothing to stop.'; exit 0 }
& docker compose --project-name $project --env-file $envFile -f $compose down --remove-orphans
exit $LASTEXITCODE
