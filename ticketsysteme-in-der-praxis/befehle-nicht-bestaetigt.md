# Befehle und Aussagen, die nicht bestätigt sind

Prüfliste für den ersten Durchlauf: Befund und Datum eintragen, danach den Hinweis in der Übung entfernen. Legende: **Q** = gegen Quelle geprüft, nicht ausgeführt; **L** = real in der Testumgebung ausgeführt (Python 3); **–** = weder noch.

| Modul | Aussage oder Befehl | Status | Was zu prüfen ist |
|---|---|---|---|
| 02 | Wizard-Schritte von Zammad; ob `ingest-attachment` bei der Elasticsearch-Version nötig ist | – | Beim ersten Lauf dokumentieren |
| 03 | Ob Kunden im Formular die Gruppe wählen können; ob ein Benutzer zugleich Agent und Customer sein darf | – | Im Labor ausprobieren |
| 04 | Fristrechnung außerhalb der Geschäftszeit | L (Python, Rechenbeweis) | Anzeige in Zammad vergleichen; Feiertage |
| 06 | E-Mail-Kanal: Verifizierungsmail; Verhalten bei Antwort auf geschlossenes Ticket | – | Beim ersten Lauf beobachten |
| 06 | Mailpit-Einheiten | Q (Unit-Syntax laut Lehrplan geprüft, nicht gestartet) | Dienste im Labor starten |
| 07 | Zeitkriterium „seit letzter Aktualisierung“ im Scheduler | – | Im Labor prüfen |
| 08 | Menüführung Reporting und Token-Verwaltung; Felder der Ticket-API | – | Im Labor prüfen |
| alle | Hyper-V-Schritte, Netplan, Windows-Schritte, PowerShell-Beispiele | – | nicht ausgeführt |

Die Liste ist aus den Warnhinweisen der Module zusammengestellt und **nicht vollständig**; maßgeblich ist der Text der jeweiligen Übung („nicht bestätigt“).
