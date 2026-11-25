#requires -Version 5.1
<#
  按需拉取技能（不长期占用本机与仓库空间）
  用法：
    # 看某个技能包里有什么
    .\fetch-skill.ps1 -Preset aris -List
    # 临时拉一个技能到 %TEMP%\trae-on-demand\paper-write
    .\fetch-skill.ps1 -Preset aris -Path paper-write
    # 用完清理
    .\fetch-skill.ps1 -Clean
    # 任意仓库
    .\fetch-skill.ps1 -Repo owner/repo -Path skills/xxx
#>
param(
    [string]$Repo,
    [string]$Path,
    [ValidateSet('aris','science','codex')]
    [string]$Preset,
    [string]$Dest = "$env:TEMP\trae-on-demand",
    [switch]$List,
    [switch]$Clean
)

$ErrorActionPreference = 'Stop'
$Utf8 = New-Object System.Text.UTF8Encoding($false)

function Get-Token {
    $t = $null
    try { $t = (& gh auth token 2>$null) } catch { }
    if ($t) { $t.Trim() } else { $null }
}

function Get-Headers {
    $h = @{ 'User-Agent' = 'trae-on-demand'; 'Accept' = 'application/vnd.github+json' }
    $t = Get-Token
    if ($t) { $h['Authorization'] = "Bearer $t" }
    return $h
}

# 预设：两个大技能包 + Codex 技能合集
$presets = @{
    'aris'    = @{ repo = 'wanshuiyin/Auto-claude-code-research-in-sleep'; base = 'skills' }
    'science' = @{ repo = 'K-Dense-AI/scientific-agent-skills';            base = 'skills' }
    'codex'   = @{ repo = 'composio-community/awesome-codex-skills';       base = '' }
}

if ($Clean) {
    if (Test-Path $Dest) { Remove-Item $Dest -Recurse -Force; "已清理：$Dest" }
    else { "无需清理：$Dest 不存在" }
    return
}

if ($Preset) {
    $Repo = $presets[$Preset].repo
    if (-not $Path -and -not $List) { $List = $true }
    $base = $presets[$Preset].base
}
else { $base = 'skills' }

if (-not $Repo) { throw '需要 -Repo owner/repo 或 -Preset aris|science|codex' }

# 列目录
if ($List) {
    $q = if ($base) { $base } else { '' }
    $url = "https://api.github.com/repos/$Repo/contents/$q"
    $items = Invoke-RestMethod $url -Headers (Get-Headers) -TimeoutSec 30
    $dirs = $items | Where-Object { $_.type -eq 'dir' }
    "$Repo 共 $($dirs.Count) 个技能目录："
    $dirs | ForEach-Object { '  ' + $_.name }
    '' | Out-Null
    "拉取用法：.\fetch-skill.ps1 -Repo $Repo -Path $(if ($base) { "$base/<名字>" } else { '<名字>' })"
    return
}

if (-not $Path) { throw '需要 -Path（技能子目录），或加 -List 先看清单' }

New-Item -ItemType Directory -Force -Path $Dest | Out-Null
$leaf = ($Path -split '/')[-1]
$target = Join-Path $Dest $leaf
if (Test-Path $target) { Remove-Item $target -Recurse -Force }

$clone = Join-Path $env:TEMP ('ondemand-' + [guid]::NewGuid().ToString('N').Substring(0, 8))
$oldEap = $ErrorActionPreference
$ErrorActionPreference = 'SilentlyContinue'
try {
    # 稀疏克隆：只取目标目录，不下载整仓
    git clone --depth 1 --filter=blob:none --sparse "https://github.com/$Repo.git" $clone 2>&1 | Out-Null
    if ($LASTEXITCODE -ne 0) { throw 'git 克隆失败（可能需要代理）' }
    git -C $clone sparse-checkout set --no-cone "/$Path/" 2>&1 | Out-Null
    if ($LASTEXITCODE -ne 0) { throw "路径不存在：$Path" }

    $src = Join-Path $clone ($Path -replace '/', '\')
    if (-not (Test-Path $src)) { throw "没找到目录：$Path" }
    Copy-Item $src $target -Recurse -Force
}
catch {
    if (Test-Path $clone) { Remove-Item $clone -Recurse -Force -ErrorAction SilentlyContinue }
    throw
}
finally {
    if (Test-Path $clone) { Remove-Item $clone -Recurse -Force -ErrorAction SilentlyContinue }
    $ErrorActionPreference = $oldEap
}

$skillMd = Join-Path $target 'SKILL.md'
$size = [math]::Round(((Get-ChildItem $target -Recurse -File | Measure-Object Length -Sum).Sum) / 1KB)
"已拉到：$target（$size KB）"
if (Test-Path $skillMd) {
    "让 AI 直接读这个文件即可：$skillMd"
    "用完执行 .\fetch-skill.ps1 -Clean 清理"
}
else { "该目录没有 SKILL.md，可按需阅读其中的 md 文件" }
