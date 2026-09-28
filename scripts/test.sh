#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"; cd "$ROOT"
python3 - <<'PY'
import json, pathlib
manifest = json.loads(pathlib.Path('service.json').read_text())
assert manifest['id'] == 'nango'
assert manifest['artifact']['source']['repo'] == 'service-lasso/lasso-nango'
assert next(endpoint for endpoint in manifest['endpoints'] if endpoint['id'] == 'server')['bind'] == '127.0.0.1'
assert manifest['healthchecks'][0]['type'] == 'http'
for name in ['runtime/docker-compose.yaml', 'runtime/nango-service.ps1', 'runtime/nango-stop.ps1', 'runtime/nango-service.sh', 'runtime/nango-stop.sh', 'UPSTREAM.md']:
    assert pathlib.Path(name).is_file(), f'missing {name}'
compose = pathlib.Path('runtime/docker-compose.yaml').read_text()
for value in ['hosted-0.71.10@sha256:b4e96e827f8a27c6ab108602f1850325250ac31636db5cf392c1d08fde8a79c5', 'postgres:16.0-alpine@sha256:acf5271bbecd4b8733f4e93959a8d2b536a57aeee6cc4b6a71890aaf646425b8', 'NANGO_BIND']:
    assert value in compose, f'missing {value}'
PY
bash -n runtime/nango-service.sh runtime/nango-stop.sh scripts/package.sh scripts/test.sh scripts/verify.sh
echo 'Nango package static tests passed (POSIX)'
