#!/usr/bin/env bash
# Buat URL publik untuk akses dari HP (tanpa Wi-Fi/hotspot).
# Mobile lewat gateway port 8888 (UI + API). Admin port 8890.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
LOG="$ROOT/scripts/.tunnel-urls.txt"

kill_lt() {
  pkill -f "localtunnel --port $1" 2>/dev/null || true
}

echo "=== Backpacker — tunnel untuk HP ==="

# Pastikan gateway & admin jalan
curl -sf http://127.0.0.1:8888/ >/dev/null || {
  echo "ERROR: Mobile gateway (8888) tidak jalan."
  echo "Jalankan dulu: bash scripts/start-mobile-phone.sh"
  exit 1
}
curl -sf http://127.0.0.1:8890/ >/dev/null || {
  echo "ERROR: Admin (8890) tidak jalan."
  echo "Jalankan: cd report-web && npm run dev"
  exit 1
}

kill_lt 8888
kill_lt 8890
sleep 1

MOBILE_LOG=$(mktemp)
ADMIN_LOG=$(mktemp)

npx --yes localtunnel --port 8888 >"$MOBILE_LOG" 2>&1 &
npx --yes localtunnel --port 8890 >"$ADMIN_LOG" 2>&1 &

echo "Menunggu URL tunnel..."
for i in $(seq 1 30); do
  MOBILE_URL=$(rg -o 'https://[a-z0-9-]+\.loca\.lt' "$MOBILE_LOG" | head -1 || true)
  ADMIN_URL=$(rg -o 'https://[a-z0-9-]+\.loca\.lt' "$ADMIN_LOG" | head -1 || true)
  if [ -n "$MOBILE_URL" ] && [ -n "$ADMIN_URL" ]; then
    break
  fi
  sleep 1
done

if [ -z "$MOBILE_URL" ] || [ -z "$ADMIN_URL" ]; then
  echo "ERROR: Gagal membuat tunnel. Log mobile:"
  cat "$MOBILE_LOG"
  echo "--- admin ---"
  cat "$ADMIN_LOG"
  exit 1
fi

{
  echo "Mobile: $MOBILE_URL"
  echo "Admin:  $ADMIN_URL"
  echo "Dibuat: $(date)"
} | tee "$LOG"

echo ""
echo "Buka di HP (bisa pakai mobile data / Wi-Fi apa saja):"
echo "  Mobile : $MOBILE_URL"
echo "  Admin  : $ADMIN_URL"
echo ""
echo "Catatan:"
echo "  - Halaman pertama localtunnel mungkin minta klik 'Click to Continue'."
echo "  - Tunnel aktif selama terminal ini berjalan."
echo "  - URL disimpan di: scripts/.tunnel-urls.txt"
echo ""
echo "Tekan Ctrl+C untuk stop tunnel."

wait
