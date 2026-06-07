-- ============================================================
-- 3.4 产品工艺查询 — 菜单注册
-- 在 工艺管理(id=15) 下新增「产品工艺查询」菜单
-- ============================================================

-- 新增菜单：产品工艺查询（id=173，挂载在工艺管理 id=15 下，grade=3三级菜单）
INSERT IGNORE INTO `sp_sys_menu` (`id`, `code`, `name`, `url`, `parent_id`, `grade`, `sort_num`, `type`, `permission`, `icon`, `descr`, `create_time`, `create_username`, `update_time`, `update_username`)
VALUES ('173', 'productProcessQuery', '产品工艺查询', '/technology/product-process/list-ui', '15', '3', 5, '0', 'user:add', 'fa fa-search', '', NOW(), 'admin', NOW(), 'admin');

-- 为 admin 角色(1185025876737396738)绑定新菜单
INSERT IGNORE INTO `sp_sys_role_menu` (`id`, `role_id`, `menu_id`, `create_time`, `create_username`, `update_time`, `update_username`)
VALUES (REPLACE(UUID(), '-', ''), '1185025876737396738', '173', NOW(), 'admin', NOW(), 'admin');
