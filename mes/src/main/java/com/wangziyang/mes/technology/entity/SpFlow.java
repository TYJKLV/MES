package com.wangziyang.mes.technology.entity;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableName;
import com.wangziyang.mes.common.BaseEntity;

/**
 * 流程（工艺路线）实体类
 */
@TableName(value = "sp_flow")
public class SpFlow extends BaseEntity {

    private static final long serialVersionUID = 1L;

    /** 流程编码 */
    private String flow;

    /** 流程描述 */
    private String flowDesc;

    /** 流程时序绘制 A→B→C */
    private String process;

    /** 版本号 */
    private String version;

    /** 状态：creat=创建, pass=已定版 */
    private String state;

    /** 状态(0:正常;1:删除;2:禁用) */
    @TableField(value = "is_deleted")
    private String deleted;

    public String getFlow() { return flow; }
    public void setFlow(String flow) { this.flow = flow; }
    public String getFlowDesc() { return flowDesc; }
    public void setFlowDesc(String flowDesc) { this.flowDesc = flowDesc; }
    public String getProcess() { return process; }
    public void setProcess(String process) { this.process = process; }
    public String getVersion() { return version; }
    public void setVersion(String version) { this.version = version; }
    public String getState() { return state; }
    public void setState(String state) { this.state = state; }
    public String getDeleted() { return deleted; }
    public void setDeleted(String deleted) { this.deleted = deleted; }
}
