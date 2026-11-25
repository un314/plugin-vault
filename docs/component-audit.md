# 组件盘点（2026-11-26）

## 本机现状

| 组件 | 状态 | 版本 |
|---|---|---|
| Node / npm | 已装 | 24.22.1 / 11.19.1 |
| Python | 已装 | 3.15.2；另有 Astral 3.12.13（uv 自带，未进 PATH） |
| Git | 已装 | 2.56.0 |
| ffmpeg | 已装 | 9.0.2 |
| Ollama | 已装 | 0.40.16，已有模型 qwen2.5:3b（1.9GB） |
| winget | 已装 | 1.29.380 |
| Docker | **未装** | — |
| Go / Rust | **未装** | — |
| Android SDK / adb | **未装** | — |

磁盘：C 盘只剩 **4.1GB**，D 盘 231GB。这是本轮最关键的限制。

## 结论：不装新组件

- Docker Desktop 装完至少占 3GB 且要 WSL2 + 重启，C 盘放不下 → 所有容器类项目留云端。
- Go / Rust 只为编译个别项目（goink、craft-anything、rust-anything），它们都有现成 Release 或 npm/pip 包，用到再取。
- Ollama 已装，本地模型能力可用；但模型默认落在 C 盘，建议把 `OLLAMA_MODELS` 指到 D 盘再拉新模型。

## 按项目分类

| 类别 | 项目 | 本机能否直接跑 |
|---|---|---|
| 纯技能（Markdown） | impeccable、nuwa、darwin、superpowers、agency-agents 等 | ✅ 直接可用 |
| 文档/清单 | awesome、public-apis、free-for-dev、awesome-* | ✅ 直接读 |
| Python 脚本 | douyin-downloader、wechat-intelligence-hub、ARIS 技能脚本 | ✅ 装少量依赖即可 |
| 本地模型 | ollama + qwen2.5:3b | ✅ 已可用（注意 C 盘） |
| 需 Docker | dify、open-webui、openhands、loopforge、BettaFish、MiroFish、OpenMAIC | ❌ 留云端 |
| 需编译 | goink（有 Release）、anydoc（有 npm/pip 包）、craft-anything、rust-anything | ⚠️ 用到再取 |
| 需模型权重 | lingbot-touch | ❌ 留云端 |
| 手机端 | komi-store（APK） | ⚠️ 装手机，不占电脑 |

## 已执行的调整

1. ✅ Ollama 模型已迁到 D 盘（2026-11-26）：设置用户环境变量 `OLLAMA_MODELS=D:\ollama-models`，原 `C:\Users\dizey\.ollama\models`（1.8GB）整体移动；C 盘可用从 4.11GB 升到 5.9GB；服务重启后 `qwen2.5:3b` 正常可读，新拉取的模型块写入 D 盘。
2. 若确实要跑 Dify / Open WebUI 多 Agent 工作台，优先装在 D 盘（Docker 数据目录也改到 D），或直接用官方云版。
3. 其余按 `docs/on-demand-skills.md` 的方式按需取，不常驻。
