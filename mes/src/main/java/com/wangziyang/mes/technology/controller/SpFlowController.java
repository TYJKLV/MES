package com.wangziyang.mes.technology.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.wangziyang.mes.common.BaseController;
import com.wangziyang.mes.common.Result;
import com.wangziyang.mes.technology.entity.SpBom;
import com.wangziyang.mes.technology.entity.SpFlow;
import com.wangziyang.mes.technology.entity.SpFlowBomRel;
import com.wangziyang.mes.technology.request.SpFlowReq;
import com.wangziyang.mes.technology.service.ISpBomService;
import com.wangziyang.mes.technology.service.ISpFlowBomRelService;
import com.wangziyang.mes.technology.service.ISpFlowService;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/technology/flow")
public class SpFlowController extends BaseController {

    @Autowired
    public ISpFlowService iSpFlowService;
    @Autowired
    private ISpFlowBomRelService spFlowBomRelService;
    @Autowired
    private ISpBomService spBomService;

    @GetMapping("/list-ui")
    public String listUI(Model model) {
        return "technology/flow/list";
    }

    @GetMapping("/add-or-update-ui")
    public String addOrUpdateUI(Model model, @RequestParam(required = false) String id) {
        if (StringUtils.isNotEmpty(id)) {
            model.addAttribute("result", iSpFlowService.getById(id));
        }
        return "technology/flow/addOrUpdate";
    }

    @PostMapping("/page")
    @ResponseBody
    public Result page(SpFlowReq req) {
        QueryWrapper<SpFlow> qw = new QueryWrapper<>();
        if (StringUtils.isNotEmpty(req.getFlowLike())) {
            qw.like("flow", req.getFlowLike());
        }
        qw.orderByDesc("update_time");
        IPage result = iSpFlowService.page(req, qw);
        return Result.success(result);
    }

    @GetMapping("/list-all")
    @ResponseBody
    public Result listAll() {
        QueryWrapper<SpFlow> qw = new QueryWrapper<>();
        qw.eq("is_deleted", "0");
        qw.select("id", "flow", "flow_desc");
        List<SpFlow> list = iSpFlowService.list(qw);
        return Result.success(list);
    }

    @PostMapping("/add-or-update")
    @ResponseBody
    public Result addOrUpdate(SpFlow record) {
        if (StringUtils.isNotEmpty(record.getId())) {
            SpFlow existing = iSpFlowService.getById(record.getId());
            if (existing != null && "pass".equals(existing.getState())) {
                return Result.failure("该工艺路线已定版，不可编辑。如需修改请先取消定版状态");
            }
        }
        iSpFlowService.saveOrUpdate(record);
        return Result.success();
    }

    @PostMapping("/delete")
    @ResponseBody
    public Result delete(SpFlow record) {
        iSpFlowService.removeById(record.getId());
        return Result.success();
    }

    @PostMapping("/batch-delete")
    @ResponseBody
    public Result batchDelete(String ids) {
        if (StringUtils.isEmpty(ids)) return Result.failure("请选择要删除的记录");
        for (String id : ids.split(",")) {
            iSpFlowService.removeById(id.trim());
        }
        return Result.success();
    }

    @PostMapping("/lock")
    @ResponseBody
    public Result lock(SpFlow record) {
        SpFlow existing = iSpFlowService.getById(record.getId());
        if (existing == null) return Result.failure("工艺路线不存在");
        existing.setState("pass");
        iSpFlowService.updateById(existing);
        return Result.success();
    }

    @PostMapping("/unlock")
    @ResponseBody
    public Result unlock(SpFlow record) {
        SpFlow existing = iSpFlowService.getById(record.getId());
        if (existing == null) return Result.failure("工艺路线不存在");
        existing.setState("creat");
        iSpFlowService.updateById(existing);
        return Result.success();
    }

    /** BOM绑定页面 */
    @GetMapping("/bom-ui")
    public String bomUI(Model model, @RequestParam String flowId) {
        SpFlow flow = iSpFlowService.getById(flowId);
        model.addAttribute("flow", flow);
        return "technology/flow/flowBom";
    }

    /** 获取流程已绑定BOM ID列表 */
    @GetMapping("/bom-ids/{flowId}")
    @ResponseBody
    public Result bomIds(@PathVariable String flowId) {
        return Result.success(spFlowBomRelService.listBomIdsByFlowId(flowId));
    }

    /** BOM列表（下拉/勾选用） */
    @GetMapping("/bom-list")
    @ResponseBody
    public Result bomList() {
        QueryWrapper<SpBom> qw = new QueryWrapper<>();
        qw.eq("is_deleted", "0");
        qw.select("id", "bom_code", "materiel_desc");
        List<SpBom> list = spBomService.list(qw);
        return Result.success(list);
    }

    /** 保存流程-BOM绑定 */
    @PostMapping("/assign-boms")
    @ResponseBody
    public Result assignBoms(@RequestParam String flowId, @RequestParam(required = false) String bomIds) {
        List<String> idList = null;
        if (StringUtils.isNotEmpty(bomIds)) {
            idList = java.util.Arrays.asList(bomIds.split(","));
        }
        spFlowBomRelService.saveFlowBoms(flowId, idList);
        return Result.success();
    }
}
