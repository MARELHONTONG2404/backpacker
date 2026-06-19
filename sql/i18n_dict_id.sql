-- Lokalisasi kamus data, departemen, dan role ke Bahasa Indonesia
-- Jalankan: mysql -u iwip -piwip123456 iwip_manajemen < base/sql/i18n_dict_id.sql

-- Departemen
UPDATE sys_dept SET dept_name = 'Kawasan Wedabe' WHERE dept_id = 100;

-- Role
UPDATE sys_role SET role_name = 'Super Admin', remark = 'Super Admin' WHERE role_id = 1;
UPDATE sys_role SET role_name = 'Role Biasa', remark = 'Role Biasa' WHERE role_id = 2;

-- Tipe kamus data
UPDATE sys_dict_type SET dict_name = 'Jenis Kelamin', remark = 'Daftar jenis kelamin user' WHERE dict_id = 1;
UPDATE sys_dict_type SET dict_name = 'Status Menu', remark = 'Daftar status menu' WHERE dict_id = 2;
UPDATE sys_dict_type SET dict_name = 'Status Sistem', remark = 'Daftar status aktif/nonaktif' WHERE dict_id = 3;
UPDATE sys_dict_type SET dict_name = 'Status Tugas', remark = 'Daftar status tugas terjadwal' WHERE dict_id = 4;
UPDATE sys_dict_type SET dict_name = 'Grup Tugas', remark = 'Daftar grup tugas terjadwal' WHERE dict_id = 5;
UPDATE sys_dict_type SET dict_name = 'Ya/Tidak', remark = 'Daftar opsi ya/tidak' WHERE dict_id = 6;
UPDATE sys_dict_type SET dict_name = 'Tipe Notifikasi', remark = 'Daftar tipe notifikasi' WHERE dict_id = 7;
UPDATE sys_dict_type SET dict_name = 'Status Notifikasi', remark = 'Daftar status notifikasi' WHERE dict_id = 8;
UPDATE sys_dict_type SET dict_name = 'Tipe Operasi', remark = 'Daftar tipe operasi log' WHERE dict_id = 9;
UPDATE sys_dict_type SET dict_name = 'Status Umum', remark = 'Daftar status login' WHERE dict_id = 10;

-- Data kamus: jenis kelamin
UPDATE sys_dict_data SET dict_label = 'Laki-laki', remark = 'Jenis kelamin laki-laki' WHERE dict_code = 1;
UPDATE sys_dict_data SET dict_label = 'Perempuan', remark = 'Jenis kelamin perempuan' WHERE dict_code = 2;
UPDATE sys_dict_data SET dict_label = 'Tidak diketahui', remark = 'Jenis kelamin tidak diketahui' WHERE dict_code = 3;

-- Data kamus: tampilan menu
UPDATE sys_dict_data SET dict_label = 'Tampil', remark = 'Menu ditampilkan' WHERE dict_code = 4;
UPDATE sys_dict_data SET dict_label = 'Sembunyi', remark = 'Menu disembunyikan' WHERE dict_code = 5;

-- Data kamus: status normal/nonaktif
UPDATE sys_dict_data SET dict_label = 'Normal', remark = 'Status normal' WHERE dict_code = 6;
UPDATE sys_dict_data SET dict_label = 'Nonaktif', remark = 'Status nonaktif' WHERE dict_code = 7;

-- Data kamus: status tugas
UPDATE sys_dict_data SET dict_label = 'Normal', remark = 'Tugas berjalan normal' WHERE dict_code = 8;
UPDATE sys_dict_data SET dict_label = 'Dijeda', remark = 'Tugas dijeda' WHERE dict_code = 9;

-- Data kamus: grup tugas
UPDATE sys_dict_data SET dict_label = 'Default', remark = 'Grup default' WHERE dict_code = 10;
UPDATE sys_dict_data SET dict_label = 'Sistem', remark = 'Grup sistem' WHERE dict_code = 11;

-- Data kamus: ya/tidak
UPDATE sys_dict_data SET dict_label = 'Ya', remark = 'Opsi ya' WHERE dict_code = 12;
UPDATE sys_dict_data SET dict_label = 'Tidak', remark = 'Opsi tidak' WHERE dict_code = 13;

-- Data kamus: tipe notifikasi
UPDATE sys_dict_data SET dict_label = 'Notifikasi', remark = 'Tipe notifikasi' WHERE dict_code = 14;
UPDATE sys_dict_data SET dict_label = 'Pengumuman', remark = 'Tipe pengumuman' WHERE dict_code = 15;

-- Data kamus: status notifikasi
UPDATE sys_dict_data SET dict_label = 'Normal', remark = 'Status normal' WHERE dict_code = 16;
UPDATE sys_dict_data SET dict_label = 'Ditutup', remark = 'Status ditutup' WHERE dict_code = 17;

-- Data kamus: tipe operasi
UPDATE sys_dict_data SET dict_label = 'Lainnya', remark = 'Operasi lainnya' WHERE dict_code = 18;
UPDATE sys_dict_data SET dict_label = 'Tambah', remark = 'Operasi tambah' WHERE dict_code = 19;
UPDATE sys_dict_data SET dict_label = 'Ubah', remark = 'Operasi ubah' WHERE dict_code = 20;
UPDATE sys_dict_data SET dict_label = 'Hapus', remark = 'Operasi hapus' WHERE dict_code = 21;
UPDATE sys_dict_data SET dict_label = 'Otorisasi', remark = 'Operasi otorisasi' WHERE dict_code = 22;
UPDATE sys_dict_data SET dict_label = 'Ekspor', remark = 'Operasi ekspor' WHERE dict_code = 23;
UPDATE sys_dict_data SET dict_label = 'Impor', remark = 'Operasi impor' WHERE dict_code = 24;
UPDATE sys_dict_data SET dict_label = 'Keluar Paksa', remark = 'Operasi keluar paksa' WHERE dict_code = 25;
UPDATE sys_dict_data SET dict_label = 'Hapus Data', remark = 'Operasi hapus data' WHERE dict_code = 27;

-- Data kamus: status umum (login)
UPDATE sys_dict_data SET dict_label = 'Berhasil', remark = 'Status berhasil' WHERE dict_code = 28;
UPDATE sys_dict_data SET dict_label = 'Gagal', remark = 'Status gagal' WHERE dict_code = 29;
