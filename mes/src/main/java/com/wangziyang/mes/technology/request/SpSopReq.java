package com.wangziyang.mes.technology.request;

import com.wangziyang.mes.common.BasePageReq;

/**
 * SOP分页请求对象
 */
public class SpSopReq extends BasePageReq {

    private String codeLike;

    private String nameLike;

    public String getCodeLike() { return codeLike; }
    public void setCodeLike(String codeLike) { this.codeLike = codeLike; }
    public String getNameLike() { return nameLike; }
    public void setNameLike(String nameLike) { this.nameLike = nameLike; }
}
