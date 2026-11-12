<#
.SYNOPSIS
    Legt die privaten Hyper-V-Switches des Labors an (Uebung 02.1, Teil 3, Schritt 1).
.DESCRIPTION
    Laeuft auf dem Hyper-V-HOST in einer PowerShell als Administrator. Legt sw-lab-srv und
    sw-lab-cli als PRIVATE Switches an (keine Verbindung zum Heimnetz). Vorhandene Switches
    werden nicht veraendert. Mit -MitTest wird zusaetzlich sw-lab-test angelegt (ab Modul 6).
    Mit -WhatIf wird nichts geaendert.
.EXAMPLE
    .\02.1-switches-anlegen.ps1 -WhatIf
#>
[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [switch]$MitTest
)

$namen = @('sw-lab-srv', 'sw-lab-cli')
if ($MitTest) { $namen += 'sw-lab-test' }

foreach ($name in $namen) {
    if (Get-VMSwitch -Name $name -ErrorAction SilentlyContinue) {
        Write-Host "Vorhanden, wird nicht veraendert: $name"
        continue
    }
    if ($PSCmdlet.ShouldProcess($name, 'Privaten Switch anlegen')) {
        New-VMSwitch -Name $name -SwitchType Private | Out-Null
        Write-Host "Angelegt: $name (Private)"
    }
}
Get-VMSwitch | Select-Object Name, SwitchType
