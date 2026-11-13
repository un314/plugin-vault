---
name: uipath-exam-env-setup
description: 在另一台 Windows 设备复刻本机 UiPath 23.10 考试环境，涵盖安装、账号登录、禁用自动更新、许可与依赖校验、工程迁移、考前自检与回滚。当用户要在机房电脑或新设备配置 UiPath 考试环境时使用，不用于日常流程开发。
---

# UiPath 考试环境复刻

## 先判断场景

| 目标机现状 | 只执行 |
|---|---|
| 已预装 23.10.x 且版本被学校固定 | 阶段 4 验证 |
| 未安装或版本不符 | 阶段 1–6 |
| 机房等非自有设备 | 安装、改安装目录、禁用任务前，先取得监考或管理员同意；无权限立即停止并报告 |

账号只同步身份、组织、许可证和 Orchestrator 资产。工程文件、依赖包、Studio 偏好、更新设置、计划任务都不同步，必须逐台处理。

## 阶段 0 环境确认

记录并在最终报告中输出：

```powershell
Test-NetConnection cloud.uipath.com -Port 443 -InformationLevel Quiet
[Environment]::OSVersion.VersionString
(Get-Item "$env:LOCALAPPDATA\Programs\UiPath\Studio\UiPath.Studio.exe" -ErrorAction SilentlyContinue).VersionInfo.ProductVersion
```

确认：Windows 版本、是否管理员、443 连通、目标安装目录、屏幕分辨率与缩放（建议 1920×1080 和 100%）。

## 阶段 1 安装

1. 先卸载已有 UiPath，保留工程目录。
2. 运行 msi，选「快速」，勾选接受许可条款，点击安装。
3. 安装完成后确认路径为 `%LOCALAPPDATA%\Programs\UiPath\Studio\UiPath.Studio.exe`。
4. 不要装到需要管理员权限的目录，按用户安装才能正常获取许可。
5. 版本必须是 23.10.x；工程依赖与模板按 23.10 设计，升级到 24.x 及以上会导致工程打不开。

## 阶段 2 账号登录或注册

优先直接登录已有账号，不要为了「干净」重新注册，重注册会丢失现有许可会话。

已有账号登录：

1. 打开 Studio，选择以账号方式登录。
2. 输入邮箱和密码。
3. 输入 Authenticator 的 6 位动态码，必要时勾选 Remember this device for 30 days。
4. 确认左下角显示许可证名称。

必须新注册时，严格按此顺序：

1. Sign up，用邮箱和密码创建账户。
2. 配置 Microsoft Authenticator，扫码绑定，填入 6 位动态码。
3. 到邮箱点击 Verify Email。
4. 填写姓名与地区，姓名必须是真实「名 空格 姓」。
5. 创建组织并记住组织名与租户名。
6. 打开 UiPath，选择第一个配置文件 UiPath Studio。

姓名不合规、邮箱未验证、没有组织，都会导致无许可或考试身份核对失败。

## 阶段 3 阻止自动更新

前提：Studio 已完全退出，任务管理器中没有 `UiPath.UpdateService.*` 进程。

1. Studio 弹出更新提示时点击 Later。
2. 进入 `%LOCALAPPDATA%\Programs\UiPath\Studio`，把两个文件扩展名由 `.exe` 改为 `.bak`：
   - `UiPath.UpdateService.Agent.exe`
   - `UiPath.UpdateService.Worker.exe`
3. 禁用登录自启的两个计划任务：

```powershell
Get-ScheduledTask -TaskName 'UiPath Upgrade Service*' | Disable-ScheduledTask
```

4. 预期副作用：启动日志出现 `SetUpdateChannel` 或 `SetCommunityUpdate` 的 TimeoutException，启动慢约 30 秒，不影响编辑、运行和发布。
5. 安装目录中的 `net461\UiPath.UpdateService.Launcher.exe` 只是启动器，指向已改名的 Worker，无法完成更新，不要额外删除。
6. 保留 `.bak` 用于回滚，不要直接删除。

## 阶段 4 验证

```powershell
powershell -ExecutionPolicy Bypass -File scripts\verify-uipath-env.ps1
```

全部 PASS 才继续。手动复核入口：Studio 关于页看版本；安装目录看是否只剩 `.bak`；`taskschd.msc` 看两个 Upgrade Service 任务是否为已禁用。

## 阶段 5 迁移工程与依赖

1. 用 `scripts\backup-rpa-project.ps1` 打包，自动排除 `.local`、`bin`、`obj`、`.vs`。
2. 目标机解压到短路径，例如 `D:\RPA_Exam\`。不要放 U 盘、网络盘、OneDrive、超长中文目录。
3. 打开前删除工程内残留的 `.local`，它记录的是源机绝对路径。
4. 打开工程并等待还原，输出出现 `Restore completed` 才算成功。
5. `project.json` 中依赖版本必须与源机一致。目标机无网络时，把源机 `%USERPROFILE%\.nuget\packages` 对应包目录拷过去，在 Manage Packages 中添加为本地源并置顶。
6. 检查 `.xaml` 与 `project.json` 是否含绝对路径，有则改为：

```vb
Path.Combine(Environment.CurrentDirectory, "数据\文件名.xlsx")
```

7. 优先使用 Workbook 系列活动，减少对目标机 Office 安装的依赖。

## 阶段 6 考前自检

| 检查项 | 通过标准 |
|---|---|
| Studio 版本 | 23.10.x |
| 许可 | 左下角显示许可证名称，不是 Sign in |
| 依赖 | `Restore completed`，无 NU1100 或 NU1101 |
| 工程 | 每个工程 Analyze 结果为 0 error，无 Missing activity |
| Excel | 能读写目标 xlsx |
| 浏览器 | 扩展已启用，能拾取元素 |
| 显示 | 1920×1080，缩放 100% |
| 提交 | 录屏软件、提交入口、指定目录均已确认 |

## 回滚

```powershell
$dir = "$env:LOCALAPPDATA\Programs\UiPath\Studio"
Rename-Item "$dir\UiPath.UpdateService.Agent.bak" "UiPath.UpdateService.Agent.exe"
Rename-Item "$dir\UiPath.UpdateService.Worker.bak" "UiPath.UpdateService.Worker.exe"
Get-ScheduledTask -TaskName 'UiPath Upgrade Service*' | Enable-ScheduledTask
```

工程异常时：删除 `.local` 后重开；仍失败则用备份覆盖整个工程目录。版本被升级则卸载后重装 23.10.x。

## 故障速查

| 现象 | 处理 |
|---|---|
| NU1100 或 NU1101 | 把依赖改为目标机已缓存版本，或挂本地 NuGet 源 |
| 工程打不开、路径报错 | 删除工程内 `.local` 后重开 |
| Missing activity | Manage Packages 中还原对应包 |
| 无许可 | 连网重开 Studio 并登录，等待 1–2 分钟 |
| 元素拾取失败 | 重装浏览器扩展，或改用属性选择器 |
| Excel 活动报错 | 改用 Workbook 活动，或让管理员安装 Office |
| 找不到数据文件 | 改为相对路径，数据放工程目录内 |

## 禁止事项

- 未获授权时，不要在机房修改安装目录、计划任务或系统设置。
- 不要退出登录后重新注册，除非课程明确要求指定邮箱。
- 不要把 `.local`、`bin`、`obj` 一起拷贝。
- 不要使用绝对路径或依赖本机用户名的路径。
- 不要把试题、答案或考试资料上传到任何云端位置。

## 交付报告

输出：目标机版本、登录账号、组织与租户、许可名称、依赖与还原结果、验证 PASS 或 FAIL 明细、剩余风险与回滚方式。
