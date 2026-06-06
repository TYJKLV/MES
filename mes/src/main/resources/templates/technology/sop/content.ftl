<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>SOP编制 - ${sop.name}</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <#include "${request.contextPath}/common/common.ftl">
    <style>
        .sop-step-content { padding: 15px; }
        .sop-step-content textarea { min-height: 100px; }
        .layui-tab-title { position: sticky; top: 0; background: #fff; z-index: 10; }
    </style>
</head>
<body>
<div class="splayui-container">
    <div class="splayui-main">
        <blockquote class="layui-elem-quote">
            SOP: <strong>${sop.name}</strong>（${sop.code}）| 版本：${sop.version} | 状态：${sop.state}
        </blockquote>

        <div class="layui-tab" lay-filter="sop-tab">
            <ul class="layui-tab-title">
                <li class="layui-this">工序主信息</li>
                <li>工艺内容</li>
                <li>工艺要求</li>
                <li>注意事项</li>
                <li>工装</li>
                <li>技术文档</li>
                <li>备料清单</li>
            </ul>
            <div class="layui-tab-content">
                <form class="layui-form" lay-filter="sop-form">
                    <input type="hidden" name="sopId" value="${sop.id}"/>
                    <div class="layui-tab-item layui-show">
                        <div class="layui-form-item sop-step-content">
                            <textarea name="operMainInfo" placeholder="填写工序主信息（设备参数、作业环境等）" class="layui-textarea">${(content.operMainInfo)!}</textarea>
                        </div>
                    </div>
                    <div class="layui-tab-item">
                        <div class="layui-form-item sop-step-content">
                            <textarea name="processContent" placeholder="填写工艺内容（操作步骤、加工方法等）" class="layui-textarea">${(content.processContent)!}</textarea>
                        </div>
                    </div>
                    <div class="layui-tab-item">
                        <div class="layui-form-item sop-step-content">
                            <textarea name="processReq" placeholder="填写工艺要求（精度标准、质量要求等）" class="layui-textarea">${(content.processReq)!}</textarea>
                        </div>
                    </div>
                    <div class="layui-tab-item">
                        <div class="layui-form-item sop-step-content">
                            <textarea name="attention" placeholder="填写注意事项（安全提醒、操作禁忌等）" class="layui-textarea">${(content.attention)!}</textarea>
                        </div>
                    </div>
                    <div class="layui-tab-item">
                        <div class="layui-form-item sop-step-content">
                            <textarea name="tooling" placeholder="填写工装要求（夹具、量具、刀具等）" class="layui-textarea">${(content.tooling)!}</textarea>
                        </div>
                    </div>
                    <div class="layui-tab-item">
                        <div class="layui-form-item sop-step-content">
                            <textarea name="techDoc" placeholder="填写技术文档（图纸编号、技术规范等）" class="layui-textarea">${(content.techDoc)!}</textarea>
                        </div>
                    </div>
                    <div class="layui-tab-item">
                        <div class="layui-form-item sop-step-content">
                            <textarea name="materialList" placeholder="填写备料清单（物料编码、规格、数量等）" class="layui-textarea">${(content.materialList)!}</textarea>
                        </div>
                    </div>
                    <div style="text-align:center; padding: 15px;">
                        <button class="layui-btn layui-btn-lg" lay-submit lay-filter="js-save-content">保存全部内容</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
<script>
    layui.use(['form', 'element'], function () {
        var form = layui.form, element = layui.element;
        form.on('submit(js-save-content)', function (data) {
            spUtil.ajax({
                url: '${request.contextPath}/technology/sop/save-content',
                type: 'POST', showLoading: true, serializable: true,
                data: data.field,
                success: function () {
                    parent.layer.msg('SOP内容保存成功');
                    parent.layer.closeAll();
                }
            });
            return false;
        });
    });
</script>
</body>
</html>
