# AiToEarn — AI 内容多平台发布

**上游**：https://github.com/yikart/AiToEarn
**备份**：https://github.com/un314/AiToEarn（fork，含完整历史）
**本地**：`D:\github专用仓库\plugins\AiToEarn`
**类型**：Node / pnpm monorepo
**版本**：`47e5a6f`

## 用途

AI 内容创作与多平台发布平台（TypeScript monorepo）。

## 依赖

Node.js 20+、pnpm 9+、可能需 Docker（数据库）。

## 安装

```powershell
npm i -g pnpm
cd "D:\github专用仓库\plugins\AiToEarn"
pnpm install
```

## 运行 / 使用

```powershell
pnpm dev    # 具体脚本以根 package.json 为准
```

## 验证

```powershell
Test-Path "D:\github专用仓库\plugins\AiToEarn\node_modules"
```

## 备注

仓库约 376MB，monorepo 依赖较多。运行通常还需配置数据库与第三方平台密钥。

---

前置环境见仓库根 `README.md`；代码拉取失败时重跑 `bootstrap.ps1` 即可续传。