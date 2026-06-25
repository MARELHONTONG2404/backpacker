#!/usr/bin/env bash
# Build Flutter web for serving at http://host:8080/app/ (HP-friendly, same port as API).
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
APP="$ROOT/report-app"

echo "=== Build mobile for backend /app/ ==="
cd "$APP"
flutter pub get
flutter build web --release --base-href /app/ --no-web-resources-cdn

echo ""
echo "OK  Buka di HP: http://IP-LAPTOP:8080/app/"
echo "    Contoh     : http://192.168.137.34:8080/app/"
echo ""
echo "Restart backend agar file baru dilayani:"
echo "  set -a && source .env && set +a && cd report/iwip-admin && mvn spring-boot:run"
