#!/usr/bin/env bash
# Tunnel port 8080 (mobile /app/ + API) — untuk HP saat hotspot tidak bisa akses IP lokal.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
LOG="$ROOT/scripts/.tunnel-cloudflare.log"
CF="/tmp/cloudflared"

curl -sf http://127.0.0.1:8080/app/ >/dev/null || {
  echo "ERROR: Backend + /app/ tidak jalan. Jalankan backend dulu."
  exit 1
}

if [ ! -x "$CF" ]; then
  echo "Mengunduh cloudflared..."
  curl -sL https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 -o "$CF"
  chmod +x "$CF"
fi

pkill -f 'cloudflared tunnel --url http://127.0.0.1:8080' 2>/dev/null || true
sleep 1

echo "=== Tunnel mobile (port 8080) ==="
"$CF" tunnel --url http://127.0.0.1:8080 2>&1 | tee "$LOG" &
sleep 8

URL=$(rg -o 'https://[a-z0-9-]+\.trycloudflare\.com' "$LOG" | head -1 || true)
if [ -z "$URL" ]; then
  echo "ERROR: Gagal membuat tunnel. Lihat $LOG"
  exit 1
fi

{
  echo "Mobile: ${URL}/app/"
  echo "API:    ${URL}/"
  echo "Dibuat: $(date)"
} | tee "$ROOT/scripts/.tunnel-urls.txt"

echo ""
echo "Buka di HP (Wi-Fi atau mobile data):"
echo "  ${URL}/app/"
echo ""
echo "Tunnel aktif selama terminal ini berjalan."

wait
