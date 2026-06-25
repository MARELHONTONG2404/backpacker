# Setup Keamanan & Database — Backpacker (Step by Step)

Panduan ini fokus pada **dua area prioritas**: database lengkap + hardening keamanan dasar.
Ikuti urutan di bawah; setiap langkah punya **cek** agar Anda tahu sudah benar.

---

## Ringkasan langkah

| # | Langkah | Estimasi |
|---|---------|----------|
| 1 | Prasyarat (MySQL, Redis, Java, Node, Flutter) | 15–30 menit |
| 2 | Jalankan infrastruktur (Docker atau manual) | 10 menit |
| 3 | Import database (urutan SQL) | 10 menit |
| 4 | Konfigurasi secret backend (`.env`) | 5 menit |
| 5 | Verifikasi backend | 5 menit |
| 6 | Konfigurasi admin web | 5 menit |
| 7 | Konfigurasi mobile app | 5 menit |
| 8 | Checklist keamanan sebelum production | 15 menit |

---

## Langkah 1 — Prasyarat

Pastikan terpasang:

- **Java 17+** — `java -version`
- **Maven 3.9+** — `mvn -version`
- **MySQL 8** — `mysql --version`
- **Redis 7** — `redis-cli ping` → harus `PONG`
- **Node.js 18+** — `node -version`
- **Flutter 3.x** — `flutter --version`

> **Penting:** Backend membutuhkan **MySQL dan Redis** berjalan. Redis dipakai untuk captcha dan session token — tanpa Redis, login bisa gagal.

---

## Langkah 2 — Infrastruktur

### Opsi A — Docker (disarankan untuk dev)

```bash
cd /path/ke/base
docker compose up -d
```

Tunggu MySQL siap:

```bash
docker compose exec mysql mysqladmin ping -h localhost -u root -proot
```

**Cek:** output `mysqld is alive`

### Opsi B — Manual

- Start MySQL di port `3306`
- Start Redis di port `6379`
- Buat database: `CREATE DATABASE iwip_manajemen CHARACTER SET utf8mb4;`
- Buat user (contoh dev):

```sql
CREATE USER 'iwip'@'localhost' IDENTIFIED BY 'ganti-password-kuat';
GRANT ALL ON iwip_manajemen.* TO 'iwip'@'localhost';
FLUSH PRIVILEGES;
```

---

## Langkah 3 — Import database

### Opsi A — Script otomatis

```bash
chmod +x scripts/setup-database.sh
DB_USER=iwip DB_PASSWORD=password-anda DB_NAME=iwip_manajemen ./scripts/setup-database.sh
```

### Opsi B — Manual (urutan wajib)

```bash
export DB_USER=iwip
export DB_PASS=password-anda
export DB_NAME=iwip_manajemen

mysql -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" < sql/20260417.sql
mysql -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" < sql/phonenumber_varchar20.sql
mysql -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" < sql/biz_order.sql
mysql -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" < sql/backpacker_auth.sql
mysql -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" < sql/backpacker_unify.sql
mysql -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" < sql/backpacker_coins.sql
mysql -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" < sql/backpacker_reputation.sql
mysql -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" < sql/backpacker_extras.sql
mysql -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" < sql/backpacker_chat.sql
mysql -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" < sql/backpacker_chat_extras.sql
mysql -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" < sql/backpacker_admin_menu.sql
mysql -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" < sql/i18n_menu_id.sql
mysql -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" < sql/i18n_dict_id.sql
mysql -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" < sql/quartz.sql
```

**Cek:**

```bash
mysql -u iwip -p iwip_manajemen -e "SHOW TABLES LIKE 'biz_order'; SHOW TABLES LIKE 'biz_backpacker_chat_message';"
```

Harus menampilkan kedua tabel.

**Git:** pastikan file `sql/backpacker_chat.sql` dan `sql/backpacker_chat_extras.sql` sudah di-commit agar clone baru tidak kehilangan migrasi chat.

---

## Langkah 4 — Secret backend

### 4.1 Salin template environment

```bash
cp .env.example .env
```

### 4.2 Isi `.env` (jangan commit file ini)

| Variabel | Contoh | Keterangan |
|----------|--------|------------|
| `SPRING_PROFILES_ACTIVE` | `dev` | Gunakan `prod` di server |
| `DB_PASSWORD` | password kuat | Password MySQL |
| `JWT_SECRET` | string acak ≥32 karakter | **Wajib ganti** di production |
| `REDIS_HOST` | `localhost` | Host Redis |
| `IWIP_UPLOAD_PATH` | `/home/user/iwip/uploadPath` | Folder upload gambar |
| `CORS_ALLOWED_ORIGINS` | `https://admin.domain.com` | Wajib di production |

Generate JWT secret:

```bash
openssl rand -base64 48
```

### 4.3 Load env saat menjalankan backend

```bash
set -a && source .env && set +a
cd report/iwip-admin && mvn spring-boot:run
```

Atau export manual:

```bash
export DB_PASSWORD=...
export JWT_SECRET=...
export SPRING_PROFILES_ACTIVE=dev
cd report/iwip-admin && mvn spring-boot:run
```

**Cek:**

```bash
curl -s -o /dev/null -w "%{http_code}" http://localhost:8080/
```

Harus `200`.

---

## Langkah 5 — Verifikasi backend & Redis

```bash
# Redis
redis-cli ping

# Login captcha (butuh Redis)
curl -s http://localhost:8080/captchaImage | head -c 80
```

Jika captcha mengembalikan JSON dengan `uuid`, Redis OK.

---

## Langkah 6 — Admin web

```bash
cp report-web/.env.example report-web/.env.development
cd report-web && npm install && npm run dev
```

Buka http://localhost:5173 — **form login tidak lagi pre-filled** `admin/admin123`.

**Production checklist admin:**
- Ganti password default user `admin` di database
- Deploy di belakang HTTPS (nginx)
- Set `VITE_APP_BASE_API` ke `/prod-api` + proxy nginx ke backend

---

## Langkah 7 — Mobile app

Edit `report-app/lib/config/api_config.dart`:

```dart
// Kosongkan untuk auto-detect (emulator/local)
static const String hostOverride = '';

// Atau IP PC untuk device fisik (satu WiFi):
static const String hostOverride = 'http://192.168.x.x:8080';
```

Jalankan:

```bash
cd report-app
flutter pub get
flutter run -d web-server --web-port 8888 --web-hostname 0.0.0.0 --release
```

**Perubahan keamanan mobile:**
- "Remember me" hanya menyimpan **username**, tidak lagi password plain text
- Untuk production: build dengan `--dart-define=API_BASE_URL=https://api.domain.com` (rencana lanjutan)

---

## Langkah 8 — Checklist keamanan sebelum production

Centang semua sebelum go-live:

### Database & infrastruktur
- [ ] Semua script SQL di `sql/` sudah di-import
- [ ] Backup otomatis MySQL dijadwalkan
- [ ] Folder upload (`IWIP_UPLOAD_PATH`) ada backup

### Backend
- [ ] `SPRING_PROFILES_ACTIVE=prod`
- [ ] `JWT_SECRET` unik & panjang (bukan default)
- [ ] `DB_PASSWORD` kuat, bukan `iwip123456`
- [ ] `CORS_ALLOWED_ORIGINS` hanya domain Anda (bukan `*`)
- [ ] HTTPS via reverse proxy (nginx/Caddy)
- [ ] **Reset password:** tambahkan OTP SMS/email (saat ini hanya username+HP — risiko tinggi)

### Admin web
- [ ] Password admin default diganti
- [ ] `.env.production` tidak di-commit

### Mobile
- [ ] `hostOverride` pakai HTTPS domain production
- [ ] `usesCleartextTraffic=false` di Android (setelah HTTPS)
- [ ] Release APK pakai keystore sendiri (bukan debug signing)

### Git
- [ ] File `.env` tidak ter-commit
- [ ] `sql/backpacker_chat*.sql` sudah di repo

---

## Troubleshooting

| Gejala | Penyebab | Solusi |
|--------|----------|--------|
| Login gagal "captcha" | Redis mati | `redis-cli ping`, start Redis |
| Chat error / upload gagal | SQL chat belum import | Jalankan `backpacker_chat.sql` + extras |
| Mobile tidak connect API | IP salah | Sesuaikan `hostOverride` dengan IP PC |
| CORS error di browser | Origin tidak diizinkan | Set `CORS_ALLOWED_ORIGINS` |

---

## Langkah berikutnya (setelah fase ini)

1. Refund koin saat order cancel/expired
2. OTP untuk reset password
3. Docker Compose full stack (backend + nginx)
4. CI/CD + automated tests

---

*Terakhir diperbarui: sesuai implementasi fase keamanan + database Backpacker.*
