package com.wangziyang.mes.basedata.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.wangziyang.mes.basedata.entity.SpTeamUserRel;
import com.wangziyang.mes.basedata.mapper.SpTeamUserRelMapper;
import com.wangziyang.mes.basedata.service.ISpTeamUserRelService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class SpTeamUserRelServiceImpl extends ServiceImpl<SpTeamUserRelMapper, SpTeamUserRel> implements ISpTeamUserRelService {

    @Override
    public List<String> listUserIdsByTeamId(String teamId) {
        QueryWrapper<SpTeamUserRel> qw = new QueryWrapper<>();
        qw.eq("team_id", teamId);
        return this.list(qw).stream().map(SpTeamUserRel::getUserId).collect(Collectors.toList());
    }

    @Override
    public void ensureTeamUser(String teamId, String userId) {
        QueryWrapper<SpTeamUserRel> qw = new QueryWrapper<>();
        qw.eq("team_id", teamId).eq("user_id", userId);
        if (this.count(qw) == 0) {
            SpTeamUserRel rel = new SpTeamUserRel();
            rel.setTeamId(teamId);
            rel.setUserId(userId);
            this.save(rel);
        }
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void saveTeamUsers(String teamId, List<String> userIds) {
        QueryWrapper<SpTeamUserRel> qw = new QueryWrapper<>();
        qw.eq("team_id", teamId);
        this.remove(qw);
        if (userIds != null && !userIds.isEmpty()) {
            List<SpTeamUserRel> list = new ArrayList<>();
            for (String userId : userIds) {
                SpTeamUserRel rel = new SpTeamUserRel();
                rel.setTeamId(teamId);
                rel.setUserId(userId);
                list.add(rel);
            }
            this.saveBatch(list);
        }
    }
}
