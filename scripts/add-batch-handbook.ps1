#requires -Version 5.1
$ErrorActionPreference = 'Stop'
$mp = 'D:\github????\plugin-vault\manifest.json'
$Utf8 = New-Object System.Text.UTF8Encoding($false)
$m = Get-Content $mp -Raw -Encoding UTF8 | ConvertFrom-Json

$new = @(
    @{ name='mediacrawler'; dir='MediaCrawler'; upstream='NanmiCoder/MediaCrawler'; type='python'; cat='?????';
       desc='???????:???/??/??/B?/??/??/???????????(? douyin-downloader ??,??????)';
       run='pip install -r requirements.txt;?? config ?? cookie,? python main.py' },
    @{ name='ai-money-maker-handbook'; dir='ai-money-maker-handbook'; upstream='XiaomingX/ai-money-maker-handbook'; type='docs'; cat='??';
       desc='AI ?????????,?????????????';
       run='???? README ???' }
)

$added = @()
foreach ($n in $new) {
    if (@($m.plugins | Where-Object { $_.name -eq $n.name }).Count -gt 0) { continue }
    $m.plugins += [pscustomobject]@{
        name     = $n.name
        dir      = $n.dir
        upstream = $n.upstream
        fork     = $null
        commit   = ''
        type     = $n.type
        desc     = $n.desc
        run      = $n.run
        cat      = $n.cat
        local    = '???'
        storage  = 'ondemand'
    }
    $added += $n.name
}

$m.generatedAt = (Get-Date -Format 'yyyy-MM-dd')
[System.IO.File]::WriteAllText($mp, ($m | ConvertTo-Json -Depth 6), $Utf8)
"??: $($added -join ', ');?? $($m.plugins.Count)"
"??: " + (($m.plugins | Group-Object cat | ForEach-Object { "$($_.Name)=$($_.Count)" }) -join ' ')
