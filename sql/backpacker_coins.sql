-- ----------------------------
-- Backpacker — profil koin tembaga & riwayat transaksi
-- Jalankan setelah sql/backpacker_auth.sql:
--   mysql -u iwip -p iwip_manajemen < sql/backpacker_coins.sql
-- ----------------------------

drop table if exists biz_coin_transaction;
drop table if exists biz_backpacker_profile;

create table biz_backpacker_profile (
  user_id           bigint(20)      not null                   comment 'ID pengguna (sys_user)',
  copper_coins      int(11)         not null default 0         comment 'Saldo koin tembaga',
  reputation_score  int(11)         not null default 100       comment 'Skor reputasi (0-200)',
  last_checkin_date date            default null               comment 'Tanggal check-in terakhir',
  completed_tasks   int(11)         not null default 0         comment 'Jumlah tugas selesai',
  failed_tasks      int(11)         not null default 0         comment 'Jumlah tugas gagal/batal',
  create_time       datetime                                   comment 'Waktu buat',
  update_time       datetime                                   comment 'Waktu ubah',
  primary key (user_id)
) engine=innodb comment='Profil backpacker (koin & reputasi)';

create table biz_coin_transaction (
  transaction_id    bigint(20)      not null auto_increment    comment 'ID transaksi',
  user_id           bigint(20)      not null                   comment 'ID pengguna',
  amount            int(11)         not null                   comment 'Perubahan koin (+/-)',
  balance_after     int(11)         not null                   comment 'Saldo setelah transaksi',
  tx_type           varchar(30)     not null                   comment 'REGISTER_BONUS|DAILY_CHECKIN|PUBLISH_FEE|TASK_REWARD',
  ref_id            bigint(20)      default null               comment 'Referensi (order_id, dll)',
  remark            varchar(255)    default null               comment 'Keterangan',
  create_time       datetime                                   comment 'Waktu transaksi',
  primary key (transaction_id),
  key idx_user_id (user_id),
  key idx_tx_type (tx_type),
  key idx_create_time (create_time)
) engine=innodb auto_increment=1 comment='Riwayat transaksi koin tembaga';

-- Profil default untuk pengguna backpacker yang sudah ada
insert into biz_backpacker_profile (user_id, copper_coins, reputation_score, create_time)
select u.user_id, 10, 100, sysdate()
from sys_user u
inner join sys_user_role ur on u.user_id = ur.user_id and ur.role_id = 3
where not exists (select 1 from biz_backpacker_profile p where p.user_id = u.user_id);
