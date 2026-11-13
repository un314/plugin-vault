# UiPath 财务 RPA 全量知识库（模型无关通用版）

> **定位**：可直接作为任意大语言模型（GPT / Claude / Gemini / 通义 / DeepSeek / 本地模型）的系统提示、知识库或 RAG 文档，用于「财务 RPA 实操题」的全流程作业：读题 → 设计 → 生成可运行工程 → 校验 → 打包交付。
> **兼容环境**：UiPath Studio 23.10.x（Windows 目标框架 / VisualBasic 表达式），Excel 活动包 2.22.x，System 活动包 23.10.x，Mail 活动包 1.x，UI Automation 活动包 23.10.x。
> **占位符**：`{{项目目录}}`、`{{数据目录}}`、`{{邮箱}}`、`{{授权码}}`，按实际环境替换。

---

## 目录
1. 行为准则
2. RPA 基础理论（概念 / 特点 / 领域 / 价值）
3. UiPath 体系（组件 / 界面 / 工作流类型 / 项目结构 / 依赖 / 调试 / 发布）
4. 变量与表达式
5. 活动库全表（常用 / 流程控制 / 异常 / Excel / 数据表 / 邮件 / Web / 文件）
6. 选取器与录制器
7. 经典题目配方（7 个）
8. 交付、运行与排错
9. 高频考点题库（含答案）
10. 验证脚本
11. 输出模板
12. 常见坑总清单

---

## 1. 行为准则

1. **先读数据再写流程**：必须实际读取 xlsx 的 sheet 名、表头、行列数、列顺序，禁止猜列索引。
2. **先设计再生成**：输出「活动树 + 变量表 + 属性表」，确认后给 XAML。
3. **必须可运行**：XAML 要能被 Studio 加载且 0 错误 0 警告；无法校验须声明风险。
4. **结果自证**：运行后用脚本读取输出文件关键单元格，与源数据交叉核对。
5. **交付自包含**：压缩包内必须含工程文件 + 输入数据，不依赖外部路径。
6. **不产多余文件**：除工程、输入数据、交付包外不额外生成文档。

---

## 2. RPA 基础理论

### 2.1 定义
- **RPA = Robotic Process Automation（机器人流程自动化）**，用软件模拟人类操作，与各类数字系统交互。
- 典型代表：按键精灵（录制/脚本回放）。
- 财务机器人 = RPA 在财务领域的应用，是软件程序，不是实体机器人。

### 2.2 功能与特点
| 维度 | 内容 |
|---|---|
| 功能 | 文件批处理、邮件自动化、数据库连接、OCR 识别、跨系统数据搬运与模拟录入、结构化数据处理 |
| 特点 | 基于明确规则、模拟手工操作、**非入侵性**、替代重复/标准/大批量事务 |
| 适合条件 | **虚拟化、高负荷、规则驱动、可重复** |

### 2.3 应用领域
- 行业：金融（银行/证券/保险）、电商、零售、物流、政府、医疗、制造
- 职能：财务、HR、IT
- 典型案例：电商自动退换货、银行数据整理、财务银企对账、HR 简历自动搜寻
- 财务场景：银行回单下载、银企对账、纳税申报、发票填开、报表编制

### 2.4 财务人员为何要学
- 财务是**强规则领域**，排序筛选、录入、复制粘贴场景多
- 初级核算工作（发票填开、对账、申报、凭证）可被 RPA 替代，存在被取代风险
- 数字化转型需要“懂财务 + 懂技术”的复合人才
- 价值：灵活定制、降低人工风险、提效降本、释放人力做高价值工作

---

## 3. UiPath 体系

### 3.1 三大组件
| 组件 | 职责 |
|---|---|
| **Studio** | 低代码可视化编辑环境，设计流程（拖拽 + 录制） |
| **Robot** | 执行流程的虚拟劳动力；分**有人值守**与**无人值守** |
| **Orchestrator** | Web 端集中调度、管理、监控机器人 |

关系：Robot 是最基础单元，Studio 为其规划路径，Orchestrator 管理与监控。

### 3.2 界面要点
- 主页：打开、开始、工具、模板、设置、帮助
- 工具 → 扩展程序：浏览器、Java、Silverlight、Citrix
- 设置 → 常规（**界面语言**、主题）、设计（保存/发布/执行）、位置、管理源、许可证、团队
- 设计器菜单：管理程序包、录制、正在抓取（数据抓取）、**UI 探测器**（自定义选取器）、导出到 Excel、发布
- 调试面板：调试文件、断点、**慢步骤**、高亮元素、执行历史、日志活动、画中画

### 3.3 四种工作流类型
| 类型 | 适用场景 |
|---|---|
| **序列 Sequence** | 线性、活动依次跟随的简单流程 |
| **流程图 Flowchart** | 复杂分支、决策 |
| **状态机 State Machine** | 大型项目、状态驱动 |
| **全局处理程序 Global Handler** | 统一异常处理 |

序列与流程图**可互相嵌套**。

### 3.4 项目结构
```
{{项目目录}}/
├── Main.xaml
├── project.json          # name / main / targetFramework=Windows / expressionLanguage=VisualBasic / dependencies
├── .settings/
├── .project/
├── .objects/
├── .tmh/
└── {{输入数据}}.xlsx
```
- `project.json` 依赖示例：`UiPath.Excel.Activities [2.22.3]`、`UiPath.System.Activities [23.10.5]`、`UiPath.Mail.Activities`、`UiPath.UiAutomation.Activities`
- 依赖缺失时在“依赖项”面板显示红色，右键“修复依赖项”重新拉取

### 3.5 调试与发布
- 调试：断点、慢步骤、高亮元素、日志活动；F5 运行，F7 单步
- 发布：功能区「发布」→ 打包为 nupkg；可发布到本地或 Orchestrator
- **本地发布**适用：无需流程配置和监控管理

---

## 4. 变量与表达式

### 4.1 数据类型
| 类型 | 说明 | 示例 |
|---|---|---|
| `String` | 字符串，引号包裹 | `"文本"` |
| `Boolean` | 真/假 | `True` / `False` |
| `Int32` | 整数 | `123` |
| `Double` | 小数 | `123.45` |
| `Array` | 数组 | `{"a","b","c"}` |
| `GenericValue` | 万能类型，可存任意值 | — |
| `DataTable` | 数据表 | `dt` |
| `List<T>` | 泛型集合 | `List<MailMessage>` |
| `MailMessage` | 邮件对象 | `currentItem` |

### 4.2 变量创建
变量面板 → 创建变量 → 名称 / 变量类型 / 范围（序列、整个流程）/ 默认值；赋值用「分配」活动。

### 4.3 类型转换与常用函数
| 函数 | 用途 |
|---|---|
| `CInt(x)` / `CDbl(x)` / `CStr(x)` / `CDate(x)` | 显式转换，失败抛异常 |
| `.ToString` | 转字符串 |
| `CStr(数值)` | 数值转文本 |
| `x.ToString("yyyy-MM-dd")` | 日期格式化 |
| `String.Format("{0}-{1}",a,b)` | 字符串拼接 |
| `x.Contains("y")` / `x.StartsWith` / `x.EndsWith` | 字符串判断 |
| `x.Split(","c)` | 拆分 |
| `x.Trim()` / `x.Replace("a","b")` | 去空格 / 替换 |
| `Now` / `Today` | 当前时间 / 日期 |
| `Directory.GetFiles(路径,"*.xlsx")` | 取文件列表 |
| `Path.GetFileName(路径)` | 取文件名 |

### 4.4 运算符
算术 `+ - * /`、取余 `Mod`；比较 `= <> > < >= <=`；逻辑 `And Or Not`；字符串拼接 `&` 或 `+`。

### 4.5 数据表取值（0 基）
`data(行)(列)`、`row(列).ToString`、`data.Rows(0).Item("列名")`、`data.Rows.Count`、`data.Columns.Count`。

---

## 5. 活动库全表

### 5.1 常用活动
| 活动 | 用途 / 关键属性 |
|---|---|
| 分配 Assign | `To` 变量，`Value` 表达式 |
| 消息框 MessageBox | `Text`（表达式需引号），可设按钮/标题 |
| 输入对话框 InputDialog | `Title`、`Label`、`Result`（输出 String）、`IsPassword` |
| 日志消息 Log Message | `Level`（Info/Warn/Error/Trace）、`Message` |
| 延迟 Delay | `Duration`（如 `00:00:03`） |
| 注释 Comment | 流程注释，不执行 |
| 调用工作流 Invoke Workflow File | 复用子流程 |
| 调用代码 Invoke Code | 内联 VB/C# |
| 调用 Python Invoke Python Method | 需 Python 作用域 |
| 重试范围 Retry Scope | `NumberOfRetries`、`RetryInterval`，包裹易失败操作 |

### 5.2 流程控制
| 活动 | 说明 |
|---|---|
| If | `Condition` 布尔表达式；Then / Else 分支 |
| Else If | 多条件串联，避免嵌套过深 |
| Switch | 按值分派多分支（`x:TypeArguments="x:String"`） |
| 流程决策 Flow Decision | 流程图中的条件分支 |
| 流程开关 Flow Switch | 流程图中的多路分支 |
| 先条件循环 While | 条件为真时循环（`InterruptibleWhile` 可被中断） |
| 后条件循环 Do While | 先执行后判断 |
| 遍历循环 For Each | 集合遍历，`x:TypeArguments` 指定元素类型 |
| 对于每一行 For Each Row | 遍历 DataTable，`CurrentRow` 无需声明 |
| 中断 Break / 继续 Continue | 跳出 / 跳过本次循环 |

### 5.3 异常处理
| 活动 | 说明 |
|---|---|
| Try Catch | Try 放可能出错的活动；Catch **至少指定一个异常类型**；Finally 无论成败都执行（常用于写日志） |
| Throw | 主动抛出异常（`New Exception("消息")`） |
| Rethrow | 子流程捕获后重新抛给主流程 |
| 全局处理程序 | 统一捕获未处理异常 |

### 5.4 Excel 活动
| 活动 | XAML 类型 | 关键属性与行为 |
|---|---|---|
| Excel 应用程序范围 | `ui:ExcelApplicationScope` | `WorkbookPath`、`AutoSave`、`Password`、`InstanceCachePeriod`；文件不存在**新建**；输出 WorkbookApplication 变量可延长生命周期 |
| 读取范围 | `ui:ExcelReadRange` | `SheetName`、`Range`（空=整表；`A1`=该格起整片）、`AddHeaders`（默认 True）、`DataTable` |
| 写入范围 | `ui:ExcelWriteRange` | `SheetName`、`StartingCell`（默认 A1）、`AddHeaders`（默认 False）、`DataTable`；工作表不存在**自动创建**；覆盖原数据 |
| 写入单元格 | `ui:ExcelWriteCell` | `SheetName`、`Cell`、`Text`（值或公式） |
| 读取单元格/行/列 | `ui:ExcelReadCell/ReadRow/ReadColumn` | 以指定单元格为基准 |
| 复制粘贴范围 | `ui:ExcelCopyPasteRange` | `SourceRange`、`DestinationCell`、`SheetName`、`DestinationSheet`；可复制值/公式/格式 |
| 创建表格 | `ui:ExcelCreateTable` | `Range`、`SheetName`、`TableName` |
| 创建透视表 | `ui:ExcelCreatePivotTable` | `Range`、`SheetName`、`SourceTableName`、`TableName`；**无字段布局属性**，只生成空骨架 |
| 删除重复范围 | `ui:ExcelRemoveDuplicateRows` | 按列去重 |
| 查找范围 | `ui:ExcelLookUpRange` | 返回单元格坐标字符串 |
| 自动填充范围 | `ui:ExcelAutoFillRange` | 模拟拖动填充柄 |
| 插入/删除行列 | `ui:ExcelInsertRow/DeleteRow/…` | 指定位置 |
| 执行宏 / 调用 VBA | `ui:ExcelExecuteMacro` / `ui:InvokeVBA` | 执行宏或 VBA 代码 |

**分组规则**：`Excel*`（应用程序集成）必须包在 Excel 应用程序范围内并共用路径；`Workbook*`（系统→文件→工作簿）各自带路径，可独立使用。

### 5.5 数据表活动（16 个）
| 活动 | 要点 |
|---|---|
| 筛选数据表 `FilterDataTable` | `FilterRowsMode`（Keep/Remove）、`SelectColumnsMode`（Keep/Remove）、`Filters`（`Column` 0 基 + `Operator` + `Operand`）、多条件 And/Or |
| 构建数据表 `BuildDataTable` | 向导定义列名/类型/值；需「写入范围」落地 |
| 添加数据行 `AddDataRow` | 数组行 `{"值1","值2"}`；可向已有表追加 |
| 添加数据列 `AddDataColumn` | 列名、类型、默认值 |
| 排序数据表 `SortDataTable` | 指定列 + 升/降序 |
| 联接数据表 `JoinDataTable` | Inner/Left/Full；配对 表1列 / 表2列 / 运算（`=`、`<>`）；不匹配补 null |
| 删除数据列/行/重复行 | — |
| 合并数据表 `MergeDataTable` | 追加/合并 |
| 输出数据表 `OutputDataTable` | DataTable → 分隔字符串 |
| 生成数据表 `GenerateDataTable` | 字符串 → DataTable |
| 清除数据表 / 查找数据行 等 | 同组 |

**核对类通用解法**：联接（Full/Left，补 null）→ 筛选（删除两侧同时非空）→ 不符记录。

### 5.6 邮件活动
| 活动 | 关键属性 |
|---|---|
| 发送 SMTP 邮件消息 `SendMail` | `Server`、`Port`、`EnableSSL`、`SecureConnection`、`From`/`Email`、`Password`（授权码）、`To`、`Subject`、`Body`、`Files`（String 数组） |
| 获取 POP3 邮件消息 `GetPOP3MailMessages` | `Server`、`Port`、`Email`、`Password`、`Top`（30 或 `{x:Null}`）、`DeleteMessages`、输出 `List<MailMessage>` |
| 获取 IMAP 邮件消息 `GetIMAPMailMessages` | 同 POP3，服务器 `imap.163.com:993` |
| 获取 Outlook 邮件消息 | 读取本机 Outlook |
| 保存邮件附件 `SaveMailAttachments` | `Message`、`FolderPath`（空=工程目录；指定目录须先创建）、`OverwriteExisting` |
| 移动/删除邮件 | IMAP 专用 |
| 回复邮件 / 转发邮件 | 基于原邮件 |

端口：SMTP 25（非 SSL）/465（SSL）；POP3 110/995；IMAP 143/993。必须先在邮箱开启协议并生成**授权码**。

### 5.7 Web 与 UI 自动化
| 活动 | 关键属性 |
|---|---|
| 打开浏览器 `UseBrowser` | 容器，URL 设在容器；内部放最大化窗口、单击、设置文本 |
| 附加浏览器 `AttachBrowser` | 连接已打开页面；网页录制自动生成 |
| 关闭选项卡 / 最大化窗口 | — |
| 单击 `Click` | `Target`（选取器）、`Simulate`（默认 True）、`ClickType` |
| 设置文本 `TypeInto` | `Target`、`Text`、`Simulate`、`EmptyField` |
| 选择项目 `SelectItem` | 下拉框选项 |
| 获取文本 `GetText` | 输出 String |
| 元素存在 `ElementExists` | 返回 Boolean，常用于等待加载 |
| 等待元素 `WaitUiElementAppear` | 超时控制 |
| 截图 `TakeScreenshot` | 保存图片 |
| 提取结构化数据 `ExtractStructuredData` | 数据抓取向导生成；`MaxResultsNumber`（0=全部）、分页选择器 |
| 屏幕抓取 | 全文 `GetFullText` / 原生 `GetVisibleText` / OCR `GetOCRText` |

**选取器**：XML 片段；`<wnd>` 顶层窗口 → `<html>` / `<ctrl>` / `<webctrl>` 目标；属性 `name='value'`；通配符 `*`（任意长）、`?`（单字符）；动态值用 `{{变量名}}`；拾取快捷键 `Esc`（取消/保存）、`F2`（延迟）、`F3`（指定区域）、`F4`（切换 UI 框架）。

**录制器 5 类**：基本、桌面、网页、图像、原生；网页录制默认 `Simulate` 输入。

### 5.8 文件与系统活动
| 活动 | 用途 |
|---|---|
| 复制文件 Copy File | `Path`、`Destination`、`Overwrite`、`ContinueOnError` |
| 创建文件夹 Create Directory | 目标目录不存在时创建 |
| 遍历文件夹 For Each File in Folder | 返回文件列表 |
| 读取文本文件 / 写入文本文件 | 编码需指定 |
| 移动 / 删除文件 | — |
| 压缩 / 解压 Zip | `Compress/Zip` 活动 |
| 获取文件名 / 路径操作 | `Path.GetFileName`、`Directory.GetFiles` |

---

## 6. XAML 规范（最高频错误来源）

### 6.1 根节点
```xml
<Activity mc:Ignorable="sap sap2010" x:Class="Main" VisualBasic.Settings="{x:Null}"
  sap2010:WorkflowViewState.IdRef="ActivityBuilder_1"
  xmlns="http://schemas.microsoft.com/netfx/2009/xaml/activities"
  xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
  xmlns:sap="http://schemas.microsoft.com/netfx/2009/xaml/activities/presentation"
  xmlns:sap2010="http://schemas.microsoft.com/netfx/2010/xaml/activities/presentation"
  xmlns:scg="clr-namespace:System.Collections.Generic;assembly=System.Private.CoreLib"
  xmlns:sco="clr-namespace:System.Collections.ObjectModel;assembly=System.Private.CoreLib"
  xmlns:sd="clr-namespace:System.Data;assembly=System.Data.Common"
  xmlns:snm="clr-namespace:System.Net.Mail;assembly=System.Net.Mail"
  xmlns:ui="http://schemas.uipath.com/workflow/activities"
  xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml">
```

### 6.2 三块必备声明
- `TextExpression.NamespacesForImplementation`：`System.Activities*`、`System.Data`、`System.Linq`、`UiPath.Core`、`UiPath.Core.Activities`、`UiPath.Excel`、`UiPath.Excel.Activities`、`UiPath.Mail*`、`UiPath.UIAutomation*`、`System.Windows.Markup`、`GlobalVariablesNamespace`、`GlobalConstantsNamespace`
- `TextExpression.ReferencesForImplementation`：`UiPath.Excel.Activities`、`UiPath.System.Activities`、`UiPath.UiAutomation.Activities`、`UiPath.Mail.Activities`、`System.Data`、`System.Data.Common`、`System.Private.CoreLib`、`mscorlib`、`PresentationCore`、`PresentationFramework`、`WindowsBase`
- 变量：`<Sequence.Variables><Variable x:TypeArguments="sd:DataTable" Name="data" /></Sequence.Variables>`

### 6.3 致命错误：ExcelApplicationScope.Body 泛型
```xml
<ui:ExcelApplicationScope AutoSave="True" DisplayName="Excel 应用程序范围"
    WorkbookPath="[&quot;{{文件名}}.xlsx&quot;]">
  <ui:ExcelApplicationScope.Body>
    <ActivityAction x:TypeArguments="ui:WorkbookApplication">
      <ActivityAction.Argument>
        <DelegateInArgument x:TypeArguments="ui:WorkbookApplication" Name="ExcelWorkbookScope" />
      </ActivityAction.Argument>
      <Sequence DisplayName="执行"> … </Sequence>
    </ActivityAction>
  </ui:ExcelApplicationScope.Body>
</ui:ExcelApplicationScope>
```
泛型必须为 **`ui:WorkbookApplication`**。写成 `ui:Workbook` 会导致整棵子树解析失败（“此活动丢失或无法加载”），报错文本：
`类型"ActivityAction(Workbook)"不可分配给成员"Body"的类型"ActivityAction(WorkbookApplication)"`。

### 6.4 表达式与参数
- 表达式包在 `[...]`：`SheetName="[&quot;Sheet1&quot;]"`、`Range="[&quot;A1&quot;]"`、`DestinationCell="[&quot;F&quot;+(i+2).ToString]"`
- 引号转义 `&quot;`；空值 `{x:Null}`
- 输出参数元素写法：
```xml
<ui:ExcelReadRange.DataTable>
  <OutArgument x:TypeArguments="sd:DataTable">[data]</OutArgument>
</ui:ExcelReadRange.DataTable>
```
- 列表参数：
```xml
<scg:List x:TypeArguments="InArgument" Capacity="6">
  <InArgument x:TypeArguments="x:String">[&quot;一级部门&quot;]</InArgument>
</scg:List>
```

### 6.5 公式批量填充模板
```xml
<ui:InterruptibleWhile DisplayName="先条件循环" Condition="[data(i)(0).ToString&lt;&gt;&quot;&quot;]">
  <ui:InterruptibleWhile.Body>
    <Sequence DisplayName="循环体">
      <ui:ExcelCopyPasteRange SheetName="[&quot;表名&quot;]" DestinationSheet="[&quot;表名&quot;]"
          SourceRange="[&quot;F2:G2&quot;]" DestinationCell="[&quot;F&quot;+(i+2).ToString]" />
      <Assign DisplayName="分配">
        <Assign.To><OutArgument x:TypeArguments="x:Int32">[i]</OutArgument></Assign.To>
        <Assign.Value><InArgument x:TypeArguments="x:Int32">[i+1]</InArgument></Assign.Value>
      </Assign>
    </Sequence>
  </ui:InterruptibleWhile.Body>
</ui:InterruptibleWhile>
```

---

## 7. 经典题目配方

### 7.1 按部门汇总工资（筛选 + 表格 + 透视表）
```
序列
 └ ExcelApplicationScope(本月工资结算表.xlsx)
    └ 执行序列（data、data_1 均为 DataTable）
       ├ 读取范围(Sheet1, Range 空, AddHeaders=True) → data
       ├ 筛选数据表(SelectColumnsMode=Keep：一级部门/二级部门/基本薪资/奖金/加班费/合计) → data_1
       ├ 写入范围(Sheet=本月工资汇总表, A1, AddHeaders=True, data_1)
       ├ 创建表格(Range=A1:F72, Sheet=本月工资汇总表, TableName=本月工资汇总表)
       └ 创建透视表(Range=A1, Sheet=工资汇总透视表, SourceTableName=本月工资汇总表, TableName=数据透视表)
```
经典透视表活动只能建空骨架；要求字段布局需追加 VBA/宏。

### 7.2 材料登记表 → 采购清单（公式填充 + 条件筛选）
- 结构：A 序号、B 物料代码、C 名称、D 单位、E 期初、F 本期采购、G 本期领用、H 期末=`E+F-G`、I 是否购买=`IF(H<E*10%,"是","否")`；行 2–27
- 明细表：物料代码 D2:D26，数量 G2:G26
- 公式（外部工作簿相对引用，三份文件同目录）：
  - F2 `=IFERROR(VLOOKUP(B2,[采购明细表.xlsx]Sheet1!$D$2:$G$26,4,0),0)`
  - G2 `=IFERROR(VLOOKUP(B2,[领料明细表.xlsx]Sheet1!$D$2:$G$26,4,0),0)`
  - 等价：`SUMIF(明细表!$D:$D,$B2,明细表!$G:$G)`
- 流程：读取(`A:I`) → 写 F2/G2 → While 填充 → 读取(`A1`) → 筛选第9列（索引 8）=“是” → 写入范围(采购清单)

### 7.3 邮件附件收集（POP3 + 主题匹配 + 保存）
```
序列 → 获取POP3邮件消息(Server=pop.163.com, Port=995, Top=30, DeleteMessages=True) → mail
     → 遍历(mail, currentItem)
        → If currentItem.Subject.Contains("采购明细表") OrElse Contains("领料明细表")
           → 保存附件(Message=currentItem, FolderPath 空 → 工程目录)
```

### 7.4 批量保存财务报表附件
```
输入对话框(年份) → 获取POP3邮件消息(Top={x:Null}, DeleteMessages=False) → mails
遍历(mails) → If currentItem.Subject.Contains(年份+"年财务报表")
  → 文件名 = currentItem.Subject
  → 创建文件夹(["财务报表\"+文件名])
  → 保存附件(FolderPath 同路径)
```
运行后产出 `财务报表\<主题名>\<附件>`。

### 7.5 网银付款机器人（新版：双层循环）
```
序列 → ExcelApplicationScope(付款清单.xlsx) → 打开浏览器 → 最大化窗口
子流程1：读取范围(企业信息, A1) → 子公司信息
        遍历(子公司信息) → 读取范围(工作表=CurrentRow(0), A1) → 子公司付款数据
子流程2：选择项目(付款账号=CurrentRow(1))、选择项目(角色=CurrentRow(2))
        设置文本(密码="123456") → 单击(登录)
子流程3：遍历(子公司付款数据)
        设置文本 收款人/账号/银行/金额 = CurrentRow(0..3)
        选择项目 用途 = CurrentRow(4)
        设置文本 校验码 = CurrentRow(5)（勾选“如果禁用则更改”）
        单击(提交) → 单击(退出)
```
旧版（单层循环）：主框架用 3 个流程图。

### 7.6 银企对账机器人（旧版：4 子流程，最高频）
```
分配 企业列表(String[]) = {"北京定采工业有限公司.xlsx","北京华茂工业有限公司.xlsx","北京新城工业有限公司.xlsx"}
遍历(企业列表) → ExcelApplicationScope(WorkbookPath="银企对账数据\"+item.ToString)
 ├ 子流程1：读取范围(银行存款对账单, A1) → 对账单数据
 │   筛选① 保留第4列（索引3）含“本月合计” → 对账单期末余额
 │   筛选② 删除第4列 空白/“期初余额”/“本月合计” → 对账单待核对数据
 ├ 子流程2：读取范围(银行存款日记账, A1) → 日记账数据
 │   筛选① 保留第3列（索引2）含“本月合计” → 日记账期末余额
 │   筛选② 删除第3列 空白/“期初余额”/“本日合计”/“本月合计” → 日记账待核对数据
 ├ 子流程3：联接数据表 Full
 │   对账单借方(第5列/索引4) = 日记账贷方(第5列/索引4)
 │   对账单贷方(第6列/索引5) = 日记账借方(第4列/索引3) → 核对完成数据
 │   筛选：删除 第1列 与 第9列 同时非空 → 核对不符数据
 └ 子流程4：写单元格 D5 = 对账单期末余额(0)(6)；B5 = 日记账期末余额(0)(5)
     银行已收企业未收：保留第6列>0，留第1、6列 → 写入 A7
     银行已付企业未付：保留第5列>0，留第1、5列 → 写入 A23
     企业已收银行未收：保留第12列>0，留第9、12列 → 写入 C7
     企业已付银行未付：保留第13列>0，留第9、13列 → 写入 C23
```
**新版（5 子流程）**：多“填写平台余额调节表”（遍历单元格 + 选取器变量 `{{...}}` + 读取单元格 + 设置文本），主框架多打开浏览器/最大化窗口；企业列表可用 `Directory.GetFiles("银企对账数据","*")`。

### 7.7 AI + RPA 投资理财决策（项目八）
```
任务1：大模型按历史业绩/规模/风控评分 → 精选 5 家基金公司
任务2：RPA 抓取 5 家旗下全部产品（收益率、费率、经理、交易状态）
任务3：RPA 抓取对应基金经理历史管理业绩
任务4：数据交回大模型 + 风险偏好/流动性需求 → 投资组合建议
数据源：天天基金网（货币基金排行、基金经理信息）；可用抓取表格或 HTTP 请求 API
```

---

## 8. 交付、运行与排错

### 8.1 在线评测平台机制
- 上传的 zip 会被解压到临时目录后重建工程，**只带工程配置，不带运行数据**。
- 缺输入 xlsx 时，Excel 范围新建空工作簿 → 读空表 → 写空数据 → 创建表格时表头为空，Excel 自动命名“列1…列6”。

### 8.2 必备：运行前复制干净输入
在 Excel 应用程序范围**之前**放「复制文件」：
```
Path = 原始数据绝对路径
Destination = 当前目录同名文件
Overwrite = True
ContinueOnError = True
```
作用：① 保证每次数据干净；② 避免重复运行导致表格/透视表重名报错。

### 8.3 错误码速查
| 现象 | 原因 | 修复 |
|---|---|---|
| `0x8FE30C19`（`ListObjects.Add`） | 同名表格已存在（重复运行） | 复制干净输入后再运行 |
| 活动“丢失或无法加载” | `ActivityAction<Workbook>` 写错 | 改为 `ui:WorkbookApplication` |
| “需要本地许可证” | 社区版未登录 Orchestrator | 登录 UiPath |
| “The operation has timed out” | 连不上 Orchestrator 云端 | 检查网络/代理 |
| 保存附件失败 | 文件夹不存在 | 先创建文件夹 |
| 公式 #REF!/#NAME? | 外部工作簿路径不对 | 保证三份文件同目录、用相对引用 |

### 8.4 打包
```powershell
Compress-Archive -Path "{{项目目录}}\*" -DestinationPath "{{交付目录}}\{{项目名}}.zip" -Force
```
- 必须含：`Main.xaml`、`project.json`、`.settings`、`.project`、`.objects`、`.tmh` + 输入数据
- **不要把已生成结果的工作簿打进包**
- 中文路径受限时先用 ASCII 临时名打包，再重命名（重命名勿带 `.zip`，否则变 `.zip.zip`）

### 8.5 验证清单
1. Studio 加载：0 错误 0 警告
2. 运行：输出“执行结束”，无异常堆栈
3. 结果：工作表名、行数、列名、合计值与源数据一致
4. 幂等：连续运行两次均成功

---

## 9. 高频考点题库（含答案）

### 9.1 项目七练习 15 题
| # | 题型 | 题目要点 | 答案 |
|---|---|---|---|
| 1 | 单选 | 可能引发异常的活动放 Try Catch 哪部分 | **A. Try** |
| 2 | 单选 | 识别并抛出异常、提示程序运行错误 | **B. Throw** |
| 3 | 单选 | 关于 Try Catch 说法错误的是 | **D**（无异常时 Finally 不执行——错） |
| 4 | 单选 | 不属于 UiPath 组件的软件 | **C. Blue Prism** |
| 5 | 单选 | 不属于外部因素造成异常 | **C. 未安装活动程序包** |
| 6 | 多选 | 三大组件描述正确的是 | **A、C、D**（B 错：Robot 含无人值守） |
| 7 | 多选 | 属于调试界面功能 | **A、B、C、D**（调试文件/断点/日志活动/慢步骤） |
| 8 | 多选 | 序列与流程图说法错误的是 | **A、D**（可互相嵌套） |
| 9 | 多选 | 以下说法正确的有 | **A、B、D**（C 错：写入范围自动建表） |
| 10 | 多选 | 常见异常处理活动 | **A、B、C**（Exception Handler 不属于） |
| 11 | 判断 | 无需流程配置可本地发布 | **正确** |
| 12 | 判断 | RPA 流程稳定，不需要运维 | **错误** |
| 13 | 判断 | 子流程异常可用 Rethrow 抛出 | **正确** |
| 14 | 判断 | 部署成本可忽略、无需考虑成本 | **错误** |
| 15 | 判断 | 社区版自动更新可能导致设置需再调整 | **正确** |

### 9.2 项目二练习（节选）
| # | 题目 | 答案 |
|---|---|---|
| 1 | 负责设计自动化流程的组件 | **Studio** |
| 2 | 新装 UiPath 改中文 | **设置 → 语言** |
| 4 | 迟到/早退/旷工/请假不同扣款适合的工作流文件 | **Flowchart** |
| 5 | RPA 英文缩写 | **Robotic Process Automation** |

---

## 10. 验证脚本（PowerShell + COM，任意 Windows 可用）

### 10.1 读结构与关键单元格
```powershell
$xl = New-Object -ComObject Excel.Application
$xl.Visible = $false; $xl.DisplayAlerts = $false
$wb = $xl.Workbooks.Open("{{文件绝对路径}}")
foreach($ws in $wb.Worksheets){
  Write-Output ("SHEET=" + $ws.Name + " USED=" + $ws.UsedRange.Address())
}
Write-Output ("D5=" + $wb.Worksheets.Item("银行存款余额调节表").Range("D5").Text)
$wb.Close($false); $xl.Quit()
[System.Runtime.InteropServices.Marshal]::ReleaseComObject($xl) | Out-Null
```

### 10.2 校验行数与合计
```powershell
$ws = $wb.Worksheets.Item("本月工资汇总表")
$rows = $ws.UsedRange.Rows.Count
$total = 0
for($r=2; $r -le $rows; $r++){ $total += [double]$ws.Cells($r,6).Value2 }  # F 列合计
Write-Output ("ROWS=" + ($rows-1) + " SUM=" + $total)
```

---

## 11. 输出模板（模型回答格式）

```
【一】题干解析   ：业务场景 / 输入输出 / 约束 / 变量表
【二】流程设计   ：活动树 + 变量表（名称/类型/范围/默认值）
【三】关键配置   ：每个活动属性值表
【四】工程代码   ：Main.xaml 全文
【五】运行验证   ：验证脚本 + 预期数值（行数/合计/关键字段）
【六】交付说明   ：压缩包内容清单 + 上传注意事项 + 已知限制
```

---

## 12. 常见坑总清单

1. `ActivityAction` 泛型写成 `Workbook` → 整棵子树失效（必须 `WorkbookApplication`）
2. 忘记 `TextExpression.ReferencesForImplementation` 里的 Excel/Mail 程序集 → 活动无法解析
3. 变量声明位置错误（范围过小）→ “变量未声明”
4. 数据表索引误用 1 基 → 取错列
5. 筛选数据表列索引按表头位置写，未减 1 → 差一列
6. 写入范围忘记 `AddHeaders=True` → 首行数据被当表头
7. 读取范围 `Range` 留空却只想读部分区域 → 读到整表
8. 外部工作簿公式相对引用但文件不同目录 → #REF!
9. 同一工作簿重复运行 → `0x8FE30C19`（表格重名）
10. 透视表期待有字段 → 经典活动只能建空骨架
11. 保存附件前未建文件夹 → 报错
12. POP3 用登录密码而非授权码 → 认证失败
13. 页面元素选取器含动态 id → 加通配符或变量
14. 输入文本未勾 `Simulate` → 慢且易失败
15. 打包时漏掉输入数据 → 评测环境读到空表（列1…列6）
16. 把运行后的结果文件打进包 → 再次运行报错

---

## 13. 科云平台 8 套业务系统环境档案

> 2026-10-21 实测（Chrome，账号 0202341073035）。

### 13.1 统一入口与拉起方式
- 平台：`https://cloud.acctedu.com/#/chapterContentList?...`，页面下方 8 个系统卡片。
- 点卡片文字 → **新开标签页** → 先显示“请稍候…” → 进入系统。
- 地址形如 `#/cloudRpa?params=<长 token>`、`#/rpaIndex?params=...`、`#/fssToolMain?params=...`。
  **token 随会话变化，绝不能写死 URL**；每次必须从平台入口点击进入，或调试期用页面上的「复制URL」。
- **单点登录并不彻底**：网银/开票/报税/认证/个税 直接进已登录界面；**仓储/会计信息化/ERP 仍弹各自登录页**，用户名或岗位已预填，初始密码统一 `123456`，需点「登 录」。
- 仓储系统是 **iframe 嵌套**（`document "仓储系统"` 位于 `RPA环境` 之内）；其余为整页。UiPath 选取器会自动多一层 `<html>`。

### 13.2 系统档案
| 系统 | 登录 | 身份/主体 | URL 特征 |
|---|---|---|---|
| 网银 | 免登录 | ST公司（客户号000001）制单员 | `#/cloudRpa?params=` |
| 开票 | 免登录 | 电子发票服务平台 | `#/cloudRpa?params=` |
| 报税 | 免登录 | 厦门铭鸿电子科技有限公司（A级），当前期间 2024-07 | `#/cloudRpa?params=` |
| 认证 | 免登录 | 厦门铭鸿电子科技有限公司 | `#/cloudRpa?params=` |
| 仓储 | 需登录 000001仓库管理员/123456 | 仓库进销存管理系统 | iframe `#/rpaIndex?params=` |
| 会计信息化 | 需登录 admin/123456 | 会计电算化云平台 | `#/cloudRpa?params=` |
| 个税 | 免登录 | 北京宝良制造有限公司，所属月份 2024-06 | `#/cloudRpa?params=` |
| ERP | 需登录 岗位=管理员/123456 | ERP业务中心 | `#/fssToolMain?params=` |

**网银**
- 顶部一级菜单（19）：欢迎页面、账户管理、收款业务、付款业务、集团理财、票据业务、国际业务、投资理财、托管服务、监管审批、投资银行、海关业务、薪酬福利、招标管理、客户服务、对公钱包、电子保函、指令核查、企业帮手。
- 账户管理：`账户余额` / `明细查询` / `答题结果`。
  - 明细查询：开始日期、结束日期（默认 2024-12-01）、查询、下载；表列：日期、对方户名、摘要、借方发生额、贷方发生额、余额、附言、操作。
- 付款业务：`转账申请记录`（日期起止、状态下拉、查询；列：日期、收款人单位名称、收款人账户、收款人开户行、金额、用途、状态）；`转账汇款申请`（付款人名称/账号/银行只读；收款人名称/账号/银行可填；金额；用途下拉默认“货款”；汇款方式下拉默认“普通”；摘要；附言；重置；提交）。

**开票（电子发票服务平台）**
- 菜单：蓝字发票开具、红字发票开具、开票信息维护、答题结果查看。
- 蓝字页：数据概览（可用授信额度、纸票数量、开票金额/累计税额/数量）；按钮 立即开票、发票草稿、复制开票；最近开票列：发票种类、发票票种、购方名称、数电发票号码、合计金额、开票日期。
- 开票信息维护：项目信息维护、客户信息维护、附加信息维护（均支持批量导入导出）。

**报税（电子税务局）**
- 顶部：首页、我要办税、我要查询、公众服务、查看答案。
- 我要办税 → 综合信息报告、发票使用、税费申报及缴纳、证明开具、一般退税管理。
- 税费申报及缴纳 → 增值税及附加税费申报（一般纳税人/小规模/预缴）、企业所得税申报（查账/核定·月季/年度）、财产和行为税申报、综合申报。
- 本期应申报列：事项名称、办理日期、标签状态、操作（填写申报表）。

**认证（税务数字账户）**
- 菜单：发票勾选确认、发票查询统计、海关缴款书采集、发票查验、发票额度调整申请、答题结果。
- 勾选页：抵扣类勾选 / 出口退税类勾选 / 不抵扣勾选；已勾选统计（发票税额、海关缴款书税额、代扣代缴完税凭证税额、农产品加计扣除税额）；属期月份选择器。

**仓储（仓库进销存，iframe）**
- 页内按钮：做题情况、**重置单据**、复制URL。
- 左侧：基础信息、物料维护、物料开单、物料查询、库存余额、库存报表。
- 物料开单：单据类型（入库单）、物料类别（原材料）、单据号码、校验码；按钮 增行、减行、清空、提交；列：物料编码、物料名称、规格、单位、入库数量、出库数量。
- 物料查询列：校验码、单据类型、物料类别、单据号码、操作。

**会计信息化（会计电算化云平台）**
- 左侧：基础设置、凭证列表、期末结账、会计账簿、财务报表、答题结果。
- 凭证列表 → 填制凭证、凭证列表、审核凭证。
- 凭证列表页：期间 2024年第01期；按钮 删除、凭证号排序、导出凭证、**导出凭证到Excel**、批量打印；列：凭证号、凭证日期、摘要、会计科目、借方金额、贷方金额、附件张数、制单人、审核人、凭证来源、影像、操作。

**个税（自然人电子税务局扣缴端）**
- 顶部：人员信息采集、专项附加扣除信息采集、综合所得申报、分类所得申报、税款缴纳、查询统计。
- 人员信息采集：总人数 18；按钮 添加、导入、报送、导出、展开查询条件、更多操作；列：工号、姓名、证件类型、证件号码、人员状态、任职受雇从业类型、手机号码、报送状态。

**ERP（ERP业务中心）**
- 左侧：采购管理、销售管理、资金管理、税务管理、仓库管理、凭证预处理。
- 采购管理 → 采购订单、收料通知、采购入库、应付单、采购订单跟踪表。
- 采购订单查询字段：单据编号、商品信息、单据日期起止；按钮 查询、重置、展开、新增、批量操作；列：状态、业务名称、供应商、业务类型、单据编号、商品信息、单据日期、采购员、数量、金额合计、操作。

### 13.3 针对这 8 套系统的 RPA 写法
1. **入口**：`Open Browser` 平台课程页（或让用户先点好）→ `Click` 卡片文字（innertext='仓储系统' 等）→ 等新标签页面出现 → `Attach Browser`（匹配标题 `RPA环境` / `ERP业务中心`，或 URL 含 `cloudRpa`/`rpaIndex`/`fssToolMain`）。
2. **不要写死 params**：token 每次不同，直接打开旧链接会失败。
3. **登录兼容**：先 `Element Exists` 判断是否出现「登 录」按钮；出现则 `Type Into` 密码 123456（用户名/岗位已预填）并点击登录；未出现直接继续。
4. **iframe**：仓储的选取器会多一层 `<html>`，先用 `Attach Browser` 再抓元素；窗口标题仍是 `RPA环境`。
5. **只查不改**：查询类题目只点 查询/下载/导出；有 提交/保存/审核/开票/申报 的页面，提交必须是流程最后一步，且确认数据无误。
6. **重复运行**：仓储可用「重置单据」恢复演示数据；其余系统若已有单据，先查询再决定新增，避免重复入账。
7. **下载路径**：明细查询的「下载」、凭证的「导出凭证到Excel」都走 Chrome 默认下载目录，运行前把下载目录固定到已知路径（`chrome://settings/downloads`），并用「等待文件生成」轮询。
8. **超时**：首次加载 3–5 秒，`Attach Browser` 的 Timeout 设 15 秒，`Wait For Element` 用 `aaname`/innertext 定位而非 CSS 路径。

### 13.4 环境无关性检查（拿到新环境先问）
1. Studio 版本 + 目标框架（Windows / Windows-Legacy）
2. 活动包版本（Excel 2.22.3 经典 Interop vs 2.24+ 现代）
3. 机器上是真 Excel / WPS 冒充 / 未装 Office（决定用 `ui:Excel*` 还是 `Workbook*`）
4. 运行方（本地 F5 / 课评平台临时目录 / 无人值守 Robot）
5. 区域设置（公式分隔符、小数点、日期格式）
6. 浏览器版本与下载目录

---

## 14. 可运行工程模板（复制即用）

### 14.1 工程文件清单与依赖
一个能被 Studio 打开、能被课评平台重建的最小工程：
```
Main.xaml
project.json
.settings/            （可空）
.project/             （可空）
.objects/             （可空）
.tmh/                 （可空）
<输入数据>.xlsx
```
`project.json` 关键字段（版本号务必写目标机器已安装的版本，否则报“包不存在”）：
```json
{
  "name": "{{项目名}}",
  "projectVersion": "1.0.0",
  "main": "Main.xaml",
  "dependencies": {
    "UiPath.Excel.Activities": "[2.22.3]",
    "UiPath.Mail.Activities": "[1.21.1]",
    "UiPath.System.Activities": "[23.10.5]",
    "UiPath.UIAutomation.Activities": "[23.10.8]"
  },
  "targetFramework": "Windows"
}
```

### 14.2 Excel 汇总机器人（本项目实测通过，可直接改字段复用）
结构：复制干净输入 → Excel 应用程序范围 → 读取范围 → 筛选列 → 写入范围 → 创建表格 → 创建透视表。
```xml
<Activity mc:Ignorable="sap sap2010" x:Class="Main" VisualBasic.Settings="{x:Null}"
  xmlns="http://schemas.microsoft.com/netfx/2009/xaml/activities"
  xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
  xmlns:sap="http://schemas.microsoft.com/netfx/2009/xaml/activities/presentation"
  xmlns:sap2010="http://schemas.microsoft.com/netfx/2010/xaml/activities/presentation"
  xmlns:scg="clr-namespace:System.Collections.Generic;assembly=System.Private.CoreLib"
  xmlns:sco="clr-namespace:System.Collections.ObjectModel;assembly=System.Private.CoreLib"
  xmlns:sd="clr-namespace:System.Data;assembly=System.Data.Common"
  xmlns:ui="http://schemas.uipath.com/workflow/activities"
  xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml">
  <TextExpression.NamespacesForImplementation>
    <sco:Collection x:TypeArguments="x:String">
      <x:String>System.Activities</x:String>
      <x:String>System.Activities.Statements</x:String>
      <x:String>System</x:String>
      <x:String>System.Data</x:String>
      <x:String>System.IO</x:String>
      <x:String>UiPath.Core</x:String>
      <x:String>UiPath.Core.Activities</x:String>
      <x:String>UiPath.Excel</x:String>
      <x:String>UiPath.Excel.Activities</x:String>
      <x:String>GlobalVariablesNamespace</x:String>
      <x:String>GlobalConstantsNamespace</x:String>
    </sco:Collection>
  </TextExpression.NamespacesForImplementation>
  <TextExpression.ReferencesForImplementation>
    <sco:Collection x:TypeArguments="AssemblyReference">
      <AssemblyReference>System</AssemblyReference>
      <AssemblyReference>System.Activities</AssemblyReference>
      <AssemblyReference>System.Data</AssemblyReference>
      <AssemblyReference>System.Data.Common</AssemblyReference>
      <AssemblyReference>System.Private.CoreLib</AssemblyReference>
      <AssemblyReference>UiPath.Excel.Activities</AssemblyReference>
      <AssemblyReference>UiPath.System.Activities</AssemblyReference>
      <AssemblyReference>UiPath.UiAutomation.Activities</AssemblyReference>
    </sco:Collection>
  </TextExpression.ReferencesForImplementation>
  <Sequence DisplayName="Main Sequence" sap2010:WorkflowViewState.IdRef="Sequence_1">
    <ui:CopyFile ContinueOnError="True" DisplayName="复制数据文件"
      Destination="[&quot;本月工资结算表.xlsx&quot;]"
      Overwrite="True" Path="[&quot;{{原始数据绝对路径}}&quot;]" />
    <ui:ExcelApplicationScope AutoSave="True" DisplayName="Excel 应用程序范围"
      WorkbookPath="[&quot;本月工资结算表.xlsx&quot;]">
      <ui:ExcelApplicationScope.Body>
        <ActivityAction x:TypeArguments="ui:WorkbookApplication">
          <ActivityAction.Argument>
            <DelegateInArgument x:TypeArguments="ui:WorkbookApplication" Name="ExcelWorkbookScope" />
          </ActivityAction.Argument>
          <Sequence DisplayName="执行">
            <Sequence.Variables>
              <Variable x:TypeArguments="sd:DataTable" Name="data" />
              <Variable x:TypeArguments="sd:DataTable" Name="data_1" />
            </Sequence.Variables>
            <ui:ExcelReadRange AddHeaders="True" DisplayName="读取范围" Range="{x:Null}" SheetName="[&quot;Sheet1&quot;]">
              <ui:ExcelReadRange.DataTable>
                <OutArgument x:TypeArguments="sd:DataTable">[data]</OutArgument>
              </ui:ExcelReadRange.DataTable>
            </ui:ExcelReadRange>
            <ui:FilterDataTable DataTable="[data]" DisplayName="筛选数据表"
              SelectColumnsMode="[UiPath.Core.Activities.SelectMode.Keep]">
              <ui:FilterDataTable.SelectColumns>
                <scg:List x:TypeArguments="InArgument" Capacity="6">
                  <InArgument x:TypeArguments="x:String">[&quot;一级部门&quot;]</InArgument>
                  <InArgument x:TypeArguments="x:String">[&quot;二级部门&quot;]</InArgument>
                  <InArgument x:TypeArguments="x:String">[&quot;基本薪资&quot;]</InArgument>
                  <InArgument x:TypeArguments="x:String">[&quot;奖金&quot;]</InArgument>
                  <InArgument x:TypeArguments="x:String">[&quot;加班费&quot;]</InArgument>
                  <InArgument x:TypeArguments="x:String">[&quot;合计&quot;]</InArgument>
                </scg:List>
              </ui:FilterDataTable.SelectColumns>
              <ui:FilterDataTable.OutputDataTable>
                <OutArgument x:TypeArguments="sd:DataTable">[data_1]</OutArgument>
              </ui:FilterDataTable.OutputDataTable>
            </ui:FilterDataTable>
            <ui:ExcelWriteRange AddHeaders="True" DataTable="[data_1]" DisplayName="写入范围"
              SheetName="[&quot;本月工资汇总表&quot;]" StartingCell="[&quot;A1&quot;]" />
            <ui:ExcelCreateTable DisplayName="创建表格" Range="[&quot;A1:F72&quot;]"
              SheetName="[&quot;本月工资汇总表&quot;]" TableName="[&quot;本月工资汇总表&quot;]" />
            <ui:ExcelCreatePivotTable DisplayName="创建透视表" Range="[&quot;A1&quot;]"
              SheetName="[&quot;工资汇总透视表&quot;]" SourceTableName="[&quot;本月工资汇总表&quot;]"
              TableName="[&quot;数据透视表&quot;]" />
          </Sequence>
        </ActivityAction>
      </ui:ExcelApplicationScope.Body>
    </ui:ExcelApplicationScope>
  </Sequence>
</Activity>
```
变量（声明在内层「执行」序列）：
| 名称 | 类型 | 作用 |
|---|---|---|
| data | DataTable | 整表原始数据 |
| data_1 | DataTable | 筛选后的输出表 |

### 14.3 Web 业务系统机器人骨架（科云 8 套系统通用）
流程：打开平台 → 点系统卡片 → 附加浏览器 → 判断是否要登录 → 登录 → 点菜单 → 查询/下载 → 结果落盘。
```xml
<Sequence DisplayName="Main Sequence">
  <!-- 1. 打开平台 -->
  <ui:OpenBrowser BrowserType="Chrome" CommunicationMethod="Native" DisplayName="打开平台"
    Url="[&quot;https://cloud.acctedu.com/#/chapterContentList&quot;]">
    <ui:OpenBrowser.Body>
      <ActivityAction x:TypeArguments="ui:Browser">
        <ActivityAction.Argument>
          <DelegateInArgument x:TypeArguments="ui:Browser" Name="Browser" />
        </ActivityAction.Argument>
        <Sequence DisplayName="网页操作">
          <Sequence.Variables>
            <Variable x:TypeArguments="x:Boolean" Name="needLogin" />
          </Sequence.Variables>

          <!-- 2. 点系统卡片（新开标签页） -->
          <ui:Click DisplayName="点击系统卡片">
            <ui:Click.Target>
              <ui:Target ClippingRegion="{x:Null}" Element="{x:Null}"
                Selector="&lt;html app='chrome.exe' title='RPA财务机器人应用与开发1.1' /&gt;&lt;webctrl tag='SPAN' aaname='{{系统名}}' /&gt;">
                <ui:Target.TimeoutMS><InArgument x:TypeArguments="x:Int32">15000</InArgument></ui:Target.TimeoutMS>
                <ui:Target.WaitForReady><InArgument x:TypeArguments="ui:WaitForReady">Complete</InArgument></ui:Target.WaitForReady>
              </ui:Target>
            </ui:Click.Target>
          </ui:Click>

          <!-- 3. 附加新标签页 -->
          <ui:AttachBrowser DisplayName="附加浏览器" Selector="&lt;html app='chrome.exe' title='RPA环境' /&gt;">
            <ui:AttachBrowser.Body>
              <ActivityAction x:TypeArguments="ui:Browser">
                <ActivityAction.Argument>
                  <DelegateInArgument x:TypeArguments="ui:Browser" Name="Browser" />
                </ActivityAction.Argument>
                <Sequence DisplayName="系统内操作">
                  <!-- 4. 判断是否需要登录（仓储/会计信息化/ERP 会弹登录页） -->
                  <ui:ElementExists DisplayName="是否存在登录按钮" Result="[needLogin]">
                    <ui:ElementExists.Target>
                      <ui:Target ClippingRegion="{x:Null}" Element="{x:Null}"
                        Selector="&lt;html app='chrome.exe' title='RPA环境' /&gt;&lt;webctrl tag='BUTTON' aaname='登 录' /&gt;">
                        <ui:Target.TimeoutMS><InArgument x:TypeArguments="x:Int32">5000</InArgument></ui:Target.TimeoutMS>
                      </ui:Target>
                    </ui:ElementExists.Target>
                  </ui:ElementExists>
                  <If Condition="[needLogin]" DisplayName="需要登录吗">
                    <If.Then>
                      <Sequence DisplayName="登录">
                        <ui:TypeInto DisplayName="输入密码" ClickBeforeTyping="False" EmptyField="True"
                          Text="[&quot;123456&quot;]">
                          <ui:TypeInto.Target>
                            <ui:Target ClippingRegion="{x:Null}" Element="{x:Null}"
                              Selector="&lt;html app='chrome.exe' title='RPA环境' /&gt;&lt;webctrl tag='INPUT' type='password' /&gt;">
                              <ui:Target.TimeoutMS><InArgument x:TypeArguments="x:Int32">10000</InArgument></ui:Target.TimeoutMS>
                            </ui:Target>
                          </ui:TypeInto.Target>
                        </ui:TypeInto>
                        <ui:Click DisplayName="点击登录">
                          <ui:Click.Target>
                            <ui:Target ClippingRegion="{x:Null}" Element="{x:Null}"
                              Selector="&lt;html app='chrome.exe' title='RPA环境' /&gt;&lt;webctrl tag='BUTTON' aaname='登 录' /&gt;">
                              <ui:Target.TimeoutMS><InArgument x:TypeArguments="x:Int32">10000</InArgument></ui:Target.TimeoutMS>
                            </ui:Target>
                          </ui:Click.Target>
                        </ui:Click>
                      </Sequence>
                    </If.Then>
                  </If>

                  <!-- 5. 进入菜单：仓储是 iframe，选取器多一层 html -->
                  <ui:Click DisplayName="点击菜单">
                    <ui:Click.Target>
                      <ui:Target ClippingRegion="{x:Null}" Element="{x:Null}"
                        Selector="&lt;html app='chrome.exe' title='RPA环境' /&gt;&lt;html /&gt;&lt;webctrl tag='A' innertext='{{菜单名}}' /&gt;">
                        <ui:Target.TimeoutMS><InArgument x:TypeArguments="x:Int32">15000</InArgument></ui:Target.TimeoutMS>
                      </ui:Target>
                    </ui:Click.Target>
                  </ui:Click>

                  <!-- 6. 查询 / 下载 / 导出 按题目补 -->
                </Sequence>
              </ActivityAction>
            </ui:AttachBrowser.Body>
          </ui:AttachBrowser>
        </Sequence>
      </ActivityAction>
    </ui:OpenBrowser.Body>
  </ui:OpenBrowser>
</Sequence>
```
变量：
| 名称 | 类型 | 说明 |
|---|---|---|
| needLogin | Boolean | 是否弹出了登录页 |
| dtData | DataTable | 抓取/读入的数据 |

选取器速查：
| 目标 | 写法 |
|---|---|
| 系统卡片 | `<html app='chrome.exe' title='RPA财务机器人应用与开发1.1' /><webctrl tag='SPAN' aaname='仓储系统' />` |
| 密码框 | `<html app='chrome.exe' title='RPA环境' /><webctrl tag='INPUT' type='password' />` |
| 登录按钮 | `<html app='chrome.exe' title='RPA环境' /><webctrl tag='BUTTON' aaname='登 录' />` |
| iframe 内菜单 | `<html app='chrome.exe' title='RPA环境' /><html /><webctrl tag='A' innertext='物料开单' />` |
| ERP 页面 | `title='ERP业务中心'`，其余同上 |

> 属性名以 Studio 23.10 生成结果为准；若活动报“无法解析”，在 Studio 里拖一次同名活动让设计器补全属性后再粘回去。

### 14.4 容错加固四件套
```xml
<!-- ① 重试：网络/加载慢时包住 Click -->
<ui:RetryScope DisplayName="重试" NumberOfRetries="3" RetryInterval="[TimeSpan.FromSeconds(2)]">
  <ui:RetryScope.ActivityBody>
    <ActivityAction>
      <ui:Click DisplayName="点击查询"> ... </ui:Click>
    </ActivityAction>
  </ui:RetryScope.ActivityBody>
</ui:RetryScope>

<!-- ② 异常：整段包 Try Catch，Finally 里保存/关闭 -->
<TryCatch DisplayName="异常处理">
  <TryCatch.Try> <Sequence DisplayName="主流程"> ... </Sequence> </TryCatch.Try>
  <TryCatch.Catches>
    <Catch x:TypeArguments="s:Exception">
      <ActivityAction x:TypeArguments="s:Exception">
        <ActivityAction.Argument>
          <DelegateInArgument x:TypeArguments="s:Exception" Name="exception" />
        </ActivityAction.Argument>
        <ui:LogMessage Level="Error" Message="[&quot;失败：&quot; + exception.Message]" />
      </ActivityAction>
    </Catch>
  </TryCatch.Catches>
  <TryCatch.Finally> <Sequence DisplayName="收尾" /> </TryCatch.Finally>
</TryCatch>
<!-- 需要 xmlns:s="clr-namespace:System;assembly=mscorlib" -->

<!-- ③ 等下载文件生成（不要写死 Delay） -->
<Assign DisplayName="初始化等待次数"> ... </Assign>
<ui:InterruptibleWhile DisplayName="等待文件" Condition="[Not File.Exists(下载路径) AndAlso n &lt; 60]">
  <ui:InterruptibleWhile.Body>
    <Sequence DisplayName="循环体">
      <ui:Delay DisplayName="等待 1 秒" Duration="[TimeSpan.FromSeconds(1)]" />
      <Assign DisplayName="计数"> n = n + 1 </Assign>
    </Sequence>
  </ui:InterruptibleWhile.Body>
</ui:InterruptibleWhile>
```

### 14.5 交付前自检（10 项）
1. Studio 加载 0 错误 0 警告
2. 变量全部声明、无黄色波浪线
3. 输入数据随包交付，且是原始数据而非运行结果
4. 顶部「复制文件」存在（Overwrite=True）
5. 输出工作表名与题目要求逐字一致
6. 行数、列名、合计值核对
7. 连续运行两次均成功（幂等）
8. 无绝对路径（除复制文件的源路径）
9. 无 MessageBox/InputDialog 阻塞无人值守运行
10. 压缩包不含 .local、bin、obj、日志