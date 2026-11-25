# claude-code-game-studios

- 上游：https://github.com/Donchitos/Claude-Code-Game-Studios
- 分类：AI ｜ 类型：skill
- 存放：常驻（技能目录）
- 用途：游戏工作室角色包，78 个岗位定义（设计/制作/测试）
- 运行：按需复制 .claude/agents 下角色到技能目录
- 按需拉取：`powershell -ExecutionPolicy Bypass -File scripts\fetch-project.ps1 -Name claude-code-game-studios`（默认临时目录，跑完 -Clean）
- 要转常驻：同上加 `-Keep`，落到 `D:\github专用仓库\plugins\claude-code-game-studios`
- 详细说明：暂无（见下方用途与运行）
- 返回总索引：[PROJECTS.md](../../PROJECTS.md)

---

存放规则：基础能力、高频或大用量才常驻 D 盘；其余按需拉取，用完清理。