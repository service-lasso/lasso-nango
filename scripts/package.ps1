$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$dist = Join-Path $root 'dist'
$stage = Join-Path $dist 'lasso-nango-win32'
$archive = Join-Path $dist 'lasso-nango-win32.zip'
New-Item -ItemType Directory -Force -Path $dist | Out-Null
if (Test-Path $stage) { Remove-Item -Recurse -Force $stage }
New-Item -ItemType Directory -Force -Path $stage | Out-Null
Copy-Item -Recurse -Force (Join-Path $root 'runtime') (Join-Path $stage 'runtime')
Copy-Item -Force (Join-Path $root 'service.json') (Join-Path $stage 'service.json')
Copy-Item -Force (Join-Path $root 'UPSTREAM.md') (Join-Path $stage 'UPSTREAM.md')
if (Test-Path $archive) { Remove-Item -Force $archive }
Compress-Archive -Path (Join-Path $stage '*') -DestinationPath $archive
Write-Host "Created $archive"
