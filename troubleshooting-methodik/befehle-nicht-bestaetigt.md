# Befehle und Aussagen, die nicht bestätigt sind

Prüfliste für den ersten Durchlauf: Befund und Datum eintragen, danach den Hinweis in der Übung entfernen. Legende: **Q** = gegen Quelle gelesen; **L** = real in der Testumgebung ausgeführt (Python 3); **–** = weder noch.

| Modul | Aussage oder Befehl | Status | Was zu prüfen ist |
|---|---|---|---|
| 04, 05 | Optionen und Ausgabeformate von `ping`, `tracert`, `nslookup`, `ipconfig`, `ip`, `journalctl`, `systemctl` | – | In der Hilfe des Systems prüfen |
| 04 | `Test-NetConnection`: Parameter `ComputerName`, `Port`, `InformationLevel` | Q (Learn-Seite gelesen) | Ausgabefelder im Labor prüfen |
| 05 | `Get-WinEvent`: Schlüssel von `FilterHashtable`, Level-Werte | Q (Learn-Seiten gelesen) | Schreibweise der Zeitwerte im Labor prüfen |
| 02, 03, 04, 05 | Hilfsskripte `ereignisse_zeitleiste.py`, `eingrenzen.py`, `traceroute_auswertung.py`, `protokoll_pruefen.py` | L (Python) | – |
| 04 | Format der Beispieldateien im Stil von `tracert` | – | gegen echte Ausgabe vergleichen |
| 06 | Beispielbefehle (`systemctl status`) und Fehlerbilder | – | im Labor prüfen |
| 08 | Laborvariante mit vorab eingebauten Fehlern | – | Labor aufbauen und erproben |

Die Liste ist aus den Warnhinweisen der Module zusammengestellt und **nicht vollständig**; maßgeblich ist der Text der jeweiligen Übung.
