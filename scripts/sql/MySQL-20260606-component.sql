-- ----------------------------
-- 零部件 SQL 迁移脚本
-- 日期: 2026-06-06
-- 对应任务: 大任务二 / 2.1 零部件定义
-- 目标数据库: mes_db
-- 前置依赖: 需已执行 MySQL-20260606-materile-enhance.sql（sp_materile 增强）
-- ----------------------------

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for sp_component
-- ----------------------------
DROP TABLE IF EXISTS `sp_component`;
CREATE TABLE `sp_component` (
  `id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '主键id',
  `code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '零部件编码',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '零部件名称',
  `spec` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '规格',
  `materiel_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '关联物料ID（关联sp_materile）',
  `drawing_no` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '图号',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  `create_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '创建人',
  `update_time` datetime(0) NOT NULL COMMENT '最后更新时间',
  `update_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '最后更新人',
  `is_deleted` char(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '逻辑删除：1 表示删除，0 表示未删除，2 表示禁用',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_component_code`(`code`) USING BTREE,
  INDEX `idx_materiel_id`(`materiel_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '零部件表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- 菜单项：零部件管理（二级：常规管理 > 零部件管理）id=21
-- ----------------------------
INSERT IGNORE INTO `sp_sys_menu` VALUES ('21', 'partMgt', '零部件管理', '#', '1', '2', 8, '0', 'user:add', 'fa fa-puzzle-piece', '', NOW(), 'admin', NOW(), 'admin');

-- ----------------------------
-- 菜单项：零部件维护（三级：零部件管理 > 零部件维护）id=211
-- ----------------------------
INSERT IGNORE INTO `sp_sys_menu` VALUES ('211', 'componentDef', '零部件维护', '/basedata/component/list-ui', '21', '3', 1, '0', 'user:add', 'fa fa-cog', '', NOW(), 'admin', NOW(), 'admin');

-- ----------------------------
-- 角色-菜单绑定：管理员可访问零部件管理
-- ----------------------------
INSERT IGNORE INTO `sp_sys_role_menu` VALUES ('1340000000000030', '1185025876737396738', '21', NOW(), 'admin', NOW(), 'admin');
INSERT IGNORE INTO `sp_sys_role_menu` VALUES ('1340000000000031', '1185025876737396738', '211', NOW(), 'admin', NOW(), 'admin');

SET FOREIGN_KEY_CHECKS = 1;
