package com.wangziyang.mes.technology.entity;

import com.wangziyang.mes.common.BaseEntity;

/**
 * 工艺流程-BOM组件绑定关系
 */
public class SpFlowBomRel extends BaseEntity {

    private static final long serialVersionUID = 1L;

    /** 流程ID */
    private String flowId;

    /** BOM头ID */
    private String bomId;

    public String getFlowId() { return flowId; }
    public void setFlowId(String flowId) { this.flowId = flowId; }
    public String getBomId() { return bomId; }
    public void setBomId(String bomId) { this.bomId = bomId; }
}
