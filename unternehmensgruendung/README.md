# Unternehmensgründung: Lernskript

Lernskript in 12 Modulen zur Gründung eines Technologieunternehmens in der EU: von Problemdefinition und Marktvalidierung über Rechtsform, Geschäftsmodell, Produkt und Plattformbetrieb, Datenschutz, Finanzen und Finanzierung bis zu Vertrieb, Organisation, Legal Operations und Skalierung bis zum Exit. Jede Lerneinheit hat Erklärung, ein durchgerechnetes oder lauffähiges Beispiel, typische Fehler und einen Praxisbezug.

## Wichtig: Was dieses Repository (noch) ist

- Es enthält das **Skript als Markdown**, ein Kapitel pro Modul (`skript.md`), dazu [Einleitung](docs/skript-einleitung.md) und [Quellenverzeichnis](docs/skript-quellenverzeichnis.md) im Ordner `docs`.
- Eine eigenständige Übungsreihe mit Beispieldateien, Testskripten und Lösungen je Modul ist **noch nicht** Teil des Repositories (die Übungsaufgaben am Kapitelende gehören zum Skript).
- **Keine Rechtsberatung:** Rechtliche und steuerliche Aussagen (Rechtsformen, Steuern, Datenschutz, KI- und Cyber-Regulierung, Förderungen) sind allgemeine Information. Der Rechtsstand ist der Stand der Recherche der Quelle (1. November 2026, siehe Quellenverzeichnis); ich habe diese Aussagen nicht gegen die Rechtsquellen nachgeprüft, und Recht und Förderbedingungen ändern sich.
- **Umwandlung:** Alle 144 Codeblöcke wurden maschinell mit der LaTeX-Quelle verglichen und sind zeichengleich (143 als `python`, 1 als `yaml`). Die Quelle setzt die Sprache nur als `language=Python`; der eine Block ohne Angabe (ein GitHub-Actions-Workflow in Modul 05) ist als `yaml` ausgezeichnet.
- **Prüfstand der Python-Beispiele (von mir, Python 3.13, nur Standardbibliothek):** 142 von 143 Python-Blöcken sind syntaktisch gültig; 132 laufen für sich allein ohne Fehler durch. 10 weitere sind Ergänzungen in den Lösungen, die Variablen aus einem früheren Beispiel voraussetzen (Fehler `NameError`), einer ist ein eingerückter Ausschnitt (Modul 05). Die Quelle enthält keine abgedruckten Ausgaben zum Vergleichen; ob die Zahlenbeispiele in Text und Lösungen zu den Programmausgaben passen, habe ich nicht Zeile für Zeile verglichen.
- **Stunden:** Dauer je Modul laut Modulübersicht (8 oder 10 Stunden, zusammen 110 Stunden). Die Einzelwerte der 9 Lerneinheiten ergeben 8,1 oder 9,9 Stunden je Modul (zusammen 109,8 Stunden); die Quelle nennt die Rundung im Modulkopf. Beides ist in den Modul-READMEs angegeben.
- **Priorität:** 1 für Modul 01 bis 08, 2 für Modul 09 bis 12 (laut Modulkopf der Quelle).
- Das Quellenverzeichnis trennt tatsächlich abgerufene (18 Einträge) und weiterführende Quellen; sie geben Stand und Verwendung an.

## Module

| Modul | Thema | Dauer laut Übersicht | Summe der Einzelwerte | Prio | Codeblöcke |
|---|---|---|---|---|---|
| [01](modul-01-eu-tech-gruendung-strategie-marktvalidierung/) | EU-Tech-Gründung, Strategie und Marktvalidierung | 8 h | 8,1 h | 1 | 11 |
| [02](modul-02-rechtsform-standortwahl-eu-gruendungsverfahren/) | Rechtsform, Standortwahl und EU-Gründungsverfahren | 8 h | 8,1 h | 1 | 12 |
| [03](modul-03-geschaeftsmodell-pricing-go-to-market/) | Geschäftsmodell, Pricing und Go-to-Market | 10 h | 9,9 h | 1 | 12 |
| [04](modul-04-produktmanagement-mvp-technologiearchitektur/) | Produktmanagement, MVP und Technologiearchitektur | 10 h | 9,9 h | 1 | 12 |
| [05](modul-05-software-engineering-devops-plattformbetrieb/) | Software Engineering, DevOps und Plattformbetrieb | 10 h | 9,9 h | 1 | 13 |
| [06](modul-06-datenschutz-cybersecurity-ai-tech-regulierung/) | Datenschutz, Cybersecurity und AI-Tech-Regulierung | 10 h | 9,9 h | 1 | 12 |
| [07](modul-07-finanzen-buchhaltung-steuern-controlling/) | Finanzen, Buchhaltung, Steuern und Controlling | 8 h | 8,1 h | 1 | 12 |
| [08](modul-08-funding-grants-investor-readiness-cap-table/) | Funding, Grants, Investor Readiness und Cap Table | 10 h | 9,9 h | 1 | 12 |
| [09](modul-09-vertrieb-marketing-customer-success-wachstum/) | Vertrieb, Marketing, Customer Success und Wachstum | 10 h | 9,9 h | 2 | 12 |
| [10](modul-10-people-organisation-founder-operations/) | People, Organisation und Founder Operations | 8 h | 8,1 h | 2 | 12 |
| [11](modul-11-legal-operations-ip-vertraege-risikomanagement/) | Legal Operations, IP, Verträge und Risikomanagement | 8 h | 8,1 h | 2 | 12 |
| [12](modul-12-skalierung-internationalisierung-exit-resilienz/) | Skalierung, Internationalisierung, Exit und Resilienz | 10 h | 9,9 h | 2 | 12 |

Priorität: 1 = höchste.

## Lizenz

- **Code** (Beispieldateien und Skripte, falls das Repository solche enthält): [MIT-Lizenz](LICENSE)
- **Texte** (die Modul-READMEs, die Kapitel `skript.md` und die Dateien unter `docs/`): [CC BY 4.0](LICENSE-DOCS.md)
- Genannte Organisationen, Programme und Rechtsvorschriften (zum Beispiel EU-Kommission, EIC, WKO, GitHub) gehören ihren jeweiligen Inhabern; dieses Repository steht in keiner Verbindung zu ihnen.

Autor: AnsibleArtisan4711
