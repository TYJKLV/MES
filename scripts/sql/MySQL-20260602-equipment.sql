-- ----------------------------
-- 设备管理 + 库房库位 SQL 迁移脚本
-- 日期: 2026-06-02
-- 对应任务: 大任务一 - 4.1 资源分配管理
-- ----------------------------

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
-- 菜单项：设备管理（二级：常规管理 > 设备管理）
-- ----------------------------
INSERT INTO `sp_sys_menu` VALUES ('16', 'equipment', '设备管理', '#', '1', '2', 5, '0', 'user:add', 'fa fa-cogs', '', NOW(), 'admin', NOW(), 'admin');

-- ----------------------------
-- 菜单项：设备维护（三级：设备管理 > 设备维护）
-- ----------------------------
INSERT INTO `sp_sys_menu` VALUES ('161', 'equipmentDef', '设备维护', '/basedata/equipment/list-ui', '16', '3', 1, '0', 'user:add', 'fa fa-wrench', '', NOW(), 'admin', NOW(), 'admin');

-- ----------------------------
-- 字典数据：设备状态
-- ----------------------------
INSERT INTO `sp_sys_dict` VALUES ('1337619000000001', '正常', 'NORMAL', 'equipment_status', '设备状态', 1, '\"\"', '0', NOW(), 'admin', NOW(), 'admin');
INSERT INTO `sp_sys_dict` VALUES ('1337619000000002', '维修中', 'REPAIR', 'equipment_status', '设备状态', 2, '\"\"', '0', NOW(), 'admin', NOW(), 'admin');
INSERT INTO `sp_sys_dict` VALUES ('1337619000000003', '已报废', 'SCRAPPED', 'equipment_status', '设备状态', 3, '\"\"', '0', NOW(), 'admin', NOW(), 'admin');
