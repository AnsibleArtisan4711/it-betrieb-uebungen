# Incident-, Problem- und Change-Management (P41)

Fallstudien- und Dokumentationsaufgaben zu ITIL-4-Practices mit der fiktiven `example.com` (Netzplan nach RFC 1918). Acht Module mit je einer ausgearbeiteten Übung (Steckbrief, Lernziele, Voraussetzungen, Grundbegriffe, Aufgabe mit Zuordnung zu Lerneinheiten, Hinweise, Kontrollfragen, Musterlösung, Erweiterungen, Quellen). Gesamtumfang: 36 Stunden (48 Unterrichtseinheiten zu 45 Minuten, mit dem Faktor 0,75 umgerechnet).

> **Prüfstand, ehrlich:** **Es wurde nichts installiert.** Real ausgeführt wurden nur die Rechenhilfen (Python 3, ohne Fremdpakete); ihre Ausgaben stehen in den Ordnern `beispiele/`. Die Aufgaben wurden nicht mit Lernenden erprobt; ITIL-Begriffe sind nicht gegen das Buch geprüft. Offene Punkte: [`befehle-nicht-bestaetigt.md`](befehle-nicht-bestaetigt.md); Anmerkungen zum Lehrplan: [`lehrplan-korrekturen.md`](lehrplan-korrekturen.md).

## Umgebung

Es gibt **kein technisches Labor**: keine VMs, keine Installation. Benötigt werden nur Office-Software (Textverarbeitung, Tabellenkalkulation) oder Papier. Beispieldaten (Logauszug, Ticketliste, Vorlagen) liegen in den Modulordnern; wo Rechenaufgaben ein Python-Skript haben, steht die echte Ausgabe in `beispiele/`.

## Module

| Nr. | Modul | Zeit | Prüfstand |
|---|---|---|---|
| 01 | [Grundlagen des IT Service Managements (ITIL 4)](01-grundlagen-itsm-itil-4/) | 4,5 h | Entwurf, nicht erprobt |
| 02 | [Incident Management – Lebenszyklus und Klassifizierung](02-incident-lebenszyklus-und-klassifizierung/) | 4,5 h | Entwurf, nicht erprobt |
| 03 | [Incident Management – Eskalation und Kommunikation](03-incident-eskalation-und-kommunikation/) | 4,5 h | Rechenhilfe real ausgeführt, Rest Entwurf |
| 04 | [Problem Management – Grundlagen und reaktive Analyse](04-problem-management-grundlagen/) | 4,5 h | Entwurf, nicht erprobt |
| 05 | [Problem Management – Proaktive Analyse und RCA](05-problem-management-rca/) (Priorität 2) | 4,5 h | Entwurf, nicht erprobt |
| 06 | [Change Enablement – Grundlagen und Change-Typen](06-change-enablement-grundlagen/) | 4,5 h | Entwurf, nicht erprobt |
| 07 | [Change Enablement – Evaluierung und Wartungsfenster](07-change-evaluierung-und-wartungsfenster/) | 4,5 h | Entwurf, nicht erprobt |
| 08 | [Post-Incident-Review und Service-Metriken](08-post-incident-review-und-metriken/) (Priorität 2) | 4,5 h | Rechenaufgabe per Skript real nachgerechnet, Rest Entwurf |

Summe 36 Stunden. 2 Module mit Priorität 2 dienen der Vertiefung; kein Pflichtmodul setzt sie voraus.

## Aufbau eines Moduls

Ordner `NN-kurzname/` mit `README.md`, der Übung `NN.1-….md`, gegebenenfalls Beispieldaten und Vorlagen sowie `beispiele/` mit der echten Ausgabe der Rechenhilfen.

## Hinweise

- Alle Firmen, Personen, Adressen und Zahlen sind frei erfunden (Domänen nach RFC 2606, Adressen nach RFC 1918).
- Kennwörter und Token gehören nie in Dateien dieses Repositories (Ausnahme: gekennzeichnete Laborwerte).
- Keine Rechtsberatung; keine Zertifizierungsvorbereitung.

## Lizenz

- Code und Skripte: MIT, siehe [`LICENSE`](LICENSE)
- Texte: CC BY 4.0, siehe [`LICENSE-DOCS.md`](LICENSE-DOCS.md)
