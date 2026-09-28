#!/usr/bin/env bash
set -euo pipefail
ARTIFACT_ROOT="${SERVICE_ARTIFACT_ROOT:-$(cd "$(dirname "$0")/.." && pwd)}"; SERVICE_ROOT="${SERVICE_ROOT:-$ARTIFACT_ROOT}"; ENV_FILE="$SERVICE_ROOT/.state/nango.env"; COMPOSE="$ARTIFACT_ROOT/runtime/docker-compose.yaml"; PROJECT="${NANGO_COMPOSE_PROJECT:-lasso-nango}"
if [[ ! -f "$ENV_FILE" ]]; then echo 'Nango has not been initialized; nothing to stop.'; exit 0; fi
exec docker compose --project-name "$PROJECT" --env-file "$ENV_FILE" -f "$COMPOSE" down --remove-orphans
