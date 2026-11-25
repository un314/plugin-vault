# ecc

- 上游：https://github.com/affaan-m/ECC
- 分类：AI ｜ 类型：skill
- 存放：常驻（技能目录）
- 用途：everything-claude-code：技能、记忆、安全、研究优先的 Agent 增强包
- 运行：克隆后按 README 选择要装的技能子目录
- 按需拉取：`powershell -ExecutionPolicy Bypass -File scripts\fetch-project.ps1 -Name ecc`（默认临时目录，跑完 -Clean）
- 要转常驻：同上加 `-Keep`，落到 `D:\github专用仓库\plugins\ecc`
- 详细说明：[docs/ecc.md](../../docs/ecc.md)
- 返回总索引：[PROJECTS.md](../../PROJECTS.md)

---

存放规则：基础能力、高频或大用量才常驻 D 盘；其余按需拉取，用完清理。