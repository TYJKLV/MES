package com.wangziyang.mes.technology.entity;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableName;
import com.wangziyang.mes.common.BaseEntity;

import java.math.BigDecimal;

/**
 * 工序实体类
 */
@TableName(value = "sp_oper")
public class SpOper extends BaseEntity {

    private static final long serialVersionUID = 1L;

    /** 工序编号 */
    private String operCode;

    /** 工序名称 */
    private String oper;

    /** 工序描述 */
    private String operDesc;

    /** 工时定额（单位：分钟） */
    private BigDecimal manHours;

    /** 加工单元ID（关联sp_workcell） */
    private String workcellId;

    /** 状态(0:正常;1:删除;2:禁用) */
    @TableField(value = "is_deleted")
    private String deleted;

    public String getOperCode() { return operCode; }
    public void setOperCode(String operCode) { this.operCode = operCode; }
    public String getOper() { return oper; }
    public void setOper(String oper) { this.oper = oper; }
    public String getOperDesc() { return operDesc; }
    public void setOperDesc(String operDesc) { this.operDesc = operDesc; }
    public BigDecimal getManHours() { return manHours; }
    public void setManHours(BigDecimal manHours) { this.manHours = manHours; }
    public String getWorkcellId() { return workcellId; }
    public void setWorkcellId(String workcellId) { this.workcellId = workcellId; }
    public String getDeleted() { return deleted; }
    public void setDeleted(String deleted) { this.deleted = deleted; }
}
