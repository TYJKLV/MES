<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>SOP管理</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <#include "${request.contextPath}/common/common.ftl">
</head>
<body>
<div class="splayui-container">
    <div class="splayui-main">
        <form id="js-search-form" class="layui-form" lay-filter="js-q-form-filter">
            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label">SOP编号</label>
                    <div class="layui-input-inline">
                        <input type="text" name="codeLike" autocomplete="off" class="layui-input">
                    </div>
                </div>
                <div class="layui-inline">
                    <label class="layui-form-label">SOP名称</label>
                    <div class="layui-input-inline">
                        <input type="text" name="nameLike" autocomplete="off" class="layui-input">
                    </div>
                </div>
                <div class="layui-inline">
                    <a class="layui-btn" lay-submit lay-filter="js-search-filter"><i class="layui-icon layui-icon-search layuiadmin-button-btn"></i></a>
                </div>
            </div>
        </form>
        <table class="layui-hide" id="js-record-table" lay-filter="js-record-table-filter"></table>
    </div>
</div>

<script type="text/html" id="js-record-table-toolbar-top">
    <div class="layui-btn-container">
        <button class="layui-btn layui-btn-danger layui-btn-sm" lay-event="deleteBatch"><i class="layui-icon">&#xe640;</i>批量删除</button>
        <button class="layui-btn layui-btn-sm" lay-event="add"><i class="layui-icon">&#xe61f;</i>添加</button>
    </div>
</script>

<script type="text/html" id="js-record-table-toolbar-right">
    <a class="layui-btn layui-btn-xs layui-btn-warm" lay-event="content"><i class="layui-icon layui-icon-edit"></i>编制</a>
    <a class="layui-btn layui-btn-xs layui-btn-normal" lay-event="preview"><i class="layui-icon layui-icon-read"></i>预览</a>
    {{# if(d.state == 'draft'){ }}
    <a class="layui-btn layui-btn-xs" lay-event="submitReview">提交审核</a>
    {{# } else if(d.state == 'review'){ }}
    <a class="layui-btn layui-btn-xs layui-btn-normal" lay-event="publish">发布</a>
    {{# } }}
    <a class="layui-btn layui-btn-xs" lay-event="edit"><i class="layui-icon layui-icon-edit"></i>编辑</a>
    <a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="delete"><i class="layui-icon layui-icon-delete"></i>删除</a>
</script>

<script>
    layui.use(['form', 'table', 'spLayer', 'spTable'], function () {
        var form = layui.form, table = layui.table, spLayer = layui.spLayer, spTable = layui.spTable;

        var tableIns = spTable.render({
            url: '${request.contextPath}/technology/sop/page',
            cols: [[
                {type: 'checkbox'},
                {field: 'code', title: 'SOP编号'},
                {field: 'name', title: 'SOP名称'},
                {field: 'operId', title: '关联工序ID'},
                {field: 'version', title: '版本号'},
                {field: 'state', title: '状态', templet: function (d) {
                    if (d.state === 'draft') return '<span style="color:#999;">草稿</span>';
                    if (d.state === 'review') return '<span style="color:#FFB800;">审核中</span>';
                    if (d.state === 'pass') return '<span style="color:#5FB878;">已发布</span>';
                    return d.state;
                }},
                {field: 'deleted', title: '有效', templet: function (d) { return spConfig.isDeletedDict[d.deleted]; }},
                {fixed: 'right', field: 'operate', title: '操作', toolbar: '#js-record-table-toolbar-right', unresize: true, width: 270}
            ]]
        });

        $(function () { form.render(); });

        form.on('submit(js-search-filter)', function (data) {
            tableIns.reload({ where: data.field, page: { curr: 1 } });
            return false;
        });

        table.on('toolbar(js-record-table-filter)', function (obj) {
            if (obj.event === 'deleteBatch') {
                var data = table.checkStatus('js-record-table').data;
                if (data.length > 0) {
                    layer.confirm('确认要删除选中的 ' + data.length + ' 条记录吗？', function (index) {
                        var ids = $.map(data, function (item) { return item.id; });
                        spUtil.ajax({ url: '${request.contextPath}/technology/sop/batch-delete', type: 'POST', showLoading: true, serializable: false, data: {ids: ids.join(',')}, success: function () { tableIns.reload(); layer.close(index); } });
                    });
                } else { layer.msg("请先选择需要删除的数据！"); }
            }
            if (obj.event === 'add') {
                spLayer.open({ title: '添加', area: ['800px', '520px'], content: '${request.contextPath}/technology/sop/add-or-update-ui' });
            }
        });

        table.on('tool(js-record-table-filter)', function (obj) {
            var data = obj.data;
            if (obj.event === 'content') {
                spLayer.open({ title: 'SOP编制 - ' + data.name, area: ['95%', '95%'], spWhere: {sopId: data.id}, content: '${request.contextPath}/technology/sop/content-ui' });
            }
            if (obj.event === 'preview') {
                spLayer.open({ title: 'SOP预览 - ' + data.name, area: ['95%', '95%'], spWhere: {sopId: data.id}, content: '${request.contextPath}/technology/sop/preview-ui' });
            }
            if (obj.event === 'submitReview') {
                layer.confirm('确认提交审核？', function (index) {
                    spUtil.ajax({ url: '${request.contextPath}/technology/sop/submit-review', type: 'POST', serializable: false, data: {id: data.id}, success: function () { tableIns.reload(); layer.close(index); } });
                });
            }
            if (obj.event === 'publish') {
                layer.confirm('确认发布此SOP？发布后不可修改', function (index) {
                    spUtil.ajax({ url: '${request.contextPath}/technology/sop/publish', type: 'POST', serializable: false, data: {id: data.id}, success: function () { tableIns.reload(); layer.close(index); } });
                });
            }
            if (obj.event === 'edit') {
                spLayer.open({ title: '编辑', area: ['800px', '520px'], spWhere: {id: data.id}, content: '${request.contextPath}/technology/sop/add-or-update-ui' });
            }
            if (obj.event === 'delete') {
                layer.confirm('确认要删除吗？', function (index) {
                    spUtil.ajax({ url: '${request.contextPath}/technology/sop/delete', type: 'POST', serializable: false, data: {id: data.id}, success: function () { tableIns.reload(); layer.close(index); } });
                });
            }
        });
    });
</script>
</body>
</html>
