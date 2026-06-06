-- ----------------------------
-- 设备管理 + 库房库位 SQL 迁移脚本
-- 日期: 2026-06-02
-- 对应任务: 大任务一 - 4.1 资源分配管理
-- 目标数据库: mes_db
-- ----------------------------

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for sp_equipment
-- ----------------------------
DROP TABLE IF EXISTS `sp_equipment`;
CREATE TABLE `sp_equipment`  (
  `id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '主键id',
  `code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '设备编码',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '设备名称',
  `category` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '设备分类',
  `spec_model` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '规格型号',
  `status` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '设备状态',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  `create_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '创建人',
  `update_time` datetime(0) NOT NULL COMMENT '最后更新时间',
  `update_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '最后更新人',
  `is_deleted` char(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '逻辑删除：1 表示删除，0 表示未删除，2 表示禁用',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '设备表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sp_warehouse
-- ----------------------------
DROP TABLE IF EXISTS `sp_warehouse`;
CREATE TABLE `sp_warehouse`  (
  `id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '主键id',
  `code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '库房编码',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '库房名称',
  `type` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '库房类型（原材料/半成品/成品）',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  `create_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '创建人',
  `update_time` datetime(0) NOT NULL COMMENT '最后更新时间',
  `update_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '最后更新人',
  `is_deleted` char(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '逻辑删除：1 表示删除，0 表示未删除，2 表示禁用',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '库房表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sp_warehouse_location
-- ----------------------------
DROP TABLE IF EXISTS `sp_warehouse_location`;
CREATE TABLE `sp_warehouse_location`  (
  `id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '主键id',
  `code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '库位编码',
  `warehouse_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '所属库房ID',
  `status` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '库位状态',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  `create_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '创建人',
  `update_time` datetime(0) NOT NULL COMMENT '最后更新时间',
  `update_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '最后更新人',
  `is_deleted` char(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '逻辑删除：1 表示删除，0 表示未删除，2 表示禁用',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '库位表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- 菜单项：设备管理（二级：常规管理 > 设备管理）id=18，id=16已被在制品管理占用
-- ----------------------------
INSERT IGNORE INTO `sp_sys_menu` VALUES ('18', 'equipment', '设备管理', '#', '1', '2', 5, '0', 'user:add', 'fa fa-cogs', '', NOW(), 'admin', NOW(), 'admin');

-- ----------------------------
-- 菜单项：设备维护（三级：设备管理 > 设备维护）id=181
-- ----------------------------
INSERT IGNORE INTO `sp_sys_menu` VALUES ('181', 'equipmentDef', '设备维护', '/basedata/equipment/list-ui', '18', '3', 1, '0', 'user:add', 'fa fa-wrench', '', NOW(), 'admin', NOW(), 'admin');

-- ----------------------------
-- 菜单项：库房维护（三级：常规管理 > 物料管理 > 库房维护）id=132
-- ----------------------------
INSERT IGNORE INTO `sp_sys_menu` VALUES ('132', 'warehouseDef', '库房维护', '/basedata/warehouse/list-ui', '13', '3', 2, '0', 'user:add', 'fa fa-building', '', NOW(), 'admin', NOW(), 'admin');

-- ----------------------------
-- 菜单项：库位维护（三级：常规管理 > 物料管理 > 库位维护）id=133
-- ----------------------------
INSERT IGNORE INTO `sp_sys_menu` VALUES ('133', 'locationDef', '库位维护', '/basedata/warehouseLocation/list-ui', '13', '3', 3, '0', 'user:add', 'fa fa-th-large', '', NOW(), 'admin', NOW(), 'admin');

-- ----------------------------
-- 字典数据：设备状态
-- ----------------------------
INSERT IGNORE INTO `sp_sys_dict` VALUES ('1337619000000001', '正常', 'NORMAL', 'equipment_status', '设备状态', 1, '\"\"', '0', NOW(), 'admin', NOW(), 'admin');
INSERT IGNORE INTO `sp_sys_dict` VALUES ('1337619000000002', '维修中', 'REPAIR', 'equipment_status', '设备状态', 2, '\"\"', '0', NOW(), 'admin', NOW(), 'admin');
INSERT IGNORE INTO `sp_sys_dict` VALUES ('1337619000000003', '已报废', 'SCRAPPED', 'equipment_status', '设备状态', 3, '\"\"', '0', NOW(), 'admin', NOW(), 'admin');

-- ----------------------------
-- 字典数据：库房类型
-- ----------------------------
INSERT IGNORE INTO `sp_sys_dict` VALUES ('1337619000000004', '原材料库', 'RAW', 'warehouse_type', '库房类型', 1, '\"\"', '0', NOW(), 'admin', NOW(), 'admin');
INSERT IGNORE INTO `sp_sys_dict` VALUES ('1337619000000005', '半成品库', 'SEMI', 'warehouse_type', '库房类型', 2, '\"\"', '0', NOW(), 'admin', NOW(), 'admin');
INSERT IGNORE INTO `sp_sys_dict` VALUES ('1337619000000006', '成品库', 'FINISHED', 'warehouse_type', '库房类型', 3, '\"\"', '0', NOW(), 'admin', NOW(), 'admin');

-- ----------------------------
-- 字典数据：库位状态
-- ----------------------------
INSERT IGNORE INTO `sp_sys_dict` VALUES ('1337619000000007', '空闲', 'IDLE', 'location_status', '库位状态', 1, '\"\"', '0', NOW(), 'admin', NOW(), 'admin');
INSERT IGNORE INTO `sp_sys_dict` VALUES ('1337619000000008', '占用', 'OCCUPIED', 'location_status', '库位状态', 2, '\"\"', '0', NOW(), 'admin', NOW(), 'admin');
INSERT IGNORE INTO `sp_sys_dict` VALUES ('1337619000000009', '禁用', 'DISABLED', 'location_status', '库位状态', 3, '\"\"', '0', NOW(), 'admin', NOW(), 'admin');

-- ----------------------------
-- 角色-菜单绑定：管理员可访问设备管理/库房库位
-- ----------------------------
INSERT IGNORE INTO `sp_sys_role_menu` VALUES ('1340000000000021', '1185025876737396738', '18', NOW(), 'admin', NOW(), 'admin');
INSERT IGNORE INTO `sp_sys_role_menu` VALUES ('1340000000000022', '1185025876737396738', '181', NOW(), 'admin', NOW(), 'admin');
INSERT IGNORE INTO `sp_sys_role_menu` VALUES ('1340000000000023', '1185025876737396738', '132', NOW(), 'admin', NOW(), 'admin');
INSERT IGNORE INTO `sp_sys_role_menu` VALUES ('1340000000000024', '1185025876737396738', '133', NOW(), 'admin', NOW(), 'admin');

SET FOREIGN_KEY_CHECKS = 1;
