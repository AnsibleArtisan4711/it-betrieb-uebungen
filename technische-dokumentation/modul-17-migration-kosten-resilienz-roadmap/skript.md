# Modul 17 - Migration, Kosten, Resilienz und Roadmap

> **Hinweis zu diesem Kapitel:** Das ist das Kapitel des Skripts „Technische Dokumentation und Dokumentations-Governance“, aus der LaTeX-Quelle in Markdown umgewandelt (Text und Listings unverändert, farbige Boxen als Zitatblöcke mit fettem Titel, Tabellen als Markdown-Tabellen, Übungsaufgaben und Lösungen als Absätze). Die Lerneinheiten sind wie in der Quelle nach Modul nummeriert (17.1 bis 17.15), danach folgen „Übungsaufgaben“ (8 Aufgaben) und „Lösungen und Erläuterungen“. Die Sprachangabe der Codeblöcke ist in der Quelle nur für Python und Bash gesetzt; die übrigen Blöcke sind hier nach ihrem Inhalt als `python`, `yaml`, `markdown`, `bash` oder `text` ausgezeichnet, der Inhalt selbst ist unverändert. **Prüfstand der Beispiele für dieses Repository:** Die Python-Beispiele wurden auf Syntax geprüft; welche Beispiele ausgeführt wurden und welche zusätzlich PyYAML brauchen, steht in der [README des Repositories](../README.md). Übersicht zum Modul: [README](README.md).

**Dauer:** 15 Stunden | **Priorität:** 2 | **Lerneinheiten:** 15

| **Nr.** | **Lerneinheit**              | **Dauer (h)** | **Prio** |
|--------:|:-----------------------------|--------------:|---------:|
|       1 | Ist-Analyse                  |             1 |        1 |
|       2 | Dokumentationsmigration      |             1 |        1 |
|       3 | Kostenmodell                 |             1 |        1 |
|       4 | Tool-Konsolidierung          |             1 |        1 |
|       5 | Archivierung                 |             1 |        1 |
|       6 | BCDR für Dokumentation       |             1 |        2 |
|       7 | Kontinuierliche Verbesserung |             1 |        2 |
|       8 | 30-60-90-Tage-Roadmap        |             1 |        2 |
|       9 | Lab Dokumentationsstrategie  |             1 |        1 |
|      10 | Lab Taxonomie erstellen      |             1 |        1 |
|      11 | Lab RACI Matrix              |             1 |        1 |
|      12 | Lab Template entwickeln      |             1 |        1 |
|      13 | Lab Review Prozess           |             1 |        1 |
|      14 | Lab Audit Checkliste         |             1 |        2 |
|      15 | Prüfungsnahe Aufgaben        |             1 |        2 |
|         | **Summe**                    |        **15** |          |

## 17.1 Ist-Analyse

Jede Veränderung der Dokumentationslandschaft beginnt mit der Frage, was eigentlich vorhanden ist. Die Ist-Analyse ist die systematische Bestandsaufnahme: Welche Dokumente gibt es, wo liegen sie, wem gehören sie, wie alt sind sie, wie oft werden sie genutzt und wie viel davon ist doppelt oder überholt? Sie ist die Grundlage für Migration, Kostenrechnung, Werkzeugentscheidungen und Roadmap, die in diesem Modul folgen. Wer sie überspringt, plant auf Annahmen und erlebt Überraschungen, sobald die ersten Daten umziehen.

Eine abgerufene Praxisquelle zu SharePoint-Migrationen (2toLead, ein Beratungsunternehmen) fasst die Problematik mit dem Begriff *ROT* zusammen: redundante, veraltete (englisch obsolete) und triviale Inhalte. Redundant sind Dubletten ohne eigenen Wert, veraltet sind abgelaufene Richtlinien oder überholte Fassungen, trivial sind Arbeitskopien ohne fachliche oder rechtliche Bedeutung. Die Quelle nennt ROT den größten verborgenen Kostenfaktor einer Migration, weil er Speicher, Berechtigungsplanung und Migrationsaufwand erhöht. Als ersten Schritt empfiehlt sie ein Audit vor der Migration, das für jedes Objekt Größe, Owner, Vertraulichkeit, letzten Zugriff und Versionstiefe erfasst und für jedes entscheidet: migrieren, archivieren oder neu aufbauen. Die Quelle stammt von einem Dienstleister; sie ist als Praxisbeitrag zu lesen, nicht als Standard.

Das Ergebnis der Ist-Analyse ist kein Bericht, sondern ein *Inventar*: eine Tabelle mit einer Zeile je Dokument und festen Spalten. Aus ihr lassen sich die wichtigen Fragen beantworten. Das folgende Skript wertet ein solches Inventar aus. Es fasst je Ablageort zusammen, wie viele Dokumente es gibt, wie viele ohne Owner sind, wie viele länger als zwei Jahre nicht geändert wurden und wie viele in den letzten 90 Tagen nie aufgerufen wurden, und es sucht Dubletten über den normalisierten Titel.

```text
ablage;titel;owner;letzte_aenderung;aufrufe_90d
SharePoint;Passwortrichtlinie;Leitung IT;2026-05-01;40
SharePoint;Passwortrichtlinie (Kopie);;2023-02-01;0
SharePoint;Vertrag Dienstleister A;Einkauf;2025-11-01;3
Wiki;Runbook Neustart;Team Betrieb;2026-09-10;240
Wiki;runbook neustart;;2022-04-01;1
Wiki;Notizen 2021;;2021-06-01;0
Repo;API Authentifizierung;Entwicklung;2026-10-01;120
Laufwerk;Netzplan 2019;;2019-08-01;0
Laufwerk;Kantinenplan;;2018-03-01;0
```

```python
import csv
from collections import defaultdict
from datetime import date

HEUTE = date(2026, 10, 28)
zeilen = list(csv.DictReader(open("ist.csv", encoding="utf-8"), delimiter=";"))
je_ablage = defaultdict(list)
for z in zeilen:
    je_ablage[z["ablage"]].append(z)

for ablage, liste in je_ablage.items():
    ohne_owner = sum(1 for z in liste if not z["owner"])
    alt = sum(1 for z in liste if (HEUTE - date.fromisoformat(z["letzte_aenderung"])).days > 730)
    ungenutzt = sum(1 for z in liste if int(z["aufrufe_90d"]) == 0)
    print(f"{ablage}: {len(liste)} Dokumente, ohne Owner {ohne_owner}, älter als 2 Jahre {alt}, ungenutzt {ungenutzt}")

titel = defaultdict(list)
for z in zeilen:
    schluessel = z["titel"].lower().replace(" (kopie)", "")
    titel[schluessel].append(z["ablage"])
for schluessel, orte in titel.items():
    if len(orte) > 1:
        print(f"Dublette: '{schluessel}' in {', '.join(orte)}")
```

Das Skript gruppiert zuerst die Zeilen nach Ablageort und zählt für jede Gruppe die drei Auffälligkeiten. Im zweiten Teil bildet es einen Vergleichsschlüssel aus dem Titel (Kleinbuchstaben, ohne den Zusatz „(Kopie)“) und meldet Schlüssel, die mehrfach vorkommen. Das Ergebnis für die neun Beispielzeilen: SharePoint hat drei Dokumente (eines ohne Owner, eines älter als zwei Jahre, eines ungenutzt), das Wiki drei (zwei ohne Owner, zwei alt, eines ungenutzt), das Repository eines ohne Auffälligkeit, das Laufwerk zwei, die alle drei Auffälligkeiten tragen. Gemeldet werden außerdem zwei Dubletten: die Passwortrichtlinie und das Runbook Neustart, jeweils zweimal am selben Ort (SharePoint beziehungsweise Wiki). Dublette heißt hier nur „gleicher Titel“; ob der Inhalt gleich ist, muss geprüft werden, und die Bewertung, welche Fassung gilt, ist eine fachliche Entscheidung. Das Laufwerk fällt mit Kantinenplan und Netzplan als Archiv- oder Löschkandidat auf, während das Repository die gesündeste Ablage ist.

Typische Fehler: Die Analyse erfasst nur die offiziellen Ablageorte und übersieht Laufwerke, Postfächer und Chat-Dateien; sie wird von Hand und einmalig erstellt; Kriterien für „veraltet“ fehlen, sodass jede Person anders urteilt; man analysiert das Werkzeug, nicht den Inhalt; die Daten werden erhoben, aber nie in Entscheidungen übersetzt.

| **Falsch**                                          | **Richtig**                                                                                                                                    |
|:----------------------------------------------------|:-----------------------------------------------------------------------------------------------------------------------------------------------|
| „Wir haben etwa 5 000 Dokumente, davon vieles alt.“ | Inventar mit einer Zeile je Dokument, Kennzahlen je Ablage und eine Entscheidung je Objekt: migrieren, archivieren, neu aufbauen oder löschen. |

Im Projekt lohnt sich die Automatisierung der Datenerhebung, weil das Inventar später für Kennzahlen (Modul 16) und Pflege (Modul 14 und 15) weiter genutzt wird.

## 17.2 Dokumentationsmigration

Eine Dokumentationsmigration überführt Inhalte aus einem System in ein anderes: vom Dateilaufwerk ins Wiki, von einem alten Wiki in eine neue Plattform, von Word-Dateien in Markdown. Gründe sind veraltete Werkzeuge, Konsolidierung (nächster Abschnitt), das Ende eines Produkts (Modul 12 nannte die Terminplanung zu Atlassian Data Center) oder ein neues Governance-Modell. Die technische Umwandlung ist dabei nur der kleinste Teil. Der größere Teil ist Entscheidung, Bereinigung und Prüfung.

Ein tragfähiger Ablauf folgt den Phasen, die auch die abgerufene Praxisquelle beschreibt: erst Audit und Klassifizierung (was wandert, was wird archiviert, was wird neu geschrieben), dann die Gestaltung der Zielstruktur mit Berechtigungen, Metadaten und Namensschema, bevor eine einzige Datei bewegt wird, danach die Migration in Wellen (zuerst eine Pilotgruppe, dann nach Priorität und Risiko), und zum Schluss Gesundheitsprüfungen: tote Verweise, verwaiste Berechtigungen, Inhalte ohne Owner. Eine Welle ist wichtig, weil Fehler im kleinen Maßstab günstig sind. Nach derselben Quelle dauern Unternehmensmigrationen häufig drei bis neun Monate, und Wellen ermöglichen erste Ergebnisse in den ersten Wochen; das sind Erfahrungswerte eines Anbieters, keine Regeln.

Entscheidend für die Qualität ist die *Prüfung nach der Umwandlung*. Automatische Konverter erhalten die Struktur meist gut, verlieren aber leicht Feinheiten: Tabellen mit verbundenen Zellen, Kommentare, Änderungsverfolgung, eingebettete Objekte. Das folgende Beispiel führt eine Umwandlung mit Pandoc durch und vergleicht Kennzahlen vor und nach der Umwandlung. Ausgangspunkt ist eine Markdown-Datei, aus der ich eine Word-Datei erzeugt und diese wieder in Markdown zurückverwandelt habe; das simuliert den Weg von Word in ein Markdown-Zielsystem.

```bash
pandoc quelle.md -o alt.docx
pandoc alt.docx -t gfm -o neu.md
python3 migration_pruefen.py quelle.md neu.md
```

```python
import re, sys
from pathlib import Path

def kennzahlen(text):
    return {"Überschriften": len(re.findall(r"^#{1,6} ", text, re.M)),
            "Tabellenzeilen": len(re.findall(r"^\|", text, re.M)),
            "Verweise": len(re.findall(r"\]\(http", text)),
            "Listenpunkte": len(re.findall(r"^\s*(?:[-*]|\d+\.) ", text, re.M))}

vorher = kennzahlen(Path(sys.argv[1]).read_text(encoding="utf-8"))
nachher = kennzahlen(Path(sys.argv[2]).read_text(encoding="utf-8"))
for name in vorher:
    zeichen = "ok" if vorher[name] == nachher[name] else "ABWEICHUNG"
    print(f"{name}: vorher {vorher[name]}, nachher {nachher[name]} - {zeichen}")
```

Die Quelldatei enthielt drei Überschriften, drei Listenpunkte (einen Aufzählungspunkt und zwei nummerierte), eine Tabelle mit Kopfzeile, Trennzeile und einer Datenzeile (drei Tabellenzeilen) und einen Verweis. Das Skript zählt diese Strukturelemente vor und nach der Umwandlung und meldet für alle vier Kennzahlen Übereinstimmung. Die Datei `neu.md` ist dabei nicht zeichengleich: Pandoc setzt die Tabelle mit festen Spaltenbreiten und rückt nummerierte Listen mit zwei Leerzeichen nach dem Punkt ein. Das Beispiel zeigt die Methode: Man prüft nicht, ob der Text identisch ist, sondern ob *messbare Strukturmerkmale* erhalten blieben. Die Grenze ist ebenso deutlich: Eine Übereinstimmung der Zahlen beweist nicht, dass Inhalte unbeschädigt sind. Für jede Welle gehört daher eine Stichprobe von Hand dazu, und der Vergleich der Zahlen weist auf Ausfälle hin, schließt sie aber nicht aus.

Typische Fehler: Man migriert alles, statt vorher zu bereinigen, und nimmt den Müll mit; Zielstruktur und Berechtigungen werden erst nach der Migration überlegt; es gibt keinen Rückweg, falls die Welle misslingt; Verweise zwischen Dokumenten werden nicht umgeschrieben und zeigen ins alte System; die Altsysteme werden nie abgeschaltet, sodass es zwei Fassungen gibt.

| **Falsch**                                                                            | **Richtig**                                                                                                                               |
|:--------------------------------------------------------------------------------------|:------------------------------------------------------------------------------------------------------------------------------------------|
| Alle 5 000 Dokumente werden an einem Wochenende per Skript ins neue System geschoben. | Bereinigter Bestand, Pilotwelle mit Prüfung, weitere Wellen nach Priorität, Altsystem schreibgeschützt und nach der Abnahme abgeschaltet. |

Im Projekt legt man vor dem Start fest, was „fertig“ heißt: Kennzahlen stimmen, Stichprobe bestanden, Verweise funktionieren, Owner sind eingetragen. Erst dann wird das Altsystem auf schreibgeschützt gesetzt und nach einer vereinbarten Frist abgeschaltet.

## 17.3 Kostenmodell

Dokumentation verursacht Kosten, auch wenn sie in keinem Budget als eigene Zeile steht: Lizenzen, Betrieb der Plattformen, vor allem aber die Arbeitszeit für Erstellung, Pflege, Suche und Einarbeitung. Ein Kostenmodell macht sie sichtbar und erlaubt Vergleiche: Was kostet der heutige Zustand, was ein Zielzustand, und ab wann rechnet sich die Veränderung? Es ist ein Entscheidungsinstrument und keine Prognose; seine Stärke ist die Nachvollziehbarkeit der Annahmen.

Man unterscheidet *einmalige Kosten* (Migration, Einrichtung, Schulung) und *laufende Kosten* (Lizenzen, Administration, Pflege). Die Gesamtkosten über einen Betrachtungszeitraum, oft drei bis fünf Jahre, heißen im Fachjargon Total Cost of Ownership (TCO, allgemeines Fachwissen). Dazu kommen schwerer zu fassende *Nutzenseiten*: gesparte Suchzeit, schnellere Einarbeitung, weniger Fehler und Rückfragen, bessere Auditergebnisse. Sie werden selten exakt in Euro ausgedrückt; man kann sie mit Annahmen schätzen und als Spannen ausweisen, muss aber sagen, dass sie geschätzt sind.

Das folgende Skript rechnet zwei Szenarien durch, den heutigen Zustand und einen Zielzustand: jährliche Kosten aus Lizenz plus Arbeitsstunden mal Stundensatz, Gesamtkosten über den Zeitraum und die Amortisationszeit der einmaligen Kosten aus der jährlichen Ersparnis. Alle Zahlen sind frei gewählte Beispielwerte.

```yaml
stundensatz: 70
jahre: 3
szenarien:
  heute:
    lizenz_pro_jahr: 6000
    admin_stunden_pro_jahr: 120
    pflege_stunden_pro_jahr: 600
    einmalig: 0
  ziel:
    lizenz_pro_jahr: 9000
    admin_stunden_pro_jahr: 40
    pflege_stunden_pro_jahr: 450
    einmalig: 18000
```

```python
import yaml

d = yaml.safe_load(open("kosten.yaml", encoding="utf-8"))
satz, jahre = d["stundensatz"], d["jahre"]
gesamt = {}
for name, s in d["szenarien"].items():
    pro_jahr = s["lizenz_pro_jahr"] + (s["admin_stunden_pro_jahr"] + s["pflege_stunden_pro_jahr"]) * satz
    gesamt[name] = s["einmalig"] + pro_jahr * jahre
    print(f"{name}: {pro_jahr:.0f} Euro pro Jahr, {gesamt[name]:.0f} Euro über {jahre} Jahre")
ersparnis_jahr = (d["szenarien"]["heute"]["lizenz_pro_jahr"] + (d["szenarien"]["heute"]["admin_stunden_pro_jahr"] + d["szenarien"]["heute"]["pflege_stunden_pro_jahr"]) * satz) \
    - (d["szenarien"]["ziel"]["lizenz_pro_jahr"] + (d["szenarien"]["ziel"]["admin_stunden_pro_jahr"] + d["szenarien"]["ziel"]["pflege_stunden_pro_jahr"]) * satz)
if ersparnis_jahr > 0:
    print(f"Amortisation nach {d['szenarien']['ziel']['einmalig'] / ersparnis_jahr:.1f} Jahren")
else:
    print("Keine laufende Ersparnis: Zielszenario rechnet sich nicht über Kosten allein")
```

Die Rechnung für den heutigen Zustand: 6 000 Euro Lizenz plus 720 Stunden zu 70 Euro, also 56 400 Euro pro Jahr und 169 200 Euro über drei Jahre. Für das Ziel: 9 000 Euro Lizenz plus 490 Stunden zu 70 Euro, also 43 300 Euro pro Jahr; mit 18 000 Euro einmaligen Kosten ergeben sich 147 900 Euro über drei Jahre. Die jährliche Ersparnis beträgt 13 100 Euro, die Amortisation erfolgt nach 1,4 Jahren. Das Beispiel zeigt eine typische Struktur: Die Lizenz wird teurer, die Arbeitszeit sinkt deutlich, und die Arbeitszeit ist der größere Posten. Wer nur die Lizenzkosten vergleicht, würde die falsche Entscheidung treffen. Zugleich zeigt es die Schwäche: Das Ergebnis hängt an der Annahme, dass die Pflegezeit tatsächlich um 150 Stunden sinkt; diese Annahme muss begründet oder in einem Pilot geprüft werden.

Typische Fehler: Man vergleicht nur Lizenzpreise; die Arbeitszeit der Fachbereiche bleibt außen vor; Nutzenannahmen werden als Tatsachen dargestellt; Einmalkosten werden vergessen (Schulung, Parallelbetrieb); man rechnet mit einem Szenario statt mit einer Spanne; Kosten des Nichtstuns (Auditbefunde, Fehler, Einarbeitungszeit) bleiben unsichtbar.

| **Falsch**                                                                   | **Richtig**                                                                                                                        |
|:-----------------------------------------------------------------------------|:-----------------------------------------------------------------------------------------------------------------------------------|
| „Plattform B kostet 3 000 Euro mehr Lizenz im Jahr, also lehnen wir sie ab.“ | Gesamtkosten über drei Jahre mit Arbeitszeit, Einmalkosten und Annahmen; Ergebnis als Spanne (optimistisch, erwartet, vorsichtig). |

Im Projekt rechnet man pessimistisch und optimistisch und zeigt beide. Entscheidungsträger vertrauen einer Rechnung mit offengelegten Annahmen eher als einer mit einem einzigen glatten Ergebnis.

## 17.4 Tool-Konsolidierung

Nach Jahren des Wachstums haben viele Organisationen mehrere Werkzeuge, die ähnliche Aufgaben erfüllen. Tool-Konsolidierung bedeutet, diese Zahl zu verringern: Funktionen zusammenzuführen, Dubletten abzuschalten und für jede Dokumentart ein maßgebliches System festzulegen (Modul 12, Tool-Landschaft). Sie senkt Lizenz- und Betriebskosten, vereinfacht die Suche und die Governance und reduziert die Zahl der Systeme, deren Berechtigungen, Aufbewahrung und Sicherheit man verwalten muss. Sie hat aber auch Kosten: Migration, Schulung, Widerstand der Nutzer und das Risiko, Funktionen zu verlieren, die ein Team braucht.

Der Weg zu einer begründeten Entscheidung führt über *Kriterien und Gewichte*. Man legt fest, was die Plattform leisten muss (zum Beispiel Suche, Berechtigungen, Aufbewahrung, Bedienbarkeit, Kosten), gewichtet die Kriterien nach ihrer Bedeutung für die Organisation und bewertet jedes Werkzeug je Kriterium auf einer einfachen Skala. Das Ergebnis ist eine gewichtete Summe. Wichtig ist, die Gewichte *vor* der Bewertung festzulegen, damit sie nicht rückwirkend zugunsten eines Wunschkandidaten verschoben werden.

```yaml
gewichte: {suche: 3, berechtigungen: 3, aufbewahrung: 2, bedienung: 2, kosten: 1}
tools:
  Wiki A: {suche: 4, berechtigungen: 3, aufbewahrung: 2, bedienung: 5, kosten: 4}
  Plattform B: {suche: 3, berechtigungen: 5, aufbewahrung: 5, bedienung: 3, kosten: 2}
  Altes Wiki: {suche: 1, berechtigungen: 1, aufbewahrung: 1, bedienung: 3, kosten: 5}
```

```python
import yaml

d = yaml.safe_load(open("bewertung_tools.yaml", encoding="utf-8"))
g = d["gewichte"]
summe = sum(g.values())
for name, w in sorted(d["tools"].items(), key=lambda t: -sum(g[k] * t[1][k] for k in g)):
    punkte = sum(g[k] * w[k] for k in g) / summe
    schwach = [k for k in g if w[k] <= 2]
    print(f"{name}: {punkte:.2f} von 5" + (f", schwach bei: {', '.join(schwach)}" if schwach else ""))
```

Die Gewichte sind hier drei für Suche und Berechtigungen, zwei für Aufbewahrung und Bedienung, eins für die Kosten; die Skala geht von eins (schlecht) bis fünf (sehr gut), wobei bei den Kosten fünf „günstig“ bedeutet. Das Skript sortiert nach der gewichteten Summe und nennt außerdem Kriterien mit höchstens zwei Punkten als Schwächen. Das Ergebnis: Plattform B erreicht 3,82 von 5 und ist bei den Kosten schwach; Wiki A erreicht 3,55 und ist bei der Aufbewahrung schwach; das alte Wiki erreicht 1,73 mit Schwächen bei Suche, Berechtigungen und Aufbewahrung. Der Abstand zwischen B und A ist gering und hängt an den Gewichten: Würde man die Aufbewahrung geringer gewichten, könnte A vorn liegen. Deshalb gehört zu jeder Bewertung eine *Sensitivitätsprüfung*: Man ändert die Gewichte und prüft, ob die Rangfolge hält. Die Punktzahl ist eine Entscheidungshilfe, die Entscheidung bleibt eine fachliche, und Ausschlusskriterien (zum Beispiel Datenstandort, Plattformstrategie) gehören vor die Rechnung.

Typische Fehler: Man konsolidiert aus Kostendruck, ohne Anforderungen zu klären; Gewichte werden nach dem Ergebnis angepasst; das Altsystem läuft nach der Migration weiter; man vergisst die Menschen: Schulung und Kommunikation fehlen; Funktionen, die ein einzelnes Team braucht, werden übersehen und führen zu Schatten-Lösungen.

| **Falsch**                                                                     | **Richtig**                                                                                             |
|:-------------------------------------------------------------------------------|:--------------------------------------------------------------------------------------------------------|
| Entscheidung für das Werkzeug, das die Geschäftsleitung von einer Messe kennt. | Anforderungen und Gewichte vorab, Bewertung durch ein Team, Sensitivitätsprüfung, Pilot mit zwei Teams. |

Im Projekt hat sich bewährt, vor dem Vergleich die *Muss-Kriterien* zu klären (Datenstandort, Berechtigungskonzept, Exportfähigkeit) und erst danach zu bewerten. Die Exportfähigkeit ist besonders wichtig, damit die Entscheidung in fünf Jahren nicht wieder alternativlos ist.

## 17.5 Archivierung

In Modul 10 wurde die technische Seite der Archivierung beschrieben, in Modul 14 die Entscheidung, ob ein Dokument archiviert, behalten oder gelöscht wird, und in Modul 13 die rechtlichen Grundlagen der Aufbewahrung. Dieser Abschnitt behandelt Archivierung als *Teil der Landschaftsplanung*: Wie bleibt ein Archiv über Jahre beherrschbar, und wie sorgt man dafür, dass Fristen tatsächlich zu Entscheidungen führen? Ein Archiv ohne Pflege wird zum Abfalleimer mit Vergangenheit: Alles ist noch da, niemand findet etwas, und Dokumente liegen weit über ihre Frist hinaus, was bei personenbezogenen Daten ein Problem sein kann (keine Rechtsberatung, siehe Modul 13).

Ein beherrschbares Archiv hat drei Eigenschaften. Es hat einen *Index*: eine Liste aller archivierten Dokumente mit Titel, Datum der Archivierung, Aufbewahrungsfrist, Grund und gegebenenfalls Sperre. Es hat *Termine*: Zu jedem Dokument ist das Fristende berechenbar, und eine regelmäßige Auswertung zeigt, was in den nächsten Monaten ansteht. Und es kennt *Sperren*: Dokumente, die wegen eines laufenden Verfahrens oder einer Prüfung nicht gelöscht werden dürfen (im Fachjargon Legal Hold), sind markiert und überstimmen jede Frist.

Das folgende Skript wertet einen Archivindex aus: Es berechnet je Dokument das Fristende aus dem Archivierungsdatum und der Aufbewahrungsdauer in Jahren und meldet, ob die Frist abgelaufen ist, bald endet (innerhalb von 90 Tagen) oder noch läuft; Sperren gehen vor.

```text
titel;archiviert_am;frist_jahre;legal_hold
Vertrag Dienstleister A;2021-03-01;10;nein
Netzplan 2019;2020-01-15;5;nein
Protokoll Sitzung 2018;2018-12-01;7;nein
Rechtsstreit Akte;2019-06-01;3;ja
Kantinenplan 2018;2019-01-10;1;nein
```

```python
import csv
from datetime import date

HEUTE = date(2026, 10, 28)
for z in csv.DictReader(open("archiv.csv", encoding="utf-8"), delimiter=";"):
    a = date.fromisoformat(z["archiviert_am"])
    ende = date(a.year + int(z["frist_jahre"]), a.month, a.day)
    tage = (ende - HEUTE).days
    if z["legal_hold"] == "ja":
        urteil = "SPERRE (Legal Hold) - nicht löschen"
    elif tage < 0:
        urteil = f"Frist seit {-tage} Tagen abgelaufen - Löschung prüfen"
    elif tage <= 90:
        urteil = f"Frist endet in {tage} Tagen"
    else:
        urteil = f"aufbewahren bis {ende}"
    print(f"{z['titel']}: {urteil}")
```

Das Ergebnis: Der Vertrag läuft bis zum 1. März 2031; der Netzplan 2019 ist seit 651 Tagen über seine Frist, das Sitzungsprotokoll seit 331 Tagen, der Kantinenplan seit 2 483 Tagen; die Rechtsstreit-Akte ist gesperrt, obwohl ihre Frist eigentlich abgelaufen wäre. Das Skript zeigt zugleich eine Gefahr der Beispielrechnung: Der 29. Februar als Archivierungsdatum würde bei der Fristberechnung über das Jahr zu einem Fehler führen, weil es das Datum im Zieljahr nicht gibt; ein echtes Archivwerkzeug muss das behandeln. Und die Meldung „Löschung prüfen“ ist ausdrücklich keine Aufforderung zu löschen: Vor einer Löschung sind Sperren, andere Aufbewahrungsgründe und die Freigabe des Owners zu prüfen (Modul 14, Archivierungsentscheidung).

Typische Fehler: Archiv ohne Index; keine Fristen oder eine einheitliche Frist für alles; Archivierung bedeutet „in einen Ordner schieben“; die Löschung wird nie durchgeführt; Sperren existieren nur im Kopf der Rechtsabteilung; Archivierte Dokumente sind weiter im allgemeinen Suchindex und stören die Suche.

| **Falsch**                                                                     | **Richtig**                                                                                                                                |
|:-------------------------------------------------------------------------------|:-------------------------------------------------------------------------------------------------------------------------------------------|
| Ordner „Archiv“ auf dem Laufwerk mit 10 000 Dateien ohne Liste und ohne Frist. | Archivindex mit Fristen und Sperren, vierteljährliche Auswertung der anstehenden Fristenden, Löschung nur nach Freigabe und mit Protokoll. |

Im Projekt trennt man das Archiv von der aktiven Ablage (eigener Bereich, aus der normalen Suche ausgenommen, mit eingeschränktem Zugriff) und plant die Fristenauswertung als wiederkehrenden Termin ein.

## 17.6 BCDR für Dokumentation

BCDR steht für Business Continuity and Disaster Recovery, auf Deutsch Betriebskontinuität und Wiederherstellung nach Katastrophen. Der Gedanke: Was passiert mit der Dokumentation, wenn das Wiki ausfällt, das Laufwerk verschlüsselt wird oder der Cloud-Dienst nicht erreichbar ist? Und was passiert mit dem *Betrieb*, wenn gerade dann die Notfallanleitungen nicht verfügbar sind? Die Dokumentation ist bei einem Ausfall oft genau das, was man am dringendsten braucht, und genau das, was am schlechtesten verfügbar ist, wenn sie im selben System liegt wie der Ausfall.

Zwei Kenngrößen bestimmen die Anforderungen. Nach einer abgerufenen Darstellung von Advisera ist das *Recovery Time Objective* (RTO) die maximale Zeit nach einem Ausfall, innerhalb derer der Betrieb wieder aufgenommen sein muss; ein kürzeres RTO erfordert mehr Ressourcen. Das *Recovery Point Objective* (RPO) ist der akzeptable Datenverlust; es bestimmt, wie oft gesichert werden muss, ein RPO von vier Stunden verlangt mindestens alle vier Stunden ein Backup. Beide werden durch eine Business-Impact-Analyse festgelegt, sind voneinander unabhängig und können je System verschieden sein: Ein selten geändertes Dokument verträgt einen größeren Datenverlust als eine tägliche Betriebsübersicht. Für die Dokumentation heißt das, Kategorien zu bilden (Notfallpläne, Betriebsanleitungen, Wiki-Inhalte) und für jede RTO und RPO festzulegen.

> **Ergänzung aus der Nachrecherche**
>
> Zur Sicherungsstrategie nach einer abgerufenen Darstellung von NinjaOne: Die 3-2-1-Regel empfiehlt drei Kopien der Daten auf zwei verschiedenen Medientypen, davon eine an einem anderen Standort; die Quelle nennt, dass die US-Behörde CISA sie empfehle. Die Variante 3-2-1-1-0 ergänzt eine unveränderliche oder offline gehaltene Kopie (gegen Verschlüsselung durch Schadsoftware) und die Anforderung, dass Sicherungen fehlerfrei geprüft werden. Die Quelle betont, dass ungetestete Sicherungen ein falsches Sicherheitsgefühl erzeugen und Kopien in getrennten Ausfallbereichen liegen sollten. Es handelt sich um die Darstellung eines Anbieters; die Empfehlung der Behörde habe ich nicht an der Primärquelle geprüft. (Abruf 28.10.2026, siehe Quellenverzeichnis.)

Das folgende Skript prüft für drei Dokumentationskategorien, ob das Sicherungsintervall zum RPO passt, ob die 3-2-1-Regel erfüllt ist und ob ein Wiederherstellungstest in den letzten zwölf Monaten stattfand.

```text
kategorie;rpo_stunden;backup_intervall_stunden;kopien;medien;extern;letzter_restore_test
Notfallplan;24;24;3;2;ja;2026-08-01
Runbooks;24;168;2;1;nein;2025-01-10
Wiki-Inhalte;8;12;3;2;ja;
```

```python
import csv
from datetime import date

HEUTE = date(2026, 10, 28)
for z in csv.DictReader(open("bcdr.csv", encoding="utf-8"), delimiter=";"):
    b = []
    if int(z["backup_intervall_stunden"]) > int(z["rpo_stunden"]):
        b.append(f"Backup-Intervall {z['backup_intervall_stunden']} h länger als RPO {z['rpo_stunden']} h")
    if int(z["kopien"]) < 3 or int(z["medien"]) < 2 or z["extern"] != "ja":
        b.append("3-2-1-Regel nicht erfüllt")
    if not z["letzter_restore_test"]:
        b.append("nie getestet")
    elif (HEUTE - date.fromisoformat(z["letzter_restore_test"])).days > 365:
        b.append("Restore-Test älter als ein Jahr")
    print(f"{z['kategorie']}: " + ("; ".join(b) or "in Ordnung"))
```

Das Ergebnis: Die Notfallpläne sind in Ordnung; die Betriebsanleitungen (Runbooks) haben ein wöchentliches Backup bei einem RPO von 24 Stunden, nur zwei Kopien auf einem Medium ohne externen Standort und einen Wiederherstellungstest, der länger als ein Jahr zurückliegt; die Wiki-Inhalte werden alle zwölf Stunden gesichert bei einem RPO von acht Stunden und wurden nie getestet. Auffällig ist, dass ausgerechnet die Betriebsanleitungen am schlechtesten abschneiden. Das Skript prüft nur die dokumentierten Angaben; ob die Sicherung wirklich funktioniert, zeigt allein der Wiederherstellungstest, den man tatsächlich durchführen muss.

Eine Besonderheit der Dokumentation ist die *Verfügbarkeit im Notfall*. Notfallpläne dürfen nicht nur im ausgefallenen System liegen: Eine ausgedruckte Fassung, eine Kopie auf einem getrennten, offline zugänglichen Medium und eine Verteilung an die Verantwortlichen sind Teil der Planung. Dabei muss man die Aktualität dieser Kopien im Blick behalten, damit im Ernstfall nicht die Anleitung von vor zwei Jahren in der Hand liegt.

Typische Fehler: Dokumentation liegt im selben System wie das, was ausfällt; Sicherungen werden nie wiederhergestellt; RTO und RPO sind nicht festgelegt oder gelten pauschal; Notfallpläne existieren nur online; Kopien im Notfall-Ordner sind veraltet.

| **Falsch**                                                                                | **Richtig**                                                                                                        |
|:------------------------------------------------------------------------------------------|:-------------------------------------------------------------------------------------------------------------------|
| Notfallplan für den Ausfall des Rechenzentrums liegt im Wiki, das im Rechenzentrum läuft. | Notfallplan zusätzlich offline und ausgedruckt, mit Prüfdatum, und jährlicher Wiederherstellungstest dokumentiert. |

Im Projekt führt man einmal jährlich eine Übung durch: Ein Dokument wird aus der Sicherung wiederhergestellt, und man prüft, ob ein Mitarbeiter ohne Zugriff aufs Wiki nach dem Notfallplan handeln kann. Die Lücken daraus fließen in den Verbesserungsbacklog (Modul 16).

## 17.7 Kontinuierliche Verbesserung

Kontinuierliche Verbesserung bedeutet, Dokumentation nicht als einmaliges Ergebnis, sondern als Prozess zu betrachten, der regelmäßig überprüft und verbessert wird. Der klassische Rahmen ist der Zyklus aus Planen, Durchführen, Prüfen und Handeln (englisch Plan, Do, Check, Act). Man wählt eine Verbesserung auf Basis einer Kennzahl oder eines Befunds, setzt sie um, prüft, ob die Kennzahl sich bewegt hat, und übernimmt, passt an oder verwirft die Maßnahme. Die Grundlagen dafür liefern die Kennzahlen, Audits und der Verbesserungsbacklog aus Modul 16; hier steht der Kreislauf selbst im Vordergrund.

Der häufigste Schwachpunkt ist der dritte Schritt, die *Wirkungsprüfung*. Viele Maßnahmen werden umgesetzt und nie überprüft; man weiß dann nicht, ob die Zeit gut investiert war. Das Prüfen braucht vor der Maßnahme einen Ausgangswert und danach einen Vergleichswert, mit klarer Festlegung, ab welcher Veränderung man von Wirkung spricht. Beachten Sie die Grenze: Ein Vorher-Nachher-Vergleich ohne Kontrollgruppe beweist keine Ursache, denn gleichzeitig können andere Einflüsse gewirkt haben; er liefert Hinweise. Deshalb sollte man Maßnahmen nacheinander einführen, nicht alle gleichzeitig, wo das möglich ist.

```text
massnahme;kennzahl;vorher;nachher;ziel_richtung
Synonymliste;top3_quote;0.55;0.68;hoch
Pflegetag;aktualitaetsquote;0.48;0.49;hoch
Titel überarbeitet;nulltreffer_quote;0.22;0.12;runter
Neue Vorlage;aktualitaetsquote;0.50;0.44;hoch
```

```python
import csv

for z in csv.DictReader(open("massnahmen.csv", encoding="utf-8"), delimiter=";"):
    v, n = float(z["vorher"]), float(z["nachher"])
    delta = n - v if z["ziel_richtung"] == "hoch" else v - n
    if delta >= 0.05:
        urteil = "wirksam"
    elif delta > -0.02:
        urteil = "keine erkennbare Wirkung"
    else:
        urteil = "VERSCHLECHTERUNG"
    print(f"{z['massnahme']} ({z['kennzahl']}): {v:.2f} -> {n:.2f}, Veränderung {delta:+.2f} - {urteil}")
```

Das Skript bringt jede Veränderung auf eine gemeinsame Richtung: Bei Kennzahlen, die steigen sollen (hoch), ist die Verbesserung nachher minus vorher, bei solchen, die sinken sollen (runter, etwa die Nulltreffer-Quote), vorher minus nachher. Das Ergebnis: Die Synonymliste hat die Top-3-Quote um 0,13 verbessert (wirksam); der Pflegetag brachte nur 0,01 (keine erkennbare Wirkung); die Überarbeitung der Titel senkte die Nulltreffer-Quote um 0,10 (wirksam); die neue Vorlage ist mit minus 0,06 eine Verschlechterung der Aktualitätsquote. Die Schwellen (0,05 für Wirkung, minus 0,02 als Grenze zur Verschlechterung) sind Beispielwerte. Der Befund zur neuen Vorlage ist besonders lehrreich: Eine gut gemeinte Maßnahme kann schaden, etwa wenn die Vorlage Pflichtfelder einführt, die das Prüfen erschweren. Ohne Wirkungsprüfung bliebe das unbemerkt.

Typische Fehler: Maßnahmen werden nie überprüft; man wertet jede Veränderung der Kennzahl als Erfolg der eigenen Maßnahme; man führt zehn Änderungen gleichzeitig ein; unwirksame Maßnahmen werden aus Gewohnheit fortgeführt; Verbesserungen werden nicht festgehalten, sodass das Wissen verloren geht.

| **Falsch**                                                     | **Richtig**                                                                                                                                               |
|:---------------------------------------------------------------|:----------------------------------------------------------------------------------------------------------------------------------------------------------|
| „Wir haben den Pflegetag eingeführt, jetzt wird alles besser.“ | Ausgangswert festgehalten, nach acht Wochen verglichen: kaum Veränderung, also Maßnahme anpassen (zum Beispiel Priorisierung der Dokumente) oder beenden. |

Im Projekt gehört zu jeder Maßnahme im Backlog eine Zeile „Woran erkennen wir den Erfolg, und wann prüfen wir?“. Das macht die Wirkungsprüfung zur Gewohnheit.

## 17.8 30-60-90-Tage-Roadmap

Eine Roadmap übersetzt Absichten in einen zeitlichen Ablauf. Die 30-60-90-Tage-Form teilt die ersten drei Monate einer Veränderung in drei Abschnitte mit eigenen Zielen: Im ersten Monat schafft man Klarheit (Bestandsaufnahme, Verantwortliche, Schnellerfolge), im zweiten legt man die Grundlagen (Standards, Prozesse, Werkzeuge), im dritten setzt man um und misst. Der Vorteil dieser kurzen Spanne ist, dass sie überschaubar bleibt und erste Ergebnisse zeigt, bevor die Aufmerksamkeit nachlässt. Sie ersetzt keine langfristige Strategie, sondern macht den Einstieg konkret.

Gute Roadmaps haben drei Eigenschaften. Sie sind *abhängigkeitsbewusst*: Man kann Verantwortliche nicht zuordnen, bevor der Bestand bekannt ist, und keine Review-Termine einrichten, bevor es Owner gibt. Sie sind *kapazitätsbewusst*: Die Stunden, die pro Phase zur Verfügung stehen, begrenzen, was hineinpasst. Und sie sind *überprüfbar*: Jede Aufgabe hat ein Ergebnis, an dem man das Ende erkennt. Das folgende Skript setzt die ersten beiden Eigenschaften um. Es liest Aufgaben mit Aufwand und Abhängigkeiten sowie die Kapazität je Phase, ordnet die Aufgaben mit dem Modul `graphlib` der Standardbibliothek in eine zulässige Reihenfolge und verteilt sie auf die Phasen.

```yaml
kapazitaet_h: {tag30: 30, tag60: 40, tag90: 40}
aufgaben:
  - {id: A1, titel: Bestandsaufnahme, aufwand: 20, nach: []}
  - {id: A2, titel: Owner zuordnen, aufwand: 10, nach: [A1]}
  - {id: A3, titel: Vorlagen festlegen, aufwand: 15, nach: [A1]}
  - {id: A4, titel: Review-Kalender einrichten, aufwand: 15, nach: [A2]}
  - {id: A5, titel: Archivierung Altbestand, aufwand: 25, nach: [A1, A2]}
  - {id: A6, titel: Kennzahlen erheben, aufwand: 20, nach: [A4]}
```

```python
import yaml
from graphlib import TopologicalSorter

d = yaml.safe_load(open("roadmap.yaml", encoding="utf-8"))
aufgaben = {a["id"]: a for a in d["aufgaben"]}
reihenfolge = list(TopologicalSorter({i: a["nach"] for i, a in aufgaben.items()}).static_order())

phasen = list(d["kapazitaet_h"].items())
p, rest = 0, phasen[0][1]
erledigt_in = {}
for i in reihenfolge:
    a = aufgaben[i]
    while p < len(phasen) and (a["aufwand"] > rest or any(erledigt_in.get(v, -1) >= p for v in a["nach"])):
        p += 1
        if p < len(phasen):
            rest = phasen[p][1]
    if p >= len(phasen):
        print(f"{i} {a['titel']}: passt nicht in die 90 Tage")
        continue
    rest -= a["aufwand"]
    erledigt_in[i] = p
    print(f"{phasen[p][0]}: {i} {a['titel']} ({a['aufwand']} h)")
```

Die Funktion `static_order` liefert eine Reihenfolge, in der jede Aufgabe nach ihren Voraussetzungen steht. In der Schleife wird die laufende Phase gewechselt, wenn der Aufwand nicht mehr in die verbleibende Kapazität passt oder eine Voraussetzung noch in derselben Phase erledigt würde; Letzteres erzwingt, dass abhängige Aufgaben in einer späteren Phase landen. Das Ergebnis: In den ersten 30 Tagen die Bestandsaufnahme (20 Stunden); in den Tagen 31 bis 60 die Zuordnung der Owner (10 Stunden) und die Vorlagen (15 Stunden); in den Tagen 61 bis 90 der Review-Kalender (15 Stunden) und die Archivierung des Altbestands (25 Stunden). Die Kennzahlen (20 Stunden) passen nicht mehr in die 90 Tage. Das Skript legt also sofort offen, dass der Plan zu groß ist, und macht die Entscheidung nötig: Kapazität erhöhen, eine Aufgabe verkleinern oder verschieben. Das Skript ist bewusst einfach; es verteilt gierig der Reihe nach und liefert keine optimale Planung, und eine Aufgabe, die mehr Aufwand hat als die größte Phase, wird nie platziert.

Typische Fehler: Die Roadmap ignoriert Abhängigkeiten und Kapazität; sie enthält zu viel für 90 Tage; Aufgaben haben keine überprüfbaren Ergebnisse; die Roadmap wird einmal erstellt und nie überprüft; es fehlen Schnellerfolge, sodass im ersten Monat nichts sichtbar wird.

| **Falsch**                                                                   | **Richtig**                                                                                                                                  |
|:-----------------------------------------------------------------------------|:---------------------------------------------------------------------------------------------------------------------------------------------|
| 90-Tage-Plan mit 20 Aufgaben, alle „in Q1“, ohne Reihenfolge und Zuständige. | Sechs bis acht Aufgaben mit Aufwand, Abhängigkeiten, Verantwortlichem und Ergebnis, auf drei Phasen verteilt und alle zwei Wochen überprüft. |

Im Projekt plant man im ersten Monat mindestens einen sichtbaren Schnellerfolg ein, zum Beispiel die Zuordnung von Ownern für die zehn meistgenutzten Dokumente. Er schafft Rückhalt für die größeren Schritte.

## 17.9 Lab Dokumentationsstrategie

Eine Dokumentationsstrategie hält auf wenigen Seiten fest, was die Organisation mit ihrer Dokumentation erreichen will, für wen sie geschrieben wird, was dazugehört und was nicht, wer verantwortlich ist und woran man den Erfolg misst. Sie verbindet die Themen der vorangegangenen Module: Ziele und Zielgruppen aus Modul 1 und 2, Rollen und Prozesse aus Modul 14, Kennzahlen aus Modul 16. Dieses Lab übt, eine Strategie so zu schreiben, dass sie überprüfbar ist, und sie maschinell auf typische Schwächen zu prüfen.

Die Aufgabe lautet: Schreiben Sie für ein fiktives Unternehmen (zum Beispiel einen Softwarehersteller mit Betriebs- und Entwicklungsteam) eine Strategie als YAML-Datei mit den Abschnitten Ziele, Zielgruppen, Umfang (mit Abgrenzung), Rollen und Kennzahlen. Die Form ist bewusst streng gewählt, weil sich dadurch automatisch prüfen lässt, ob jedes Ziel eine Zahl und einen Termin enthält und ob nichts Wesentliches fehlt. Die folgende Datei ist eine absichtlich fehlerhafte Fassung, an der das Prüfskript demonstriert wird.

```yaml
ziele:
  - Aktualitätsquote kritischer Dokumente bis 30.06.2027 auf mindestens 85 Prozent
  - besser dokumentieren
zielgruppen: [Betrieb, Entwicklung]
umfang: {enthalten: [Betriebsdokumentation, API-Dokumentation], ausgeschlossen: []}
rollen: {owner: Leitung Betrieb}
kpis: []
```

```python
import re, yaml

s = yaml.safe_load(open("strategie.yaml", encoding="utf-8"))
for ziel in s.get("ziele", []):
    messbar = bool(re.search(r"\d", ziel)) and bool(re.search(r"\d{4}", ziel))
    print(f"Ziel '{ziel[:40]}': " + ("messbar und terminiert" if messbar else "NICHT messbar/terminiert"))
for pflicht in ["zielgruppen", "umfang", "rollen", "kpis"]:
    if not s.get(pflicht):
        print(f"Abschnitt '{pflicht}' fehlt oder ist leer")
if s["umfang"] and not s["umfang"].get("ausgeschlossen"):
    print("Umfang: Abgrenzung (ausgeschlossen) fehlt")
```

Das Skript prüft jedes Ziel mit einem sehr einfachen Kriterium: Es muss eine Ziffer und eine vierstellige Zahl (als Jahresangabe) enthalten. Das ist eine grobe Näherung und kein Beweis für Qualität, aber sie trennt das erste Ziel (mit Zielwert und Datum) zuverlässig vom zweiten („besser dokumentieren“). Danach prüft es, ob die Pflichtabschnitte gefüllt sind, und meldet, dass der Abschnitt `kpis` leer ist und im Umfang die Abgrenzung fehlt. Die Ausgabe lautet: erstes Ziel messbar und terminiert, zweites Ziel nicht; Abschnitt `kpis` fehlt oder ist leer; Umfang ohne Abgrenzung. Genau diese Befunde sollen Sie in Ihrer eigenen Strategie beheben: Formulieren Sie das zweite Ziel messbar um, tragen Sie mindestens drei Kennzahlen ein (zum Beispiel Aktualitätsquote, Top-3-Trefferquote, Anteil Dokumente mit Owner), nennen Sie ausgeschlossene Bereiche (etwa Marketingmaterial) und besetzen Sie mindestens die Rollen Owner, Autor, Reviewer und Freigeber.

Typische Fehler: Die Strategie besteht aus allgemeinen Absichtserklärungen; sie nennt Werkzeuge statt Ziele („Wir führen ein Wiki ein“); der Umfang ist unbegrenzt; es gibt keinen Verantwortlichen; sie wird einmal beschlossen und nie überprüft.

| **Falsch**                                                 | **Richtig**                                                                                                 |
|:-----------------------------------------------------------|:------------------------------------------------------------------------------------------------------------|
| Ziel: „Die Dokumentation soll besser und moderner werden.“ | Ziel: „Der Anteil kritischer Dokumente mit zugewiesenem Owner steigt bis 31.03.2027 von 40 auf 95 Prozent.“ |

Im Projekt ist eine Strategie dann gelungen, wenn man sie in einem Jahr aufschlagen und für jedes Ziel sagen kann, ob es erreicht wurde.

## 17.10 Lab Taxonomie erstellen

Eine Taxonomie ordnet die Dokumentation: Welche Dokumentarten gibt es, welche Metadaten gehören zu jeder Art, in welchen Bereichen werden sie abgelegt und wie heißen sie? Modul 6 und 7 haben Struktur und Metadaten behandelt, Modul 10 die Ablage. Im Lab entwerfen Sie eine kleine Taxonomie als Datei und prüfen sie mit einem Skript, das zugleich die Ordnerstruktur erzeugt. So entsteht aus der Beschreibung unmittelbar die Struktur, und Widersprüche fallen sofort auf.

Die Taxonomie besteht aus zwei Teilen. Die *Dokumentarten* haben jeweils ein Kürzel (für Dateinamen) und eine Liste von Pflichtmetadaten. Die *Bereiche* sind die Hauptordner und listen auf, welche Dokumentarten dort vorkommen dürfen. Zwei Regeln sind sinnvoll: Das Kürzel ist eindeutig, und jede Art hat mindestens die Metadaten Owner und nächste Prüfung, damit Pflege möglich ist (Modul 14).

```yaml
dokumentarten:
  runbook: {kuerzel: RB, metadaten: [owner, system, naechste_pruefung]}
  richtlinie: {kuerzel: RL, metadaten: [owner, klasse, naechste_pruefung]}
  api: {kuerzel: API, metadaten: [owner]}
bereiche:
  betrieb: [runbook, richtlinie]
  entwicklung: [api, Runbook]
```

```python
import yaml
from pathlib import Path

t = yaml.safe_load(open("taxonomie.yaml", encoding="utf-8"))
arten = t["dokumentarten"]
kuerzel = [a["kuerzel"] for a in arten.values()]
if len(set(kuerzel)) != len(kuerzel):
    print("Kürzel nicht eindeutig")
for name, a in arten.items():
    if "owner" not in a["metadaten"] or "naechste_pruefung" not in a["metadaten"]:
        print(f"{name}: Pflichtmetadaten owner/naechste_pruefung nicht vollständig")
for bereich, liste in t["bereiche"].items():
    for art in liste:
        if art not in arten:
            print(f"{bereich}: unbekannte Dokumentart '{art}'")
        else:
            Path("ablage", bereich, art).mkdir(parents=True, exist_ok=True)
print("Ordner angelegt:", sorted(str(p) for p in Path("ablage").glob("*/*")))
```

Das Skript prüft zuerst die Eindeutigkeit der Kürzel, danach die Pflichtmetadaten je Dokumentart und schließlich, ob jede in einem Bereich genannte Art definiert ist; nur für gültige Kombinationen legt es mit `mkdir` mit dem Parameter `parents=True` die Ordner an. Das Ergebnis bei den Beispieldaten: Für die Art `api` fehlen die Pflichtmetadaten (nur der Owner ist genannt, die nächste Prüfung fehlt); im Bereich `entwicklung` ist `Runbook` unbekannt, weil die Art klein als `runbook` definiert ist (ein Tippfehler in der Großschreibung, den ein Mensch leicht übersieht); angelegt werden die drei Ordner `ablage/betrieb/richtlinie`, `ablage/betrieb/runbook` und `ablage/entwicklung/api`. Wichtig ist die Lehre: Die Beschreibung ist die Quelle der Wahrheit, die Ordnerstruktur wird daraus abgeleitet, nicht umgekehrt.

Ihre Aufgabe: Erweitern Sie die Taxonomie um mindestens zwei weitere Dokumentarten (zum Beispiel Anleitung und Entscheidungsdokument), vergeben Sie eindeutige Kürzel, beheben Sie die gemeldeten Fehler, und ergänzen Sie das Skript um eine Namensregel, die Dateinamen aus Kürzel, Titel und Datum bildet (zum Beispiel `RB_Neustart-Shop_2026-10`).

Typische Fehler: Zu viele Dokumentarten, sodass niemand sie unterscheiden kann; Bereiche, die nach der Organisationsstruktur statt nach Zielgruppe und Zweck gebildet werden; Metadaten ohne Pflege; Kürzel, die sich später ändern und alle Dateinamen ungültig machen.

| **Falsch**                                       | **Richtig**                                                                               |
|:-------------------------------------------------|:------------------------------------------------------------------------------------------|
| Ordner „Neu“, „Neu2“, „Sonstiges“ und „Wichtig“. | Wenige, klar definierte Dokumentarten mit Pflichtmetadaten und Bereichen nach Zielgruppe. |

Im Projekt hilft es, die Taxonomie an realen Dokumenten zu testen: Nimmt man 20 vorhandene Dokumente, sollte jedes eindeutig einer Art zuzuordnen sein.

## 17.11 Lab RACI Matrix

Die RACI-Matrix ordnet jeder Aufgabe Rollen zu: R (responsible) führt aus, A (accountable) trägt die Gesamtverantwortung und entscheidet, C (consulted) wird vorher befragt, I (informed) wird nachher informiert. Es gibt zwei Grundregeln: Jede Aufgabe hat *genau ein* A, denn bei zwei Verantwortlichen fühlt sich im Zweifel keiner zuständig, und jede Aufgabe hat mindestens ein R, denn sonst macht sie niemand. Modul 14 hat die Rollen beschrieben; das Lab übt die Prüfung einer Matrix, die als Tabelle vorliegt.

Das Skript liest eine Matrix als CSV mit einer Zeile je Aufgabe und einer Spalte je Rolle, prüft die beiden Grundregeln und rechnet die *Verantwortungslast* je Rolle: Wie viele Aufgaben tragen sie als A oder R? Diese Zahl zeigt, ob eine Rolle überlastet ist oder ob Verantwortung zu ungleich verteilt wurde.

```text
aufgabe;owner;autor;reviewer;freigeber;redaktion
Dokument erstellen;A;R;;;C
Dokument prüfen;I;;R;A;
Dokument veröffentlichen;A;;;;R
Dokument archivieren;R;;;R;I
Kennzahlen berichten;;;;;R
```

```python
import csv
from collections import Counter

zeilen = list(csv.DictReader(open("raci.csv", encoding="utf-8"), delimiter=";"))
rollen = [k for k in zeilen[0] if k != "aufgabe"]
last = Counter()
for z in zeilen:
    werte = [z[r] for r in rollen]
    a, r = werte.count("A"), werte.count("R")
    probleme = []
    if a != 1:
        probleme.append(f"{a} x A (genau 1 verlangt)")
    if r == 0:
        probleme.append("kein R")
    print(f"{z['aufgabe']}: " + ("; ".join(probleme) or "in Ordnung"))
    for rolle in rollen:
        if z[rolle] in ("A", "R"):
            last[rolle] += 1
print("Verantwortungslast (A oder R) je Rolle:", dict(last))
```

Die Schleife bestimmt je Aufgabe, wie oft A und R vorkommen, und sammelt Probleme. Ergebnis: Die ersten drei Aufgaben sind in Ordnung. Bei „Dokument archivieren“ steht kein A, weil Owner und Freigeber beide nur R sind; bei „Kennzahlen berichten“ gibt es ebenfalls kein A, nur die Redaktion führt aus. Die Verantwortungslast: Owner 3, Autor 1, Reviewer 1, Freigeber 2, Redaktion 2. Der Owner trägt die meisten Aufgaben; ob das gewollt ist, muss man bewerten. Ein weiterer Hinweis: Das Skript prüft nur die Form. Ob die Zuordnung sinnvoll ist, etwa ob der Autor nicht zugleich die Freigabe verantwortet (Vier-Augen-Prinzip, siehe Lab Review Prozess), zeigt nur die inhaltliche Prüfung.

Ihre Aufgabe: Ergänzen Sie die Matrix um mindestens vier weitere Aufgaben aus dem Dokumentationszyklus (zum Beispiel „Review-Termin planen“, „Löschung freigeben“, „Vorlage pflegen“), korrigieren Sie die beiden fehlerhaften Zeilen und begründen Sie, wer das A für die Kennzahlen sein sollte. Erweitern Sie das Skript um eine Warnung, wenn eine Rolle mehr als die Hälfte aller Aufgaben trägt.

Typische Fehler: Mehrere A in einer Zeile; kein A; Rollen sind Personen statt Funktionen, sodass bei Urlaub oder Wechsel unklar ist, wer zuständig ist; alle Spalten voller C und I, sodass die Matrix nichts mehr aussagt.

| **Falsch**                                            | **Richtig**                                                                              |
|:------------------------------------------------------|:-----------------------------------------------------------------------------------------|
| „Dokument archivieren“: Owner R, Freigeber R, kein A. | Owner A, Freigeber R, Redaktion I: eine Entscheidung, eine Ausführung, ein Informierter. |

Im Projekt hängt man die Matrix dort auf, wo man sie braucht, im Wiki an die Prozessbeschreibung, und überprüft sie bei jedem Rollenwechsel.

## 17.12 Lab Template entwickeln

Eine Vorlage (englisch Template) sorgt für Einheitlichkeit und spart Zeit, weil Struktur und Pflichtangaben von Anfang an vorhanden sind. Modul 6 hat Vorlagen als Strukturmittel behandelt. Im Lab entwickeln Sie eine Vorlage für ein Runbook, eine Betriebsanleitung, mit Platzhaltern für die Metadaten und festen Abschnitten, und ein Skript, das aus der Vorlage ein neues Dokument erzeugt und eingereichte Dokumente auf fehlende Pflichtabschnitte prüft.

Die Vorlage ist eine Markdown-Datei mit einem Kopf aus Metadaten (YAML-Kopfzeile) und einer festen Gliederung. Platzhalter stehen in doppelten geschweiften Klammern. Das ist bewusst einfach; Dokumentationswerkzeuge bieten eigene Vorlagenmechanismen, aber das Prinzip ist dasselbe.

```markdown
---
titel: {{titel}}
owner: {{owner}}
naechste_pruefung: {{datum}}
---
# {{titel}}

## Zweck

## Voraussetzungen

## Schritte

## Rückfall

## Kontakt
```

```python
import re, sys
from pathlib import Path

vorlage = Path("vorlage_runbook.md").read_text(encoding="utf-8")
werte = {"titel": "Runbook Neustart Shop", "owner": "Team Betrieb", "datum": "2027-04-01"}
text = vorlage
for k, v in werte.items():
    text = text.replace("{{" + k + "}}", v)
Path("runbook_neu.md").write_text(text, encoding="utf-8")

pflicht = re.findall(r"^## (.+)$", vorlage, re.M)
vorhanden = re.findall(r"^## (.+)$", Path(sys.argv[1]).read_text(encoding="utf-8"), re.M)
print("Aus Vorlage erzeugt: runbook_neu.md, offene Platzhalter:", re.findall(r"{{\w+}}", text) or "keine")
print("Fehlende Abschnitte in", sys.argv[1] + ":", [p for p in pflicht if p not in vorhanden] or "keine")
```

Der erste Teil ersetzt die Platzhalter durch die Werte und schreibt die neue Datei; danach prüft ein regulärer Ausdruck, ob noch unersetzte Platzhalter übrig sind. Der zweite Teil liest die Überschriften zweiter Ebene aus der Vorlage und aus einer eingereichten Datei, die als Kommandozeilenargument übergeben wird, und meldet fehlende. Ruft man das Skript mit der Datei `eingereicht.md` auf, die nur die Abschnitte „Zweck“ und „Schritte“ enthält, lautet das Ergebnis: Aus der Vorlage wurde `runbook_neu.md` erzeugt, es gibt keine offenen Platzhalter, und in `eingereicht.md` fehlen die Abschnitte „Voraussetzungen“, „Rückfall“ und „Kontakt“. Ohne Argument bricht das Skript mit einem Indexfehler ab; für den Produktiveinsatz würde man das abfangen.

Ihre Aufgabe: Entwickeln Sie eine eigene Vorlage für eine Entscheidungsdokumentation (Kontext, Optionen, Entscheidung, Folgen) und erweitern Sie das Skript um die Prüfung, ob unter jeder Überschrift auch Text steht. Eine Überschrift ohne Text erfüllt die Pflicht nicht, auch wenn sie vorhanden ist. Denken Sie an die Pflege: Eine Vorlage ändert sich, und bestehende Dokumente behalten ihre alte Struktur; planen Sie, wie Sie das erkennen.

Typische Fehler: Vorlagen sind zu lang und werden nicht ausgefüllt; Pflichtfelder sind nicht von optionalen unterscheidbar; Platzhaltertexte bleiben im veröffentlichten Dokument stehen; es gibt eine Vorlage, aber niemand weiß, wo sie liegt.

| **Falsch**                                                          | **Richtig**                                                                                         |
|:--------------------------------------------------------------------|:----------------------------------------------------------------------------------------------------|
| Vorlage mit 25 Abschnitten, von denen die Hälfte „entfällt“ lautet. | Vorlage mit fünf bis sieben Pflichtabschnitten, die im Kopf verlinkt und mit Beispiel versehen ist. |

Im Projekt prüft man die Pflichtabschnitte automatisch bei der Einreichung (Modul 11), sodass menschliche Reviewer sich auf Inhalt konzentrieren können.

## 17.13 Lab Review Prozess

Ein Review-Prozess bestimmt, wie ein Dokument vom Entwurf zur gültigen Fassung wird. Modul 14 hat Statusmodell und Vier-Augen-Prinzip beschrieben. Im Lab setzen Sie die Regeln als kleinen Zustandsautomaten um und prüfen damit ein Protokoll tatsächlicher Statuswechsel. Ein Zustandsautomat ist ein Modell, in dem ein Objekt immer in genau einem Zustand ist und nur über erlaubte Übergänge in einen anderen wechseln darf.

Die Regeln: Ein Dokument beginnt als Entwurf; aus dem Entwurf geht es in die Prüfung, aus der Prüfung zurück in den Entwurf oder weiter zur Freigabe; ein freigegebenes Dokument kann wieder in Überarbeitung (Entwurf) gehen oder archiviert werden. Ein direkter Weg vom Entwurf zur Freigabe ist nicht erlaubt. Zusätzlich gilt das Vier-Augen-Prinzip: Wer ein Dokument geschrieben hat, darf es nicht selbst freigeben.

```text
dokument;von;nach;person;autor
D1;entwurf;in_pruefung;Meier;Meier
D1;in_pruefung;freigegeben;Huber;Meier
D2;entwurf;freigegeben;Schmid;Schmid
D3;entwurf;in_pruefung;Berger;Berger
D3;in_pruefung;freigegeben;Berger;Berger
D3;freigegeben;archiviert;Berger;Berger
```

```python
import csv

ERLAUBT = {("entwurf", "in_pruefung"), ("in_pruefung", "entwurf"),
           ("in_pruefung", "freigegeben"), ("freigegeben", "entwurf"),
           ("freigegeben", "archiviert")}
for z in csv.DictReader(open("status_log.csv", encoding="utf-8"), delimiter=";"):
    b = []
    if (z["von"], z["nach"]) not in ERLAUBT:
        b.append(f"unzulässiger Übergang {z['von']} -> {z['nach']}")
    if z["nach"] == "freigegeben" and z["person"] == z["autor"]:
        b.append("Vier-Augen-Prinzip verletzt (Autor gibt selbst frei)")
    print(f"{z['dokument']} {z['von']} -> {z['nach']} durch {z['person']}: " + ("; ".join(b) or "ok"))
```

Die Menge `ERLAUBT` enthält die zulässigen Übergänge als Paare. Das Skript prüft jede Zeile des Protokolls gegen diese Menge und zusätzlich gegen die Vier-Augen-Regel. Das Ergebnis: Dokument D1 ist in Ordnung, weil eine andere Person freigegeben hat. D2 hat gleich zwei Verstöße: der Sprung vom Entwurf zur Freigabe und die Selbstfreigabe durch die Autorin. Bei D3 ist der Übergang selbst zulässig, aber Berger hat als Autor sein eigenes Dokument freigegeben (Vier-Augen-Prinzip verletzt); die anschließende Archivierung ist formal in Ordnung. Dass dieselbe Person alle Schritte allein ausführt, ist im Protokoll gut sichtbar, im Wiki ohne Auswertung dagegen nicht. Das ist der Nutzen einer solchen Prüfung für Audits (siehe Lab Audit Checkliste).

Ihre Aufgabe: Erweitern Sie das Protokoll um ein Datum und prüfen Sie zusätzlich, dass die Prüfung mindestens einen Tag dauerte (um reine Durchwinke-Vorgänge zu erkennen), und dass nach dem Wechsel in die Freigabe die nächste Prüfung terminiert wurde. Überlegen Sie, wo das Vier-Augen-Prinzip in kleinen Teams nicht einzuhalten ist, und beschreiben Sie eine dokumentierte Ausnahme mit nachträglicher Kontrolle.

Typische Fehler: Der Prozess existiert nur im Handbuch, das Werkzeug erzwingt ihn nicht; Reviewer prüfen nur Rechtschreibung; die Prüfung dauert Wochen und wird deshalb umgangen; Ausnahmen werden nicht protokolliert.

| **Falsch**                                                                | **Richtig**                                                                                         |
|:--------------------------------------------------------------------------|:----------------------------------------------------------------------------------------------------|
| Autor setzt den Status selbst auf „freigegeben“, damit es schneller geht. | Das Werkzeug erlaubt Freigaben nur durch eine zweite Person; Ausnahmen mit Begründung im Protokoll. |

Im Projekt lässt sich der Automat teilweise im Werkzeug abbilden (Workflows in Wiki- und DMS-Systemen) oder bei Dokumentation im Repository über geschützte Zweige und Pflicht-Reviews erzwingen.

## 17.14 Lab Audit Checkliste

Ein Audit prüft, ob die tatsächliche Praxis den eigenen Regeln entspricht. Modul 15 hat Auditarten und Ablauf beschrieben. Im Lab erstellen Sie eine Checkliste mit gewichteten Kontrollen und werten ein Ergebnis aus. Eine Checkliste ist kein Ersatz für Urteilsvermögen, aber sie macht Audits vergleichbar und nachvollziehbar.

Jede Kontrolle hat eine Kritikalität (hoch, mittel, niedrig), die zugleich als Gewicht dient (3, 2, 1), und ein Ergebnis (erfüllt, teilweise, nicht erfüllt) mit den Punkten 1, 0,5 und 0. Der gewichtete Erfüllungsgrad ist die Summe der gewichteten Punkte geteilt durch die Summe der Gewichte. Eine nicht erfüllte Kontrolle mit hoher Kritikalität gilt als wesentlicher Befund, alles andere Nichterfüllte als Abweichung. Diese Einstufung und die Gewichte sind eigene, in diesem Kurs gewählte Konventionen, keine Norm.

```text
kontrolle;kritikalitaet;ergebnis
Owner je Dokument;hoch;teilweise
Reviews fristgerecht;hoch;erfüllt
Klassifizierung gesetzt;hoch;nicht erfüllt
Namensschema eingehalten;niedrig;teilweise
Löschprotokolle vorhanden;mittel;nicht erfüllt
```

```python
import csv

PUNKTE = {"erfüllt": 1.0, "teilweise": 0.5, "nicht erfüllt": 0.0}
GEWICHT = {"hoch": 3, "mittel": 2, "niedrig": 1}
summe = gewicht = 0
for z in csv.DictReader(open("audit_ergebnis.csv", encoding="utf-8"), delimiter=";"):
    g = GEWICHT[z["kritikalitaet"]]
    summe += PUNKTE[z["ergebnis"]] * g
    gewicht += g
    if z["ergebnis"] != "erfüllt":
        stufe = "wesentlich" if z["kritikalitaet"] == "hoch" and z["ergebnis"] == "nicht erfüllt" else "Abweichung"
        print(f"Befund [{stufe}]: {z['kontrolle']} ({z['ergebnis']}, Kritikalität {z['kritikalitaet']})")
print(f"Erfüllungsgrad gewichtet: {100 * summe / gewicht:.0f} Prozent")
```

Die Schleife addiert für jede Kontrolle Punkte mal Gewicht und das Gewicht selbst und gibt für alles Nichterfüllte einen Befund aus. Ergebnis: Die Zuordnung der Owner (teilweise) und das Namensschema (teilweise) sowie die fehlenden Löschprotokolle sind Abweichungen; die fehlende Klassifizierung ist wegen der hohen Kritikalität ein wesentlicher Befund. Der gewichtete Erfüllungsgrad beträgt 42 Prozent: Die gewichteten Punkte sind 1,5 (Owner: Gewicht 3 mal 0,5), 3 (Reviews: 3 mal 1), 0 (Klassifizierung), 0,5 (Namensschema: 1 mal 0,5) und 0 (Löschprotokolle), zusammen 5; die Gewichtssumme ist 3 plus 3 plus 3 plus 1 plus 2, also 12; 5 geteilt durch 12 ergibt gerundet 0,42. Typische Fehlerquelle bei der eigenen Nachrechnung: Man teilt durch die Anzahl der Kontrollen (5) statt durch die Gewichtssumme (12). Der Erfüllungsgrad ist eine Orientierung, die Befunde zählen mehr: Ein hoher Gesamtwert kann einen wesentlichen Befund verdecken.

Ihre Aufgabe: Erstellen Sie eine Checkliste mit mindestens zehn Kontrollen aus den Bereichen Governance, Qualität, Sicherheit und Aufbewahrung, schätzen Sie Kritikalität und Ergebnis für ein fiktives Unternehmen und werten Sie mit dem Skript aus. Ergänzen Sie für jeden Befund eine Maßnahme mit Verantwortlichem und Frist, damit sie im Verbesserungsbacklog (Modul 16) landet.

Typische Fehler: Kontrollen sind so vage, dass jeder anders urteilt („Dokumentation ist gepflegt“); Nachweise werden nicht festgehalten; der Erfüllungsgrad wird als Ziel statt als Messwert betrachtet; Befunde bleiben ohne Maßnahme.

| **Falsch**                                  | **Richtig**                                                                                                                                             |
|:--------------------------------------------|:--------------------------------------------------------------------------------------------------------------------------------------------------------|
| Kontrolle: „Die Dokumentation ist aktuell.“ | Kontrolle: „Mindestens 90 Prozent der kritischen Dokumente haben ein Prüfdatum, das nicht älter als 12 Monate ist (Nachweis: Auswertung vom Stichtag).“ |

Im Projekt führt man die Checkliste vor dem externen Audit als internes Audit durch; so findet man die Schwachstellen selbst.

## 17.15 Prüfungsnahe Aufgaben

Prüfungsnahe Aufgaben verlangen, den Stoff in Fragen anzuwenden und nicht nur wiederzugeben. Typisch sind Auswahlfragen mit plausiblen falschen Antworten, kurze Fallbeschreibungen mit Entscheidungsfrage und Berechnungen. Dieser Abschnitt zeigt, wie man sich mit einem kleinen Übungsprogramm vorbereitet und wie man Fragen löst. Er ersetzt nicht die Aufgaben am Ende des Moduls, sondern ergänzt sie um Methode.

Bei Auswahlfragen führt eine feste Reihenfolge am sichersten zum Ziel. Man liest zuerst die Frage ohne die Antworten und überlegt, wie man selbst antworten würde. Dann streicht man Antworten, die absolut formuliert sind („immer“, „nie“), die ein Werkzeug anstelle eines Zwecks nennen oder zwei Dinge verwechseln, die man im Kurs getrennt hat, etwa RTO und RPO oder Owner und Autor. Bleiben zwei Antworten, fragt man, welche die Frage tatsächlich beantwortet und nicht nur etwas Richtiges über das Thema sagt. Bei Fallfragen sucht man die Information, die den Fall entscheidet: eine Frist, eine Rolle, eine Zahl.

Das folgende Skript ist ein Mini-Übungsprogramm: Es liest Fragen mit Antworten aus einer YAML-Datei, vergleicht sie mit einer Antwortfolge, die als Argument übergeben wird, und nennt bei Fehlern die richtige Lösung. So lassen sich eigene Fragen sammeln und wiederholen.

```text
- frage: Was bedeutet RPO?
  antworten: {a: Zeit bis zur Wiederherstellung, b: Akzeptabler Datenverlust, c: Anzahl der Backups}
  richtig: b
- frage: Wer gibt ein Dokument im Vier-Augen-Prinzip frei?
  antworten: {a: Der Autor, b: Eine zweite Person, c: Das Wiki}
  richtig: b
- frage: Was ist ein maßgebliches System?
  antworten: {a: Das teuerste Tool, b: Der Ort der gültigen Fassung, c: Das neueste Tool}
  richtig: b
```

```python
import sys, yaml

fragen = yaml.safe_load(open("quiz.yaml", encoding="utf-8"))
antworten = sys.argv[1].split(",")
richtig = 0
for f, a in zip(fragen, antworten):
    ok = a == f["richtig"]
    richtig += ok
    print(f["frage"], f"Ihre Antwort {a}: " + ("richtig" if ok else f"falsch, richtig ist {f['richtig']}: {f['antworten'][f['richtig']]}"))
print(f"{richtig} von {len(fragen)} richtig")
```

Ruft man das Programm mit `python3 quiz_lauf.py b,a,b` auf, gibt es die Antworten b, a und b ab. Die erste und die dritte sind richtig; bei der zweiten Frage („Wer gibt ein Dokument im Vier-Augen-Prinzip frei?“) wurde „Der Autor“ gewählt, richtig ist b, „Eine zweite Person“. Das Ergebnis lautet daher zwei von drei richtig. Der Wert des Verfahrens liegt weniger im Zählen als im Nachschlagen: Zu jeder falschen Antwort gehört eine Wiederholung des Themas im Skript. Ein Detail: Das Programm geht davon aus, dass die Antwortfolge nicht länger ist als die Fragenliste; zu lange Folgen schneidet `zip` stillschweigend ab.

Zum Rechnen sind drei Aufgabentypen in diesem Modul zu erwarten: die Prüfung von Sicherungsintervall und RPO (das Intervall darf den Wert nicht überschreiten), die Berechnung von Gesamtkosten und Amortisation (laufende Ersparnis, Einmalkosten durch Ersparnis) und die gewichtete Bewertung (Summe der Gewicht mal Punkte geteilt durch Summe der Gewichte). Üben Sie diese Rechnungen mit Zahlen aus den Beispielen und prüfen Sie das Ergebnis mit den Skripten dieses Moduls.

Typische Fehler: Man liest nur die Antworten, nicht die Frage; man wählt die Antwort, die richtig klingt, statt die, die zur Frage passt; man verwechselt Begriffe, die sich ähneln; man rechnet im Kopf ohne Einheitenprüfung (Stunden und Tage, Euro pro Jahr und pro Monat).

| **Falsch**                                                                                        | **Richtig**                                                                                                                                                                                 |
|:--------------------------------------------------------------------------------------------------|:--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Frage: „Was bestimmt, wie oft gesichert werden muss?“ Antwort: „das RTO“, weil das bekannter ist. | Das RPO bestimmt die Häufigkeit der Sicherung, das RTO die Dauer der Wiederherstellung; die Einheit beider Begriffe (Datenverlust gegen Zeit bis zum Betrieb) hilft bei der Unterscheidung. |

Im Projekt lernt man am besten, indem man eigene Fragen zu den Dokumenten des Unternehmens formuliert und im Team durchspielt; so wird die Prüfungsvorbereitung zugleich zur Wissensprüfung.

## Übungsaufgaben

Die Aufgaben sind nach steigender Schwierigkeit geordnet. Die Aufgaben 4, 5, 6 und 7 verlangen Code; für sie sollten Sie die Skripte dieses Moduls als Ausgangspunkt nutzen.

**Aufgabe 1 (leicht).** Erklären Sie die Begriffe RTO und RPO in eigenen Worten und nennen Sie für ein selten geändertes Handbuch und für eine tägliche Betriebsübersicht je einen plausiblen RPO-Wert mit Begründung.

**Aufgabe 2 (leicht).** Was bedeutet ROT in der Ist-Analyse, und welche drei Entscheidungen kann man für ein Objekt in einer Migration treffen?

**Aufgabe 3 (mittel).** Ein Unternehmen vergleicht zwei Werkzeuge nur nach dem Lizenzpreis. Nennen Sie vier weitere Kostenarten und zwei Nutzenarten, die im Kostenmodell fehlen, und erklären Sie, warum die Nutzenseite nur als Spanne ausgewiesen werden sollte.

**Aufgabe 4 (mittel, Code).** Schreiben Sie ein Skript, das aus einer CSV-Datei mit den Spalten `titel`, `archiviert_am` und `frist_jahre` ausgibt, welche Dokumente innerhalb der nächsten 180 Tage ihr Fristende erreichen. Behandeln Sie den 29. Februar als Archivierungsdatum.

**Aufgabe 5 (mittel, Code).** Ergänzen Sie die Bewertung aus der Einheit zur Konsolidierung um eine Sensitivitätsprüfung. Ändern Sie das Gewicht der Aufbewahrung von 2 auf 1 und von 2 auf 3 und geben Sie jeweils die Rangfolge aus.

**Aufgabe 6 (anspruchsvoll, Code).** Erweitern Sie die Roadmap-Planung so, dass eine Aufgabe, die in keine Phase passt, mit der Angabe ausgegeben wird, wie viele Stunden Kapazität insgesamt fehlen.

**Aufgabe 7 (anspruchsvoll, Code).** Schreiben Sie ein Skript, das aus dem Protokoll des Review-Prozesses die Dokumente nennt, bei denen dieselbe Person alle Schritte allein durchgeführt hat.

**Aufgabe 8 (anspruchsvoll).** Entwerfen Sie für ein Unternehmen mit 400 Mitarbeitenden eine 30-60-90-Tage-Roadmap mit sechs Aufgaben (Aufwand, Abhängigkeiten, Ergebnis) und begründen Sie, welche Aufgabe Sie als Schnellerfolg im ersten Monat wählen und welche Kennzahl den Erfolg nach 90 Tagen zeigt.

## Lösungen und Erläuterungen

**Lösung 1.** Das RTO (Recovery Time Objective) ist die höchstens zulässige Dauer bis zur Wiederaufnahme des Betriebs, das RPO (Recovery Point Objective) der akzeptable Datenverlust, gemessen in Zeit. Für ein selten geändertes Handbuch ist ein RPO von einer Woche oder mehr plausibel, weil kaum etwas verloren gehen kann; für die tägliche Betriebsübersicht ist ein RPO von vier bis 24 Stunden sinnvoll, weil sonst Betriebsinformationen fehlen. Entscheidend ist die Begründung aus der Auswirkung eines Verlusts, nicht der Zahlenwert; die Werte sind Beispiele.

**Lösung 2.** ROT steht für redundante, veraltete und triviale Inhalte, die eine Migration verteuern, ohne Nutzen zu bringen. Für ein Objekt sind drei Entscheidungen möglich: migrieren (in die Zielstruktur übernehmen), archivieren (mit Frist und Index aufbewahren, aber aus der aktiven Ablage nehmen) oder neu aufbauen (inhaltlich neu schreiben, weil eine Übernahme nicht lohnt). Als vierte Möglichkeit kommt das Löschen in Betracht, sofern keine Aufbewahrungspflicht und keine Sperre besteht.

**Lösung 3.** Weitere Kostenarten sind Einmalkosten der Migration, Schulung, Parallelbetrieb in der Übergangszeit und die Arbeitszeit für Administration und Pflege. Nutzenarten sind gesparte Suchzeit und kürzere Einarbeitung (ebenso: weniger Fehler durch veraltete Anleitungen, bessere Auditergebnisse). Der Nutzen beruht auf Annahmen, zum Beispiel über die Zahl der Suchvorgänge und die Zeitersparnis je Vorgang; Annahmen können sich als falsch erweisen. Eine Spanne (vorsichtig, erwartet, optimistisch) zeigt, wie stark das Ergebnis davon abhängt, und verhindert eine Scheingenauigkeit.

**Lösung 4.** Ein möglicher Ansatz berechnet das Fristende und behandelt den 29. Februar:

```python
import csv
from datetime import date, timedelta

HEUTE = date(2026, 10, 28)

def fristende(a, jahre):
    try:
        return a.replace(year=a.year + jahre)
    except ValueError:
        return date(a.year + jahre, 2, 28)

for z in csv.DictReader(open("archiv.csv", encoding="utf-8"), delimiter=";"):
    ende = fristende(date.fromisoformat(z["archiviert_am"]), int(z["frist_jahre"]))
    if HEUTE <= ende <= HEUTE + timedelta(days=180):
        print(f"{z['titel']}: Fristende {ende}")
```

Die Funktion versucht, das Jahr zu ersetzen, und weicht bei einem nicht existierenden 29. Februar auf den 28. Februar aus; ob der 28. Februar oder der 1. März gilt, ist eine fachliche Festlegung, die man dokumentieren muss. Mit den Beispieldaten der Archivierung gibt das Skript nichts aus, weil keines der Fristenden im Fenster liegt (die Fristen sind entweder abgelaufen oder liegen deutlich in der Zukunft, der Vertrag erst 2031). Beim Testen sollten Sie deshalb einen Eintrag ergänzen, der im Fenster liegt.

**Lösung 5.** Man verwandelt die Bewertung in eine Funktion mit Gewichten als Parameter:

```python
import yaml

d = yaml.safe_load(open("bewertung_tools.yaml", encoding="utf-8"))

def rangfolge(gewichte):
    summe = sum(gewichte.values())
    punkte = {n: sum(gewichte[k] * w[k] for k in gewichte) / summe for n, w in d["tools"].items()}
    return sorted(punkte.items(), key=lambda t: -t[1])

for aufbewahrung in (1, 2, 3):
    g = dict(d["gewichte"], aufbewahrung=aufbewahrung)
    print(aufbewahrung, [(n, round(p, 2)) for n, p in rangfolge(g)])
```

Der Lauf ergibt bei Gewicht 1 einen Gleichstand von Wiki A und Plattform B (je 3,70), bei Gewicht 2 den Vorsprung von Plattform B (3,82 gegen 3,55) und bei Gewicht 3 einen größeren Vorsprung (3,92 gegen 3,42); das alte Wiki bleibt in allen Fällen weit zurück. Die Rangfolge von B vor A ist also nur bei sehr geringer Gewichtung der Aufbewahrung nicht mehr eindeutig; entscheidend ist die Methode: Man prüft, ob die Entscheidung gegenüber vernünftigen Änderungen der Gewichte stabil ist, und legt offen, wenn nicht.

**Lösung 6.** Man summiert die Kapazität aller Phasen und die verplanten Stunden und gibt die Differenz aus:

```python
import yaml

d = yaml.safe_load(open("roadmap.yaml", encoding="utf-8"))
kapazitaet = sum(d["kapazitaet_h"].values())
bedarf = sum(a["aufwand"] for a in d["aufgaben"])
print(f"Bedarf {bedarf} h, Kapazität {kapazitaet} h, Differenz {bedarf - kapazitaet} h")
```

Bei den Beispieldaten beträgt der Bedarf 105 Stunden bei 110 Stunden Kapazität; die Bilanz weist also sogar fünf Stunden Reserve aus, und trotzdem passt die Kennzahlenaufgabe nicht hinein. Die Ursache sind die Abhängigkeiten: Sie sind erst im dritten Abschnitt erfüllt, dessen Kapazität bereits verbraucht ist. Die Gesamtbilanz allein reicht also nicht, man braucht die Platzierung je Phase, wie das Skript der Einheit sie liefert. Die Aufgabe verlangt deshalb, beide Auswertungen zu verbinden und beim Ausgeben der nicht platzierten Aufgabe zu nennen, wie viele Stunden in der letzten Phase fehlen.

**Lösung 7.** Das Protokoll wird nach Dokument gruppiert, und man prüft, ob die Menge der beteiligten Personen genau eine Person enthält:

```python
import csv
from collections import defaultdict

personen = defaultdict(set)
for z in csv.DictReader(open("status_log.csv", encoding="utf-8"), delimiter=";"):
    personen[z["dokument"]].add(z["person"])
for dok, menge in sorted(personen.items()):
    if len(menge) == 1:
        print(f"{dok}: alle Schritte durch {next(iter(menge))}")
```

Mit den Beispieldaten meldet das Skript D2 (Schmid) und D3 (Berger). D1 ist unauffällig, weil Meier und Huber beteiligt waren. Die Mengenschreibweise (`set`) vermeidet Doppelzählungen; `next(iter(menge))` liest das einzige Element.

**Lösung 8.** Eine mögliche Lösung für 400 Mitarbeitende: A1 Bestandsaufnahme der zehn wichtigsten Bereiche (20 h, Ergebnis: Inventar), A2 Owner für die meistgenutzten Dokumente benennen (10 h, nach A1, Ergebnis: Liste mit Owner), A3 Vorlage für Runbooks festlegen (15 h, nach A1, Ergebnis: veröffentlichte Vorlage), A4 Review-Kalender einrichten (15 h, nach A2), A5 Altbestand der Laufwerke archivieren (25 h, nach A1 und A2) und A6 Kennzahlen erheben (15 h, nach A4). Als Schnellerfolg bietet sich A2 an, weil sie wenig Aufwand verlangt, sofort sichtbar ist (jede Person sieht, wer zuständig ist) und die Grundlage für spätere Schritte bildet. Als Kennzahl nach 90 Tagen eignet sich der Anteil der kritischen Dokumente mit Owner und Prüftermin, weil sie direkt von den Aufgaben abhängt. Bewerten Sie Ihre Lösung nach den Kriterien der Einheit: Abhängigkeiten stimmig, Kapazität eingehalten, jede Aufgabe mit überprüfbarem Ergebnis.
