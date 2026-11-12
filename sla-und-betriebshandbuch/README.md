# SLA und Betriebshandbuch (P43)

Fallstudien-, Rechen- und Dokumentationsaufgaben mit der fiktiven Nordwind Logistik GmbH (`nordwind.example.com`). Acht Module mit je einer ausgearbeiteten Übung (Steckbrief, Lernziele, Voraussetzungen, Grundbegriffe, Aufgabe mit Zuordnung zu Lerneinheiten, Hinweise, Kontrollfragen, Musterlösung, Erweiterungen, Quellen). Gesamtumfang: 36 Stunden (48 Unterrichtseinheiten zu 45 Minuten, mit dem Faktor 0,75 umgerechnet).

> **Prüfstand, ehrlich:** **Es wurde nichts installiert.** Real ausgeführt wurden nur die Rechenhilfen (Python 3, ohne Fremdpakete); ihre Ausgaben stehen in den Ordnern `beispiele/`. Die Aufgaben wurden nicht mit Lernenden erprobt; ITIL-Begriffe sind nicht gegen das Buch geprüft. Offene Punkte: [`befehle-nicht-bestaetigt.md`](befehle-nicht-bestaetigt.md); Anmerkungen zum Lehrplan: [`lehrplan-korrekturen.md`](lehrplan-korrekturen.md).

## Umgebung

Es gibt **kein technisches Labor**: keine VMs, keine Installation. Benötigt werden nur Office-Software (Textverarbeitung, Tabellenkalkulation) oder Papier. Beispieldaten (Logauszug, Ticketliste, Vorlagen) liegen in den Modulordnern; wo Rechenaufgaben ein Python-Skript haben, steht die echte Ausgabe in `beispiele/`.

## Module

| Nr. | Modul | Zeit | Prüfstand |
|---|---|---|---|
| 01 | [Servicekatalog](01-servicekatalog/) | 4,5 h | Subnetzrechnung real ausgeführt, Rest Entwurf |
| 02 | [SLA, OLA und Underpinning Contracts](02-sla-ola-und-underpinning-contracts/) | 4,5 h | Entwurf, nicht erprobt |
| 03 | [Kennzahlen und Reporting](03-kennzahlen-und-reporting/) | 4,5 h | Rechnung per Skript real ausgeführt, Rest Entwurf |
| 04 | [Verfügbarkeitsberechnung](04-verfuegbarkeitsberechnung/) | 4,5 h | Rechnung per Skript real ausgeführt, Rest Entwurf |
| 05 | [Bereitschaft und Eskalation](05-bereitschaft-und-eskalation/) (Priorität 2) | 4,5 h | Rechnung per Skript real ausgeführt, Rechtsquelle nicht geprüft |
| 06 | [Betriebshandbuch und Runbooks](06-betriebshandbuch-und-runbooks/) | 5,25 h | Entwurf, nicht erprobt |
| 07 | [Übergabe in den Betrieb](07-uebergabe-in-den-betrieb/) | 4,5 h | Entwurf, nicht erprobt |
| 08 | [Qualität und Aktualität](08-qualitaet-und-aktualitaet/) | 3,75 h | Rechnung per Skript real ausgeführt, Rest Entwurf |

Summe 36 Stunden. 1 Module mit Priorität 2 dienen der Vertiefung; kein Pflichtmodul setzt sie voraus.

## Aufbau eines Moduls

Ordner `NN-kurzname/` mit `README.md`, der Übung `NN.1-….md`, gegebenenfalls Beispieldaten und Vorlagen sowie `beispiele/` mit der echten Ausgabe der Rechenhilfen.

## Hinweise

- Alle Firmen, Personen, Adressen und Zahlen sind frei erfunden (Domänen nach RFC 2606, Adressen nach RFC 1918).
- Kennwörter und Token gehören nie in Dateien dieses Repositories (Ausnahme: gekennzeichnete Laborwerte).
- Keine Rechtsberatung; keine Zertifizierungsvorbereitung.

## Lizenz

- Code und Skripte: MIT, siehe [`LICENSE`](LICENSE)
- Texte: CC BY 4.0, siehe [`LICENSE-DOCS.md`](LICENSE-DOCS.md)
