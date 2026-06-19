-- ----------------------------
-- Modul Laporan IWIP
-- ----------------------------

-- Tabel laporan
drop table if exists biz_report;
create table biz_report (
  report_id     bigint(20)      not null auto_increment    comment 'ID laporan',
  report_no     varchar(32)     not null                   comment 'Nomor laporan',
  title         varchar(200)    not null                   comment 'Judul laporan',
  report_type   char(1)         not null default '1'       comment 'Tipe (1=harian 2=insiden 3=maintenance)',
  status        char(1)         not null default '0'       comment 'Status (0=draft 1=diajukan 2=disetujui 3=ditolak)',
  content       text                                       comment 'Isi laporan',
  user_id       bigint(20)      default null               comment 'ID pelapor',
  dept_id       bigint(20)      default null               comment 'ID departemen',
  del_flag      char(1)         default '0'                comment 'Hapus (0=ada 2=hapus)',
  create_by     varchar(64)     default ''                 comment 'Pembuat',
  create_time   datetime                                   comment 'Waktu buat',
  update_by     varchar(64)     default ''                 comment 'Pengubah',
  update_time   datetime                                   comment 'Waktu ubah',
  remark        varchar(500)    default null               comment 'Catatan',
  primary key (report_id),
  unique key uk_report_no (report_no)
) engine=innodb auto_increment=1 comment='Tabel laporan';

-- Data contoh
insert into biz_report (report_no, title, report_type, status, content, user_id, dept_id, create_by, create_time, remark) values
('RPT-2026-001', 'Laporan Produksi Harian Shift 1', '1', '2', 'Produksi berjalan normal, output sesuai target.', 1, 100, 'admin', sysdate(), 'Disetujui'),
('RPT-2026-002', 'Insiden Kecil di Area Gudang', '2', '1', 'Terjadi tumpahan material, sudah ditangani tim safety.', 1, 100, 'admin', sysdate(), 'Menunggu review'),
('RPT-2026-003', 'Maintenance Rutin Conveyor A', '3', '2', 'Pengecekan dan pelumasan selesai tanpa kendala.', 1, 100, 'admin', date_sub(sysdate(), interval 1 day), null),
('RPT-2026-004', 'Laporan Kehadiran Tim Produksi', '1', '0', 'Draft laporan kehadiran minggu ini.', 1, 100, 'admin', date_sub(sysdate(), interval 2 day), null),
('RPT-2026-005', 'Gangguan Listrik Sementara', '2', '3', 'Listrik padam 15 menit, sudah pulih.', 1, 100, 'admin', date_sub(sysdate(), interval 3 day), 'Perlu revisi data');

-- Dictionary tipe laporan
insert into sys_dict_type (dict_name, dict_type, status, create_by, create_time, remark)
select 'Tipe Laporan', 'biz_report_type', '0', 'admin', sysdate(), 'Tipe laporan IWIP'
from dual where not exists (select 1 from sys_dict_type where dict_type = 'biz_report_type');

insert into sys_dict_data (dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time)
select 1, 'Harian', '1', 'biz_report_type', '', 'primary', 'Y', '0', 'admin', sysdate()
from dual where not exists (select 1 from sys_dict_data where dict_type = 'biz_report_type' and dict_value = '1');

insert into sys_dict_data (dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time)
select 2, 'Insiden', '2', 'biz_report_type', '', 'warning', 'N', '0', 'admin', sysdate()
from dual where not exists (select 1 from sys_dict_data where dict_type = 'biz_report_type' and dict_value = '2');

insert into sys_dict_data (dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time)
select 3, 'Maintenance', '3', 'biz_report_type', '', 'info', 'N', '0', 'admin', sysdate()
from dual where not exists (select 1 from sys_dict_data where dict_type = 'biz_report_type' and dict_value = '3');

-- Dictionary status laporan
insert into sys_dict_type (dict_name, dict_type, status, create_by, create_time, remark)
select 'Status Laporan', 'biz_report_status', '0', 'admin', sysdate(), 'Status workflow laporan'
from dual where not exists (select 1 from sys_dict_type where dict_type = 'biz_report_status');

insert into sys_dict_data (dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time)
select 1, 'Draft', '0', 'biz_report_status', '', 'info', 'Y', '0', 'admin', sysdate()
from dual where not exists (select 1 from sys_dict_data where dict_type = 'biz_report_status' and dict_value = '0');

insert into sys_dict_data (dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time)
select 2, 'Diajukan', '1', 'biz_report_status', '', 'warning', 'N', '0', 'admin', sysdate()
from dual where not exists (select 1 from sys_dict_data where dict_type = 'biz_report_status' and dict_value = '1');

insert into sys_dict_data (dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time)
select 3, 'Disetujui', '2', 'biz_report_status', '', 'success', 'N', '0', 'admin', sysdate()
from dual where not exists (select 1 from sys_dict_data where dict_type = 'biz_report_status' and dict_value = '2');

insert into sys_dict_data (dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time)
select 4, 'Ditolak', '3', 'biz_report_status', '', 'danger', 'N', '0', 'admin', sysdate()
from dual where not exists (select 1 from sys_dict_data where dict_type = 'biz_report_status' and dict_value = '3');

-- Menu laporan
insert into sys_menu (menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select 2100, 'Manajemen Laporan', 0, 4, 'report', null, '', '', 1, 0, 'M', '0', '0', '', 'documentation', 'admin', sysdate(), 'Modul laporan IWIP'
from dual where not exists (select 1 from sys_menu where menu_id = 2100);

insert into sys_menu (menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select 2101, 'Daftar Laporan', 2100, 1, 'list', 'report/list/index', '', '', 1, 0, 'C', '0', '0', 'report:report:list', 'list', 'admin', sysdate(), 'Daftar laporan'
from dual where not exists (select 1 from sys_menu where menu_id = 2101);

insert into sys_menu (menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select 2102, 'Laporan Query', 2101, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'report:report:query', '#', 'admin', sysdate(), ''
from dual where not exists (select 1 from sys_menu where menu_id = 2102);

insert into sys_menu (menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select 2103, 'Laporan Add', 2101, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'report:report:add', '#', 'admin', sysdate(), ''
from dual where not exists (select 1 from sys_menu where menu_id = 2103);

insert into sys_menu (menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select 2104, 'Laporan Edit', 2101, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'report:report:edit', '#', 'admin', sysdate(), ''
from dual where not exists (select 1 from sys_menu where menu_id = 2104);

insert into sys_menu (menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select 2105, 'Laporan Remove', 2101, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'report:report:remove', '#', 'admin', sysdate(), ''
from dual where not exists (select 1 from sys_menu where menu_id = 2105);

-- Hak akses admin
insert into sys_role_menu (role_id, menu_id) select 1, 2100 from dual where not exists (select 1 from sys_role_menu where role_id = 1 and menu_id = 2100);
insert into sys_role_menu (role_id, menu_id) select 1, 2101 from dual where not exists (select 1 from sys_role_menu where role_id = 1 and menu_id = 2101);
insert into sys_role_menu (role_id, menu_id) select 1, 2102 from dual where not exists (select 1 from sys_role_menu where role_id = 1 and menu_id = 2102);
insert into sys_role_menu (role_id, menu_id) select 1, 2103 from dual where not exists (select 1 from sys_role_menu where role_id = 1 and menu_id = 2103);
insert into sys_role_menu (role_id, menu_id) select 1, 2104 from dual where not exists (select 1 from sys_role_menu where role_id = 1 and menu_id = 2104);
insert into sys_role_menu (role_id, menu_id) select 1, 2105 from dual where not exists (select 1 from sys_role_menu where role_id = 1 and menu_id = 2105);
