<#
.SYNOPSIS
    Exportiert LX-UBU01 und importiert eine Kopie als LX-UBU01-Klon in den isolierten Switch sw-lab-test (Uebung 06.1, Teil 2).
.DESCRIPTION
    Laeuft auf dem Hyper-V-HOST als Administrator. VORBEDINGUNGEN: LX-UBU01 ist ausgeschaltet; sw-lab-test existiert
    (02.1-switches-anlegen.ps1 -MitTest). Der Klon wird mit -Copy -GenerateNewId importiert (Learn), UMBENANNT und
    ALLE Adapter werden VOR dem ersten Start auf sw-lab-test gelegt bzw. getrennt. Der Klon wird NICHT gestartet.
    Pfade sind Beispiele (D:). Mit -WhatIf wird nichts geaendert.
    Nicht auf Hyper-V ausgefuehrt (nur Syntaxpruefung). Rename-VM und Connect-VMNetworkAdapter sind nicht bestaetigt.
#>
[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [string]$Quelle      = 'LX-UBU01',
    [string]$ExportOrdner = 'D:\Export',
    [string]$KlonOrdner  = 'D:\VMs\Klon'
)

if ((Get-VM -Name $Quelle).State -ne 'Off') { throw "$Quelle muss ausgeschaltet sein (Stop-VM)." }
if (-not (Get-VMSwitch -Name 'sw-lab-test' -ErrorAction SilentlyContinue)) { throw 'Switch sw-lab-test fehlt.' }
if (Get-VM -Name 'LX-UBU01-Klon' -ErrorAction SilentlyContinue) { throw 'LX-UBU01-Klon existiert bereits.' }

if ($PSCmdlet.ShouldProcess($Quelle, "Export nach $ExportOrdner")) {
    Export-VM -Name $Quelle -Path $ExportOrdner
}
$vmcx = Get-ChildItem -Path (Join-Path $ExportOrdner "$Quelle\Virtual Machines") -Filter *.vmcx -ErrorAction SilentlyContinue | Select-Object -First 1
if (-not $vmcx -and -not $WhatIfPreference) { throw 'Keine .vmcx-Datei im Export gefunden.' }

if ($PSCmdlet.ShouldProcess($Quelle, 'Import als Kopie mit neuer ID')) {
    $neu = Import-VM -Path $vmcx.FullName -Copy -GenerateNewId -VhdDestinationPath $KlonOrdner -VirtualMachinePath $KlonOrdner
    Rename-VM -VM $neu -NewName 'LX-UBU01-Klon'
    # SOFORT, vor dem ersten Start: Adapter auf den isolierten Switch bzw. trennen
    foreach ($na in Get-VMNetworkAdapter -VMName 'LX-UBU01-Klon') {
        if ($na.Name -eq 'NIC-INET') { Disconnect-VMNetworkAdapter -VMNetworkAdapter $na }
        else { Connect-VMNetworkAdapter -VMNetworkAdapter $na -SwitchName 'sw-lab-test' }
    }
    Get-VMNetworkAdapter -VMName 'LX-UBU01-Klon' | Select-Object Name, SwitchName
    Get-VMHardDiskDrive -VMName 'LX-UBU01-Klon' | Select-Object Path
}
