# agency-agents — 299 个专业角色

**上游**：https://github.com/msitarzewski/agency-agents
**备份**：https://github.com/un314/agency-agents（fork，含完整历史）
**本地**：`D:\github专用仓库\plugins\agency-agents`
**类型**：技能包
**版本**：`8ae6164`

## 用途

299 个角色定义，覆盖工程、设计、营销、财务、产品、研究、安全等 19 个部门，每个角色带人格、流程和交付标准。

## 依赖

无。纯 Markdown。

## 安装

```powershell
# 已安装到 Trae 技能目录，无需重复操作
Get-ChildItem "$env:USERPROFILE\.trae-cn\skills\agency-agents\references"
```

## 运行 / 使用

```powershell
# 在 Trae 里直接说：
# 「用前端专家帮我重构这个组件」
# 「以安全审计员视角看这段代码」
```

## 验证

```powershell
(Get-ChildItem "$env:USERPROFILE\.trae-cn\skills\agency-agents\references" -Recurse -Filter *.md | Measure-Object).Count   # 期望 299
```

## 备注

已按部门整理为 references/<division>/。一次只用 1–2 个角色，避免立场冲突。

---

前置环境见仓库根 `README.md`；代码拉取失败时重跑 `bootstrap.ps1` 即可续传。