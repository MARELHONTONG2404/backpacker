-- ----------------------------
-- Backpacker — satukan alur produk (sembunyikan modul Laporan IWIP legacy)
-- Jalankan setelah sql/biz_order.sql:
--   mysql -u iwip -p iwip_manajemen < sql/backpacker_unify.sql
-- ----------------------------

-- Sembunyikan menu Manajemen Laporan IWIP dari sidebar admin
update sys_menu set visible = '1'
where menu_id = 2100 or parent_id = 2100;

-- Prioritaskan menu Backpacker di navigasi
update sys_menu set order_num = 1, menu_name = 'Backpacker'
where menu_id = 2200;

update sys_menu set menu_name = 'Daftar Pesanan'
where menu_id = 2201;
