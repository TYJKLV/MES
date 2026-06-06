package com.wangziyang.mes.basedata.entity;

import com.wangziyang.mes.common.BaseEntity;

/**
 * 班组-员工绑定关系
 */
public class SpTeamUserRel extends BaseEntity {

    private static final long serialVersionUID = 1L;

    /** 班组ID */
    private String teamId;

    /** 员工ID（关联sys_user） */
    private String userId;

    public String getTeamId() { return teamId; }
    public void setTeamId(String teamId) { this.teamId = teamId; }
    public String getUserId() { return userId; }
    public void setUserId(String userId) { this.userId = userId; }
}
