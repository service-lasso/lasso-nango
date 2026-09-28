# Lasso Nango

`lasso-nango` is the Service Lasso package for a local, self-hosted Nango
instance. It packages Service Lasso's Compose wrapper; Nango itself remains
the upstream software and runs from pinned official Docker images.

## What it manages

- Nango server at `http://127.0.0.1:3003`
- Nango Connect UI at `http://127.0.0.1:3009`
- a private PostgreSQL 16 database, persisted under the installed service root
- a generated local encryption key, admin key, database password and dashboard
  password in `.state/nango.env` (never committed or printed)

Nango's official self-hosted Compose guide is the upstream contract. This
package pins `nangohq/nango-server:hosted-0.71.10` by digest and pins the
official PostgreSQL 16 Alpine image by digest. See [UPSTREAM.md](UPSTREAM.md)
for the recorded source evidence.

## Requirements

- Docker Engine with Docker Compose v2
- Linux containers (Docker Desktop is supported on Windows and macOS)
- ports 3003 and 3009 available on loopback

The first start pulls images and can take several minutes. This package does
not expose Nango beyond loopback and does not publish, deploy, or release
anything by itself.

## Local validation

```powershell
pwsh -NoLogo -NoProfile -File ./scripts/package.ps1
pwsh -NoLogo -NoProfile -File ./scripts/test.ps1
```

On a Docker-enabled Linux host, `bash ./scripts/verify.sh` performs the
bounded Compose start/health/stop smoke test. It creates only the temporary
`lasso-nango-verify` Compose project and removes it at the end.

## Operator safety

Do not copy `.state/nango.env` into tickets, logs, releases, or source control.
It contains local credentials. `runtime/nango-stop.*` stops containers but
keeps the database volume; deleting data is a separate, deliberate operator
operation.
