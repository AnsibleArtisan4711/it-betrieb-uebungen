<#
.SYNOPSIS
    Installiert AD DS und stuft SRV-DC01 zum ersten Domaenencontroller von lab.example.internal herauf (Uebung 03.1, Teil 2).
.DESCRIPTION
    Laeuft auf SRV-DC01 in Windows PowerShell 5.1 als Administrator. VORBEDINGUNGEN: Prüfpunkt
    SRV-DC01-M3-Start (VM ausgeschaltet erstellt), Adresse 192.168.50.10 gesetzt, Computername SRV-DC01.
    Das Wiederherstellungskennwort (DSRM) wird von Install-ADDSForest INTERAKTIV abgefragt und
    nirgends gespeichert. Nach der Heraufstufung startet der Server neu.
    Mit -WhatIf wird nichts geaendert (Install-ADDSForest unterstuetzt -WhatIf selbst).
#>
[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [string]$Domain  = 'lab.example.internal',
    [string]$NetBios = 'LAB'
)

if ($env:COMPUTERNAME -ne 'SRV-DC01') { throw "Dieses Skript gehoert auf SRV-DC01, nicht auf $env:COMPUTERNAME." }
if (-not (Get-NetIPAddress -IPAddress '192.168.50.10' -ErrorAction SilentlyContinue)) {
    throw 'Adresse 192.168.50.10 ist nicht gesetzt (Modul 2).'
}

if ($PSCmdlet.ShouldProcess($env:COMPUTERNAME, 'Rolle AD-Domain-Services installieren')) {
    Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools
}
# Das DSRM-Kennwort fragt das Cmdlet selbst ab; es wird hier nicht uebergeben.
Install-ADDSForest -DomainName $Domain -DomainNetbiosName $NetBios -InstallDns -WhatIf:$WhatIfPreference
