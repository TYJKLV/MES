package com.wangziyang.mes.technology.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.wangziyang.mes.common.BaseController;
import com.wangziyang.mes.common.Result;
import com.wangziyang.mes.technology.entity.SpBomItem;
import com.wangziyang.mes.technology.service.ISpBomItemService;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/technology/bomItem")
public class SpBomItemController extends BaseController {

    @Autowired
    private ISpBomItemService spBomItemService;

    /** BOM子项管理页面 */
    @GetMapping("/list-ui")
    public String listUI(Model model, @RequestParam String bomHeadId) {
        model.addAttribute("bomHeadId", bomHeadId);
        return "technology/bom/bomItemList";
    }

    /** BOM子项分页查询（平铺列表） */
    @PostMapping("/page")
    @ResponseBody
    public Result page(@RequestParam String bomHeadId) {
        QueryWrapper<SpBomItem> qw = new QueryWrapper<>();
        qw.eq("bom_head_id", bomHeadId);
        qw.orderByAsc("line_no");
        List<SpBomItem> list = spBomItemService.list(qw);
        return Result.success(list);
    }

    /** BOM树形结构数据 */
    @GetMapping("/tree/{bomHeadId}")
    @ResponseBody
    public Result tree(@PathVariable String bomHeadId) {
        QueryWrapper<SpBomItem> qw = new QueryWrapper<>();
        qw.eq("bom_head_id", bomHeadId);
        qw.orderByAsc("line_no");
        List<SpBomItem> allItems = spBomItemService.list(qw);
        List<SpBomItem> roots = allItems.stream()
                .filter(i -> StringUtils.isEmpty(i.getParentItemId()))
                .collect(Collectors.toList());
        List<TreeNode> tree = new ArrayList<>();
        for (SpBomItem root : roots) {
            tree.add(buildTreeNode(root, allItems));
        }
        return Result.success(tree);
    }

    private TreeNode buildTreeNode(SpBomItem item, List<SpBomItem> allItems) {
        TreeNode node = new TreeNode(item);
        List<SpBomItem> children = allItems.stream()
                .filter(i -> item.getId().equals(i.getParentItemId()))
                .collect(Collectors.toList());
        for (SpBomItem child : children) {
            node.getChildren().add(buildTreeNode(child, allItems));
        }
        return node;
    }

    /** 树节点 DTO */
    public static class TreeNode {
        private String id;
        private String materielItemCode;
        private String materielItemDesc;
        private String itemNum;
        private String itemUnit;
        private String lineNo;
        private String parentItemId;
        private List<TreeNode> children = new ArrayList<>();

        public TreeNode(SpBomItem item) {
            this.id = item.getId();
            this.materielItemCode = item.getMaterielItemCode();
            this.materielItemDesc = item.getMaterielItemDesc();
            this.itemNum = item.getItemNum() != null ? item.getItemNum().toPlainString() : "";
            this.itemUnit = item.getItemUnit();
            this.lineNo = item.getLineNo();
            this.parentItemId = item.getParentItemId();
        }

        public String getId() { return id; }
        public String getMaterielItemCode() { return materielItemCode; }
        public String getMaterielItemDesc() { return materielItemDesc; }
        public String getItemNum() { return itemNum; }
        public String getItemUnit() { return itemUnit; }
        public String getLineNo() { return lineNo; }
        public String getParentItemId() { return parentItemId; }
        public List<TreeNode> getChildren() { return children; }
    }
}
