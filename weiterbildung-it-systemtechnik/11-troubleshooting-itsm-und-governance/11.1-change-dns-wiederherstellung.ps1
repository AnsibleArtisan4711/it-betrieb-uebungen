<#
.SYNOPSIS
    Sichert, aendert und setzt die Wiederherstellungsaktionen des DNS-Dienstes zurueck (Uebung 11.1, Teil 4).
.DESCRIPTION
    Laeuft auf SRV-DC01 (Windows PowerShell 5.1, Administrator) im Wartungsfenster.
      Sichern    sc.exe qfailure DNS  -> C:\Temp\dns-failure-vorher.txt (Pflicht VOR der Aenderung, in den Antrag uebernehmen)
      Aendern    sc.exe failure DNS reset= 86400 actions= restart/60000/restart/60000//0   (laut Lehrplan; Syntax NICHT BESTAETIGT)
      Rollback   setzt die Werte zurueck, die DU aus der Sicherung ablaest: -Reset und -Aktionen angeben (z. B. -Reset 0 -Aktionen '///')
    Das Skript erfindet keine Ausgangswerte. Ohne Sicherungsdatei brechen Aendern und Rollback ab.
    Mit -WhatIf wird nichts geaendert. Nicht auf Windows ausgefuehrt (nur Syntaxpruefung).
#>
[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [Parameter(Mandatory)][ValidateSet('Sichern', 'Aendern', 'Rollback')][string]$Aktion,
    [string]$Sicherung = 'C:\Temp\dns-failure-vorher.txt',
    [string]$Reset,
    [string]$Aktionen
)

if ($env:COMPUTERNAME -ne 'SRV-DC01') { throw "Dieses Skript gehoert auf SRV-DC01, nicht auf $env:COMPUTERNAME." }
switch ($Aktion) {
    'Sichern' {
        if ($PSCmdlet.ShouldProcess($Sicherung, 'Ist-Zustand sichern')) {
            sc.exe qfailure DNS | Tee-Object -FilePath $Sicherung
        }
    }
    'Aendern' {
        if (-not (Test-Path -LiteralPath $Sicherung)) { throw 'Erst -Aktion Sichern ausfuehren (Rollback braucht den Ausgangszustand).' }
        if ($PSCmdlet.ShouldProcess('DNS', 'Wiederherstellungsaktionen setzen')) {
            sc.exe failure DNS reset= 86400 actions= restart/60000/restart/60000//0
        }
        sc.exe qfailure DNS
    }
    'Rollback' {
        if (-not (Test-Path -LiteralPath $Sicherung)) { throw 'Sicherungsdatei fehlt: Ausgangszustand unbekannt, nichts geaendert.' }
        if (-not $Reset -or -not $Aktionen) { throw 'Bitte -Reset und -Aktionen aus der Sicherung angeben (siehe Datei).' }
        Get-Content -LiteralPath $Sicherung
        if ($PSCmdlet.ShouldProcess('DNS', "Zuruecksetzen: reset= $Reset actions= $Aktionen")) {
            sc.exe failure DNS reset= $Reset actions= $Aktionen
        }
        sc.exe qfailure DNS
    }
}
