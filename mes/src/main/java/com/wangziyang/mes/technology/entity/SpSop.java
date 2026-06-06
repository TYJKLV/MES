package com.wangziyang.mes.technology.entity;

import com.baomidou.mybatisplus.annotation.TableField;
import com.wangziyang.mes.common.BaseEntity;

/**
 * SOP（标准作业指导书）主表
 */
public class SpSop extends BaseEntity {

    private static final long serialVersionUID = 1L;

    /** SOP编号 */
    private String code;

    /** SOP名称 */
    private String name;

    /** 关联工序ID（关联sp_oper） */
    private String operId;

    /** 关联BOM ID（可选，关联sp_bom） */
    private String bomId;

    /** 版本号 */
    private String version;

    /** 状态：draft=草稿, review=审核中, pass=已发布 */
    private String state;

    /** 状态(0:正常;1:删除;2:禁用) */
    @TableField(value = "is_deleted")
    private String deleted;

    public String getCode() { return code; }
    public void setCode(String code) { this.code = code; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getOperId() { return operId; }
    public void setOperId(String operId) { this.operId = operId; }
    public String getBomId() { return bomId; }
    public void setBomId(String bomId) { this.bomId = bomId; }
    public String getVersion() { return version; }
    public void setVersion(String version) { this.version = version; }
    public String getState() { return state; }
    public void setState(String state) { this.state = state; }
    public String getDeleted() { return deleted; }
    public void setDeleted(String deleted) { this.deleted = deleted; }
}
