<#
.SYNOPSIS
    Stoppt oder startet den DNS-Dienst auf SRV-DC01 fuer die Stoerungssimulation (Uebung 11.1, Teil 2).
.DESCRIPTION
    Laeuft auf SRV-DC01 (Windows PowerShell 5.1, Administrator), durch den PARTNER (nicht durch die Person, die analysiert).
    Aktion Stoppen:  Stop-Service -Name DNS      Aktion Starten:  Start-Service -Name DNS
    Der Dienstname DNS ist NICHT BESTAETIGT; das Skript bricht ab, wenn es ihn nicht findet. Mit -WhatIf wird nichts geaendert.
    Nach der Simulation IMMER 'Starten' ausfuehren und Status pruefen. Nicht auf Windows ausgefuehrt (nur Syntaxpruefung).
#>
[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [Parameter(Mandatory)][ValidateSet('Stoppen', 'Starten')][string]$Aktion
)

if ($env:COMPUTERNAME -ne 'SRV-DC01') { throw "Dieses Skript gehoert auf SRV-DC01, nicht auf $env:COMPUTERNAME." }
$dienst = Get-Service -Name 'DNS' -ErrorAction Stop
Write-Host "Vorher: $($dienst.Name) = $($dienst.Status)  ($(Get-Date -Format 'HH:mm:ss'))"
if ($Aktion -eq 'Stoppen') {
    if ($PSCmdlet.ShouldProcess('DNS', 'Dienst stoppen (Simulation)')) { Stop-Service -Name 'DNS' -Force }
} else {
    if ($PSCmdlet.ShouldProcess('DNS', 'Dienst starten')) { Start-Service -Name 'DNS' }
}
$dienst.Refresh()
Write-Host "Nachher: $($dienst.Name) = $($dienst.Status)  ($(Get-Date -Format 'HH:mm:ss'))"
