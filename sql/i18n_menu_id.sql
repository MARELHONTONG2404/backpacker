-- Lokalisasi menu ke Bahasa Indonesia
-- Jalankan: mysql -u iwip -piwip123456 iwip_manajemen < base/sql/i18n_menu_id.sql

UPDATE sys_menu SET menu_name = 'Manajemen Sistem' WHERE menu_id = 1;
UPDATE sys_menu SET menu_name = 'Monitoring Sistem' WHERE menu_id = 2;
UPDATE sys_menu SET menu_name = 'Alat Sistem' WHERE menu_id = 3;
UPDATE sys_menu SET menu_name = 'Manajemen User' WHERE menu_id = 100;
UPDATE sys_menu SET menu_name = 'Manajemen Role' WHERE menu_id = 101;
UPDATE sys_menu SET menu_name = 'Manajemen Menu' WHERE menu_id = 102;
UPDATE sys_menu SET menu_name = 'Manajemen Departemen' WHERE menu_id = 103;
UPDATE sys_menu SET menu_name = 'Manajemen Jabatan' WHERE menu_id = 104;
UPDATE sys_menu SET menu_name = 'Manajemen Kamus Data' WHERE menu_id = 105;
UPDATE sys_menu SET menu_name = 'Pengaturan Parameter' WHERE menu_id = 106;
UPDATE sys_menu SET menu_name = 'Pengumuman' WHERE menu_id = 107;
UPDATE sys_menu SET menu_name = 'Manajemen Log' WHERE menu_id = 108;
UPDATE sys_menu SET menu_name = 'User Online' WHERE menu_id = 109;
UPDATE sys_menu SET menu_name = 'Tugas Terjadwal' WHERE menu_id = 110;
UPDATE sys_menu SET menu_name = 'Monitoring Server' WHERE menu_id = 112;
UPDATE sys_menu SET menu_name = 'Monitoring Cache' WHERE menu_id = 113;
UPDATE sys_menu SET menu_name = 'Daftar Cache' WHERE menu_id = 114;
UPDATE sys_menu SET menu_name = 'Log Operasi' WHERE menu_id = 500;
UPDATE sys_menu SET menu_name = 'Log Login' WHERE menu_id = 501;
UPDATE sys_menu SET menu_name = 'Manajemen Laporan' WHERE menu_id = 2100;
UPDATE sys_menu SET menu_name = 'Daftar Laporan' WHERE menu_id = 2101;

-- Tombol user
UPDATE sys_menu SET menu_name = 'Cari User' WHERE menu_id = 1000;
UPDATE sys_menu SET menu_name = 'Tambah User' WHERE menu_id = 1001;
UPDATE sys_menu SET menu_name = 'Ubah User' WHERE menu_id = 1002;
UPDATE sys_menu SET menu_name = 'Hapus User' WHERE menu_id = 1003;
UPDATE sys_menu SET menu_name = 'Ekspor User' WHERE menu_id = 1004;
UPDATE sys_menu SET menu_name = 'Impor User' WHERE menu_id = 1005;
UPDATE sys_menu SET menu_name = 'Reset Kata Sandi' WHERE menu_id = 1006;
-- Tombol role
UPDATE sys_menu SET menu_name = 'Cari Role' WHERE menu_id = 1007;
UPDATE sys_menu SET menu_name = 'Tambah Role' WHERE menu_id = 1008;
UPDATE sys_menu SET menu_name = 'Ubah Role' WHERE menu_id = 1009;
UPDATE sys_menu SET menu_name = 'Hapus Role' WHERE menu_id = 1010;
UPDATE sys_menu SET menu_name = 'Ekspor Role' WHERE menu_id = 1011;
-- Tombol menu
UPDATE sys_menu SET menu_name = 'Cari Menu' WHERE menu_id = 1012;
UPDATE sys_menu SET menu_name = 'Tambah Menu' WHERE menu_id = 1013;
UPDATE sys_menu SET menu_name = 'Ubah Menu' WHERE menu_id = 1014;
UPDATE sys_menu SET menu_name = 'Hapus Menu' WHERE menu_id = 1015;
-- Tombol departemen
UPDATE sys_menu SET menu_name = 'Cari Departemen' WHERE menu_id = 1016;
UPDATE sys_menu SET menu_name = 'Tambah Departemen' WHERE menu_id = 1017;
UPDATE sys_menu SET menu_name = 'Ubah Departemen' WHERE menu_id = 1018;
UPDATE sys_menu SET menu_name = 'Hapus Departemen' WHERE menu_id = 1019;
-- Tombol jabatan
UPDATE sys_menu SET menu_name = 'Cari Jabatan' WHERE menu_id = 1020;
UPDATE sys_menu SET menu_name = 'Tambah Jabatan' WHERE menu_id = 1021;
UPDATE sys_menu SET menu_name = 'Ubah Jabatan' WHERE menu_id = 1022;
UPDATE sys_menu SET menu_name = 'Hapus Jabatan' WHERE menu_id = 1023;
UPDATE sys_menu SET menu_name = 'Ekspor Jabatan' WHERE menu_id = 1024;
-- Tombol kamus data
UPDATE sys_menu SET menu_name = 'Cari Kamus' WHERE menu_id = 1025;
UPDATE sys_menu SET menu_name = 'Tambah Kamus' WHERE menu_id = 1026;
UPDATE sys_menu SET menu_name = 'Ubah Kamus' WHERE menu_id = 1027;
UPDATE sys_menu SET menu_name = 'Hapus Kamus' WHERE menu_id = 1028;
UPDATE sys_menu SET menu_name = 'Ekspor Kamus' WHERE menu_id = 1029;
-- Tombol parameter
UPDATE sys_menu SET menu_name = 'Cari Parameter' WHERE menu_id = 1030;
UPDATE sys_menu SET menu_name = 'Tambah Parameter' WHERE menu_id = 1031;
UPDATE sys_menu SET menu_name = 'Ubah Parameter' WHERE menu_id = 1032;
UPDATE sys_menu SET menu_name = 'Hapus Parameter' WHERE menu_id = 1033;
UPDATE sys_menu SET menu_name = 'Ekspor Parameter' WHERE menu_id = 1034;
-- Tombol pengumuman
UPDATE sys_menu SET menu_name = 'Cari Pengumuman' WHERE menu_id = 1035;
UPDATE sys_menu SET menu_name = 'Tambah Pengumuman' WHERE menu_id = 1036;
UPDATE sys_menu SET menu_name = 'Ubah Pengumuman' WHERE menu_id = 1037;
UPDATE sys_menu SET menu_name = 'Hapus Pengumuman' WHERE menu_id = 1038;
-- Tombol log operasi
UPDATE sys_menu SET menu_name = 'Cari Log Operasi' WHERE menu_id = 1039;
UPDATE sys_menu SET menu_name = 'Hapus Log Operasi' WHERE menu_id = 1040;
UPDATE sys_menu SET menu_name = 'Ekspor Log Operasi' WHERE menu_id = 1041;
-- Tombol log login
UPDATE sys_menu SET menu_name = 'Cari Log Login' WHERE menu_id = 1042;
UPDATE sys_menu SET menu_name = 'Hapus Log Login' WHERE menu_id = 1043;
UPDATE sys_menu SET menu_name = 'Ekspor Log Login' WHERE menu_id = 1044;
UPDATE sys_menu SET menu_name = 'Buka Kunci Akun' WHERE menu_id = 1045;
-- Tombol user online
UPDATE sys_menu SET menu_name = 'Cari Online' WHERE menu_id = 1046;
UPDATE sys_menu SET menu_name = 'Keluar Paksa Massal' WHERE menu_id = 1047;
UPDATE sys_menu SET menu_name = 'Keluar Paksa' WHERE menu_id = 1048;
-- Tombol tugas terjadwal
UPDATE sys_menu SET menu_name = 'Cari Tugas' WHERE menu_id = 1049;
UPDATE sys_menu SET menu_name = 'Tambah Tugas' WHERE menu_id = 1050;
UPDATE sys_menu SET menu_name = 'Ubah Tugas' WHERE menu_id = 1051;
UPDATE sys_menu SET menu_name = 'Hapus Tugas' WHERE menu_id = 1052;
UPDATE sys_menu SET menu_name = 'Ubah Status' WHERE menu_id = 1053;
UPDATE sys_menu SET menu_name = 'Ekspor Tugas' WHERE menu_id = 1054;
