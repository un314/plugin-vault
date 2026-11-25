# android-ad-cleaner

- 上游：https://github.com/rddmwmddr/android-ad-cleaner
- 分类：生活与科技 ｜ 类型：python
- 存放：常驻（D 盘）
- 用途：免 root 关闭国产安卓系统广告与推送（adb 脚本）
- 运行：py -m venv .venv && .venv\Scripts\pip install -r requirements.txt
- 按需拉取：`powershell -ExecutionPolicy Bypass -File scripts\fetch-project.ps1 -Name android-ad-cleaner`（默认临时目录，跑完 -Clean）
- 要转常驻：同上加 `-Keep`，落到 `D:\github专用仓库\plugins\android-ad-cleaner`
- 详细说明：[docs/android-ad-cleaner.md](../../docs/android-ad-cleaner.md)
- 返回总索引：[PROJECTS.md](../../PROJECTS.md)

---

存放规则：基础能力、高频或大用量才常驻 D 盘；其余按需拉取，用完清理。