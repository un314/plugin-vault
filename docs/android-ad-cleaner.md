# android-ad-cleaner — 免 root 关安卓广告

**上游**：https://github.com/rddmwmddr/android-ad-cleaner
**备份**：https://github.com/un314/android-ad-cleaner（fork，含完整历史）
**本地**：`D:\github专用仓库\plugins\android-ad-cleaner`
**类型**：Python / ADB 脚本
**版本**：`4a826a1`

## 用途

通过 ADB 关闭国产安卓系统里的广告、热搜、资讯推荐和营销推送。不 root、可还原，支持 AI 智能体一键执行。

## 依赖

Python 3.9+、ADB（platform-tools）、手机开启 USB 调试。

## 安装

```powershell
cd "D:\github专用仓库\plugins\android-ad-cleaner"
py -m venv .venv
.\.venv\Scripts\pip install -r requirements.txt
```

## 运行 / 使用

```powershell
# 手机连上电脑并授权调试后
adb devices
.\.venv\Scripts\python main.py   # 具体入口以仓库 README 为准
```

## 验证

```powershell
adb devices   # 应看到设备序列号
```

## 备注

只改系统设置，不会卸载应用，可按仓库提供的方式还原。不同品牌机型支持程度不同。

---

前置环境见仓库根 `README.md`；代码拉取失败时重跑 `bootstrap.ps1` 即可续传。