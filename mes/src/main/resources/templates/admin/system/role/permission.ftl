<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>权限分配 - ${role.name}</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=0">
    <#include "${request.contextPath}/common/common.ftl">
    <style>
        .perm-tree { padding: 15px 20px; max-height: 500px; overflow-y: auto; }
        .perm-tree ul { list-style: none; padding-left: 24px; }
        .perm-tree li { padding: 3px 0; }
        .perm-tree label { cursor: pointer; }
        .perm-tree .dir-label { font-weight: bold; color: #333; }
        .perm-tree .menu-label { color: #555; }
        .perm-tree .btn-label { color: #999; font-size: 90%; }
    </style>
</head>
<body>
<div class="splayui-container">
    <div class="splayui-main">
        <form class="layui-form" lay-filter="perm-form">
            <blockquote class="layui-elem-quote">
                角色：<strong>${role.name}</strong>（${role.code}）
            </blockquote>

            <div class="perm-tree" id="js-menu-tree">
                <div style="text-align:center;padding:40px;"><i class="layui-icon layui-icon-loading layui-anim layui-anim-rotate layui-anim-loop"></i> 加载菜单中...</div>
            </div>

            <div class="layui-form-item layui-hide">
                <input id="js-roleId" value="${role.id}"/>
                <button id="js-submit" class="layui-btn" lay-submit lay-filter="js-submit-filter">保存权限</button>
            </div>
        </form>
    </div>
</div>

<script type="text/html" id="js-tree-node-tpl">
    {{# layui.each(d, function(index, node) { }}
    <li>
        <input type="checkbox" name="menuIds" value="{{ node.id }}" title="{{ node.name }}" data-pid="{{ node.pid }}" lay-filter="menu-check" {{ node.checked ? 'checked' : '' }}>
        {{# if (node.children && node.children.length > 0) { }}
        <ul>{{ node.children }}</ul>
        {{# } }}
    </li>
    {{# }); }}
</script>

<script>
    layui.use(['form', 'util'], function () {
        var form = layui.form,
            util = layui.util;
        var roleId = '${role.id}';
        var menuTreeData = [];
        var roleMenuIds = [];

        // 加载数据
        loadData();

        function loadData() {
            // 并行加载菜单树和角色已有权限
            var menuLoaded = false, idsLoaded = false;

            spUtil.ajax({
                url: '${request.contextPath}/admin/sys/menu/tree',
                type: 'GET',
                success: function (data) {
                    menuTreeData = data.data || [];
                    menuLoaded = true;
                    tryRender();
                }
            });

            spUtil.ajax({
                url: '${request.contextPath}/admin/sys/role/menu-ids/' + roleId,
                type: 'GET',
                success: function (data) {
                    roleMenuIds = data.data || [];
                    idsLoaded = true;
                    tryRender();
                }
            });

            function tryRender() {
                if (menuLoaded && idsLoaded) {
                    renderTree();
                }
            }
        }

        function renderTree() {
            var container = $('#js-menu-tree');
            container.empty();

            if (!menuTreeData || menuTreeData.length === 0) {
                container.html('<div style="text-align:center;padding:40px;color:#999;">暂无菜单数据</div>');
                return;
            }

            var html = '<ul>';
            $.each(menuTreeData, function (i, node) {
                html += buildNodeHtml(node);
            });
            html += '</ul>';
            container.html(html);
            form.render('checkbox', 'perm-form');
        }

        function buildNodeHtml(node) {
            var checked = roleMenuIds.indexOf(node.id) !== -1;
            var typeClass = '';
            if (node.type === '0') typeClass = 'dir-label';
            else if (node.type === '1') typeClass = 'menu-label';
            else if (node.type === '2') typeClass = 'btn-label';

            var html = '<li>';
            html += '<input type="checkbox" name="menuIds" value="' + node.id + '" title="' + node.name + '" data-pid="' + node.pid + '" lay-filter="menu-check"';
            if (checked) html += ' checked';
            html += ' class="' + typeClass + '">';

            if (node.children && node.children.length > 0) {
                html += '<ul>';
                $.each(node.children, function (i, child) {
                    html += buildNodeHtml(child);
                });
                html += '</ul>';
            }
            html += '</li>';
            return html;
        }

        // 监听提交
        form.on('submit(js-submit-filter)', function (data) {
            var checkedIds = [];
            $('input[name="menuIds"]:checked').each(function () {
                checkedIds.push($(this).val());
            });

            spUtil.ajax({
                url: '${request.contextPath}/admin/sys/role/assign-menu',
                type: 'POST',
                showLoading: true,
                serializable: false,
                data: {
                    roleId: roleId,
                    menuIds: checkedIds.join(',')
                },
                success: function (result) {
                    parent.layer.msg('权限分配成功');
                    parent.layer.closeAll();
                    // 刷新父窗口表格
                    if (parent && parent.layui && parent.layui.table) {
                        parent.layui.table.reload('js-record-table');
                    }
                }
            });
            return false;
        });
    });
</script>
</body>
</html>