<#
.SYNOPSIS
    Beschraenkt die Ping-Regel LAB-ICMPv4-In auf die Labornetze (Uebung 09.1, Teil 5) oder macht das rueckgaengig.
.DESCRIPTION
    Laeuft auf jeder Windows-VM (Windows PowerShell 5.1, Administrator). Die Regel LAB-ICMPv4-In stammt aus Modul 2; gibt es sie
    nicht, bricht das Skript ab. Rueckgaengig: -Zuruecksetzen setzt RemoteAddress auf Any.
    Set-NetFirewallRule -RemoteAddress ist NICHT BESTAETIGT. Mit -WhatIf wird nichts geaendert. Nur Syntaxpruefung.
#>
[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [switch]$Zuruecksetzen
)

$name = 'LAB-ICMPv4-In'
if (-not (Get-NetFirewallRule -DisplayName $name -ErrorAction SilentlyContinue)) { throw "Regel $name nicht gefunden (Modul 2)." }
$adressen = if ($Zuruecksetzen) { 'Any' } else { @('192.168.50.0/24', '192.168.60.0/24') }
if ($PSCmdlet.ShouldProcess($name, "RemoteAddress = $($adressen -join ',')")) {
    Set-NetFirewallRule -DisplayName $name -RemoteAddress $adressen
}
Get-NetFirewallRule -DisplayName $name | Get-NetFirewallAddressFilter | Select-Object RemoteAddress
