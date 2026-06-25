-- ----------------------------
-- Backpacker — chat per pesanan (pembuat ↔ pelaksana)
-- Jalankan setelah sql/biz_order.sql:
--   mysql -u iwip -p iwip_manajemen < sql/backpacker_chat.sql
-- ----------------------------

CREATE TABLE IF NOT EXISTS biz_backpacker_chat_message (
  message_id    bigint(20)      NOT NULL AUTO_INCREMENT    COMMENT 'ID pesan',
  order_id      bigint(20)      NOT NULL                   COMMENT 'ID pesanan',
  sender_id     bigint(20)      NOT NULL                   COMMENT 'ID pengirim',
  sender_name   varchar(64)     DEFAULT NULL               COMMENT 'Nama pengirim',
  content       varchar(2000)   NOT NULL                   COMMENT 'Isi pesan',
  create_time   datetime                                   COMMENT 'Waktu kirim',
  PRIMARY KEY (message_id),
  KEY idx_order_id (order_id),
  KEY idx_order_time (order_id, create_time)
) ENGINE=InnoDB AUTO_INCREMENT=1 COMMENT='Chat backpacker per pesanan';
