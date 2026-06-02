package com.wangziyang.mes.basedata.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.wangziyang.mes.basedata.entity.SpTableManager;
import com.wangziyang.mes.basedata.entity.SpWarehouseLocation;
import com.wangziyang.mes.basedata.request.SpWarehouseLocationReq;
import com.wangziyang.mes.basedata.service.ISpWarehouseLocationService;
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
 * 库位控制器
 * </p>
 *
 * @author WangZiYang
 * @since 2020-03-19
 */
@Controller
@RequestMapping("/basedata/warehouseLocation")
public class SpWarehouseLocationController extends BaseController {

    @Autowired
    private ISpWarehouseLocationService iSpWarehouseLocationService;

    /**
     * 库位管理界面
     */
    @ApiOperation("库位管理界面UI")
    @ApiImplicitParams({@ApiImplicitParam(name = "model", value = "模型", defaultValue = "模型")})
    @GetMapping("/list-ui")
    public String listUI(Model model) {
        return "basedata/warehouseLocation/list";
    }

    /**
     * 库位管理修改界面
     */
    @ApiOperation("库位管理修改界面")
    @GetMapping("/add-or-update-ui")
    public String addOrUpdateUI(Model model, SpTableManager record) {
        if (StringUtils.isNotEmpty(record.getId())) {
            SpWarehouseLocation spWarehouseLocation = iSpWarehouseLocationService.getById(record.getId());
            model.addAttribute("result", spWarehouseLocation);
        }
        return "basedata/warehouseLocation/addOrUpdate";
    }

    /**
     * 库位管理界面分页查询
     */
    @ApiOperation("库位管理界面分页查询")
    @ApiImplicitParams({@ApiImplicitParam(name = "req", value = "请求参数", defaultValue = "请求参数")})
    @PostMapping("/page")
    @ResponseBody
    public Result page(SpWarehouseLocationReq req) {
        QueryWrapper queryWrapper = new QueryWrapper();
        if (StringUtils.isNotEmpty(req.getCodeLike())) {
            queryWrapper.like("code", req.getCodeLike());
        }
        if (StringUtils.isNotEmpty(req.getWarehouseId())) {
            queryWrapper.eq("warehouse_id", req.getWarehouseId());
        }
        IPage result = iSpWarehouseLocationService.page(req, queryWrapper);
        return Result.success(result);
    }

    /**
     * 库位管理修改、新增
     */
    @ApiOperation("库位管理修改、新增")
    @PostMapping("/add-or-update")
    @ResponseBody
    public Result addOrUpdate(SpWarehouseLocation record) {
        iSpWarehouseLocationService.saveOrUpdate(record);
        return Result.success();
    }

    /**
     * 删除库位信息
     */
    @ApiOperation("删除库位信息")
    @ApiImplicitParams({@ApiImplicitParam(name = "req", value = "库位实体", defaultValue = "库位实体")})
    @PostMapping("/delete")
    @ResponseBody
    public Result deleteByTableNameId(SpWarehouseLocation req) throws Exception {
        iSpWarehouseLocationService.removeById(req.getId());
        return Result.success();
    }
}
