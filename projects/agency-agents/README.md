# agency-agents

- 上游：https://github.com/msitarzewski/agency-agents
- 分类：AI ｜ 类型：skill
- 存放：常驻（技能目录）
- 用途：299 个专业角色代理，覆盖 19 个部门
- 运行：已装入 ~/.trae-cn/skills/agency-agents，直接说「用 XX 专家帮我」
- 按需拉取：`powershell -ExecutionPolicy Bypass -File scripts\fetch-project.ps1 -Name agency-agents`（默认临时目录，跑完 -Clean）
- 要转常驻：同上加 `-Keep`，落到 `D:\github专用仓库\plugins\agency-agents`
- 详细说明：[docs/agency-agents.md](../../docs/agency-agents.md)
- 返回总索引：[PROJECTS.md](../../PROJECTS.md)

---

存放规则：基础能力、高频或大用量才常驻 D 盘；其余按需拉取，用完清理。