# Technische Dokumentation und Dokumentations-Governance: Lernskript

Lernskript in 17 Modulen: wie technische Dokumentation entsteht, die Menschen tatsächlich nutzen können, und wie eine Organisation sicherstellt, dass sie richtig, aktuell, auffindbar und prüfbar bleibt. Es reicht von Grundlagen, Zielgruppen und Dokumentationsstrategie über Struktur, Informationsdesign und Schreibstil, System-, Betriebs-, Prozess- und API-Dokumentation, Standards und Templates, Diagramme, Versionierung, Review und Qualitätssicherung bis zu Tools, Plattformen und Ablageorten, Security, Datenschutz und Compliance, Lifecycle, Betrieb und Wissensmanagement, Kennzahlen und Audits sowie Migration, Kosten, Resilienz und Roadmap. Jede Lerneinheit hat eine Erklärung, mindestens ein vollständiges Beispiel, typische Fehler mit Gegenüberstellung und einen Praxisbezug. Am Ende jedes Moduls stehen acht Übungsaufgaben mit Lösungen.

## Wichtig: Was dieses Repository (noch) ist

- Es enthält das **Skript als Markdown**, ein Kapitel pro Modul (`skript.md`), dazu [Einleitung](docs/skript-einleitung.md) und [Quellenverzeichnis](docs/skript-quellenverzeichnis.md) im Ordner `docs`.
- Eine eigenständige Übungsreihe mit Beispieldateien, Testskripten und Lösungen je Modul ist **noch nicht** Teil des Repositories (die Übungsaufgaben am Kapitelende gehören zum Skript).
- **Prüfstand der Beispiele:** Alle 375 Codeblöcke sind zeichengleich aus der Quelle übernommen (184 als `python`, 46 als `yaml`, 25 als `markdown`, 7 als `bash`, 113 als `text`). In der Quelle ist nur für Python und Bash eine Sprache gesetzt; die Auszeichnung der übrigen Blöcke habe ich nach dem Inhalt vergeben, der Inhalt ist unverändert. Alle 184 Python-Beispiele sind syntaktisch gültig (Python 3.13). Als eigenständiges Programm ohne Argumente und ohne Eingabedateien laufen nur 13 durch; die übrigen sind Kommandozeilenwerkzeuge, die ein Argument (93 Beispiele, Abbruch mit `IndexError`) oder eine Eingabedatei (78 Beispiele, Abbruch mit `FileNotFoundError`) erwarten. Deren Eingabedaten stehen im Skript als eigene Blöcke, ich habe sie **nicht** zusammengesetzt und die Werkzeuge **nicht** mit Daten ausgeführt und auch die im Skript gezeigten Ausgaben nicht verglichen. Von den 7 Bash-Blöcken ist die Syntax in Ordnung; 3 laufen allein durch, die übrigen brauchen Argumente, ein Git-Repository oder ein vorher angelegtes Skript.
- **Zusatzpakete:** Die Einleitung sagt, die Python-Skripte brauchten eine normale Python-3-Installation ohne Zusatzpakete. Das stimmt nicht für alle Beispiele: 42 Python-Beispiele (in den Modulen 05 bis 17) importieren `yaml` (PyYAML, installierbar mit `pip install pyyaml`); Modul 11 zeigt außerdem ein Beispiel mit dem Paket `markdown` und mehrere Beispiele rufen Pandoc oder Git auf. Der Hinweis in der Einleitung ist hier unverändert übernommen.
- **Stundenangaben:** Dauer laut Skript 191,75 Stunden insgesamt; je Modul stimmen Modulkopf und Summe der Lerneinheiten überein.
- Das Quellenverzeichnis trennt tatsächlich abgerufene und weiterführende Quellen (Abrufstand laut Skript: 28.10.2026). Rechtliche Hinweise (DSGVO, Maschinenverordnung, Normen) sind keine Rechtsberatung.

## Module

| Modul | Thema | Dauer laut Skript | Lerneinheiten | Prio | Aufgaben |
|---|---|---|---|---|---|
| [01](modul-01-grundlagen-zweck-zielbild/) | Grundlagen, Zweck und Zielbild technischer Dokumentation | 13 h | 13 | 1 | 8 |
| [02](modul-02-dokumentationsstrategie-zielbild/) | Dokumentationsstrategie und Zielbild | 8,75 h | 8 | 1 | 8 |
| [03](modul-03-strukturierung-gliederung-informationsdesign/) | Strukturierung, Gliederung und Informationsdesign | 15,5 h | 15 | 1 | 8 |
| [04](modul-04-technische-schreibweise-stilregeln/) | Technische Schreibweise und Stilregeln | 8 h | 8 | 1 | 8 |
| [05](modul-05-system-betriebs-administrationsdokumentation/) | System-, Betriebs- und Administrationsdokumentation | 8,75 h | 8 | 1 | 8 |
| [06](modul-06-prozess-arbeits-verfahrensdokumentation/) | Prozess-, Arbeits- und Verfahrensdokumentation | 14,5 h | 14 | 1 | 8 |
| [07](modul-07-standards-templates-qualitaetskriterien/) | Standards, Templates und Qualitätskriterien | 8,75 h | 8 | 1 | 8 |
| [08](modul-08-api-software-entwicklerdokumentation/) | API-, Software- und Entwicklerdokumentation | 8,75 h | 8 | 1 | 8 |
| [09](modul-09-diagramme-modelle-visualisierung/) | Diagramme, Modelle und Visualisierung | 8 h | 8 | 1 | 8 |
| [10](modul-10-versionierung-review-qualitaetssicherung/) | Versionierung, Review und Qualitätssicherung | 16,75 h | 16 | 1 | 8 |
| [11](modul-11-tools-formate-publishing/) | Tools, Formate und Publishing-Prozesse | 8,75 h | 8 | 2 | 8 |
| [12](modul-12-tooling-plattformen-ablageorte/) | Tooling, Plattformen und Ablageorte | 8 h | 8 | 2 | 8 |
| [13](modul-13-security-datenschutz-compliance/) | Security, Datenschutz und Compliance in Dokumenten | 15,75 h | 15 | 1 | 8 |
| [14](modul-14-review-aktualitaet-lifecycle/) | Review, Aktualität und Lifecycle Management | 8,75 h | 8 | 1 | 8 |
| [15](modul-15-betrieb-pflege-wissensmanagement/) | Betrieb, Pflege und Wissensmanagement | 16 h | 16 | 2 | 8 |
| [16](modul-16-kennzahlen-audits-verbesserung/) | Kennzahlen, Audits und kontinuierliche Verbesserung | 8,75 h | 8 | 2 | 8 |
| [17](modul-17-migration-kosten-resilienz-roadmap/) | Migration, Kosten, Resilienz und Roadmap | 15 h | 15 | 2 | 8 |

Priorität: 1 = höchste.

## Lizenz

- **Code** (Beispieldateien und Skripte, falls das Repository solche enthält): [MIT-Lizenz](LICENSE)
- **Texte** (die Modul-READMEs, die Kapitel `skript.md` und die Dateien unter `docs/`): [CC BY 4.0](LICENSE-DOCS.md)
- Genannte Produkte und Normen (zum Beispiel Confluence, SharePoint, GitHub, Pandoc, MkDocs, ISO und IEC) sind Marken oder Werke ihrer jeweiligen Inhaber; dieses Repository steht in keiner Verbindung zu ihnen.

Autor: AnsibleArtisan4711
