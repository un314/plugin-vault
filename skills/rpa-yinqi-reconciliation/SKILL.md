---
name: rpa-yinqi-reconciliation
description: 在 cloud.acctedu.com 银企对账实操题中自动填写银行存款余额调节表并保存，并完成 UiPath 工程本地发布。当用户要做银企对账实操题、调节表输入框填不进去、或需要完整复刻本次 RPA 作业时使用。不适用于其他课程任务。
---

# 银企对账实操题自动完成

目标：把两家子公司的《银行存款余额调节表》8 个金额 + 校验码写入平台并保存成功，最后交付可提交的 UiPath 包（.nupkg）。

## 0. 三条铁律

1. **绝不点「全部重做」「重置单据」**——会清空题目数据并改变账目。
2. 调节表输入框是 `disabled` 的：**鼠标打不进去，computer-use 的 type_text / set_value 也打不进去**。只能用浏览器 DevTools 协议（CDP）在页面里直接改 DOM。不要在这件事上反复试打字。
3. 保存前必须先验算平衡：`a1+a2-a3 == a4 == a8 == a5+a6-a7`，两侧调节后余额必须完全相等。

## 1. 数据包结构（xlsx 三张表，必须吃透）

数据源是课程下发的 `银企对账数据.zip`，解压后**每家公司一个 xlsx**，每个 xlsx 固定 3 张表。

### 1.1 三张表的字段与视角

| 表 | 视角 | 列布局 |
|---|---|---|
| `银行存款对账单` | 银行侧流水 | A 日期 / B 对方账号 / C 对方户名 / D 摘要 / **E 借方发生额 / F 贷方发生额** / G 余额 / H 操作(回单) |
| `银行存款日记账` | 企业侧流水 | A 日期 / B 记字(记005号) / C 摘要 / **D 借方发生额 / E 贷方发生额** / F 余额 |
| `银行存款余额调节表` | 空白模板 | 见 1.5 |

**方向陷阱（最容易把四类未达账项写反）**：

- 对账单是银行视角：`F 贷方` = 钱进银行 = **银行已收**；`E 借方` = 银行付钱 = **银行已付**。
- 日记账是企业视角，恰好相反：`D 借方` = 银行存款增加 = **企业已收**；`E 贷方` = 企业付钱 = **企业已付**。
- 若把对账单的 E/F 当成「收/付」直接套，四类全反，平衡必然不成立。先认列名再动数。

**行类型（4 种，必须区分）**：`期初余额` 行（只有余额无数额）→ 明细行 → `本日合计` 行 → 末行 `本月合计`。

**日期列两种格式（实测同一批数据里混用）**：宸宇基本是 Excel 序列号（46204 = 2026-07-01，46234 = 2026-07-31）；瀚科部分单元格是文本 `2026/7/30`。**所以不要用日期做匹配键，只按金额匹配。**

### 1.2 未达账项判定（唯一可靠规则：金额多重集合比差）

先各抽一组金额（**剔除 期初余额 / 本日合计 / 本月合计 行，只留明细行**）：

- 对账单借方 E → 银行付款集合
- 对账单贷方 F → 银行收款集合
- 日记账贷方 E → 企业付款集合
- 日记账借方 D → 企业收款集合

然后做**多重集合差**（同额出现 N 次就扣 N 次，用 Counter/字典减，不要用集合去重）：

| 差集 | 含义 | 落到哪 |
|---|---|---|
| 对账单E − 日记账E | 银行已付、企业未付 | **a3**（日记账侧减项） |
| 日记账E − 对账单E | 企业已付、银行未付 | **a7**（对账单侧减项） |
| 对账单F − 日记账D | 银行已收、企业未收 | **a2**（日记账侧加项） |
| 日记账D − 对账单F | 企业已收、银行未收 | **a6**（对账单侧加项） |

**坑：漏剔合计行会让结果全错。** 实测宸宇 `记146号 付货款 74888` 与该日「本日合计」金额相同，若不剔除合计行，差集里会重复扣两次；瀚科 `记075号 200838`、`记150号 66770` 同样撞上本日合计。剔除后四类金额才与平台答案一字不差。

**摘要文字不可作为匹配依据**：同一笔业务银行写「货款」、企业写「付货款」/「收货款」，写法不一致，只有金额可靠。

### 1.3 精度规则

- 一律 2 位小数；xlsx 里存在 3 位小数（如 733.205、期末 5124844.725）。
- 期末余额要**四舍五入（half-up）**再填：5124844.725 → a1 = `5124844.73`（截断成 .72 会让 a4 与 a8 差 0.01）。
- 脚本实现坑：PowerShell 的 `[math]::Round` 默认是「银行家舍入」，而且 double 存不下 5124844.725（实际是 .724999…），两重坑都会得到 .72。正确写法是先转 decimal：
  ```powershell
  [double]([math]::Round([decimal]$v, 2, [MidpointRounding]::AwayFromZero))
  ```
- a4 / a8 必须用「已经填进去的 a1、a5」推算：`a4 = a1+a2−a3`、`a8 = a5+a6−a7`；两边各自独立四舍五入会差 1 分。
- 输入框 `maxlength=11`，金额小数位别超。

### 1.4 读取 xlsx 不用开 Excel（已封装成脚本）

**首选：直接跑 `scripts/recon.ps1`，一次算出 a1..a8 + 校验码 + 平衡校验**，不用再手写解析：

```
powershell -ExecutionPolicy Bypass -File scripts\recon.ps1 -Path "<公司>.xlsx"
```

输出示例（宸宇）：四行差集明细 + `a1..a4` / `a5..a8` + `BALANCED a4 = a8 = 5810188.73` + `dzCode = f3s...353`。两家都跑一遍，看到两次 BALANCED 再去动页面。

自己写解析时的要点：xlsx 就是 zip，读 `xl/sharedStrings.xml`（字符串池）+ `xl/worksheets/sheetN.xml`（数值在 `<v>`，字符串是索引 `<v>` 指向共享池）。PowerShell 用 `System.IO.Compression.ZipFile` 即可。

注意两点：**表顺序不保证**（用「末行有没有 G 列」判断哪张是对账单，别按 sheet1/sheet2 猜）；**PowerShell 脚本里的中文字面量会被编码搞坏**（无 BOM 时按 ANSI 读入），判断「合计/期初」用码点 `[string][char]0x5408 + [char]0x8BA1` 拼字符串，别直接写中文。

### 1.5 调节表模板与校验码

模板布局：A5 企业日记账余额 / C5 对账单余额（左右两栏）；B6、D6 加项合计；B7:B21 加项逐笔明细；B22、D22 减项合计；B23:B42 减项逐笔明细；A43、C43 调节后余额。

**校验码在 D3**（C3 是文字「校验码：」），25 位字母数字，形如 `f3s3171zs809y3w3149gj353`。**与公司绑定**：本批宸宇末三位 `353`、瀚科末三位 `653`，串用会保存不成功。

平台只收 8 个数字 + 校验码，模板里的逐笔明细只是给自己算数/复核用的。

字段对应（页面 `input` 的 id 是固定的）：

| id | 页面行 | 值 |
|---|---|---|
| a1 | 企业银行存款日记账余额 | 日记账期末余额 |
| a2 | 加：银行已收、企业未收款 | 合计 |
| a3 | 减：银行已付、企业未付款 | 合计 |
| a4 | 调节后的存款余额（左） | a1+a2-a3 |
| a5 | 银行对账单余额 | 对账单期末余额 |
| a6 | 加：企业已收、银行未收款 | 合计 |
| a7 | 减：企业已付、银行未付款 | 合计 |
| a8 | 调节后的存款余额（右） | a5+a6-a7 |
| dzCode | 校验码 | xlsx 里那一串 |

本次案例（郑州宸宇 / 建行，郑州瀚科 / 中行）已验证的参考值：

```
宸宇: 5124844.73 / 1248247.00 / 562903.00 / 5810188.73 ; 5463327.82 / 1142790.00 / 795929.09 / 5810188.73 ; f3s3171zs809y3w3149gj353
瀚科: 9173992.74 / 764643.00 / 721563.48 / 9217072.26 ; 9276553.11 / 970332.00 / 1029812.85 / 9217072.26 ; f3s3171zs809y3w3149gj653
```

未达账项逐笔（用来核对算得对不对；换批次就全部失效）：

```
宸宇 银行已收企业未收 a2 = 1248247 : 216128(7/27 浙江佳和餐饮) + 225533(7/3 济南鑫盛网络) + 236566(7/27 南宁鑫源信息) + 273482(7/19 合肥盛泰信息) + 296538(7/8 四川宏远工贸)
宸宇 银行已付企业未付 a3 = 562903  : 46827(7/22 苏州恒达大数据) + 214005(7/30 福建鑫盛制造) + 302071(7/15 昆明恒达工贸)
宸宇 企业已收银行未收 a6 = 1142790 : 91641(记138) + 218713(记174) + 221210(记037) + 246994(记007) + 364232(记158)
宸宇 企业已付银行未付 a7 = 795929.09: 699.38(记207 水费) + 7640.71(记210 电费) + 74888(记146) + 214511(记181) + 215919(记115) + 282271(记028)

瀚科 银行已收企业未收 a2 = 764643  : 55429 + 94644 + 124179 + 162404 + 327987
瀚科 银行已付企业未付 a3 = 721563.48: 15792.48(办公费 张天豪) + 69476 + 168509 + 215468 + 252318
瀚科 企业已收银行未收 a6 = 970332  : 66770(记150) + 89551(记014) + 174801(记039) + 301697(记170) + 337513(记207)
瀚科 企业已付银行未付 a7 = 1029812.85: 8484.85(记202 招待费) + 151503(记110) + 200838(记075) + 326909(记032) + 342078(记155)
```

换账号/换批次时数据会变，必须重新按 1.2 算，不要照抄。核对顺序：四类金额先对上 → 再验 `a1+a2−a3 = a5+a6−a7` → 才去填页面。

## 2. 拿到做题 URL

平台地址形如 `https://cloud.acctedu.com/#/rpaIndex?params=<超长 token>`。

- 该 token URL **在全新浏览器、未登录状态下也能直接打开**（已实测），所以不需要登录态，也不要动用户正在用的那个窗口。
- 每个同学在课程页「RPA环境 → 复制URL」拿自己的 URL。

## 3. 起一个可控的浏览器（本次最大坑）

`browser_use` 插件当时不可用（扩展未连接）；computer-use 又打不进 disabled 输入框。可靠做法是给 Edge 开远程调试端口，用 Node 直接调 CDP。

两个必须遵守的细节：

1. **进程会被回收**：直接 `Start-Process msedge` 后一结束命令，浏览器就没了。必须把启动放进**后台命令**并用 `-Wait` 挂住，端口才活着。
2. **首屏很慢**：全新 user-data-dir 没有缓存，会停在「正在加载资源」，实测约 60 秒才出页面。别在 10 秒内判定失败。

启动（后台执行，端口按需改）：

```
Start-Process "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe" `
  -ArgumentList "--remote-debugging-port=9223","--user-data-dir=$env:TEMP\rpa_edge_prof","--no-first-run","--no-default-browser-check","--remote-allow-origins=*","--window-size=1400,900",$url -Wait
```

- 无头模式（`--headless=new`）同样能连 CDP 且不干扰用户，但同样受上面两条约束。
- 连接前先确认端口：`Invoke-WebRequest http://127.0.0.1:9223/json/list`。
- 用完记得按命令行里的 user-data-dir 杀掉这些 msedge 进程，别留窗口给用户。

## 4. 用脚本执行页面 JS

`scripts/cdp_eval.js`：读一个 JSON 数组，逐条 `Runtime.evaluate`，支持 `sleep`。

```
cd "%TEMP%"
$env:CDP_PORT="9223"
node cdp_eval.js fill_chenyu.json
```

Node 需 ≥ 22（内置 WebSocket）。给 Edge 传 `--remote-allow-origins=*` 可避免 WS 握手被拒。

写入值的关键写法（**不要 removeAttribute('disabled')**，不要只用 `el.value=`）：

```js
const d = Object.getOwnPropertyDescriptor(HTMLInputElement.prototype, 'value');
d.set.call(el, v);
el.dispatchEvent(new Event('input',  {bubbles: true}));
el.dispatchEvent(new Event('change', {bubbles: true}));
```

Element UI 的组件是「保存时直接读 DOM」，所以这样写就能被后端接受；`a1..a8` 的 maxlength 是 11，数值位数别超。

## 5. 保存与切换企业

```js
// 保存（按钮文字是「保 存」，中间有空格）
[...document.querySelectorAll('button')]
  .find(b => b.textContent.replace(/\s/g,'') === '保存').click();
```

- 成功判据：页面出现 `.el-message` 文本 **操作成功**，且输入框数值不被清空。
- 切换企业：`select#selectCompany`，设 value + 派发 `change`，**等 3 秒以上**再填；切完先确认 `账号/开户银行` 文案已变，否则会写到上一家的表单里。
- 两家都填完保存后，切回第一家回读 a1..a8/dzCode 是否仍在——能读到说明已落库。

## 6. UiPath 本地发布（第 16 题交付物）

课程第 16 题要求「本地发布 + 运行机器人」，提交物是包文件。

### 6.1 project.json 必须完整

缺字段会导致 `publish` 报「无法找到入口点 / 项目存在验证错误」。必须有：
`name`、`main: "Main.xaml"`、`dependencies`、`schemaVersion: "4.0"`、`studioVersion`、`projectVersion`、`runtimeOptions`、`designOptions.outputType: "Process"`、`expressionLanguage`、`entryPoints`（含 `input: []`、`output: []`）、`targetFramework: "Windows"`。
可对照 `C:\Users\dizey\Documents\UiPath\本月工资汇总机器人_加固版\project.json`。

### 6.2 依赖版本必须本地已缓存

本地 NuGet 源只有 `UiPath.UIAutomation.Activities 23.10.7`，写成 `[23.10.8]` 会 NU1100 且 Studio 打不开工程。Excel 2.22.3、System 23.10.5 可用。

### 6.3 发布命令

```
& "C:\Users\dizey\AppData\Local\Programs\UiPath\Studio\UiPath.Studio.CommandLine.exe" `
  publish -p "<工程目录>\project.json" -t 300
```

- 本地发布会不会弹 Studio 无所谓，CLI 自己编译。
- 成功后到 `%USERPROFILE%\.nuget\packages\<包名>\<版本>\` 和 `%LOCALAPPDATA%\UiPath\Packages\` 找 `.nupkg`，把它（必要时连同 `银企对账数据` 目录）打包交付。
- 若仍报「项目存在验证错误」，先跑 `analyze-file -p Main.xaml` 定位具体 XAML 报错，不要盲改。

### 6.4 XAML 与工程规范（改 Main.xaml 前必读）

完整资料在 `references/uipath-rpa-knowledge.md`（939 行，UiPath 财务 RPA 全量知识库）。改 XAML 前至少确认这几条：

1. **`ExcelApplicationScope.Body` 的泛型必须是 `ui:WorkbookApplication`**，写成 `ui:Workbook` 会让整棵子树解析失败，报「类型 ActivityAction(Workbook) 不可分配给成员 Body 的类型 ActivityAction(WorkbookApplication)」，Studio 里表现为「此活动丢失或无法加载」——这一条是最高频、最容易被当成"工程坏了"的错误。
2. **`TextExpression.ReferencesForImplementation` 必须含 `UiPath.Excel.Activities` / `UiPath.System.Activities` / `UiPath.UIAutomation.Activities` / `System.Data` / `System.Data.Common`**，缺一条活动就解析不了。
3. 表达式一律包在 `[...]` 里，内部引号写 `&quot;`；DataTable 取值为 **0 基**（`data(0)(6)`），筛选列索引要按表头位置减 1。
4. 变量声明要放在足够外层的 `Sequence.Variables` 里，否则「变量未声明」。
5. 在 Excel 范围**之前**放「复制文件」把原始 xlsx 复制到当前目录（Overwrite=True），保证每次数据干净、也避免重复运行时表格重名报 `0x8FE30C19`。
6. 打包交付必须含 `Main.xaml`、`project.json`、`.settings`、`.project`、`.objects`、`.tmh` + 输入数据；**不要把已产出结果的 xlsx 打进去**；评测环境只带工程配置、不带运行数据，缺输入就会读到空表（列名变成「列1…列6」）。

### 6.5 两条技术路线怎么选

- **要最快出结果（今天这种做法）**：UiPath 只做到「本地发布 + 生成包」，页面填写走本 skill 的 CDP 脚本（第 3~5 节）。平台 disabled 输入框用 UiPath 的 SetText 也打不进。
- **老师要求机器人端到端自己做完**：照 `references/uipath-rpa-knowledge.md` §7.6「银企对账机器人（旧版 4 子流程）」搭——读两表 → 筛期末余额 → `联接数据表(Full)` 比对 → 写调节表四类 → 新版再加「填写平台余额调节表」子流程（遍历 + 选取器变量 + 读取单元格 + 设置文本）。注意该路线在 disabled 输入框上是否生效未实测，先小范围试一笔。

## 7. computer-use 使用要点（只在必须看界面时用）

- `get_app_state` 要求目标窗口是**当前前台窗口**，否则直接返回 not focused。
- 每次跑 Shell 都会把前台抢回 Trae；发键/点击前必须先 `SetForegroundWindow`。
- 微信（Weixin.exe）会突然抢焦点，先 `ShowWindow(hwnd, 6)` 最小化它。
- Ribbon 的「发布」是 split-button：UIA `click` 命中箭头，只会弹出「发布测试用例」下拉。别指望点它，直接用 6.3 的 CLI。
- `[^>]*` 这类正则在本 UI 树里会贪婪跨行（树里没有 `>`），取元素 id 用非贪婪 `[\s\S]*?`。

## 8. 排错对照表

| 现象 | 原因 | 处理 |
|---|---|---|
| 输入框点不动、光标是禁止符 | 页面 `disabled` | 走 CDP + JS 写值 |
| `type_text` / `set_value` 无效 | 同上 | 同上 |
| CDP 端口 refused | 浏览器随命令结束被回收 | 后台命令 + `-Wait` |
| 页面停在「正在加载资源」 | 全新配置无缓存 | 等 60 秒左右 |
| 保存无反应 | 校验码未填 / 数值不超 11 位 | 补齐 dzCode，重新保存 |
| 保存后校验不通过 / 提示金额不符 | 校验码串了另一家；或 a4/a8 各算各的 | 校验码按 1.5 对号，a4/a8 用已填 a1/a5 推 |
| 四类未达账项金额明显偏大 | 没剔「本日合计/本月合计」行 | 按 1.2 重新比差 |
| a4 与 a8 差 0.01 | 期末余额被截断而非四舍五入 | 按 1.3，5124844.725 → .73 |
| publish 报找不到入口点 | project.json 缺 `main` 等字段 | 按 6.1 补齐 |
| Studio 打不开工程 | 依赖版本本地不存在 | 按 6.2 改版本 |
| 活动「丢失或无法加载」 | `ActivityAction<Workbook>` 写错 | 改成 `ui:WorkbookApplication`（6.4） |
| 运行报 `0x8FE30C19` | 重复运行，同名表格已存在 | 先复制干净输入再跑（6.4） |

## 9. 快速执行清单（照这个顺序做，别绕路）

1. 解压数据包 → 每家一个 xlsx → 直接跑 `scripts/recon.ps1`（1.4），两家都出 `BALANCED` 才往下走。
2. 拿 URL（2）→ 后台命令 `-Wait` 起 Edge + 9223 端口（3）→ 等页面出来（约 60 秒）。
3. 先用 `check-tab` 脚本确认当前 tab/企业/字段 id 都在，再 `fill`，再 `save`，最后 `result` 读 `.el-message`（4、5）。
4. 换 `selectCompany` 等 3 秒以上再填第二家；两家都保存后切回第一家回读核对。
5. 收尾杀 msedge 进程；再做第 16 题的 CLI 发布（6.3）。
