package com.wangziyang.mes.basedata.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.wangziyang.mes.basedata.entity.SpEquipmentGroupRel;

import java.util.List;

public interface ISpEquipmentGroupRelService extends IService<SpEquipmentGroupRel> {

    /** 获取编组已绑定的设备ID列表 */
    List<String> listEquipmentIdsByGroupId(String groupId);

    /** 保存编组-设备绑定（先删后增） */
    void saveGroupEquipments(String groupId, List<String> equipmentIds);
}
