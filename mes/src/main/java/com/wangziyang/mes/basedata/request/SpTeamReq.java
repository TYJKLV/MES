package com.wangziyang.mes.basedata.request;

import com.wangziyang.mes.common.BasePageReq;

public class SpTeamReq extends BasePageReq {

    private String codeLike;
    private String nameLike;

    public String getCodeLike() { return codeLike; }
    public void setCodeLike(String codeLike) { this.codeLike = codeLike; }
    public String getNameLike() { return nameLike; }
    public void setNameLike(String nameLike) { this.nameLike = nameLike; }
}
