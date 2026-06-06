package com.wangziyang.mes.system.controller.admin;


import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.wangziyang.mes.common.BaseController;
import com.wangziyang.mes.common.Result;
import com.wangziyang.mes.system.entity.SysRole;
import com.wangziyang.mes.system.request.SysRolePageReq;
import com.wangziyang.mes.system.service.ISysRoleMenuService;
import com.wangziyang.mes.system.service.ISysRoleService;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * <p>
 * 前端控制器
 * </p>
 *
 * @author SongPeng
 * @since 2019-10-16
 */
@Controller("adminSysRoleController")
@RequestMapping("/admin/sys/role")
public class SysRoleController extends BaseController {

    @Autowired
    private ISysRoleService sysRoleService;

    @Autowired
    private ISysRoleMenuService sysRoleMenuService;

    @GetMapping("/list-ui")
    public String listUI(Model model) {
        return "admin/system/role/list";
    }

    @PostMapping("/page")
    @ResponseBody
    public Result page(SysRolePageReq req) {
        QueryWrapper qw = new QueryWrapper();
        qw.orderByDesc(req.getOrderBy());
        IPage result = sysRoleService.page(req, qw);
        return Result.success(result);
    }

    @GetMapping("/add-or-update-ui")
    public String addOrUpdateUI(Model model, SysRole record) {
        if (StringUtils.isNotEmpty(record.getId())) {
            SysRole result = sysRoleService.getById(record.getId());
            model.addAttribute("result", result);
        }
        return "admin/system/role/addOrUpdate";
    }

    @PostMapping("/add-or-update")
    @ResponseBody
    public Result addOrUpdate(SysRole record) {
        sysRoleService.saveOrUpdate(record);
        return Result.success(record.getId());
    }

    /**
     * 角色权限分配页面
     */
    @GetMapping("/permission-ui")
    public String permissionUI(Model model, @RequestParam String roleId) {
        SysRole role = sysRoleService.getById(roleId);
        model.addAttribute("role", role);
        return "admin/system/role/permission";
    }

    /**
     * 获取角色已分配的菜单ID列表
     */
    @GetMapping("/menu-ids/{roleId}")
    @ResponseBody
    public Result menuIds(@PathVariable String roleId) {
        List<String> menuIds = sysRoleMenuService.listMenuIdsByRoleId(roleId);
        return Result.success(menuIds);
    }

    /**
     * 保存角色-菜单分配
     */
    @PostMapping("/assign-menu")
    @ResponseBody
    public Result assignMenu(@RequestParam String roleId, @RequestParam(required = false) String menuIds) {
        List<String> idList = null;
        if (StringUtils.isNotEmpty(menuIds)) {
            idList = java.util.Arrays.asList(menuIds.split(","));
        }
        sysRoleMenuService.saveRoleMenus(roleId, idList);
        return Result.success();
    }

    /**
     * 删除角色
     */
    @PostMapping("/delete")
    @ResponseBody
    public Result delete(SysRole record) {
        sysRoleService.removeById(record.getId());
        return Result.success();
    }

    /**
     * 批量删除角色
     */
    @PostMapping("/batch-delete")
    @ResponseBody
    public Result batchDelete(String ids) {
        if (StringUtils.isEmpty(ids)) {
            return Result.failure("请选择要删除的记录");
        }
        for (String id : ids.split(",")) {
            sysRoleService.removeById(id.trim());
        }
        return Result.success();
    }
}
