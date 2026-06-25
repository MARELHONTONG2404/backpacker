# Backpacker

**Backpacker** adalah platform **marketplace jasa on-demand** — pengguna dapat berperan sebagai pembuat tugas sekaligus pelaksana tugas.

## Komponen

| Folder | Peran |
|---|---|
| `report/` | Backend API (Spring Boot) |
| `report-web/` | Panel admin Backpacker |
| `report-app/` | Aplikasi mobile Flutter |
| `sql/` | Skema database MySQL |

## Alur sistem

```text
Mobile (Flutter)     →  /backpacker/auth/*, /backpacker/orders/*, /backpacker/coins/*
Admin Web (Vue)      →  Dashboard + monitoring pesanan
Backend              →  State machine pesanan (DRAFT → … → COMPLETED)
Database             →  biz_order, sys_user, sys_role
```

Modul **Laporan IWIP** (`biz_report`) masih ada di codebase sebagai legacy base framework, tetapi **disembunyikan** dari menu admin agar fokus produk tetap Backpacker.

## Prasyarat

- Java 17+, Maven 3.9+
- **MySQL 8** (port 3306)
- **Redis 7** (port 6379) — wajib untuk captcha & session token
- Node.js 18+ (admin web)
- Flutter 3.x (mobile)

## Setup cepat

```bash
# 1. Infrastruktur (MySQL + Redis)
docker compose up -d

# 2. Database
chmod +x scripts/setup-database.sh
DB_PASSWORD=iwip123456 ./scripts/setup-database.sh

# 3. Secret backend
cp .env.example .env
# Edit .env — ganti JWT_SECRET dan DB_PASSWORD

# 4. Backend
set -a && source .env && set +a
cd report/iwip-admin && mvn spring-boot:run

# 5. Admin web
cp report-web/.env.example report-web/.env.development
cd report-web && npm install && npm run dev

# 6. Mobile
cd report-app && flutter pub get && flutter run
```

**Panduan lengkap keamanan & database:** [docs/SETUP-KEAMANAN-DATABASE.md](docs/SETUP-KEAMANAN-DATABASE.md)

## Setup database (manual)

```bash
mysql -u iwip -p iwip_manajemen < sql/20260417.sql
mysql -u iwip -p iwip_manajemen < sql/phonenumber_varchar20.sql
mysql -u iwip -p iwip_manajemen < sql/biz_order.sql
mysql -u iwip -p iwip_manajemen < sql/backpacker_auth.sql
mysql -u iwip -p iwip_manajemen < sql/backpacker_unify.sql
mysql -u iwip -p iwip_manajemen < sql/backpacker_coins.sql
mysql -u iwip -p iwip_manajemen < sql/backpacker_reputation.sql
mysql -u iwip -p iwip_manajemen < sql/backpacker_extras.sql
mysql -u iwip -p iwip_manajemen < sql/backpacker_chat.sql
mysql -u iwip -p iwip_manajemen < sql/backpacker_chat_extras.sql
mysql -u iwip -p iwip_manajemen < sql/backpacker_admin_menu.sql
mysql -u iwip -p iwip_manajemen < sql/i18n_menu_id.sql
mysql -u iwip -p iwip_manajemen < sql/i18n_dict_id.sql
mysql -u iwip -p iwip_manajemen < sql/quartz.sql
```

## Menjalankan

```bash
# Backend (dengan env)
set -a && source .env && set +a
cd report/iwip-admin && mvn spring-boot:run

# Admin web
cd report-web && npm run dev

# Mobile (web di smartphone: sesuaikan IP di lib/config/api_config.dart)
cd report-app && flutter run -d web-server --web-port 8888 --web-hostname 0.0.0.0 --release
```
