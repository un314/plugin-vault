# goutoujunshi — 恋爱军师

**上游**：https://github.com/shengjidaguai-china/goutoujunshi
**备份**：https://github.com/un314/goutoujunshi（fork，含完整历史）
**本地**：`D:\github专用仓库\plugins\goutoujunshi`
**类型**：技能
**版本**：`6db7354`

## 用途

先接住情绪、再分析关系并给出可执行策略的技能，内置心理、法律、社会、哲学、婚姻家庭等知识库。

## 依赖

无（纯 Markdown + 参考资料）。

## 安装

```powershell
# 已安装到 Trae 技能目录
Test-Path "$env:USERPROFILE\.trae-cn\skills\goutoujunshi\SKILL.md"
```

## 运行 / 使用

```powershell
# 在 Trae 里说：
# 「用狗头军师帮我梳理情绪、分析当前关系，并给出下一步建议」
```

## 验证

```powershell
Get-ChildItem "$env:USERPROFILE\.trae-cn\skills\goutoujunshi" -Recurse -File | Measure-Object
```

## 备注

支持直接分析导出的聊天记录文件。

---

前置环境见仓库根 `README.md`；代码拉取失败时重跑 `bootstrap.ps1` 即可续传。