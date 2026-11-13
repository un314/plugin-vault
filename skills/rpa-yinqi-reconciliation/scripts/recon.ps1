# recon.ps1 - compute a1..a8 (bank reconciliation) from one company xlsx
# usage: powershell -ExecutionPolicy Bypass -File recon.ps1 -Path "<company>.xlsx"
param([string]$Path)
Add-Type -AssemblyName System.IO.Compression.FileSystem
$zip = [System.IO.Compression.ZipFile]::OpenRead((Resolve-Path $Path))

function ReadEntry($name) {
  $e = $zip.Entries | Where-Object { $_.FullName -eq $name }
  if (-not $e) { return $null }
  $sr = New-Object System.IO.StreamReader($e.Open()); $t = $sr.ReadToEnd(); $sr.Close(); return $t
}

$shared = @{}
$ss = ReadEntry 'xl/sharedStrings.xml'
if ($ss) {
  $xd = New-Object System.Xml.XmlDocument; $xd.PreserveWhitespace = $true; $xd.LoadXml($ss)
  $i = 0
  foreach ($si in $xd.SelectNodes('//*[local-name()="si"]')) {
    $txt = ''; foreach ($t in $si.SelectNodes('.//*[local-name()="t"]')) { $txt += $t.InnerText }
    $shared[$i] = $txt; $i++
  }
}

function SheetRows($file) {
  $xml = ReadEntry $file
  $xd = New-Object System.Xml.XmlDocument; $xd.PreserveWhitespace = $true; $xd.LoadXml($xml)
  $out = @()
  foreach ($row in $xd.SelectNodes('//*[local-name()="row"]')) {
    $h = @{}
    foreach ($c in $row.SelectNodes('./*[local-name()="c"]')) {
      $ref = $c.GetAttribute('r'); $t = $c.GetAttribute('t'); $v = $c.SelectSingleNode('./*[local-name()="v"]')
      if ($t -eq 's' -and $v) { $h[($ref -replace '\d','')] = $shared[[int]$v.InnerText] }
      elseif ($v) { $h[($ref -replace '\d','')] = $v.InnerText }
    }
    if ($h.Count) { $out += ,@([int]$row.GetAttribute('r'), $h) }
  }
  return $out
}

function R2($v) { return [double]([math]::Round([decimal]$v, 2, [MidpointRounding]::AwayFromZero)) }

function Num($s) {
  if (-not $s) { return $null }
  $d = 0.0
  if ([double]::TryParse($s, [ref]$d)) { return $d }
  return $null
}

# sheet order is not guaranteed: bank statement is the one whose last row has a G column
$s1 = SheetRows 'xl/worksheets/sheet1.xml'
$s2 = SheetRows 'xl/worksheets/sheet2.xml'
$bank = $s1; $books = $s2
if (-not $s1[$s1.Count-1][1].ContainsKey('G')) { $bank = $s2; $books = $s1 }

# skip 期初余额 / 本日合计 / 本月合计 rows; match by code point (script file may be read as ANSI)
$HJ = [string][char]0x5408 + [char]0x8BA1
$QC = [string][char]0x671F + [char]0x521D
function Amts($rows, $col) {
  $list = New-Object System.Collections.ArrayList
  foreach ($r in $rows) {
    $c = $r[1]
    $label = $c['C']; if (-not $label) { $label = $c['D'] }
    if ($label -and ($label.Contains($HJ) -or $label.Contains($QC))) { continue }
    $v = Num $c[$col]
    if ($v -eq $null) { continue }
    [void]$list.Add([pscustomobject]@{ Row = $r[0]; Amt = R2 ($v) })
  }
  return $list
}

function MultisetDiff($a, $b) {
  $m = @{}
  foreach ($x in $a) { if ($m.ContainsKey($x.Amt)) { $m[$x.Amt]++ } else { $m[$x.Amt] = 1 } }
  foreach ($x in $b) { if ($m.ContainsKey($x.Amt)) { $m[$x.Amt]--; if ($m[$x.Amt] -le 0) { $m.Remove($x.Amt) } } }
  return $m
}
function TotalOf($m) { $s = 0.0; foreach ($k in $m.Keys) { $s += $k * $m[$k] }; return R2 ($s) }
function Fmt($m) { return (($m.Keys | Sort-Object | ForEach-Object { "${_}" }) -join ' + ') }

$bankPay = Amts $bank 'E'; $bankRec = Amts $bank 'F'
$bookPay = Amts $books 'E'; $bookRec = Amts $books 'D'
$d3 = MultisetDiff $bankRec $bookRec    # bank received only  -> a2
$d1 = MultisetDiff $bankPay $bookPay    # bank paid only      -> a3
$d4 = MultisetDiff $bookRec $bankRec    # books received only -> a6
$d2 = MultisetDiff $bookPay $bankPay    # books paid only     -> a7

$rowsB = @($bank | Where-Object { $_[1]['G'] }); $rowsJ = @($books | Where-Object { $_[1]['F'] })
$a5 = R2 ([double]$rowsB[$rowsB.Count-1][1]['G'])
$a1 = R2 ([double]$rowsJ[$rowsJ.Count-1][1]['F'])
$a2 = TotalOf $d3; $a3 = TotalOf $d1; $a6 = TotalOf $d4; $a7 = TotalOf $d2
$a4 = R2 ($a1 + $a2 - $a3); $a8 = R2 ($a5 + $a6 - $a7)

Write-Output "FILE      $Path"
Write-Output "a2 bank-received-only : $(Fmt $d3) = $a2"
Write-Output "a3 bank-paid-only     : $(Fmt $d1) = $a3"
Write-Output "a6 books-received-only: $(Fmt $d4) = $a6"
Write-Output "a7 books-paid-only    : $(Fmt $d2) = $a7"
Write-Output "a1=$a1 a2=$a2 a3=$a3 a4=$a4"
Write-Output "a5=$a5 a6=$a6 a7=$a7 a8=$a8"
if ($a4 -eq $a8) { Write-Output "BALANCED  a4 = a8 = $a4" } else { Write-Output "NOT BALANCED  diff = $([math]::Round($a4-$a8,2))" }

$ws = $zip.Entries | Where-Object { $_.FullName -eq 'xl/worksheets/sheet3.xml' }
if ($ws) {
  $r = SheetRows 'xl/worksheets/sheet3.xml'
  foreach ($row in $r) { $d3c = $row[1]['D']; if ($d3c -and $d3c.Length -eq 25) { Write-Output "dzCode = $d3c" } }
}
$zip.Dispose()
