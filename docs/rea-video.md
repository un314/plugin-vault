# rea-video — 逐镜头逆向视频

**上游**：https://github.com/JuneYaooo/rea-video
**备份**：https://github.com/un314/rea-video（fork，含完整历史）
**本地**：`D:\github专用仓库\plugins\rea-video`
**类型**：Python
**版本**：`3522250`

## 用途

逆向分析任意视频，逐镜头判断是实拍、AI 生成还是代码渲染，并给出复刻方案。

## 依赖

Python 3.10+、ffmpeg，可能需视觉模型 API。

## 安装

```powershell
cd "D:\github专用仓库\plugins\rea-video"
py -m venv .venv
.\.venv\Scripts\pip install -r requirements.txt
```

## 运行 / 使用

```powershell
.\.venv\Scripts\python -m rea_video --help   # 入口以仓库 README 为准
```

## 验证

```powershell
ffmpeg -version
```

## 备注

仓库约 113MB。

---

前置环境见仓库根 `README.md`；代码拉取失败时重跑 `bootstrap.ps1` 即可续传。