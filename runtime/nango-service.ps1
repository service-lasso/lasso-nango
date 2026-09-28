param([string]$ArtifactRoot = $env:SERVICE_ARTIFACT_ROOT, [string]$ServiceRoot = $env:SERVICE_ROOT)
$ErrorActionPreference = 'Stop'
if (-not $ArtifactRoot) { $ArtifactRoot = Split-Path -Parent $PSScriptRoot }
if (-not $ServiceRoot) { $ServiceRoot = $ArtifactRoot }
$compose = Join-Path $ArtifactRoot 'runtime\docker-compose.yaml'; $state = Join-Path $ServiceRoot '.state'; $data = Join-Path $ServiceRoot 'data'; $envFile = Join-Path $state 'nango.env'; $project = if ($env:NANGO_COMPOSE_PROJECT) { $env:NANGO_COMPOSE_PROJECT } else { 'lasso-nango' }
if (-not (Get-Command docker -ErrorAction SilentlyContinue)) { throw 'Docker Engine with Compose v2 is required to run Nango.' }
& docker compose version | Out-Null; if ($LASTEXITCODE -ne 0) { throw 'Docker Compose v2 is required to run Nango.' }
if (-not (Test-Path $compose)) { throw "Missing packaged Compose file: $compose" }
New-Item -ItemType Directory -Force -Path $state, $data | Out-Null
function New-Secret([int]$Bytes = 32) { $buffer = [byte[]]::new($Bytes); [System.Security.Cryptography.RandomNumberGenerator]::Fill($buffer); [Convert]::ToBase64String($buffer) }
function New-DatabasePassword { $buffer = [byte[]]::new(24); [System.Security.Cryptography.RandomNumberGenerator]::Fill($buffer); [Convert]::ToHexString($buffer).ToLowerInvariant() }
if (-not (Test-Path $envFile)) {
  $httpPort = if ($env:NANGO_HTTP_PORT) { $env:NANGO_HTTP_PORT } else { '3003' }; $connectPort = if ($env:NANGO_CONNECT_PORT) { $env:NANGO_CONNECT_PORT } else { '3009' }; $bind = if ($env:NANGO_BIND) { $env:NANGO_BIND } else { '127.0.0.1' }; $serverUrl = if ($env:NANGO_SERVER_URL) { $env:NANGO_SERVER_URL } else { "http://${bind}:${httpPort}" }; $connectUrl = if ($env:NANGO_PUBLIC_CONNECT_URL) { $env:NANGO_PUBLIC_CONNECT_URL } else { "http://${bind}:${connectPort}" }
  @("NANGO_BIND=$bind", "NANGO_HTTP_PORT=$httpPort", "NANGO_CONNECT_PORT=$connectPort", "NANGO_SERVER_URL=$serverUrl", "NANGO_PUBLIC_CONNECT_URL=$connectUrl", "NANGO_DATA_PATH=$($data -replace '\\','/')", 'NANGO_DB_NAME=nango', 'NANGO_DB_USER=nango', "NANGO_DB_PASSWORD=$(New-DatabasePassword)", "NANGO_ENCRYPTION_KEY=$(New-Secret 32)", "NANGO_ADMIN_KEY=$(New-Secret 32)", 'NANGO_DASHBOARD_USERNAME=admin', "NANGO_DASHBOARD_PASSWORD=$(New-Secret 24)") | Set-Content -Path $envFile
  $currentUser = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
  icacls $envFile /inheritance:r /grant:r "${currentUser}:(F)" | Out-Null
}
& docker compose --project-name $project --env-file $envFile -f $compose up --remove-orphans
exit $LASTEXITCODE
