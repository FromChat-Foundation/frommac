#!/usr/bin/env bash
# DEV ONLY: CORS proxy (curl-backed) + Flutter web
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
export PATH="${HOME}/flutter/bin:/opt/homebrew/bin:${PATH}"
cd "$ROOT"

PROXY_PORT="${FROMCHAT_PROXY_PORT:-8787}"
PROXY_HOST="127.0.0.1"
PROXY_PID=""

proxy_health() {
  curl -sf -m 2 "http://${PROXY_HOST}:${PROXY_PORT}/__health" >/dev/null
}

kill_stale_proxy() {
  # Old proxy may be hung on urllib timeouts — free the port.
  local pids
  pids="$(lsof -tiTCP:"${PROXY_PORT}" -sTCP:LISTEN 2>/dev/null || true)"
  if [[ -n "${pids}" ]]; then
    echo "Stopping previous process on :${PROXY_PORT} ..."
    # shellcheck disable=SC2086
    kill ${pids} 2>/dev/null || true
    sleep 0.4
  fi
}

start_proxy() {
  kill_stale_proxy
  PYTHONUNBUFFERED=1 python3 "$ROOT/tool/cors_proxy.py" --port "$PROXY_PORT" &
  PROXY_PID=$!
  for _ in $(seq 1 30); do
    if proxy_health; then
      return 0
    fi
    sleep 0.2
  done
  echo "ERROR: proxy health check failed on :${PROXY_PORT}" >&2
  return 1
}

if proxy_health; then
  echo "Proxy already healthy on http://${PROXY_HOST}:${PROXY_PORT}"
else
  start_proxy
fi

# Quick upstream smoke (non-fatal)
if curl -sf -m 15 "http://${PROXY_HOST}:${PROXY_PORT}/instance_id" >/dev/null; then
  echo "Upstream OK via proxy"
else
  echo "WARN: proxy is up, but api.fromchat.ru timed out through it."
  echo "      Try: curl -m 15 https://api.fromchat.ru/instance_id"
fi

cleanup() {
  if [[ -n "${PROXY_PID}" ]]; then
    kill "$PROXY_PID" 2>/dev/null || true
  fi
}
trap cleanup EXIT

echo ""
echo "=== FromChat DEV web ==="
echo "HTTP proxy: http://${PROXY_HOST}:${PROXY_PORT}  →  api.fromchat.ru"
echo "WebSocket:  wss://api.fromchat.ru/chat/ws  (direct, not via proxy)"
echo "Starting Flutter (Chrome)..."
echo "========================"
echo ""

flutter run -d chrome \
  --dart-define=FROMCHAT_WEB_PROXY="${PROXY_HOST}:${PROXY_PORT}"
