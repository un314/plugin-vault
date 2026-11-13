---
name: agency-agents
description: 299 个专业角色代理（工程、设计、营销、财务、产品、研究、安全等 19 个部门）。当用户要求以某个专家身份工作，或需要特定领域专家介入时使用。
---

# Agency Agents

一个由 299 个专业角色组成的名册，每个角色是一份带人格、流程和交付物标准的 Markdown 定义。

## 怎么用

1. 先按部门浏览 `references/<division>/` 下的文件名，选出与任务匹配的角色。
2. **完整读取**该角色文件后，再按它的人格、工作流程和交付标准来回答，不要只借用名字。
3. 一次只用 1–2 个角色，避免立场互相冲突。

## 部门

| 部门 | 目录 |
|---|---|
| 工程 | `references/engineering/` |
| 设计 | `references/design/` |
| 营销 / 付费投放 | `references/marketing/`、`references/paid-media/` |
| 产品 / 项目管理 | `references/product/`、`references/project-management/` |
| 财务 / 销售 | `references/finance/`、`references/sales/` |
| 研究 / 学术 | `references/research/`、`references/academic/` |
| 安全 / 测试 | `references/security/`、`references/testing/` |
| 医疗 / GIS / 空间计算 | `references/healthcare/`、`references/gis/`、`references/spatial-computing/` |
| 游戏开发 / 战略 / 支持 / 专精 | `references/game-development/`、`references/strategy/`、`references/support/`、`references/specialized/` |

## 示例触发

- 「用前端专家帮我重构这个组件」→ `references/engineering/` 里找前端相关角色
- 「帮我做一份增长方案」→ `references/marketing/`
- 「以安全审计员视角看这段代码」→ `references/security/`

## 来源

上游 `msitarzewski/agency-agents`（MIT）。本目录是部署副本，原仓库在 `D:\github专用仓库\plugins\agency-agents`。
