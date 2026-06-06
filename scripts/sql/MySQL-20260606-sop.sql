-- ----------------------------
-- SOP（标准作业指导书）SQL 迁移脚本
-- 日期: 2026-06-06
-- 对应任务: 大任务三 / 3.3 工艺内容编制
-- 目标数据库: mes_db
-- 前置依赖: sp_oper 表需已存在（MySQL-20260606-oper-enhance.sql）
-- 前置依赖: sp_bom 表需已存在（MySQL-20260606-bom-enhance.sql）
-- ----------------------------

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table: sp_sop（SOP主表）
-- 字段: 编号、名称、关联工序、关联BOM、版本、状态
-- 状态三态: draft=草稿, review=审核中, pass=已发布
-- ----------------------------
DROP TABLE IF EXISTS `sp_sop`;
CREATE TABLE `sp_sop` (
  `id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '主键id',
  `code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'SOP编号',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'SOP名称',
  `oper_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '关联工序ID（关联sp_oper）',
  `bom_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '关联BOM ID（可选，关联sp_bom）',
  `version` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '1' COMMENT '版本号',
  `state` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'draft' COMMENT '状态：draft=草稿, review=审核中, pass=已发布',
  `is_deleted` char(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '逻辑删除：0=正常, 1=删除, 2=禁用',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `create_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '创建人',
  `update_time` datetime NOT NULL COMMENT '最后更新时间',
  `update_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '最后更新人',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_sop_code`(`code`) USING BTREE,
  INDEX `idx_oper_id`(`oper_id`) USING BTREE,
  INDEX `idx_bom_id`(`bom_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'SOP主表（标准作业指导书）' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table: sp_sop_content（SOP内容表）
-- 7个内容区块: 工序主信息、工艺内容、工艺要求、注意事项、工装、技术文档、备料清单
-- 与 sp_sop 一对一关系（一个SOP一份内容）
-- ----------------------------
DROP TABLE IF EXISTS `sp_sop_content`;
CREATE TABLE `sp_sop_content` (
  `id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '主键id',
  `sop_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'SOP主表ID（关联sp_sop）',
  `oper_main_info` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '工序主信息（设备参数、作业环境等）',
  `process_content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '工艺内容（操作步骤、加工方法等）',
  `process_req` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '工艺要求（精度标准、质量要求等）',
  `attention` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '注意事项（安全提醒、操作禁忌等）',
  `tooling` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '工装（夹具、量具、刀具等）',
  `tech_doc` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '技术文档（图纸编号、技术规范等）',
  `material_list` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '备料清单（物料编码、规格、数量等）',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `create_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '创建人',
  `update_time` datetime NOT NULL COMMENT '最后更新时间',
  `update_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '最后更新人',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_sop_id`(`sop_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'SOP内容表（作业指导书编制内容）' ROW_FORMAT = Dynamic;

-- ----------------------------
-- 菜单项：SOP管理挂载到工艺管理(15)下，id=174
-- 工艺管理下已有: 工艺路线管理(151), 工艺BOM管理(152), 工艺流程维护(172), 产品工艺查询(173)
-- SOP管理排序号=4，排在产品工艺查询(sort=3)之后
-- ----------------------------
INSERT IGNORE INTO `sp_sys_menu` VALUES ('174', 'sopDef', 'SOP管理', '/technology/sop/list-ui', '15', '3', 4, '0', 'user:add', 'fa fa-file-text-o', '', NOW(), 'admin', NOW(), 'admin');

-- ----------------------------
-- 角色-菜单绑定：管理员可访问SOP管理
-- ----------------------------
INSERT IGNORE INTO `sp_sys_role_menu` VALUES ('1340000000000035', '1185025876737396738', '174', NOW(), 'admin', NOW(), 'admin');

-- ----------------------------
-- 字典数据：SOP状态
-- ----------------------------
INSERT IGNORE INTO `sp_sys_dict` (`id`, `name`, `value`, `type`, `descr`, `sort_num`, `parent_id`, `is_deleted`, `create_time`, `create_username`, `update_time`, `update_username`)
VALUES ('1337619000000030', '草稿', 'draft', 'sop_state', 'SOP草稿状态', 1, '0', '0', NOW(), 'admin', NOW(), 'admin');

INSERT IGNORE INTO `sp_sys_dict` (`id`, `name`, `value`, `type`, `descr`, `sort_num`, `parent_id`, `is_deleted`, `create_time`, `create_username`, `update_time`, `update_username`)
VALUES ('1337619000000031', '审核中', 'review', 'sop_state', 'SOP审核中状态', 2, '0', '0', NOW(), 'admin', NOW(), 'admin');

INSERT IGNORE INTO `sp_sys_dict` (`id`, `name`, `value`, `type`, `descr`, `sort_num`, `parent_id`, `is_deleted`, `create_time`, `create_username`, `update_time`, `update_username`)
VALUES ('1337619000000032', '已发布', 'pass', 'sop_state', 'SOP已发布状态', 3, '0', '0', NOW(), 'admin', NOW(), 'admin');

SET FOREIGN_KEY_CHECKS = 1;
