# Y2A-Auto

- 上游：https://github.com/fqscfqj/Y2A-Auto
- 分类：生活与科技 ｜ 类型：python
- 存放：常驻（D 盘）
- 用途：YouTube 到 AcFun/B站 自动化搬运，含 AI 翻译与字幕
- 运行：py -m venv .venv 后按 docs/Y2A-Auto.md 安装，需要 ffmpeg
- 按需拉取：`powershell -ExecutionPolicy Bypass -File scripts\fetch-project.ps1 -Name Y2A-Auto`（默认临时目录，跑完 -Clean）
- 要转常驻：同上加 `-Keep`，落到 `D:\github专用仓库\plugins\Y2A-Auto`
- 详细说明：[docs/Y2A-Auto.md](../../docs/Y2A-Auto.md)
- 返回总索引：[PROJECTS.md](../../PROJECTS.md)

---

存放规则：基础能力、高频或大用量才常驻 D 盘；其余按需拉取，用完清理。