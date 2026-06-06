-- ----------------------------
-- 工艺流程增强 SQL 迁移脚本
-- 日期: 2026-06-06
-- 对应任务: 大任务三 / 3.2 工艺流程管理
-- 目标数据库: mes_db
-- 前置依赖: sp_flow 表需已存在（MySQL-20210225.sql）
-- 前置依赖: sp_bom 表需已存在（MySQL-20260606-bom-enhance.sql）
-- ----------------------------

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- sp_flow 表增加版本和状态字段
-- ----------------------------
ALTER TABLE `sp_flow` ADD COLUMN `version` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '1' COMMENT '版本号' AFTER `process`;
ALTER TABLE `sp_flow` ADD COLUMN `state` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'creat' COMMENT '状态：creat=创建, pass=已定版' AFTER `version`;
ALTER TABLE `sp_flow` ADD COLUMN `is_deleted` char(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '逻辑删除' AFTER `state`;

-- ----------------------------
-- Table: sp_flow_bom_rel（工艺流程-BOM绑定）
-- ----------------------------
DROP TABLE IF EXISTS `sp_flow_bom_rel`;
CREATE TABLE `sp_flow_bom_rel` (
  `id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '主键id',
  `flow_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '流程ID',
  `bom_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'BOM头ID',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  `create_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '创建人',
  `update_time` datetime(0) NOT NULL COMMENT '最后更新时间',
  `update_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '最后更新人',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_flow_id`(`flow_id`) USING BTREE,
  INDEX `idx_bom_id`(`bom_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '工艺流程-BOM绑定关系表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- 菜单项：工艺流程维护挂载到产品工艺(17)下，id=172
-- ----------------------------
INSERT INTO `sp_sys_menu` VALUES ('172', 'flowDef', '工艺流程维护', '/technology/flow/list-ui', '17', '3', 2, '0', 'user:add', 'fa fa-random', '', NOW(), 'admin', NOW(), 'admin');

-- ----------------------------
-- 角色-菜单绑定：管理员可访问工艺流程维护
-- ----------------------------
INSERT INTO `sp_sys_role_menu` VALUES ('1340000000000034', '1185025876737396738', '172', NOW(), 'admin', NOW(), 'admin');

SET FOREIGN_KEY_CHECKS = 1;
