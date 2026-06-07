package com.wangziyang.mes.basedata.entity;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableName;
import com.wangziyang.mes.common.BaseEntity;

/**
 * <p>
 * 库位实体
 * </p>
 *
 * @author WangZiYang
 * @since 2020-03-19
 */
@TableName("sp_warehouse_location")
public class SpWarehouseLocation extends BaseEntity {

    private static final long serialVersionUID = 1L;

    /**
     * 库位编码
     */
    private String code;

    /**
     * 所属库房ID
     */
    private String warehouseId;

    /**
     * 库位状态
     */
    private String status;

    /**
     * 状态(00:删除;01:正常;02:禁用)
     */
    @TableField(value = "is_deleted")
    private String deleted;

    public String getCode() {
        return this.code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getWarehouseId() {
        return this.warehouseId;
    }

    public void setWarehouseId(String warehouseId) {
        this.warehouseId = warehouseId;
    }

    public String getStatus() {
        return this.status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getDeleted() {
        return this.deleted;
    }

    public void setDeleted(String deleted) {
        this.deleted = deleted;
    }

}
