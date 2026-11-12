<#
.SYNOPSIS
    Entfernt LX-UBU01-Klon samt Klonordner (Uebung 06.1, Teil 2, Schritt 5: Rueckbau am Ende des Moduls).
.DESCRIPTION
    Laeuft auf dem Hyper-V-HOST. VORBEDINGUNG (wird geprueft): ALLE Datentraegerpfade des Klons liegen im Klonordner,
    keiner im Ordner des Originals. Sonst bricht das Skript ab und loescht NICHTS. Es werden nur der Klon und der
    Klonordner entfernt; Export-Ordner und Original bleiben.
    Mit -WhatIf wird nichts geaendert.
#>
[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [string]$KlonOrdner = 'D:\VMs\Klon'
)

$vm = Get-VM -Name 'LX-UBU01-Klon' -ErrorAction Stop
$orig = Get-VM -Name 'LX-UBU01' -ErrorAction SilentlyContinue
$klonPfad = (Resolve-Path -LiteralPath $KlonOrdner).Path.TrimEnd('\') + '\'
$platten = Get-VMHardDiskDrive -VM $vm
foreach ($p in $platten) {
    if (-not $p.Path.StartsWith($klonPfad, [System.StringComparison]::OrdinalIgnoreCase)) {
        throw "Datentraeger $($p.Path) liegt NICHT im Klonordner $klonPfad. Abbruch, nichts geloescht."
    }
    if ($orig -and (Get-VMHardDiskDrive -VM $orig | Where-Object Path -eq $p.Path)) {
        throw "Datentraeger $($p.Path) gehoert auch dem Original. Abbruch, nichts geloescht."
    }
}
if ($PSCmdlet.ShouldProcess('LX-UBU01-Klon', 'Ausschalten und entfernen')) {
    if ($vm.State -ne 'Off') { Stop-VM -VM $vm -TurnOff -Force }
    Remove-VM -VM $vm -Force
}
if (Test-Path -LiteralPath $klonPfad) {
    if ($PSCmdlet.ShouldProcess($klonPfad, 'Ordner loeschen')) { Remove-Item -LiteralPath $klonPfad -Recurse -Force }
}
