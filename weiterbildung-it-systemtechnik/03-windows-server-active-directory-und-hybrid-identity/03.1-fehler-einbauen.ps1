<#
.SYNOPSIS
    KURSLEITER: baut die drei Domaenenfehler aus Modul 3, Aufgabe 8 ein oder macht sie rueckgaengig.
.DESCRIPTION
      a  auf CL-W11-01: DNS-Server auf 192.168.50.99 (falsch)
      b  auf SRV-DC01 : Verknuepfung von GPO-Lab-Client von OU=Computer nach OU=Benutzer verlegen
      c  auf SRV-DC01 : lab-user01 aus grp-projekt entfernen
      zurueck-a / zurueck-b / zurueck-c  stellen den Sollzustand wieder her
    Laeuft jeweils auf dem genannten Rechner (Windows PowerShell 5.1, Administrator). Mit -WhatIf wird
    nichts geaendert. Nicht auf Windows ausgefuehrt (nur Syntaxpruefung).
#>
[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [Parameter(Mandatory)][ValidateSet('a', 'b', 'c', 'zurueck-a', 'zurueck-b', 'zurueck-c')][string]$Fehler
)

function Test-Rechner([string]$Name) {
    if ($env:COMPUTERNAME -ne $Name) { throw "Dieser Fehler gehoert auf $Name, nicht auf $env:COMPUTERNAME." }
}
$basis = 'DC=lab,DC=example,DC=internal'

switch ($Fehler) {
    'a' { Test-Rechner 'CL-W11-01'
          if ($PSCmdlet.ShouldProcess('NIC-CLI', 'DNS 192.168.50.99')) { Set-DnsClientServerAddress -InterfaceAlias 'NIC-CLI' -ServerAddresses '192.168.50.99' } }
    'zurueck-a' { Test-Rechner 'CL-W11-01'
          if ($PSCmdlet.ShouldProcess('NIC-CLI', 'DNS 192.168.50.10')) { Set-DnsClientServerAddress -InterfaceAlias 'NIC-CLI' -ServerAddresses '192.168.50.10' } }
    'b' { Test-Rechner 'SRV-DC01'; Import-Module GroupPolicy
          if ($PSCmdlet.ShouldProcess('GPO-Lab-Client', 'Verknuepfung auf OU=Benutzer verlegen')) {
              Remove-GPLink -Name 'GPO-Lab-Client' -Target "OU=Computer,OU=LAB,$basis" | Out-Null
              New-GPLink    -Name 'GPO-Lab-Client' -Target "OU=Benutzer,OU=LAB,$basis" | Out-Null } }
    'zurueck-b' { Test-Rechner 'SRV-DC01'; Import-Module GroupPolicy
          if ($PSCmdlet.ShouldProcess('GPO-Lab-Client', 'Verknuepfung auf OU=Computer zuruecklegen')) {
              Remove-GPLink -Name 'GPO-Lab-Client' -Target "OU=Benutzer,OU=LAB,$basis" -ErrorAction SilentlyContinue | Out-Null
              New-GPLink    -Name 'GPO-Lab-Client' -Target "OU=Computer,OU=LAB,$basis" | Out-Null } }
    'c' { Test-Rechner 'SRV-DC01'
          if ($PSCmdlet.ShouldProcess('grp-projekt', 'lab-user01 entfernen')) { Remove-ADGroupMember -Identity 'grp-projekt' -Members 'lab-user01' -Confirm:$false } }
    'zurueck-c' { Test-Rechner 'SRV-DC01'
          if ($PSCmdlet.ShouldProcess('grp-projekt', 'lab-user01 hinzufuegen')) { Add-ADGroupMember -Identity 'grp-projekt' -Members 'lab-user01' } }
}
