# 部署状态（2026-11-12）

## 环境

| 项 | 状态 |
|---|---|
| Node.js | ✅ v24.22.1 / npm 11.19.1 |
| Python | ⚠️ 仅 3.15（`python` 是商店占位符）与 Astral 3.12；须用 `py` 启动器 |
| Git | ✅ 2.56.0 |
| GitHub CLI | ✅ v2.103.3，账号 `un314` |
| 代理 | ✅ Clash Verge，`127.0.0.1:7897`，已写入 git 全局配置 |
| GitHub 直连 | ❌ 不通；**必须走代理** |

## 本地插件：31 个，全部克隆成功

### 本轮补齐的 22 个（此前因网络失败）

`ecc`、`taste-skill`、`rea-video`、`Y2A-Auto`、`hello-agents`、`AiToEarn`、`OpenMausBot`、`openspec`、`bmad-method`、`superpowers`、`aider`、`gpt-engineer`、`spec-kit`、`claude-code-game-studios`、`awesome-remote-job`、`awesome-telegram-groups`、`awesome-n8n-templates`、`awesome-quant`、`awesome-public-datasets`、`obscura`、`lightpanda`、`ego-lite`

### 已在 Trae 生效的技能（共 24 个）

- 本轮新增：`superpowers` 全家桶 15 个（brainstorming、test-driven-development、systematic-debugging、writing-plans、executing-plans、dispatching-parallel-agents、requesting-code-review、receiving-code-review、verification-before-completion、using-git-worktrees、finishing-a-development-branch、subagent-driven-development、writing-skills、using-superpowers、diagnosing-superpowers）
- 本轮新增：`taste-skill`
- 之前：`agency-agents`、`agile-pm-workflow`、`frontend-design`、`goutoujunshi`、`scrapling-official`、`newshub`、`uipath-studio-automation`、`uipath-exam-env-setup`、`rpa-yinqi-reconciliation`

## 未安装依赖的项（代码已就位，按需再装）

| 插件 | 原因 |
|---|---|
| `aider` / `gpt-engineer` / `spec-kit` / `bmad-method` | Python 项目，需 pip 安装；本机 Python 3.15 兼容性未验证 |
| `openspec` / `ego-lite` / `AiToEarn` / `OpenMausBot` | Node 项目，依赖体积大，按需 `npm install` |
| `obscura` / `lightpanda` | 需 Rust / Zig 工具链，本机未安装 |
| `ecc`（1068 个技能）/ `claude-code-game-studios`（78 个角色） | 体量大，未全量装入技能目录，可按需挑选 |

## 云端

- 之前 16 个仓库已 fork 到 `un314`
- 本轮 15 个**未 fork**，仅 Star + 记录在 `manifest.json`（如需完整云端副本，告诉我，服务端 fork 很快）
- `plugin-vault`：31 条清单 + 分类方案 + 一键恢复脚本

## 恢复方法

```powershell
# 先开代理（Clash 7897），git 已配置全局代理
powershell -ExecutionPolicy Bypass -File D:\github专用仓库\plugin-vault\bootstrap.ps1
```
