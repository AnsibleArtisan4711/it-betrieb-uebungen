<#
.SYNOPSIS
    Sichert den AD-Systemstatus von SRV-DC01 nach G: (Uebung 08.1, Teil 5). Die Wiederherstellung wird NICHT ausgefuehrt.
.DESCRIPTION
    Laeuft auf SRV-DC01 (Windows PowerShell 5.1, Administrator). VORBEDINGUNGEN: Prüfpunkt SRV-DC01-M8-Start (VM aus),
    NEUE leere Festplatte (30 GB) angehaengt, Windows-Server-Backup installiert (Install-WindowsFeature Windows-Server-Backup).
    Das Skript formatiert NUR einen RAW-Datentraeger mit genau 30 GB als G:, sonst Abbruch.
    Befehl: wbadmin start systemstatebackup -backupTarget:G: (Learn). Ausgabe nicht bestaetigt.
    Mit -WhatIf wird nichts geaendert. Nicht auf Windows ausgefuehrt (nur Syntaxpruefung).
#>
[CmdletBinding(SupportsShouldProcess = $true)]
param()

if ($env:COMPUTERNAME -ne 'SRV-DC01') { throw "Dieses Skript gehoert auf SRV-DC01, nicht auf $env:COMPUTERNAME." }
if ($PSCmdlet.ShouldProcess('SRV-DC01', 'Windows-Server-Backup installieren')) {
    Install-WindowsFeature -Name Windows-Server-Backup
}
if (-not (Get-Volume -DriveLetter G -ErrorAction SilentlyContinue)) {
    $kand = @(Get-Disk | Where-Object { $_.PartitionStyle -eq 'RAW' -and [math]::Round($_.Size / 1GB) -eq 30 })
    if ($kand.Count -ne 1) { throw "Erwartet genau einen RAW-Datentraeger mit 30 GB, gefunden: $($kand.Count). Get-Disk pruefen. Abbruch." }
    $nr = $kand[0].Number
    if ($PSCmdlet.ShouldProcess("Datentraeger $nr", 'als G: formatieren')) {
        Initialize-Disk -Number $nr -PartitionStyle GPT
        New-Partition -DiskNumber $nr -DriveLetter G -UseMaximumSize | Out-Null
        Format-Volume -DriveLetter G -FileSystem NTFS -NewFileSystemLabel 'SystemState' -Confirm:$false | Out-Null
    }
}
if ($PSCmdlet.ShouldProcess('G:', 'Systemstatus sichern')) {
    $dauer = Measure-Command { wbadmin start systemstatebackup -backupTarget:G: -quiet }
    Write-Host ("Dauer Systemstatus-Sicherung: {0:n1} s" -f $dauer.TotalSeconds)
}
