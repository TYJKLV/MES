package com.wangziyang.mes.basedata.entity;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableName;
import com.wangziyang.mes.common.BaseEntity;

/**
 * 班组实体
 */
@TableName("sp_team")
public class SpTeam extends BaseEntity {

    private static final long serialVersionUID = 1L;

    /** 班组编码 */
    private String code;

    /** 班组名称 */
    private String name;

    /** 所属部门ID */
    private String deptId;

    /** 班组长ID（关联sys_user） */
    private String leaderId;

    /** 状态(0:正常;1:删除;2:禁用) */
    @TableField(value = "is_deleted")
    private String deleted;

    public String getCode() { return code; }
    public void setCode(String code) { this.code = code; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getDeptId() { return deptId; }
    public void setDeptId(String deptId) { this.deptId = deptId; }
    public String getLeaderId() { return leaderId; }
    public void setLeaderId(String leaderId) { this.leaderId = leaderId; }
    public String getDeleted() { return deleted; }
    public void setDeleted(String deleted) { this.deleted = deleted; }
}
