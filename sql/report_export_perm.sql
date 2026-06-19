-- Tambah permission ekspor laporan
-- Jalankan: mysql -u iwip -piwip123456 iwip_manajemen < base/sql/report_export_perm.sql

INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
SELECT 2106, 'Ekspor Laporan', 2101, 5, '', '', '', '', 1, 0, 'F', '0', '0', 'report:report:export', '#', 'admin', sysdate(), ''
FROM dual WHERE NOT EXISTS (SELECT 1 FROM sys_menu WHERE menu_id = 2106);

INSERT INTO sys_role_menu (role_id, menu_id)
SELECT 1, 2106 FROM dual WHERE NOT EXISTS (SELECT 1 FROM sys_role_menu WHERE role_id = 1 AND menu_id = 2106);

UPDATE sys_menu SET menu_name = 'Cari Laporan' WHERE menu_id = 2102;
UPDATE sys_menu SET menu_name = 'Tambah Laporan' WHERE menu_id = 2103;
UPDATE sys_menu SET menu_name = 'Ubah Laporan' WHERE menu_id = 2104;
UPDATE sys_menu SET menu_name = 'Hapus Laporan' WHERE menu_id = 2105;
