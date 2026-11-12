<#
.SYNOPSIS
    Setzt Adressen, Route, Weiterleitung und Ping-Regel nach dem Adressplan (Uebung 02.1, Teil 3, Schritte 4 bis 6).
.DESCRIPTION
    Laeuft IM GAST (SRV-DC01, SRV-FS01 oder CL-W11-01) in Windows PowerShell 5.1 als Administrator.
    Voraussetzung: Die Adapter heissen bereits NIC-LAB bzw. NIC-CLI (Teil 3, Schritt 3).
    Der Computername muss zur Rolle passen, sonst bricht das Skript ab.
    Es werden KEINE Kennwoerter benoetigt. Mit -WhatIf wird nichts geaendert.
.PARAMETER Rolle
    DC, FS oder CL.
.EXAMPLE
    .\02.1-labor-netz-einrichten.ps1 -Rolle FS -WhatIf
#>
[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [Parameter(Mandatory)][ValidateSet('DC', 'FS', 'CL')][string]$Rolle
)

$erwartet = @{ DC = 'SRV-DC01'; FS = 'SRV-FS01'; CL = 'CL-W11-01' }
if ($env:COMPUTERNAME -ne $erwartet[$Rolle]) {
    throw "Computername ist $env:COMPUTERNAME, erwartet wird $($erwartet[$Rolle]). Abbruch."
}

function Set-LabAdresse {
    param([string]$Alias, [string]$Ip, [string]$Gateway)
    if (-not (Get-NetAdapter -Name $Alias -ErrorAction SilentlyContinue)) {
        throw "Adapter $Alias nicht gefunden (siehe Teil 3, Schritt 3)."
    }
    if ($PSCmdlet.ShouldProcess("$Alias", "Adresse $Ip/24 setzen")) {
        # Vorhandene IPv4-Adressen auf diesem Adapter entfernen, damit der Lauf wiederholbar ist.
        Get-NetIPAddress -InterfaceAlias $Alias -AddressFamily IPv4 -ErrorAction SilentlyContinue |
            Remove-NetIPAddress -Confirm:$false
        if ($Gateway) {
            New-NetIPAddress -InterfaceAlias $Alias -IPAddress $Ip -PrefixLength 24 -DefaultGateway $Gateway | Out-Null
        } else {
            New-NetIPAddress -InterfaceAlias $Alias -IPAddress $Ip -PrefixLength 24 | Out-Null
        }
    }
}

switch ($Rolle) {
    'DC' {
        Set-LabAdresse -Alias 'NIC-LAB' -Ip '192.168.50.10' -Gateway $null
        if ($PSCmdlet.ShouldProcess('NIC-LAB', 'Route 192.168.60.0/24 ueber 192.168.50.20')) {
            if (-not (Get-NetRoute -DestinationPrefix '192.168.60.0/24' -ErrorAction SilentlyContinue)) {
                New-NetRoute -DestinationPrefix '192.168.60.0/24' -InterfaceAlias 'NIC-LAB' -NextHop '192.168.50.20' | Out-Null
            }
        }
    }
    'FS' {
        Set-LabAdresse -Alias 'NIC-LAB' -Ip '192.168.50.20' -Gateway $null
        Set-LabAdresse -Alias 'NIC-CLI' -Ip '192.168.60.1' -Gateway $null
        foreach ($alias in 'NIC-LAB', 'NIC-CLI') {
            if ($PSCmdlet.ShouldProcess($alias, 'Weiterleitung aktivieren')) {
                Set-NetIPInterface -InterfaceAlias $alias -Forwarding Enabled
            }
        }
    }
    'CL' {
        Set-LabAdresse -Alias 'NIC-CLI' -Ip '192.168.60.101' -Gateway '192.168.60.1'
    }
}

# Eigene Ping-Regel (Name wird in Modul 9 wieder gebraucht)
if (-not (Get-NetFirewallRule -DisplayName 'LAB-ICMPv4-In' -ErrorAction SilentlyContinue)) {
    if ($PSCmdlet.ShouldProcess('Firewall', 'Regel LAB-ICMPv4-In anlegen')) {
        New-NetFirewallRule -DisplayName 'LAB-ICMPv4-In' -Direction Inbound -Protocol ICMPv4 -IcmpType 8 -Action Allow | Out-Null
    }
}

Get-NetIPAddress -AddressFamily IPv4 | Where-Object { $_.InterfaceAlias -like 'NIC-*' } |
    Select-Object InterfaceAlias, IPAddress, PrefixLength
