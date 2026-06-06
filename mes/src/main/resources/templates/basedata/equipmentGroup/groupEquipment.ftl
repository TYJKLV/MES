<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>设备分配 - ${group.name}</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=0">
    <#include "${request.contextPath}/common/common.ftl">
    <style>
        .equip-check-list { padding: 15px 20px; max-height: 420px; overflow-y: auto; }
        .equip-check-list .layui-form-item { margin-bottom: 8px; }
    </style>
</head>
<body>
<div class="splayui-container">
    <div class="splayui-main">
        <blockquote class="layui-elem-quote">
            编组：<strong>${group.name}</strong>（${group.code}）
        </blockquote>

        <form class="layui-form" lay-filter="equip-form">
            <div class="equip-check-list" id="js-equip-list">
                <div style="text-align:center;padding:40px;"><i class="layui-icon layui-icon-loading layui-anim layui-anim-rotate layui-anim-loop"></i> 加载设备列表...</div>
            </div>

            <div class="layui-form-item layui-hide">
                <input id="js-groupId" value="${group.id}"/>
                <button id="js-submit" class="layui-btn" lay-submit lay-filter="js-submit-filter">保存分配</button>
            </div>
        </form>
    </div>
</div>

<script>
    layui.use(['form'], function () {
        var form = layui.form;
        var groupId = '${group.id}';
        var allEquips = [], assignedIds = [];
        var equipsLoaded = false, idsLoaded = false;

        // 并行加载设备列表和已分配设备ID
        spUtil.ajax({
            url: '${request.contextPath}/basedata/equipmentGroup/equipment-list', type: 'GET',
            success: function (data) { allEquips = data.data || []; equipsLoaded = true; tryRender(); }
        });
        spUtil.ajax({
            url: '${request.contextPath}/basedata/equipmentGroup/equipment-ids/' + groupId, type: 'GET',
            success: function (data) { assignedIds = data.data || []; idsLoaded = true; tryRender(); }
        });

        function tryRender() {
            if (!equipsLoaded || !idsLoaded) return;
            var container = $('#js-equip-list');
            container.empty();
            if (allEquips.length === 0) {
                container.html('<div style="text-align:center;padding:40px;color:#999;">暂无可选设备</div>');
                return;
            }
            $.each(allEquips, function (i, equip) {
                var checked = assignedIds.indexOf(equip.id) !== -1;
                container.append(
                    '<div class="layui-form-item"><input type="checkbox" name="equipmentIds" value="' + equip.id + '" title="' + equip.name + ' (' + equip.code + ')" lay-filter="equip-check"' + (checked ? ' checked' : '') + '></div>'
                );
            });
            form.render('checkbox', 'equip-form');
        }

        form.on('submit(js-submit-filter)', function (data) {
            var checkedIds = [];
            $('input[name="equipmentIds"]:checked').each(function () { checkedIds.push($(this).val()); });

            spUtil.ajax({
                url: '${request.contextPath}/basedata/equipmentGroup/assign-equipments',
                type: 'POST', showLoading: true, serializable: false,
                data: { groupId: groupId, equipmentIds: checkedIds.join(',') },
                success: function () {
                    parent.layer.msg('设备分配成功');
                    parent.layer.closeAll();
                }
            });
            return false;
        });
    });
</script>
</body>
</html>
