# douyin-downloader

- 上游：https://github.com/jiji262/douyin-downloader
- 分类：生活与科技 ｜ 类型：python
- 存放：按需（未下载）
- 用途：抖音批量下载：视频、图集、合集、音乐，带去重与断点重试
- 运行：pip install -r requirements.txt && python run.py
- 按需拉取：`powershell -ExecutionPolicy Bypass -File scripts\fetch-project.ps1 -Name douyin-downloader`（默认临时目录，跑完 -Clean）
- 要转常驻：同上加 `-Keep`，落到 `D:\github专用仓库\plugins\douyin-downloader`
- 详细说明：暂无（见下方用途与运行）
- 返回总索引：[PROJECTS.md](../../PROJECTS.md)

---

存放规则：基础能力、高频或大用量才常驻 D 盘；其余按需拉取，用完清理。