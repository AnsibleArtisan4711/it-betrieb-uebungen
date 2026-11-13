# Projektmanagement für Administratoren (P51)

Fallstudien-, Rechen- und Dokumentationsaufgaben zum Projektmanagement in der IT-Administration (klassisch und agil) mit der fiktiven Tannenhof Logistik GmbH (`tannenhof.example.com`, Netz `10.90.0.0/24`), ohne technisches Labor. Acht Module mit je einer ausgearbeiteten Übung (Steckbrief, Lernziele, Voraussetzungen, Grundbegriffe, Aufgabe mit Zuordnung zu Lerneinheiten, Hinweise, Kontrollfragen, Musterlösung, Erweiterungen, Quellen). Gesamtumfang: 34,5 Stunden (46 Unterrichtseinheiten zu 45 Minuten, mit dem Faktor 0,75 umgerechnet).

> **Prüfstand, ehrlich:** **Es wurde nichts installiert.** Real ausgeführt wurden nur die Rechenhilfen (`kritischer_pfad.py`, `aufwand.py`; Python 3, ohne Fremdpakete); ihre Ausgaben stehen in `beispiele/`. **Alle Methodenaussagen sind Fachwissen und nicht gegen Normen oder Leitfäden geprüft**; der Scrum Guide wurde nicht abgerufen. Offene Punkte: [`befehle-nicht-bestaetigt.md`](befehle-nicht-bestaetigt.md); Anmerkungen zum Lehrplan: [`lehrplan-korrekturen.md`](lehrplan-korrekturen.md).

## Umgebung

Es gibt **kein technisches Labor**: keine VMs, keine Installation. Benötigt werden nur Textverarbeitung und Tabellenkalkulation (oder Papier); die Rechenhilfen brauchen Python 3 ohne Zusatzpakete. Beispieldaten liegen in den Modulordnern; wo ein Python-Skript dabei ist, steht die echte Ausgabe in `beispiele/`.

## Module

| Nr. | Modul | Zeit | Prüfstand |
|---|---|---|---|
| 01 | [Projektgrundlagen und Projektphasen](01-projektgrundlagen-und-phasen/) | 3,75 h | Entwurf, nicht erprobt |
| 02 | [Anforderungen erfassen und Projektauftrag schreiben](02-anforderungen-und-projektauftrag/) | 4,5 h | Entwurf, nicht erprobt |
| 03 | [Planung: Strukturplan, Ablauf und kritischer Pfad](03-planung-und-kritischer-pfad/) | 5,25 h | Skript ausgeführt, Rest Entwurf |
| 04 | [Aufwandsschätzung und Budget](04-aufwandsschaetzung-und-budget/) | 4,5 h | Skript ausgeführt, Rest Entwurf |
| 05 | [Risiken und Änderungen steuern](05-risiken-und-aenderungen/) | 3,75 h | Entwurf, nicht erprobt |
| 06 | [Klassisch, agil und hybrid: Methoden im Überblick](06-klassisch-agil-hybrid/) | 4,5 h | Entwurf, nicht erprobt |
| 07 | [Kommunikation, Abnahme, Übergabe und Dokumentation](07-kommunikation-abnahme-uebergabe/) | 4,5 h | Entwurf, nicht erprobt |
| 08 | [Fallbeispiele: Server-Migration und Client-Rollout](08-fallbeispiele/) (Priorität 2) | 3,75 h | Entwurf, nicht erprobt |

Summe 34,5 Stunden. 1 Modul mit Priorität 2 dient der Vertiefung; kein Pflichtmodul setzt es voraus.

## Aufbau eines Moduls

Ordner `NN-kurzname/` mit `README.md`, der Übung `NN.1-….md`, gegebenenfalls Beispieldaten und Skripten sowie `beispiele/` mit der echten Ausgabe der Hilfsskripte.

## Hinweise

- Alle Firmen, Personen, Adressen, Protokolle und Zahlen sind frei erfunden (Domänen nach RFC 2606, Adressen nach RFC 1918).
- Kennwörter und Token gehören nie in Dateien dieses Repositories; Laborwerte sind keine Zugangsdaten.
- Keine Zertifizierungsvorbereitung und keine Rechtsberatung.

## Lizenz

- Code und Skripte: MIT, siehe [`LICENSE`](LICENSE)
- Texte: CC BY 4.0, siehe [`LICENSE-DOCS.md`](LICENSE-DOCS.md)
