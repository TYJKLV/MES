package com.wangziyang.mes.technology.controller;


import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.wangziyang.mes.common.BaseController;
import com.wangziyang.mes.common.Result;
import com.wangziyang.mes.technology.entity.SpBom;
import com.wangziyang.mes.technology.request.SpBomReq;
import com.wangziyang.mes.technology.service.ISpBomService;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequestMapping("/technology/bom")
public class SpBomController extends BaseController {

    @Autowired
    private ISpBomService iSpBomService;

    @GetMapping("/list-ui")
    public String listUI(Model model) {
        return "technology/bom/list";
    }

    @GetMapping("/add-or-update-ui")
    public String addOrUpdateUI(Model model, SpBom spBom) throws Exception {
        if (StringUtils.isNotEmpty(spBom.getId())) {
            SpBom result = iSpBomService.getById(spBom.getId());
            model.addAttribute("result", result);
        }
        return "technology/bom/addOrUpdate";
    }

    @PostMapping("/page")
    @ResponseBody
    public Result page(SpBomReq req) {
        QueryWrapper<SpBom> qw = new QueryWrapper<>();
        if (StringUtils.isNotEmpty(req.getMaterielCodeLike())) {
            qw.likeRight("materiel_code", req.getMaterielCodeLike());
        }
        if (StringUtils.isNotEmpty(req.getBomType())) {
            qw.eq("bom_type", req.getBomType());
        }
        qw.orderByDesc("update_time");
        IPage result = iSpBomService.page(req, qw);
        return Result.success(result);
    }

    @PostMapping("/add-or-update")
    @ResponseBody
    public Result addOrUpdate(SpBom spBom) {
        // 版本锁定：已定版的BOM不可编辑
        if (StringUtils.isNotEmpty(spBom.getId())) {
            SpBom existing = iSpBomService.getById(spBom.getId());
            if (existing != null && "pass".equals(existing.getState())) {
                return Result.failure("该BOM已定版，不可编辑。如需修改请先取消定版状态");
            }
        }
        iSpBomService.saveOrUpdate(spBom);
        return Result.success();
    }

    @PostMapping("/delete")
    @ResponseBody
    public Result deleteByTableNameId(SpBom spBom) throws Exception {
        iSpBomService.removeById(spBom.getId());
        return Result.success();
    }

    @PostMapping("/batch-delete")
    @ResponseBody
    public Result batchDelete(String ids) {
        if (StringUtils.isEmpty(ids)) {
            return Result.failure("请选择要删除的记录");
        }
        for (String id : ids.split(",")) {
            iSpBomService.removeById(id.trim());
        }
        return Result.success();
    }

    /** 锁定/定版 BOM */
    @PostMapping("/lock")
    @ResponseBody
    public Result lock(SpBom spBom) {
        SpBom existing = iSpBomService.getById(spBom.getId());
        if (existing == null) {
            return Result.failure("BOM不存在");
        }
        existing.setState("pass");
        iSpBomService.updateById(existing);
        return Result.success();
    }

    /** 取消定版 */
    @PostMapping("/unlock")
    @ResponseBody
    public Result unlock(SpBom spBom) {
        SpBom existing = iSpBomService.getById(spBom.getId());
        if (existing == null) {
            return Result.failure("BOM不存在");
        }
        existing.setState("creat");
        iSpBomService.updateById(existing);
        return Result.success();
    }
}
