# OpenMausBot — 带虚拟机的开源 Bot

**上游**：https://github.com/milind-soni/OpenMausBot
**备份**：https://github.com/un314/OpenMausBot（fork，含完整历史）
**本地**：`D:\github专用仓库\plugins\OpenMausBot`
**类型**：Node / TypeScript 应用
**版本**：`1de1164`

## 用途

开源 Grok Bot 替代品，Bot 可操作一台虚拟机。TypeScript 实现。

## 依赖

Node.js 20+、npm/pnpm。仓库约 484MB，含较多静态资源。

## 安装

```powershell
git clone --depth 1 https://github.com/un314/OpenMausBot.git "D:\github专用仓库\plugins\OpenMausBot"
cd "D:\github专用仓库\plugins\OpenMausBot"
npm install
```

## 运行 / 使用

```powershell
npm run dev    # 具体脚本以仓库 package.json 为准
```

## 验证

```powershell
Test-Path "D:\github专用仓库\plugins\OpenMausBot\node_modules"
```

## 备注

体积最大的一个，网络差时优先用 bootstrap.ps1 分段拉。首次运行通常还需要配置模型 API Key，见仓库 .env.example。

---

前置环境见仓库根 `README.md`；代码拉取失败时重跑 `bootstrap.ps1` 即可续传。