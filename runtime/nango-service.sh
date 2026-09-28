#!/usr/bin/env bash
set -euo pipefail
ARTIFACT_ROOT="${SERVICE_ARTIFACT_ROOT:-$(cd "$(dirname "$0")/.." && pwd)}"; SERVICE_ROOT="${SERVICE_ROOT:-$ARTIFACT_ROOT}"; COMPOSE="$ARTIFACT_ROOT/runtime/docker-compose.yaml"; STATE="$SERVICE_ROOT/.state"; DATA="$SERVICE_ROOT/data"; ENV_FILE="$STATE/nango.env"; PROJECT="${NANGO_COMPOSE_PROJECT:-lasso-nango}"
command -v docker >/dev/null 2>&1 || { echo 'Docker Engine with Compose v2 is required to run Nango.' >&2; exit 1; }; docker compose version >/dev/null; [[ -f "$COMPOSE" ]] || { echo "Missing packaged Compose file: $COMPOSE" >&2; exit 1; }; mkdir -p "$STATE" "$DATA"; chmod 700 "$STATE"
secret() { openssl rand -base64 "$1" | tr -d '\n'; }
database_secret() { openssl rand -hex 24; }
if [[ ! -f "$ENV_FILE" ]]; then
  umask 077
  cat > "$ENV_FILE" <<EOF
NANGO_BIND=${NANGO_BIND:-127.0.0.1}
NANGO_HTTP_PORT=${NANGO_HTTP_PORT:-3003}
NANGO_CONNECT_PORT=${NANGO_CONNECT_PORT:-3009}
NANGO_SERVER_URL=${NANGO_SERVER_URL:-http://127.0.0.1:3003}
NANGO_PUBLIC_CONNECT_URL=${NANGO_PUBLIC_CONNECT_URL:-http://127.0.0.1:3009}
NANGO_DATA_PATH=$DATA
NANGO_DB_NAME=nango
NANGO_DB_USER=nango
NANGO_DB_PASSWORD=$(database_secret)
NANGO_ENCRYPTION_KEY=$(secret 32)
NANGO_ADMIN_KEY=$(secret 32)
NANGO_DASHBOARD_USERNAME=admin
NANGO_DASHBOARD_PASSWORD=$(secret 24)
EOF
  chmod 600 "$ENV_FILE"
fi
exec docker compose --project-name "$PROJECT" --env-file "$ENV_FILE" -f "$COMPOSE" up --remove-orphans
