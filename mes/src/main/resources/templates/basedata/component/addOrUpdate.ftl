<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>零部件信息</title>
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
                        <label for="js-code" class="layui-form-label sp-required">零件编码</label>
                        <div class="layui-input-inline">
                            <input type="text" id="js-code" name="code" lay-verify="required" autocomplete="off"
                                   class="layui-input" value="${result.code}">
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label for="js-name" class="layui-form-label sp-required">零件名称</label>
                        <div class="layui-input-inline">
                            <input type="text" id="js-name" name="name" lay-verify="required"
                                   autocomplete="off" class="layui-input" value="${result.name}">
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label for="js-spec" class="layui-form-label sp-required">规格</label>
                        <div class="layui-input-inline">
                            <input type="text" id="js-spec" name="spec" lay-verify="required"
                                   autocomplete="off" class="layui-input" value="${result.spec}">
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label for="js-materielId" class="layui-form-label sp-required">关联物料</label>
                        <div class="layui-input-inline">
                            <select id="js-materielId" name="materielId" lay-verify="required">
                            </select>
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label for="js-drawingNo" class="layui-form-label">图号</label>
                        <div class="layui-input-inline">
                            <input type="text" id="js-drawingNo" name="drawingNo"
                                   autocomplete="off" class="layui-input" value="${result.drawingNo}">
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

        // 初始化关联物料下拉框
        spUtil.ajax({
            url: '${request.contextPath}/basedata/component/materiel-list',
            async: false, type: 'GET', serializable: false,
            success: function (data) {
                $.each(data.data, function (index, item) {
                    $('#js-materielId').append(new Option(item.materiel + ' - ' + item.materielDesc, item.id));
                });
            }
        });

        // 回填选中值
        form.val("formTest", {
            "materielId": "${result.materielId}"
        });

        form.on('submit(js-submit-filter)', function (data) {
            spUtil.submitForm({
                url: "${request.contextPath}/basedata/component/add-or-update",
                data: data.field
            });
            return false;
        });
    });
</script>
</body>
</html>
