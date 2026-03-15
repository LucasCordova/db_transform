#!/bin/bash
set -euo pipefail

log() {
  echo "[$(date '+%Y-%m-%dT%H:%M:%S%z')] $*"
}

if [ -z "${TRANSFORM_SQL:-}" ]; then
  log "ERROR: TRANSFORM_SQL is not set. Set it in Railway Variables with the SQL to run."
  exit 1
fi

if [ -z "${DATABASE_URL:-}" ]; then
  log "ERROR: DATABASE_URL is not set."
  exit 1
fi

log "Starting database transform..."

if [ "${DEBUG:-false}" = "true" ] || [ "${DEBUG:-0}" = "1" ]; then
  log "DEBUG: DATABASE_URL is set: yes"
  log "DEBUG: SQL to execute:"
  printf '%s\n' "$TRANSFORM_SQL" | while IFS= read -r line; do log "  $line"; done
  output=$(printf '%s\n' "$TRANSFORM_SQL" | psql "$DATABASE_URL" 2>&1)
  code=$?
  echo "$output" | while IFS= read -r line; do log "psql: $line"; done
  if [ $code -ne 0 ]; then
    log "DEBUG: Exited with code $code"
    exit $code
  fi
  log "DEBUG: Completed successfully"
else
  printf '%s\n' "$TRANSFORM_SQL" | psql "$DATABASE_URL"
fi

log "Done."
