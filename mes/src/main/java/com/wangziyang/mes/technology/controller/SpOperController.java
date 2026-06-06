package com.wangziyang.mes.technology.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.wangziyang.mes.basedata.entity.SpWorkcell;
import com.wangziyang.mes.basedata.service.ISpWorkcellService;
import com.wangziyang.mes.common.BaseController;
import com.wangziyang.mes.common.Result;
import com.wangziyang.mes.technology.entity.SpOper;
import com.wangziyang.mes.technology.request.SpOperReq;
import com.wangziyang.mes.technology.service.ISpOperService;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/technology/oper")
public class SpOperController extends BaseController {

    @Autowired
    private ISpOperService spOperService;
    @Autowired
    private ISpWorkcellService spWorkcellService;

    @GetMapping("/list-ui")
    public String listUI(Model model) {
        return "technology/oper/list";
    }

    @GetMapping("/add-or-update-ui")
    public String addOrUpdateUI(Model model, @RequestParam(required = false) String id) {
        if (StringUtils.isNotEmpty(id)) {
            model.addAttribute("result", spOperService.getById(id));
        }
        return "technology/oper/addOrUpdate";
    }

    @PostMapping("/page")
    @ResponseBody
    public Result page(SpOperReq req) {
        QueryWrapper<SpOper> qw = new QueryWrapper<>();
        if (StringUtils.isNotEmpty(req.getOperCodeLike())) {
            qw.like("oper_code", req.getOperCodeLike());
        }
        if (StringUtils.isNotEmpty(req.getOperLike())) {
            qw.like("oper", req.getOperLike());
        }
        qw.orderByDesc("update_time");
        IPage result = spOperService.page(req, qw);
        return Result.success(result);
    }

    @PostMapping("/add-or-update")
    @ResponseBody
    public Result addOrUpdate(SpOper record) {
        spOperService.saveOrUpdate(record);
        return Result.success();
    }

    @PostMapping("/delete")
    @ResponseBody
    public Result delete(SpOper record) {
        spOperService.removeById(record.getId());
        return Result.success();
    }

    @PostMapping("/batch-delete")
    @ResponseBody
    public Result batchDelete(String ids) {
        if (StringUtils.isEmpty(ids)) {
            return Result.failure("请选择要删除的记录");
        }
        for (String id : ids.split(",")) {
            spOperService.removeById(id.trim());
        }
        return Result.success();
    }

    /** 加工单元列表（下拉框用） */
    @GetMapping("/workcell-list")
    @ResponseBody
    public Result workcellList() {
        QueryWrapper<SpWorkcell> qw = new QueryWrapper<>();
        qw.eq("is_deleted", "0");
        qw.select("id", "code", "name");
        List<SpWorkcell> list = spWorkcellService.list(qw);
        return Result.success(list);
    }
}
