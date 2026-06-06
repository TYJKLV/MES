<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>产品工艺查询</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <#include "${request.contextPath}/common/common.ftl">
    <style>
        .search-row { margin-bottom: 5px; }
        .result-empty { text-align: center; padding: 60px 0; color: #999; }
        .state-pass { color: #5FB878; }
        .state-creat { color: #FFB800; }
    </style>
</head>
<body>
<div class="splayui-container">
    <div class="splayui-main">
        <div class="layui-card">
            <div class="layui-card-header">产品工艺综合查询</div>
            <div class="layui-card-body">
                <form id="js-search-form" class="layui-form" lay-filter="js-q-form-filter">
                    <div class="search-row">
                        <div class="layui-inline">
                            <label class="layui-form-label">物料编码</label>
                            <div class="layui-input-inline">
                                <input type="text" name="materielLike" placeholder="模糊匹配" autocomplete="off" class="layui-input">
                            </div>
                        </div>
                        <div class="layui-inline">
                            <label class="layui-form-label">物料描述</label>
                            <div class="layui-input-inline">
                                <input type="text" name="materielDescLike" placeholder="模糊匹配" autocomplete="off" class="layui-input">
                            </div>
                        </div>
                        <div class="layui-inline">
                            <label class="layui-form-label">BOM编码</label>
                            <div class="layui-input-inline">
                                <input type="text" name="bomCodeLike" placeholder="模糊匹配" autocomplete="off" class="layui-input">
                            </div>
                        </div>
                    </div>
                    <div class="search-row">
                        <div class="layui-inline">
                            <label class="layui-form-label">工序编号</label>
                            <div class="layui-input-inline">
                                <input type="text" name="operCodeLike" placeholder="如 OP-001" autocomplete="off" class="layui-input">
                            </div>
                        </div>
                        <div class="layui-inline">
                            <label class="layui-form-label">工序名称</label>
                            <div class="layui-input-inline">
                                <input type="text" name="operLike" placeholder="如 车削" autocomplete="off" class="layui-input">
                            </div>
                        </div>
                        <div class="layui-inline">
                            <label class="layui-form-label">加工单元</label>
                            <div class="layui-input-inline">
                                <input type="text" name="workcellNameLike" placeholder="按名称模糊匹配" autocomplete="off" class="layui-input">
                            </div>
                        </div>
                    </div>
                    <div class="search-row">
                        <div class="layui-inline">
                            <a class="layui-btn" lay-submit lay-filter="js-search-filter"><i class="layui-icon layui-icon-search layuiadmin-button-btn"></i> 查询</a>
                            <button type="reset" class="layui-btn layui-btn-primary">重置</button>
                        </div>
                    </div>
                </form>
            </div>
        </div>

        <table class="layui-hide" id="js-record-table" lay-filter="js-record-table-filter"></table>
    </div>
</div>

<script type="text/html" id="js-record-table-toolbar-right">
    <a class="layui-btn layui-btn-xs layui-btn-warm" lay-event="flowDetail"><i class="layui-icon layui-icon-tree"></i>工艺路线</a>
</script>

<script>
    layui.use(['form', 'table'], function () {
        var form = layui.form, table = layui.table;

        var tableIns = table.render({
            elem: '#js-record-table',
            url: '${request.contextPath}/technology/product-process/search',
            method: 'post',
            contentType: 'application/x-www-form-urlencoded',
            page: false,
            limit: 50,
            height: 'full-280',
            cols: [[
                {field: 'flowCode', title: '工艺路线编码', width: 140},
                {field: 'flowDesc', title: '工艺路线描述', width: 180},
                {field: 'version', title: '版本', width: 80},
                {field: 'state', title: '审核状态', width: 100, templet: function (d) {
                    return d.state === 'pass' ? '<span class="state-pass">已定版</span>' : '<span class="state-creat">创建</span>';
                }},
                {field: 'operCount', title: '工序数', width: 80},
                {field: 'process', title: '流程时序', width: 250},
                {field: 'materials', title: '关联物料 (编码 - 描述)', width: 300},
                {fixed: 'right', field: 'operate', title: '操作', toolbar: '#js-record-table-toolbar-right', unresize: true, width: 110}
            ]],
            text: {none: '暂无匹配结果，请调整筛选条件后重试'}
        });

        $(function () { form.render(); });

        form.on('submit(js-search-filter)', function (data) {
            tableIns.reload({ where: data.field, page: { curr: 1 } });
            return false;
        });

        table.on('tool(js-record-table-filter)', function (obj) {
            if (obj.event === 'flowDetail') {
                var data = obj.data;
                layui.spLayer.open({
                    title: '工艺路线可视化 - ' + data.flowCode,
                    area: ['950px', '600px'],
                    spWhere: {flowId: data.flowId},
                    content: '${request.contextPath}/technology/product-process/flow-detail-ui'
                });
            }
        });
    });
</script>
</body>
</html>
