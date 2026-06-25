-- ----------------------------
-- Backpacker Admin — menu panel monitoring koin & reputasi
-- Jalankan setelah sql/backpacker_reputation.sql:
--   mysql -u iwip -p iwip_manajemen < sql/backpacker_admin_menu.sql
-- ----------------------------

insert into sys_menu (menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select 2205, 'Profil Backpacker', 2200, 2, 'users', 'backpacker/profile/index', '', 'BackpackerProfile', 1, 0, 'C', '0', '0', 'backpacker:profile:list', 'user', 'admin', sysdate(), 'Monitoring profil koin dan reputasi'
from dual where not exists (select 1 from sys_menu where menu_id = 2205);

insert into sys_menu (menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select 2206, 'Profil Query', 2205, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'backpacker:profile:query', '#', 'admin', sysdate(), ''
from dual where not exists (select 1 from sys_menu where menu_id = 2206);

insert into sys_menu (menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select 2207, 'Riwayat Koin', 2200, 3, 'coin', 'backpacker/coin/index', '', '', 1, 0, 'C', '0', '0', 'backpacker:coin:list', 'money', 'admin', sysdate(), 'Riwayat transaksi koin tembaga'
from dual where not exists (select 1 from sys_menu where menu_id = 2207);

insert into sys_menu (menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select 2208, 'Log Reputasi', 2200, 4, 'reputation', 'backpacker/reputation/index', '', '', 1, 0, 'C', '0', '0', 'backpacker:reputation:list', 'star', 'admin', sysdate(), 'Riwayat perubahan reputasi'
from dual where not exists (select 1 from sys_menu where menu_id = 2208);

insert into sys_menu (menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select 2209, 'Penilaian Tugas', 2200, 5, 'rating', 'backpacker/rating/index', '', '', 1, 0, 'C', '0', '0', 'backpacker:rating:list', 'rate', 'admin', sysdate(), 'Penilaian tugas oleh pembuat'
from dual where not exists (select 1 from sys_menu where menu_id = 2209);

insert into sys_role_menu (role_id, menu_id) select 1, 2205 from dual where not exists (select 1 from sys_role_menu where role_id = 1 and menu_id = 2205);
insert into sys_role_menu (role_id, menu_id) select 1, 2206 from dual where not exists (select 1 from sys_role_menu where role_id = 1 and menu_id = 2206);
insert into sys_role_menu (role_id, menu_id) select 1, 2207 from dual where not exists (select 1 from sys_role_menu where role_id = 1 and menu_id = 2207);
insert into sys_role_menu (role_id, menu_id) select 1, 2208 from dual where not exists (select 1 from sys_role_menu where role_id = 1 and menu_id = 2208);
insert into sys_role_menu (role_id, menu_id) select 1, 2209 from dual where not exists (select 1 from sys_role_menu where role_id = 1 and menu_id = 2209);

-- Dictionary tipe transaksi koin
insert into sys_dict_type (dict_name, dict_type, status, create_by, create_time, remark)
select 'Tipe Transaksi Koin Backpacker', 'biz_coin_tx_type', '0', 'admin', sysdate(), 'Jenis transaksi koin tembaga'
from dual where not exists (select 1 from sys_dict_type where dict_type = 'biz_coin_tx_type');

insert into sys_dict_data (dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time)
select 1, 'Bonus Registrasi', 'REGISTER_BONUS', 'biz_coin_tx_type', '', 'success', 'N', '0', 'admin', sysdate()
from dual where not exists (select 1 from sys_dict_data where dict_type = 'biz_coin_tx_type' and dict_value = 'REGISTER_BONUS');

insert into sys_dict_data (dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time)
select 2, 'Check-in Harian', 'DAILY_CHECKIN', 'biz_coin_tx_type', '', 'primary', 'N', '0', 'admin', sysdate()
from dual where not exists (select 1 from sys_dict_data where dict_type = 'biz_coin_tx_type' and dict_value = 'DAILY_CHECKIN');

insert into sys_dict_data (dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time)
select 3, 'Biaya Publikasi', 'PUBLISH_FEE', 'biz_coin_tx_type', '', 'warning', 'N', '0', 'admin', sysdate()
from dual where not exists (select 1 from sys_dict_data where dict_type = 'biz_coin_tx_type' and dict_value = 'PUBLISH_FEE');

insert into sys_dict_data (dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time)
select 4, 'Reward Tugas', 'TASK_REWARD', 'biz_coin_tx_type', '', 'success', 'N', '0', 'admin', sysdate()
from dual where not exists (select 1 from sys_dict_data where dict_type = 'biz_coin_tx_type' and dict_value = 'TASK_REWARD');

-- Dictionary alasan reputasi
insert into sys_dict_type (dict_name, dict_type, status, create_by, create_time, remark)
select 'Alasan Reputasi Backpacker', 'biz_reputation_reason', '0', 'admin', sysdate(), 'Alasan perubahan reputasi'
from dual where not exists (select 1 from sys_dict_type where dict_type = 'biz_reputation_reason');

insert into sys_dict_data (dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time)
select 1, 'Tugas Selesai', 'TASK_COMPLETE', 'biz_reputation_reason', '', 'success', 'N', '0', 'admin', sysdate()
from dual where not exists (select 1 from sys_dict_data where dict_type = 'biz_reputation_reason' and dict_value = 'TASK_COMPLETE');

insert into sys_dict_data (dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time)
select 2, 'Tugas Gagal/Dilepas', 'TASK_FAILED', 'biz_reputation_reason', '', 'danger', 'N', '0', 'admin', sysdate()
from dual where not exists (select 1 from sys_dict_data where dict_type = 'biz_reputation_reason' and dict_value = 'TASK_FAILED');

insert into sys_dict_data (dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time)
select 3, 'Penilaian Buruk', 'BAD_RATING', 'biz_reputation_reason', '', 'danger', 'N', '0', 'admin', sysdate()
from dual where not exists (select 1 from sys_dict_data where dict_type = 'biz_reputation_reason' and dict_value = 'BAD_RATING');

insert into sys_dict_data (dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time)
select 4, 'Penilaian Bagus', 'GOOD_RATING', 'biz_reputation_reason', '', 'success', 'N', '0', 'admin', sysdate()
from dual where not exists (select 1 from sys_dict_data where dict_type = 'biz_reputation_reason' and dict_value = 'GOOD_RATING');
