package com.wangziyang.mes.basedata.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.wangziyang.mes.basedata.entity.SpEquipment;
import com.wangziyang.mes.basedata.entity.SpTableManager;
import com.wangziyang.mes.basedata.request.SpEquipmentReq;
import com.wangziyang.mes.basedata.service.ISpEquipmentService;
import com.wangziyang.mes.common.BaseController;
import com.wangziyang.mes.common.Result;
import io.swagger.annotations.ApiImplicitParam;
import io.swagger.annotations.ApiImplicitParams;
import io.swagger.annotations.ApiOperation;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 * <p>
 * 设备控制器
 * </p>
 *
 * @author WangZiYang
 * @since 2020-03-19
 */
@Controller
@RequestMapping("/basedata/equipment")
public class SpEquipmentController extends BaseController {

    @Autowired
    private ISpEquipmentService iSpEquipmentService;

    /**
     * 设备管理界面
     */
    @ApiOperation("设备管理界面UI")
    @ApiImplicitParams({@ApiImplicitParam(name = "model", value = "模型", defaultValue = "模型")})
    @GetMapping("/list-ui")
    public String listUI(Model model) {
        return "basedata/equipment/list";
    }

    /**
     * 设备管理修改界面
     */
    @ApiOperation("设备管理修改界面")
    @GetMapping("/add-or-update-ui")
    public String addOrUpdateUI(Model model, SpTableManager record) {
        if (StringUtils.isNotEmpty(record.getId())) {
            SpEquipment spEquipment = iSpEquipmentService.getById(record.getId());
            model.addAttribute("result", spEquipment);
        }
        return "basedata/equipment/addOrUpdate";
    }

    /**
     * 设备管理界面分页查询
     */
    @ApiOperation("设备管理界面分页查询")
    @ApiImplicitParams({@ApiImplicitParam(name = "req", value = "请求参数", defaultValue = "请求参数")})
    @PostMapping("/page")
    @ResponseBody
    public Result page(SpEquipmentReq req) {
        QueryWrapper queryWrapper = new QueryWrapper();
        if (StringUtils.isNotEmpty(req.getCodeLike())) {
            queryWrapper.like("code", req.getCodeLike());
        }
        if (StringUtils.isNotEmpty(req.getNameLike())) {
            queryWrapper.like("name", req.getNameLike());
        }
        IPage result = iSpEquipmentService.page(req, queryWrapper);
        return Result.success(result);
    }

    /**
     * 设备管理修改、新增
     */
    @ApiOperation("设备管理修改、新增")
    @PostMapping("/add-or-update")
    @ResponseBody
    public Result addOrUpdate(SpEquipment record) {
        iSpEquipmentService.saveOrUpdate(record);
        return Result.success();
    }

    /**
     * 删除设备信息
     */
    @ApiOperation("删除设备信息")
    @ApiImplicitParams({@ApiImplicitParam(name = "req", value = "设备实体", defaultValue = "设备实体")})
    @PostMapping("/delete")
    @ResponseBody
    public Result deleteByTableNameId(SpEquipment req) throws Exception {
        iSpEquipmentService.removeById(req.getId());
        return Result.success();
    }
}
