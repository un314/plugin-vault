param(
    [string]$StudioDir = "$env:LOCALAPPDATA\Programs\UiPath\Studio",
    [string]$ExpectedVersionPrefix = "23.10"
)

$script:fail = 0

function Report([string]$Name, [bool]$Ok, [string]$Detail) {
    $status = if ($Ok) { "PASS" } else { "FAIL" }
    Write-Host ("[{0}] {1} - {2}" -f $status, $Name, $Detail)
    if (-not $Ok) { $script:fail++ }
}

Write-Host "UiPath exam environment check"
Write-Host ("Studio dir: {0}" -f $StudioDir)
Write-Host ""

$exe = Join-Path $StudioDir "UiPath.Studio.exe"
if (Test-Path $exe) {
    $full = (Get-Item $exe).VersionInfo.ProductVersion
    $ver = $full.Split("+")[0]
    Report "Studio version" ($ver.StartsWith($ExpectedVersionPrefix)) ("{0}, expected {1}.x" -f $ver, $ExpectedVersionPrefix)
} else {
    Report "Studio version" $false "UiPath.Studio.exe not found"
}

$exes = @(Get-ChildItem $StudioDir -Filter "UiPath.UpdateService*.exe" -File -ErrorAction SilentlyContinue)
Report "UpdateService exe removed" ($exes.Count -eq 0) ("{0} left" -f $exes.Count)

$baks = @(Get-ChildItem $StudioDir -Filter "UiPath.UpdateService*.bak" -File -ErrorAction SilentlyContinue)
Report "UpdateService renamed to .bak" ($baks.Count -ge 2) ("{0} found" -f $baks.Count)

$procs = @(Get-Process -Name "UiPath.UpdateService*" -ErrorAction SilentlyContinue)
Report "No UpdateService process" ($procs.Count -eq 0) ("{0} running" -f $procs.Count)

$tasks = @(Get-ScheduledTask -TaskName "UiPath Upgrade Service*" -ErrorAction SilentlyContinue)
$enabled = @($tasks | Where-Object { $_.State -ne "Disabled" })
Report "Upgrade tasks disabled" ($tasks.Count -gt 0 -and $enabled.Count -eq 0) ("{0} tasks, {1} enabled" -f $tasks.Count, $enabled.Count)

$packages = @("uipath.excel.activities", "uipath.system.activities", "uipath.uiautomation.activities")
foreach ($pkg in $packages) {
    $dir = Join-Path "$env:USERPROFILE\.nuget\packages" $pkg
    if (Test-Path $dir) {
        $versions = (Get-ChildItem $dir -Directory | Select-Object -ExpandProperty Name) -join ", "
        Report ("Package {0}" -f $pkg) $true $versions
    } else {
        Report ("Package {0}" -f $pkg) $false "not cached, restore online or use a local feed"
    }
}

Write-Host ""
if ($script:fail -gt 0) {
    Write-Host ("RESULT: FAIL ({0} item(s))" -f $script:fail)
    exit 1
}
Write-Host "RESULT: PASS"
exit 0
