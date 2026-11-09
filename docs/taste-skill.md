# taste-skill — 给编码 Agent 审美

**上游**：https://github.com/Leonxlnx/taste-skill
**备份**：https://github.com/un314/taste-skill（fork，含完整历史）
**本地**：`D:\github专用仓库\plugins\taste-skill`
**类型**：技能
**版本**：`f6b7657`

## 用途

让编码 Agent 产出有设计感的页面：艺术指导、参考图、浏览器自查，替代通用的 AI 风页面。

## 依赖

无（Markdown 技能）。

## 安装

```powershell
$src = Get-ChildItem "D:\github专用仓库\plugins\taste-skill" -Recurse -Filter SKILL.md | Select-Object -First 1
Copy-Item $src.Directory.FullName "$env:USERPROFILE\.trae-cn\skills\taste-skill" -Recurse -Force
```

## 运行 / 使用

```powershell
# 在 Trae 里说：「按 taste-skill 的标准做一个落地页」
```

## 验证

```powershell
Test-Path "$env:USERPROFILE\.trae-cn\skills\taste-skill\SKILL.md"
```

## 备注

仓库约 104MB，大头是参考图。

---

前置环境见仓库根 `README.md`；代码拉取失败时重跑 `bootstrap.ps1` 即可续传。