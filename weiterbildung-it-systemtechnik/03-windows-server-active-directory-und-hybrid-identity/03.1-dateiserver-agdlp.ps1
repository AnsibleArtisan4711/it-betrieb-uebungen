<#
.SYNOPSIS
    Richtet auf SRV-FS01 Datenlaufwerk E:, Ordner und Freigabe "Daten" nach AGDLP ein (Uebung 03.1, Teil 5).
.DESCRIPTION
    Laeuft auf SRV-FS01 (Windows PowerShell 5.1, als Administrator), NACHDEM der Server Domaenenmitglied ist
    und die Gruppen existieren (03.1-ou-und-konten.ps1). VORBEDINGUNGEN fuer die Datentraegerbefehle:
    Prüfpunkt SRV-FS01 wurde bei ausgeschalteter VM erstellt; eine NEUE leere Festplatte (20 GB) ist angehaengt.
    Das Skript formatiert NUR einen Datentraeger mit PartitionStyle RAW und genau 20 GB; sonst Abbruch.
    NTFS: dl-projekt-rw Aendern; Freigabe: dl-projekt-rw Aendern; Jeder erhaelt nichts.
    Mit -WhatIf wird nichts geaendert.
#>
[CmdletBinding(SupportsShouldProcess = $true)]
param()

if (-not (Get-Volume -DriveLetter E -ErrorAction SilentlyContinue)) {
    $kandidaten = @(Get-Disk | Where-Object { $_.PartitionStyle -eq 'RAW' -and [math]::Round($_.Size / 1GB) -eq 20 })
    if ($kandidaten.Count -ne 1) {
        throw "Erwartet genau einen RAW-Datentraeger mit 20 GB, gefunden: $($kandidaten.Count). Get-Disk pruefen. Abbruch."
    }
    $nr = $kandidaten[0].Number
    if ($PSCmdlet.ShouldProcess("Datentraeger $nr", 'Initialisieren, partitionieren, als E: formatieren')) {
        Initialize-Disk -Number $nr -PartitionStyle GPT
        New-Partition -DiskNumber $nr -DriveLetter E -UseMaximumSize | Out-Null
        Format-Volume -DriveLetter E -FileSystem NTFS -NewFileSystemLabel 'Daten' -Confirm:$false | Out-Null
    }
}

$pfad = 'E:\Daten\Projekt'
if ($PSCmdlet.ShouldProcess($pfad, 'Ordner anlegen')) { New-Item -ItemType Directory -Path $pfad -Force | Out-Null }

if ($PSCmdlet.ShouldProcess($pfad, 'NTFS-Rechte setzen')) {
    # Vererbung aus E:\ entfernen, vorhandene Rechte kopieren, dann gezielt ergaenzen
    icacls $pfad /inheritance:d | Out-Null
    icacls $pfad /remove:g 'Users' 'Authenticated Users' 2>$null | Out-Null
    icacls $pfad /grant 'LAB\dl-projekt-rw:(OI)(CI)M' | Out-Null
    icacls $pfad
}
if (-not (Get-SmbShare -Name 'Daten' -ErrorAction SilentlyContinue)) {
    if ($PSCmdlet.ShouldProcess('Daten', 'Freigabe anlegen')) {
        New-SmbShare -Name 'Daten' -Path 'E:\Daten' -ChangeAccess 'LAB\dl-projekt-rw' | Out-Null
        # Standardmaessig erhaelt "Jeder" Lesezugriff bei neuen Freigaben; ausdruecklich entziehen:
        Revoke-SmbShareAccess -Name 'Daten' -AccountName 'Everyone' -Force -ErrorAction SilentlyContinue | Out-Null
    }
}
Get-SmbShareAccess -Name 'Daten'
