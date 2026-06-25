#!/usr/bin/env bash
# Import semua migrasi Backpacker ke MySQL (urutan wajib).
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
DB_HOST="${DB_HOST:-localhost}"
DB_PORT="${DB_PORT:-3306}"
DB_USER="${DB_USER:-iwip}"
DB_PASSWORD="${DB_PASSWORD:-iwip123456}"
DB_NAME="${DB_NAME:-iwip_manajemen}"

SQL_FILES=(
  "20260417.sql"
  "phonenumber_varchar20.sql"
  "biz_order.sql"
  "backpacker_auth.sql"
  "backpacker_unify.sql"
  "backpacker_coins.sql"
  "backpacker_reputation.sql"
  "backpacker_extras.sql"
  "backpacker_chat.sql"
  "backpacker_chat_extras.sql"
  "backpacker_admin_menu.sql"
  "i18n_menu_id.sql"
  "i18n_dict_id.sql"
  "quartz.sql"
)

echo "==> Backpacker database setup"
echo "    Host: ${DB_HOST}:${DB_PORT}"
echo "    Database: ${DB_NAME}"
echo "    User: ${DB_USER}"
echo ""

for file in "${SQL_FILES[@]}"; do
  path="${ROOT}/sql/${file}"
  if [[ ! -f "$path" ]]; then
    echo "ERROR: missing ${path}" >&2
    exit 1
  fi
  echo "    -> ${file}"
  mysql -h "$DB_HOST" -P "$DB_PORT" -u "$DB_USER" -p"$DB_PASSWORD" "$DB_NAME" < "$path"
done

echo ""
echo "==> Done. Verify:"
mysql -h "$DB_HOST" -P "$DB_PORT" -u "$DB_USER" -p"$DB_PASSWORD" "$DB_NAME" \
  -e "SHOW TABLES LIKE 'biz_order'; SHOW TABLES LIKE 'biz_backpacker_chat_message';"
