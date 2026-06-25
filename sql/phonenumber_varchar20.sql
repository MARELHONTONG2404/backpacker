-- Perluas kolom nomor telepon untuk format internasional (mis. 0812... Indonesia, +62...).
ALTER TABLE sys_user
  MODIFY COLUMN phonenumber varchar(20) DEFAULT '' COMMENT '手机号码';
