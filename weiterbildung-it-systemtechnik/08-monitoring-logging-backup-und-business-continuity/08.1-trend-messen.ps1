<#
.SYNOPSIS
    Sammelt zehn Messwerte im Abstand von 30 Sekunden in eine CSV (Uebung 08.1, Teil 3).
.DESCRIPTION
    Laeuft auf SRV-FS01 (Windows PowerShell 5.1). Gemessen werden freier Speicher auf C: (GB) und verfuegbarer
    Arbeitsspeicher (MB, Get-Counter). Ausgabe: C:\Temp\trend.csv (Ordner vorher anlegen; wird ueberschrieben).
    Danach: Import-Csv C:\Temp\trend.csv | Measure-Object FreiGB -Average -Minimum -Maximum
    oder python3 08.1-kapazitaet-und-rto.py werte trend.csv FreiGB.
    Mit -WhatIf wird nichts geschrieben. Nicht auf Windows ausgefuehrt (nur Syntaxpruefung).
#>
[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [int]$Anzahl = 10,
    [int]$AbstandSekunden = 30,
    [string]$Ziel = 'C:\Temp\trend.csv'
)

$zeilen = for ($i = 1; $i -le $Anzahl; $i++) {
    [pscustomobject]@{
        Zeit         = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
        FreiGB       = [math]::Round((Get-PSDrive -Name C).Free / 1GB, 2)
        VerfuegbarMB = [math]::Round((Get-Counter '\Memory\Available MBytes').CounterSamples[0].CookedValue)
    }
    if ($i -lt $Anzahl) { Start-Sleep -Seconds $AbstandSekunden }
}
if ($PSCmdlet.ShouldProcess($Ziel, 'CSV schreiben')) {
    $zeilen | Export-Csv -Path $Ziel -NoTypeInformation -Encoding UTF8
}
$zeilen | Format-Table -AutoSize
