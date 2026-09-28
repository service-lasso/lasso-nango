#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"; cd "$ROOT"
command -v docker >/dev/null 2>&1 || { echo 'Docker is required for the Nango smoke test.' >&2; exit 1; }
TMP="$(mktemp -d)"; PROJECT="lasso-nango-verify-$$"; LOG="$TMP/nango.log"
cleanup() { SERVICE_ROOT="$TMP" SERVICE_ARTIFACT_ROOT="$ROOT" NANGO_COMPOSE_PROJECT="$PROJECT" bash "$ROOT/runtime/nango-stop.sh" >/dev/null 2>&1 || true; rm -rf "$TMP"; }
trap cleanup EXIT
export SERVICE_ROOT="$TMP" SERVICE_ARTIFACT_ROOT="$ROOT" NANGO_COMPOSE_PROJECT="$PROJECT"
export NANGO_BIND=127.0.0.1 NANGO_HTTP_PORT=13003 NANGO_CONNECT_PORT=13009 NANGO_SERVER_URL=http://127.0.0.1:13003 NANGO_PUBLIC_CONNECT_URL=http://127.0.0.1:13009
bash "$ROOT/runtime/nango-service.sh" >"$LOG" 2>&1 &
PID=$!
for _ in $(seq 1 150); do
  if curl --fail --silent --show-error http://127.0.0.1:13003/health >/dev/null; then
    kill "$PID" 2>/dev/null || true
    wait "$PID" 2>/dev/null || true
    echo 'Nango Docker smoke test passed (Linux)'
    exit 0
  fi
  if ! kill -0 "$PID" 2>/dev/null; then cat "$LOG" >&2; exit 1; fi
  sleep 1
done
cat "$LOG" >&2
exit 1
