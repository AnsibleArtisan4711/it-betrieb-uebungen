<#
.SYNOPSIS
    Traegt ein Skript mit SHA-256-Hash in die Freigabeliste freigabe.csv ein (Uebung 10.1, Teil 8).
.DESCRIPTION
    Spalten der Liste: Skript, Version, SHA256, Datum, Freigeber. Das Skript haengt eine Zeile an.
    Gleiche Kombination aus Skript und Version mit ANDEREM Hash wird abgelehnt (neue Version angeben).
    Der Freigeber ist eine Rolle oder ein Konto (kein Kennwort). Mit -WhatIf wird nichts geschrieben.
    Logik real getestet unter PowerShell 7.4 auf Linux; auf Windows PowerShell 5.1 nicht ausgefuehrt.
#>
[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [Parameter(Mandatory)][string]$Skript,
    [Parameter(Mandatory)][string]$Version,
    [Parameter(Mandatory)][string]$Freigeber,
    [string]$Liste = 'C:\Skripte\Freigegeben\freigabe.csv'
)

if (-not (Test-Path -LiteralPath $Skript -PathType Leaf)) { throw "Skript '$Skript' nicht gefunden." }
$name = Split-Path -Leaf $Skript
$hash = (Get-FileHash -LiteralPath $Skript -Algorithm SHA256).Hash
$bisher = @()
if (Test-Path -LiteralPath $Liste) { $bisher = @(Import-Csv -LiteralPath $Liste) }
$gleich = $bisher | Where-Object { $_.Skript -eq $name -and $_.Version -eq $Version }
if ($gleich -and $gleich.SHA256 -ne $hash) { throw "Version $Version von $name ist mit anderem Hash freigegeben. Neue Version vergeben." }
if ($gleich) { Write-Host "Bereits freigegeben ($name $Version)."; return }
$zeile = [pscustomobject]@{ Skript = $name; Version = $Version; SHA256 = $hash; Datum = (Get-Date -Format 'yyyy-MM-dd'); Freigeber = $Freigeber }
if ($PSCmdlet.ShouldProcess($Liste, "Freigabe $name $Version eintragen")) {
    $zeile | Export-Csv -LiteralPath $Liste -NoTypeInformation -Append -Encoding UTF8
    Write-Host "Eingetragen: $name $Version"
}
