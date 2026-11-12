<#
.SYNOPSIS
    Startet einen TCP-Listener auf Port 8080 fuer die Firewall-Uebung (Uebung 02.1, Teil 6).
.DESCRIPTION
    Laeuft auf SRV-DC01 in Windows PowerShell 5.1. Das Skript blockiert, bis du Enter drueckst; dann wird der
    Listener beendet. So bleibt kein Port offen. Die Firewallregel legst du getrennt an und entfernst sie wieder.
#>
[CmdletBinding()]
param([int]$Port = 8080)

$listener = [System.Net.Sockets.TcpListener]::new([System.Net.IPAddress]::Any, $Port)
try {
    $listener.Start()
    Write-Host "Listener laeuft auf TCP $Port. Test vom Client, danach hier Enter druecken."
    [void](Read-Host)
} finally {
    $listener.Stop()
    Write-Host "Listener beendet."
}
