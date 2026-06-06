<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>员工分配 - ${team.name}</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=0">
    <#include "${request.contextPath}/common/common.ftl">
    <style>
        .user-check-list { padding: 15px 20px; max-height: 420px; overflow-y: auto; }
        .user-check-list .layui-form-item { margin-bottom: 8px; }
    </style>
</head>
<body>
<div class="splayui-container">
    <div class="splayui-main">
        <blockquote class="layui-elem-quote">
            班组：<strong>${team.name}</strong>（${team.code}）
        </blockquote>

        <form class="layui-form" lay-filter="user-form">
            <div class="user-check-list" id="js-user-list">
                <div style="text-align:center;padding:40px;"><i class="layui-icon layui-icon-loading layui-anim layui-anim-rotate layui-anim-loop"></i> 加载员工列表...</div>
            </div>

            <div class="layui-form-item layui-hide">
                <input id="js-teamId" value="${team.id}"/>
                <button id="js-submit" class="layui-btn" lay-submit lay-filter="js-submit-filter">保存分配</button>
            </div>
        </form>
    </div>
</div>

<script>
    layui.use(['form'], function () {
        var form = layui.form;
        var teamId = '${team.id}';
        var allUsers = [], assignedIds = [];
        var usersLoaded = false, idsLoaded = false;

        // 并行加载
        spUtil.ajax({
            url: '${request.contextPath}/basedata/team/user-list', type: 'GET',
            success: function (data) { allUsers = data.data || []; usersLoaded = true; tryRender(); }
        });
        spUtil.ajax({
            url: '${request.contextPath}/basedata/team/user-ids/' + teamId, type: 'GET',
            success: function (data) { assignedIds = data.data || []; idsLoaded = true; tryRender(); }
        });

        function tryRender() {
            if (!usersLoaded || !idsLoaded) return;
            var container = $('#js-user-list');
            container.empty();
            if (allUsers.length === 0) {
                container.html('<div style="text-align:center;padding:40px;color:#999;">暂无员工数据</div>');
                return;
            }
            $.each(allUsers, function (i, user) {
                var checked = assignedIds.indexOf(user.id) !== -1;
                container.append(
                    '<div class="layui-form-item"><input type="checkbox" name="userIds" value="' + user.id + '" title="' + user.name + ' (' + user.username + ')" lay-filter="user-check"' + (checked ? ' checked' : '') + '></div>'
                );
            });
            form.render('checkbox', 'user-form');
        }

        form.on('submit(js-submit-filter)', function (data) {
            var checkedIds = [];
            $('input[name="userIds"]:checked').each(function () { checkedIds.push($(this).val()); });

            spUtil.ajax({
                url: '${request.contextPath}/basedata/team/assign-users',
                type: 'POST', showLoading: true, serializable: false,
                data: { teamId: teamId, userIds: checkedIds.join(',') },
                success: function () {
                    parent.layer.msg('员工分配成功');
                    parent.layer.closeAll();
                }
            });
            return false;
        });
    });
</script>
</body>
</html>
