# ziwei-doushu — 紫微斗数排盘引擎

**上游**：https://github.com/Renhuai123/ziwei-doushu
**备份**：https://github.com/un314/ziwei-doushu（fork，含完整历史）
**本地**：`D:\github专用仓库\plugins\ziwei-doushu`
**类型**：Node / Next.js 应用
**版本**：`7922285`

## 用途

基于倪海厦《天纪》体系的开源排盘引擎，含排盘算法、四化系统、格局知识库与古籍原文数据。

## 依赖

Node.js 20+。Next.js 应用。

## 安装

```powershell
cd "D:\github专用仓库\plugins\ziwei-doushu"
npm install
```

## 运行 / 使用

```powershell
npm run dev      # http://localhost:3000
npm run build; npm start   # 生产模式
npm test           # 22 个回归测试
```

## 验证

```powershell
Test-Path "D:\github专用仓库\plugins\ziwei-doushu\node_modules"
npm run typecheck
```

## 备注

13 维解读数据集需另从 Releases 下载（v4.0-13d），不在代码仓里。

---

前置环境见仓库根 `README.md`；代码拉取失败时重跑 `bootstrap.ps1` 即可续传。