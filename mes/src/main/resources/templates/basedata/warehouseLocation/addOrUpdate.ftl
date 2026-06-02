<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>添加库位</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport"
          content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=0">
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
                        <label for="js-code" class="layui-form-label sp-required">库位编码
                        </label>
                        <div class="layui-input-inline">
                            <input type="text" id="js-code" name="code" lay-verify="required" autocomplete="off"
                                   class="layui-input" value="${result.code}">
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label for="js-warehouseId" class="layui-form-label sp-required">所属库房
                        </label>
                        <div class="layui-input-inline">
                            <select id="js-warehouseId" name="warehouseId" lay-filter="warehouse-filter" lay-verify="required">
                            </select>
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label for="js-status" class="layui-form-label sp-required">库位状态
                        </label>
                        <div class="layui-input-inline">
                            <select id="js-status" name="status" lay-filter="status-filter" lay-verify="required">
                            </select>
                        </div>
                    </div>

                    <div class="layui-form-item">
                        <label for="js-is-deleted" class="layui-form-label sp-required">状态
                        </label>
                        <div class="layui-input-block" id="js-is-deleted" style="width: 310px;">
                            <input type="radio" name="deleted" value="0" title="正常"
                                   <#if result.deleted == "0" || !(result??)>checked</#if>>
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
                        <button id="js-submit" class="layui-btn" lay-submit lay-filter="js-submit-filter">确定
                        </button>
                    </div>
                </div>
            </div>

        </form>
    </div>
</div>
<script>
    layui.use(['form', 'util'], function () {
        var form = layui.form,
            util = layui.util;

        //初始化库房下拉框
        getWarehouseData();
        //初始化库位状态下拉框
        getStatusData();

        /**
         * 初始化库房下拉数据
         */
        function getWarehouseData() {
            spUtil.ajax({
                url: '${request.contextPath}/basedata/warehouse/listAll',
                async: false,
                type: 'GET',
                serializable: false,
                data: {},
                success: function (data) {
                    $.each(data.data, function (index, item) {
                        $('#js-warehouseId').append(new Option(item.name, item.id));
                    });
                }
            });
        }

        /**
         * 初始化库位状态数据
         */
        function getStatusData() {
            spUtil.ajax({
                url: '${request.contextPath}/basedata/dict/list/location_status',
                async: false,
                type: 'GET',
                serializable: false,
                data: {},
                success: function (data) {
                    $.each(data.data, function (index, item) {
                        $('#js-status').append(new Option(item.name, item.value));
                    });
                }
            });
        }

        //给表单赋值
        form.val("formTest", {
            "warehouseId": "${result.warehouseId}",
            "status": "${result.status}"
        });

        //监听提交
        form.on('submit(js-submit-filter)', function (data) {
            spUtil.submitForm({
                url: "${request.contextPath}/basedata/warehouseLocation/add-or-update",
                data: data.field
            });
            return false;
        });

    });
</script>
</body>
</html>
