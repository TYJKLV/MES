<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>BOM绑定 - ${flow.flow}</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=0">
    <#include "${request.contextPath}/common/common.ftl">
    <style>
        .bom-check-list { padding: 15px 20px; max-height: 420px; overflow-y: auto; }
        .bom-check-list .layui-form-item { margin-bottom: 8px; }
    </style>
</head>
<body>
<div class="splayui-container">
    <div class="splayui-main">
        <blockquote class="layui-elem-quote">
            工艺流程：<strong>${flow.flow}</strong>（${flow.flowDesc}）
        </blockquote>

        <form class="layui-form" lay-filter="bom-form">
            <div class="bom-check-list" id="js-bom-list">
                <div style="text-align:center;padding:40px;"><i class="layui-icon layui-icon-loading layui-anim layui-anim-rotate layui-anim-loop"></i> 加载BOM列表...</div>
            </div>

            <div class="layui-form-item layui-hide">
                <input id="js-flowId" value="${flow.id}"/>
                <button id="js-submit" class="layui-btn" lay-submit lay-filter="js-submit-filter">保存绑定</button>
            </div>
        </form>
    </div>
</div>

<script>
    layui.use(['form'], function () {
        var form = layui.form;
        var flowId = '${flow.id}';
        var allBoms = [], assignedIds = [];
        var bomsLoaded = false, idsLoaded = false;

        spUtil.ajax({
            url: '${request.contextPath}/technology/flow/bom-list', type: 'GET',
            success: function (data) { allBoms = data.data || []; bomsLoaded = true; tryRender(); }
        });
        spUtil.ajax({
            url: '${request.contextPath}/technology/flow/bom-ids/' + flowId, type: 'GET',
            success: function (data) { assignedIds = data.data || []; idsLoaded = true; tryRender(); }
        });

        function tryRender() {
            if (!bomsLoaded || !idsLoaded) return;
            var container = $('#js-bom-list');
            container.empty();
            if (allBoms.length === 0) {
                container.html('<div style="text-align:center;padding:40px;color:#999;">暂无可选BOM</div>');
                return;
            }
            $.each(allBoms, function (i, bom) {
                var checked = assignedIds.indexOf(bom.id) !== -1;
                container.append(
                    '<div class="layui-form-item"><input type="checkbox" name="bomIds" value="' + bom.id + '" title="' + bom.bomCode + ' - ' + bom.materielDesc + '" lay-filter="bom-check"' + (checked ? ' checked' : '') + '></div>'
                );
            });
            form.render('checkbox', 'bom-form');
        }

        form.on('submit(js-submit-filter)', function (data) {
            var checkedIds = [];
            $('input[name="bomIds"]:checked').each(function () { checkedIds.push($(this).val()); });
            spUtil.ajax({
                url: '${request.contextPath}/technology/flow/assign-boms',
                type: 'POST', showLoading: true, serializable: false,
                data: { flowId: flowId, bomIds: checkedIds.join(',') },
                success: function () {
                    parent.layer.msg('BOM绑定成功');
                    parent.layer.closeAll();
                }
            });
            return false;
        });
    });
</script>
</body>
</html>
