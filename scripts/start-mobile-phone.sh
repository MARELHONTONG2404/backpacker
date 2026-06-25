#!/usr/bin/env bash
# Jalankan mobile app + gateway agar HP cukup buka port 8888 (UI + API).
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
APP="$ROOT/report-app"

kill_port() {
  local port="$1"
  local pid
  pid="$(ss -tlnp 2>/dev/null | rg ":${port}" | rg -oP 'pid=\K[0-9]+' | head -1 || true)"
  if [ -n "$pid" ]; then
    kill "$pid" 2>/dev/null || true
    sleep 1
  fi
}

echo "=== Backpacker mobile + gateway ==="
kill_port 8888
kill_port 8889
kill_port 9000

cd "$APP"
flutter pub get
flutter build web --release --no-web-resources-cdn

echo "Starting Flutter internal port 8889..."
flutter run -d web-server --web-port 8889 --web-hostname 127.0.0.1 --release --no-web-resources-cdn &
FLUTTER_PID=$!
sleep 3

echo "Starting phone gateway port 8888..."
node "$ROOT/scripts/phone-gateway.mjs" &
GATEWAY_PID=$!
sleep 2

if curl -s -o /dev/null -w '%{http_code}' http://127.0.0.1:8888/ | rg -q '200'; then
  echo "OK  Gateway http://127.0.0.1:8888"
else
  echo "ERR Gateway tidak merespons"
fi

if curl -s -o /dev/null -w '%{http_code}' http://127.0.0.1:8888/captchaImage | rg -q '200'; then
  echo "OK  API via gateway"
else
  echo "ERR API via gateway gagal"
fi

echo ""
echo "Dari HP (Wi-Fi sama dengan PC):"
echo "  Mobile (disarankan): http://IP-PC-ANDA:8080/app/"
echo "  Mobile (gateway)   : http://IP-PC-ANDA:8888  (sering gagal dari hotspot HP)"
echo "  Admin              : http://IP-PC-ANDA:8890"
echo ""
echo "Refresh port forwarding (PowerShell Admin):"
echo "  D:\\codex\\base\\scripts\\windows-lan-proxy.ps1"
echo ""
echo "Tekan Ctrl+C untuk stop."

wait "$GATEWAY_PID" "$FLUTTER_PID"
