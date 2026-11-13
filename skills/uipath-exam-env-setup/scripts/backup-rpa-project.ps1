param(
    [Parameter(Mandatory = $true)][string]$Source,
    [Parameter(Mandatory = $true)][string]$Destination
)

if (-not (Test-Path $Source)) { throw "Source not found: $Source" }
$src = (Resolve-Path $Source).Path

$stage = Join-Path $env:TEMP ("rpa_backup_" + [guid]::NewGuid().ToString("N"))
New-Item -ItemType Directory -Path $stage -Force | Out-Null

robocopy $src $stage /E /XD .local bin obj .vs /NFL /NDL /NJH /NJS | Out-Null
if ($LASTEXITCODE -ge 8) {
    Remove-Item $stage -Recurse -Force -ErrorAction SilentlyContinue
    throw "robocopy failed with exit code $LASTEXITCODE"
}

$destParent = Split-Path -Parent $Destination
if ($destParent -and -not (Test-Path $destParent)) {
    New-Item -ItemType Directory -Path $destParent -Force | Out-Null
}

Compress-Archive -Path (Join-Path $stage "*") -DestinationPath $Destination -Force
Remove-Item $stage -Recurse -Force -ErrorAction SilentlyContinue

$size = (Get-Item $Destination).Length
Write-Host ("Created {0} ({1:N1} MB), excluded .local / bin / obj / .vs" -f $Destination, ($size / 1MB))
