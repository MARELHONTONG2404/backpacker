-- Pisahkan menu profil backpacker dari profil admin (hindari path/name "profile" bentrok)
-- mysql -u iwip -p iwip_manajemen < sql/backpacker_profile_route_name.sql

UPDATE sys_menu
SET path = 'users',
    route_name = 'BackpackerProfile'
WHERE menu_id = 2205;
