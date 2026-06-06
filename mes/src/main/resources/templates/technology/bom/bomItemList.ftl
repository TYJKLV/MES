<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>BOM子项</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=0">
    <#include "${request.contextPath}/common/common.ftl">
    <style>
        .bom-tree-container { padding: 20px; }
        .bom-tree-node { margin-left: 24px; padding: 4px 0; border-left: 1px dashed #ccc; }
        .bom-tree-root > .bom-tree-content { font-weight: bold; background: #f6f7f9; border-radius: 4px; padding: 8px 12px; margin-bottom: 8px; }
        .bom-tree-content { padding: 4px 12px; display: inline-flex; align-items: center; gap: 12px; }
        .bom-tree-label { color: #666; font-size: 12px; }
        .bom-tree-value { color: #333; }
        .bom-toggle { cursor: pointer; color: #1E9FFF; margin-right: 4px; font-size: 12px; }
        .bom-tree-children { display: block; }
        .bom-tree-children.collapsed { display: none; }
    </style>
</head>
<body>
<div class="splayui-container">
    <div class="splayui-main">
        <div style="padding: 12px;">
            <span style="color:#999;">BOM ID: <strong>${bomHeadId}</strong></span>
            <button class="layui-btn layui-btn-xs layui-btn-normal" onclick="location.reload()" style="margin-left:12px;"><i class="layui-icon layui-icon-refresh"></i> 刷新</button>
        </div>
        <div id="js-bom-tree" class="bom-tree-container">
            <div style="text-align:center;padding:40px;"><i class="layui-icon layui-icon-loading layui-anim layui-anim-rotate layui-anim-loop"></i> 加载BOM结构...</div>
        </div>
    </div>
</div>
<script>
    $(function () {
        var bomHeadId = '${bomHeadId}';
        $.ajax({
            url: '${request.contextPath}/technology/bomItem/tree/' + bomHeadId,
            type: 'GET',
            success: function (res) {
                renderTree(res.data || []);
            },
            error: function () {
                $('#js-bom-tree').html('<div style="text-align:center;padding:40px;color:#999;">加载失败，请重试</div>');
            }
        });

        function renderTree(nodes) {
            var container = $('#js-bom-tree');
            container.empty();
            if (!nodes || nodes.length === 0) {
                container.html('<div style="text-align:center;padding:40px;color:#999;">该BOM暂无子项数据</div>');
                return;
            }
            $.each(nodes, function (i, node) {
                container.append(renderNode(node, true));
            });
        }

        function renderNode(node, isRoot) {
            var hasChildren = node.children && node.children.length > 0;
            var cls = isRoot ? 'bom-tree-root' : '';
            var html = '<div class="bom-tree-node ' + cls + '">';

            if (hasChildren) {
                html += '<div class="bom-tree-content">';
                html += '<span class="bom-toggle" onclick="$(this).closest(\'.bom-tree-node\').find(\'.bom-tree-children\').toggleClass(\'collapsed\'); var $icon=$(this).find(\'i\'); $icon.toggleClass(\'layui-icon-triangle-d\'); $icon.toggleClass(\'layui-icon-right\');"><i class="layui-icon layui-icon-triangle-d"></i></span>';
            } else {
                html += '<div class="bom-tree-content"><span style="margin-left:16px;"></span>';
            }

            html += '<span class="bom-tree-value"><strong>' + (node.materielItemCode || '') + '</strong> ' + (node.materielItemDesc || '') + '</span>';
            html += '<span class="bom-tree-label">行号:<span class="bom-tree-value">' + (node.lineNo || '-') + '</span></span>';
            html += '<span class="bom-tree-label">用量:<span class="bom-tree-value">' + (node.itemNum || '-') + '</span></span>';
            html += '<span class="bom-tree-label">单位:<span class="bom-tree-value">' + (node.itemUnit || '-') + '</span></span>';
            html += '</div>';

            if (hasChildren) {
                html += '<div class="bom-tree-children">';
                $.each(node.children, function (i, child) {
                    html += renderNode(child, false);
                });
                html += '</div>';
            }
            html += '</div>';
            return html;
        }
    });
</script>
</body>
</html>
