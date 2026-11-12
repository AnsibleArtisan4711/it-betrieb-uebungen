<#
.SYNOPSIS
    Trennt die Zusatzdatentraeger F: (SRV-FS01) und G: (SRV-DC01) von den VMs und loescht deren VHDX-Dateien (Uebung 08.1, Teil 8).
.DESCRIPTION
    Laeuft auf dem Hyper-V-HOST. Die VMs muessen AUSGESCHALTET sein. Das Skript zeigt zuerst Pfad und Dateiname jedes
    Datentraegers (Get-VMHardDiskDrive) und entfernt NUR die Datentraeger, deren Dateiname dem Parameter entspricht
    (Standard: SRV-FS01-sicherung.vhdx bzw. SRV-DC01-systemstate.vhdx). Das Betriebssystem- und das Daten-VHDX (E:)
    werden nie angefasst. Passe -FsDatei und -DcDatei an die Namen an, die DU beim Anlegen vergeben hast.
    Mit -WhatIf wird nichts geaendert.
#>
[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [string]$FsDatei = 'SRV-FS01-sicherung.vhdx',
    [string]$DcDatei = 'SRV-DC01-systemstate.vhdx'
)

foreach ($ziel in @(@{ Vm = 'SRV-FS01'; Datei = $FsDatei }, @{ Vm = 'SRV-DC01'; Datei = $DcDatei })) {
    $vm = Get-VM -Name $ziel.Vm -ErrorAction Stop
    if ($vm.State -ne 'Off') { throw "$($ziel.Vm) muss ausgeschaltet sein." }
    $platten = Get-VMHardDiskDrive -VM $vm
    $platten | Select-Object VMName, ControllerNumber, ControllerLocation, Path | Format-Table -AutoSize
    $treffer = @($platten | Where-Object { (Split-Path -Leaf $_.Path) -eq $ziel.Datei })
    if ($treffer.Count -ne 1) { throw "Erwartet genau einen Datentraeger mit Dateiname $($ziel.Datei) an $($ziel.Vm), gefunden: $($treffer.Count). Abbruch, nichts geloescht." }
    $pfad = $treffer[0].Path
    if ($PSCmdlet.ShouldProcess("$($ziel.Vm): $pfad", 'Datentraeger trennen und Datei loeschen')) {
        Remove-VMHardDiskDrive -VMHardDiskDrive $treffer[0]
        Remove-Item -LiteralPath $pfad
    }
}
