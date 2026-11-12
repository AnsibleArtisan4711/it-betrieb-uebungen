# Weiterbildung IT-Systemtechnik (P72)

Übungsreihe zum Lehrplan **P72 – Weiterbildung IT-Systemtechnik**: zwölf Module mit je einer ausgearbeiteten Übung (Steckbrief, Lernziele, Voraussetzungen, Grundbegriffe, Aufgabe mit Zuordnung zu Lerneinheit und Praxisaufgabe, Hintergrund, Hinweise, Prüfbefehle und Kontrollfragen, Erweiterungen, Musterlösung, Aufräumen, Quellen), Skripten und Vorlagen. Gesamtumfang: 82,5 Stunden (110 Unterrichtseinheiten zu 45 Minuten, jeweils mit dem Faktor 0,75 umgerechnet).

> **Prüfstand, ehrlich:** **Kein Windows-, Hyper-V- oder Portalbefehl wurde ausgeführt.** Real ausgeführt wurden die Rechenhilfen (Python), die Bash-Skripte und Teile der Linux-Konfiguration in einem Container mit Ubuntu 24.04, einige PowerShell-Skripte nur in ihrer Logik unter PowerShell 7.4 auf Linux (Modul 10). Alle übrigen PowerShell-Skripte sind nur auf Syntax geprüft. Jedes Modul nennt seinen Stand im Warnhinweis. Offene Punkte: [`befehle-nicht-bestaetigt.md`](befehle-nicht-bestaetigt.md); Anmerkungen zum Lehrplan: [`lehrplan-korrekturen.md`](lehrplan-korrekturen.md).

## Laborumgebung

Hyper-V mit drei **privaten** Switches; der `Default Switch` nur in den Internetphasen (I-1 bis I-3). Alle Namen und Adressen sind Beispielwerte (Domäne `lab.example.internal`, NetBIOS `LAB`).

| Switch | Netz |
|---|---|
| `sw-lab-srv` | `192.168.50.0/24` |
| `sw-lab-cli` | `192.168.60.0/24` |
| `sw-lab-test` | Testnetz (Modul 2 und 9) |

| VM | Rolle | Adresse |
|---|---|---|
| `SRV-DC01` | Domänencontroller, DNS | `192.168.50.10` (kein Gateway, Route in `.60` über `.50.20`) |
| `SRV-FS01` | Dateiserver und Router zwischen den Netzen | `.50.20` und `.60.1` (`NIC-LAB`, `NIC-CLI`), `NIC-INET` für Phasen |
| `CL-W11-01` | Windows-Client, Domänenmitglied | `192.168.60.101`, Gateway `.60.1` |
| `LX-UBU01` | Ubuntu-Server | `192.168.50.30` |
| `CL-W11-02` | Cloud-Client (Modul 4), nicht Domänenmitglied | über `Default Switch` |

Prüfpunkte: `<VM>-M<Nr>-Start`, nur bei **ausgeschalteter** VM; das Labor wird nur gemeinsam zurückgesetzt. Ein Prüfpunkt ist keine Datensicherung (Modul 8).

**Cloud-Ausnahmen vom isolierten Labor:** Intune-Testmandant (30 Tage, Modul 4) und Azure Free Account (Guthaben 30 Tage, Modul 7, in Modul 9 weiterverwendet). Kosten 0 EUR innerhalb des Guthabens, Budget und Rückbau sind Pflicht; Zahlungskarte und Telefonnummer nur zur Überprüfung und nur mit deiner ausdrücklichen Zustimmung.

## Module

| Nr. | Modul | Zeit | Prüfstand |
|---|---|---|---|
| 01 | [Berufsbild und Spezialisierungslandkarte](01-berufsbild-und-spezialisierungslandkarte/) | 6 h | Recherche, keine Befehle |
| 02 | [Netzwerk, Protokolle und Infrastruktur](02-netzwerk-protokolle-und-infrastruktur/) | 6,75 h | Rechner real, PowerShell Syntax |
| 03 | [Windows Server, Active Directory und Hybrid Identity](03-windows-server-active-directory-und-hybrid-identity/) | 7,5 h | nur Syntax |
| 04 | [Modern Workplace und Endpoint Management](04-modern-workplace-und-endpoint-management/) | 7,5 h | Syntax, Auswertung mit Nachbildung getestet |
| 05 | [Linux-Server und Plattformbetrieb](05-linux-server-und-plattformbetrieb/) | 6,75 h | Linux teilweise real |
| 06 | [Virtualisierung, Storage und Plattformen](06-virtualisierung-storage-und-plattformen/) (Priorität 2) | 6,75 h | Rechner real, PowerShell Syntax |
| 07 | [Cloud Administration und Hybrid Platforms](07-cloud-administration-und-hybrid-platforms/) | 7,5 h | Rechner real, nichts im Portal |
| 08 | [Monitoring, Logging, Backup und Business Continuity](08-monitoring-logging-backup-und-business-continuity/) | 6,75 h | Rechner und Linux-Sicherung real |
| 09 | [Security, Hardening und IAM](09-security-hardening-und-iam/) | 7,5 h | Rechner und Linux-Skript real |
| 10 | [Automation, Scripting und IaC Grundlagen](10-automation-scripting-und-iac-grundlagen/) | 7,5 h | Bash und PowerShell-Logik real (PS 7 unter Linux) |
| 11 | [Troubleshooting, ITSM und Governance](11-troubleshooting-itsm-und-governance/) (Priorität 2) | 6 h | Vorlagen, nur Syntax |
| 12 | [Karrierepfade, Zertifikate und Spezialisierungen](12-karrierepfade-zertifikate-und-spezialisierungen/) | 6 h | Python-Hilfen real |

Summe 82,5 Stunden. Module mit Priorität 2 (6 und 11) dienen der Vertiefung; kein Pflichtmodul setzt sie voraus.

## Aufbau eines Moduls

Ordner `NN-kurzname/` mit `README.md`, der Übung `NN.1-….md`, den zugehörigen Skripten (`.ps1` mit `-WhatIf`, UTF-8 mit BOM; `.sh` mit `bash -n` geprüft; `.py` ohne Fremdpakete) und, wo Skripte real liefen, `beispiele/` mit den echten Ausgaben (Beispielwerte sind gekennzeichnet).

## Sicherheitshinweise

- Alles nur im isolierten Labor (private Switches). Cloud-Zugänge nur mit Testkonten, nie mit produktiven Konten oder Abonnements.
- Kennwörter, Schlüssel und Token werden nie in Dateien geschrieben; Skripte fragen sie interaktiv ab.
- Datenträger werden nur formatiert, wenn Zustand und Größe passen; Löschbefehle prüfen Pfade und unterstützen `-WhatIf`.
- Domäne `lab.example.internal` und alle Adressen sind Beispielwerte nach RFC 2606 bzw. RFC 1918.

## Lizenz

Code und Konfigurationen: MIT ([`LICENSE`](LICENSE)). Texte und Dokumentation: CC BY 4.0 ([`LICENSE-DOCS.md`](LICENSE-DOCS.md)).
