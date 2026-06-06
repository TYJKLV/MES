-- ----------------------------
-- 设备编组 SQL 迁移脚本
-- 日期: 2026-06-06
-- 对应任务: 大任务一 / 1.3 编组设备定义 — 设备编组
-- 目标数据库: mes_db
-- 前置依赖: 需先执行 MySQL-20260602-equipment.sql（sp_equipment 表 + 设备管理菜单）
-- ----------------------------

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for sp_equipment_group
-- ----------------------------
DROP TABLE IF EXISTS `sp_equipment_group`;
CREATE TABLE `sp_equipment_group` (
  `id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '主键id',
  `code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '编组编码',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '编组名称',
  `group_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '编组类型：static=静态编组，dynamic=动态编组',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  `create_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '创建人',
  `update_time` datetime(0) NOT NULL COMMENT '最后更新时间',
  `update_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '最后更新人',
  `is_deleted` char(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '逻辑删除：1 表示删除，0 表示未删除，2 表示禁用',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_group_code`(`code`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '设备编组表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sp_equipment_group_rel
-- ----------------------------
DROP TABLE IF EXISTS `sp_equipment_group_rel`;
CREATE TABLE `sp_equipment_group_rel` (
  `id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '主键id',
  `group_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '设备编组ID',
  `equipment_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '设备ID',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  `create_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '创建人',
  `update_time` datetime(0) NOT NULL COMMENT '最后更新时间',
  `update_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '最后更新人',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_group_id`(`group_id`) USING BTREE,
  INDEX `idx_equipment_id`(`equipment_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '设备编组-设备绑定关系表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- 菜单项：设备编组维护（三级：常规管理 > 设备管理 > 设备编组维护）id=182
-- ----------------------------
INSERT IGNORE INTO `sp_sys_menu` VALUES ('182', 'equipmentGroupDef', '设备编组维护', '/basedata/equipmentGroup/list-ui', '18', '3', 2, '0', 'user:add', 'fa fa-object-group', '', NOW(), 'admin', NOW(), 'admin');

-- ----------------------------
-- 字典数据：设备编组类型
-- 注意：ID 使用 1337619000000020/21，避免与 materile-enhance.sql 的 1337619000000010 冲突
-- ----------------------------
-- 清理旧ID（如果之前用错误ID执行过）
DELETE FROM `sp_sys_dict` WHERE `id` IN ('1337619000000010', '1337619000000011') AND `type` = 'equipment_group_type';
-- 插入新ID
INSERT IGNORE INTO `sp_sys_dict` VALUES ('1337619000000020', '静态编组', 'static', 'equipment_group_type', '设备编组类型', 1, '\"\"', '0', NOW(), 'admin', NOW(), 'admin');
INSERT IGNORE INTO `sp_sys_dict` VALUES ('1337619000000021', '动态编组', 'dynamic', 'equipment_group_type', '设备编组类型', 2, '\"\"', '0', NOW(), 'admin', NOW(), 'admin');

-- ----------------------------
-- 角色-菜单绑定：管理员可访问设备编组维护
-- ----------------------------
INSERT IGNORE INTO `sp_sys_role_menu` VALUES ('1340000000000027', '1185025876737396738', '182', NOW(), 'admin', NOW(), 'admin');

-- ----------------------------
-- 测试数据：设备编组（先清理再插入，保证可重复执行）
-- ----------------------------
DELETE FROM `sp_equipment_group_rel` WHERE `group_id` IN ('1350000000000001', '1350000000000002');
DELETE FROM `sp_equipment_group` WHERE `id` IN ('1350000000000001', '1350000000000002');
INSERT INTO `sp_equipment_group` VALUES ('1350000000000001', 'GRP-01', '装配线设备组', 'static', NOW(), 'admin', NOW(), 'admin', '0');
INSERT INTO `sp_equipment_group` VALUES ('1350000000000002', 'GRP-02', '动态调度设备池', 'dynamic', NOW(), 'admin', NOW(), 'admin', '0');

SET FOREIGN_KEY_CHECKS = 1;
