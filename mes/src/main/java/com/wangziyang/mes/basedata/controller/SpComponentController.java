package com.wangziyang.mes.basedata.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.wangziyang.mes.basedata.entity.SpComponent;
import com.wangziyang.mes.basedata.entity.SpMaterile;
import com.wangziyang.mes.basedata.entity.SpTableManager;
import com.wangziyang.mes.basedata.request.SpComponentReq;
import com.wangziyang.mes.basedata.service.ISpComponentService;
import com.wangziyang.mes.basedata.service.ISpMaterileService;
import com.wangziyang.mes.common.BaseController;
import com.wangziyang.mes.common.Result;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/basedata/component")
public class SpComponentController extends BaseController {

    @Autowired
    private ISpComponentService spComponentService;
    @Autowired
    private ISpMaterileService spMaterileService;

    @GetMapping("/list-ui")
    public String listUI(Model model) {
        return "basedata/component/list";
    }

    @GetMapping("/add-or-update-ui")
    public String addOrUpdateUI(Model model, SpTableManager record) {
        if (StringUtils.isNotEmpty(record.getId())) {
            model.addAttribute("result", spComponentService.getById(record.getId()));
        }
        return "basedata/component/addOrUpdate";
    }

    @PostMapping("/page")
    @ResponseBody
    public Result page(SpComponentReq req) {
        QueryWrapper<SpComponent> qw = new QueryWrapper<>();
        if (StringUtils.isNotEmpty(req.getCodeLike())) {
            qw.like("code", req.getCodeLike());
        }
        if (StringUtils.isNotEmpty(req.getNameLike())) {
            qw.like("name", req.getNameLike());
        }
        qw.orderByDesc("update_time");
        IPage result = spComponentService.page(req, qw);
        return Result.success(result);
    }

    @PostMapping("/add-or-update")
    @ResponseBody
    public Result addOrUpdate(SpComponent record) {
        spComponentService.saveOrUpdate(record);
        return Result.success();
    }

    @PostMapping("/delete")
    @ResponseBody
    public Result delete(SpComponent record) {
        spComponentService.removeById(record.getId());
        return Result.success();
    }

    @PostMapping("/batch-delete")
    @ResponseBody
    public Result batchDelete(String ids) {
        if (StringUtils.isEmpty(ids)) {
            return Result.failure("请选择要删除的记录");
        }
        for (String id : ids.split(",")) {
            spComponentService.removeById(id.trim());
        }
        return Result.success();
    }

    /** 物料列表（下拉框用） */
    @GetMapping("/materiel-list")
    @ResponseBody
    public Result materielList() {
        QueryWrapper<SpMaterile> qw = new QueryWrapper<>();
        qw.eq("is_deleted", "0");  // sp_materile 实际数据用 '0' 表示正常
        qw.select("id", "materiel", "materiel_desc");
        List<SpMaterile> list = spMaterileService.list(qw);
        return Result.success(list);
    }
}
