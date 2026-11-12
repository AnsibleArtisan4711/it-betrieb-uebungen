<#
.SYNOPSIS
    KURSLEITER: baut die drei Fehler aus Modul 2, Aufgabe 4 ein oder macht sie rueckgaengig.
.DESCRIPTION
    Laeuft im jeweiligen Gast als Administrator (Windows PowerShell 5.1).
      a  auf CL-W11-01: Standardroute entfernen und mit falschem Gateway 192.168.60.254 neu anlegen
      b  auf SRV-FS01 : Weiterleitung auf NIC-CLI deaktivieren
      c  auf SRV-DC01 : Ping-Regel LAB-ICMPv4-In deaktivieren
      zurueck  stellt den Sollzustand des jeweiligen Rechners wieder her
    Der Computername wird geprueft. Mit -WhatIf wird nichts geaendert.
    Nicht auf einem Windows-System ausgefuehrt (nur Syntaxpruefung).
#>
[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [Parameter(Mandatory)][ValidateSet('a', 'b', 'c', 'zurueck')][string]$Fehler
)

function Test-Rechner([string]$Name) {
    if ($env:COMPUTERNAME -ne $Name) { throw "Dieser Fehler gehoert auf $Name, nicht auf $env:COMPUTERNAME." }
}

switch ($Fehler) {
    'a' {
        Test-Rechner 'CL-W11-01'
        if ($PSCmdlet.ShouldProcess('CL-W11-01', 'Standardgateway auf 192.168.60.254 setzen')) {
            Get-NetRoute -DestinationPrefix '0.0.0.0/0' -ErrorAction SilentlyContinue | Remove-NetRoute -Confirm:$false
            New-NetRoute -DestinationPrefix '0.0.0.0/0' -InterfaceAlias 'NIC-CLI' -NextHop '192.168.60.254' | Out-Null
        }
    }
    'b' {
        Test-Rechner 'SRV-FS01'
        if ($PSCmdlet.ShouldProcess('SRV-FS01 NIC-CLI', 'Weiterleitung deaktivieren')) {
            Set-NetIPInterface -InterfaceAlias 'NIC-CLI' -Forwarding Disabled
        }
    }
    'c' {
        Test-Rechner 'SRV-DC01'
        if ($PSCmdlet.ShouldProcess('SRV-DC01', 'Regel LAB-ICMPv4-In deaktivieren')) {
            Disable-NetFirewallRule -DisplayName 'LAB-ICMPv4-In'
        }
    }
    'zurueck' {
        switch ($env:COMPUTERNAME) {
            'CL-W11-01' {
                if ($PSCmdlet.ShouldProcess('CL-W11-01', 'Standardgateway auf 192.168.60.1')) {
                    Get-NetRoute -DestinationPrefix '0.0.0.0/0' -ErrorAction SilentlyContinue | Remove-NetRoute -Confirm:$false
                    New-NetRoute -DestinationPrefix '0.0.0.0/0' -InterfaceAlias 'NIC-CLI' -NextHop '192.168.60.1' | Out-Null
                }
            }
            'SRV-FS01' {
                if ($PSCmdlet.ShouldProcess('SRV-FS01 NIC-CLI', 'Weiterleitung aktivieren')) {
                    Set-NetIPInterface -InterfaceAlias 'NIC-CLI' -Forwarding Enabled
                }
            }
            'SRV-DC01' {
                if ($PSCmdlet.ShouldProcess('SRV-DC01', 'Regel LAB-ICMPv4-In aktivieren')) {
                    Enable-NetFirewallRule -DisplayName 'LAB-ICMPv4-In'
                }
            }
            default { throw "Unbekannter Rechner $env:COMPUTERNAME." }
        }
    }
}
