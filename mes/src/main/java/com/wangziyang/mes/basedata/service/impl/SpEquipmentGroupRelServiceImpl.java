package com.wangziyang.mes.basedata.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.wangziyang.mes.basedata.entity.SpEquipmentGroupRel;
import com.wangziyang.mes.basedata.mapper.SpEquipmentGroupRelMapper;
import com.wangziyang.mes.basedata.service.ISpEquipmentGroupRelService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class SpEquipmentGroupRelServiceImpl extends ServiceImpl<SpEquipmentGroupRelMapper, SpEquipmentGroupRel> implements ISpEquipmentGroupRelService {

    @Override
    public List<String> listEquipmentIdsByGroupId(String groupId) {
        QueryWrapper<SpEquipmentGroupRel> qw = new QueryWrapper<>();
        qw.eq("group_id", groupId);
        return this.list(qw).stream().map(SpEquipmentGroupRel::getEquipmentId).collect(Collectors.toList());
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void saveGroupEquipments(String groupId, List<String> equipmentIds) {
        QueryWrapper<SpEquipmentGroupRel> qw = new QueryWrapper<>();
        qw.eq("group_id", groupId);
        this.remove(qw);
        if (equipmentIds != null && !equipmentIds.isEmpty()) {
            List<SpEquipmentGroupRel> list = new ArrayList<>();
            for (String eid : equipmentIds) {
                SpEquipmentGroupRel rel = new SpEquipmentGroupRel();
                rel.setGroupId(groupId);
                rel.setEquipmentId(eid);
                list.add(rel);
            }
            this.saveBatch(list);
        }
    }
}
