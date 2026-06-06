package com.wangziyang.mes.technology.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.wangziyang.mes.basedata.entity.SpMaterile;
import com.wangziyang.mes.basedata.entity.SpWorkcell;
import com.wangziyang.mes.basedata.service.ISpMaterileService;
import com.wangziyang.mes.basedata.service.ISpWorkcellService;
import com.wangziyang.mes.common.BaseController;
import com.wangziyang.mes.common.Result;
import com.wangziyang.mes.technology.entity.SpBom;
import com.wangziyang.mes.technology.entity.SpFlow;
import com.wangziyang.mes.technology.entity.SpFlowBomRel;
import com.wangziyang.mes.technology.entity.SpFlowOperRelation;
import com.wangziyang.mes.technology.entity.SpOper;
import com.wangziyang.mes.technology.service.ISpBomService;
import com.wangziyang.mes.technology.service.ISpFlowBomRelService;
import com.wangziyang.mes.technology.service.ISpFlowOperRelationService;
import com.wangziyang.mes.technology.service.ISpFlowService;
import com.wangziyang.mes.technology.service.ISpOperService;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.*;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/technology/product-process")
public class ProductProcessController extends BaseController {

    @Autowired
    private ISpMaterileService materileService;
    @Autowired
    private ISpFlowService flowService;
    @Autowired
    private ISpFlowOperRelationService flowOperRelationService;
    @Autowired
    private ISpOperService operService;
    @Autowired
    private ISpWorkcellService workcellService;
    @Autowired
    private ISpBomService bomService;
    @Autowired
    private ISpFlowBomRelService flowBomRelService;

    @GetMapping("/list-ui")
    public String listUI() {
        return "technology/productProcess/list";
    }

    @PostMapping("/search")
    @ResponseBody
    public Result search(
            @RequestParam(required = false) String materielLike,
            @RequestParam(required = false) String materielDescLike,
            @RequestParam(required = false) String bomCodeLike,
            @RequestParam(required = false) String operCodeLike,
            @RequestParam(required = false) String operLike,
            @RequestParam(required = false) String workcellNameLike) {

        Set<String> flowIds = null;
        boolean first = true;

        // 1. 按物料筛选
        if (StringUtils.isNotEmpty(materielLike) || StringUtils.isNotEmpty(materielDescLike)) {
            QueryWrapper<SpMaterile> qw = new QueryWrapper<>();
            qw.isNotNull("flow_id").ne("flow_id", "").eq("is_deleted", "0");
            if (StringUtils.isNotEmpty(materielLike)) qw.like("materiel", materielLike);
            if (StringUtils.isNotEmpty(materielDescLike)) qw.like("materiel_desc", materielDescLike);
            Set<String> ids = materileService.list(qw).stream()
                    .map(SpMaterile::getFlowId).filter(StringUtils::isNotEmpty).collect(Collectors.toSet());
            flowIds = ids;
            first = false;
        }

        // 2. 按BOM筛选
        if (StringUtils.isNotEmpty(bomCodeLike)) {
            QueryWrapper<SpBom> bomQw = new QueryWrapper<>();
            bomQw.like("bom_code", bomCodeLike).eq("is_deleted", "0");
            List<String> bomIds = bomService.list(bomQw).stream()
                    .map(SpBom::getId).collect(Collectors.toList());
            Set<String> ids = new HashSet<>();
            if (!bomIds.isEmpty()) {
                QueryWrapper<SpFlowBomRel> relQw = new QueryWrapper<>();
                relQw.in("bom_id", bomIds);
                ids = flowBomRelService.list(relQw).stream()
                        .map(SpFlowBomRel::getFlowId).collect(Collectors.toSet());
            }
            flowIds = first ? ids : intersect(flowIds, ids);
            first = false;
        }

        // 3. 按工序筛选
        if (StringUtils.isNotEmpty(operCodeLike) || StringUtils.isNotEmpty(operLike)) {
            QueryWrapper<SpOper> operQw = new QueryWrapper<>();
            operQw.eq("is_deleted", "0");
            if (StringUtils.isNotEmpty(operCodeLike)) operQw.like("oper_code", operCodeLike);
            if (StringUtils.isNotEmpty(operLike)) operQw.like("oper", operLike);
            List<String> operIds = operService.list(operQw).stream()
                    .map(SpOper::getId).collect(Collectors.toList());
            Set<String> ids = new HashSet<>();
            if (!operIds.isEmpty()) {
                QueryWrapper<SpFlowOperRelation> relQw = new QueryWrapper<>();
                relQw.in("oper_id", operIds);
                ids = flowOperRelationService.list(relQw).stream()
                        .map(SpFlowOperRelation::getFlowId).collect(Collectors.toSet());
            }
            flowIds = first ? ids : intersect(flowIds, ids);
            first = false;
        }

        // 4. 按加工单元筛选
        if (StringUtils.isNotEmpty(workcellNameLike)) {
            QueryWrapper<SpWorkcell> wcQw = new QueryWrapper<>();
            wcQw.like("name", workcellNameLike).eq("is_deleted", "0");
            List<String> workcellIds = workcellService.list(wcQw).stream()
                    .map(SpWorkcell::getId).collect(Collectors.toList());
            Set<String> ids = new HashSet<>();
            if (!workcellIds.isEmpty()) {
                QueryWrapper<SpOper> operQw = new QueryWrapper<>();
                operQw.in("workcell_id", workcellIds).eq("is_deleted", "0");
                List<String> operIds = operService.list(operQw).stream()
                        .map(SpOper::getId).collect(Collectors.toList());
                if (!operIds.isEmpty()) {
                    QueryWrapper<SpFlowOperRelation> relQw = new QueryWrapper<>();
                    relQw.in("oper_id", operIds);
                    ids = flowOperRelationService.list(relQw).stream()
                            .map(SpFlowOperRelation::getFlowId).collect(Collectors.toSet());
                }
            }
            flowIds = first ? ids : intersect(flowIds, ids);
            first = false;
        }

        // 5. 无筛选条件时，返回所有关联了工艺路线的物料
        if (first) {
            QueryWrapper<SpMaterile> qw = new QueryWrapper<>();
            qw.isNotNull("flow_id").ne("flow_id", "").eq("is_deleted", "0");
            flowIds = materileService.list(qw).stream()
                    .map(SpMaterile::getFlowId).filter(StringUtils::isNotEmpty).collect(Collectors.toSet());
        }

        // 构建结果列表
        List<Map<String, Object>> results = new ArrayList<>();
        for (String flowId : flowIds) {
            SpFlow flow = flowService.getById(flowId);
            if (flow == null || "1".equals(flow.getDeleted())) continue;

            QueryWrapper<SpMaterile> matQw = new QueryWrapper<>();
            matQw.eq("flow_id", flowId).eq("is_deleted", "0");
            List<SpMaterile> materials = materileService.list(matQw);

            QueryWrapper<SpFlowOperRelation> relQw = new QueryWrapper<>();
            relQw.eq("flow_id", flowId);
            int operCount = (int) flowOperRelationService.count(relQw);

            Map<String, Object> row = new HashMap<>();
            row.put("flowId", flow.getId());
            row.put("flowCode", flow.getFlow());
            row.put("flowDesc", flow.getFlowDesc());
            row.put("version", flow.getVersion());
            row.put("state", flow.getState());
            row.put("process", flow.getProcess());
            row.put("operCount", operCount);
            row.put("materials", materials.stream()
                    .map(m -> m.getMateriel() + " - " + m.getMaterielDesc())
                    .collect(Collectors.joining("; ")));
            results.add(row);
        }

        return Result.success(results);
    }

    @GetMapping("/flow-detail-ui")
    public String flowDetailUI(Model model, @RequestParam String flowId) {
        SpFlow flow = flowService.getById(flowId);
        model.addAttribute("flow", flow);

        QueryWrapper<SpFlowOperRelation> qw = new QueryWrapper<>();
        qw.eq("flow_id", flowId).orderByAsc("sort_num");
        List<SpFlowOperRelation> relations = flowOperRelationService.list(qw);

        List<Map<String, Object>> operDetails = new ArrayList<>();
        for (SpFlowOperRelation rel : relations) {
            Map<String, Object> detail = new HashMap<>();
            detail.put("relation", rel);
            if (StringUtils.isNotEmpty(rel.getOperId())) {
                SpOper oper = operService.getById(rel.getOperId());
                detail.put("oper", oper);
                if (oper != null && StringUtils.isNotEmpty(oper.getWorkcellId())) {
                    SpWorkcell wc = workcellService.getById(oper.getWorkcellId());
                    detail.put("workcell", wc);
                }
            }
            operDetails.add(detail);
        }
        model.addAttribute("operDetails", operDetails);

        QueryWrapper<SpMaterile> matQw = new QueryWrapper<>();
        matQw.eq("flow_id", flowId).eq("is_deleted", "0");
        model.addAttribute("materials", materileService.list(matQw));

        return "technology/productProcess/flowDetail";
    }

    private Set<String> intersect(Set<String> a, Set<String> b) {
        if (a == null || a.isEmpty()) return new HashSet<>(b != null ? b : Collections.emptySet());
        Set<String> result = new HashSet<>(a);
        result.retainAll(b != null ? b : Collections.emptySet());
        return result;
    }
}
