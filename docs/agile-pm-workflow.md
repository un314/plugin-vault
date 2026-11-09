# agile-pm-workflow — 敏捷 PM 七步工作流

**上游**：https://github.com/chyxin071-sys/Agile-PM-Workflow
**备份**：https://github.com/un314/Agile-PM-Workflow（fork，含完整历史）
**本地**：`D:\github专用仓库\plugins\agile-pm-workflow`
**类型**：技能
**版本**：`a4d9c14`

## 用途

七步走完需求全过程：对话式采集 → PRD 骨架 → HTML 原型 → Mermaid 流程图 → 内嵌原型的最终 PRD → 版本迭代，每步强制等你确认。

## 依赖

无。

## 安装

```powershell
# 已安装到 Trae 技能目录
Test-Path "$env:USERPROFILE\.trae-cn\skills\agile-pm-workflow\SKILL.md"
```

## 运行 / 使用

```powershell
# 在 Trae 里说：「我想做一个记账小程序，帮月光族控制外卖支出」
```

## 验证

```powershell
Get-ChildItem "$env:USERPROFILE\.trae-cn\skills\agile-pm-workflow" -Recurse -File | Measure-Object
```

## 备注

templates/ 下已放 prd_template.md、pm_workflow_definition.md、README.md。

---

前置环境见仓库根 `README.md`；代码拉取失败时重跑 `bootstrap.ps1` 即可续传。