package com.wangziyang.mes.technology.request;

import com.wangziyang.mes.common.BasePageReq;

/**
 * bom 分页请求
 *
 * @author wangziyang
 * @since 20200328
 */

public class SpBomReq extends BasePageReq {
    /**
     * 物料模糊查询
     */
    private String materielCodeLike;

    /**
     * BOM类型精确匹配：product/process
     */
    private String bomType;

    public String getMaterielCodeLike() {
        return this.materielCodeLike;
    }

    public void setMaterielCodeLike(String materielCodeLike) {
        this.materielCodeLike = materielCodeLike;
    }

    public String getBomType() {
        return bomType;
    }

    public void setBomType(String bomType) {
        this.bomType = bomType;
    }
}
