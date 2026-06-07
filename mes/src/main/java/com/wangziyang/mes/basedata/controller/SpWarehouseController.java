package com.wangziyang.mes.basedata.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.wangziyang.mes.basedata.entity.SpTableManager;
import com.wangziyang.mes.basedata.entity.SpWarehouse;
import com.wangziyang.mes.basedata.entity.SpWarehouseLocation;
import com.wangziyang.mes.basedata.request.SpWarehouseReq;
import com.wangziyang.mes.basedata.service.ISpWarehouseLocationService;
import com.wangziyang.mes.basedata.service.ISpWarehouseService;
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

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * <p>
 * 库房控制器
 * </p>
 *
 * @author WangZiYang
 * @since 2020-03-19
 */
@Controller
@RequestMapping("/basedata/warehouse")
public class SpWarehouseController extends BaseController {

    @Autowired
    private ISpWarehouseService iSpWarehouseService;

    @Autowired
    private ISpWarehouseLocationService iSpWarehouseLocationService;

    /**
     * 库房管理界面
     */
    @ApiOperation("库房管理界面UI")
    @ApiImplicitParams({@ApiImplicitParam(name = "model", value = "模型", defaultValue = "模型")})
    @GetMapping("/list-ui")
    public String listUI(Model model) {
        return "basedata/warehouse/list";
    }

    /**
     * 库房管理修改界面
     */
    @ApiOperation("库房管理修改界面")
    @GetMapping("/add-or-update-ui")
    public String addOrUpdateUI(Model model, SpTableManager record) {
        if (StringUtils.isNotEmpty(record.getId())) {
            SpWarehouse spWarehouse = iSpWarehouseService.getById(record.getId());
            model.addAttribute("result", spWarehouse);
        }
        return "basedata/warehouse/addOrUpdate";
    }

    /**
     * 库房管理界面分页查询
     */
    @ApiOperation("库房管理界面分页查询")
    @ApiImplicitParams({@ApiImplicitParam(name = "req", value = "请求参数", defaultValue = "请求参数")})
    @PostMapping("/page")
    @ResponseBody
    public Result page(SpWarehouseReq req) {
        QueryWrapper queryWrapper = new QueryWrapper();
        if (StringUtils.isNotEmpty(req.getCodeLike())) {
            queryWrapper.like("code", req.getCodeLike());
        }
        if (StringUtils.isNotEmpty(req.getNameLike())) {
            queryWrapper.like("name", req.getNameLike());
        }
        IPage result = iSpWarehouseService.page(req, queryWrapper);
        return Result.success(result);
    }

    /**
     * 查询全部库房（供库位下拉框使用）
     */
    @ApiOperation("查询全部库房列表")
    @GetMapping("/listAll")
    @ResponseBody
    public Result listAll() {
        List<SpWarehouse> list = iSpWarehouseService.list();
        return Result.success(list);
    }

    /**
     * 3D数字仿真数据：库房+库位
     */
    @ApiOperation("3D数字仿真库房库位数据")
    @GetMapping("/3d-data")
    @ResponseBody
    public Result get3DData() {
        // 查询所有有效库房（兼容 is_deleted 单双字符两种约定：排除已删除的）
        QueryWrapper<SpWarehouse> warehouseQw = new QueryWrapper<>();
        warehouseQw.notIn("is_deleted", "1", "01");
        List<SpWarehouse> warehouses = iSpWarehouseService.list(warehouseQw);

        // 查询所有有效库位
        QueryWrapper<SpWarehouseLocation> locationQw = new QueryWrapper<>();
        locationQw.notIn("is_deleted", "1", "01");
        List<SpWarehouseLocation> allLocations = iSpWarehouseLocationService.list(locationQw);

        // 按库房ID分组库位
        Map<String, List<Map<String, String>>> locationMap = new HashMap<>();
        for (SpWarehouseLocation loc : allLocations) {
            locationMap.computeIfAbsent(loc.getWarehouseId(), k -> new ArrayList<>());
            Map<String, String> locData = new HashMap<>();
            locData.put("id", loc.getId());
            locData.put("code", loc.getCode());
            locationMap.get(loc.getWarehouseId()).add(locData);
        }

        // 组装结果
        List<Map<String, Object>> result = new ArrayList<>();
        for (SpWarehouse wh : warehouses) {
            Map<String, Object> whData = new HashMap<>();
            whData.put("warehouseId", wh.getId());
            whData.put("warehouseName", wh.getName());
            whData.put("warehouseType", wh.getType());
            whData.put("locations", locationMap.getOrDefault(wh.getId(), new ArrayList<>()));
            result.add(whData);
        }

        return Result.success(result);
    }

    /**
     * 库房管理修改、新增
     */
    @ApiOperation("库房管理修改、新增")
    @PostMapping("/add-or-update")
    @ResponseBody
    public Result addOrUpdate(SpWarehouse record) {
        iSpWarehouseService.saveOrUpdate(record);
        return Result.success();
    }

    /**
     * 删除库房信息
     */
    @ApiOperation("删除库房信息")
    @ApiImplicitParams({@ApiImplicitParam(name = "req", value = "库房实体", defaultValue = "库房实体")})
    @PostMapping("/delete")
    @ResponseBody
    public Result deleteByTableNameId(SpWarehouse req) throws Exception {
        iSpWarehouseService.removeById(req.getId());
        return Result.success();
    }
}
