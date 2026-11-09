# scrapling — 网页抓取框架

**上游**：https://github.com/D4Vinci/Scrapling
**备份**：https://github.com/un314/Scrapling（fork，含完整历史）
**本地**：`D:\github专用仓库\plugins\scrapling`
**类型**：Python 库 + 技能
**版本**：`c5121c7`

## 用途

支持快速 HTTP 请求、隐身浏览器、自适应解析和并发爬虫的 Python 抓取框架。

## 依赖

Python 3.10+。隐身浏览器需额外装 fetchers 与浏览器内核。

## 安装

```powershell
py -m pip install "scrapling[fetchers]"
scrapling install
```

## 运行 / 使用

```powershell
python -c "from scrapling.fetchers import StealthyFetcher; print(StealthyFetcher.fetch('https://example.com').status)"
```

## 验证

```powershell
python -c "import scrapling; print(scrapling.__version__)"
```

## 备注

技能已装入 ~/.trae-cn/skills/scrapling-official。本机 Python 为 3.15，部分依赖可能无预编译轮子，装不上时建议用 3.11/3.12 虚拟环境。

---

前置环境见仓库根 `README.md`；代码拉取失败时重跑 `bootstrap.ps1` 即可续传。