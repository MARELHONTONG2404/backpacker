-- Status SUBMITTED: pelaksana mengajukan selesai, menunggu konfirmasi pembuat tugas.
-- mysql -u iwip -p iwip_manajemen < sql/backpacker_order_submitted.sql

insert into sys_dict_data (dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time)
select 5, 'Menunggu Konfirmasi', 'SUBMITTED', 'biz_order_status', '', 'warning', 'N', '0', 'admin', sysdate()
from dual where not exists (select 1 from sys_dict_data where dict_type = 'biz_order_status' and dict_value = 'SUBMITTED');

update sys_dict_data
set dict_sort = 6
where dict_type = 'biz_order_status' and dict_value = 'COMPLETED';

update sys_dict_data
set dict_sort = 7
where dict_type = 'biz_order_status' and dict_value = 'CANCELLED';

update sys_dict_data
set dict_sort = 8
where dict_type = 'biz_order_status' and dict_value = 'EXPIRED';
