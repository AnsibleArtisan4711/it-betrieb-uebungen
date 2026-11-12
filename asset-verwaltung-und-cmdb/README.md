# Asset-Verwaltung und CMDB (P69)

Laborreihe mit GLPI (Open Source) auf Ubuntu 24.04 mit Apache, MariaDB und PHP sowie zwei Clients auf Hyper-V; Fallstudie Bergfeld Maschinenbau GmbH (`example.internal`). Acht Module mit je einer ausgearbeiteten Übung (Steckbrief, Lernziele, Voraussetzungen, Grundbegriffe, Aufgabe mit Zuordnung zu Lerneinheiten, Hinweise, Kontrollfragen, Musterlösung, Erweiterungen, Quellen). Gesamtumfang: 33,75 Stunden (45 Unterrichtseinheiten zu 45 Minuten, mit dem Faktor 0,75 umgerechnet).

> **Prüfstand, ehrlich:** **Kein Schritt in GLPI, Ubuntu, Hyper-V oder Windows wurde ausgeführt.** Real gerechnet wurden nur die Prüfskripte (Python). Die Voraussetzungen von GLPI sind gegen die Dokumentation geprüft; Menüpfade, Agent-Schritte und Importdialog sind es nicht. Offene Punkte: [`befehle-nicht-bestaetigt.md`](befehle-nicht-bestaetigt.md); Anmerkungen zum Lehrplan: [`lehrplan-korrekturen.md`](lehrplan-korrekturen.md).

## Umgebung

Hyper-V mit drei VMs (`asset-srv` Ubuntu 24.04 mit GLPI, `win-client` Windows 11, `lx-client` Linux) am privaten Switch `Private-Switch`; Adressen `192.168.110.10/24`, `.20/24`, `.30/24`, Name `asset.example.internal`. Details in Modul 02.

## Module

| Nr. | Modul | Zeit | Prüfstand |
|---|---|---|---|
| 01 | [Begriffe und Lebenszyklus](01-begriffe-und-lebenszyklus/) | 3,75 h | Entwurf, nicht erprobt |
| 02 | [Laboraufbau und Installation von GLPI](02-laboraufbau-und-installation-von-glpi/) | 5,25 h | gegen Dokumentation geprüft, nicht ausgeführt |
| 03 | [Datenmodell: Typen, Standorte, Beziehungen](03-datenmodell/) | 4,5 h | Entwurf, nicht erprobt |
| 04 | [Erfassung: manuell und per Import, Datenqualität](04-erfassung-und-datenqualitaet/) | 4,5 h | Prüfskript real ausgeführt, GLPI-Schritte nicht ausgeführt |
| 05 | [Automatische Inventarisierung](05-automatische-inventarisierung/) (Priorität 2) | 4,5 h | gegen Dokumentation (teilweise) geprüft, nicht ausgeführt |
| 06 | [Tickets, Berechtigungen und Verknüpfungen](06-tickets-und-berechtigungen/) | 3 h | Entwurf, nicht erprobt |
| 07 | [Berichte, Bestandsaufnahme und Kennzahlen](07-berichte-bestandsaufnahme-und-kennzahlen/) | 4,5 h | Rechnung real ausgeführt, GLPI-Schritte nicht ausgeführt |
| 08 | [Verantwortung, Datenschutz und Sicherung](08-verantwortung-datenschutz-und-sicherung/) | 3,75 h | gegen Dokumentation (teilweise) geprüft, nicht ausgeführt |

Summe 33,75 Stunden. 1 Modul mit Priorität 2 dient der Vertiefung; kein Pflichtmodul setzt es voraus.

## Aufbau eines Moduls

Ordner `NN-kurzname/` mit `README.md`, der Übung `NN.1-….md`, gegebenenfalls Beispieldaten und Vorlagen sowie `beispiele/` mit der echten Ausgabe der Rechenhilfen.

## Hinweise

- Alle Firmen, Personen, Adressen und Zahlen sind frei erfunden (Domänen nach RFC 2606, Adressen nach RFC 1918).
- Kennwörter und Token gehören nie in Dateien dieses Repositories (Ausnahme: gekennzeichnete Laborwerte).
- Keine Rechtsberatung; keine Zertifizierungsvorbereitung.

## Lizenz

- Code und Skripte: MIT, siehe [`LICENSE`](LICENSE)
- Texte: CC BY 4.0, siehe [`LICENSE-DOCS.md`](LICENSE-DOCS.md)
