# Y2A-Auto — YouTube 搬运到 A/B 站

**上游**：https://github.com/fqscfqj/Y2A-Auto
**备份**：https://github.com/un314/Y2A-Auto（fork，含完整历史）
**本地**：`D:\github专用仓库\plugins\Y2A-Auto`
**类型**：Python
**版本**：`c5ce9f6`

## 用途

YouTube 到 AcFun / bilibili 的自动化搬运工具，支持 AI 翻译、字幕生成、内容审核与智能监控。

## 依赖

Python 3.10+、ffmpeg、各平台 Cookie。

## 安装

```powershell
cd "D:\github专用仓库\plugins\Y2A-Auto"
py -m venv .venv
.\.venv\Scripts\pip install -r requirements.txt
```

## 运行 / 使用

```powershell
.\.venv\Scripts\python main.py   # 入口以仓库 README 为准
```

## 验证

```powershell
ffmpeg -version
```

## 备注

你给的原始地址 fgscfai/Y2A-Auto 不存在，已按 fqscfqj/Y2A-Auto 部署。搬运内容需遵守平台版权规则。

---

前置环境见仓库根 `README.md`；代码拉取失败时重跑 `bootstrap.ps1` 即可续传。