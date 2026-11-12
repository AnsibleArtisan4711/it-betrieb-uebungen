# Ticketsysteme in der Praxis (Zammad) (P42)

Laborreihe mit Zammad (Open Source), Ubuntu 24.04, Nginx, PostgreSQL, Elasticsearch und Mailpit auf Hyper-V. Acht Module mit je einer ausgearbeiteten Übung (Steckbrief, Lernziele, Voraussetzungen, Grundbegriffe, Aufgabe mit Zuordnung zu Lerneinheiten, Hinweise, Kontrollfragen, Musterlösung, Erweiterungen, Quellen). Gesamtumfang: 33,75 Stunden (45 Unterrichtseinheiten zu 45 Minuten, mit dem Faktor 0,75 umgerechnet).

> **Prüfstand, ehrlich:** **Kein Schritt in Zammad, Ubuntu, Hyper-V oder Windows wurde ausgeführt.** Nur die Fristrechnung (Python) wurde real gerechnet. Alle Menüpfade sind gegen die Dokumentation geprüft, nicht ausprobiert. Offene Punkte: [`befehle-nicht-bestaetigt.md`](befehle-nicht-bestaetigt.md); Anmerkungen zum Lehrplan: [`lehrplan-korrekturen.md`](lehrplan-korrekturen.md).

## Umgebung

Hyper-V mit zwei VMs (`zammad-srv` Ubuntu 24.04, `client-pc` Windows 11) am privaten Switch `Private-Switch`; Adressen `192.168.100.10/24` und `.20/24`, Domäne `zammad.example.internal`. Details in Modul 01.

## Module

| Nr. | Modul | Zeit | Prüfstand |
|---|---|---|---|
| 01 | [Grundlagen und Vorbereitung des Labors](01-grundlagen-und-laborvorbereitung/) | 3 h | Entwurf, nicht erprobt |
| 02 | [Installation und Grundkonfiguration von Zammad](02-installation-und-grundkonfiguration/) | 4,5 h | Entwurf, nicht erprobt |
| 03 | [Kategorien, Gruppen und Berechtigungskonzepte](03-kategorien-gruppen-und-berechtigungen/) | 4,5 h | Entwurf, nicht erprobt |
| 04 | [SLAs, Eskalationen und Prioritäten](04-slas-eskalationen-und-prioritaeten/) | 4,5 h | Fristrechnung per Skript real ausgeführt, Zammad nicht |
| 05 | [Wissensdatenbank (Knowledge Base) und Textbausteine](05-wissensdatenbank-und-textbausteine/) (Priorität 2) | 3 h | Entwurf, nicht erprobt |
| 06 | [E-Mail-Anbindung und Kommunikationswege](06-e-mail-anbindung/) | 5,25 h | Entwurf, nicht erprobt |
| 07 | [Automatisierung (Trigger, Scheduler, Makros)](07-automatisierung/) (Priorität 2) | 4,5 h | Entwurf, nicht erprobt |
| 08 | [Reporting, Monitoring-Anbindung und Troubleshooting](08-reporting-monitoring-und-troubleshooting/) | 4,5 h | Entwurf, nicht erprobt |

Summe 33,75 Stunden. 2 Module mit Priorität 2 dienen der Vertiefung; kein Pflichtmodul setzt sie voraus.

## Aufbau eines Moduls

Ordner `NN-kurzname/` mit `README.md`, der Übung `NN.1-….md`, gegebenenfalls Beispieldaten und Vorlagen sowie `beispiele/` mit der echten Ausgabe der Rechenhilfen.

## Hinweise

- Alle Firmen, Personen, Adressen und Zahlen sind frei erfunden (Domänen nach RFC 2606, Adressen nach RFC 1918).
- Kennwörter und Token gehören nie in Dateien dieses Repositories (Ausnahme: gekennzeichnete Laborwerte).
- Keine Rechtsberatung; keine Zertifizierungsvorbereitung.

## Lizenz

- Code und Skripte: MIT, siehe [`LICENSE`](LICENSE)
- Texte: CC BY 4.0, siehe [`LICENSE-DOCS.md`](LICENSE-DOCS.md)
