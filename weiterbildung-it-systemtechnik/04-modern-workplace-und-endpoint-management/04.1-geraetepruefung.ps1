<#
.SYNOPSIS
    Prueft auf CL-W11-02 Join-Status, BitLocker und Defender (Uebung 04.1, Teile 3 und 6).
.DESCRIPTION
    Laeuft auf CL-W11-02 in Windows PowerShell 5.1 als Administrator. Es werden nur Werte gelesen:
      dsregcmd /status      -> AzureAdJoined, DomainJoined (rein cloudverbunden: YES und NO)
      manage-bde -status C: -> Schutzstatus (Ausgabefelder nicht bestaetigt)
      Get-MpComputerStatus  -> RealTimeProtectionEnabled
    Es werden keine Kennwoerter, Schluessel oder IDs ausgegeben oder gespeichert.
    Mit -WhatIf hat das Skript keine Wirkung (es aendert nichts).
#>
[CmdletBinding()]
param()

$dsreg = dsregcmd /status
$felder = foreach ($name in 'AzureAdJoined', 'DomainJoined') {
    $zeile = $dsreg | Select-String -Pattern "^\s*$name\s*:\s*(\S+)" | Select-Object -First 1
    [pscustomobject]@{ Feld = $name; Wert = if ($zeile) { $zeile.Matches[0].Groups[1].Value } else { 'nicht gefunden' } }
}
$felder | Format-Table -AutoSize

Write-Host '--- BitLocker (Systemlaufwerk) ---'
manage-bde -status C: | Select-String -Pattern 'Schutzstatus|Protection Status|Verschl|Conversion Status'

Write-Host '--- Defender ---'
try {
    Get-MpComputerStatus | Select-Object RealTimeProtectionEnabled, AntivirusEnabled
} catch {
    Write-Warning "Get-MpComputerStatus nicht verfuegbar: $($_.Exception.Message)"
}
