<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>BOM管理</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <#include "${request.contextPath}/common/common.ftl">
</head>
<body>
<div class="splayui-container">
    <div class="splayui-main">
        <!--查询参数-->
        <form id="js-search-form" class="layui-form" lay-filter="js-q-form-filter">
            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label">物料编号</label>
                    <div class="layui-input-inline">
                        <input type="text" name="materielCodeLike" autocomplete="off" class="layui-input">
                    </div>
                </div>
                <div class="layui-inline">
                    <label class="layui-form-label">BOM类型</label>
                    <div class="layui-input-inline">
                        <select id="js-bomType" name="bomType">
                            <option value="">全部</option>
                        </select>
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

<!--表格头操作模板-->
<script type="text/html" id="js-record-table-toolbar-top">
    <div class="layui-btn-container">
        <button class="layui-btn layui-btn-danger layui-btn-sm" lay-event="deleteBatch"><i class="layui-icon">&#xe640;</i>批量删除</button>
        <button class="layui-btn layui-btn-sm" lay-event="add"><i class="layui-icon">&#xe61f;</i>添加</button>
    </div>
</script>

<!--行操作模板-->
<script type="text/html" id="js-record-table-toolbar-right">
    <a class="layui-btn layui-btn-xs" lay-event="bomItems"><i class="layui-icon layui-icon-list"></i>子项</a>
    {{# if(d.state == 'creat'){ }}
    <a class="layui-btn layui-btn-xs layui-btn-warm" lay-event="lock">定版</a>
    {{# } else if(d.state == 'pass'){ }}
    <a class="layui-btn layui-btn-xs layui-btn-normal" lay-event="unlock">取消定版</a>
    {{# } }}
    <a class="layui-btn layui-btn-xs" lay-event="edit"><i class="layui-icon layui-icon-edit"></i>编辑</a>
    <a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="delete"><i class="layui-icon layui-icon-delete"></i>删除</a>
</script>

<!--js逻辑-->
<script>
    layui.use(['form', 'table', 'spLayer', 'spTable'], function () {
        var form = layui.form,
            table = layui.table,
            spLayer = layui.spLayer,
            spTable = layui.spTable;

        // 初始化BOM类型下拉框
        spUtil.ajax({
            url: '${request.contextPath}/basedata/dict/list/bom_type',
            async: false, type: 'GET', serializable: false,
            success: function (data) {
                $.each(data.data, function (index, item) {
                    $('#js-bomType').append(new Option(item.name, item.value));
                });
            }
        });
        form.render('select', 'js-q-form-filter');

        var tableIns = spTable.render({
            url: '${request.contextPath}/technology/bom/page',
            cols: [[
                {type: 'checkbox'},
                {field: 'bomCode', title: 'BOM编号'},
                {field: 'materielCode', title: '物料编号'},
                {field: 'materielDesc', title: '物料名称'},
                {field: 'bomType', title: 'BOM类型', templet: function (d) {
                    return d.bomType === 'product' ? '产品BOM' : (d.bomType === 'process' ? '工艺BOM' : d.bomType);
                }},
                {field: 'versionNumber', title: '版本号'},
                {field: 'state', title: '审核状态', templet: function (d) {
                    return d.state === 'pass' ? '<span style="color:#5FB878;">已定版</span>' : (d.state === 'creat' ? '<span style="color:#FFB800;">创建</span>' : d.state);
                }},
                {field: 'factory', title: '所属工厂'},
                {field: 'remark', title: '备注'},
                {field: 'deleted', title: '状态', templet: function (d) {
                    return spConfig.isDeletedDict[d.deleted];
                }},
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
                        spUtil.ajax({
                            url: '${request.contextPath}/technology/bom/batch-delete',
                            type: 'POST', showLoading: true, serializable: false,
                            data: {ids: ids.join(',')},
                            success: function () { tableIns.reload(); layer.close(index); }
                        });
                    });
                } else { layer.msg("请先选择需要删除的数据！"); }
            }
            if (obj.event === 'add') {
                spLayer.open({ title: '添加', area: ['80%', '90%'], content: '${request.contextPath}/technology/bom/add-or-update-ui' });
            }
        });

        table.on('tool(js-record-table-filter)', function (obj) {
            var data = obj.data;
            if (obj.event === 'bomItems') {
                spLayer.open({ title: 'BOM子项 - ' + data.bomCode, area: ['90%', '90%'], spWhere: {bomHeadId: data.id}, content: '${request.contextPath}/technology/bomItem/list-ui' });
            }
            if (obj.event === 'lock') {
                layer.confirm('确认定版此BOM？定版后不可编辑', function (index) {
                    spUtil.ajax({
                        url: '${request.contextPath}/technology/bom/lock', type: 'POST', serializable: false,
                        data: {id: data.id},
                        success: function () { tableIns.reload(); layer.close(index); }
                    });
                });
            }
            if (obj.event === 'unlock') {
                layer.confirm('确认取消定版？', function (index) {
                    spUtil.ajax({
                        url: '${request.contextPath}/technology/bom/unlock', type: 'POST', serializable: false,
                        data: {id: data.id},
                        success: function () { tableIns.reload(); layer.close(index); }
                    });
                });
            }
            if (obj.event === 'edit') {
                spLayer.open({ title: '编辑', area: ['80%', '90%'], spWhere: {id: data.id}, content: '${request.contextPath}/technology/bom/add-or-update-ui' });
            }
            if (obj.event === 'delete') {
                layer.confirm('确认要删除吗？', function (index) {
                    spUtil.ajax({
                        url: '${request.contextPath}/technology/bom/delete', type: 'POST', serializable: false,
                        data: {id: data.id},
                        success: function () { tableIns.reload(); layer.close(index); }
                    });
                });
            }
        });
    });
</script>
</body>
</html>
