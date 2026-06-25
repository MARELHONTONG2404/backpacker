#!/usr/bin/env bash
# Refresh port forwarding Windows -> WSL agar HP bisa akses admin/mobile/backend.
# Jalankan setiap kali: PC restart, WSL restart, atau layanan tidak bisa dibuka dari HP.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PS1="${ROOT}/scripts/windows-lan-proxy.ps1"

echo "=== Backpacker — refresh akses LAN ==="
echo "WSL IP: $(hostname -I | awk '{print $1}')"
echo ""

if command -v powershell.exe >/dev/null 2>&1; then
  WIN_PS1="$(wslpath -w "$PS1" 2>/dev/null || echo "$PS1")"
  powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$WIN_PS1" || {
    echo ""
    echo "GAGAL: jalankan PowerShell sebagai Administrator, lalu:"
    echo "  Set-ExecutionPolicy -Scope Process Bypass -Force"
    echo "  $WIN_PS1"
    exit 1
  }
else
  echo "powershell.exe tidak ditemukan. Jalankan manual di Windows (Admin):"
  echo "  scripts/windows-lan-proxy.ps1"
  exit 1
fi

echo ""
echo "=== Cek layanan di WSL ==="
for spec in "8080:Backend" "8888:Mobile" "8890:Admin"; do
  port="${spec%%:*}"
  name="${spec##*:}"
  code="$(curl -s -o /dev/null -w '%{http_code}' "http://127.0.0.1:${port}/" 2>/dev/null || echo 000)"
  if [ "$code" = "200" ] || [ "$code" = "301" ] || [ "$code" = "302" ]; then
    echo "  OK  $name (port $port)"
  else
    echo "  OFF $name (port $port) — HTTP $code — jalankan layanan dulu"
  fi
done

echo ""
echo "Pastikan HP terhubung ke jaringan yang SAMA dengan PC (hotspot/Wi-Fi yang sama)."
