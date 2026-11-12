<#
.SYNOPSIS
    Loescht Dateien aelter als N Tage, aber nur unterhalb eines Testordners (Uebung 10.1, Teil 5).
.DESCRIPTION
    Schutzmassnahmen: (1) Path wird aufgeloest und muss UNTERHALB von -Basis liegen, sonst Abbruch (auch bei '..'),
    (2) -Days nur 1 bis 365, (3) -WhatIf/-Confirm ueber SupportsShouldProcess, (4) try/catch mit -ErrorAction Stop.
    Standard fuer -Basis: C:\Skripte\Test. -Basis dient nur dem Test (z. B. auf anderem System); fuer die Uebung nicht aendern.
    Nur Dateien, keine Ordner, kein -Recurse ohne Schalter -Rekursiv.
    Logik real getestet unter PowerShell 7.4 auf Linux (Pfade dort anders); auf Windows PowerShell 5.1 nicht ausgefuehrt.
#>
[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [Parameter(Mandatory)][string]$Path,
    [Parameter(Mandatory)][ValidateRange(1, 365)][int]$Days,
    [string]$Basis = 'C:\Skripte\Test',
    [switch]$Rekursiv
)

try {
    $sep = [System.IO.Path]::DirectorySeparatorChar
    $basisVoll = [System.IO.Path]::GetFullPath($Basis).TrimEnd($sep)
    $pfadVoll = [System.IO.Path]::GetFullPath($Path).TrimEnd($sep)
    $vergleich = if ($sep -eq '\') { [System.StringComparison]::OrdinalIgnoreCase } else { [System.StringComparison]::Ordinal }
    if (-not $pfadVoll.StartsWith($basisVoll + $sep, $vergleich)) {
        throw "Pfad '$pfadVoll' liegt nicht unterhalb von '$basisVoll'. Abbruch, nichts geloescht."
    }
    if (-not (Test-Path -LiteralPath $pfadVoll -PathType Container)) { throw "Ordner '$pfadVoll' nicht gefunden." }
    $grenze = (Get-Date).AddDays(-$Days)
    $dateien = Get-ChildItem -LiteralPath $pfadVoll -File -Recurse:$Rekursiv -ErrorAction Stop | Where-Object { $_.LastWriteTime -lt $grenze }
    foreach ($d in $dateien) {
        if ($PSCmdlet.ShouldProcess($d.FullName, "Loeschen (aelter als $Days Tage)")) {
            Remove-Item -LiteralPath $d.FullName -ErrorAction Stop
        }
    }
    Write-Host ("Gefunden: {0} Datei(en) aelter als {1} Tage." -f @($dateien).Count, $Days)
} catch {
    Write-Error $_.Exception.Message
    exit 1
}
