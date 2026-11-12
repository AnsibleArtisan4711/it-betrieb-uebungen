<#
.SYNOPSIS
    Testet vom Host aus Erreichbarkeit und Anmeldung der Azure-VM (Uebung 07.1, Teile 4 und 8).
.DESCRIPTION
    Laeuft auf dem Hyper-V-HOST. Die oeffentliche Adresse der VM gibst du als Parameter ein; sie wird NICHT gespeichert.
    Es wird nur gelesen: Test-NetConnection auf TCP 22. Der Skriptausgang nennt die haeufigste Ursache je Ergebnis.
    Mit -WhatIf hat das Skript keine Wirkung (es aendert nichts).
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory)][string]$Adresse,
    [int]$Port = 22
)

$ergebnis = Test-NetConnection -ComputerName $Adresse -Port $Port -WarningAction SilentlyContinue
if ($ergebnis.TcpTestSucceeded) {
    Write-Host "TCP $Port auf $Adresse erreichbar. Weiter mit: ssh -i <Schluessel> <Benutzer>@$Adresse"
} else {
    Write-Host "TCP $Port auf $Adresse NICHT erreichbar. Pruefreihenfolge:"
    Write-Host '  1. VM laeuft (nicht gestoppt/freigegeben)? Status im Portal.'
    Write-Host '  2. NSG-Regel: Quelladresse = eigene aktuelle oeffentliche Adresse? Prioritaet und Ziel-Port 22?'
    Write-Host '  3. Eigene Firewall oder Netz blockt ausgehendes TCP 22?'
}
