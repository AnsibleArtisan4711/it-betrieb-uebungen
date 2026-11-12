<#
.SYNOPSIS
    Legt OU-Struktur, Konten und Gruppen an (Uebung 03.1, Teil 2, Schritte 3 und 4, sowie Gruppen fuer Teil 5).
.DESCRIPTION
    Laeuft auf SRV-DC01 NACH der Heraufstufung (Windows PowerShell 5.1, Modul ActiveDirectory).
    Ein einziges Anfangskennwort wird einmal interaktiv abgefragt (Read-Host -AsSecureString) und fuer
    alle Testkonten verwendet; es steht in keiner Datei. Die Konten muessen es bei der ersten
    Anmeldung aendern. Das Skript ist wiederholbar: vorhandene Objekte werden uebersprungen.
    Mit -WhatIf wird nichts geaendert.
#>
[CmdletBinding(SupportsShouldProcess = $true)]
param()

Import-Module ActiveDirectory
$basis = 'DC=lab,DC=example,DC=internal'
$lab   = "OU=LAB,$basis"

function New-LabOu($Name, $Pfad) {
    $dn = "OU=$Name,$Pfad"
    if (-not (Get-ADOrganizationalUnit -Filter "DistinguishedName -eq '$dn'" -ErrorAction SilentlyContinue)) {
        if ($PSCmdlet.ShouldProcess($dn, 'OU anlegen')) { New-ADOrganizationalUnit -Name $Name -Path $Pfad }
    }
}
New-LabOu 'LAB' $basis
foreach ($ou in 'Benutzer', 'Gruppen', 'Computer', 'Admin') { New-LabOu $ou $lab }

$kennwort = Read-Host -AsSecureString 'Anfangskennwort fuer die Testkonten'

function New-LabUser($Name, $Ou) {
    if (-not (Get-ADUser -Filter "SamAccountName -eq '$Name'" -ErrorAction SilentlyContinue)) {
        if ($PSCmdlet.ShouldProcess($Name, 'Konto anlegen')) {
            New-ADUser -Name $Name -SamAccountName $Name -UserPrincipalName "$Name@lab.example.internal" `
                -Path "OU=$Ou,$lab" -AccountPassword $kennwort -Enabled $true -ChangePasswordAtLogon $true
        }
    }
}
New-LabUser 'lab-user01' 'Benutzer'
New-LabUser 'lab-hd01'   'Benutzer'
New-LabUser 'lab-adm01'  'Admin'

function New-LabGroup($Name, $Scope) {
    if (-not (Get-ADGroup -Filter "Name -eq '$Name'" -ErrorAction SilentlyContinue)) {
        if ($PSCmdlet.ShouldProcess($Name, "Gruppe ($Scope) anlegen")) {
            New-ADGroup -Name $Name -GroupScope $Scope -GroupCategory Security -Path "OU=Gruppen,$lab"
        }
    }
}
New-LabGroup 'grp-helpdesk' 'Global'
New-LabGroup 'grp-projekt'  'Global'
New-LabGroup 'dl-projekt-rw' 'DomainLocal'

if ($PSCmdlet.ShouldProcess('Gruppenmitgliedschaften', 'setzen')) {
    Add-ADGroupMember -Identity 'Domain Admins' -Members 'lab-adm01'
    Add-ADGroupMember -Identity 'grp-helpdesk'  -Members 'lab-hd01'
    Add-ADGroupMember -Identity 'grp-projekt'   -Members 'lab-user01'
    Add-ADGroupMember -Identity 'dl-projekt-rw' -Members 'grp-projekt'
}
Get-ADUser -Filter 'SamAccountName -like "lab-*"' | Select-Object SamAccountName, DistinguishedName, Enabled
