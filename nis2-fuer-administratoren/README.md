# NIS2 für Administratoren (P48)

Fallstudien- und Rechenaufgaben zu NIS-2-Richtlinie und NISG 2026 für Administratoren mit der fiktiven Donauwerk Fertigungs GmbH (`donauwerk.example.com`, Netz `10.60.0.0/22`), ohne technisches Labor. Acht Module mit je einer ausgearbeiteten Übung (Steckbrief, Lernziele, Voraussetzungen, Grundbegriffe, Aufgabe mit Zuordnung zu Lerneinheiten, Hinweise, Kontrollfragen, Musterlösung, Erweiterungen, Quellen). Gesamtumfang: 34,5 Stunden (46 Unterrichtseinheiten zu 45 Minuten, mit dem Faktor 0,75 umgerechnet).

> **Prüfstand, ehrlich:** **Es wurde nichts installiert.** Real ausgeführt wurden nur die Rechenhilfen (`einstufung.py`, `risikomatrix.py`, `meldefristen.py`; Python 3, ohne Fremdpakete); ihre Ausgaben stehen in `beispiele/`. **Weder der Wortlaut der NIS-2-Richtlinie auf EUR-Lex noch das NISG 2026 im RIS wurden gelesen.** Grundlage sind Wiedergaben von Art. 21 und 23 auf Drittseiten und die Sekundärquelle Austrian Standards (Seite ohne Datum, abgerufen am 13.11.2026), deren Fristen sich teilweise widersprechen. Kein Rechtsrat. Offene Punkte: [`befehle-nicht-bestaetigt.md`](befehle-nicht-bestaetigt.md); Anmerkungen zum Lehrplan: [`lehrplan-korrekturen.md`](lehrplan-korrekturen.md).

## Umgebung

Es gibt **kein technisches Labor**: keine VMs, keine Installation. Benötigt werden nur Textverarbeitung und Tabellenkalkulation (oder Papier); die Rechenhilfen brauchen Python 3 ohne Zusatzpakete. Beispieldaten liegen in den Modulordnern; wo ein Python-Skript dabei ist, steht die echte Ausgabe in `beispiele/`.

## Module

| Nr. | Modul | Zeit | Prüfstand |
|---|---|---|---|
| 01 | [Grundlagen und Rechtsrahmen](01-grundlagen-und-rechtsrahmen/) | 3,75 h | Entwurf, nicht erprobt; Stand der Umsetzung aus Sekundärquelle |
| 02 | [Anwendungsbereich und Einstufung](02-anwendungsbereich-und-einstufung/) | 4,5 h | Skript real ausgeführt, Kursregel nicht am Gesetz geprüft |
| 03 | [Pflichten im Überblick und Leitungsorgane](03-pflichten-und-leitungsorgane/) | 3,75 h | Entwurf, nicht erprobt |
| 04 | [Risikomanagementmaßnahmen, Teil 1: Risiko, Vorfälle, Betriebskontinuität](04-risikomanagement-teil-1/) | 5,25 h | Skript real ausgeführt, Maßnahmenliste nach Wiedergabe gelesen |
| 05 | [Risikomanagementmaßnahmen, Teil 2: Härtung, Zugriff, Schwachstellen, Kryptografie](05-risikomanagement-teil-2/) | 4,5 h | Entwurf, nicht erprobt |
| 06 | [Meldepflichten bei erheblichen Vorfällen](06-meldepflichten-bei-erheblichen-vorfaellen/) | 4,5 h | Skript real ausgeführt, Fristen laut Wiedergabe, Abschlussbericht widersprüchlich |
| 07 | [Lieferkette und Dienstleister](07-lieferkette-und-dienstleister/) | 3,75 h | Entwurf, nicht erprobt |
| 08 | [Nachweise, Aufsicht und Umsetzungsplan](08-nachweise-aufsicht-und-umsetzungsplan/) (Priorität 2) | 4,5 h | Entwurf, nicht erprobt; Sanktionsrahmen aus Sekundärquelle |

Summe 34,5 Stunden. 1 Modul mit Priorität 2 dient der Vertiefung; kein Pflichtmodul setzt es voraus.

## Aufbau eines Moduls

Ordner `NN-kurzname/` mit `README.md`, der Übung `NN.1-….md`, gegebenenfalls Beispieldaten, Vorlagen und Skripten sowie `beispiele/` mit der echten Ausgabe der Rechenhilfen.

## Hinweise

- Alle Firmen, Personen, Adressen, Protokolle und Zahlen sind frei erfunden (Domänen nach RFC 2606, Adressen nach RFC 1918).
- Kennwörter und Token gehören nie in Dateien dieses Repositories.
- **Keine Rechtsberatung** und keine Zertifizierungsvorbereitung; Rechtsaussagen sind Kursannahmen und von Fachleuten zu prüfen.

## Lizenz

- Code und Skripte: MIT, siehe [`LICENSE`](LICENSE)
- Texte: CC BY 4.0, siehe [`LICENSE-DOCS.md`](LICENSE-DOCS.md)
