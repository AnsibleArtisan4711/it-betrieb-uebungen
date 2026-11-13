# Datenschutz (DSGVO) in der IT (P47)

Fallstudien- und Rechenaufgaben zum Datenschutz in der IT-Administration mit der fiktiven Alpenblick Reisen GmbH (`alpenblick.example.com`, Netz `10.50.0.0/24`), ohne technisches Labor. Neun Module mit je einer ausgearbeiteten Übung (Steckbrief, Lernziele, Voraussetzungen, Grundbegriffe, Aufgabe mit Zuordnung zu Lerneinheiten, Hinweise, Kontrollfragen, Musterlösung, Erweiterungen, Quellen). Gesamtumfang: 36,75 Stunden (49 Unterrichtseinheiten zu 45 Minuten, mit dem Faktor 0,75 umgerechnet).

> **Prüfstand, ehrlich:** **Es wurde nichts installiert.** Real ausgeführt wurden nur die Rechenhilfen (`anfrage_frist.py`, `meldefrist.py`, `protokoll_pruefen.py`, `abgleich.py`; Python 3, ohne Fremdpakete); ihre Ausgaben stehen in `beispiele/`. **Der Wortlaut der DSGVO, das österreichische DSG, Muster der Datenschutzbehörde und Aufbewahrungsfristen wurden nicht gelesen** (EUR-Lex, RIS und dsb.gv.at waren nicht abrufbar); nur die Angaben zur Meldung von Datenpannen stammen aus einer gelesenen Sekundärquelle (WKO, Stand 23.10.2026). Kein Rechtsrat. Offene Punkte: [`befehle-nicht-bestaetigt.md`](befehle-nicht-bestaetigt.md); Anmerkungen zum Lehrplan: [`lehrplan-korrekturen.md`](lehrplan-korrekturen.md).

## Umgebung

Es gibt **kein technisches Labor**: keine VMs, keine Installation. Benötigt werden nur Textverarbeitung und Tabellenkalkulation (oder Papier); die Rechenhilfen brauchen Python 3 ohne Zusatzpakete. Beispieldaten liegen in den Modulordnern; wo ein Python-Skript dabei ist, steht die echte Ausgabe in `beispiele/`.

## Module

| Nr. | Modul | Zeit | Prüfstand |
|---|---|---|---|
| 01 | [Grundbegriffe und Grundsätze](01-grundbegriffe-und-grundsaetze/) | 3,75 h | Entwurf, nicht erprobt |
| 02 | [Rechtsgrundlagen der Verarbeitung](02-rechtsgrundlagen-der-verarbeitung/) | 3,75 h | Entwurf, nicht erprobt |
| 03 | [Betroffenenrechte](03-betroffenenrechte/) | 4,5 h | Fristrechnung real ausgeführt, Fristregeln nicht am Gesetz geprüft |
| 04 | [Verzeichnis der Verarbeitungstätigkeiten](04-verzeichnis-der-verarbeitungstaetigkeiten/) | 3,75 h | Abgleichsskript real ausgeführt, Pflichtangaben nicht am Gesetz geprüft |
| 05 | [Auftragsverarbeitung und Übermittlung in Drittländer](05-auftragsverarbeitung-und-drittlaender/) | 3,75 h | Entwurf, nicht erprobt |
| 06 | [Technische und organisatorische Maßnahmen](06-technische-und-organisatorische-massnahmen/) | 4,5 h | Entwurf, nicht erprobt |
| 07 | [Datenpannen und Meldung](07-datenpannen-und-meldung/) | 3,75 h | Fristrechnung real ausgeführt, Auslegung nicht am Gesetz geprüft |
| 08 | [Protokollierung, Aufbewahrung und Praxisfälle aus der Administration](08-protokollierung-aufbewahrung-und-praxisfaelle/) | 6 h | Skript real ausgeführt, Fristen und Rechtslage nicht geprüft |
| 09 | [Datenschutz-Folgenabschätzung und Datenschutzbeauftragter](09-folgenabschaetzung-und-datenschutzbeauftragter/) (Priorität 2) | 3 h | Entwurf, nicht erprobt |

Summe 36,75 Stunden. 1 Modul mit Priorität 2 dient der Vertiefung; kein Pflichtmodul setzt es voraus.

## Aufbau eines Moduls

Ordner `NN-kurzname/` mit `README.md`, der Übung `NN.1-….md`, gegebenenfalls Beispieldaten, Vorlagen und Skripten sowie `beispiele/` mit der echten Ausgabe der Rechenhilfen.

## Hinweise

- Alle Firmen, Personen, Adressen, Protokolle und Zahlen sind frei erfunden (Domänen nach RFC 2606, Adressen nach RFC 1918).
- Kennwörter und Token gehören nie in Dateien dieses Repositories.
- **Keine Rechtsberatung** und keine Zertifizierungsvorbereitung; Rechtsaussagen sind Kursannahmen und von Fachleuten zu prüfen.

## Lizenz

- Code und Skripte: MIT, siehe [`LICENSE`](LICENSE)
- Texte: CC BY 4.0, siehe [`LICENSE-DOCS.md`](LICENSE-DOCS.md)
