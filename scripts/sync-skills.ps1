#requires -Version 5.1
<#
  Trae 技能库双向同步
  1) 从 GitHub 拉取（网页端新增的技能）
  2) 仓库里已有、本机没有的技能 -> 复制到本机技能目录
  3) 本机技能 -> 镜像到仓库对应文件夹
  4) 有变化则提交并推送（失败自动重试）
#>

param(
    [string]$SkillsDir = "$env:USERPROFILE\.trae-cn\skills",
    [string]$RepoDir   = "D:\github专用仓库\plugin-vault",
    [string]$RepoSub   = "skills",
    [string]$LogFile   = "D:\github专用仓库\_skills_sync.log"
)

function Write-Log {
    param([string]$Level, [string]$Message)
    $line = "[{0}] [{1}] {2}" -f (Get-Date -Format 'yyyy-MM-dd HH:mm:ss'), $Level, $Message
    Write-Host $line
    Add-Content -Path $LogFile -Value $line -Encoding UTF8
}

function Invoke-Git {
    param([string[]]$GitArgs, [switch]$IgnoreError)
    $out = & git -C $RepoDir @GitArgs 2>&1 | Out-String
    if ($LASTEXITCODE -ne 0 -and -not $IgnoreError) {
        throw ("git " + ($GitArgs -join ' ') + " 失败：" + $out.Trim())
    }
    return $out
}

function Get-SkillDescription {
    param([string]$SkillPath)
    $skillMd = Join-Path $SkillPath 'SKILL.md'
    if (-not (Test-Path $skillMd)) { return '' }
    $head = Get-Content $skillMd -TotalCount 15 -Encoding UTF8
    foreach ($line in $head) {
        if ($line -match '^\s*description:\s*"?(.*?)"?\s*$') { return $Matches[1] }
    }
    return ''
}

try {
    Write-Log 'INFO' '===== 开始同步技能库 ====='

    if (-not (Test-Path $SkillsDir)) { throw "本机技能目录不存在：$SkillsDir" }
    if (-not (Test-Path (Join-Path $RepoDir '.git'))) { throw "技能仓库未初始化：$RepoDir" }
    $SkillRepo = Join-Path $RepoDir $RepoSub
    New-Item -ItemType Directory -Path $SkillRepo -Force | Out-Null

    # 1) 拉取远端
    $pull = Invoke-Git -GitArgs @('pull', '--rebase', '--autostash') -IgnoreError
    if ($LASTEXITCODE -eq 0) { Write-Log 'INFO' '已拉取 GitHub 最新内容' }
    else {
        Invoke-Git -GitArgs @('rebase', '--abort') -IgnoreError | Out-Null
        Write-Log 'WARN' ('拉取失败（继续用本地内容）：' + ($pull -split "`n" | Select-Object -First 1))
    }

    # 2) 仓库有新技能而本机没有 -> 复制到本机
    $normalizedSkills = (Resolve-Path $SkillsDir).Path
    foreach ($remoteSkill in (Get-ChildItem $SkillRepo -Directory -Force | Where-Object { $_.Name -notlike '.*' })) {
        if (-not (Test-Path (Join-Path $remoteSkill.FullName 'SKILL.md'))) { continue }
        $localTarget = Join-Path $normalizedSkills $remoteSkill.Name
        if (-not (Test-Path $localTarget)) {
            Copy-Item $remoteSkill.FullName $localTarget -Recurse -Force
            Write-Log 'INFO' ("[新增到本机] " + $remoteSkill.Name)
        }
    }

    # 3) 本机技能 -> 镜像到仓库
    $changed = @()
    foreach ($localSkill in (Get-ChildItem $SkillsDir -Directory -Force | Where-Object { $_.Name -notlike '.*' })) {
        $dst = Join-Path $SkillRepo $localSkill.Name
        $res = robocopy $localSkill.FullName $dst /MIR /NFL /NDL /NJH /NJS /NP /R:1 /W:1
        if ($LASTEXITCODE -ge 8) {
            Write-Log 'WARN' ("[复制失败] " + $localSkill.Name + " rc=" + $LASTEXITCODE)
        }
        elseif (-not (Test-Path $dst)) {
            Write-Log 'WARN' ("[复制异常] " + $localSkill.Name)
        }
    }

    # 4) 重建 README 技能清单
    $lines = @(
        '# 我的 Trae 技能库',
        '',
        '本仓库备份本机 `C:\Users\dizey\.trae-cn\skills\` 下的全部技能，每个技能一个独立文件夹。',
        '',
        '## 技能清单',
        ''
    )
    foreach ($localSkill in (Get-ChildItem $SkillsDir -Directory -Force | Where-Object { $_.Name -notlike '.*' } | Sort-Object Name)) {
        $desc = Get-SkillDescription -SkillPath $localSkill.FullName
        if ($desc) { $lines += ('- `' + $localSkill.Name + '` — ' + $desc) }
        else { $lines += ('- `' + $localSkill.Name + '`') }
    }
    $lines += @(
        '',
        '## 恢复方式（换电脑 / 重装）',
        '',
        '把需要的技能文件夹整体复制回 `C:\Users\dizey\.trae-cn\skills\` 即可，无需其他配置。',
        '',
        '## 同步机制',
        '',
        '- 本机新增技能 -> 自动复制进本仓库对应文件夹 -> 自动提交并推送到 GitHub',
        '- GitHub 上新增的技能文件夹 -> 自动复制回本机技能目录',
        '- 每天定时执行一次'
    )
    Set-Content -Path (Join-Path $SkillRepo 'README.md') -Value $lines -Encoding UTF8

    # 5) 提交并推送
    Invoke-Git -GitArgs @('add', '-A') | Out-Null
    $staged = Invoke-Git -GitArgs @('diff', '--cached', '--name-only')
    if ([string]::IsNullOrWhiteSpace($staged)) {
        Write-Log 'INFO' '无变化，跳过提交'
    }
    else {
        $names = ($staged -split "`r?`n" | Where-Object { $_ -match '\S' } | ForEach-Object { ($_ -split '/')[0].Trim() } | Sort-Object -Unique) -join ', '
        # 注意：PS 5.1 用数组 splat 调用原生命令时不会给含空格的参数加引号，
        # 会把提交信息拆成多个 pathspec。这里必须直接传单个表达式。
        $msg = "skills: 同步 " + $names
        # 用 -F 传文件，彻底绕开 PS 5.1 对含空格/逗号参数的错误拆分
        $msgFile = Join-Path $env:TEMP 'trae-skills-commit-msg.txt'
        [System.IO.File]::WriteAllText($msgFile, $msg, (New-Object System.Text.UTF8Encoding($false)))
        & git -C $RepoDir commit -F $msgFile | Out-Null
        if ($LASTEXITCODE -ne 0) { throw ("git commit 失败：" + $msg) }
        $pushed = $false
        for ($i = 1; $i -le 6; $i++) {
            Invoke-Git -GitArgs @('push', 'origin', 'HEAD:main') -IgnoreError | Out-Null
            if ($LASTEXITCODE -eq 0) { $pushed = $true; break }
            Write-Log 'WARN' ("推送第 $i 次失败，20 秒后重试")
            Start-Sleep -Seconds 20
        }
        if ($pushed) { Write-Log 'INFO' ("已推送到 GitHub：" + $names) }
        else { Write-Log 'ERROR' '推送多次失败，下次运行会重试' }
    }

    Write-Log 'INFO' '===== 同步结束 ====='
}
catch {
    Write-Log 'ERROR' ('同步异常：' + $_.Exception.Message)
    exit 1
}
