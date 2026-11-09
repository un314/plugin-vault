# 部署状态（2026-11-09 21:50）

## 云端（GitHub）— 100% 完成

- 15 个上游全部 fork 到 `un314`，均为完整副本（服务端复制，含全部历史）
- `plugin-vault`：清单、15 份逐插件文档、`bootstrap.ps1`、`verify.ps1`
- `my-skills`：8 个技能已备份

## 本地 — 8 个完成

| 插件 | 体积 | 状态 |
|---|---|---|
| agency-agents | 6.6 MB | ✅ 技能已装（299 角色） |
| agile-pm-workflow | 0.1 MB | ✅ 技能已装 |
| android-ad-cleaner | 81.8 MB | ✅ 代码 + venv（Python 3.12 + uiautomator2） |
| frontend-design | 0 MB | ✅ 技能已装 |
| goutoujunshi | 2.4 MB | ✅ 技能已装 |
| Mineradio | 132 MB | ✅ 代码 + npm 依赖 |
| scrapling | 14.5 MB | ✅ 技能已装 |
| ziwei-doushu | 397.6 MB | ✅ 代码 + npm 依赖（next cli 就绪） |

## 本地 — 7 个未完成（约 1.4 GB）

`ecc`、`taste-skill`、`rea-video`、`Y2A-Auto`、`hello-agents`、`AiToEarn`、`OpenMausBot`

### 失败的实测证据

| 线路 | 实测结果 |
|---|---|
| `github.com:443` | 完全连不上（21s 超时） |
| `codeload.github.com` | 可连，约 23 KB/s，传输中途重置 |
| `gh-proxy.com` | 峰值 551 KB/s；支持 206 分段，但 512KB 块传一半即卡死 |
| `ghproxy.net` / `ghfast.top` / `gitclone.com` | 0 字节 / 502 |
| `gh.ddlc.top` | 429 限流 |
| 本机代理端口（7890/1080 等） | 无监听 |

结论：**不是配置错误，是链路不稳定**。已试过 git 克隆、zip 直下、并行、串行、分块续传五种方式，全部卡在传输中途。

## 恢复方法（有代理/VPN 时）

```powershell
# 方式一：一键（推荐，自动判断已完成项）
powershell -ExecutionPolicy Bypass -File D:\github专用仓库\plugin-vault\bootstrap.ps1

# 方式二：只补某一个
git clone --depth 1 https://github.com/un314/ECC.git "D:\github专用仓库\plugins\ecc"
```

VPN 开启后，1.4GB 预计 10–20 分钟可拉完。
