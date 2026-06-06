-- ----------------------------
-- 班组管理 SQL 迁移脚本
-- 日期: 2026-06-06
-- 对应任务: 大任务一 / 1.2 班组员工定义
-- 目标数据库: mes_db
-- ----------------------------

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for sp_team
-- ----------------------------
DROP TABLE IF EXISTS `sp_team`;
CREATE TABLE `sp_team` (
  `id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '主键id',
  `code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '班组编码',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '班组名称',
  `dept_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '所属部门ID',
  `leader_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '班组长ID',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  `create_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '创建人',
  `update_time` datetime(0) NOT NULL COMMENT '最后更新时间',
  `update_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '最后更新人',
  `is_deleted` char(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '逻辑删除：1 表示删除，0 表示未删除，2 表示禁用',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_team_code`(`code`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '班组表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sp_team_user_rel
-- ----------------------------
DROP TABLE IF EXISTS `sp_team_user_rel`;
CREATE TABLE `sp_team_user_rel` (
  `id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '主键id',
  `team_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '班组ID',
  `user_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '员工ID',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  `create_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '创建人',
  `update_time` datetime(0) NOT NULL COMMENT '最后更新时间',
  `update_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '最后更新人',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_team_id`(`team_id`) USING BTREE,
  INDEX `idx_user_id`(`user_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '班组-员工绑定关系表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- 菜单项：班组管理（二级：常规管理 > 班组管理）id=19
-- ----------------------------
INSERT INTO `sp_sys_menu` VALUES ('19', 'team', '班组管理', '#', '1', '2', 6, '0', 'user:add', 'fa fa-users', '', NOW(), 'admin', NOW(), 'admin');

-- ----------------------------
-- 菜单项：班组维护（三级：班组管理 > 班组维护）id=191
-- ----------------------------
INSERT INTO `sp_sys_menu` VALUES ('191', 'teamDef', '班组维护', '/basedata/team/list-ui', '19', '3', 1, '0', 'user:add', 'fa fa-user-circle', '', NOW(), 'admin', NOW(), 'admin');

-- ----------------------------
-- 测试数据：班组
-- ----------------------------
INSERT INTO `sp_team` VALUES ('1340000000000001', 'TEAM-01', '装配一班', '1336866559213600', '1184019107907227649', NOW(), 'admin', NOW(), 'admin', '0');
INSERT INTO `sp_team` VALUES ('1340000000000002', 'TEAM-02', '测试一班', '1336866559213600', '1184010472443396098', NOW(), 'admin', NOW(), 'admin', '0');

-- ----------------------------
-- 测试数据：班组-员工绑定
-- ----------------------------
INSERT INTO `sp_team_user_rel` VALUES ('1340000000000011', '1340000000000001', '1184019107907227649', NOW(), 'admin', NOW(), 'admin');
INSERT INTO `sp_team_user_rel` VALUES ('1340000000000012', '1340000000000001', '1184010472443396098', NOW(), 'admin', NOW(), 'admin');
INSERT INTO `sp_team_user_rel` VALUES ('1340000000000013', '1340000000000002', '1184010472443396098', NOW(), 'admin', NOW(), 'admin');

-- ----------------------------
-- 角色-菜单绑定：管理员可访问班组管理
-- ----------------------------
INSERT INTO `sp_sys_role_menu` VALUES ('1340000000000025', '1185025876737396738', '19', NOW(), 'admin', NOW(), 'admin');
INSERT INTO `sp_sys_role_menu` VALUES ('1340000000000026', '1185025876737396738', '191', NOW(), 'admin', NOW(), 'admin');

SET FOREIGN_KEY_CHECKS = 1;
