package com.wangziyang.mes.basedata.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.wangziyang.mes.basedata.entity.SpEquipment;
import com.wangziyang.mes.basedata.entity.SpEquipmentGroup;
import com.wangziyang.mes.basedata.entity.SpTableManager;
import com.wangziyang.mes.basedata.request.SpEquipmentGroupReq;
import com.wangziyang.mes.basedata.service.ISpEquipmentGroupRelService;
import com.wangziyang.mes.basedata.service.ISpEquipmentGroupService;
import com.wangziyang.mes.basedata.service.ISpEquipmentService;
import com.wangziyang.mes.common.BaseController;
import com.wangziyang.mes.common.Result;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/basedata/equipmentGroup")
public class SpEquipmentGroupController extends BaseController {

    @Autowired
    private ISpEquipmentGroupService spEquipmentGroupService;
    @Autowired
    private ISpEquipmentGroupRelService spEquipmentGroupRelService;
    @Autowired
    private ISpEquipmentService spEquipmentService;

    @GetMapping("/list-ui")
    public String listUI(Model model) {
        return "basedata/equipmentGroup/list";
    }

    @GetMapping("/add-or-update-ui")
    public String addOrUpdateUI(Model model, SpTableManager record) {
        if (StringUtils.isNotEmpty(record.getId())) {
            model.addAttribute("result", spEquipmentGroupService.getById(record.getId()));
        }
        return "basedata/equipmentGroup/addOrUpdate";
    }

    @PostMapping("/page")
    @ResponseBody
    public Result page(SpEquipmentGroupReq req) {
        QueryWrapper<SpEquipmentGroup> qw = new QueryWrapper<>();
        if (StringUtils.isNotEmpty(req.getCodeLike())) {
            qw.like("code", req.getCodeLike());
        }
        if (StringUtils.isNotEmpty(req.getNameLike())) {
            qw.like("name", req.getNameLike());
        }
        qw.orderByDesc("update_time");
        IPage result = spEquipmentGroupService.page(req, qw);
        return Result.success(result);
    }

    @PostMapping("/add-or-update")
    @ResponseBody
    public Result addOrUpdate(SpEquipmentGroup record) {
        spEquipmentGroupService.saveOrUpdate(record);
        return Result.success();
    }

    @PostMapping("/delete")
    @ResponseBody
    public Result delete(SpEquipmentGroup record) {
        spEquipmentGroupService.removeById(record.getId());
        return Result.success();
    }

    @PostMapping("/batch-delete")
    @ResponseBody
    public Result batchDelete(String ids) {
        if (StringUtils.isEmpty(ids)) {
            return Result.failure("请选择要删除的记录");
        }
        for (String id : ids.split(",")) {
            spEquipmentGroupService.removeById(id.trim());
        }
        return Result.success();
    }

    /** 设备列表（下拉框用） */
    @GetMapping("/equipment-list")
    @ResponseBody
    public Result equipmentList() {
        QueryWrapper<SpEquipment> qw = new QueryWrapper<>();
        qw.eq("is_deleted", "0");  // sp_equipment 表用 '0' 表示正常（与老表 '01' 不同）
        qw.select("id", "code", "name");
        List<SpEquipment> list = spEquipmentService.list(qw);
        return Result.success(list);
    }

    /** 设备编组分配页面 */
    @GetMapping("/group-equipment-ui")
    public String groupEquipmentUI(Model model, @RequestParam String groupId) {
        SpEquipmentGroup group = spEquipmentGroupService.getById(groupId);
        model.addAttribute("group", group);
        return "basedata/equipmentGroup/groupEquipment";
    }

    /** 获取编组已绑定设备ID列表 */
    @GetMapping("/equipment-ids/{groupId}")
    @ResponseBody
    public Result equipmentIds(@PathVariable String groupId) {
        return Result.success(spEquipmentGroupRelService.listEquipmentIdsByGroupId(groupId));
    }

    /** 保存编组-设备绑定 */
    @PostMapping("/assign-equipments")
    @ResponseBody
    public Result assignEquipments(@RequestParam String groupId, @RequestParam(required = false) String equipmentIds) {
        List<String> idList = null;
        if (StringUtils.isNotEmpty(equipmentIds)) {
            idList = java.util.Arrays.asList(equipmentIds.split(","));
        }
        spEquipmentGroupRelService.saveGroupEquipments(groupId, idList);
        return Result.success();
    }
}
