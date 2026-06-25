-- ----------------------------
-- Backpacker — ekstra chat: unread, lampiran gambar
-- Jalankan setelah sql/backpacker_chat.sql:
--   mysql -u iwip -p iwip_manajemen < sql/backpacker_chat_extras.sql
-- ----------------------------

ALTER TABLE biz_backpacker_chat_message
  ADD COLUMN message_type varchar(10) NOT NULL DEFAULT 'TEXT' COMMENT 'TEXT|IMAGE' AFTER content,
  ADD COLUMN image_url varchar(500) DEFAULT NULL COMMENT 'URL gambar' AFTER message_type;

ALTER TABLE biz_backpacker_chat_message
  MODIFY COLUMN content varchar(2000) NOT NULL DEFAULT '' COMMENT 'Isi pesan';

CREATE TABLE IF NOT EXISTS biz_backpacker_chat_read (
  order_id              bigint(20)  NOT NULL                   COMMENT 'ID pesanan',
  user_id               bigint(20)  NOT NULL                   COMMENT 'ID pengguna',
  last_read_message_id  bigint(20)  NOT NULL DEFAULT 0         COMMENT 'ID pesan terakhir dibaca',
  update_time           datetime                               COMMENT 'Waktu update',
  PRIMARY KEY (order_id, user_id)
) ENGINE=InnoDB COMMENT='Status baca chat backpacker';
