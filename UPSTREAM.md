# Upstream evidence

## Nango

- Source: <https://github.com/NangoHQ/nango>
- Release used for this package: `v0.71.10` (published 2026-09-21)
- Self-hosted image: `nangohq/nango-server:hosted-0.71.10`
- Verified image digest: `sha256:b4e96e827f8a27c6ab108602f1850325250ac31636db5cf392c1d08fde8a79c5`
- Licence: Elastic License 2.0

Nango's official Compose file documents a Nango server using a PostgreSQL
database and recommends pinning an image by commit or version tag. This package
uses the official version tag with the verified immutable manifest digest.

## PostgreSQL dependency

- Image: `postgres:16.0-alpine`
- Verified index digest: `sha256:acf5271bbecd4b8733f4e93959a8d2b536a57aeee6cc4b6a71890aaf646425b8`

Evidence was inspected on 2026-09-28 with Docker registry metadata. The
digests are deliberately in `runtime/docker-compose.yaml`, not left to a
mutable `latest` tag.
