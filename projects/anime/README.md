# anime

- 上游：https://github.com/juliangarnier/anime
- 分类：资源 ｜ 类型：node
- 存放：常驻（D 盘）
- 用途：anime.js v4 动画引擎（JS/CSS/SVG/WebGL 通用动画库）
- 运行：npm install && npm run build（产物在 dist/；示例 npm run open:examples）
- 按需拉取：`powershell -ExecutionPolicy Bypass -File scripts\fetch-project.ps1 -Name anime`（默认临时目录，跑完 -Clean）
- 要转常驻：同上加 `-Keep`，落到 `D:\github专用仓库\plugins\anime`
- 详细说明：[docs/anime.md](../../docs/anime.md)
- 返回总索引：[PROJECTS.md](../../PROJECTS.md)

---

存放规则：基础能力、高频或大用量才常驻 D 盘；其余按需拉取，用完清理。