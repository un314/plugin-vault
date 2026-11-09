# frontend-design — 前端审美锚点

**上游**：https://github.com/Ilm-Alan/frontend-design
**备份**：https://github.com/un314/frontend-design（fork，含完整历史）
**本地**：`D:\github专用仓库\plugins\frontend-design`
**类型**：技能
**版本**：`f8966e6`

## 用途

八个审美锚点，每个锁定一套配色、字体、结构与质感的 CSS token，按 brief 选一个贯穿到底。

## 依赖

无。

## 安装

```powershell
# 已安装到 Trae 技能目录
Test-Path "$env:USERPROFILE\.trae-cn\skills\frontend-design\SKILL.md"
```

## 运行 / 使用

```powershell
# 在 Trae 里说：「用 frontend-design 的某个锚点做这个页面」
```

## 验证

```powershell
Get-Content "$env:USERPROFILE\.trae-cn\skills\frontend-design\SKILL.md" -TotalCount 3
```

## 备注

与 taste-skill 功能相近，二者可择一使用，避免风格指令互相冲突。

---

前置环境见仓库根 `README.md`；代码拉取失败时重跑 `bootstrap.ps1` 即可续传。