# 10 Automation, Scripting und Infrastructure as Code Grundlagen

Übung **10.1**: Skriptkandidaten bewerten, PowerShell- und Bash-Grundlagen, `cron`, CSV/JSON-Bericht, abgesichertes Löschskript, Benutzer aus CSV (idempotent), DSC gegen Skript, Skript-Governance mit Freigabeliste und Hashprüfung. Geschätzte Zeit: 7,5 Stunden (Lehrplan: 10 UE).

> Bash-Skript, Löschskript und Hashprüfung real getestet (die PowerShell-Skripte unter PowerShell 7 auf Linux, nicht auf Windows PowerShell 5.1). AD-, DSC- und Freigabeteile nur auf Syntax geprüft, *nicht bestätigt*.

| Datei | Zweck |
|---|---|
| `10.1-automation-scripting-und-iac-grundlagen.md` | Die Übung |
| `10.1-diskcheck.sh` | Belegung von `/` prüfen (real getestet) |
| `10.1-bericht.ps1` | Speicher je Laufwerk als CSV und JSON |
| `10.1-Remove-OldFiles.ps1` | Abgesichertes Löschen (Pfadgrenze, Validierung, `-WhatIf`) |
| `10.1-users.csv` | Beispielkonten `skript-user01` bis `05` |
| `10.1-benutzer-aus-csv.ps1` | Konten anlegen, idempotent, mit Rückbau |
| `10.1-LabBasis.ps1` | DSC-Konfiguration mit Anwenden und Aufräumen |
| `10.1-skript-governance-einrichten.ps1` | Freigabe `Skripte$` einrichten oder entfernen |
| `10.1-skript-freigeben.ps1` | Skript mit Hash in die Freigabeliste eintragen |
| `10.1-start-geprueft.ps1` | Skript nur bei passendem Hash starten |
| `10.1-vorlagen.md` | Tabellen, Skriptkopf, Freigaberegeln |
| `beispiele/` | Echte Testläufe |
