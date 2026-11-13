# IT-Englisch für Administratoren (P52)

Sprachaufgaben zu Fachenglisch in der IT-Administration (Wortschatz, Dokumentation, Fehlermeldungen, E-Mails und Tickets, Telefonate, Berichte) mit der fiktiven Bergfried Metallbau GmbH und erfundenen englischsprachigen Partnern, ohne technisches Labor. Acht Module mit je einer ausgearbeiteten Übung (Steckbrief, Lernziele, Voraussetzungen, Grundbegriffe, Aufgabe mit Zuordnung zu Lerneinheiten, Hinweise, Kontrollfragen, Musterlösung, Erweiterungen, Quellen). Gesamtumfang: 34,5 Stunden (46 Unterrichtseinheiten zu 45 Minuten, mit dem Faktor 0,75 umgerechnet).

> **Prüfstand, ehrlich:** **Es wurde nichts installiert.** Real ausgeführt wurden nur die Hilfsskripte (`fehlermeldungen.py`, `glossar_pruefen.py`; Python 3, ohne Fremdpakete); ihre Ausgaben stehen in `beispiele/`. **Wortschatz, Beispielsätze und Musterlösungen sind nicht von einer Englischlehrkraft geprüft.** Offene Punkte: [`befehle-nicht-bestaetigt.md`](befehle-nicht-bestaetigt.md); Anmerkungen zum Lehrplan: [`lehrplan-korrekturen.md`](lehrplan-korrekturen.md).

## Umgebung

Es gibt **kein technisches Labor**: keine VMs, keine Installation. Benötigt werden nur Textverarbeitung und Tabellenkalkulation (oder Papier) sowie ein Wörterbuch; die Hilfsskripte brauchen Python 3 ohne Zusatzpakete. Beispieldaten liegen in den Modulordnern; wo ein Python-Skript dabei ist, steht die echte Ausgabe in `beispiele/`.

## Module

| Nr. | Modul | Zeit | Prüfstand |
|---|---|---|---|
| 01 | [Fachwortschatz: Hardware, Software und Betriebssystem](01-fachwortschatz-hardware-software/) | 3,75 h | Entwurf, nicht erprobt |
| 02 | [Fachwortschatz: Netzwerk, Server und Betrieb](02-netzwerk-und-server-wortschatz/) | 3,75 h | Entwurf, nicht erprobt |
| 03 | [Dokumentation und Handbücher lesen](03-dokumentation-lesen/) | 5,25 h | Entwurf, nicht erprobt |
| 04 | [Fehlermeldungen und Logs auf Englisch lesen](04-fehlermeldungen-und-logs/) | 4,5 h | Skript ausgeführt, Rest Entwurf |
| 05 | [E-Mails und Tickets auf Englisch schreiben](05-emails-und-tickets/) | 5,25 h | Entwurf, nicht erprobt |
| 06 | [Telefon- und Support-Situationen](06-telefon-und-support/) | 4,5 h | Entwurf, nicht erprobt |
| 07 | [Berichte, Änderungs- und Vorfallsdokumentation auf Englisch](07-berichte-und-dokumentation/) | 4,5 h | Entwurf, nicht erprobt |
| 08 | [Übungsdialoge und Glossar Deutsch–Englisch](08-uebungsdialoge-und-glossar/) (Priorität 2) | 3 h | Skript ausgeführt, Rest Entwurf |

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
