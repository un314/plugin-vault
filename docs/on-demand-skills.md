# 大技能包按需拉取

ARIS（91 个技能，38MB）和 K-Dense 科学技能库（177 个技能，471MB）不镜像进仓库，也不常驻本机。用 `scripts/fetch-skill.ps1` 临时取一个，用完即删。

## 用法

```powershell
# 看包里有哪些技能
powershell -ExecutionPolicy Bypass -File scripts\fetch-skill.ps1 -Preset aris -List
powershell -ExecutionPolicy Bypass -File scripts\fetch-skill.ps1 -Preset science -List

# 取一个到 %TEMP%\trae-on-demand\<技能名>（稀疏克隆，只下这个目录）
powershell -ExecutionPolicy Bypass -File scripts\fetch-skill.ps1 -Preset aris -Path skills/paper-write

# AI 直接读返回的 SKILL.md 路径，按里面的流程执行

# 用完清理
powershell -ExecutionPolicy Bypass -File scripts\fetch-skill.ps1 -Clean
```

任意仓库同样可用：`-Repo owner/repo -Path skills/xxx`。

实测：拉 `paper-write` 382KB，几秒完成；克隆中间产物在结束时自动删除。

## 关于仓库变大与检索速度

- 仓库体积影响的是**首次 clone / 换机恢复**，不影响 AI 查资料。我们没把大包塞进仓库，仓库仍在几 MB 级，clone 是秒级。
- 即使仓库变大，GitHub 单文件阅读走 raw/API，也不会变慢；真正慢的是整仓克隆。
- 所以策略是：小的（单个 SKILL.md）入库，大的（几十上百个技能）按需拉。

## 云端仓库能不能直接当运行环境用

不能。要分两种：

| 类型 | 能否只用云端 |
|---|---|
| 技能（纯 Markdown 指令） | 能。取 SKILL.md 文本即可，不需要装到本机 |
| 工具/应用（要跑代码、装依赖、连数据库、要 API Key） | 不能。GitHub 是代码托管，不是服务器；必须有本机或云主机在跑 |

例外：GitHub Actions 能定时跑脚本，但它不适合交互式使用，也不保存你本地的数据和登录态。
