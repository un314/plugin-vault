param(
  [string]$Root = 'D:\github专用仓库\plugins',
  [switch]$SkipInstall
)

$ErrorActionPreference = 'Continue'
$Vault = Split-Path -Parent $PSCommandPath
$ManifestPath = Join-Path $Vault 'manifest.json'
if (-not (Test-Path $ManifestPath)) { throw "找不到 manifest.json: $ManifestPath" }
$Manifest = Get-Content $ManifestPath -Raw -Encoding UTF8 | ConvertFrom-Json

$Mirrors = @(
  'https://ghproxy.net/https://github.com',
  'https://ghfast.top/https://github.com',
  'https://github.com'
)

function Write-Step($msg) { Write-Host "  $msg" }
function Test-GitRepo($path) { Test-Path (Join-Path $path '.git') }

function Invoke-Clone($name, $repo, $target) {
  if (Test-GitRepo $target) { Write-Step "已存在，跳过：$name"; return $true }
  if (Test-Path $target) { Remove-Item $target -Recurse -Force -ErrorAction SilentlyContinue }
  foreach ($base in $Mirrors) {
    git clone --depth 1 --single-branch "$base/$repo.git" $target 2>&1 | Out-Null
    if (Test-GitRepo $target) {
      if ($base -ne 'https://github.com') {
        git -C $target remote set-url origin "https://github.com/$repo.git" 2>&1 | Out-Null
      }
      Write-Step "克隆成功：$name（$base）"
      return $true
    }
    if (Test-Path $target) { Remove-Item $target -Recurse -Force -ErrorAction SilentlyContinue }
  }
  Write-Step "克隆失败：$name"
  return $false
}

Write-Host "=== 1/3 检查运行时 ==="
$node = (Get-Command node -ErrorAction SilentlyContinue)
$py = (Get-Command py -ErrorAction SilentlyContinue)
Write-Step ("node : " + $(if ($node) { (node -v) } else { '未安装（Node 类插件不可用）' }))
Write-Step ("python: " + $(if ($py) { (& py -V 2>&1) } else { '未安装（Python 类插件不可用）' }))
Write-Step ("git  : " + (git --version))

New-Item -ItemType Directory -Path $Root -Force | Out-Null

Write-Host "=== 2/3 获取代码 ==="
$results = @()
foreach ($p in $Manifest.plugins) {
  $target = Join-Path $Root $p.dir
  $repo = if ($p.fork) { $p.fork } else { $p.upstream }
  $ok = Invoke-Clone $p.name $repo $target
  $results += [pscustomobject]@{ name = $p.name; clone = $ok; install = 'skipped'; note = '' }
}

if (-not $SkipInstall) {
  Write-Host "=== 3/3 安装依赖 ==="
  foreach ($p in $Manifest.plugins) {
    $r = $results | Where-Object { $_.name -eq $p.name }
    if (-not $r.clone) { continue }
    $target = Join-Path $Root $p.dir
    switch ($p.type) {
      'skill' {
        if ($p.skillSource) {
          $dst = Join-Path (Join-Path $env:USERPROFILE '.trae-cn\skills') $p.skillName
          if (Test-Path $dst) { Remove-Item $dst -Recurse -Force }
          Copy-Item (Join-Path $target $p.skillSource) $dst -Recurse -Force
          $r.install = 'ok'
        } else { $r.install = 'manual' }
      }
      'python' {
        if (-not $py) { $r.install = 'no-python'; break }
        $venv = Join-Path $target '.venv'
        if (-not (Test-Path $venv)) { & py -m venv $venv 2>&1 | Out-Null }
        $pip = Join-Path $venv 'Scripts\pip.exe'
        if ($p.pipInstall) {
          & $pip install $p.pipInstall 2>&1 | Select-Object -Last 1
          $r.install = 'ok'
        } else { $r.install = 'venv-only' }
      }
      'node' {
        if (-not $node) { $r.install = 'no-node'; break }
        Push-Location $target
        npm install --no-audit --no-fund 2>&1 | Select-Object -Last 1
        Pop-Location
        $r.install = 'ok'
      }
      default { $r.install = $p.type }   # docs / archive：无依赖
    }
  }
}

Write-Host ""
Write-Host "=== 结果 ==="
$results | ForEach-Object { "{0,-20} clone={1,-6} install={2} {3}" -f $_.name, $_.clone, $_.install, $_.note }
$fail = ($results | Where-Object { -not $_.clone }).Count
if ($fail -gt 0) { Write-Host "有 $fail 个未成功，网络问题可重跑本脚本（已完成的会跳过）。" }
