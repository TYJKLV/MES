<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>添加部门</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=0">
    <#include "${request.contextPath}/common/common.ftl">
</head>
<body>
<div class="splayui-container">
    <div class="splayui-main">
        <form class="layui-form splayui-form">
            <div class="layui-row">
                <div class="layui-col-xs6 layui-col-sm6 layui-col-md6">
                    <div class="layui-form-item">
                        <label for="js-name" class="layui-form-label sp-required">部门名称</label>
                        <div class="layui-input-inline">
                            <input type="text" id="js-name" name="name" lay-verify="required" autocomplete="off" class="layui-input" value="${(department.name)!}">
                        </div>
                    </div>

                    <div class="layui-form-item">
                        <label for="js-parent-id" class="layui-form-label sp-required">父部门</label>
                        <div class="layui-input-inline">
                            <select id="js-parent-id" name="parentId" lay-verify="" lay-search="">
                                <option value="0">顶级部门</option>
                                <#if deptList??>
                                    <#list deptList as dept>
                                        <option value="${dept.id}" <#if (department.parentId)?? && department.parentId == dept.id>selected</#if>>${dept.name}</option>
                                    </#list>
                                </#if>
                            </select>
                        </div>
                    </div>

                    <div class="layui-form-item">
                        <label for="js-sort-num" class="layui-form-label sp-required">排序号</label>
                        <div class="layui-input-inline">
                            <input type="number" id="js-sort-num" name="sortNum" lay-verify="required" autocomplete="off" class="layui-input" value="${(department.sortNum)!0}">
                        </div>
                    </div>

                    <div class="layui-form-item">
                        <label for="js-is-deleted" class="layui-form-label sp-required">状态</label>
                        <div class="layui-input-block" id="js-is-deleted">
                            <input type="radio" name="isDeleted" value="0" title="正常" <#if !(department??) || department.isDeleted == "0">checked</#if>>
                            <input type="radio" name="isDeleted" value="2" title="已禁用" <#if (department.isDeleted)?? && department.isDeleted == "2">checked</#if>>
                            <input type="radio" name="isDeleted" value="1" title="已删除" <#if (department.isDeleted)?? && department.isDeleted == "1">checked</#if>>
                        </div>
                    </div>
                </div>

                <div class="layui-form-item layui-hide">
                    <div class="layui-input-block">
                        <input id="js-id" name="id" value="${(department.id)!}"/>
                        <button id="js-submit" class="layui-btn" lay-submit lay-filter="js-submit-filter">确定</button>
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

        //监听提交
        form.on('submit(js-submit-filter)', function (data) {
            spUtil.submitForm({
                url: "${request.contextPath}/admin/sys/department/add-or-update",
                data: data.field
            });

            return false;
        });
    });
</script>
</body>
</html>
