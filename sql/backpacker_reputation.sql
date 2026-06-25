-- ----------------------------
-- Backpacker — penilaian tugas & log reputasi
-- Jalankan setelah sql/backpacker_coins.sql:
--   mysql -u iwip -p iwip_manajemen < sql/backpacker_reputation.sql
-- ----------------------------

drop table if exists biz_reputation_log;
drop table if exists biz_order_rating;

create table biz_order_rating (
  rating_id         bigint(20)      not null auto_increment    comment 'ID penilaian',
  order_id          bigint(20)      not null                   comment 'ID pesanan',
  rater_id          bigint(20)      not null                   comment 'ID pemberi penilaian (pembuat tugas)',
  executor_id       bigint(20)      not null                   comment 'ID pelaksana dinilai',
  score             tinyint(4)      not null                   comment 'Skor 1-5',
  comment           varchar(500)    default null               comment 'Komentar',
  create_time       datetime                                   comment 'Waktu penilaian',
  primary key (rating_id),
  unique key uk_order_rating (order_id),
  key idx_executor_id (executor_id),
  key idx_rater_id (rater_id)
) engine=innodb auto_increment=1 comment='Penilaian tugas oleh pembuat';

create table biz_reputation_log (
  log_id            bigint(20)      not null auto_increment    comment 'ID log',
  user_id           bigint(20)      not null                   comment 'ID pengguna',
  delta             int(11)         not null                   comment 'Perubahan skor (+/-)',
  score_after       int(11)         not null                   comment 'Skor setelah perubahan',
  reason            varchar(30)     not null                   comment 'TASK_COMPLETE|TASK_FAILED|BAD_RATING|GOOD_RATING',
  ref_id            bigint(20)      default null               comment 'Referensi (order_id)',
  remark            varchar(255)    default null               comment 'Keterangan',
  create_time       datetime                                   comment 'Waktu log',
  primary key (log_id),
  key idx_user_id (user_id),
  key idx_create_time (create_time)
) engine=innodb auto_increment=1 comment='Riwayat perubahan reputasi backpacker';
