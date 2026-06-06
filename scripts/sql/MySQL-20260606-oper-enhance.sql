-- ----------------------------
-- 工序信息增强 SQL 迁移脚本
-- 日期: 2026-06-06
-- 对应任务: 大任务三 / 3.1 工序信息定义
-- 目标数据库: mes_db
-- 前置依赖: sp_oper 表需已存在（MySQL-20210225.sql）
-- 前置依赖: sp_workcell 表需已存在（MySQL-20260606-workcell.sql）
-- ----------------------------

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- sp_oper 表增加字段（使用存储过程检查，防止重复执行报错）
-- ----------------------------
DROP PROCEDURE IF EXISTS `add_oper_columns`;
DELIMITER //
CREATE PROCEDURE `add_oper_columns`()
BEGIN
  IF NOT EXISTS (SELECT * FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'sp_oper' AND COLUMN_NAME = 'oper_code') THEN
    ALTER TABLE `sp_oper` ADD COLUMN `oper_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '工序编号' AFTER `id`;
  END IF;
  IF NOT EXISTS (SELECT * FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'sp_oper' AND COLUMN_NAME = 'man_hours') THEN
    ALTER TABLE `sp_oper` ADD COLUMN `man_hours` decimal(10,2) NULL DEFAULT NULL COMMENT '工时定额（分钟）' AFTER `oper_desc`;
  END IF;
  IF NOT EXISTS (SELECT * FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'sp_oper' AND COLUMN_NAME = 'workcell_id') THEN
    ALTER TABLE `sp_oper` ADD COLUMN `workcell_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '加工单元ID（关联sp_workcell）' AFTER `man_hours`;
  END IF;
  IF NOT EXISTS (SELECT * FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'sp_oper' AND COLUMN_NAME = 'is_deleted') THEN
    ALTER TABLE `sp_oper` ADD COLUMN `is_deleted` char(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '逻辑删除：1=删除，0=正常，2=禁用' AFTER `workcell_id`;
  END IF;
  IF NOT EXISTS (SELECT * FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'sp_oper' AND INDEX_NAME = 'uk_oper_code') THEN
    ALTER TABLE `sp_oper` ADD UNIQUE INDEX `uk_oper_code`(`oper_code`) USING BTREE;
  END IF;
  IF NOT EXISTS (SELECT * FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'sp_oper' AND INDEX_NAME = 'idx_workcell_id') THEN
    ALTER TABLE `sp_oper` ADD INDEX `idx_workcell_id`(`workcell_id`) USING BTREE;
  END IF;
END //
DELIMITER ;
CALL `add_oper_columns`();
DROP PROCEDURE IF EXISTS `add_oper_columns`;

-- ----------------------------
-- 菜单项：工序管理（二级：常规管理 > 工序管理）id=22
-- ----------------------------
INSERT IGNORE INTO `sp_sys_menu` VALUES ('22', 'oper', '工序管理', '#', '1', '2', 9, '0', 'user:add', 'fa fa-cogs', '', NOW(), 'admin', NOW(), 'admin');

-- ----------------------------
-- 菜单项：工序维护（三级：工序管理 > 工序维护）id=221
-- ----------------------------
INSERT IGNORE INTO `sp_sys_menu` VALUES ('221', 'operDef', '工序维护', '/technology/oper/list-ui', '22', '3', 1, '0', 'user:add', 'fa fa-wrench', '', NOW(), 'admin', NOW(), 'admin');

-- ----------------------------
-- 角色-菜单绑定：管理员可访问工序管理
-- ----------------------------
INSERT IGNORE INTO `sp_sys_role_menu` VALUES ('1340000000000032', '1185025876737396738', '22', NOW(), 'admin', NOW(), 'admin');
INSERT IGNORE INTO `sp_sys_role_menu` VALUES ('1340000000000033', '1185025876737396738', '221', NOW(), 'admin', NOW(), 'admin');

SET FOREIGN_KEY_CHECKS = 1;
