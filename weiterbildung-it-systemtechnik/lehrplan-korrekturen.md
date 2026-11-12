# Korrekturen und Anmerkungen zum Lehrplan P72

Beim Ausarbeiten der Übungen sind Punkte aufgefallen, die im Lehrplan `P72 – Weiterbildung IT-Systemtechnik` geändert oder überprüft werden sollten. Der Lehrplan selbst wurde **nicht** verändert. „Bestätigt“ heißt: in der Testumgebung (Ubuntu 24.04 im Container, PowerShell 7.4 unter Linux) real beobachtet; Windows wurde nicht geprüft.

| Nr. | Modul | Stelle im Lehrplan | Befund | Vorschlag |
|---|---|---|---|---|
| 1 | 5 | SSH-Härtung mit Drop-in-Datei | Bei `sshd` gilt für die meisten Schlüsselwörter der **erste** gelesene Wert. Ein Drop-in mit Namen `10-…` überschreibt `50-cloud-init.conf`, ein Name mit höherer Nummer nicht (bestätigt mit `sshd -T`). | Dateinamen des Drop-ins mit niedriger Nummer vorschreiben und die Prüfung mit `sshd -T` ergänzen. |
| 2 | 5 | `ssh`-Dienst neu laden | Ob Ubuntu 24.04 `ssh` per Socket-Aktivierung startet und ob `systemctl reload ssh` genügt, ist nicht bestätigt. | Als Prüfauftrag formulieren (`systemctl status ssh`, `ss -tlnp`). |
| 3 | 6 | Prüfpunkte wiederherstellen | Parameter von `Restore-VMCheckpoint` und Verhalten bei laufender VM sind nicht bestätigt. | Wiederherstellung nur bei ausgeschalteter VM vorschreiben, Cmdlet prüfen. |
| 4 | 8 | Aufgabe 7: „Betrieb, der 4 Stunden Ausfall verträgt“ | Die 4 Stunden betreffen das **RTO** (erlaubter Ausfall), nicht das RPO (Datenverlust). Das RPO folgt aus dem Sicherungsintervall (24 h) und ist eine getrennte Entscheidung. | Aufgabe in zwei Fragen teilen: RTO gegen 4 h, RPO gegen den tragbaren Datenverlust. |
| 5 | 8 | `wbadmin start recovery` | Reihenfolge der Parameter und Option `-recursive` sind im Lehrplan als nicht bestätigt markiert; die Wiederherstellung ganzer Ordner ist damit offen. | Beim ersten Lauf Ausgabe von `wbadmin start recovery /?` ergänzen. |
| 6 | 9 | Aufgabe 7: `auditpol … /subcategory:"Logon"` | Die Namen der Unterkategorien sind **sprachabhängig** (deutsches System: andere Bezeichnung). | Vor dem Setzen `auditpol /list /subcategory:*` ausführen und den Namen übernehmen. |
| 7 | 9 | Aufgabe 2: Reihenfolge B und C | Die Reihenfolge von B (hoch, intern) und C (mittel, Internet) hängt von der Gewichtung ab; die Übungsregel (Ausnutzung, Erreichbarkeit, Schwere) ergibt C vor B. | Wie im Lehrplan: Begründung bewerten, nicht die Reihenfolge. |
| 8 | 10 | Aufgabe 5: Löschskript im „Ordner mit angelegten Beispieldateien“ | Eine strenge Pfadgrenze („unterhalb von `C:\Skripte\Test`“) lehnt den Testordner selbst ab; Beispieldateien müssen in einem **Unterordner** liegen (bestätigt). | Aufgabe um „Unterordner `C:\Skripte\Test\dateien`“ ergänzen. |
| 9 | 10 | Aufgabe 7: DSC-Konfiguration | Das Schlüsselwort `Configuration` lässt sich unter Linux nicht auf Syntax prüfen (fehlender DSC-Schema-Speicher). | Hinweis „nur auf Windows prüfbar“ ergänzen. |
| 10 | 11 | Aufgabe 4: Neustart nach `Stop-Service` | Ob ein manuelles Stoppen die Wiederherstellungsaktionen auslöst, ist nicht bestätigt (die Aktionen sind für unerwartetes Beenden gedacht). | Als Beobachtungsaufgabe formulieren; alternativ den Prozess beenden (nach Prüfung). |
| 11 | 3 | Hybrid-Identität: eigener Domänenname | `lab.example.internal` lässt sich vermutlich nicht als verifizierte Domäne in Entra ID anlegen (nicht bestätigt). | Aufgabe auf Konzepte beschränken oder `<name>.onmicrosoft.com` verwenden. |
| 12 | 2, 4–7 | Cmdlets ohne Learn-Beleg | `Rename-NetAdapter`, `Set-VMMemory`, `Connect-VMNetworkAdapter` und ähnliche Aufrufe sind im Lehrplan teils ohne Beleg. | Beim ersten Durchlauf mit `Get-Help` prüfen und Ergebnis in `befehle-nicht-bestaetigt.md` eintragen. |
| 13 | alle | Zeitplan | 110 UE zu 45 Minuten entsprechen 82,5 Stunden; die Laboraufgaben können je nach Vorwissen länger dauern, auch Installation der Betriebssysteme und Cloud-Registrierung liegen außerhalb der UE. | Keine Änderung nötig; Hinweis im Lehrplan bleibt. |

Weitere Hinweise zu nicht bestätigten Aussagen: [`befehle-nicht-bestaetigt.md`](befehle-nicht-bestaetigt.md).
