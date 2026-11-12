<#
.SYNOPSIS
    Erzeugt auf dem Host ein SSH-Schluesselpaar (ed25519) fuer die Azure-VM (Uebung 07.1, Teil 4).
.DESCRIPTION
    Laeuft auf dem Hyper-V-HOST (OpenSSH-Client noetig, Verfuegbarkeit nicht bestaetigt). Die Passphrase wird von
    ssh-keygen INTERAKTIV abgefragt und nirgends gespeichert. Ein vorhandener Schluessel gleichen Namens wird NICHT
    ueberschrieben. Es wird nur der OEFFENTLICHE Schluessel angezeigt (der kommt ins Portal). Den privaten Schluessel
    gibst du nie weiter.
    Mit -WhatIf wird nichts geaendert.
#>
[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [string]$Name = 'id_ed25519_azure_lab'
)

if (-not (Get-Command ssh-keygen -ErrorAction SilentlyContinue)) {
    throw 'ssh-keygen nicht gefunden: OpenSSH-Client installieren (Optionale Features).'
}
$ordner = Join-Path $env:USERPROFILE '.ssh'
$pfad = Join-Path $ordner $Name
if (Test-Path -LiteralPath $pfad) {
    Write-Warning "Schluessel $pfad existiert bereits und wird nicht ueberschrieben."
} elseif ($PSCmdlet.ShouldProcess($pfad, 'Schluesselpaar erzeugen')) {
    New-Item -ItemType Directory -Path $ordner -Force | Out-Null
    ssh-keygen -t ed25519 -f $pfad -C 'lab-azure'
}
if (Test-Path -LiteralPath "$pfad.pub") {
    Write-Host 'Oeffentlicher Schluessel (fuer das Portal):'
    Get-Content -LiteralPath "$pfad.pub"
}
