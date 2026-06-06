-- ----------------------------
-- 物料管理增强 SQL 迁移脚本
-- 日期: 2026-06-06
-- 对应任务: 大任务一 / 1.5 物料信息定义
-- 目标数据库: mes_db
-- ----------------------------

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- 1. 物料编码唯一索引（保证一物一码）
--    使用存储过程检查索引是否已存在，防止重复执行报错
-- ----------------------------
DROP PROCEDURE IF EXISTS `add_materile_index`;
DELIMITER //
CREATE PROCEDURE `add_materile_index`()
BEGIN
  -- 先清理可能的重复编码（保留最早创建的一条）
  DELETE t1 FROM sp_materile t1
  INNER JOIN sp_materile t2
  WHERE t1.id > t2.id AND t1.materiel = t2.materiel;
  -- 仅在索引不存在时创建
  IF NOT EXISTS (SELECT * FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'sp_materile' AND INDEX_NAME = 'uk_materiel') THEN
    ALTER TABLE `sp_materile` ADD UNIQUE INDEX `uk_materiel` (`materiel`) USING BTREE;
  END IF;
END //
DELIMITER ;
CALL `add_materile_index`();
DROP PROCEDURE IF EXISTS `add_materile_index`;

-- ----------------------------
-- 2. 补充字典数据：物料类型——原材料（RM）
--    原有字典仅有 FG(成品) 和 PG(半成品)，缺少原材料
--    使用存储过程防止重复插入报错
-- ----------------------------
INSERT IGNORE INTO `sp_sys_dict` VALUES ('1337619000000010', '原材料', 'RM', 'material_type', '物料类型', 1, '\"\"', '0', NOW(), 'admin', NOW(), 'admin');

-- ----------------------------
-- 3. 更新现有字典排序号：原材料(1)→半成品(2)→成品(3)
-- ----------------------------
UPDATE `sp_sys_dict` SET sort_num = 2 WHERE `type` = 'material_type' AND `value` = 'PG';
UPDATE `sp_sys_dict` SET sort_num = 3 WHERE `type` = 'material_type' AND `value` = 'FG';

SET FOREIGN_KEY_CHECKS = 1;
