package com.wangziyang.mes.order.request;

import com.wangziyang.mes.common.BasePageReq;

/**
 * 生产订单分页请求对象
 *
 * @author WangZiYang
 * @since 2020-07-01
 */
public class SpOrderReq extends BasePageReq {

    /**
     * 模糊查询工单编号
     */
    private String orderCodeLike;

    /**
     * 模糊查询工单描述
     */
    private String orderDescriptionLike;

    public String getOrderCodeLike() {
        return this.orderCodeLike;
    }

    public void setOrderCodeLike(String orderCodeLike) {
        this.orderCodeLike = orderCodeLike;
    }

    public String getOrderDescriptionLike() {
        return this.orderDescriptionLike;
    }

    public void setOrderDescriptionLike(String orderDescriptionLike) {
        this.orderDescriptionLike = orderDescriptionLike;
    }
}
