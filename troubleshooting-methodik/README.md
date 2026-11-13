# Troubleshooting-Methodik (P50)

Übungen zur systematischen Fehlersuche in Windows und Linux (Informationen sammeln, Hypothesen, Eingrenzen, Netzwerkwerkzeuge, Protokolle, Fehlerbilder, Dokumentation) mit der fiktiven Bergfried Metallbau GmbH (Labornetz `10.80.0.0/24`, Namen unter `lab.internal`). Acht Module mit je einer ausgearbeiteten Übung (Steckbrief, Lernziele, Voraussetzungen, Grundbegriffe, Aufgabe mit Zuordnung zu Lerneinheiten, Hinweise, Kontrollfragen, Musterlösung, Erweiterungen, Quellen). Gesamtumfang: 35,25 Stunden (47 Unterrichtseinheiten zu 45 Minuten, mit dem Faktor 0,75 umgerechnet).

> **Prüfstand, ehrlich:** **Es wurde nichts installiert und kein Labor aufgebaut.** Real ausgeführt wurden nur die Hilfsskripte (`ereignisse_zeitleiste.py`, `eingrenzen.py`, `traceroute_auswertung.py`, `protokoll_pruefen.py`; Python 3, ohne Fremdpakete); ihre Ausgaben stehen in `beispiele/`. **Befehle wie `ping`, `tracert`, `nslookup`, `journalctl` und `systemctl` wurden nicht ausgeführt**; von `Get-WinEvent` und `Test-NetConnection` sind nur Schlüssel bzw. Parameter auf Microsoft Learn gelesen. Offene Punkte: [`befehle-nicht-bestaetigt.md`](befehle-nicht-bestaetigt.md); Anmerkungen zum Lehrplan: [`lehrplan-korrekturen.md`](lehrplan-korrekturen.md).

## Umgebung

Ein **technisches Labor** (1× Windows-Server-VM, 1× Linux-Server-VM, 1× Windows-11-Client-VM, privater Hyper-V-Switch) ist **nur für Modul 08** (Laborvariante) vorgesehen und wurde **nicht aufgebaut**. Alle Module lassen sich mit den mitgelieferten, erfundenen Beispieldateien ohne Labor lösen; die Rechenhilfen brauchen Python 3 ohne Zusatzpakete. Beispieldaten liegen in den Modulordnern; wo ein Python-Skript dabei ist, steht die echte Ausgabe in `beispiele/`.

## Module

| Nr. | Modul | Zeit | Prüfstand |
|---|---|---|---|
| 01 | [Systematisches Vorgehen bei der Fehlersuche](01-systematisches-vorgehen/) | 3,75 h | Entwurf, nicht erprobt |
| 02 | [Informationen sammeln und Zeitleiste erstellen](02-informationen-sammeln/) | 4,5 h | Skript ausgeführt, Rest Entwurf |
| 03 | [Hypothesen bilden und Fehler eingrenzen](03-hypothesen-und-eingrenzen/) | 4,5 h | Skript ausgeführt, Rest Entwurf |
| 04 | [Werkzeuge für Netzwerkfehler](04-netzwerkwerkzeuge/) | 5,25 h | Skript ausgeführt, Befehle nicht erprobt |
| 05 | [Protokolle und Ereignisanzeige auswerten](05-protokolle-und-ereignisse/) | 5,25 h | Skript ausgeführt, Befehle nicht erprobt |
| 06 | [Typische Fehlerbilder in Netzwerk, Server und Client](06-typische-fehlerbilder/) | 5,25 h | Entwurf, nicht erprobt |
| 07 | [Dokumentieren und mit Anwendern kommunizieren](07-dokumentieren-und-kommunizieren/) | 3,75 h | Entwurf, nicht erprobt |
| 08 | [Übungsfälle: Fehler suchen im Labor](08-uebungsfaelle/) (Priorität 2) | 3 h | Entwurf, nicht erprobt |

Summe 35,25 Stunden. 1 Modul mit Priorität 2 dient der Vertiefung; kein Pflichtmodul setzt es voraus.

## Aufbau eines Moduls

Ordner `NN-kurzname/` mit `README.md`, der Übung `NN.1-….md`, gegebenenfalls Beispieldaten und Skripten sowie `beispiele/` mit der echten Ausgabe der Hilfsskripte.

## Hinweise

- Alle Firmen, Personen, Adressen, Protokolle und Zahlen sind frei erfunden (Domänen nach RFC 2606, Adressen nach RFC 1918).
- Kennwörter und Token gehören nie in Dateien dieses Repositories; Laborwerte sind keine Zugangsdaten.
- Keine Zertifizierungsvorbereitung und keine Rechtsberatung.

## Lizenz

- Code und Skripte: MIT, siehe [`LICENSE`](LICENSE)
- Texte: CC BY 4.0, siehe [`LICENSE-DOCS.md`](LICENSE-DOCS.md)
