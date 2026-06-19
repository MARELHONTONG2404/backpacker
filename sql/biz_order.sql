-- ----------------------------
-- Modul Pesanan (Order) — Sistem Backpacker
-- Marketplace jasa on-demand, workflow berbasis status (state-driven)
--
-- Jalankan setelah sql/20260417.sql:
--   mysql -u iwip -piwip123456 iwip_manajemen < sql/biz_order.sql
--
-- State machine:
--   DRAFT -> PUBLISHED -> TAKEN -> IN_PROGRESS -> COMPLETED
--                     \-> CANCELLED
--                     \-> EXPIRED (opsional)
--
-- Anti double-booking (ambil tugas ganda):
--   UPDATE biz_order
--   SET status = 'TAKEN', executor_id = ?, taken_at = NOW(), version = version + 1
--   WHERE order_id = ? AND status = 'PUBLISHED' AND del_flag = '0';
--   -- affected_rows = 0  => sudah diambil pengguna lain
-- ----------------------------

-- ----------------------------
-- 1. Tabel pesanan / tugas
-- ----------------------------
drop table if exists biz_order_log;
drop table if exists biz_order;

create table biz_order (
  order_id          bigint(20)      not null auto_increment    comment 'ID pesanan',
  order_no          varchar(32)     not null                   comment 'Nomor pesanan unik',
  title             varchar(200)    not null                   comment 'Judul tugas',
  description       text                                       comment 'Deskripsi tugas',
  category          varchar(50)     default 'general'          comment 'Kategori layanan',
  reward_amount     decimal(10,2)   not null default 0.00      comment 'Imbalan (Rp)',
  location_text     varchar(255)    default null               comment 'Lokasi / area layanan',
  creator_id        bigint(20)      not null                   comment 'ID pembuat tugas',
  executor_id       bigint(20)      default null               comment 'ID pelaksana tugas',
  status            varchar(20)     not null default 'DRAFT'   comment 'Status pesanan',
  version           int(11)         not null default 0           comment 'Versi optimistic lock',
  published_at      datetime        default null               comment 'Waktu publikasi',
  taken_at          datetime        default null               comment 'Waktu diambil pelaksana',
  started_at        datetime        default null               comment 'Waktu mulai dikerjakan',
  completed_at      datetime        default null               comment 'Waktu selesai',
  cancelled_at      datetime        default null               comment 'Waktu dibatalkan',
  cancel_reason     varchar(500)    default null               comment 'Alasan pembatalan',
  del_flag          char(1)         default '0'                comment 'Hapus (0=ada 2=hapus)',
  create_by         varchar(64)     default ''                 comment 'Pembuat record',
  create_time       datetime                                   comment 'Waktu buat',
  update_by         varchar(64)     default ''                 comment 'Pengubah',
  update_time       datetime                                   comment 'Waktu ubah',
  remark            varchar(500)    default null               comment 'Catatan',
  primary key (order_id),
  unique key uk_order_no (order_no),
  key idx_creator_id (creator_id),
  key idx_executor_id (executor_id),
  key idx_status_published (status, published_at),
  key idx_status_del (status, del_flag)
) engine=innodb auto_increment=1 comment='Pesanan marketplace Backpacker';

-- ----------------------------
-- 2. Log perubahan status (audit trail)
-- ----------------------------
create table biz_order_log (
  log_id            bigint(20)      not null auto_increment    comment 'ID log',
  order_id          bigint(20)      not null                   comment 'ID pesanan',
  from_status       varchar(20)     default null               comment 'Status sebelumnya',
  to_status         varchar(20)     not null                   comment 'Status sesudahnya',
  operator_id       bigint(20)      default null               comment 'ID operator',
  operator_type     varchar(20)     default 'user'             comment 'Tipe operator (user/system/admin)',
  remark            varchar(500)    default null               comment 'Catatan transisi',
  create_time       datetime                                   comment 'Waktu log',
  primary key (log_id),
  key idx_order_id (order_id),
  key idx_create_time (create_time)
) engine=innodb auto_increment=1 comment='Riwayat perubahan status pesanan';

-- ----------------------------
-- 3. Data contoh MVP
-- ----------------------------
insert into biz_order (
  order_no, title, description, category, reward_amount, location_text,
  creator_id, executor_id, status, version,
  published_at, taken_at, started_at, completed_at,
  create_by, create_time, remark
) values
(
  'ORD-2026-001',
  'Antar dokumen ke kantor pos',
  'Dokumen sudah disiapkan, tinggal antar ke kantor pos terdekat.',
  'delivery',
  25000.00,
  'Area Wedabe - Blok A',
  1, null, 'PUBLISHED', 0,
  sysdate(), null, null, null,
  'admin', sysdate(), 'Contoh tugas tersedia'
),
(
  'ORD-2026-002',
  'Bantu pindahkan meja rapat',
  'Butuh 1 orang bantu pindah 4 meja ke ruang meeting lantai 2.',
  'helper',
  50000.00,
  'Area Wedabe - Gedung Utama',
  1, 1, 'IN_PROGRESS', 2,
  date_sub(sysdate(), interval 2 hour), date_sub(sysdate(), interval 1 hour), date_sub(sysdate(), interval 30 minute), null,
  'admin', date_sub(sysdate(), interval 3 hour), 'Contoh tugas sedang dikerjakan'
),
(
  'ORD-2026-003',
  'Cek instalasi WiFi rumah',
  'Cek koneksi dan bantu setup router baru.',
  'tech',
  75000.00,
  'Perumahan Staff - Cluster B',
  1, 1, 'COMPLETED', 3,
  date_sub(sysdate(), interval 2 day), date_sub(sysdate(), interval 2 day), date_sub(sysdate(), interval 2 day), date_sub(sysdate(), interval 1 day),
  'admin', date_sub(sysdate(), interval 3 day), 'Contoh tugas selesai'
),
(
  'ORD-2026-004',
  'Draft tugas belanja kebutuhan dapur',
  'Belum dipublikasikan, masih draft.',
  'errands',
  30000.00,
  'Area Wedabe - Mess 3',
  1, null, 'DRAFT', 0,
  null, null, null, null,
  'admin', sysdate(), 'Contoh draft'
),
(
  'ORD-2026-005',
  'Service AC portable',
  'Tugas dibatalkan karena jadwal berubah.',
  'tech',
  100000.00,
  'Area Wedabe - Blok C',
  1, null, 'CANCELLED', 1,
  date_sub(sysdate(), interval 1 day), null, null, null,
  'admin', date_sub(sysdate(), interval 2 day), 'Contoh dibatalkan'
);

update biz_order
set cancelled_at = date_sub(sysdate(), interval 12 hour),
    cancel_reason = 'Jadwal pembuat tugas berubah'
where order_no = 'ORD-2026-005';

insert into biz_order_log (order_id, from_status, to_status, operator_id, operator_type, remark, create_time)
select order_id, null, status, creator_id, 'user', 'Inisialisasi data contoh', create_time
from biz_order;

-- ----------------------------
-- 4. Dictionary kategori tugas
-- ----------------------------
insert into sys_dict_type (dict_name, dict_type, status, create_by, create_time, remark)
select 'Kategori Tugas Backpacker', 'biz_order_category', '0', 'admin', sysdate(), 'Kategori layanan marketplace Backpacker'
from dual where not exists (select 1 from sys_dict_type where dict_type = 'biz_order_category');

insert into sys_dict_data (dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time)
select 1, 'Umum', 'general', 'biz_order_category', '', 'primary', 'Y', '0', 'admin', sysdate()
from dual where not exists (select 1 from sys_dict_data where dict_type = 'biz_order_category' and dict_value = 'general');

insert into sys_dict_data (dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time)
select 2, 'Antar Barang', 'delivery', 'biz_order_category', '', 'success', 'N', '0', 'admin', sysdate()
from dual where not exists (select 1 from sys_dict_data where dict_type = 'biz_order_category' and dict_value = 'delivery');

insert into sys_dict_data (dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time)
select 3, 'Bantuan', 'helper', 'biz_order_category', '', 'warning', 'N', '0', 'admin', sysdate()
from dual where not exists (select 1 from sys_dict_data where dict_type = 'biz_order_category' and dict_value = 'helper');

insert into sys_dict_data (dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time)
select 4, 'Teknisi', 'tech', 'biz_order_category', '', 'info', 'N', '0', 'admin', sysdate()
from dual where not exists (select 1 from sys_dict_data where dict_type = 'biz_order_category' and dict_value = 'tech');

insert into sys_dict_data (dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time)
select 5, 'Belanja / Errands', 'errands', 'biz_order_category', '', 'default', 'N', '0', 'admin', sysdate()
from dual where not exists (select 1 from sys_dict_data where dict_type = 'biz_order_category' and dict_value = 'errands');

-- ----------------------------
-- 5. Dictionary status pesanan
-- ----------------------------
insert into sys_dict_type (dict_name, dict_type, status, create_by, create_time, remark)
select 'Status Pesanan Backpacker', 'biz_order_status', '0', 'admin', sysdate(), 'State machine pesanan Backpacker'
from dual where not exists (select 1 from sys_dict_type where dict_type = 'biz_order_status');

insert into sys_dict_data (dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time)
select 1, 'Draft', 'DRAFT', 'biz_order_status', '', 'info', 'Y', '0', 'admin', sysdate()
from dual where not exists (select 1 from sys_dict_data where dict_type = 'biz_order_status' and dict_value = 'DRAFT');

insert into sys_dict_data (dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time)
select 2, 'Dipublikasikan', 'PUBLISHED', 'biz_order_status', '', 'primary', 'N', '0', 'admin', sysdate()
from dual where not exists (select 1 from sys_dict_data where dict_type = 'biz_order_status' and dict_value = 'PUBLISHED');

insert into sys_dict_data (dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time)
select 3, 'Diambil', 'TAKEN', 'biz_order_status', '', 'warning', 'N', '0', 'admin', sysdate()
from dual where not exists (select 1 from sys_dict_data where dict_type = 'biz_order_status' and dict_value = 'TAKEN');

insert into sys_dict_data (dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time)
select 4, 'Dikerjakan', 'IN_PROGRESS', 'biz_order_status', '', 'warning', 'N', '0', 'admin', sysdate()
from dual where not exists (select 1 from sys_dict_data where dict_type = 'biz_order_status' and dict_value = 'IN_PROGRESS');

insert into sys_dict_data (dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time)
select 5, 'Selesai', 'COMPLETED', 'biz_order_status', '', 'success', 'N', '0', 'admin', sysdate()
from dual where not exists (select 1 from sys_dict_data where dict_type = 'biz_order_status' and dict_value = 'COMPLETED');

insert into sys_dict_data (dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time)
select 6, 'Dibatalkan', 'CANCELLED', 'biz_order_status', '', 'danger', 'N', '0', 'admin', sysdate()
from dual where not exists (select 1 from sys_dict_data where dict_type = 'biz_order_status' and dict_value = 'CANCELLED');

insert into sys_dict_data (dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time)
select 7, 'Kedaluwarsa', 'EXPIRED', 'biz_order_status', '', 'default', 'N', '0', 'admin', sysdate()
from dual where not exists (select 1 from sys_dict_data where dict_type = 'biz_order_status' and dict_value = 'EXPIRED');

-- ----------------------------
-- 6. Menu admin (panel backend)
-- ----------------------------
insert into sys_menu (menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select 2200, 'Backpacker', 0, 5, 'backpacker', null, '', '', 1, 0, 'M', '0', '0', '', 'shopping', 'admin', sysdate(), 'Modul marketplace Backpacker'
from dual where not exists (select 1 from sys_menu where menu_id = 2200);

insert into sys_menu (menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select 2201, 'Daftar Pesanan', 2200, 1, 'order', 'backpacker/order/index', '', '', 1, 0, 'C', '0', '0', 'backpacker:order:list', 'list', 'admin', sysdate(), 'Monitoring pesanan Backpacker'
from dual where not exists (select 1 from sys_menu where menu_id = 2201);

insert into sys_menu (menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select 2202, 'Pesanan Query', 2201, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'backpacker:order:query', '#', 'admin', sysdate(), ''
from dual where not exists (select 1 from sys_menu where menu_id = 2202);

insert into sys_menu (menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select 2203, 'Pesanan Edit', 2201, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'backpacker:order:edit', '#', 'admin', sysdate(), ''
from dual where not exists (select 1 from sys_menu where menu_id = 2203);

insert into sys_menu (menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select 2204, 'Pesanan Remove', 2201, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'backpacker:order:remove', '#', 'admin', sysdate(), ''
from dual where not exists (select 1 from sys_menu where menu_id = 2204);

insert into sys_role_menu (role_id, menu_id) select 1, 2200 from dual where not exists (select 1 from sys_role_menu where role_id = 1 and menu_id = 2200);
insert into sys_role_menu (role_id, menu_id) select 1, 2201 from dual where not exists (select 1 from sys_role_menu where role_id = 1 and menu_id = 2201);
insert into sys_role_menu (role_id, menu_id) select 1, 2202 from dual where not exists (select 1 from sys_role_menu where role_id = 1 and menu_id = 2202);
insert into sys_role_menu (role_id, menu_id) select 1, 2203 from dual where not exists (select 1 from sys_role_menu where role_id = 1 and menu_id = 2203);
insert into sys_role_menu (role_id, menu_id) select 1, 2204 from dual where not exists (select 1 from sys_role_menu where role_id = 1 and menu_id = 2204);
