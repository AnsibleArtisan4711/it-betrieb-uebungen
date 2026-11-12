<#
.SYNOPSIS
    Prueft die delegierte Kennwortruecksetzung fuer grp-helpdesk (Uebung 09.1, Teil 4, Schritt 3).
.DESCRIPTION
    Laeuft auf SRV-FS01 (Windows PowerShell 5.1, RSAT-AD-PowerShell installiert). Setzt das Kennwort des Zielkontos zurueck
    und zwar mit den Anmeldedaten von LAB\lab-hd01. Es wird KEIN Kennwort im Skript gespeichert: das Anmeldekennwort fragt
    Get-Credential interaktiv ab, das neue Kennwort Read-Host -AsSecureString.
    Erwartung: lab-user01 (OU Benutzer) gelingt, lab-adm01 (OU Admin) scheitert mit Zugriff verweigert.
    Mit -WhatIf wird nichts geaendert. Cmdlets nicht bestaetigt. Nicht auf Windows ausgefuehrt (nur Syntaxpruefung).
#>
[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [Parameter(Mandatory)][ValidateSet('lab-user01', 'lab-adm01')][string]$Ziel,
    [string]$Helpdesk = 'LAB\lab-hd01'
)

if ($env:COMPUTERNAME -ne 'SRV-FS01') { throw "Dieses Skript gehoert auf SRV-FS01, nicht auf $env:COMPUTERNAME." }
$cred = Get-Credential -UserName $Helpdesk -Message 'Anmeldung des Helpdesk-Kontos'
$neu = Read-Host -AsSecureString "Neues Kennwort fuer $Ziel"
if ($PSCmdlet.ShouldProcess($Ziel, "Kennwort zuruecksetzen als $Helpdesk")) {
    try {
        Set-ADAccountPassword -Identity $Ziel -Reset -NewPassword $neu -Credential $cred -ErrorAction Stop
        Write-Host "$Ziel : Ruecksetzen ERFOLGREICH" -ForegroundColor Green
    } catch {
        Write-Host "$Ziel : FEHLGESCHLAGEN - $($_.Exception.Message)" -ForegroundColor Yellow
    }
}
