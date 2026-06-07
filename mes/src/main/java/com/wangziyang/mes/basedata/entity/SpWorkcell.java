package com.wangziyang.mes.basedata.entity;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableName;
import com.wangziyang.mes.common.BaseEntity;

/**
 * 加工单元实体
 */
@TableName("sp_workcell")
public class SpWorkcell extends BaseEntity {

    private static final long serialVersionUID = 1L;

    /** 加工单元编码 */
    private String code;

    /** 加工单元名称 */
    private String name;

    /** 所属车间ID（关联sys_department） */
    private String deptId;

    /** 关联设备编组ID（关联sp_equipment_group） */
    private String groupId;

    /** 状态(0:正常;1:删除;2:禁用) */
    @TableField(value = "is_deleted")
    private String deleted;

    public String getCode() { return code; }
    public void setCode(String code) { this.code = code; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getDeptId() { return deptId; }
    public void setDeptId(String deptId) { this.deptId = deptId; }
    public String getGroupId() { return groupId; }
    public void setGroupId(String groupId) { this.groupId = groupId; }
    public String getDeleted() { return deleted; }
    public void setDeleted(String deleted) { this.deleted = deleted; }
}
