<#
.SYNOPSIS
    Plant Check-Lab.ps1 alle 5 Minuten als SYSTEM oder entfernt die Aufgabe (Uebung 08.1, Teil 1).
.DESCRIPTION
    Laeuft auf SRV-FS01 (Windows PowerShell 5.1, Administrator). Aufgabenname: LabMonitor.
      Registrieren  New-ScheduledTaskAction/-Trigger (Wiederholung alle 5 Minuten), Konto SYSTEM
      Entfernen     Unregister-ScheduledTask -TaskName LabMonitor
    Ob zusaetzlich eine Wiederholungsdauer noetig ist, ist NICHT BESTAETIGT; ggf. Trigger im Aufgabenplaner pruefen.
    Mit -WhatIf wird nichts geaendert. Nicht auf Windows ausgefuehrt (nur Syntaxpruefung).
#>
[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [Parameter(Mandatory)][ValidateSet('Registrieren', 'Entfernen')][string]$Aktion,
    [string]$Skript = 'C:\Skripte\Check-Lab.ps1'
)

$name = 'LabMonitor'
if ($Aktion -eq 'Registrieren') {
    if (-not (Test-Path -LiteralPath $Skript)) { throw "Skript nicht gefunden: $Skript" }
    $aktion = New-ScheduledTaskAction -Execute 'powershell.exe' -Argument "-NoProfile -ExecutionPolicy Bypass -File `"$Skript`""
    $trigger = New-ScheduledTaskTrigger -Once -At (Get-Date).AddMinutes(2) -RepetitionInterval (New-TimeSpan -Minutes 5)
    if ($PSCmdlet.ShouldProcess($name, 'Geplante Aufgabe registrieren (SYSTEM, alle 5 Minuten)')) {
        Register-ScheduledTask -TaskName $name -Action $aktion -Trigger $trigger -User 'SYSTEM' -RunLevel Highest | Out-Null
    }
    Get-ScheduledTask -TaskName $name -ErrorAction SilentlyContinue | Select-Object TaskName, State
} else {
    if (Get-ScheduledTask -TaskName $name -ErrorAction SilentlyContinue) {
        if ($PSCmdlet.ShouldProcess($name, 'Geplante Aufgabe entfernen')) {
            Unregister-ScheduledTask -TaskName $name -Confirm:$false
        }
    }
}
