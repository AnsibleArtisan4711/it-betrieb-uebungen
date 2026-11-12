<#
.SYNOPSIS
    Legt GPOs an, verknuepft sie und verschiebt den Client zwischen OUs (Uebung 03.1, Teil 4).
.DESCRIPTION
    Laeuft auf SRV-DC01 (Module ActiveDirectory und GroupPolicy). Die EINSTELLUNG selbst (Interaktive
    Anmeldung: Nachrichtentext) setzt du in der Gruppenrichtlinien-Verwaltung von Hand; das Skript legt nur
    die Objekte an und verknuepft sie. Aktionen:
      Anlegen    GPO-Lab-Client anlegen, mit OU=Computer verknuepfen
      Testzweig  OU Computer\Test anlegen, CL-W11-01 dorthin verschieben, GPO-Lab-Client-2 anlegen und verknuepfen
      Rueckbau   Verknuepfungen entfernen, CL-W11-01 zurueck nach OU=Computer verschieben
    GPOs selbst bleiben bestehen und koennen in der GPMC geloescht werden (Name pruefen!).
    Mit -WhatIf wird nichts geaendert.
#>
[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [Parameter(Mandatory)][ValidateSet('Anlegen', 'Testzweig', 'Rueckbau')][string]$Aktion
)

Import-Module ActiveDirectory, GroupPolicy
$basis    = 'DC=lab,DC=example,DC=internal'
$ouComp   = "OU=Computer,OU=LAB,$basis"
$ouTest   = "OU=Test,$ouComp"

function Ensure-Gpo($Name) {
    if (-not (Get-GPO -Name $Name -ErrorAction SilentlyContinue)) {
        if ($PSCmdlet.ShouldProcess($Name, 'GPO anlegen')) { New-GPO -Name $Name | Out-Null }
    }
}

switch ($Aktion) {
    'Anlegen' {
        Ensure-Gpo 'GPO-Lab-Client'
        if ($PSCmdlet.ShouldProcess($ouComp, 'GPO-Lab-Client verknuepfen')) {
            New-GPLink -Name 'GPO-Lab-Client' -Target $ouComp | Out-Null
        }
        Write-Host 'Jetzt in der GPMC die Einstellung "Interaktive Anmeldung: Nachrichtentext..." setzen.'
    }
    'Testzweig' {
        if (-not (Get-ADOrganizationalUnit -Filter "DistinguishedName -eq '$ouTest'" -ErrorAction SilentlyContinue)) {
            if ($PSCmdlet.ShouldProcess($ouTest, 'OU anlegen')) { New-ADOrganizationalUnit -Name 'Test' -Path $ouComp }
        }
        Ensure-Gpo 'GPO-Lab-Client-2'
        if ($PSCmdlet.ShouldProcess($ouTest, 'GPO-Lab-Client-2 verknuepfen')) {
            New-GPLink -Name 'GPO-Lab-Client-2' -Target $ouTest | Out-Null
        }
        if ($PSCmdlet.ShouldProcess('CL-W11-01', "nach $ouTest verschieben")) {
            Get-ADComputer -Identity 'CL-W11-01' | Move-ADObject -TargetPath $ouTest
        }
        Write-Host 'Jetzt in GPO-Lab-Client-2 einen ANDEREN Nachrichtentext setzen, am Client gpupdate /force und gpresult /r.'
    }
    'Rueckbau' {
        if ($PSCmdlet.ShouldProcess('CL-W11-01', "nach $ouComp verschieben")) {
            Get-ADComputer -Identity 'CL-W11-01' | Move-ADObject -TargetPath $ouComp
        }
        foreach ($paar in @(@('GPO-Lab-Client-2', $ouTest), @('GPO-Lab-Client', $ouComp))) {
            if ($PSCmdlet.ShouldProcess($paar[1], "Verknuepfung $($paar[0]) entfernen")) {
                Remove-GPLink -Name $paar[0] -Target $paar[1] -ErrorAction SilentlyContinue | Out-Null
            }
        }
    }
}
