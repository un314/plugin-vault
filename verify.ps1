param([string]$Root = 'D:\github专用仓库\plugins')

$ErrorActionPreference = 'Continue'
$Vault = Split-Path -Parent $PSCommandPath
$Manifest = Get-Content (Join-Path $Vault 'manifest.json') -Raw -Encoding UTF8 | ConvertFrom-Json

$rows = @()
foreach ($p in $Manifest.plugins) {
  $target = Join-Path $Root $p.dir
  $gitOk = Test-Path (Join-Path $target '.git')
  $commit = ''
  if ($gitOk) { $commit = (git -C $target rev-parse --short HEAD 2>$null) }

  $avail = 'N/A'
  $extra = ''
  switch ($p.type) {
    'skill' {
      $dst = Join-Path (Join-Path $env:USERPROFILE '.trae-cn\skills') $p.skillName
      $ok = Test-Path (Join-Path $dst 'SKILL.md')
      $avail = if ($ok) { '已安装' } else { '缺技能文件' }
      if ($ok) { $extra = $p.skillName }
    }
    'python' {
      $venv = Join-Path $target '.venv'
      $avail = if (Test-Path (Join-Path $venv 'Scripts\python.exe')) { 'venv 就绪' } else { '未建 venv' }
    }
    'node' {
      $avail = if (Test-Path (Join-Path $target 'node_modules')) { '依赖已装' } else { '未装依赖' }
    }
    'docs' { $avail = if ($gitOk) { '可阅读' } else { '缺失' } }
    default { $avail = $p.type }
  }

  $rows += [pscustomobject]@{
    插件   = $p.name
    代码   = $(if ($gitOk) { $commit } else { '缺失' })
    可用性 = $avail
    备注   = $extra
  }
}

$rows | Format-Table -AutoSize
$bad = ($rows | Where-Object { $_.代码 -eq '缺失' }).Count
Write-Host ("总计 {0} 个，缺失 {1} 个" -f $rows.Count, $bad)
if ($bad -gt 0) { exit 1 }
