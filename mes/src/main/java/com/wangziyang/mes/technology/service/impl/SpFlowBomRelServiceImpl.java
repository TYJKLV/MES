package com.wangziyang.mes.technology.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.wangziyang.mes.technology.entity.SpFlowBomRel;
import com.wangziyang.mes.technology.mapper.SpFlowBomRelMapper;
import com.wangziyang.mes.technology.service.ISpFlowBomRelService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class SpFlowBomRelServiceImpl extends ServiceImpl<SpFlowBomRelMapper, SpFlowBomRel> implements ISpFlowBomRelService {

    @Override
    public List<String> listBomIdsByFlowId(String flowId) {
        QueryWrapper<SpFlowBomRel> qw = new QueryWrapper<>();
        qw.eq("flow_id", flowId);
        return this.list(qw).stream().map(SpFlowBomRel::getBomId).collect(Collectors.toList());
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void saveFlowBoms(String flowId, List<String> bomIds) {
        QueryWrapper<SpFlowBomRel> qw = new QueryWrapper<>();
        qw.eq("flow_id", flowId);
        this.remove(qw);
        if (bomIds != null && !bomIds.isEmpty()) {
            List<SpFlowBomRel> list = new ArrayList<>();
            for (String bomId : bomIds) {
                SpFlowBomRel rel = new SpFlowBomRel();
                rel.setFlowId(flowId);
                rel.setBomId(bomId);
                list.add(rel);
            }
            this.saveBatch(list);
        }
    }
}
