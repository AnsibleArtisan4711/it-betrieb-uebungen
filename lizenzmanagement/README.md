# Lizenzmanagement (P70)

Fallstudien- und Rechenaufgaben zu Lizenzmodellen mit der fiktiven Bergfeld Maschinenbau GmbH, ohne technisches Labor, mit Tabellenkalkulation und kleinen Python-Skripten. Acht Module mit je einer ausgearbeiteten Übung (Steckbrief, Lernziele, Voraussetzungen, Grundbegriffe, Aufgabe mit Zuordnung zu Lerneinheiten, Hinweise, Kontrollfragen, Musterlösung, Erweiterungen, Quellen). Gesamtumfang: 30 Stunden (40 Unterrichtseinheiten zu 45 Minuten, mit dem Faktor 0,75 umgerechnet).

> **Prüfstand, ehrlich:** **Es wurde nichts installiert.** Real ausgeführt wurden nur die Rechenhilfen (Python 3, ohne Fremdpakete); ihre Ausgaben stehen in `beispiele/`. Alle Preise sind erfunden. Lizenzregeln für aktuelle Produkte und rechtliche Aussagen sind nicht geprüft; es gibt keine Rechtsberatung. Offene Punkte: [`befehle-nicht-bestaetigt.md`](befehle-nicht-bestaetigt.md); Anmerkungen zum Lehrplan: [`lehrplan-korrekturen.md`](lehrplan-korrekturen.md).

## Umgebung

Es gibt **kein technisches Labor**: keine VMs, keine Installation. Benötigt werden nur Office-Software (Textverarbeitung, Tabellenkalkulation) oder Papier. Beispieldaten (Logauszug, Ticketliste, Vorlagen) liegen in den Modulordnern; wo Rechenaufgaben ein Python-Skript haben, steht die echte Ausgabe in `beispiele/`.

## Module

| Nr. | Modul | Zeit | Prüfstand |
|---|---|---|---|
| 01 | [Grundbegriffe und Lizenzarten](01-grundbegriffe-und-lizenzarten/) | 3,75 h | Entwurf, nicht erprobt |
| 02 | [Microsoft-Lizenzierung im Überblick](02-microsoft-lizenzierung/) | 4,5 h | Rechnung real ausgeführt, Regel nicht für aktuelle Version bestätigt |
| 03 | [Open-Source-Lizenzen und Pflichten](03-open-source-lizenzen/) | 3,75 h | Rechnung real ausgeführt, Lizenzinhalt nicht geprüft |
| 04 | [Cloud- und Subscription-Lizenzen](04-cloud-und-subscription-lizenzen/) | 3,75 h | Rechnung real ausgeführt, Preise erfunden |
| 05 | [Lizenzinventur und Compliance](05-lizenzinventur-und-compliance/) | 4,5 h | Rechnung real ausgeführt, Daten erfunden |
| 06 | [Audits und Nachweise](06-audits-und-nachweise/) (Priorität 2) | 3 h | Entwurf, nicht erprobt |
| 07 | [Optimierung und Beschaffung](07-optimierung-und-beschaffung/) (Priorität 2) | 3,75 h | Entwurf, nicht erprobt |
| 08 | [Dokumentation und Prozess](08-dokumentation-und-prozess/) | 3 h | Entwurf, nicht erprobt |

Summe 30 Stunden. 2 Module mit Priorität 2 dienen der Vertiefung; kein Pflichtmodul setzt sie voraus.

## Aufbau eines Moduls

Ordner `NN-kurzname/` mit `README.md`, der Übung `NN.1-….md`, gegebenenfalls Beispieldaten und Vorlagen sowie `beispiele/` mit der echten Ausgabe der Rechenhilfen.

## Hinweise

- Alle Firmen, Personen, Adressen und Zahlen sind frei erfunden (Domänen nach RFC 2606, Adressen nach RFC 1918).
- Kennwörter und Token gehören nie in Dateien dieses Repositories (Ausnahme: gekennzeichnete Laborwerte).
- Keine Rechtsberatung; keine Zertifizierungsvorbereitung.

## Lizenz

- Code und Skripte: MIT, siehe [`LICENSE`](LICENSE)
- Texte: CC BY 4.0, siehe [`LICENSE-DOCS.md`](LICENSE-DOCS.md)
