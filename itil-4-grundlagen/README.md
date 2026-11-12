# ITIL 4 Grundlagen (P40)

Fallstudien- und Dokumentationsaufgaben zu ITIL 4 mit der fiktiven Example Corp (`example.com`, Netz `192.168.10.0/24`). Acht Module mit je einer ausgearbeiteten Übung (Steckbrief, Lernziele, Voraussetzungen, Grundbegriffe, Aufgabe mit Zuordnung zu Lerneinheiten, Hinweise, Kontrollfragen, Musterlösung, Erweiterungen, Quellen). Gesamtumfang: 36 Stunden (48 Unterrichtseinheiten zu 45 Minuten, mit dem Faktor 0,75 umgerechnet).

> **Prüfstand, ehrlich:** **Es wurde nichts installiert.** Real ausgeführt wurden nur die Rechenhilfen (Python 3, ohne Fremdpakete); ihre Ausgaben stehen in den Ordnern `beispiele/`. Die Aufgaben wurden nicht mit Lernenden erprobt; ITIL-Begriffe sind nicht gegen das Buch geprüft. Offene Punkte: [`befehle-nicht-bestaetigt.md`](befehle-nicht-bestaetigt.md); Anmerkungen zum Lehrplan: [`lehrplan-korrekturen.md`](lehrplan-korrekturen.md).

## Umgebung

Es gibt **kein technisches Labor**: keine VMs, keine Installation. Benötigt werden nur Office-Software (Textverarbeitung, Tabellenkalkulation) oder Papier. Beispieldaten (Logauszug, Ticketliste, Vorlagen) liegen in den Modulordnern; wo Rechenaufgaben ein Python-Skript haben, steht die echte Ausgabe in `beispiele/`.

## Module

| Nr. | Modul | Zeit | Prüfstand |
|---|---|---|---|
| 01 | [Einführung in IT-Servicemanagement und ITIL 4](01-einfuehrung-itsm-itil-4/) | 4,5 h | Entwurf, nicht erprobt |
| 02 | [Die 7 Leitprinzipien (Guiding Principles)](02-die-7-leitprinzipien/) | 4,5 h | Entwurf, nicht erprobt |
| 03 | [Das Service-Wertschöpfungssystem (SVS) und die Vier Dimensionen](03-svs-und-vier-dimensionen/) | 4,5 h | Entwurf, nicht erprobt |
| 04 | [ITIL-Praktiken: Incident Management & Troubleshooting](04-incident-management-und-troubleshooting/) | 6 h | Entwurf, nicht erprobt |
| 05 | [ITIL-Praktiken: Problem & Change Enablement](05-problem-und-change-enablement/) | 4,5 h | Entwurf, nicht erprobt |
| 06 | [ITIL-Praktiken: Service Desk, Request Fulfilment & Monitoring](06-service-desk-request-und-monitoring/) | 4,5 h | Entwurf, nicht erprobt |
| 07 | [Rollen, Kennzahlen (KPIs) und SLAs im IT-Betrieb](07-rollen-kennzahlen-und-slas/) (Priorität 2) | 3 h | Rechenaufgabe per Skript real nachgerechnet, Rest Entwurf |
| 08 | [Continual Improvement (KVP) im System-Alltag](08-continual-improvement-im-system-alltag/) (Priorität 2) | 4,5 h | Entwurf, nicht erprobt |

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
