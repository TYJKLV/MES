package com.wangziyang.mes.basedata.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.wangziyang.mes.basedata.entity.SpTeamUserRel;

import java.util.List;

public interface ISpTeamUserRelService extends IService<SpTeamUserRel> {

    /** 获取班组已分配的员工ID列表 */
    List<String> listUserIdsByTeamId(String teamId);

    /** 保存班组-员工绑定（先删后增） */
    void saveTeamUsers(String teamId, List<String> userIds);

    /** 确保某用户已加入班组（如不存在则新增，用于班组长自动同步） */
    void ensureTeamUser(String teamId, String userId);
}
