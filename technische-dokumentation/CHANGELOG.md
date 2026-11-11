# Changelog

Alle nennenswerten Änderungen an diesem Repository. Format nach [Keep a Changelog](https://keepachangelog.com/de/1.1.0/).

## [Unveröffentlicht]

### Hinzugefügt

- Skript als Markdown: `skript.md` und `README.md` in jedem der 17 Modulordner, `docs/skript-einleitung.md` und `docs/skript-quellenverzeichnis.md` (aus der LaTeX-Quelle umgewandelt, 375 Codebeispiele zeichengleich geprüft, Inline-Codes vollständig übernommen)
- Lizenzen: MIT für Code (`LICENSE`), CC BY 4.0 für Texte (`LICENSE-DOCS.md`)

### Hinweise zur Umwandlung

- Lerneinheiten wie in der Quelle als Modul.Lerneinheit nummeriert (zum Beispiel 3.5); „Übungsaufgaben“ (8 Aufgaben je Modul) und „Lösungen und Erläuterungen“ als unnummerierte Abschnitte am Modulende
- Modulkopf (Dauer, Priorität, Anzahl Lerneinheiten) als eine Zeile, Gegenüberstellungen „Falsch/Richtig“ als Tabellen, Hinweisboxen als Zitatblöcke mit fettem Titel
- Codeblöcke: In der Quelle ist nur für Python und Bash eine Sprache gesetzt; die übrigen Blöcke sind nach ihrem Inhalt als `python`, `yaml`, `markdown`, `bash` oder `text` ausgezeichnet (Inhalt unverändert)
- In Modul 11 und 01 steht LaTeX-Quelltext in Codeblöcken; er ist als `text` unverändert übernommen
- Python-Beispiele: Syntax geprüft, 13 eigenständig ausgeführt; die übrigen brauchen Argumente oder Eingabedateien und wurden nicht mit Daten ausgeführt (Einzelheiten in der README)
- Unstimmigkeiten der Quelle unverändert übernommen: Einleitung nennt „ohne Zusatzpakete“, 42 Beispiele brauchen PyYAML; Tabelle und Überschrift weichen in Modul 03 („Textverstaendlichkeit“ gegen „Textverständlichkeit“) und Modul 05 („Systemuebersicht“ gegen „Systemübersicht“, „Inventar und CMDB Bezug“ gegen „Inventar und CMDB-Bezug“) in der Schreibweise ab
