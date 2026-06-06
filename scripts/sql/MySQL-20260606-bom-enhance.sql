-- ----------------------------
-- BOM增强 SQL 迁移脚本
-- 日期: 2026-06-06
-- 对应任务: 大任务二 / 2.2 工艺BOM/产品BOM管理
-- 目标数据库: mes_db
-- 前置依赖: sp_bom、sp_bom_item 表需已存在（MySQL-20210225.sql）
-- ----------------------------

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- sp_bom 表增加 bom_type 字段（产品BOM/工艺BOM）
-- ----------------------------
ALTER TABLE `sp_bom` ADD COLUMN `bom_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'process' COMMENT 'BOM类型：product=产品BOM, process=工艺BOM' AFTER `bom_code`;
-- 默认值为 process（工艺BOM），历史数据全部视为工艺BOM

-- ----------------------------
-- sp_bom_item 表增加 parent_item_id 字段（BOM层级结构）
-- ----------------------------
ALTER TABLE `sp_bom_item` ADD COLUMN `parent_item_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '父项ID（BOM层级结构），为空表示顶层' AFTER `oper_typer`;
ALTER TABLE `sp_bom_item` ADD INDEX `idx_parent_item_id`(`parent_item_id`) USING BTREE;

-- ----------------------------
-- 字典数据：BOM类型
-- ----------------------------
INSERT INTO `sp_sys_dict` VALUES ('1337619000000012', '产品BOM', 'product', 'bom_type', 'BOM类型', 1, '\"\"', '0', NOW(), 'admin', NOW(), 'admin');
INSERT INTO `sp_sys_dict` VALUES ('1337619000000013', '工艺BOM', 'process', 'bom_type', 'BOM类型', 2, '\"\"', '0', NOW(), 'admin', NOW(), 'admin');

SET FOREIGN_KEY_CHECKS = 1;
