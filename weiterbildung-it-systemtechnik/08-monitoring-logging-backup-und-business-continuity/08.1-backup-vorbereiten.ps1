<#
.SYNOPSIS
    Installiert Windows Server Backup, bereitet F: vor und erzeugt 20 Testdateien samt Hashliste (Uebung 08.1, Teil 4, Schritte 1 und 2).
.DESCRIPTION
    Laeuft auf SRV-FS01 (Windows PowerShell 5.1, Administrator). VORBEDINGUNGEN: Prüfpunkt SRV-FS01-M8-Start (VM aus),
    NEUE leere Festplatte (40 GB) angehaengt. Das Skript formatiert NUR einen Datentraeger mit PartitionStyle RAW und genau
    40 GB als F:, sonst Abbruch. E:\Daten\Projekt stammt aus Modul 3. Hashliste: C:\Temp\hash-vorher.csv.
    Mit -WhatIf wird nichts geaendert. Nicht auf Windows ausgefuehrt (nur Syntaxpruefung).
#>
[CmdletBinding(SupportsShouldProcess = $true)]
param()

if ($PSCmdlet.ShouldProcess('SRV-FS01', 'Windows-Server-Backup installieren')) {
    Install-WindowsFeature -Name Windows-Server-Backup
}
if (-not (Get-Volume -DriveLetter F -ErrorAction SilentlyContinue)) {
    $kand = @(Get-Disk | Where-Object { $_.PartitionStyle -eq 'RAW' -and [math]::Round($_.Size / 1GB) -eq 40 })
    if ($kand.Count -ne 1) { throw "Erwartet genau einen RAW-Datentraeger mit 40 GB, gefunden: $($kand.Count). Get-Disk pruefen. Abbruch." }
    $nr = $kand[0].Number
    if ($PSCmdlet.ShouldProcess("Datentraeger $nr", 'als F: formatieren')) {
        Initialize-Disk -Number $nr -PartitionStyle GPT
        New-Partition -DiskNumber $nr -DriveLetter F -UseMaximumSize | Out-Null
        Format-Volume -DriveLetter F -FileSystem NTFS -NewFileSystemLabel 'Sicherung' -Confirm:$false | Out-Null
    }
}
$ordner = 'E:\Daten\Projekt'
if (-not (Test-Path -LiteralPath $ordner)) { throw "$ordner fehlt (Modul 3)." }
if ($PSCmdlet.ShouldProcess($ordner, '20 Testdateien anlegen und Hashwerte speichern')) {
    1..20 | ForEach-Object { Set-Content -Path (Join-Path $ordner ("test{0:00}.txt" -f $_)) -Value "Testdatei $_ - $(Get-Random)" }
    New-Item -ItemType Directory -Path 'C:\Temp' -Force | Out-Null
    Get-ChildItem $ordner -Filter 'test*.txt' | Get-FileHash | Export-Csv 'C:\Temp\hash-vorher.csv' -NoTypeInformation
}
