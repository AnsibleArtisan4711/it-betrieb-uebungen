<#
.SYNOPSIS
    Zeigt alle SMB-Freigaben mit Zugriffsrechten und markiert 'Jeder/Everyone' (Uebung 09.1, Teil 8).
.DESCRIPTION
    Laeuft auf SRV-FS01 (Windows PowerShell 5.1). Standardmaessig nur lesen.
    Mit -Entfernen <Name> wird GENAU diese Freigabe entfernt, aber erst nach Pfadpruefung (Pfad muss unter E:\ liegen)
    und Bestaetigung. Administrative Freigaben (Name endet auf $) werden nie angefasst.
    Mit -WhatIf wird nichts geaendert. Cmdlets nicht bestaetigt. Nicht auf Windows ausgefuehrt (nur Syntaxpruefung).
#>
[CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
param(
    [string]$Entfernen
)

$shares = Get-SmbShare | Where-Object { $_.Name -notlike '*$' }
foreach ($s in $shares) {
    $rechte = Get-SmbShareAccess -Name $s.Name
    foreach ($r in $rechte) {
        $warn = if ($r.AccountName -match 'Everyone|Jeder') { '  <-- OFFEN' } else { '' }
        '{0,-12} {1,-28} {2,-22} {3}{4}' -f $s.Name, $s.Path, $r.AccountName, $r.AccessRight, $warn
    }
}
if ($Entfernen) {
    if ($Entfernen -like '*$') { throw 'Administrative Freigaben werden nicht entfernt.' }
    $ziel = $shares | Where-Object Name -eq $Entfernen
    if (-not $ziel) { throw "Freigabe $Entfernen nicht gefunden." }
    if ($ziel.Path -notlike 'E:\*') { throw "Pfad $($ziel.Path) liegt nicht unter E:\ - Abbruch." }
    if ($PSCmdlet.ShouldProcess("$($ziel.Name) ($($ziel.Path))", 'Freigabe entfernen (Ordner bleibt)')) {
        Remove-SmbShare -Name $ziel.Name -Force
    }
}
