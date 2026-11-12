<#
.SYNOPSIS
    Schreibt freien Speicher je Laufwerk als CSV und JSON (Uebung 10.1, Teil 4).
.DESCRIPTION
    Laeuft auf SRV-FS01 (Windows PowerShell 5.1). Dateinamen: bericht-<yyyy-MM-dd>.csv und .json im Zielordner
    (Standard C:\Skripte; Ordner muss existieren). Berechnete Eigenschaft FreiGB. Mit -WhatIf wird nichts geschrieben.
    Nicht auf Windows ausgefuehrt (nur Syntaxpruefung).
#>
[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [string]$Ziel = 'C:\Skripte'
)

if (-not (Test-Path -LiteralPath $Ziel -PathType Container)) { throw "Ordner '$Ziel' fehlt." }
$datum = Get-Date -Format 'yyyy-MM-dd'
$daten = Get-Volume | Where-Object DriveLetter |
    Select-Object DriveLetter, @{ n = 'FreiGB'; e = { [math]::Round($_.SizeRemaining / 1GB, 1) } }
$daten | Format-Table -AutoSize
$csv = Join-Path $Ziel "bericht-$datum.csv"
$json = Join-Path $Ziel "bericht-$datum.json"
if ($PSCmdlet.ShouldProcess("$csv, $json", 'Bericht schreiben')) {
    $daten | Export-Csv -LiteralPath $csv -NoTypeInformation -Encoding UTF8
    $daten | ConvertTo-Json | Set-Content -LiteralPath $json -Encoding UTF8
}
