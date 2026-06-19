-- ----------------------------
-- Backpacker Auth — role pengguna mobile
-- Jalankan setelah sql/20260417.sql:
--   mysql -u iwip -p iwip_manajemen < sql/backpacker_auth.sql
-- ----------------------------

insert into sys_role (role_id, role_name, role_key, role_sort, data_scope, menu_check_strictly, dept_check_strictly, status, del_flag, create_by, create_time, remark)
select 3, 'Pengguna Backpacker', 'backpacker', 3, '1', 1, 1, '0', '0', 'admin', sysdate(), 'Role default pengguna aplikasi mobile Backpacker'
from dual where not exists (select 1 from sys_role where role_id = 3);
