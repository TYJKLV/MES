package com.wangziyang.mes.system.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.wangziyang.mes.system.entity.SysRoleMenu;

import java.util.List;

/**
 * <p>
 * 服务类
 * </p>
 *
 * @author SongPeng
 * @since 2020-03-05
 */
public interface ISysRoleMenuService extends IService<SysRoleMenu> {

    /**
     * 获取角色已分配的菜单ID列表
     */
    List<String> listMenuIdsByRoleId(String roleId);

    /**
     * 保存角色-菜单绑定（先删后增）
     */
    void saveRoleMenus(String roleId, List<String> menuIds);
}
