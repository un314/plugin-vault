#requires -Version 5.1
# 设计技能择优：登记 impeccable，停用同类的四个
$ErrorActionPreference = 'Stop'
$ManifestPath = 'D:\github专用仓库\plugin-vault\manifest.json'
$Utf8 = New-Object System.Text.UTF8Encoding($false)
$m = Get-Content $ManifestPath -Raw -Encoding UTF8 | ConvertFrom-Json

foreach ($p in $m.plugins) {
    if ($p.name -in @('taste-skill', 'frontend-design')) { $p.local = '已停用' }
}

$exists = @($m.plugins | Where-Object { $_.name -eq 'impeccable' }).Count
if ($exists -eq 0) {
    $m.plugins += [pscustomobject]@{
        name     = 'impeccable'
        dir      = 'impeccable'
        upstream = 'pbakaus/impeccable'
        fork     = $null
        commit   = '4.11.0'
        type     = 'skill'
        desc     = '设计主技能：设计/重做/评审/审计/打磨/动效，自带引擎，可截图自检'
        run      = '已装入 ~/.trae-cn/skills/impeccable（首次运行自动下载引擎）'
        cat      = 'AI'
        local    = '已就位'
    }
}

$exists = @($m.plugins | Where-Object { $_.name -eq 'web-design-guidelines' }).Count
if ($exists -eq 0) {
    $m.plugins += [pscustomobject]@{
        name     = 'web-design-guidelines'
        dir      = 'web-design-guidelines'
        upstream = 'vercel-labs/web-interface-guidelines'
        fork     = $null
        commit   = ''
        type     = 'skill'
        desc     = 'Vercel 界面规范审查（审计能力已并入 impeccable）'
        run      = '已归档到 archive/skills-disabled，不再加载'
        cat      = 'AI'
        local    = '已停用'
    }
}

$m.generatedAt = (Get-Date -Format 'yyyy-MM-dd')
[System.IO.File]::WriteAllText($ManifestPath, ($m | ConvertTo-Json -Depth 6), $Utf8)
"总数 $($m.plugins.Count)；AI $(@($m.plugins | Where-Object cat -eq 'AI').Count)"
