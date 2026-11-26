#requires -Version 5.1
$ErrorActionPreference = 'Stop'
$mp = 'D:\github????\plugin-vault\manifest.json'
$Utf8 = New-Object System.Text.UTF8Encoding($false)
$m = Get-Content $mp -Raw -Encoding UTF8 | ConvertFrom-Json
if (@($m.plugins | Where-Object { $_.name -eq 'shadcn-admin' }).Count -eq 0) {
    $m.plugins += [pscustomobject]@{
        name = 'shadcn-admin'; dir = 'shadcn-admin'; upstream = 'satnaing/shadcn-admin'; fork = $null; commit = ''
        type = 'app'; cat = '??'
        desc = '???????????:Shadcn + Vite + Tailwind,??????????????(MIT,17k?)'
        run = 'pnpm install && pnpm dev;????,?????'
        local = '???'; storage = 'ondemand'
    }
}
$m.generatedAt = (Get-Date -Format 'yyyy-MM-dd')
[System.IO.File]::WriteAllText($mp, ($m | ConvertTo-Json -Depth 6), $Utf8)
"?? $($m.plugins.Count);?? $(@($m.plugins | Where-Object cat -eq '??').Count)"
