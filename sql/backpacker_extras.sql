-- Fitur tambahan Backpacker: notifikasi in-app, permission adjust admin, dict tx type

CREATE TABLE IF NOT EXISTS biz_backpacker_notification (
  notification_id BIGINT NOT NULL AUTO_INCREMENT COMMENT 'ID notifikasi',
  user_id         BIGINT NOT NULL COMMENT 'Penerima notifikasi',
  title           VARCHAR(120) NOT NULL COMMENT 'Judul',
  content         VARCHAR(500) DEFAULT NULL COMMENT 'Isi pesan',
  notify_type     VARCHAR(32) NOT NULL COMMENT 'Jenis notifikasi',
  ref_id          BIGINT DEFAULT NULL COMMENT 'Referensi (order_id dll)',
  is_read         CHAR(1) DEFAULT '0' COMMENT '0=belum dibaca 1=sudah dibaca',
  create_time     DATETIME DEFAULT NULL COMMENT 'Waktu dibuat',
  PRIMARY KEY (notification_id),
  KEY idx_bbn_user (user_id),
  KEY idx_bbn_read (user_id, is_read)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Notifikasi in-app backpacker';

INSERT INTO sys_dict_data (dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, remark)
SELECT 5, 'Penyesuaian Admin', 'ADMIN_ADJUST', 'biz_coin_tx_type', '', 'warning', 'N', '0', 'admin', sysdate(), 'Penyesuaian manual admin'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM sys_dict_data WHERE dict_type = 'biz_coin_tx_type' AND dict_value = 'ADMIN_ADJUST');

INSERT INTO sys_dict_data (dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, remark)
SELECT 5, 'Penyesuaian Admin', 'ADMIN_ADJUST', 'biz_reputation_reason', '', 'warning', 'N', '0', 'admin', sysdate(), 'Penyesuaian manual admin'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM sys_dict_data WHERE dict_type = 'biz_reputation_reason' AND dict_value = 'ADMIN_ADJUST');

INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
SELECT 2210, 'Profil Adjust', 2205, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'backpacker:profile:adjust', '#', 'admin', sysdate(), 'Penyesuaian koin/reputasi manual'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM sys_menu WHERE menu_id = 2210);

INSERT INTO sys_role_menu (role_id, menu_id)
SELECT 1, 2210 FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM sys_role_menu WHERE role_id = 1 AND menu_id = 2210);
