# ecc — everything-claude-code

**上游**：https://github.com/affaan-m/ECC
**备份**：https://github.com/un314/ECC（fork，含完整历史）
**本地**：`D:\github专用仓库\plugins\ecc`
**类型**：技能包 / Agent 增强
**版本**：`d2ef268`

## 用途

面向 Claude Code / Codex / Cursor 的 Agent 增强系统：技能、本能、记忆、安全与研究优先开发流程。

## 依赖

无（Markdown + 少量脚本）。

## 安装

```powershell
git clone --depth 1 https://github.com/un314/ECC.git "D:\github专用仓库\plugins\ecc"
Get-ChildItem "D:\github专用仓库\plugins\ecc"
```

## 运行 / 使用

```powershell
# 按仓库 README 选择需要的技能子目录，复制进 ~/.trae-cn/skills/
```

## 验证

```powershell
Test-Path "D:\github专用仓库\plugins\ecc\README.md"
```

## 备注

上游原名 everything-claude-code，已改名为 ECC。内容较多，建议只装需要的子技能。

---

前置环境见仓库根 `README.md`；代码拉取失败时重跑 `bootstrap.ps1` 即可续传。