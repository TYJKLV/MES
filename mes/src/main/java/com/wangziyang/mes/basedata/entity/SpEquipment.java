package com.wangziyang.mes.basedata.entity;

import com.baomidou.mybatisplus.annotation.TableField;
import com.wangziyang.mes.common.BaseEntity;

/**
 * <p>
 * 设备实体
 * </p>
 *
 * @author WangZiYang
 * @since 2020-03-19
 */
public class SpEquipment extends BaseEntity {

    private static final long serialVersionUID = 1L;

    /**
     * 设备编码
     */
    private String code;

    /**
     * 设备名称
     */
    private String name;

    /**
     * 设备分类
     */
    private String category;

    /**
     * 规格型号
     */
    private String specModel;

    /**
     * 设备状态
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

    public String getName() {
        return this.name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getCategory() {
        return this.category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getSpecModel() {
        return this.specModel;
    }

    public void setSpecModel(String specModel) {
        this.specModel = specModel;
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
