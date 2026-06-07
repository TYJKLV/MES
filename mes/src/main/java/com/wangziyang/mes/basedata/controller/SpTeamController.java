package com.wangziyang.mes.basedata.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.wangziyang.mes.basedata.entity.SpTableManager;
import com.wangziyang.mes.basedata.entity.SpTeam;
import com.wangziyang.mes.basedata.request.SpTeamReq;
import com.wangziyang.mes.basedata.service.ISpTeamService;
import com.wangziyang.mes.basedata.service.ISpTeamUserRelService;
import com.wangziyang.mes.common.BaseController;
import com.wangziyang.mes.common.Result;
import com.wangziyang.mes.system.entity.SysDepartment;
import com.wangziyang.mes.system.entity.SysUser;
import com.wangziyang.mes.system.service.ISysDepartmentService;
import com.wangziyang.mes.system.service.ISysUserService;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/basedata/team")
public class SpTeamController extends BaseController {

    @Autowired
    private ISpTeamService spTeamService;
    @Autowired
    private ISpTeamUserRelService spTeamUserRelService;
    @Autowired
    private ISysDepartmentService sysDepartmentService;
    @Autowired
    private ISysUserService sysUserService;

    @GetMapping("/list-ui")
    public String listUI(Model model) {
        return "basedata/team/list";
    }

    @GetMapping("/add-or-update-ui")
    public String addOrUpdateUI(Model model, SpTableManager record) {
        if (StringUtils.isNotEmpty(record.getId())) {
            model.addAttribute("result", spTeamService.getById(record.getId()));
        }
        return "basedata/team/addOrUpdate";
    }

    @PostMapping("/page")
    @ResponseBody
    public Result page(SpTeamReq req) {
        QueryWrapper<SpTeam> qw = new QueryWrapper<>();
        if (StringUtils.isNotEmpty(req.getCodeLike())) {
            qw.like("code", req.getCodeLike());
        }
        if (StringUtils.isNotEmpty(req.getNameLike())) {
            qw.like("name", req.getNameLike());
        }
        qw.orderByDesc("update_time");
        IPage result = spTeamService.page(req, qw);
        return Result.success(result);
    }

    @PostMapping("/add-or-update")
    @ResponseBody
    public Result addOrUpdate(SpTeam record) {
        spTeamService.saveOrUpdate(record);
        return Result.success();
    }

    @PostMapping("/delete")
    @ResponseBody
    public Result delete(SpTeam record) {
        spTeamService.removeById(record.getId());
        return Result.success();
    }

    @PostMapping("/batch-delete")
    @ResponseBody
    public Result batchDelete(String ids) {
        if (StringUtils.isEmpty(ids)) {
            return Result.failure("请选择要删除的记录");
        }
        for (String id : ids.split(",")) {
            spTeamService.removeById(id.trim());
        }
        return Result.success();
    }

    /** 部门列表（下拉框用） */
    @GetMapping("/dept-list")
    @ResponseBody
    public Result deptList() {
        List<SysDepartment> list = sysDepartmentService.list();
        return Result.success(list);
    }

    /** 员工列表（下拉框用） */
    @GetMapping("/user-list")
    @ResponseBody
    public Result userList() {
        QueryWrapper<SysUser> qw = new QueryWrapper<>();
        qw.eq("is_deleted", "0");
        qw.select("id", "name", "username");
        List<SysUser> list = sysUserService.list(qw);
        return Result.success(list);
    }

    /** 班组员工分配页面 */
    @GetMapping("/team-user-ui")
    public String teamUserUI(Model model, @RequestParam String teamId) {
        SpTeam team = spTeamService.getById(teamId);
        model.addAttribute("team", team);
        return "basedata/team/teamUser";
    }

    /** 获取班组已分配员工ID列表 */
    @GetMapping("/user-ids/{teamId}")
    @ResponseBody
    public Result userIds(@PathVariable String teamId) {
        return Result.success(spTeamUserRelService.listUserIdsByTeamId(teamId));
    }

    /** 保存班组-员工绑定 */
    @PostMapping("/assign-users")
    @ResponseBody
    public Result assignUsers(@RequestParam String teamId, @RequestParam(required = false) String userIds) {
        List<String> idList = null;
        if (StringUtils.isNotEmpty(userIds)) {
            idList = java.util.Arrays.asList(userIds.split(","));
        }
        spTeamUserRelService.saveTeamUsers(teamId, idList);
        return Result.success();
    }
}
