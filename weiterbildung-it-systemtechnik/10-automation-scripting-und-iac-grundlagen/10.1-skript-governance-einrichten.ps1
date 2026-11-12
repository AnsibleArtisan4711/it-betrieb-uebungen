<#
.SYNOPSIS
    Legt die versteckte Freigabe Skripte$ mit Rechten an (Uebung 10.1, Teil 8) oder entfernt sie.
.DESCRIPTION
    Laeuft auf SRV-FS01 (Windows PowerShell 5.1, Administrator). Ordner C:\Skripte\Freigegeben.
      Einrichten  Ordner, NTFS: lab-adm01 Aendern, Authentifizierte Benutzer Lesen; Freigabe Skripte$ (Lesen fuer Authentifizierte
                  Benutzer, Aendern fuer lab-adm01)
      Entfernen   entfernt NUR die Freigabe Skripte$ (Ordner und Dateien bleiben)
    Der Ausgangswert der Ausfuehrungsrichtlinie wird nur ANGEZEIGT (Get-ExecutionPolicy -List), nicht geaendert.
    icacls- und SMB-Parameter nicht bestaetigt. Mit -WhatIf wird nichts geaendert. Nur Syntaxpruefung.
#>
[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [Parameter(Mandatory)][ValidateSet('Einrichten', 'Entfernen')][string]$Aktion
)

if ($env:COMPUTERNAME -ne 'SRV-FS01') { throw "Dieses Skript gehoert auf SRV-FS01, nicht auf $env:COMPUTERNAME." }
$ordner = 'C:\Skripte\Freigegeben'
if ($Aktion -eq 'Einrichten') {
    if ($PSCmdlet.ShouldProcess($ordner, 'Ordner anlegen, Rechte setzen, Freigabe Skripte$ erstellen')) {
        New-Item -ItemType Directory -Path $ordner -Force | Out-Null
        icacls $ordner /grant 'LAB\lab-adm01:(OI)(CI)M' /grant '*S-1-5-11:(OI)(CI)R' | Out-Null
        New-SmbShare -Name 'Skripte$' -Path $ordner -ChangeAccess 'LAB\lab-adm01' -ReadAccess 'NT AUTHORITY\Authenticated Users' | Out-Null
    }
    Get-SmbShareAccess -Name 'Skripte$'
    Get-ExecutionPolicy -List
} else {
    if (Get-SmbShare -Name 'Skripte$' -ErrorAction SilentlyContinue) {
        if ($PSCmdlet.ShouldProcess('Skripte$', 'Freigabe entfernen (Ordner bleibt)')) { Remove-SmbShare -Name 'Skripte$' -Force }
    }
}
