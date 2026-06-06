<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>工艺流程信息</title>
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
                        <label for="js-flow" class="layui-form-label sp-required">流程编码</label>
                        <div class="layui-input-inline">
                            <input type="text" id="js-flow" name="flow" lay-verify="required" autocomplete="off"
                                   class="layui-input" value="${result.flow}">
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label for="js-flowDesc" class="layui-form-label sp-required">流程描述</label>
                        <div class="layui-input-inline">
                            <input type="text" id="js-flowDesc" name="flowDesc" lay-verify="required"
                                   autocomplete="off" class="layui-input" value="${result.flowDesc}">
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label for="js-version" class="layui-form-label sp-required">版本号</label>
                        <div class="layui-input-inline">
                            <input type="text" id="js-version" name="version" lay-verify="required"
                                   autocomplete="off" class="layui-input" value="${result.version}" placeholder="如 1">
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label for="js-process" class="layui-form-label">流程时序</label>
                        <div class="layui-input-inline">
                            <input type="text" id="js-process" name="process"
                                   autocomplete="off" class="layui-input" value="${result.process}" placeholder="如: A→B→C">
                        </div>
                    </div>
                    <div class="layui-form-item" id="js-state-row" <#if !(result??)>style="display:none;"</#if>>
                        <div class="layui-inline">
                            <label class="layui-form-label">审核状态</label>
                            <div class="layui-input-inline">
                                <input type="text" readonly="true" class="layui-input"
                                       value="<#if result.state == 'pass'>已定版<#elseif result.state == 'creat'>创建中<#else>${result.state}</#if>">
                                <input type="hidden" name="state" value="${result.state}">
                            </div>
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
    layui.use(['form'], function () {
        var form = layui.form;
        form.on('submit(js-submit-filter)', function (data) {
            spUtil.submitForm({
                url: "${request.contextPath}/technology/flow/add-or-update",
                data: data.field
            });
            return false;
        });
    });
</script>
</body>
</html>
