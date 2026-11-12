<#
.SYNOPSIS
    Listet lauschende TCP-Ports mit Prozessnamen auf (Uebung 09.1, Teil 1). Nur lesen, aendert nichts.
.DESCRIPTION
    Laeuft auf den Windows-VMs (Windows PowerShell 5.1). Verwendet Get-NetTCPConnection -State Listen und Get-Process.
    Mit -Ausgabe wird zusaetzlich eine CSV geschrieben (Ordner muss existieren). Nicht auf Windows ausgefuehrt (nur Syntaxpruefung).
#>
[CmdletBinding()]
param(
    [string]$Ausgabe
)

$zeilen = Get-NetTCPConnection -State Listen | Sort-Object LocalPort | ForEach-Object {
    $p = Get-Process -Id $_.OwningProcess -ErrorAction SilentlyContinue
    [pscustomobject]@{
        Computer = $env:COMPUTERNAME
        Adresse  = $_.LocalAddress
        Port     = $_.LocalPort
        PID      = $_.OwningProcess
        Prozess  = if ($p) { $p.ProcessName } else { '(nicht lesbar)' }
    }
}
$zeilen | Format-Table -AutoSize
if ($Ausgabe) {
    $ordner = Split-Path -Parent $Ausgabe
    if (-not (Test-Path -LiteralPath $ordner)) { throw "Ordner $ordner fehlt." }
    $zeilen | Export-Csv -Path $Ausgabe -NoTypeInformation -Encoding UTF8
}
