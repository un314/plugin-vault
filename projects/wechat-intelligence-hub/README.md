# wechat-intelligence-hub

- 上游：https://github.com/Rion-Wu-tech/wechat-intelligence-hub
- 分类：AI ｜ 类型：python
- 存放：按需（未下载）
- 用途：本地优先的微信情报库，含 wechat-cli 与情报库两个技能
- 运行：见仓库 docs，先跑 wechat-cli 建索引
- 按需拉取：`powershell -ExecutionPolicy Bypass -File scripts\fetch-project.ps1 -Name wechat-intelligence-hub`（默认临时目录，跑完 -Clean）
- 要转常驻：同上加 `-Keep`，落到 `D:\github专用仓库\plugins\wechat-intelligence-hub`
- 详细说明：暂无（见下方用途与运行）
- 返回总索引：[PROJECTS.md](../../PROJECTS.md)

---

存放规则：基础能力、高频或大用量才常驻 D 盘；其余按需拉取，用完清理。