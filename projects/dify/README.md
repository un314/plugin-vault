# dify

- 上游：https://github.com/langgenius/dify
- 分类：AI ｜ 类型：python
- 存放：按需（未下载）
- 用途：Agentic 工作流 + RAG 知识库平台，可自托管
- 运行：docker compose up -d（官方 compose，需 Docker）
- 按需拉取：`powershell -ExecutionPolicy Bypass -File scripts\fetch-project.ps1 -Name dify`（默认临时目录，跑完 -Clean）
- 要转常驻：同上加 `-Keep`，落到 `D:\github专用仓库\plugins\dify`
- 详细说明：暂无（见下方用途与运行）
- 返回总索引：[PROJECTS.md](../../PROJECTS.md)

---

存放规则：基础能力、高频或大用量才常驻 D 盘；其余按需拉取，用完清理。