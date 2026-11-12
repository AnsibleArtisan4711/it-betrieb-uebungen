<#
.SYNOPSIS
    VLAN-Demonstration (Uebung 02.1, Teil 5): setzt NIC-LAB von SRV-DC01 und SRV-FS01 auf VLAN-IDs oder zurueck.
.DESCRIPTION
    Laeuft auf dem Hyper-V-HOST als Administrator. Beide VMs duerfen laufen.
      -Modus Getrennt  : SRV-DC01 VLAN 10, SRV-FS01 VLAN 20
      -Modus Gleich    : beide VLAN 10
      -Modus Zurueck   : beide ohne VLAN (Untagged)  <- Pflicht am Ende
    Ob ein privater Switch die Trennung wie erwartet zeigt, ist NICHT BESTAETIGT.
    Mit -WhatIf wird nichts geaendert.
#>
[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [Parameter(Mandatory)][ValidateSet('Getrennt', 'Gleich', 'Zurueck')][string]$Modus
)

$ziele = @{
    Getrennt = @{ 'SRV-DC01' = 10; 'SRV-FS01' = 20 }
    Gleich   = @{ 'SRV-DC01' = 10; 'SRV-FS01' = 10 }
}

foreach ($vm in 'SRV-DC01', 'SRV-FS01') {
    if ($Modus -eq 'Zurueck') {
        if ($PSCmdlet.ShouldProcess($vm, 'VLAN entfernen (Untagged)')) {
            Set-VMNetworkAdapterVlan -VMName $vm -VMNetworkAdapterName 'NIC-LAB' -Untagged
        }
    } else {
        $id = $ziele[$Modus][$vm]
        if ($PSCmdlet.ShouldProcess($vm, "VLAN $id setzen")) {
            Set-VMNetworkAdapterVlan -VMName $vm -VMNetworkAdapterName 'NIC-LAB' -Access -VlanId $id
        }
    }
}
Get-VMNetworkAdapterVlan -VMName 'SRV-DC01', 'SRV-FS01' | Select-Object ParentAdapter, OperationMode, AccessVlanId
