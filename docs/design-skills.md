# 设计技能择优（2026-11-26）

四个同类技能只留一个：`impeccable`。

## 对比

| 技能 | 体量 | 覆盖范围 | 依赖 | 结论 |
|---|---|---|---|---|
| `impeccable` | SKILL.md 12.8KB + 63 个引用文件/2.2MB | 生成、重做、评审、审计、打磨、动效、设计系统；网页 + 产品 UI + iOS/Android | 自带引擎（首次运行自动下载，已实测 4.11.0 可跑） | **保留** |
| `taste-skill` | 381 行 + 自带建站脚本 | 只做公司官网/营销页，绑定 start.mjs/moments.mjs 流程 | Node 22 + 浏览器 + 脚本 | 停用 |
| `frontend-design` | 115 行 | 只给 8 种审美锚点，没有评审与验收 | 无 | 停用 |
| `frontend-skill` | 184 行 | 落地页/应用通用建议，规则较泛 | 无 | 停用 |
| `web-design-guidelines` | 39 行 | 只做 Vercel 规范审查，每次要联网取规则 | 联网 | 停用（审计能力已由 impeccable 的 audit/critique 覆盖） |

## 实际改动

- 新增 `skills/impeccable/`（Trae 专用构建，非整仓克隆，只取 2.2MB）。
- 四个旧技能已删除（本机与仓库均不再保留），git 历史可恢复。
- 验证：`skills\impeccable\scripts\impeccable.cmd --version` → `4.11.0`；`context` 能正常输出项目上下文。

## 怎么用

- 全新页面：`/impeccable shape`
- 只改现有界面：直接说「用 impeccable 审一下这个页面」
- 审查/打分：`/impeccable critique` 或 `/impeccable audit`
- 太土/太吵：`/impeccable bolder` / `quieter`

## 恢复旧技能

归档文件已按用户要求删除，但都留在 git 历史里，随时可捞回：

```powershell
cd D:\github专用仓库\plugin-vault
git log --oneline -- archive/skills-disabled          # 找到删除前的提交
git checkout <提交>^ -- archive/skills-disabled/taste-skill
Move-Item archive\skills-disabled\taste-skill skills\
```
