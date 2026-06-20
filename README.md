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

## Setup database

```bash
mysql -u iwip -p iwip_manajemen < sql/20260417.sql
mysql -u iwip -p iwip_manajemen < sql/biz_order.sql
mysql -u iwip -p iwip_manajemen < sql/backpacker_auth.sql
mysql -u iwip -p iwip_manajemen < sql/backpacker_unify.sql
mysql -u iwip -p iwip_manajemen < sql/backpacker_coins.sql
```

## Menjalankan

```bash
# Backend
cd report/iwip-admin && mvn spring-boot:run

# Admin web
cd report-web && npm install && npm run dev

# Mobile
cd report-app && flutter pub get && flutter run
```
