package com.wangziyang.mes.basedata.entity;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableName;
import com.wangziyang.mes.common.BaseEntity;

/**
 * <p>
 * 库房实体
 * </p>
 *
 * @author WangZiYang
 * @since 2020-03-19
 */
@TableName("sp_warehouse")
public class SpWarehouse extends BaseEntity {

    private static final long serialVersionUID = 1L;

    /**
     * 库房编码
     */
    private String code;

    /**
     * 库房名称
     */
    private String name;

    /**
     * 库房类型（原材料/半成品/成品）
     */
    private String type;

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

    public String getType() {
        return this.type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getDeleted() {
        return this.deleted;
    }

    public void setDeleted(String deleted) {
        this.deleted = deleted;
    }

}
