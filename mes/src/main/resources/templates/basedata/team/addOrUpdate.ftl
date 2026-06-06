<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>班组表单</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=0">
    <#include "${request.contextPath}/common/common.ftl">
</head>
<body>
<div class="splayui-container">
    <div class="splayui-main">
        <form class="layui-form splayui-form" lay-filter="formTest">
            <div class="layui-row">
                <div class="layui-col-xs6 layui-col-sm6 layui-col-md10">
                    <div class="layui-form-item">
                        <label for="js-code" class="layui-form-label sp-required">班组编码</label>
                        <div class="layui-input-inline">
                            <input type="text" id="js-code" name="code" lay-verify="required" autocomplete="off" class="layui-input" value="${result.code}">
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label for="js-name" class="layui-form-label sp-required">班组名称</label>
                        <div class="layui-input-inline">
                            <input type="text" id="js-name" name="name" lay-verify="required" autocomplete="off" class="layui-input" value="${result.name}">
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label for="js-deptId" class="layui-form-label">所属部门</label>
                        <div class="layui-input-inline">
                            <select id="js-deptId" name="deptId" lay-filter="dept-filter">
                                <option value="">请选择</option>
                            </select>
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label for="js-leaderId" class="layui-form-label">班组长</label>
                        <div class="layui-input-inline">
                            <select id="js-leaderId" name="leaderId" lay-filter="leader-filter">
                                <option value="">请选择</option>
                            </select>
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label for="js-is-deleted" class="layui-form-label sp-required">状态</label>
                        <div class="layui-input-block" id="js-is-deleted" style="width: 310px;">
                            <input type="radio" name="deleted" value="0" title="正常" <#if result.deleted == "0" || !(result??)>checked</#if>>
                            <input type="radio" name="deleted" value="1" title="已删除" <#if result.deleted == "1">checked</#if>>
                            <input type="radio" name="deleted" value="2" title="已禁用" <#if result.deleted == "2">checked</#if>>
                        </div>
                    </div>
                </div>
                <div class="layui-form-item layui-hide">
                    <div class="layui-input-block">
                        <input id="js-id" name="id" value="${result.id}"/>
                        <button id="js-submit" class="layui-btn" lay-submit lay-filter="js-submit-filter">确定</button>
                    </div>
                </div>
            </div>
        </form>
    </div>
</div>
<script>
    layui.use(['form'], function () {
        var form = layui.form;

        // 加载部门列表
        spUtil.ajax({
            url: '${request.contextPath}/basedata/team/dept-list',
            type: 'GET', async: false,
            success: function (data) {
                $.each(data.data, function (i, item) {
                    $('#js-deptId').append(new Option(item.name, item.id));
                });
            }
        });

        // 加载员工列表
        spUtil.ajax({
            url: '${request.contextPath}/basedata/team/user-list',
            type: 'GET', async: false,
            success: function (data) {
                $.each(data.data, function (i, item) {
                    $('#js-leaderId').append(new Option(item.name + ' (' + item.username + ')', item.id));
                });
            }
        });

        // 回填选中值
        form.val("formTest", {
            "deptId": "${result.deptId}",
            "leaderId": "${result.leaderId}"
        });

        form.render();

        form.on('submit(js-submit-filter)', function (data) {
            spUtil.submitForm({
                url: "${request.contextPath}/basedata/team/add-or-update",
                data: data.field
            });
            return false;
        });
    });
</script>
</body>
</html>
