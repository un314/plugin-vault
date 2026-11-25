# open-webui

- 上游：https://github.com/open-webui/open-webui
- 分类：AI ｜ 类型：node
- 存放：按需（未下载）
- 用途：多模型 Web 工作台，可接 Ollama 或任意 OpenAI 兼容接口
- 运行：docker run -d -p 3000:8080 open-webui/open-webui
- 按需拉取：`powershell -ExecutionPolicy Bypass -File scripts\fetch-project.ps1 -Name open-webui`（默认临时目录，跑完 -Clean）
- 要转常驻：同上加 `-Keep`，落到 `D:\github专用仓库\plugins\open-webui`
- 详细说明：暂无（见下方用途与运行）
- 返回总索引：[PROJECTS.md](../../PROJECTS.md)

---

存放规则：基础能力、高频或大用量才常驻 D 盘；其余按需拉取，用完清理。