package com.wangziyang.mes.basedata.entity;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableName;
import com.wangziyang.mes.common.BaseEntity;

/**
 * 零部件实体
 */
@TableName("sp_component")
public class SpComponent extends BaseEntity {

    private static final long serialVersionUID = 1L;

    /** 零部件编码 */
    private String code;

    /** 零部件名称 */
    private String name;

    /** 规格 */
    private String spec;

    /** 关联物料ID（关联sp_materile） */
    private String materielId;

    /** 图号 */
    private String drawingNo;

    /** 状态(0:正常;1:删除;2:禁用) */
    @TableField(value = "is_deleted")
    private String deleted;

    public String getCode() { return code; }
    public void setCode(String code) { this.code = code; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getSpec() { return spec; }
    public void setSpec(String spec) { this.spec = spec; }
    public String getMaterielId() { return materielId; }
    public void setMaterielId(String materielId) { this.materielId = materielId; }
    public String getDrawingNo() { return drawingNo; }
    public void setDrawingNo(String drawingNo) { this.drawingNo = drawingNo; }
    public String getDeleted() { return deleted; }
    public void setDeleted(String deleted) { this.deleted = deleted; }
}
