<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>工艺路线可视化</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: "Microsoft YaHei", sans-serif; background: #f5f6f7; padding: 20px; }

        .flow-header {
            background: #fff; border-radius: 6px; padding: 16px 20px; margin-bottom: 20px;
            box-shadow: 0 1px 4px rgba(0,0,0,.08);
        }
        .flow-header h3 { font-size: 18px; color: #1E9FFF; margin-bottom: 10px; }
        .flow-header .info-row { display: flex; gap: 30px; flex-wrap: wrap; font-size: 13px; color: #666; }
        .flow-header .info-row span strong { color: #333; }

        .flow-container { overflow-x: auto; padding: 20px 0; }
        .flow-chain { display: flex; align-items: center; min-width: max-content; padding: 0 40px; }

        .oper-node {
            background: #fff; border-radius: 8px; padding: 14px 18px; min-width: 150px;
            box-shadow: 0 2px 8px rgba(0,0,0,.1); text-align: center; position: relative;
            border-top: 4px solid #1E9FFF; transition: transform .2s;
        }
        .oper-node:hover { transform: translateY(-3px); box-shadow: 0 4px 16px rgba(0,0,0,.15); }
        .oper-node.first { border-top-color: #5FB878; }
        .oper-node.last { border-top-color: #FF5722; }

        .oper-node .oper-name { font-size: 16px; font-weight: bold; color: #333; margin-bottom: 6px; }
        .oper-node .oper-code { font-size: 12px; color: #999; margin-bottom: 6px; }
        .oper-node .oper-detail { font-size: 12px; color: #666; line-height: 1.6; }
        .oper-node .oper-detail .wc { color: #1E9FFF; }

        .arrow { flex-shrink: 0; width: 60px; text-align: center; position: relative; }
        .arrow .line { height: 2px; background: #ccc; position: relative; top: 50%; }
        .arrow .head {
            width: 0; height: 0; border-top: 7px solid transparent; border-bottom: 7px solid transparent;
            border-left: 10px solid #ccc; position: absolute; right: -2px; top: 50%; transform: translateY(-50%);
        }
        .arrow .label { font-size: 11px; color: #999; position: absolute; top: -18px; left: 50%; transform: translateX(-50%); white-space: nowrap; }

        .start-node, .end-node {
            flex-shrink: 0; width: 60px; height: 60px; border-radius: 50%; display: flex;
            align-items: center; justify-content: center; font-size: 12px; font-weight: bold; color: #fff;
        }
        .start-node { background: #5FB878; }
        .end-node { background: #FF5722; }

        .no-data { text-align: center; padding: 60px 0; color: #999; font-size: 16px; }
    </style>
</head>
<body>

<#if flow??>
<div class="flow-header">
    <h3>${flow.flow!} - ${flow.flowDesc!}</h3>
    <div class="info-row">
        <span><strong>版本：</strong>${flow.version!'-'}</span>
        <span><strong>审核状态：</strong>
            <#if flow.state == 'pass'><span style="color:#5FB878;">已定版</span>
            <#elseif flow.state == 'creat'><span style="color:#FFB800;">创建</span>
            <#else>${flow.state!}</#if>
        </span>
        <span><strong>关联物料：</strong>
            <#if materials?? && materials?size gt 0>
                <#list materials as m>${m.materiel!} - ${m.materielDesc!}<#if m_has_next>; </#if></#list>
            <#else>无
            </#if>
        </span>
    </div>
</div>
<#else>
<div class="flow-header"><h3>工艺路线不存在</h3></div>
</#if>

<div class="flow-container">
<#if operDetails?? && operDetails?size gt 0>
    <div class="flow-chain">
        <div class="start-node">开始</div>
        <div class="arrow"><div class="line"><div class="head"></div></div></div>

        <#list operDetails as detail>
        <div class="oper-node<#if detail.relation.operType?? && detail.relation.operType == 'firstOper'> first<#elseif detail.relation.operType?? && detail.relation.operType == 'lastOper'> last</#if>">
            <div class="oper-name">
                <#if detail.oper??>${detail.oper.oper!}</#if>
            </div>
            <div class="oper-code">
                <#if detail.oper??>${detail.oper.operCode!}</#if>
            </div>
            <div class="oper-detail">
                <#if detail.oper?? && detail.oper.manHours??>
                    工时：${detail.oper.manHours!} 分钟<br>
                </#if>
                <#if detail.workcell??>
                    加工单元：<span class="wc">${detail.workcell.name!}</span>
                <#else>
                    加工单元：<span style="color:#ccc;">未分配</span>
                </#if>
            </div>
        </div>
        <#if detail_has_next>
        <div class="arrow">
            <div class="line"><div class="head"></div></div>
            <#if detail.relation.sortNum?? && detail.relation.nextOper??>
            <div class="label">步骤${detail.relation.sortNum}</div>
            </#if>
        </div>
        </#if>
        </#list>

        <div class="arrow"><div class="line"><div class="head"></div></div></div>
        <div class="end-node">结束</div>
    </div>
<#else>
    <div class="no-data">该工艺路线下暂无工序数据</div>
</#if>
</div>

</body>
</html>
