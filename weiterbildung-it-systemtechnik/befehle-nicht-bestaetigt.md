# Befehle und Aussagen, die nicht bestätigt sind

Diese Liste sammelt, was in den Übungen **nicht** durch einen Lauf oder durch Microsoft Learn belegt ist. Sie dient als Prüfliste für den ersten Durchlauf im Labor: Trage Befund und Datum ein und entferne danach den Hinweis in der Übung. Sie ist aus den Warnhinweisen der Module zusammengestellt und **nicht vollständig**; maßgeblich ist der Text in der jeweiligen Übung („nicht bestätigt“).

Legende: **Q** = gegen Quelle (Microsoft Learn) geprüft, nicht ausgeführt; **L** = real in der Linux-Testumgebung ausgeführt (Ubuntu 24.04 im Container); **P7** = Logik unter PowerShell 7.4 auf Linux ausgeführt; **–** = weder noch.

## Grundsätzlich

- **Kein Windows-Befehl wurde ausgeführt, Hyper-V wurde nicht verwendet, kein Portal wurde geöffnet.** Alle PowerShell-Skripte wurden nur auf Syntax geprüft (PowerShell 7.4.6 Parser); die Cmdlet-Parameter sind teils gegen Microsoft Learn geprüft.
- Die Testumgebung hatte keinen IPv6-Kernel und kein `systemd` als PID 1: `systemctl`, `ufw enable` und das Netz zwischen mehreren VMs wurden nicht real geprüft.
- Beispielwerte in Rechenhilfen (Preise, Minutenwerte, Bewertungen) sind **erfunden** und in den Ausgaben gekennzeichnet.

## Tabelle

| Modul | Aussage oder Befehl | Status | Was im Labor zu prüfen ist |
|---|---|---|---|
| 1 | Alle Aussagen zu Markt, Gehältern, Zertifikaten | – | Kommen aus deiner Recherche, nicht aus dem Kurs |
| 2 | Subnetz-Rechenwerte | L | Stimmen mit den Kontrollwerten des Lehrplans überein |
| 2 | Zeigt ein **privater** Hyper-V-Switch die VLAN-Trennung (Teil 5)? | – | Beobachten und notieren |
| 2 | Beobachtung zu Fehler (b): ist `192.168.50.20` trotzdem erreichbar? | – | Beobachten |
| 2 | Namen der Echo-/Ping-Firewallregeln (`Get-NetFirewallRule … -like '*Echo*'`) | – | `Get-NetFirewallRule` auf dem System prüfen |
| 3 | `New-ADOrganizationalUnit`, `New-ADUser`, `New-ADGroup`, `Add-ADGroupMember`, `New-GPO`, `New-GPLink` | – | Mit `Get-Help` prüfen, WhatIf |
| 3 | `Install-ADDSForest`, GPO-Reihenfolge, `Install-WindowsFeature AD-Domain-Services` | Q | Ausgabe notieren |
| 3 | `Get-ADPrincipalGroupMembership`, `wusa /uninstall /kb:<Nummer>`, Menüpfade | – | Prüfen |
| 3 | Kann `lab.example.internal` in Entra verifiziert werden? | – | Vermutlich nein (nicht routbar), prüfen |
| 4 | Alle Portal-Menüpfade und Einstellungsnamen (Intune, Entra) | – | Beim Durchlauf mit Screenshot-Beschreibung festhalten |
| 4 | `dsregcmd /status`-Auswertung | Muster mit Nachbildung geprüft | Mit echter Ausgabe wiederholen |
| 4 | `manage-bde -status`, `Get-MpComputerStatus`-Felder | – | Ausgabefelder prüfen |
| 4 | Verfügbarkeit von Store-Apps im Katalog | – | Alternative App wählen |
| 5 | `05.1-gruppe-und-rechte.sh`, Setgid, `systemd-analyze verify`, `sshd -t/-T`, `netplan generate`, `ufw` Trockenlauf | L | Auf `LX-UBU01` wiederholen |
| 5 | `ufw enable`, `systemctl start/status`, `journalctl`, SSH über das Netz | – | Auf `LX-UBU01` prüfen |
| 5 | Ubuntu-Installation ohne Internet; OpenSSH-Client unter Windows vorinstalliert | – | Prüfen |
| 6 | `Export-VM`, `Import-VM -Copy -GenerateNewId`, `Set-VM -CheckpointType`, `Remove-VMCheckpoint`, `.avhdx` nie direkt löschen | Q | Ausgabe notieren |
| 6 | `Rename-VM`, `Set-VMMemory`-Parameter, `Connect-VMNetworkAdapter`, Python im Gast | – | `Get-Help` prüfen |
| 6 | Überbuchungsfaktor | L | 4 × 8 GB auf 24 GB = 1,33 (ohne Reserve), mit 4 GB Reserve 1,60 |
| 7 | Azure Free Account, Budget, RBAC, Policy „Allowed locations“, Ressourcengruppe löschen | Q | Betrag des Guthabens vor Anmeldung prüfen |
| 7 | Portalbezeichnungen, VM-Größen, Preise, Dauer der Wirksamkeit einer Richtlinie | – | Beobachten |
| 7 | Bleibt der Entra-Mandant nach Ablauf des Guthabens bestehen? | – | Prüfen (sonst Fallstudie in Modul 9) |
| 7 | Überlappungsprüfung | L | Stimmt mit dem Lehrplan überein |
| 8 | `Install-WindowsFeature Windows-Server-Backup`, `wbadmin start backup`, `get versions`, `start recovery`, `start systemstatebackup` | Q | Ausgabe notieren |
| 8 | Reihenfolge der `wbadmin start recovery`-Parameter, `-recursive` | – | `wbadmin start recovery /?` |
| 8 | Wiederholungsdauer des Aufgabentriggers, WinRM/DNS-Voraussetzungen für `Invoke-Command` | – | Prüfen |
| 8 | Linux-Sicherung mit `tar`, `sha256sum`, Teil-Restore, Negativtests | L | Auf `LX-UBU01` wiederholen |
| 8 | Rechenhilfe (Tage bis Grenze, RTO) | L | – |
| 9 | `Get-HotFix`, `RSAT-AD-PowerShell`, Name des Delegierungsrechts, `Protected Users`-Wirkung (NTLM) | – | Beobachten |
| 9 | `Set-NetFirewallRule -RemoteAddress`, `New-SmbShare -FullAccess Everyone` | – | `Get-Help` und Test |
| 9 | Name der Auditunterkategorie (sprachabhängig), Ereignis-ID 4625 | – | `auditpol /list /subcategory:*` |
| 9 | Sicherheitsstandards (Menüpfad), Entra ID Free nach Ablauf | – | Beobachten |
| 9 | `ss -tulpn`-Skript, Patch-Reihenfolge nach Übungsregel | L | – |
| 10 | `diskcheck.sh`; Löschskript mit Pfadgrenze; Hash-Freigabe | L / P7 | Auf Windows PowerShell 5.1 wiederholen |
| 10 | AD-Cmdlets inkl. `Remove-ADOrganizationalUnit -Recursive`, `icacls` und `New-SmbShare`-Parameter | – | `-WhatIf` und Test |
| 10 | DSC-Konfiguration (`Start-DscConfiguration`, `Get-DscConfiguration`) | – | Nur auf Windows prüfbar |
| 11 | Dienstname `DNS`, `sc.exe failure`-Syntax, Wiederanlauf nach `Stop-Service` | – | Beobachten |
| 11 | `Get-ADComputer … -Properties IPv4Address` | – | Prüfen |
| 12 | Alle Zertifikatsfakten | – | Nur von Herstellerseiten, mit Abrufdatum; MS-102-Status prüfen |
| 12 | Gewichtungsrechner, Veröffentlichungs-Check | L | Heuristik, ersetzt Durchsicht nicht |
