# hello-agents —《从零开始构建智能体》

**上游**：https://github.com/datawhalechina/hello-agents
**备份**：https://github.com/un314/hello-agents（fork，含完整历史）
**本地**：`D:\github专用仓库\plugins\hello-agents`
**类型**：教程 / Notebook
**版本**：`36f583c`

## 用途

Datawhale 的智能体原理与实践教程，含配套 Jupyter Notebook 代码，覆盖 Agent 基础、工具调用、多智能体、RAG 等。

## 依赖

Python 3.10+、Jupyter。多数章节需要 pip 安装各自 notebook 里列出的包。

## 安装

```powershell
git clone --depth 1 https://github.com/un314/hello-agents.git "D:\github专用仓库\plugins\hello-agents"
```

## 运行 / 使用

```powershell
cd "D:\github专用仓库\plugins\hello-agents"
py -m pip install jupyter
py -m jupyter notebook
```

## 验证

```powershell
Get-ChildItem "D:\github专用仓库\plugins\hello-agents" -Filter *.ipynb -Recurse | Measure-Object
```

## 备注

仓库约 314MB，主要是图片和数据。只读教程不需要装任何依赖。

---

前置环境见仓库根 `README.md`；代码拉取失败时重跑 `bootstrap.ps1` 即可续传。