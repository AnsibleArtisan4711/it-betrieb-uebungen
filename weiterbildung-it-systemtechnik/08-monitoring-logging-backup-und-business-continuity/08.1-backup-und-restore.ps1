<#
.SYNOPSIS
    Sichert E: nach F:, zeigt Versionen, stellt drei geloeschte Dateien wieder her und vergleicht Hashwerte (Uebung 08.1, Teil 4, Schritte 3 bis 5).
.DESCRIPTION
    Laeuft auf SRV-FS01 (Windows PowerShell 5.1, Administrator). Phasen:
      Sichern          wbadmin start backup -backupTarget:F: -include:E: -quiet (Dauer wird gemessen)
      Versionen        wbadmin get versions -backupTarget:F:
      Loeschen         loescht test01..test03.txt in E:\Daten\Projekt (nur diese drei)
      Wiederherstellen wbadmin start recovery ... (braucht -Version, z. B. 11/12/2026-10:00)
      Vergleichen      Hashwerte gegen C:\Temp\hash-vorher.csv
    Reihenfolge der wbadmin-Parameter und -recursive sind NICHT BESTAETIGT; Befehle sind durch Learn belegt, die Kombination nicht.
    Mit -WhatIf wird nichts ausgefuehrt. Nicht auf Windows ausgefuehrt (nur Syntaxpruefung).
#>
[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [Parameter(Mandatory)][ValidateSet('Sichern', 'Versionen', 'Loeschen', 'Wiederherstellen', 'Vergleichen')][string]$Phase,
    [string]$Version
)

$ordner = 'E:\Daten\Projekt'
$dateien = 'test01.txt', 'test02.txt', 'test03.txt'

switch ($Phase) {
    'Sichern' {
        if ($PSCmdlet.ShouldProcess('E: nach F:', 'Sicherung')) {
            $dauer = Measure-Command { wbadmin start backup -backupTarget:F: -include:E: -quiet }
            Write-Host ("Dauer Sicherung: {0:n1} s" -f $dauer.TotalSeconds)
        }
    }
    'Versionen' { wbadmin get versions -backupTarget:F: }
    'Loeschen' {
        foreach ($d in $dateien) {
            $p = Join-Path $ordner $d
            if ((Split-Path -Parent $p) -ne $ordner) { throw "Unerwarteter Pfad: $p" }
            if ((Test-Path -LiteralPath $p) -and $PSCmdlet.ShouldProcess($p, 'Datei loeschen')) { Remove-Item -LiteralPath $p }
        }
    }
    'Wiederherstellen' {
        if (-not $Version) { throw 'Bitte -Version angeben (aus wbadmin get versions).' }
        $dauer = Measure-Command {
            foreach ($d in $dateien) {
                if ($PSCmdlet.ShouldProcess($d, 'Datei wiederherstellen')) {
                    wbadmin start recovery -version:$Version -itemType:File -items:"$ordner\$d" -backupTarget:F: -recoveryTarget:E:\Wiederhergestellt -quiet
                }
            }
        }
        Write-Host ("Dauer Wiederherstellung (3 Dateien): {0:n1} s" -f $dauer.TotalSeconds)
    }
    'Vergleichen' {
        $soll = Import-Csv 'C:\Temp\hash-vorher.csv'
        foreach ($d in $dateien) {
            $kandidat = Get-ChildItem -Path 'E:\Daten\Projekt', 'E:\Wiederhergestellt' -Filter $d -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1
            $erwartet = ($soll | Where-Object { $_.Path -like "*\$d" }).Hash
            if (-not $kandidat) { Write-Host "$d : NICHT GEFUNDEN"; continue }
            $ist = (Get-FileHash $kandidat.FullName).Hash
            Write-Host ("{0} : {1}" -f $d, $(if ($ist -eq $erwartet) { 'Hash gleich (OK)' } else { 'Hash ABWEICHEND' }))
        }
    }
}
