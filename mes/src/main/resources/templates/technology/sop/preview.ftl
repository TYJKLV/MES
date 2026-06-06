<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>SOP预览 - ${sop.name}</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <#include "${request.contextPath}/common/common.ftl">
    <style>
        .preview-section { margin: 15px 20px; padding: 15px; border: 1px solid #e2e2e2; border-radius: 4px; }
        .preview-title { font-size: 16px; font-weight: bold; color: #1E9FFF; margin-bottom: 10px; padding-bottom: 8px; border-bottom: 1px dashed #e2e2e2; }
        .preview-body { color: #333; line-height: 1.8; white-space: pre-wrap; min-height: 40px; }
        .sop-header { text-align: center; padding: 20px; }
        .sop-header h2 { font-size: 22px; margin-bottom: 8px; }
        .sop-header .meta { color: #999; font-size: 13px; }
    </style>
</head>
<body>
<div class="splayui-container">
    <div class="splayui-main">
        <div class="sop-header">
            <h2>${sop.name}</h2>
            <div class="meta">编号：${sop.code} | 版本：${sop.version} | 状态：${sop.state} | 关联BOM：${sop.bomId}</div>
        </div>
        <#if content??>
            <div class="preview-section"><div class="preview-title">一、工序主信息</div><div class="preview-body">${(content.operMainInfo)!"（无）"}</div></div>
            <div class="preview-section"><div class="preview-title">二、工艺内容</div><div class="preview-body">${(content.processContent)!"（无）"}</div></div>
            <div class="preview-section"><div class="preview-title">三、工艺要求</div><div class="preview-body">${(content.processReq)!"（无）"}</div></div>
            <div class="preview-section"><div class="preview-title">四、注意事项</div><div class="preview-body">${(content.attention)!"（无）"}</div></div>
            <div class="preview-section"><div class="preview-title">五、工装</div><div class="preview-body">${(content.tooling)!"（无）"}</div></div>
            <div class="preview-section"><div class="preview-title">六、技术文档</div><div class="preview-body">${(content.techDoc)!"（无）"}</div></div>
            <div class="preview-section"><div class="preview-title">七、备料清单</div><div class="preview-body">${(content.materialList)!"（无）"}</div></div>
        <#else>
            <div style="text-align:center;padding:60px;color:#999;">该SOP尚未编制内容，请先在列表页点击「编制」按钮填写</div>
        </#if>
    </div>
</div>
</body>
</html>
