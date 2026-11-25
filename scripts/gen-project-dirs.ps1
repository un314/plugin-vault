#requires -Version 5.1
# 为每个登记项目生成独立目录 + 索引（projects/<name>/README.md、PROJECTS.md）
$ErrorActionPreference = 'Stop'
$Root = Split-Path -Parent $PSScriptRoot
$ManifestPath = Join-Path $Root 'manifest.json'
$Utf8 = New-Object System.Text.UTF8Encoding($false)
$m = Get-Content $ManifestPath -Raw -Encoding UTF8 | ConvertFrom-Json

$projDir = Join-Path $Root 'projects'
New-Item -ItemType Directory -Force -Path $projDir | Out-Null

function Get-Storage($p) {
    if ($p.local -eq '仅登记') { return '按需（未下载）' }
    if ($p.local -eq '已停用') { return '已归档（不加载）' }
    if ($p.type -eq 'skill') { return '常驻（技能目录）' }
    return '常驻（D 盘）'
}

$rows = @()
foreach ($p in ($m.plugins | Sort-Object { $_.name.ToLower() })) {
    $storage = Get-Storage $p
    $doc = Join-Path $Root "docs\$($p.name).md"
    $docLine = if (Test-Path $doc) { "- 详细说明：[docs/$($p.name).md](../../docs/$($p.name).md)" } else { "- 详细说明：暂无（见下方用途与运行）" }
    $lines = @(
        "# $($p.name)",
        '',
        "- 上游：https://github.com/$($p.upstream)",
        "- 分类：$($p.cat) ｜ 类型：$($p.type)",
        "- 存放：$storage",
        "- 用途：$($p.desc)",
        "- 运行：$($p.run)",
        "- 按需拉取：``powershell -ExecutionPolicy Bypass -File scripts\fetch-project.ps1 -Name $($p.name)``（默认临时目录，跑完 `-Clean`）",
        "- 要转常驻：同上加 ``-Keep``，落到 ``D:\github专用仓库\plugins\$($p.dir)``",
        $docLine,
        '- 返回总索引：[PROJECTS.md](../../PROJECTS.md)',
        '',
        '---',
        '',
        '存放规则：基础能力、高频或大用量才常驻 D 盘；其余按需拉取，用完清理。'
    )
    $dir = Join-Path $projDir $p.name
    New-Item -ItemType Directory -Force -Path $dir | Out-Null
    [System.IO.File]::WriteAllText((Join-Path $dir 'README.md'), ($lines -join "`r`n"), $Utf8)

    $up = if ($p.upstream) { "[$($p.upstream)](https://github.com/$($p.upstream))" } else { '—' }
    $rows += [pscustomobject]@{ Name = $p.name; Up = $up; Cat = $p.cat; Type = $p.type; Storage = $storage }
}

$idx = @(
    '# 项目索引',
    '',
    "共 $($rows.Count) 个项目。每个项目在 `projects/<名字>/README.md` 有独立页，含上游直达链接、用途、运行方式与拉取命令。",
    '',
    '## 存放规则',
    '',
    '- 常驻：基础能力、高频使用或大用量 —— 在 D 盘留一份，如 `D:\github专用仓库\plugins\<名字>`（技能本身就在 `skills/`）。',
    '- 按需：其余一律不下载，`scripts\fetch-project.ps1 -Name <名字>` 临时拉到 `%TEMP%`，用完 `-Clean`。',
    '',
    '## 全部项目',
    '',
    '| 项目 | 上游 | 分类 | 类型 | 存放 |',
    '|---|---|---|---|---|'
)
foreach ($r in $rows) {
    $idx += ('| [`' + $r.Name + '`](projects/' + $r.Name + '/README.md) | ' + $r.Up + ' | ' + $r.Cat + ' | ' + $r.Type + ' | ' + $r.Storage + ' |')
}
[System.IO.File]::WriteAllText((Join-Path $Root 'PROJECTS.md'), ($idx -join "`r`n"), $Utf8)
"生成 $($rows.Count) 个项目目录；常驻 $(@($rows | Where-Object { $_.Storage -like '常驻*' }).Count)，按需 $(@($rows | Where-Object { $_.Storage -like '按需*' }).Count)"
