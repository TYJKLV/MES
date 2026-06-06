package com.wangziyang.mes.basedata.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.wangziyang.mes.basedata.entity.SpEquipmentGroup;
import com.wangziyang.mes.basedata.entity.SpTableManager;
import com.wangziyang.mes.basedata.entity.SpWorkcell;
import com.wangziyang.mes.basedata.request.SpWorkcellReq;
import com.wangziyang.mes.basedata.service.ISpEquipmentGroupService;
import com.wangziyang.mes.basedata.service.ISpWorkcellService;
import com.wangziyang.mes.common.BaseController;
import com.wangziyang.mes.common.Result;
import com.wangziyang.mes.system.entity.SysDepartment;
import com.wangziyang.mes.system.service.ISysDepartmentService;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/basedata/workcell")
public class SpWorkcellController extends BaseController {

    @Autowired
    private ISpWorkcellService spWorkcellService;
    @Autowired
    private ISysDepartmentService sysDepartmentService;
    @Autowired
    private ISpEquipmentGroupService spEquipmentGroupService;

    @GetMapping("/list-ui")
    public String listUI(Model model) {
        return "basedata/workcell/list";
    }

    @GetMapping("/add-or-update-ui")
    public String addOrUpdateUI(Model model, SpTableManager record) {
        if (StringUtils.isNotEmpty(record.getId())) {
            model.addAttribute("result", spWorkcellService.getById(record.getId()));
        }
        return "basedata/workcell/addOrUpdate";
    }

    @PostMapping("/page")
    @ResponseBody
    public Result page(SpWorkcellReq req) {
        QueryWrapper<SpWorkcell> qw = new QueryWrapper<>();
        if (StringUtils.isNotEmpty(req.getCodeLike())) {
            qw.like("code", req.getCodeLike());
        }
        if (StringUtils.isNotEmpty(req.getNameLike())) {
            qw.like("name", req.getNameLike());
        }
        qw.orderByDesc("update_time");
        IPage result = spWorkcellService.page(req, qw);
        return Result.success(result);
    }

    @PostMapping("/add-or-update")
    @ResponseBody
    public Result addOrUpdate(SpWorkcell record) {
        spWorkcellService.saveOrUpdate(record);
        return Result.success();
    }

    @PostMapping("/delete")
    @ResponseBody
    public Result delete(SpWorkcell record) {
        spWorkcellService.removeById(record.getId());
        return Result.success();
    }

    @PostMapping("/batch-delete")
    @ResponseBody
    public Result batchDelete(String ids) {
        if (StringUtils.isEmpty(ids)) {
            return Result.failure("请选择要删除的记录");
        }
        for (String id : ids.split(",")) {
            spWorkcellService.removeById(id.trim());
        }
        return Result.success();
    }

    /** 部门列表（车间下拉框用） */
    @GetMapping("/dept-list")
    @ResponseBody
    public Result deptList() {
        List<SysDepartment> list = sysDepartmentService.list();
        return Result.success(list);
    }

    /** 设备编组列表（编组下拉框用） */
    @GetMapping("/group-list")
    @ResponseBody
    public Result groupList() {
        QueryWrapper<SpEquipmentGroup> qw = new QueryWrapper<>();
        qw.eq("is_deleted", "0");
        qw.select("id", "code", "name");
        List<SpEquipmentGroup> list = spEquipmentGroupService.list(qw);
        return Result.success(list);
    }
}
