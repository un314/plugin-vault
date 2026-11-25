#requires -Version 5.1
<#
  按需拉取项目（默认临时目录，跑完清理；-Keep 才常驻 D 盘）
  用法：
    .\fetch-project.ps1 -Name dify              # 临时拉到 %TEMP%\trae-projects\dify
    .\fetch-project.ps1 -Name ollama -Keep      # 常驻 D:\github专用仓库\plugins\ollama
    .\fetch-project.ps1 -Repo owner/repo        # 未登记的项目
    .\fetch-project.ps1 -Clean                  # 清掉所有临时项目
#>
param(
    [string]$Name,
    [string]$Repo,
    [switch]$Keep,
    [switch]$Force,
    [switch]$Clean
)

$ErrorActionPreference = 'Stop'
$Root = Split-Path -Parent $PSScriptRoot
$ManifestPath = Join-Path $Root 'manifest.json'
$TempRoot = Join-Path $env:TEMP 'trae-projects'
$ResidentRoot = 'D:\github专用仓库\plugins'

if ($Clean) {
    if (Test-Path $TempRoot) { Remove-Item $TempRoot -Recurse -Force; "已清理：$TempRoot" }
    else { "无需清理：$TempRoot 不存在" }
    return
}

if (-not $Name -and -not $Repo) { throw '需要 -Name <登记项目> 或 -Repo owner/repo' }

$dirName = $Name
if ($Name) {
    $m = Get-Content $ManifestPath -Raw -Encoding UTF8 | ConvertFrom-Json
    $p = $m.plugins | Where-Object { $_.name -eq $Name } | Select-Object -First 1
    if (-not $p) { throw "未登记的项目：$Name（可改用 -Repo owner/repo）" }
    $Repo = $p.upstream
    if ($p.dir) { $dirName = $p.dir }
}

# 体积保护：超过 200MB 需要 -Force
try {
    $r = Invoke-RestMethod "https://api.github.com/repos/$Repo" -Headers @{ 'User-Agent' = 'trae-on-demand' } -TimeoutSec 20
    $mb = [math]::Round($r.size / 1024, 1)
    "仓库 $Repo 约 $mb MB"
    if ($r.size -gt 204800 -and -not $Force) {
        throw "体积较大（$mb MB），确认要下载请加 -Force；C 盘空间紧张时建议只做登记"
    }
}
catch [System.Management.Automation.MethodInvocationException] { }
catch { if ($_.Exception.Message -like '体积较大*') { throw }; }

$dest = if ($Keep) { Join-Path $ResidentRoot $dirName } else { Join-Path $TempRoot $dirName }
if (Test-Path $dest) {
    "已存在，直接使用：$dest"
    if (-not $Keep) { "用完执行 .\fetch-project.ps1 -Clean 清理" }
    return
}

New-Item -ItemType Directory -Force -Path (Split-Path $dest) | Out-Null
$oldEap = $ErrorActionPreference
$ErrorActionPreference = 'SilentlyContinue'
git clone --depth 1 "https://github.com/$Repo.git" $dest 2>&1 | Out-Null
$code = $LASTEXITCODE
$ErrorActionPreference = $oldEap
if ($code -ne 0) { throw "克隆失败：$Repo（可能需要代理）" }

$size = [math]::Round(((Get-ChildItem $dest -Recurse -File | Measure-Object Length -Sum).Sum) / 1MB, 1)
"已拉到：$dest（$size MB）"
if ($Keep) { "已常驻 D 盘，可在 manifest.json 里把 local 改为已就位" }
else { "临时目录，用完执行 .\fetch-project.ps1 -Clean 清理" }
