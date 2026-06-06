package com.wangziyang.mes.technology.entity;

import com.wangziyang.mes.common.BaseEntity;

/**
 * SOP内容表
 */
public class SpSopContent extends BaseEntity {

    private static final long serialVersionUID = 1L;

    /** SOP主表ID */
    private String sopId;

    /** 工序主信息 */
    private String operMainInfo;

    /** 工艺内容 */
    private String processContent;

    /** 工艺要求 */
    private String processReq;

    /** 注意事项 */
    private String attention;

    /** 工装 */
    private String tooling;

    /** 技术文档 */
    private String techDoc;

    /** 备料清单 */
    private String materialList;

    public String getSopId() { return sopId; }
    public void setSopId(String sopId) { this.sopId = sopId; }
    public String getOperMainInfo() { return operMainInfo; }
    public void setOperMainInfo(String operMainInfo) { this.operMainInfo = operMainInfo; }
    public String getProcessContent() { return processContent; }
    public void setProcessContent(String processContent) { this.processContent = processContent; }
    public String getProcessReq() { return processReq; }
    public void setProcessReq(String processReq) { this.processReq = processReq; }
    public String getAttention() { return attention; }
    public void setAttention(String attention) { this.attention = attention; }
    public String getTooling() { return tooling; }
    public void setTooling(String tooling) { this.tooling = tooling; }
    public String getTechDoc() { return techDoc; }
    public void setTechDoc(String techDoc) { this.techDoc = techDoc; }
    public String getMaterialList() { return materialList; }
    public void setMaterialList(String materialList) { this.materialList = materialList; }
}
