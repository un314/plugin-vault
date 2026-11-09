# Plugins Vault — 插件本地部署与云端备份

15 个 GitHub 插件的**一仓管理**：代码在 GitHub 有完整副本（fork），本地有可运行副本，换机只需三步。

## 换机恢复（3 步）

```powershell
# 1. 克隆本仓库
git clone https://github.com/un314/plugin-vault.git D:\github专用仓库\plugin-vault

# 2. 一键拉取全部插件代码并安装依赖
powershell -ExecutionPolicy Bypass -File D:\github专用仓库\plugin-vault\bootstrap.ps1

# 3. 校验
powershell -ExecutionPolicy Bypass -File D:\github专用仓库\plugin-vault\verify.ps1
```

前置：Node.js ≥ 20、Git、Python 3.11+（用 `py` 启动器）、可选 pnpm。脚本会自动检测缺失项并提示。

## 目录约定

| 路径 | 内容 |
|---|---|
| `D:\github专用仓库\plugins\<name>\` | 每个插件一个文件夹，均为独立 git 仓库，`origin` 指向你自己的 fork |
| `~/.trae-cn/skills\<skill>\` | 技能类插件的实际生效位置 |
| `plugin-vault\manifest.json` | 机器可读清单：上游、fork、commit、类型、安装方式 |
| `plugin-vault\docs\<name>.md` | 每个插件的部署说明 |
| `plugin-vault\bootstrap.ps1` | 换机一键恢复（可重复执行，已完成的自动跳过） |
| `plugin-vault\verify.ps1` | 可用性校验，输出表格 |

## 备份策略

- **云端**：全部 15 个上游已 fork 到 `un314`，服务端复制，含完整历史，不占本地带宽。
- **本地**：浅克隆（`--depth 1`）到 `D:\github专用仓库\plugins`，`origin` 指回自己的 fork，可正常 `pull` / `push`。
- **技能**：技能类插件额外复制到 `~/.trae-cn/skills`，这是 Trae 实际加载的位置。

## 插件清单

| 插件 | 类型 | 上游 | 说明 |
|---|---|---|---|
| hello-agents | 教程 | datawhalechina/hello-agents | 《从零开始构建智能体》 |
| OpenMausBot | Node | milind-soni/OpenMausBot | 带虚拟机的开源 Bot |
| ziwei-doushu | Node | Renhuai123/ziwei-doushu | 紫微斗数排盘引擎 |
| android-ad-cleaner | Python | rddmwmddr/android-ad-cleaner | 免 root 关安卓广告 |
| agency-agents | 技能 | msitarzewski/agency-agents | 299 个专业角色 |
| scrapling | Python+技能 | D4Vinci/Scrapling | 网页抓取框架 |
| goutoujunshi | 技能 | shengjidaguai-china/goutoujunshi | 恋爱军师 |
| AiToEarn | Node | yikart/AiToEarn | AI 内容多平台发布 |
| Y2A-Auto | Python | fqscfqj/Y2A-Auto | YouTube 搬运到 A/B 站 |
| Mineradio | Node | XxHuberrr/Mineradio | 沉浸式音乐播放器 |
| taste-skill | 技能 | Leonxlnx/taste-skill | 给 Agent 审美 |
| agile-pm-workflow | 技能 | chyxin071-sys/Agile-PM-Workflow | 敏捷 PM 七步工作流 |
| frontend-design | 技能 | Ilm-Alan/frontend-design | 前端审美锚点 |
| ecc | 技能 | affaan-m/ECC | everything-claude-code |
| rea-video | Python | JuneYaooo/rea-video | 逐镜头逆向视频 |

## 注意

- `Mineradio` 上游已改名 `Mineradio-paused`，本仓库沿用该名称。
- `Y2A-Auto` 原始给到的 `fgscfai` 不存在，实际为 `fqscfqj`。
- `everything-claude-code` 上游已改名 `ECC`。
- 所有仓库均为他人作品，许可见各自 `LICENSE`；本仓库只做备份与部署记录，不改变授权。
