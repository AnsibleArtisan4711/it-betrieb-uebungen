<#
.SYNOPSIS
    Startet ein Skript nur, wenn sein SHA-256-Hash zur Freigabeliste passt (Uebung 10.1, Teil 8).
.DESCRIPTION
    Sucht die LETZTE Zeile der Liste zum Skriptnamen, vergleicht den Hash und bricht bei Abweichung oder fehlendem Eintrag
    mit Rueckgabewert 1 ab, ohne das Skript zu starten. Zusaetzliche Argumente fuer das Skript ueber -Argumente.
    Wichtig: Schuetzt nur gegen versehentliche oder unbemerkte Aenderung, wenn die Liste selbst nur von Freigebern
    beschreibbar ist (NTFS-Rechte). Die Ausfuehrungsrichtlinie ist keine Sicherheitsgrenze (nicht bestaetigt).
    Logik real getestet unter PowerShell 7.4 auf Linux; auf Windows PowerShell 5.1 nicht ausgefuehrt.
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory)][string]$Skript,
    [string]$Liste = 'C:\Skripte\Freigegeben\freigabe.csv',
    [string[]]$Argumente = @()
)

if (-not (Test-Path -LiteralPath $Skript -PathType Leaf)) { Write-Error "Skript '$Skript' nicht gefunden."; exit 1 }
if (-not (Test-Path -LiteralPath $Liste)) { Write-Error "Freigabeliste '$Liste' nicht gefunden."; exit 1 }
$name = Split-Path -Leaf $Skript
$eintrag = @(Import-Csv -LiteralPath $Liste | Where-Object { $_.Skript -eq $name }) | Select-Object -Last 1
if (-not $eintrag) { Write-Error "Kein Freigabeeintrag fuer $name. Nicht gestartet."; exit 1 }
$ist = (Get-FileHash -LiteralPath $Skript -Algorithm SHA256).Hash
if ($ist -ne $eintrag.SHA256) {
    Write-Error "Hash von $name weicht von der Freigabe ab (Version $($eintrag.Version)). Nicht gestartet."
    exit 1
}
Write-Host "Hash OK ($name, Version $($eintrag.Version), freigegeben von $($eintrag.Freigeber) am $($eintrag.Datum))."
& $Skript @Argumente
