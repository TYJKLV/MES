package com.wangziyang.mes.technology.request;

import com.wangziyang.mes.common.BasePageReq;

/**
 * 工序分页请求对象
 */
public class SpOperReq extends BasePageReq {

    /** 模糊查询工序编号 */
    private String operCodeLike;

    /** 模糊查询工序名称 */
    private String operLike;

    public String getOperCodeLike() { return operCodeLike; }
    public void setOperCodeLike(String operCodeLike) { this.operCodeLike = operCodeLike; }
    public String getOperLike() { return operLike; }
    public void setOperLike(String operLike) { this.operLike = operLike; }
}
