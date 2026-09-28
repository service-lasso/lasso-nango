# Lasso Nango maintainer context

`lasso-nango` is a one-service-per-repository package. Its release archive
contains only Service Lasso-owned runtime wrappers and configuration; it does
not vendor Nango source code or mutable third-party images.

## Runtime boundary

- `runtime/docker-compose.yaml` owns the local Compose topology.
- Nango and PostgreSQL image references must stay version-and-digest pinned.
- `.state/nango.env` is generated on first start and is credential material.
  It must never be committed, logged, or attached to an issue.
- `data/postgres` is operator-owned durable state. Stop/restart must not remove
  it.

## Validation boundary

Static package validation runs on Windows, Linux and macOS. The Docker smoke
test runs on Linux because hosted Windows/macOS runners do not provide a
reliable Docker daemon. A successful static package check is not a claim that
Docker Desktop is installed on an operator's workstation.

## Release boundary

The release workflow creates Lasso-owned platform wrapper archives plus
`SHA256SUMS.txt`. It does not publish upstream Nango images, deploy a Nango
instance, or make a catalog admission decision.
