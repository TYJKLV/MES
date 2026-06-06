-- ----------------------------
-- 加工单元 SQL 迁移脚本
-- 日期: 2026-06-06
-- 对应任务: 大任务一 / 1.4 加工单元定义
-- 目标数据库: mes_db
-- 前置依赖: 需先执行 MySQL-20260606-equipment-group.sql（sp_equipment_group 表）
-- ----------------------------

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for sp_workcell
-- ----------------------------
DROP TABLE IF EXISTS `sp_workcell`;
CREATE TABLE `sp_workcell` (
  `id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '主键id',
  `code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '加工单元编码',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '加工单元名称',
  `dept_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '所属车间ID（关联sys_department）',
  `group_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '关联设备编组ID（关联sp_equipment_group）',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  `create_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '创建人',
  `update_time` datetime(0) NOT NULL COMMENT '最后更新时间',
  `update_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '最后更新人',
  `is_deleted` char(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '逻辑删除：1 表示删除，0 表示未删除，2 表示禁用',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_workcell_code`(`code`) USING BTREE,
  INDEX `idx_dept_id`(`dept_id`) USING BTREE,
  INDEX `idx_group_id`(`group_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '加工单元表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- 菜单项：加工单元管理（二级：常规管理 > 加工单元管理）id=20
-- ----------------------------
INSERT INTO `sp_sys_menu` VALUES ('20', 'workcell', '加工单元管理', '#', '1', '2', 7, '0', 'user:add', 'fa fa-cubes', '', NOW(), 'admin', NOW(), 'admin');

-- ----------------------------
-- 菜单项：加工单元维护（三级：加工单元管理 > 加工单元维护）id=201
-- ----------------------------
INSERT INTO `sp_sys_menu` VALUES ('201', 'workcellDef', '加工单元维护', '/basedata/workcell/list-ui', '20', '3', 1, '0', 'user:add', 'fa fa-cube', '', NOW(), 'admin', NOW(), 'admin');

-- ----------------------------
-- 角色-菜单绑定：管理员可访问加工单元管理
-- ----------------------------
INSERT INTO `sp_sys_role_menu` VALUES ('1340000000000028', '1185025876737396738', '20', NOW(), 'admin', NOW(), 'admin');
INSERT INTO `sp_sys_role_menu` VALUES ('1340000000000029', '1185025876737396738', '201', NOW(), 'admin', NOW(), 'admin');

-- ----------------------------
-- 测试数据：加工单元
-- ----------------------------
INSERT INTO `sp_workcell` VALUES ('1360000000000001', 'CELL-01', '数控加工单元', '1336866559213600', '1350000000000001', NOW(), 'admin', NOW(), 'admin', '0');
INSERT INTO `sp_workcell` VALUES ('1360000000000002', 'CELL-02', '装配作业单元', '1336866559213600', '1350000000000002', NOW(), 'admin', NOW(), 'admin', '0');

SET FOREIGN_KEY_CHECKS = 1;
