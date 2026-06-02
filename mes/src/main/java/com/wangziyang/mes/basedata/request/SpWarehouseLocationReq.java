package com.wangziyang.mes.basedata.request;

import com.wangziyang.mes.common.BasePageReq;

/**
 * 库位分页请求对象
 *
 * @author WangZiYang
 * @since 2020-03-19
 */
public class SpWarehouseLocationReq extends BasePageReq {

    /**
     * 模糊查询库位编码
     */
    private String codeLike;

    /**
     * 所属库房ID
     */
    private String warehouseId;

    public String getCodeLike() {
        return this.codeLike;
    }

    public void setCodeLike(String codeLike) {
        this.codeLike = codeLike;
    }

    public String getWarehouseId() {
        return this.warehouseId;
    }

    public void setWarehouseId(String warehouseId) {
        this.warehouseId = warehouseId;
    }
}
