package com.wangziyang.mes.technology.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.wangziyang.mes.technology.entity.SpFlowBomRel;

import java.util.List;

public interface ISpFlowBomRelService extends IService<SpFlowBomRel> {

    List<String> listBomIdsByFlowId(String flowId);

    void saveFlowBoms(String flowId, List<String> bomIds);
}
