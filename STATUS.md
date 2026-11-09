# 部署状态（2026-11-09）

## 云端（GitHub）

15 个上游全部已 fork 到 `un314`，共 15 份完整副本 + 本 vault 仓库。此项 100% 完成。

## 本地

```
插件                 代码      可用性     备注               
--                 --      ---     --               
hello-agents       缺失      缺失                       
OpenMausBot        缺失      未装依赖                     
ziwei-doushu       7922285 依赖已装                     
android-ad-cleaner 85e2533 venv 就绪                  
agency-agents      8ae6164 已安装     agency-agents    
scrapling          c5121c7 未建 venv                  
goutoujunshi       6db7354 已安装     goutoujunshi     
AiToEarn           缺失      未装依赖                     
Y2A-Auto                   未建 venv                  
Mineradio          649c787 依赖已装                     
taste-skill        缺失      缺技能文件                    
agile-pm-workflow  a4d9c14 已安装     agile-pm-workflow
frontend-design    f8966e6 已安装     frontend-design  
ecc                缺失      缺技能文件                    
rea-video          缺失      未建 venv                  


总计 15 个，缺失 6 个
```

## 说明

- **已完整可用**：8 个插件代码到位；其中 5 个技能已装入 `~/.trae-cn/skills`，2 个 Node 项目依赖已装，1 个 Python 项目虚拟环境已建。
- **未完成**：7 个大仓库（hello-agents 314MB、OpenMausBot 484MB、AiToEarn 376MB、rea-video 113MB、taste-skill 104MB、ECC 62MB、Y2A-Auto）因本机到 GitHub 的传输被反复中断，未能拉全。云端副本是完整的，换网络后重跑 `bootstrap.ps1` 可续传。
- 卡点不是配置错误，是带宽：单文件包超过约 30MB 时，连接常在传输中途被重置。

## 续传方法

```powershell
powershell -ExecutionPolicy Bypass -File D:\github专用仓库\plugin-vault\bootstrap.ps1
```

脚本对已完成的项自动跳过，只补缺失部分。