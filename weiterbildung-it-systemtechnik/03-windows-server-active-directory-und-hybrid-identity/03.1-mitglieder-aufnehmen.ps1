<#
.SYNOPSIS
    Stellt den DNS-Server ein und nimmt SRV-FS01 bzw. CL-W11-01 in die Domaene auf (Uebung 03.1, Teil 3).
.DESCRIPTION
    Laeuft auf SRV-FS01 oder CL-W11-01 in Windows PowerShell 5.1 als Administrator.
    Der DNS-Server 192.168.50.10 wird auf dem Labor-Adapter gesetzt. Fuer den Beitritt fragt Add-Computer
    die Anmeldedaten von LAB\lab-adm01 selbst ab (Get-Credential); es wird nichts gespeichert.
    Der Rechner startet danach neu. Mit -WhatIf wird nichts geaendert.
#>
[CmdletBinding(SupportsShouldProcess = $true)]
param()

$alias = switch ($env:COMPUTERNAME) {
    'SRV-FS01'  { 'NIC-LAB' }
    'CL-W11-01' { 'NIC-CLI' }
    default     { throw "Unbekannter Rechner $env:COMPUTERNAME (erwartet SRV-FS01 oder CL-W11-01)." }
}

if ($PSCmdlet.ShouldProcess($alias, 'DNS-Server 192.168.50.10 setzen')) {
    Set-DnsClientServerAddress -InterfaceAlias $alias -ServerAddresses '192.168.50.10'
}
Resolve-DnsName -Name 'srv-dc01.lab.example.internal' -Server 192.168.50.10 -ErrorAction Stop | Select-Object Name, IPAddress
if ($PSCmdlet.ShouldProcess($env:COMPUTERNAME, 'Domaene lab.example.internal beitreten und neu starten')) {
    Add-Computer -DomainName 'lab.example.internal' -Credential (Get-Credential -UserName 'LAB\lab-adm01' -Message 'Kennwort von lab-adm01') -Restart
}
