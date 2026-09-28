$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
& (Join-Path $root 'scripts\package.ps1')
& (Join-Path $root 'scripts\test.ps1')
$env:NANGO_BIND = '127.0.0.1'; $env:NANGO_HTTP_PORT = '13003'; $env:NANGO_CONNECT_PORT = '13009'; $env:NANGO_SERVER_URL = 'http://127.0.0.1:13003'; $env:NANGO_PUBLIC_CONNECT_URL = 'http://127.0.0.1:13009'; $env:NANGO_DATA_PATH = (Join-Path $root '.tmp\verify-data'); $env:NANGO_DB_NAME = 'nango'; $env:NANGO_DB_USER = 'nango'; $env:NANGO_DB_PASSWORD = 'not-a-secret-test-value'; $env:NANGO_ENCRYPTION_KEY = 'not-a-secret-test-value'; $env:NANGO_ADMIN_KEY = 'not-a-secret-test-value'; $env:NANGO_DASHBOARD_USERNAME = 'admin'; $env:NANGO_DASHBOARD_PASSWORD = 'not-a-secret-test-value'
& docker compose -f (Join-Path $root 'runtime\docker-compose.yaml') config --quiet
if ($LASTEXITCODE -ne 0) { throw 'Docker Compose configuration did not validate.' }
Write-Host 'Nango package Compose configuration passed (Windows). Runtime smoke is exercised on Docker-enabled Linux CI.'
