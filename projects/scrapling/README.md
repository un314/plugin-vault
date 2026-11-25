# scrapling

- 上游：https://github.com/D4Vinci/Scrapling
- 分类：资源 ｜ 类型：python
- 存放：常驻（D 盘）
- 用途：网页抓取框架（抗反爬 + 隐身浏览器）
- 运行：pip install scrapling && scrapling install
- 按需拉取：`powershell -ExecutionPolicy Bypass -File scripts\fetch-project.ps1 -Name scrapling`（默认临时目录，跑完 -Clean）
- 要转常驻：同上加 `-Keep`，落到 `D:\github专用仓库\plugins\scrapling`
- 详细说明：[docs/scrapling.md](../../docs/scrapling.md)
- 返回总索引：[PROJECTS.md](../../PROJECTS.md)

---

存放规则：基础能力、高频或大用量才常驻 D 盘；其余按需拉取，用完清理。