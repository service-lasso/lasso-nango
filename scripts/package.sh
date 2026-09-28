#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"; DIST="$ROOT/dist"
case "$(uname -s)" in Linux*) PLATFORM=linux ;; Darwin*) PLATFORM=darwin ;; *) echo 'Unsupported OS for package.sh' >&2; exit 1 ;; esac
STAGE="$DIST/lasso-nango-$PLATFORM"; ARCHIVE="$DIST/lasso-nango-$PLATFORM.tar.gz"
mkdir -p "$DIST"; rm -rf "$STAGE"; mkdir -p "$STAGE"
cp -R "$ROOT/runtime" "$STAGE/runtime"; cp "$ROOT/service.json" "$ROOT/UPSTREAM.md" "$STAGE/"
chmod +x "$STAGE/runtime/nango-service.sh" "$STAGE/runtime/nango-stop.sh"
tar -czf "$ARCHIVE" -C "$STAGE" .
echo "Created $ARCHIVE"
