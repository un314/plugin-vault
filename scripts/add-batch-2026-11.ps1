#requires -Version 5.1
# 把 2026-11 这批开源项目/技能仓库补进 manifest 与分类索引
$ErrorActionPreference = 'Stop'
$Root = Split-Path -Parent $PSScriptRoot
$ManifestPath = Join-Path $Root 'manifest.json'
$PluginRoot = 'D:\github专用仓库\plugins'
$Utf8 = New-Object System.Text.UTF8Encoding($false)

$new = @(
    @{ name='dify'; dir='dify'; upstream='langgenius/dify'; type='python'; cat='AI'; desc='Agentic 工作流 + RAG 知识库平台，可自托管'; run='docker compose up -d（官方 compose，需 Docker）' },
    @{ name='open-webui'; dir='open-webui'; upstream='open-webui/open-webui'; type='node'; cat='AI'; desc='多模型 Web 工作台，可接 Ollama 或任意 OpenAI 兼容接口'; run='docker run -d -p 3000:8080 open-webui/open-webui' },
    @{ name='ollama'; dir='ollama'; upstream='ollama/ollama'; type='go'; cat='AI'; desc='本地大模型运行时（DeepSeek / Qwen / GLM / Gemma 等）'; run='装安装包后 ollama run qwen3' },
    @{ name='openhands'; dir='OpenHands'; upstream='OpenHands/OpenHands'; type='python'; cat='AI'; desc='AI 驱动的软件开发平台（原 All-Hands-AI/OpenHands）'; run='docker run（官方镜像，需 Docker）' },
    @{ name='loopforge'; dir='LoopForge'; upstream='Tencent/LoopForge'; type='go'; cat='AI'; desc='编码 Agent 交付流水线：编排 CodeBuddy / Codex / Claude Code，带人工审批门'; run='docker compose up -d' },
    @{ name='openmaic'; dir='OpenMAIC'; upstream='THU-MAIC/OpenMAIC'; type='node'; cat='AI'; desc='多智能体互动课堂，一键生成沉浸式学习体验'; run='pnpm install && pnpm dev（需模型 Key）' },
    @{ name='elephant-goldfish'; dir='elephant-goldfish-model'; upstream='google/elephant-goldfish-model'; type='python'; cat='AI'; desc='用 Agent 做软件设计与评审的插件（规格、评审、复查）'; run='装为 Claude/Codex 插件后使用' },
    @{ name='jevrouter'; dir='JevRouter'; upstream='BillionsBobby/JevRouter'; type='node'; cat='AI'; desc='模型、工具与子 Agent 的轻量路由'; run='npm install && npm run build' },
    @{ name='rust-anything'; dir='rust-anything'; upstream='erkamyaman/rust-anything'; type='rust'; cat='AI'; desc='把现有应用逐段改写成 Rust，每步用原行为录制做校验'; run='cargo install --path .' },
    @{ name='craft-anything'; dir='craft-anything'; upstream='storytold/craft-anything'; type='rust'; cat='AI'; desc='理解任意软件的实现并复刻（清室逆向重建引擎）'; run='cargo build --release' },
    @{ name='agent-autoloop'; dir='agent-autoloop'; upstream='KKKKhazix/agent-autoloop'; type='node'; cat='AI'; desc='命令行 Agent 自动接活、自动跟进，拿不准才发卡片找人拍板'; run='Node 22+，一条命令 autoloop run' },
    @{ name='agent-s'; dir='Agent-S'; upstream='simular-ai/Agent-S'; type='python'; cat='AI'; desc='开源 computer-use 智能体（与已装 computer-use 能力重叠，仅登记）'; run='pip install -e .（需图形桌面）' },
    @{ name='aris'; dir='Auto-claude-code-research-in-sleep'; upstream='wanshuiyin/Auto-claude-code-research-in-sleep'; type='skillpack'; cat='AI'; desc='ARIS 科研自动化技能包，91 个技能（选题、实验、审稿、论文写作）'; run='挑需要的子目录复制进 ~/.trae-cn/skills' },
    @{ name='scientific-agent-skills'; dir='scientific-agent-skills'; upstream='K-Dense-AI/scientific-agent-skills'; type='skillpack'; cat='AI'; desc='K-Dense 科学技能库，177 个技能，覆盖生物/化学/医学/药物发现'; run='挑需要的子目录复制进 ~/.trae-cn/skills' },
    @{ name='wechat-intelligence-hub'; dir='wechat-intelligence-hub'; upstream='Rion-Wu-tech/wechat-intelligence-hub'; type='python'; cat='AI'; desc='本地优先的微信情报库，含 wechat-cli 与情报库两个技能'; run='见仓库 docs，先跑 wechat-cli 建索引' },
    @{ name='nuwa-skill'; dir='nuwa-skill'; upstream='alchaincyf/nuwa-skill'; type='skill'; cat='AI'; desc='女娲：蒸馏任意人物的思维方式，生成可运行的人物 Skill'; run='已装入 ~/.trae-cn/skills/nuwa-skill'; local='已就位' },
    @{ name='darwin-skill'; dir='darwin-skill'; upstream='alchaincyf/darwin-skill'; type='skill'; cat='AI'; desc='达尔文：盲评 + 保留/回滚，自动进化 SKILL.md'; run='已装入 ~/.trae-cn/skills/darwin-skill'; local='已就位' },
    @{ name='douyin-downloader'; dir='douyin-downloader'; upstream='jiji262/douyin-downloader'; type='python'; cat='生活与科技'; desc='抖音批量下载：视频、图集、合集、音乐，带去重与断点重试'; run='pip install -r requirements.txt && python run.py' },
    @{ name='goink'; dir='goink'; upstream='sigpanic/goink'; type='go'; cat='生活与科技'; desc='Goink 桌面 AI 小说创作助手：对话式写作 + 状态追踪 + 本地语义搜索'; run='下载 Release 可执行文件' },
    @{ name='komi-store'; dir='komi-store'; upstream='komi-store/komi-store'; type='app'; cat='生活与科技'; desc='开源应用商店客户端，聚合 GitHub / Codeberg / Forgejo 的 Release'; run='下载 Android APK' },
    @{ name='awesome'; dir='awesome'; upstream='sindresorhus/awesome'; type='docs'; cat='资源'; desc='各类 Awesome 清单的总索引'; run='直接阅读 README' },
    @{ name='public-apis'; dir='public-apis'; upstream='public-apis/public-apis'; type='docs'; cat='资源'; desc='免费公开 API 目录（按领域分类）'; run='直接阅读 README / APILayer 索引' },
    @{ name='free-for-dev'; dir='free-for-dev'; upstream='ripienaar/free-for-dev'; type='docs'; cat='资源'; desc='开发者免费额度服务清单（SaaS / PaaS / IaaS）'; run='直接阅读 README' },
    @{ name='anydoc'; dir='anydoc'; upstream='firecrawl/anydoc'; type='rust'; cat='资源'; desc='Word / PPT / Excel / PDF / EPUB 转干净 Markdown（Rust 实现，带 Node/Python 绑定）'; run='npx anydoc 或 pip install anydoc' },
    @{ name='awesome-codex-skills'; dir='awesome-codex-skills'; upstream='composio-community/awesome-codex-skills'; type='docs'; cat='资源'; desc='Codex 技能合集；其中约 40 个与本机已装技能重复，只取缺失项'; run='挑缺失的技能目录复制进 ~/.trae-cn/skills' }
)

$m = Get-Content $ManifestPath -Raw -Encoding UTF8 | ConvertFrom-Json
$existing = @{}
foreach ($p in $m.plugins) { $existing[$p.name.ToLower()] = $true }

$localDirs = @{}
if (Test-Path $PluginRoot) {
    Get-ChildItem $PluginRoot -Directory | ForEach-Object { $localDirs[$_.Name.ToLower()] = $true }
}

# 补齐 local 字段
foreach ($p in $m.plugins) {
    $key = if ($p.dir) { $p.dir.ToLower() } else { $p.name.ToLower() }
    $status = if ($localDirs.ContainsKey($key)) { '已就位' } else { '仅登记' }
    if ($p.PSObject.Properties.Name -contains 'local') { $p.local = $status }
    else { $p | Add-Member -NotePropertyName local -NotePropertyValue $status }
}

$added = @()
foreach ($n in $new) {
    if ($existing.ContainsKey($n.name.ToLower())) { continue }
    $obj = [pscustomobject]@{
        name     = $n.name
        dir      = $n.dir
        upstream = $n.upstream
        fork     = $null
        commit   = ''
        type     = $n.type
        desc     = $n.desc
        run      = $n.run
        cat      = $n.cat
        local    = if ($n.local) { $n.local } else { '仅登记' }
    }
    $m.plugins += $obj
    $added += $n.name
}

$m.generatedAt = (Get-Date -Format 'yyyy-MM-dd')
[System.IO.File]::WriteAllText($ManifestPath, ($m | ConvertTo-Json -Depth 6), $Utf8)
"新增 $($added.Count) 条：$($added -join ', ')"
"总数：$($m.plugins.Count)"

# 重写四个分类表
$cats = [ordered]@{
    'ai'        = @{ title='AI 框架与智能体'; intro='AI 开发框架、编码代理、技能包与多智能体平台'; cat='AI' }
    'resources' = @{ title='实用资源与教程'; intro='Awesome 清单、数据集、教程与素材索引'; cat='资源' }
    'life-tech' = @{ title='生活与科技应用'; intro='可直接使用的应用类工具：视频、音乐、排盘、自动化等'; cat='生活与科技' }
    'browsers'  = @{ title='浏览器引擎'; intro='可嵌入的轻量浏览器与自动化内核'; cat='浏览器引擎' }
}
foreach ($k in $cats.Keys) {
    $info = $cats[$k]
    $rows = $m.plugins | Where-Object { $_.cat -eq $info.cat } | Sort-Object { $_.name.ToLower() }
    $lines = @(
        "# $($info.title)",
        '',
        "$($info.intro)（$($rows.Count)）",
        '',
        '| 项目 | 上游 | 类型 | 本地状态 | 说明 |',
        '|---|---|---|---|---|'
    )
    foreach ($r in $rows) {
        $lines += ('| `' + $r.name + '` | [' + $r.upstream + '](https://github.com/' + $r.upstream + ') | ' + $r.type + ' | ' + $r.local + ' | ' + $r.desc + ' |')
    }
    $lines += @('', '---', '', '安装与运行命令见 `docs/<项目名>.md`；换机恢复执行根目录 `bootstrap.ps1`。', '')
    [System.IO.File]::WriteAllText((Join-Path $Root "categories\$k.md"), ($lines -join "`r`n"), $Utf8)
}

# 统计技能数量（跳过 .system）
$skillCount = (Get-ChildItem (Join-Path $Root 'skills') -Directory | Where-Object { $_.Name -notlike '.*' }).Count
"技能数：$skillCount"
"分类数：" + (($m.plugins | Group-Object cat | ForEach-Object { "$($_.Name)=$($_.Count)" }) -join '  ')
