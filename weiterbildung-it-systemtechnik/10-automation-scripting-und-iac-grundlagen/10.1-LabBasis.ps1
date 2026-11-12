<#
.SYNOPSIS
    DSC-Konfiguration LabBasis (Uebung 10.1, Teil 7): Ordner und Datei deklarativ sicherstellen.
.DESCRIPTION
    Laeuft auf SRV-FS01 in Windows PowerShell 5.1 (DSC 1.1, Ressource File aus PSDesiredStateConfiguration).
    Aufruf:  .\10.1-LabBasis.ps1            erzeugt C:\Skripte\LabBasis\localhost.mof
             .\10.1-LabBasis.ps1 -Anwenden  wendet sie zusaetzlich an (Start-DscConfiguration -Wait -Verbose)
    Rueckbau:  .\10.1-LabBasis.ps1 -Aufraeumen  entfernt C:\Skripte\dsc-test, nach Pfadpruefung.
    Mit -WhatIf wird nichts angewendet oder geloescht. Nicht auf Windows ausgefuehrt. Syntaxpruefung nur fuer den Teil ausserhalb von "Configuration" moeglich (der Parser unter Linux kennt keine DSC-Ressourcen).
#>
[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [switch]$Anwenden,
    [switch]$Aufraeumen
)

Configuration LabBasis {
    Import-DscResource -ModuleName PSDesiredStateConfiguration
    Node 'localhost' {
        File Ordner { DestinationPath = 'C:\Skripte\dsc-test'; Type = 'Directory'; Ensure = 'Present' }
        File Datei  { DestinationPath = 'C:\Skripte\dsc-test\hallo.txt'; Contents = 'Lab'; Ensure = 'Present'; DependsOn = '[File]Ordner' }
    }
}

if ($Aufraeumen) {
    $ziel = 'C:\Skripte\dsc-test'
    if ((Resolve-Path -LiteralPath $ziel -ErrorAction SilentlyContinue).Path -ne $ziel) { throw "Pfad $ziel nicht gefunden oder abweichend. Nichts geloescht." }
    if ($PSCmdlet.ShouldProcess($ziel, 'Ordner loeschen')) { Remove-Item -LiteralPath $ziel -Recurse }
    return
}
LabBasis -OutputPath C:\Skripte\LabBasis | Out-Null
if ($Anwenden -and $PSCmdlet.ShouldProcess('localhost', 'DSC-Konfiguration anwenden')) {
    Start-DscConfiguration -Path C:\Skripte\LabBasis -Wait -Verbose
}
