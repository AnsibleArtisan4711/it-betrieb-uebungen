<#
.SYNOPSIS
    Prueft den freien Speicher auf C: und schreibt bei Unterschreitung eine Warnung ins Anwendungsprotokoll (Uebung 08.1, Teil 1).
.DESCRIPTION
    Laeuft auf SRV-FS01 in Windows PowerShell 5.1 (New-EventLog/Write-EventLog gelten in 5.1, Learn). Zielort:
    C:\Skripte\Check-Lab.ps1 (Ordner C:\Skripte und C:\Temp vorher anlegen). Zum Test -LimitGB 1000 angeben:
    dann wird (fast) sicher eine Warnung geschrieben. Die Ereignisquelle LabMonitor wird beim ersten Lauf angelegt.
    Mit -WhatIf wird nichts geschrieben. Nicht auf Windows ausgefuehrt (nur Syntaxpruefung).
#>
[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [int]$LimitGB = 20
)

$quelle = 'LabMonitor'
if (-not [System.Diagnostics.EventLog]::SourceExists($quelle)) {
    if ($PSCmdlet.ShouldProcess($quelle, 'Ereignisquelle anlegen')) {
        New-EventLog -LogName Application -Source $quelle
    }
}
$freiGB = [math]::Round((Get-PSDrive -Name C).Free / 1GB, 1)
Write-Host "C: frei: $freiGB GB (Limit $LimitGB GB)"
if ($freiGB -lt $LimitGB) {
    if ($PSCmdlet.ShouldProcess($quelle, 'Warnung EventId 4001 schreiben')) {
        Write-EventLog -LogName Application -Source $quelle -EventId 4001 -EntryType Warning `
            -Message "C: nur $freiGB GB frei (Limit $LimitGB GB)"
    }
}
