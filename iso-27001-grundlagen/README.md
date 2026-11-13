# ISO 27001 Grundlagen (P49)

Fallstudien-, Rechen- und Dokumentationsaufgaben zum Aufbau eines Informationssicherheits-Managementsystems (ISMS) mit der fiktiven Silbersee Software GmbH (`silbersee.example.com`, Netz `10.70.0.0/23`), ohne technisches Labor. Neun Module mit je einer ausgearbeiteten Übung (Steckbrief, Lernziele, Voraussetzungen, Grundbegriffe, Aufgabe mit Zuordnung zu Lerneinheiten, Hinweise, Kontrollfragen, Musterlösung, Erweiterungen, Quellen). Gesamtumfang: 36,75 Stunden (49 Unterrichtseinheiten zu 45 Minuten, mit dem Faktor 0,75 umgerechnet).

> **Prüfstand, ehrlich:** **Es wurde nichts installiert.** Real ausgeführt wurden nur die Rechenhilfen (`risikoregister.py`, `kennzahlen.py`; Python 3, ohne Fremdpakete); ihre Ausgaben stehen in `beispiele/`. **Die Norm ISO/IEC 27001 wurde nicht gelesen;** Klauselnummern und die Zahl der Maßnahmen im Anhang A stammen aus dem Fachwissen des Verfassers. Nur Ausgabe und Stand der Norm sind an der Produktseite von iso.org geprüft (13.11.2026). Normtexte sind nicht wiedergegeben. Kein Rechtsrat. Offene Punkte: [`befehle-nicht-bestaetigt.md`](befehle-nicht-bestaetigt.md); Anmerkungen zum Lehrplan: [`lehrplan-korrekturen.md`](lehrplan-korrekturen.md).

## Umgebung

Es gibt **kein technisches Labor**: keine VMs, keine Installation. Benötigt werden nur Textverarbeitung und Tabellenkalkulation (oder Papier); die Rechenhilfen brauchen Python 3 ohne Zusatzpakete. Beispieldaten liegen in den Modulordnern; wo ein Python-Skript dabei ist, steht die echte Ausgabe in `beispiele/`.

## Module

| Nr. | Modul | Zeit | Prüfstand |
|---|---|---|---|
| 01 | [Informationssicherheit, ISMS und Normfamilie](01-informationssicherheit-isms-und-normfamilie/) | 3,75 h | Entwurf, nicht erprobt; Ausgabe der Norm an Produktseite geprüft |
| 02 | [Kontext, interessierte Parteien und Geltungsbereich](02-kontext-parteien-und-geltungsbereich/) | 3,75 h | Entwurf, nicht erprobt |
| 03 | [Führung, Politik, Rollen und Verantwortung](03-fuehrung-politik-rollen-und-verantwortung/) | 3,75 h | Entwurf, nicht erprobt |
| 04 | [Risikomanagement: Bewertung und Behandlung](04-risikomanagement-bewertung-und-behandlung/) | 5,25 h | Skript real ausgeführt, Methode ist Annahme |
| 05 | [Maßnahmen im Überblick und Erklärung zur Anwendbarkeit](05-massnahmen-und-erklaerung-zur-anwendbarkeit/) | 5,25 h | Entwurf, nicht erprobt |
| 06 | [Unterstützung und dokumentierte Information](06-unterstuetzung-und-dokumentierte-information/) | 3,75 h | Entwurf, nicht erprobt |
| 07 | [Betrieb, Überwachung, interne Audits und Managementbewertung](07-betrieb-audit-und-managementbewertung/) | 4,5 h | Skript real ausgeführt, Zielwerte sind Annahmen |
| 08 | [Verbesserung und Zertifizierung](08-verbesserung-und-zertifizierung/) | 3,75 h | Entwurf, nicht erprobt |
| 09 | [Bezug zum Betrieb: ISMS im IT-Alltag](09-isms-im-it-alltag/) (Priorität 2) | 3 h | Entwurf, nicht erprobt |

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
