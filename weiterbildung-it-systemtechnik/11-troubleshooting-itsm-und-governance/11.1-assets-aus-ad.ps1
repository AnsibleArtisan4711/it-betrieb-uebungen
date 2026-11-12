<#
.SYNOPSIS
    Exportiert die Computerliste aus AD als Grundlage der Asset-Uebersicht (Uebung 11.1, Teil 5). Nur lesen.
.DESCRIPTION
    Laeuft auf SRV-FS01 als LAB\lab-adm01 (Windows PowerShell 5.1, AD-Modul). Spalten: Name, OperatingSystem, IPv4Address.
    LX-UBU01 (und ggf. CL-W11-02) stehen NICHT in AD und werden von Hand in die Tabelle ergaenzt.
    Get-ADComputer mit -Properties IPv4Address ist NICHT BESTAETIGT. Mit -WhatIf wird nichts geschrieben.
    Nicht auf Windows ausgefuehrt (nur Syntaxpruefung).
#>
[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [string]$Ziel = 'C:\Temp\assets-ad.csv'
)

Import-Module ActiveDirectory -ErrorAction Stop
$daten = Get-ADComputer -Filter * -Properties OperatingSystem, IPv4Address | Select-Object Name, OperatingSystem, IPv4Address
$daten | Format-Table -AutoSize
if ($PSCmdlet.ShouldProcess($Ziel, 'CSV schreiben')) {
    $daten | Export-Csv -LiteralPath $Ziel -NoTypeInformation -Encoding UTF8
}
