package com.wangziyang.mes.basedata.request;

import com.wangziyang.mes.common.BasePageReq;

/**
 * 加工单元分页请求对象
 */
public class SpWorkcellReq extends BasePageReq {

    /** 模糊查询编码 */
    private String codeLike;

    /** 模糊查询名称 */
    private String nameLike;

    public String getCodeLike() { return codeLike; }
    public void setCodeLike(String codeLike) { this.codeLike = codeLike; }
    public String getNameLike() { return nameLike; }
    public void setNameLike(String nameLike) { this.nameLike = nameLike; }
}
