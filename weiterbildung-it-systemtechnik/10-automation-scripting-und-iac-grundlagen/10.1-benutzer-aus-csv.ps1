<#
.SYNOPSIS
    Legt Benutzer aus einer CSV in der OU Skript-Test an, wiederholbar (Uebung 10.1, Teil 6).
.DESCRIPTION
    Laeuft auf SRV-FS01 als LAB\lab-adm01 (Windows PowerShell 5.1, RSAT-AD-PowerShell). Aktionen:
      Anlegen    legt OU (falls fehlt) und fehlende Konten an; vorhandene werden uebersprungen (idempotent)
      Rueckbau   zeigt zuerst die Konten der OU; entfernt OU samt Inhalt NUR, wenn dort genau die Konten aus der CSV liegen
    Das Anfangskennwort wird einmal mit Read-Host -AsSecureString abgefragt, nie gespeichert. Konten werden aktiviert mit
    Aenderung bei der naechsten Anmeldung. Mit -WhatIf wird nichts geaendert. AD-Cmdlets nicht bestaetigt.
    Nicht auf Windows ausgefuehrt (nur Syntaxpruefung).
#>
[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [Parameter(Mandatory)][ValidateSet('Anlegen', 'Rueckbau')][string]$Aktion,
    [string]$Csv = 'C:\Skripte\users.csv',
    [string]$Domaene = 'DC=lab,DC=example,DC=internal'
)

if ($env:COMPUTERNAME -ne 'SRV-FS01') { throw "Dieses Skript gehoert auf SRV-FS01, nicht auf $env:COMPUTERNAME." }
Import-Module ActiveDirectory -ErrorAction Stop
$ou = "OU=Skript-Test,$Domaene"
$users = Import-Csv -LiteralPath $Csv

if ($Aktion -eq 'Anlegen') {
    if (-not (Get-ADOrganizationalUnit -Filter "Name -eq 'Skript-Test'" -SearchBase $Domaene -ErrorAction SilentlyContinue)) {
        if ($PSCmdlet.ShouldProcess($ou, 'OU anlegen')) { New-ADOrganizationalUnit -Name 'Skript-Test' -Path $Domaene }
    }
    $kennwort = Read-Host -AsSecureString 'Anfangskennwort fuer neue Konten'
    foreach ($u in $users) {
        if (Get-ADUser -Filter "SamAccountName -eq '$($u.Anmeldename)'" -ErrorAction SilentlyContinue) {
            Write-Host "$($u.Anmeldename): existiert bereits, uebersprungen."
            continue
        }
        if ($PSCmdlet.ShouldProcess($u.Anmeldename, "Konto in $ou anlegen")) {
            New-ADUser -Name "$($u.Vorname) $($u.Name)" -GivenName $u.Vorname -Surname $u.Name -SamAccountName $u.Anmeldename `
                -Path $ou -AccountPassword $kennwort -Enabled $true -ChangePasswordAtLogon $true
            Write-Host "$($u.Anmeldename): angelegt."
        }
    }
} else {
    $vorhanden = @(Get-ADUser -SearchBase $ou -Filter * | Select-Object -ExpandProperty SamAccountName)
    $vorhanden | Sort-Object | ForEach-Object { Write-Host "In OU: $_" }
    $erwartet = @($users.Anmeldename)
    $fremd = @($vorhanden | Where-Object { $_ -notin $erwartet })
    if ($fremd.Count -gt 0) { throw "Fremde Konten in der OU: $($fremd -join ', '). Nichts entfernt." }
    if ($PSCmdlet.ShouldProcess($ou, 'Schutz aufheben und OU samt Inhalt entfernen')) {
        Set-ADOrganizationalUnit -Identity $ou -ProtectedFromAccidentalDeletion $false
        Remove-ADOrganizationalUnit -Identity $ou -Recursive -Confirm:$false
    }
}
