package com.wangziyang.mes.technology.request;

import com.wangziyang.mes.common.BasePageReq;
/**
 * 流程分页对象
 * @author wangziyang
 * @since 2020/03/15
 */
public class SpFlowReq extends BasePageReq {

    /** 模糊查询流程编码 */
    private String flowLike;

    public String getFlowLike() { return flowLike; }
    public void setFlowLike(String flowLike) { this.flowLike = flowLike; }
}
