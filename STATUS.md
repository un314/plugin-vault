# 部署状态（2026-11-25）

## 仓库结构

| 项 | 说明 |
|---|---|
| 唯一仓库 | `plugin-vault`（不再为单个项目新建仓库） |
| 分类索引 | `categories/` 4 类：AI 34、资源 16、生活与科技 12、浏览器引擎 3 |
| 技能备份 | `skills/` 43 个（`my-skills` 内容已并入；本机目录是指向此处的 junction） |
| 清点总数 | 65 个项目，全部登记在 `manifest.json` |

## 2026-11 批次（开源项目与技能仓库盘点）

新增 25 条登记，详见 `docs/batch-2026-11.md`。其中两个技能已落地可用：

| 技能 | 来源 | 状态 |
|---|---|---|
| `nuwa-skill` | alchaincyf/nuwa-skill | ✅ 已就位，可直接触发 |
| `darwin-skill` | alchaincyf/darwin-skill | ✅ 已就位，可直接触发 |

其余（dify / open-webui / ollama / ARIS / scientific-agent-skills 等）仅登记上游与运行方式，未镜像代码：ARIS 38MB、科学技能库 471MB、Dify 与 Open WebUI 均为数百 MB，整包进仓库会让备份失去意义。

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
