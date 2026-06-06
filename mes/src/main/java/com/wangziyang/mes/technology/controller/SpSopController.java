package com.wangziyang.mes.technology.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.wangziyang.mes.common.BaseController;
import com.wangziyang.mes.common.Result;
import com.wangziyang.mes.technology.entity.*;
import com.wangziyang.mes.technology.request.SpSopReq;
import com.wangziyang.mes.technology.service.ISpBomService;
import com.wangziyang.mes.technology.service.ISpOperService;
import com.wangziyang.mes.technology.service.ISpSopContentService;
import com.wangziyang.mes.technology.service.ISpSopService;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/technology/sop")
public class SpSopController extends BaseController {

    @Autowired
    private ISpSopService spSopService;
    @Autowired
    private ISpSopContentService spSopContentService;
    @Autowired
    private ISpOperService spOperService;
    @Autowired
    private ISpBomService spBomService;

    @GetMapping("/list-ui")
    public String listUI() {
        return "technology/sop/list";
    }

    @GetMapping("/add-or-update-ui")
    public String addOrUpdateUI(Model model, @RequestParam(required = false) String id) {
        if (StringUtils.isNotEmpty(id)) {
            model.addAttribute("result", spSopService.getById(id));
        }
        return "technology/sop/addOrUpdate";
    }

    @PostMapping("/page")
    @ResponseBody
    public Result page(SpSopReq req) {
        QueryWrapper<SpSop> qw = new QueryWrapper<>();
        if (StringUtils.isNotEmpty(req.getCodeLike())) qw.like("code", req.getCodeLike());
        if (StringUtils.isNotEmpty(req.getNameLike())) qw.like("name", req.getNameLike());
        qw.orderByDesc("update_time");
        return Result.success(spSopService.page(req, qw));
    }

    @PostMapping("/add-or-update")
    @ResponseBody
    public Result addOrUpdate(SpSop record) {
        spSopService.saveOrUpdate(record);
        return Result.success();
    }

    @PostMapping("/delete")
    @ResponseBody
    public Result delete(SpSop record) {
        spSopService.removeById(record.getId());
        return Result.success();
    }

    @PostMapping("/batch-delete")
    @ResponseBody
    public Result batchDelete(String ids) {
        if (StringUtils.isEmpty(ids)) return Result.failure("请选择要删除的记录");
        for (String id : ids.split(",")) spSopService.removeById(id.trim());
        return Result.success();
    }

    /** SOP内容编辑页面 */
    @GetMapping("/content-ui")
    public String contentUI(Model model, @RequestParam String sopId) {
        SpSop sop = spSopService.getById(sopId);
        model.addAttribute("sop", sop);
        QueryWrapper<SpSopContent> qw = new QueryWrapper<>();
        qw.eq("sop_id", sopId);
        SpSopContent content = spSopContentService.getOne(qw);
        model.addAttribute("content", content);
        return "technology/sop/content";
    }

    /** SOP内容预览（只读） */
    @GetMapping("/preview-ui")
    public String previewUI(Model model, @RequestParam String sopId) {
        SpSop sop = spSopService.getById(sopId);
        model.addAttribute("sop", sop);
        QueryWrapper<SpSopContent> qw = new QueryWrapper<>();
        qw.eq("sop_id", sopId);
        SpSopContent content = spSopContentService.getOne(qw);
        model.addAttribute("content", content);
        return "technology/sop/preview";
    }

    /** 保存SOP内容 */
    @PostMapping("/save-content")
    @ResponseBody
    public Result saveContent(SpSopContent record) {
        QueryWrapper<SpSopContent> qw = new QueryWrapper<>();
        qw.eq("sop_id", record.getSopId());
        SpSopContent existing = spSopContentService.getOne(qw);
        if (existing != null) {
            record.setId(existing.getId());
        }
        spSopContentService.saveOrUpdate(record);
        return Result.success();
    }

    /** 提交审核 */
    @PostMapping("/submit-review")
    @ResponseBody
    public Result submitReview(SpSop record) {
        SpSop existing = spSopService.getById(record.getId());
        if (existing == null) return Result.failure("SOP不存在");
        if (!"draft".equals(existing.getState())) return Result.failure("仅草稿状态可提交审核");
        existing.setState("review");
        spSopService.updateById(existing);
        return Result.success();
    }

    /** 发布 */
    @PostMapping("/publish")
    @ResponseBody
    public Result publish(SpSop record) {
        SpSop existing = spSopService.getById(record.getId());
        if (existing == null) return Result.failure("SOP不存在");
        existing.setState("pass");
        spSopService.updateById(existing);
        return Result.success();
    }

    /** 工序列表（下拉框） */
    @GetMapping("/oper-list")
    @ResponseBody
    public Result operList() {
        QueryWrapper<SpOper> qw = new QueryWrapper<>();
        qw.eq("is_deleted", "0");
        qw.select("id", "oper_code", "oper");
        return Result.success(spOperService.list(qw));
    }

    /** BOM列表（下拉框） */
    @GetMapping("/bom-list")
    @ResponseBody
    public Result bomList() {
        QueryWrapper<SpBom> qw = new QueryWrapper<>();
        qw.eq("is_deleted", "0");
        qw.select("id", "bom_code", "materiel_desc");
        return Result.success(spBomService.list(qw));
    }
}
