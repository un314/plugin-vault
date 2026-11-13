# plugin-vault — 本地与云端共用工作台

**唯一入口**：所有插件、技能、资源的清单、文档和备份都在这一个仓库里，不再为每个项目单独建仓库。

## 仓库结构

```
plugin-vault/
├── manifest.json        全部 40 个项目：上游、类型、分类、本地路径、运行方式
├── categories/          按属性分类的索引
│   ├── ai.md            AI 框架与智能体（17）
│   ├── resources.md     实用资源与教程（11）
│   ├── life-tech.md     生活与科技应用（9）
│   └── browsers.md      浏览器引擎（3）
├── skills/              本机 25 个 Trae 技能的备份（原 my-skills 已并入）
├── archive/             已合并仓库的归档（原 skills-github-pages）
├── docs/                每个项目的部署说明
├── bootstrap.ps1        换机一键恢复
├── verify.ps1           可用性校验
└── STATUS.md            当前部署状态
```

## 三条约定

1. **不新建仓库**。新项目只在本仓库登记（manifest + docs + 分类），代码放 `D:\github专用仓库\plugins\`。
2. **分类存放**：AI 内容 → `categories/ai.md`；生活与科技 → `life-tech.md`；资源清单 → `resources.md`；浏览器内核 → `browsers.md`。
3. **不重复部署**：`trae-remote-official` 里已有的能力不再重复收录。

## 本地与云端的对应关系

| 本地路径 | 云端位置 |
|---|---|
| `D:\github专用仓库\plugins\<项目>\` | 各自的上游仓库 / 你的 fork（仅作代码副本，不再新增仓库） |
| `C:\Users\dizey\.trae-cn\skills\<技能>\` | 本仓库 `skills/<技能>/`（唯一备份源） |

## 换机恢复

```powershell
git clone https://github.com/un314/plugin-vault.git D:\github专用仓库\plugin-vault
powershell -ExecutionPolicy Bypass -File D:\github专用仓库\plugin-vault\bootstrap.ps1
powershell -ExecutionPolicy Bypass -File D:\github专用仓库\plugin-vault\verify.ps1
```

前置：Node ≥ 20、Git、Python（用 `py` 启动器）；GitHub 需代理才能克隆。

## 已合并的旧仓库

| 旧仓库 | 处理 |
|---|---|
| `my-skills` | 内容已并入 `skills/`，原仓库仅留指向说明 |
| `skills-github-pages` | 内容已并入 `archive/skills-github-pages/` |

合并后只保留本仓库一个入口，不再分散查找。
