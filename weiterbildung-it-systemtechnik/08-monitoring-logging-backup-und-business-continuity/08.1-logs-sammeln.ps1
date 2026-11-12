<#
.SYNOPSIS
    Holt Ereignisse beider Server und das Linux-Journal auf CL-W11-01 (Uebung 08.1, Teil 2).
.DESCRIPTION
    Laeuft auf CL-W11-01 als LAB\lab-adm01 (Windows PowerShell 5.1). VORBEDINGUNG: C:\Temp existiert.
    Fuer Invoke-Command muss WinRM auf den Servern erreichbar sein; Firewallregeln und die DNS-Registrierung der
    Servernamen sind NICHT BESTAETIGT (Enable-PSRemoting auf Servern nur falls noetig).
    Das Journal wird per SSH geholt (Schluesselanmeldung aus Modul 5; ssh fragt ggf. die Passphrase).
    Mit -WhatIf wird nichts geschrieben. Nicht auf Windows ausgefuehrt (nur Syntaxpruefung).
#>
[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [string[]]$Server = @('SRV-FS01', 'SRV-DC01'),
    [string]$LinuxHost = '192.168.50.30',
    [string]$LinuxBenutzer = 'labadmin',
    [string]$Ausgabe = 'C:\Temp'
)

if (-not (Test-Path -LiteralPath $Ausgabe)) { throw "Ordner $Ausgabe fehlt." }

$ereignisse = Invoke-Command -ComputerName $Server -ScriptBlock {
    Get-WinEvent -FilterHashtable @{ LogName = 'Application'; ProviderName = 'LabMonitor' } -MaxEvents 10 -ErrorAction SilentlyContinue
}
$csv = Join-Path $Ausgabe 'lab-events.csv'
if ($PSCmdlet.ShouldProcess($csv, 'Ereignisse exportieren')) {
    $ereignisse | Select-Object PSComputerName, TimeCreated, Id, LevelDisplayName, Message | Export-Csv -Path $csv -NoTypeInformation -Encoding UTF8
}
$journal = Join-Path $Ausgabe 'lx-journal.txt'
if ($PSCmdlet.ShouldProcess($journal, "Journal von $LinuxHost holen")) {
    ssh "$LinuxBenutzer@$LinuxHost" "journalctl -p warning --since '1 hour ago' --no-pager" | Set-Content -Path $journal -Encoding UTF8
}
Write-Host "Ereignisse: $csv ($(@($ereignisse).Count) Zeilen); Journal: $journal"
