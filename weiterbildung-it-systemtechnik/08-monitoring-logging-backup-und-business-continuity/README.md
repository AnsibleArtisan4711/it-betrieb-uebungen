# 08 Monitoring, Logging, Backup und Business Continuity

Übung **08.1**: Prüfskript als geplante Aufgabe, zentrale Logauswertung, Kapazitätstrend, Dateisicherung mit `wbadmin` und Hash-Vergleich, AD-Systemstatus (ohne Wiederherstellung), Linux-Sicherung, RTO/RPO, Runbook, Fehlerbilder, Rückbau der Zusatzdatenträger. Geschätzte Zeit: 6,75 Stunden (Lehrplan: 9 UE).

> Rechenhilfe und Linux-Skript real ausgeführt; Windows-Teile nur auf Syntax geprüft. `wbadmin`-Parameterdetails *nicht bestätigt*.

| Datei | Zweck |
|---|---|
| `08.1-monitoring-logging-backup-und-business-continuity.md` | Die Übung |
| `08.1-check-lab.ps1` | Speicherprüfung mit Ereignisprotokoll-Warnung |
| `08.1-task-registrieren.ps1` | Geplante Aufgabe anlegen oder entfernen |
| `08.1-trend-messen.ps1` | Zehn Messwerte in eine CSV |
| `08.1-logs-sammeln.ps1` | Ereignisse beider Server und Linux-Journal holen |
| `08.1-backup-vorbereiten.ps1` | Feature, `F:`, Testdateien, Hashliste |
| `08.1-backup-und-restore.ps1` | Sichern, Löschen, Wiederherstellen, Vergleichen |
| `08.1-systemstatus-sichern.ps1` | AD-Systemstatus nach `G:` |
| `08.1-zusatzplatten-entfernen.ps1` | Zusatzdatenträger trennen und löschen (Pfadprüfung) |
| `08.1-linux-sicherung.sh` | `tar`, SHA-256, Teil-Restore (real getestet) |
| `08.1-kapazitaet-und-rto.py` | Tage bis Grenze, Messwerte, RTO (real ausgeführt) |
| `08.1-vorlagen.md` | Tabellen, Runbook, Fehlerbilder |
| `beispiele/` | Echte Ausgaben (Beispielwerte gekennzeichnet) |
