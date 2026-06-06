<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>工序信息</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=0">
    <#include "${request.contextPath}/common/common.ftl">
    <link href="${request.contextPath}/css/effect.css" rel="stylesheet" type="text/css"/>
</head>
<body>
<div class="splayui-container">
    <div class="splayui-main">
        <form class="layui-form splayui-form" lay-filter="formTest">
            <div class="layui-row">
                <div class="layui-col-xs6 layui-col-sm6 layui-col-md10">
                    <div class="layui-form-item">
                        <label for="js-operCode" class="layui-form-label sp-required">工序编号</label>
                        <div class="layui-input-inline">
                            <input type="text" id="js-operCode" name="operCode" lay-verify="required" autocomplete="off"
                                   class="layui-input" value="${result.operCode}">
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label for="js-oper" class="layui-form-label sp-required">工序名称</label>
                        <div class="layui-input-inline">
                            <input type="text" id="js-oper" name="oper" lay-verify="required"
                                   autocomplete="off" class="layui-input" value="${result.oper}">
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label for="js-operDesc" class="layui-form-label">工序描述</label>
                        <div class="layui-input-inline">
                            <input type="text" id="js-operDesc" name="operDesc"
                                   autocomplete="off" class="layui-input" value="${result.operDesc}">
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label for="js-manHours" class="layui-form-label">工时定额</label>
                        <div class="layui-input-inline">
                            <input type="number" id="js-manHours" name="manHours" step="0.5" min="0"
                                   autocomplete="off" class="layui-input" value="${result.manHours}" placeholder="单位：分钟">
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label for="js-workcellId" class="layui-form-label">加工单元</label>
                        <div class="layui-input-inline">
                            <select id="js-workcellId" name="workcellId">
                                <option value="">请选择</option>
                            </select>
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label for="js-is-deleted" class="layui-form-label sp-required">状态</label>
                        <div class="layui-input-block" id="js-is-deleted" style="width: 310px;">
                            <input type="radio" name="deleted" value="0" title="正常"
                                   <#if !(result??) || result.deleted == "0">checked</#if>>
                            <input type="radio" name="deleted" value="1" title="已删除"
                                   <#if result.deleted == "1">checked</#if>>
                            <input type="radio" name="deleted" value="2" title="已禁用"
                                   <#if result.deleted == "2">checked</#if>>
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
    layui.use(['form', 'util'], function () {
        var form = layui.form, util = layui.util;

        // 初始化加工单元下拉框
        spUtil.ajax({
            url: '${request.contextPath}/technology/oper/workcell-list',
            async: false, type: 'GET', serializable: false,
            success: function (data) {
                $.each(data.data, function (index, item) {
                    $('#js-workcellId').append(new Option(item.name + ' (' + item.code + ')', item.id));
                });
            }
        });

        // 回填选中值
        form.val("formTest", {
            "workcellId": "${result.workcellId}"
        });

        form.on('submit(js-submit-filter)', function (data) {
            spUtil.submitForm({
                url: "${request.contextPath}/technology/oper/add-or-update",
                data: data.field
            });
            return false;
        });
    });
</script>
</body>
</html>
