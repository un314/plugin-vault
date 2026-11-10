# anime — anime.js v4 动画引擎

**上游**：https://github.com/juliangarnier/anime
**备份**：https://github.com/un314/anime（fork，含完整历史）
**本地**：`D:\github专用仓库\plugins\anime`
**类型**：Node / JavaScript 库
**版本**：`01b81be`（animejs 4.5.0）

## 用途

anime.js v4 是通用动画引擎，可驱动 CSS 属性、SVG、DOM、JS 对象，支持时间轴、交错、弹簧缓动等。

## 依赖

Node.js 18+、npm。库本身零运行时依赖。

## 安装

```powershell
cd "D:\github专用仓库\plugins\anime"
npm install
```

> 拉取源码时 github.com 直连不通，已通过 `gh-proxy.com` 镜像克隆，`origin` 已指回 `un314/anime`。

## 运行 / 使用

```powershell
npm run build            # 构建到 dist/
npm run open:examples    # 打开示例页
```

在项目中直接调用：

```js
import { animate } from 'animejs';
animate('.box', { x: 200, rotate: '1turn', duration: 800 });
```

## 验证

```powershell
Test-Path "D:\github专用仓库\plugins\anime\node_modules"
Get-Content "D:\github专用仓库\plugins\anime\package.json" -TotalCount 5
```

## 备注

MIT 许可。仓库约 12.7MB（含示例与文档资源）。

`npm run build` 在 Windows 上会失败——脚本里用了 POSIX 的 `rm -rf`（报 `'rm' 不是内部或外部命令`）。仓库已自带构建产物 `dist/`（212 个文件），直接引用即可；确实要重建时用 Git Bash 运行，或执行：

```powershell
cd "D:\github专用仓库\plugins\anime"
Remove-Item dist -Recurse -Force -ErrorAction SilentlyContinue
npx rollup -c
```
