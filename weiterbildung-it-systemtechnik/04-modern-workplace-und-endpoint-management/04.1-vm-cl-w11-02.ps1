<#
.SYNOPSIS
    Legt die Cloud-Client-VM CL-W11-02 mit vTPM an, nur am Default Switch (Uebung 04.1, Teil 3, Schritt 3).
.DESCRIPTION
    Laeuft auf dem Hyper-V-HOST als Administrator. Die VM wird NIE mit einem Labor-Switch (sw-lab-*)
    verbunden und nie in die Domaene aufgenommen. Es wird nur der Default Switch verwendet.
    Windows 11 wird anschliessend von der ISO-Datei installiert (Standardassistent, nicht Lernstoff).
    Pfade sind Beispiele und anzupassen. Mit -WhatIf wird nichts geaendert.
    Nicht auf Hyper-V ausgefuehrt (nur Syntaxpruefung); Parameter nach Microsoft Learn teilweise nicht bestaetigt.
#>
[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [Parameter(Mandatory)][string]$IsoPfad,
    [string]$VmOrdner = 'D:\VMs',
    [string]$Name = 'CL-W11-02'
)

if (Get-VM -Name $Name -ErrorAction SilentlyContinue) { throw "VM $Name existiert bereits. Abbruch." }
if (-not (Test-Path -LiteralPath $IsoPfad)) { throw "ISO nicht gefunden: $IsoPfad" }
if (-not (Get-VMSwitch -Name 'Default Switch' -ErrorAction SilentlyContinue)) {
    throw 'Default Switch nicht vorhanden (auf Server-Hosts evtl. nicht verfuegbar, nicht bestaetigt): NAT-Switch anlegen (Learn: Set up a NAT network).'
}

$vhd = Join-Path $VmOrdner "$Name\$Name.vhdx"
if ($PSCmdlet.ShouldProcess($Name, 'VM mit vTPM anlegen')) {
    New-VM -Name $Name -Generation 2 -MemoryStartupBytes 4GB -NewVHDPath $vhd -NewVHDSizeBytes 80GB `
        -SwitchName 'Default Switch' -Path $VmOrdner | Out-Null
    Set-VMProcessor -VMName $Name -Count 2
    Set-VMKeyProtector -VMName $Name -NewLocalKeyProtector
    Enable-VMTPM -VMName $Name
    Add-VMDvdDrive -VMName $Name -Path $IsoPfad
    $dvd = Get-VMDvdDrive -VMName $Name
    Set-VMFirmware -VMName $Name -FirstBootDevice $dvd
}
Get-VM -Name $Name -ErrorAction SilentlyContinue | Get-VMNetworkAdapter | Select-Object VMName, SwitchName
