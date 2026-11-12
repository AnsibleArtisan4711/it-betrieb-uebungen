<#
.SYNOPSIS
    Legt einen INTERNEN Switch an, zeigt den Host-Adapter und entfernt ihn wieder (Uebung 06.1, Teil 6).
.DESCRIPTION
    Laeuft auf dem Hyper-V-HOST. Es wird KEIN externer Switch angelegt (er wuerde das Labornetz mit dem Heimnetz verbinden).
      Anlegen   New-VMSwitch -Name sw-lab-int -SwitchType Internal, zeigt den neuen Adapter
      Entfernen Remove-VMSwitch -Name sw-lab-int -Force
    Mit -WhatIf wird nichts geaendert.
#>
[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [Parameter(Mandatory)][ValidateSet('Anlegen', 'Entfernen')][string]$Aktion
)

$name = 'sw-lab-int'
if ($Aktion -eq 'Anlegen') {
    if (-not (Get-VMSwitch -Name $name -ErrorAction SilentlyContinue)) {
        if ($PSCmdlet.ShouldProcess($name, 'Internen Switch anlegen')) { New-VMSwitch -Name $name -SwitchType Internal | Out-Null }
    }
    Get-NetAdapter | Where-Object Name -like "*$name*" | Select-Object Name, Status, MacAddress
} else {
    if (Get-VMSwitch -Name $name -ErrorAction SilentlyContinue) {
        if ($PSCmdlet.ShouldProcess($name, 'Switch entfernen')) { Remove-VMSwitch -Name $name -Force }
    }
}
