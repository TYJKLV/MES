package com.wangziyang.mes.basedata.request;

import com.wangziyang.mes.common.BasePageReq;

/**
 * 设备分页请求对象
 *
 * @author WangZiYang
 * @since 2020-03-19
 */
public class SpEquipmentReq extends BasePageReq {

    /**
     * 模糊查询设备编码
     */
    private String codeLike;

    /**
     * 模糊查询设备名称
     */
    private String nameLike;

    public String getCodeLike() {
        return this.codeLike;
    }

    public void setCodeLike(String codeLike) {
        this.codeLike = codeLike;
    }

    public String getNameLike() {
        return this.nameLike;
    }

    public void setNameLike(String nameLike) {
        this.nameLike = nameLike;
    }
}
