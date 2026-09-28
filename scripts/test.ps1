$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$manifest = Get-Content (Join-Path $root 'service.json') -Raw | ConvertFrom-Json
if ($manifest.id -ne 'nango') { throw 'service.json id must be nango' }
if ($manifest.artifact.source.repo -ne 'service-lasso/lasso-nango') { throw 'artifact source must point to this package repository' }
if (($manifest.endpoints | Where-Object { $_.id -eq 'server' }).bind -ne '127.0.0.1') { throw 'Nango must remain loopback-only by default' }
if ($manifest.healthchecks[0].type -ne 'http') { throw 'Nango requires an HTTP readiness healthcheck' }
foreach ($path in @('runtime\docker-compose.yaml', 'runtime\nango-service.ps1', 'runtime\nango-stop.ps1', 'runtime\nango-service.sh', 'runtime\nango-stop.sh', 'UPSTREAM.md')) { if (-not (Test-Path (Join-Path $root $path))) { throw "Missing $path" } }
$compose = Get-Content (Join-Path $root 'runtime\docker-compose.yaml') -Raw
foreach ($required in @('hosted-0.71.10@sha256:b4e96e827f8a27c6ab108602f1850325250ac31636db5cf392c1d08fde8a79c5', 'postgres:16.0-alpine@sha256:acf5271bbecd4b8733f4e93959a8d2b536a57aeee6cc4b6a71890aaf646425b8', 'NANGO_BIND')) { if ($compose -notmatch [regex]::Escape($required)) { throw "Compose file lacks required pinned/local value: $required" } }
Write-Host 'Nango package static tests passed (Windows)'
