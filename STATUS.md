# 部署状态（2026-11-13）

## 仓库结构（已按规范重构）

| 项 | 说明 |
|---|---|
| 唯一仓库 | `plugin-vault`（不再为单个项目新建仓库） |
| 分类索引 | `categories/` 4 类：AI 17、资源 11、生活与科技 9、浏览器引擎 3 |
| 技能备份 | `skills/` 25 个（`my-skills` 内容已并入，原仓库仅留指向说明） |
| 清点总数 | 40 个项目，全部登记在 `manifest.json` |

## 本轮 7 个项目的部署结果

| 项目 | 本地 | 云端 | 可运行性 |
|---|---|---|---|
| awesome-design-md | ✅ 174 文件 | ✅ fork | 文档类，直接阅读 |
| build-your-own-x | ✅ 5 文件 | ✅ fork | 文档类，直接阅读 |
| awesome-selfhosted | ✅ 7 文件 | ✅ fork | 文档类，直接阅读 |
| awesome-llm-apps | ✅ 1993 文件 | ✅ fork | 子应用需各自装依赖 |
| ai-job-search | ✅ 318 文件 | ✅ fork | 需 Claude Code + 配置 |
| BettaFish | ✅ 294 文件 | ✅ fork | ⚠️ 需 Docker（本机未装） |
| MiroFish | ✅ 127 文件 | ✅ fork | ⚠️ 需 Docker（本机未装） |
| MoneyPrinterTurbo | ✅ 489 文件 + venv | ✅ fork | ✅ 依赖已装（streamlit/moviepy/edge_tts 导入通过） |
| lingbot-touch | ✅ 170 文件 | — （未新建仓库） | ⚠️ 需 `pip install -e .` 与模型权重 |

## 环境事实

- 无 Docker → BettaFish / MiroFish 无法用 docker-compose 启动
- ffmpeg 已装；Python 3.12（Astral）可用；Node 24 可用
- GitHub 直连仍不通；`codeload` 与 `api` 可通，git 协议需代理

## 云端运行时说明

本轮所有项目**只有代码托管**，没有公网访问地址。原因：这些项目（Python 服务、多智能体系统）需要一台云主机 + 域名 + 密钥，当前环境没有可用的云平台凭据。文档类项目可开 GitHub Pages，但仓库本身不是站点。

如需真正的云端访问地址，需要你提供其一：云服务器 SSH、Vercel/Cloudflare 账号授权、或 Docker 部署目标。
