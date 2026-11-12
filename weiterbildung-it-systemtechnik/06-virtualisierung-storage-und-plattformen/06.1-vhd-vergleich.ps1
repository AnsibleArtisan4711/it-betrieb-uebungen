<#
.SYNOPSIS
    Legt eine feste und eine dynamische VHDX an und vergleicht die Dateigroessen (Uebung 06.1, Teil 4, Schritt 1).
.DESCRIPTION
    Laeuft auf dem Hyper-V-HOST. Der Ordner (Standard D:\Test) wird angelegt, falls er fehlt; geloescht werden NUR
    fix.vhdx und dyn.vhdx darin (Aktion Loeschen), nachdem der Pfad geprueft wurde.
      Anlegen   erzeugt beide Dateien und zeigt die Groessen
      Loeschen  entfernt genau diese beiden Dateien
    Mit -WhatIf wird nichts geaendert.
#>
[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [Parameter(Mandatory)][ValidateSet('Anlegen', 'Loeschen')][string]$Aktion,
    [string]$Ordner = 'D:\Test'
)

$fix = Join-Path $Ordner 'fix.vhdx'
$dyn = Join-Path $Ordner 'dyn.vhdx'

if ($Aktion -eq 'Anlegen') {
    if ($PSCmdlet.ShouldProcess($Ordner, 'fix.vhdx (5 GB, fest) und dyn.vhdx (5 GB, dynamisch) anlegen')) {
        New-Item -ItemType Directory -Path $Ordner -Force | Out-Null
        New-VHD -Path $fix -SizeBytes 5GB -Fixed | Out-Null
        New-VHD -Path $dyn -SizeBytes 5GB -Dynamic | Out-Null
        Get-Item $fix, $dyn | Select-Object Name, @{n = 'GroesseMB'; e = { [math]::Round($_.Length / 1MB, 1) } }
    }
} else {
    foreach ($datei in $fix, $dyn) {
        if ((Split-Path -Parent $datei) -ne $Ordner.TrimEnd('\')) { throw "Unerwarteter Pfad: $datei" }
        if (Test-Path -LiteralPath $datei) {
            if ($PSCmdlet.ShouldProcess($datei, 'Datei loeschen')) { Remove-Item -LiteralPath $datei }
        }
    }
}
