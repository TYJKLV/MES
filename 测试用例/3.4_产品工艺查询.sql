-- ============================================================
-- 3.4 产品工艺查询 — 测试用例
-- 用途：为产品工艺综合查询功能提供测试数据
-- 数据链：物料 → 工艺路线 → 工序链（含加工单元）
-- ============================================================

-- 第 1 步：清理旧测试数据（确保脚本可重复执行）
-- ============================================================

DELETE FROM `sp_flow_oper_relation` WHERE `flow_id` = 'TEST-FLOW-3.4-001';
DELETE FROM `sp_materile` WHERE `id` IN ('TEST-MAT-3.4-001', 'TEST-MAT-3.4-002');
DELETE FROM `sp_oper` WHERE `id` IN ('TEST-OPER-3.4-001', 'TEST-OPER-3.4-002', 'TEST-OPER-3.4-003');
DELETE FROM `sp_flow` WHERE `id` = 'TEST-FLOW-3.4-001';

-- 第 2 步：创建测试工艺路线（sp_flow）
-- ============================================================

INSERT INTO `sp_flow` (`id`, `flow`, `flow_desc`, `process`, `version`, `state`, `is_deleted`, `create_time`, `create_username`, `update_time`, `update_username`)
VALUES ('TEST-FLOW-3.4-001', 'FLOW-3.4-001', '测试产品加工工艺路线', '车削加工->焊接组装->质量检验', '1', 'creat', '0', NOW(), 'admin', NOW(), 'admin');

-- 验证
SELECT `id`, `flow`, `flow_desc`, `process`, `version`, `state` FROM `sp_flow` WHERE `id` = 'TEST-FLOW-3.4-001';

-- 第 3 步：创建测试工序（sp_oper）
-- 将工序关联到已有加工单元 CELL-01(id=1360000000000001)
-- ============================================================

-- 工序1：车削加工（首道工序）
INSERT INTO `sp_oper` (`id`, `oper_code`, `oper`, `oper_desc`, `man_hours`, `workcell_id`, `is_deleted`, `create_time`, `create_username`, `update_time`, `update_username`)
VALUES ('TEST-OPER-3.4-001', 'OP-3.4-001', '车削加工', 'CNC车削外圆及端面', 10.5, '1360000000000001', '0', NOW(), 'admin', NOW(), 'admin');

-- 工序2：焊接组装
INSERT INTO `sp_oper` (`id`, `oper_code`, `oper`, `oper_desc`, `man_hours`, `workcell_id`, `is_deleted`, `create_time`, `create_username`, `update_time`, `update_username`)
VALUES ('TEST-OPER-3.4-002', 'OP-3.4-002', '焊接组装', '激光焊接组件壳体', 15.0, '1360000000000001', '0', NOW(), 'admin', NOW(), 'admin');

-- 工序3：质量检验（末道工序）
INSERT INTO `sp_oper` (`id`, `oper_code`, `oper`, `oper_desc`, `man_hours`, `workcell_id`, `is_deleted`, `create_time`, `create_username`, `update_time`, `update_username`)
VALUES ('TEST-OPER-3.4-003', 'OP-3.4-003', '质量检验', '三坐标测量及外观检验', 5.0, '1360000000000001', '0', NOW(), 'admin', NOW(), 'admin');

-- 验证
SELECT `id`, `oper_code`, `oper`, `oper_desc`, `man_hours`, `workcell_id` FROM `sp_oper` WHERE `id` LIKE 'TEST-OPER-3.4-%' ORDER BY `id`;

-- 第 4 步：创建流程-工序关系（sp_flow_oper_relation）
-- 工序顺序：车削加工(1) → 焊接组装(2) → 质量检验(3)
-- ============================================================

-- 关系1：车削加工（首道工序，后续工序=焊接组装）
INSERT INTO `sp_flow_oper_relation` (`id`, `flow_id`, `flow`, `per_oper_id`, `per_oper`, `oper_id`, `oper`, `next_oper_id`, `next_oper`, `sort_num`, `oper_type`, `create_time`, `create_username`, `update_time`, `update_username`)
VALUES ('TEST-REL-3.4-001', 'TEST-FLOW-3.4-001', 'FLOW-3.4-001', '', '', 'TEST-OPER-3.4-001', '车削加工', 'TEST-OPER-3.4-002', '焊接组装', 1, 'firstOper', NOW(), 'admin', NOW(), 'admin');

-- 关系2：焊接组装（中间工序，前后均有工序）
INSERT INTO `sp_flow_oper_relation` (`id`, `flow_id`, `flow`, `per_oper_id`, `per_oper`, `oper_id`, `oper`, `next_oper_id`, `next_oper`, `sort_num`, `oper_type`, `create_time`, `create_username`, `update_time`, `update_username`)
VALUES ('TEST-REL-3.4-002', 'TEST-FLOW-3.4-001', 'FLOW-3.4-001', 'TEST-OPER-3.4-001', '车削加工', 'TEST-OPER-3.4-002', '焊接组装', 'TEST-OPER-3.4-003', '质量检验', 2, NULL, NOW(), 'admin', NOW(), 'admin');

-- 关系3：质量检验（末道工序，前道工序=焊接组装）
INSERT INTO `sp_flow_oper_relation` (`id`, `flow_id`, `flow`, `per_oper_id`, `per_oper`, `oper_id`, `oper`, `next_oper_id`, `next_oper`, `sort_num`, `oper_type`, `create_time`, `create_username`, `update_time`, `update_username`)
VALUES ('TEST-REL-3.4-003', 'TEST-FLOW-3.4-001', 'FLOW-3.4-001', 'TEST-OPER-3.4-002', '焊接组装', 'TEST-OPER-3.4-003', '质量检验', '', '', 3, 'lastOper', NOW(), 'admin', NOW(), 'admin');

-- 验证
SELECT `id`, `flow_id`, `oper`, `sort_num`, `oper_type` FROM `sp_flow_oper_relation` WHERE `flow_id` = 'TEST-FLOW-3.4-001' ORDER BY `sort_num`;

-- 第 5 步：创建测试物料并关联工艺路线（sp_materile）
-- ============================================================

-- 物料1：精密轴套（关联到测试工艺路线）
INSERT INTO `sp_materile` (`id`, `materiel`, `materiel_desc`, `unit`, `product_group`, `mat_type`, `model`, `size`, `flow_id`, `flow_desc`, `is_deleted`, `create_time`, `create_username`, `update_time`, `update_username`)
VALUES ('TEST-MAT-3.4-001', 'MAT-3.4-001', '测试产品-精密轴套', '个', '精密零件', 'PG', 'BS-100', 'φ50×80mm', 'TEST-FLOW-3.4-001', '测试产品加工工艺路线', '0', NOW(), 'admin', NOW(), 'admin');

-- 物料2：法兰盘（关联到同一工艺路线，验证多物料共享同一工艺路线）
INSERT INTO `sp_materile` (`id`, `materiel`, `materiel_desc`, `unit`, `product_group`, `mat_type`, `model`, `size`, `flow_id`, `flow_desc`, `is_deleted`, `create_time`, `create_username`, `update_time`, `update_username`)
VALUES ('TEST-MAT-3.4-002', 'MAT-3.4-002', '测试产品-法兰盘', '个', '精密零件', 'PG', 'FL-200', 'DN200 PN16', 'TEST-FLOW-3.4-001', '测试产品加工工艺路线', '0', NOW(), 'admin', NOW(), 'admin');

-- 验证：检查物料是否正确关联了工艺路线
SELECT `id`, `materiel`, `materiel_desc`, `flow_id` FROM `sp_materile` WHERE `id` IN ('TEST-MAT-3.4-001', 'TEST-MAT-3.4-002');

-- 第 6 步：多维度查询验证
-- ============================================================

-- 6.1 按物料编码查询
SELECT m.materiel, m.materiel_desc, f.flow, f.flow_desc, f.version, f.state
FROM sp_materile m
LEFT JOIN sp_flow f ON m.flow_id = f.id
WHERE m.materiel LIKE '%3.4%' AND m.is_deleted = '0';

-- 6.2 按工序名称查询（找到所有使用"车削"工序的工艺路线）
SELECT DISTINCT f.flow, f.flow_desc, r.oper, r.sort_num
FROM sp_flow f
JOIN sp_flow_oper_relation r ON f.id = r.flow_id
WHERE r.oper LIKE '%车削%' AND f.is_deleted = '0'
ORDER BY f.flow, r.sort_num;

-- 6.3 按加工单元查询（找到所有在 CELL-01 上执行的工序对应工艺路线）
SELECT DISTINCT f.flow, f.flow_desc, o.oper, o.oper_code, w.name AS workcell_name
FROM sp_flow f
JOIN sp_flow_oper_relation r ON f.id = r.flow_id
JOIN sp_oper o ON r.oper_id = o.id
JOIN sp_workcell w ON o.workcell_id = w.id
WHERE w.name LIKE '%加工%' AND f.is_deleted = '0';

-- 6.4 查看完整工艺流程（按sort_num排序）
SELECT r.sort_num, r.oper, r.oper_type, o.man_hours, w.name AS workcell_name
FROM sp_flow_oper_relation r
LEFT JOIN sp_oper o ON r.oper_id = o.id
LEFT JOIN sp_workcell w ON o.workcell_id = w.id
WHERE r.flow_id = 'TEST-FLOW-3.4-001'
ORDER BY r.sort_num;

-- 第 7 步：清理测试数据（测试完成后取消注释执行）
-- ============================================================
-- DELETE FROM `sp_flow_oper_relation` WHERE `flow_id` = 'TEST-FLOW-3.4-001';
-- DELETE FROM `sp_materile` WHERE `id` IN ('TEST-MAT-3.4-001', 'TEST-MAT-3.4-002');
-- DELETE FROM `sp_oper` WHERE `id` IN ('TEST-OPER-3.4-001', 'TEST-OPER-3.4-002', 'TEST-OPER-3.4-003');
-- DELETE FROM `sp_flow` WHERE `id` = 'TEST-FLOW-3.4-001';
-- SELECT '测试数据已全部清理' AS message;
