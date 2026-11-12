<#
.SYNOPSIS
    Merkt, aktiviert und stellt die Auditierung fehlgeschlagener Anmeldungen wieder her (Uebung 09.1, Teil 7).
.DESCRIPTION
    Laeuft auf SRV-FS01 (und optional SRV-DC01), Windows PowerShell 5.1, Administrator.
      Merken     schreibt auditpol /get in C:\Temp\auditpol-vorher.txt (nichts wird geaendert)
      Aktivieren auditpol /set /subcategory:<Name> /failure:enable
      Zuruecksetzen auditpol /set ... /failure:disable (nur wenn die Merkdatei existiert; pruefe sie vorher!)
      Ereignisse zeigt die letzten fehlgeschlagenen Anmeldungen (Id 4625, nicht bestaetigt)
    WICHTIG: Unterkategorienamen sind je nach Sprache des Systems UNTERSCHIEDLICH (nicht bestaetigt); auf deutschem
    System ggf. -Unterkategorie angeben. Der Name wird mit auditpol /list /subcategory:* geprueft.
    Mit -WhatIf wird nichts geaendert. Nicht auf Windows ausgefuehrt (nur Syntaxpruefung).
#>
[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [Parameter(Mandatory)][ValidateSet('Merken', 'Aktivieren', 'Zuruecksetzen', 'Ereignisse')][string]$Aktion,
    [string]$Unterkategorie = 'Logon',
    [string]$Merkdatei = 'C:\Temp\auditpol-vorher.txt'
)

switch ($Aktion) {
    'Merken' {
        if ($PSCmdlet.ShouldProcess($Merkdatei, 'Ist-Zustand speichern')) {
            auditpol /get /subcategory:"$Unterkategorie" | Tee-Object -FilePath $Merkdatei
        }
    }
    'Aktivieren' {
        if (-not (Test-Path -LiteralPath $Merkdatei)) { throw 'Erst -Aktion Merken ausfuehren.' }
        if ($PSCmdlet.ShouldProcess($Unterkategorie, 'Fehlerprotokollierung aktivieren')) {
            auditpol /set /subcategory:"$Unterkategorie" /failure:enable
        }
    }
    'Zuruecksetzen' {
        if (-not (Test-Path -LiteralPath $Merkdatei)) { throw 'Merkdatei fehlt: Ursprungszustand unbekannt, nichts geaendert.' }
        Write-Host 'Gemerkter Ausgangszustand:'
        Get-Content -LiteralPath $Merkdatei
        if ($PSCmdlet.ShouldProcess($Unterkategorie, 'Fehlerprotokollierung deaktivieren (nur sinnvoll, wenn sie vorher aus war)')) {
            auditpol /set /subcategory:"$Unterkategorie" /failure:disable
        }
    }
    'Ereignisse' {
        Get-WinEvent -FilterHashtable @{ LogName = 'Security'; Id = 4625 } -MaxEvents 5 -ErrorAction SilentlyContinue |
            Select-Object TimeCreated, Id, Message | Format-List
    }
}
