# Changelog

Alle nennenswerten Änderungen an diesem Repository. Format nach [Keep a Changelog](https://keepachangelog.com/de/1.1.0/).

## [Unveröffentlicht]

### Hinzugefügt

- Skript als Markdown: `skript.md` und `README.md` in jedem der 12 Modulordner, `docs/skript-einleitung.md` und `docs/skript-quellenverzeichnis.md` (aus der LaTeX-Quelle umgewandelt, 144 Codebeispiele zeichengleich geprüft)
- Lizenzen: MIT für Code (`LICENSE`), CC BY 4.0 für Texte (`LICENSE-DOCS.md`)

### Hinweise zur Umwandlung

- Lerneinheiten wie in der Quelle als Modul.Lerneinheit nummeriert (zum Beispiel 3.9); „Übungsaufgaben zu Modul NN“ (8 Aufgaben mit Schwierigkeitsangabe als nummerierte Liste) und „Lösungen zu den Übungsaufgaben Modul NN“ (Absätze „**N.**“) am Modulende
- Modulkopf (Dauer, Priorität) als zwei Zeilen, danach die Tabelle der Lerneinheiten; Merke-, Praxis- und Ergänzungsboxen als Zitatblöcke mit fettem Titel
- Formeln: einfache Rechnungen als Text (×, ·, ≈), drei Formeln mit Indizes beziehungsweise Bruch (Modul 03, Stichprobengröße) als `$…$`-Formel, die GitHub darstellt
- Quellenverzeichnis: Beschreibungsliste der Quelle (`Q1` …) als Aufzählung mit fetter Kennung
- Geändert gegenüber der Quelle: In den Modultiteln stehen Umlaute (Quelle: „Gruendung“, „Geschaeftsmodell“, „Vertrage“ in Modul 01, 02, 03, 11; Ordnernamen bleiben ohne Umlaute). In Modul 11 ist deshalb der Satz „(Die Schreibweise „Vertrage“ im Modultitel folgt dem Lehrplan.)“ entfallen. Codeblöcke, auch Bezeichner und Kommentare ohne Umlaute, sind unverändert
- Python-Beispiele: 142 von 143 syntaktisch gültig, 132 laufen allein durch (Einzelheiten in der README)
