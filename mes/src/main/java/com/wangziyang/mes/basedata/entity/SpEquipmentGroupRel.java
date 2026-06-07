package com.wangziyang.mes.basedata.entity;

import com.wangziyang.mes.common.BaseEntity;
import com.baomidou.mybatisplus.annotation.TableName;

/**
 * 设备编组-设备绑定关系
 */
@TableName("sp_equipment_group_rel")
public class SpEquipmentGroupRel extends BaseEntity {

    private static final long serialVersionUID = 1L;

    /** 设备编组ID */
    private String groupId;

    /** 设备ID */
    private String equipmentId;

    public String getGroupId() { return groupId; }
    public void setGroupId(String groupId) { this.groupId = groupId; }
    public String getEquipmentId() { return equipmentId; }
    public void setEquipmentId(String equipmentId) { this.equipmentId = equipmentId; }
}
