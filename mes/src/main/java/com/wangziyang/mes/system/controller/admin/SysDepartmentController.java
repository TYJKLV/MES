package com.wangziyang.mes.system.controller.admin;


import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.wangziyang.mes.common.BaseController;
import com.wangziyang.mes.common.Result;
import com.wangziyang.mes.system.entity.SysDepartment;
import com.wangziyang.mes.system.request.SysDepartmentPageReq;
import com.wangziyang.mes.system.service.ISysDepartmentService;
import io.swagger.annotations.ApiImplicitParam;
import io.swagger.annotations.ApiImplicitParams;
import io.swagger.annotations.ApiOperation;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.Arrays;
import java.util.Collection;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * <p>
 * 系统部门前端控制器
 * </p>
 *
 * @author SongPeng
 * @since 2020-03-03
 */
@Controller
@RequestMapping("/admin/sys/department")
public class SysDepartmentController extends BaseController {

    Logger logger = LoggerFactory.getLogger(SysDepartmentController.class);

    @Autowired
    private ISysDepartmentService sysDepartmentService;

    @ApiOperation("系统部门信息列表UI")
    @GetMapping("/list-ui")
    public String listUI(Model model) {
        return "admin/system/department/list";
    }

    @ApiOperation("系统部门信息分页列表")
    @PostMapping("/page")
    @ResponseBody
    public Result page(SysDepartmentPageReq req) {
        QueryWrapper<SysDepartment> qw = new QueryWrapper<>();
        if (StringUtils.isNotEmpty(req.getNameLike())) {
            qw.like("name", req.getNameLike());
        }
        qw.orderByAsc("sort_num");
        IPage<SysDepartment> result = sysDepartmentService.page(req, qw);

        // 解析父部门名称
        if (result.getRecords() != null && !result.getRecords().isEmpty()) {
            List<String> parentIds = result.getRecords().stream()
                    .map(SysDepartment::getParentId)
                    .filter(id -> !"0".equals(id))
                    .distinct()
                    .collect(Collectors.toList());
            if (!parentIds.isEmpty()) {
                Collection<SysDepartment> parents = sysDepartmentService.listByIds(parentIds);
                Map<String, String> nameMap = parents.stream()
                        .collect(Collectors.toMap(SysDepartment::getId, SysDepartment::getName));
                for (SysDepartment dept : result.getRecords()) {
                    if (!"0".equals(dept.getParentId())) {
                        dept.setParentName(nameMap.getOrDefault(dept.getParentId(), dept.getParentId()));
                    } else {
                        dept.setParentName("顶级部门");
                    }
                }
            }
        }

        return Result.success(result);
    }

    @GetMapping("/add-or-update-ui")
    public String addOrUpdateUI(Model model, SysDepartment record) {
        if (StringUtils.isNotEmpty(record.getId())) {
            SysDepartment sysDepartment = sysDepartmentService.getById(record.getId());
            model.addAttribute("department", sysDepartment);
        }
        // 父部门下拉列表（排除已删除的）
        QueryWrapper<SysDepartment> qw = new QueryWrapper<>();
        qw.eq("is_deleted", "0");
        qw.orderByAsc("sort_num");
        List<SysDepartment> deptList = sysDepartmentService.list(qw);
        model.addAttribute("deptList", deptList);
        return "admin/system/department/addOrUpdate";
    }

    @PostMapping("/add-or-update")
    @ResponseBody
    public Result addOrUpdate(SysDepartment record) {
        // 新记录默认值
        if (StringUtils.isEmpty(record.getParentId())) {
            record.setParentId("0");
        }
        if (record.getSortNum() == null) {
            record.setSortNum(0);
        }
        if (StringUtils.isEmpty(record.getIsDeleted())) {
            record.setIsDeleted("0");
        }
        sysDepartmentService.saveOrUpdate(record);
        return Result.success(record.getId());
    }

    @ApiOperation("获取所有部门列表（父部门下拉框用）")
    @GetMapping("/list-all")
    @ResponseBody
    public Result listAll() {
        QueryWrapper<SysDepartment> qw = new QueryWrapper<>();
        qw.eq("is_deleted", "0");
        qw.orderByAsc("sort_num");
        List<SysDepartment> list = sysDepartmentService.list(qw);
        return Result.success(list);
    }

    @ApiOperation("删除部门")
    @PostMapping("/delete")
    @ResponseBody
    public Result delete(SysDepartment record) {
        sysDepartmentService.removeById(record.getId());
        return Result.success();
    }

    @ApiOperation("批量删除部门")
    @PostMapping("/batch-delete")
    @ResponseBody
    public Result batchDelete(String ids) {
        if (StringUtils.isNotEmpty(ids)) {
            String[] idArray = ids.split(",");
            sysDepartmentService.removeByIds(Arrays.asList(idArray));
        }
        return Result.success();
    }
}
