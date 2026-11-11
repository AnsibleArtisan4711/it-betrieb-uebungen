# Modul 15 - Betrieb, Pflege und Wissensmanagement

> **Hinweis zu diesem Kapitel:** Das ist das Kapitel des Skripts „Technische Dokumentation und Dokumentations-Governance“, aus der LaTeX-Quelle in Markdown umgewandelt (Text und Listings unverändert, farbige Boxen als Zitatblöcke mit fettem Titel, Tabellen als Markdown-Tabellen, Übungsaufgaben und Lösungen als Absätze). Die Lerneinheiten sind wie in der Quelle nach Modul nummeriert (15.1 bis 15.16), danach folgen „Übungsaufgaben“ (8 Aufgaben) und „Lösungen und Erläuterungen“. Die Sprachangabe der Codeblöcke ist in der Quelle nur für Python und Bash gesetzt; die übrigen Blöcke sind hier nach ihrem Inhalt als `python`, `yaml`, `markdown`, `bash` oder `text` ausgezeichnet, der Inhalt selbst ist unverändert. **Prüfstand der Beispiele für dieses Repository:** Die Python-Beispiele wurden auf Syntax geprüft; welche Beispiele ausgeführt wurden und welche zusätzlich PyYAML brauchen, steht in der [README des Repositories](../README.md). Übersicht zum Modul: [README](README.md).

**Dauer:** 16 Stunden | **Priorität:** 2 | **Lerneinheiten:** 16

| **Nr.** | **Lerneinheit**                   | **Dauer (h)** | **Prio** |
|--------:|:----------------------------------|--------------:|---------:|
|       1 | Dokumentationspflege              |             1 |        1 |
|       2 | Owner Modell                      |             1 |        1 |
|       3 | Suchbarkeit                       |             1 |        1 |
|       4 | Metadaten und Tags                |             1 |        1 |
|       5 | Knowledge Base                    |             1 |        1 |
|       6 | Onboarding-Unterlagen             |             1 |        2 |
|       7 | Feedback-Prozesse                 |             1 |        2 |
|       8 | Wissensmanagement-Troubleshooting |             1 |        2 |
|       9 | Wissensmanagement                 |             1 |        1 |
|      10 | Suchoptimierung intern            |             1 |        1 |
|      11 | Tags und Labels                   |             1 |        1 |
|      12 | FAQ und Knowledge Base            |             1 |        1 |
|      13 | Onboarding Dokumentation          |             1 |        1 |
|      14 | Nutzungsanalyse                   |             1 |        2 |
|      15 | Feedback Mechanismen              |             1 |        2 |
|      16 | Nutzungs-Troubleshooting          |             1 |        2 |
|         | **Summe**                         |        **16** |          |

## 15.1 Dokumentationspflege

Dokumentationspflege ist die dauerhafte Arbeit, die nach der Veröffentlichung beginnt und nie endet: Inhalte werden geprüft, korrigiert, ergänzt, zusammengeführt und irgendwann archiviert. Modul 14 hat die *Steuerung* dieser Arbeit behandelt, also Review-Kalender, Ablaufdaten und Erinnerungen. Dieses Modul betrachtet den *Betrieb*: Wie viel Zeit kostet die Pflege, wer leistet sie, und wie sorgt man dafür, dass sie im Alltag tatsächlich stattfindet? Ein verbreiteter Denkfehler ist, Dokumentation als Projekt zu betrachten, das irgendwann fertig ist. Tatsächlich ist sie ein Betrieb wie ein Dienst im Rechenzentrum: Er braucht Zuständige, Kapazität und Routinen.

Die Pflegearbeit lässt sich in drei Klassen einteilen. *Korrigierende Pflege* behebt Fehler, die Leser melden oder die beim Gebrauch auffallen. *Vorbeugende Pflege* prüft planmäßig, ob Inhalte noch stimmen, bevor jemand einen Fehler bemerkt. *Anpassende Pflege* folgt Änderungen am beschriebenen System, an Vorschriften oder an der Organisation. Jede Klasse hat einen anderen Auslöser und einen anderen Aufwand; ein Betriebskonzept sollte alle drei abdecken, sonst wird nur noch auf Beschwerden reagiert.

Der entscheidende Schritt ist, den Pflegeaufwand *sichtbar* zu machen. Man schätzt je Dokumentart, wie viele Minuten pro Jahr für Prüfung und kleine Korrekturen anfallen, summiert die Werte je Owner und vergleicht sie mit dem Zeitbudget, das der Owner dafür hat. Das folgende Skript tut genau das. Es liest den Bestand mit geschätzten Pflegeminuten pro Dokument und eine Budgetliste je Owner und meldet, wo der Bedarf das Budget übersteigt.

```text
titel;art;owner;pflegeminuten_pro_jahr
Notfallplan Shop;notfallplan;Leitung Betrieb;240
Runbook Neustart;runbook;Team Betrieb;120
Runbook Backup;runbook;Team Betrieb;120
Betriebshandbuch DB;handbuch;Team Betrieb;600
Richtlinie Backup;richtlinie;Leitung IT;90
Grundlagen;grundlagen;Redaktion;60
```

```python
import csv
from collections import defaultdict

lese = lambda n: list(csv.DictReader(open(n, encoding="utf-8"), delimiter=";"))
bedarf = defaultdict(float)
for z in lese("bestand.csv"):
    bedarf[z["owner"]] += int(z["pflegeminuten_pro_jahr"]) / 60

for b in lese("budget.csv"):
    soll, ist = float(b["stunden_pro_jahr"]), bedarf[b["owner"]]
    status = "reicht" if ist <= soll else f"UNTERDECKT um {ist - soll:.1f} h"
    print(f"{b['owner']}: Bedarf {ist:.1f} h, Budget {soll:.0f} h - {status}")
```

Die zweite Datei `budget.csv` hat die Spalten `owner` und `stunden_pro_jahr`; im Test enthielt sie Team Betrieb mit 12 Stunden, Leitung Betrieb mit 8, Leitung IT mit 4 und Redaktion mit 20 Stunden. Das Skript summiert die Minuten je Owner und rechnet sie in Stunden um. Das Ergebnis: Das Team Betrieb braucht 14,0 Stunden bei einem Budget von 12 und ist um 2,0 Stunden unterdeckt; Leitung Betrieb (4,0 von 8), Leitung IT (1,5 von 4) und Redaktion (1,0 von 20) kommen aus. Die Zahlen sind Beispielwerte, aber die Methode ist übertragbar: Das Ergebnis macht eine Lücke sichtbar, bevor sie zu überfälligen Dokumenten führt, und liefert das Argument für eine Entlastung (Archivierung nicht benötigter Dokumente) oder zusätzliche Kapazität.

Typische Fehler: Pflege wird nicht eingeplant und passiert „wenn Zeit ist“; der Aufwand wird unterschätzt, weil nur das Schreiben, nicht das Prüfen gezählt wird; Pflege bleibt an einer Person hängen; es gibt keine Rückmeldung, ob die Pflege wirkt.

| **Falsch**                            | **Richtig**                                                                              |
|:--------------------------------------|:-----------------------------------------------------------------------------------------|
| „Dokumentation pflegen wir nebenbei.“ | Je Owner ein Jahresbudget für Pflege, aus dem Bestand abgeleitet und jährlich überprüft. |

Im Projekt hat sich ein fester, wiederkehrender Pflegeblock bewährt (zum Beispiel zwei Stunden je Monat und Team), der im Kalender steht und denselben Rang hat wie eine Besprechung.

## 15.2 Owner Modell

Das Owner-Modell legt fest, wer für welche Dokumentation verantwortlich ist. Die Rollen und die RACI-Matrix wurden in Modul 06 eingeführt; hier geht es darum, wie das Modell im laufenden Betrieb trägt: bei Lastverteilung, bei Urlaub, bei Personalwechsel und bei Umorganisationen. Ein Owner ist nicht derjenige, der alles schreibt, sondern derjenige, der dafür sorgt, dass das Dokument stimmt, geprüft wird und seinen Zweck erfüllt. Er kann Autoren und Reviewer beauftragen, behält aber die Verantwortung.

Drei Gestaltungsregeln machen ein Owner-Modell belastbar. Erstens: *eine Person, nicht eine Gruppe*. Eine Verantwortung, die einem Team oder einem Postfach gehört, gehört in der Praxis niemandem. Zweitens: *jedes Dokument hat eine benannte Vertretung*, damit Urlaub und Krankheit die Pflege nicht stoppen. Drittens: *Verantwortung folgt der Rolle, nicht der Person*, und es gibt einen Prozess für den Wechsel, damit beim Weggang einer Mitarbeiterin ihre Dokumente nicht verwaisen. Dahinter steckt der Gedanke des *Bus-Faktors*: Wie viele Personen müssten ausfallen, bis niemand mehr ein Dokument versteht oder pflegt? Ist die Zahl eins, ist das Modell zerbrechlich.

Das folgende Skript prüft eine Owner-Liste auf diese Schwächen. Es meldet aktive Dokumente ohne Vertretung und Dokumente, deren Owner ausgeschieden ist, mitsamt der Vertretung, an die sie fallen würden (oder „niemand“), und zählt die Last je Owner.

```text
titel;owner;vertretung;aktiv
Notfallplan Shop;Meier;;ja
Runbook Neustart;Meier;Huber;ja
Runbook Backup;Schmid;Huber;ja
Betriebshandbuch DB;Schmid;;ja
Altes Verfahren;Berger;Meier;nein
Konzept CRM;Berger;;ja
```

```python
import csv
from collections import Counter

weg = {z.strip() for z in open("ausgeschieden.txt", encoding="utf-8") if z.strip()}
last = Counter()
for z in csv.DictReader(open("owner.csv", encoding="utf-8"), delimiter=";"):
    if z["aktiv"] != "ja":
        continue
    last[z["owner"]] += 1
    if z["owner"] in weg:
        neu = z["vertretung"] or "NIEMAND"
        print(f"{z['titel']}: Owner {z['owner']} ausgeschieden -> {neu}")
    elif not z["vertretung"]:
        print(f"{z['titel']}: keine Vertretung (Owner {z['owner']})")
print("Last je Owner:", dict(last))
```

Die Datei `ausgeschieden.txt` enthielt im Test den Namen Berger. Das Skript überspringt archivierte Dokumente („Altes Verfahren“) und meldet für die aktiven drei Befunde: Der Notfallplan und das Betriebshandbuch DB haben keine Vertretung, und das Konzept CRM hat einen ausgeschiedenen Owner ohne Vertretung, fällt also an niemanden. Die Lastverteilung zeigt zwei Dokumente für Meier, zwei für Schmid und eines für Berger. Besonders das Konzept CRM ist ein Notfall, der sofort eine Neuzuordnung braucht. Die Meldung „NIEMAND“ ist absichtlich laut.

Typische Fehler: Der Owner ist „das Team“; die Owner-Liste ist ein einmaliges Excel-Blatt, das nicht mit dem Personalprozess verbunden ist; Owner haben zu viele Dokumente, sodass nichts mehr geprüft wird; die Vertretung kennt das Dokument nicht; Owner ändern sich nach einer Umorganisation, aber die Metadaten nicht.

| **Falsch**                                                                                     | **Richtig**                                                                                                  |
|:-----------------------------------------------------------------------------------------------|:-------------------------------------------------------------------------------------------------------------|
| Owner: „Abteilung IT“, keine Vertretung, Person hat die Firma vor einem halben Jahr verlassen. | Owner: benannte Person, benannte Vertretung; der Austrittsprozess enthält den Schritt „Dokumente übergeben“. |

Im Projekt bindet man das Owner-Modell an den Personalprozess: Beim Austritt oder Rollenwechsel löst das Verzeichnis eine Aufgabe aus, die Dokumente neu zuzuordnen (Modul 14, Owner Reminder, bietet die Erinnerungslogik dazu).

## 15.3 Suchbarkeit

Dieser Abschnitt behandelt die Suchbarkeit aus Sicht des *Betriebs*: Wie weiß man, ob die Suche funktioniert, und wie misst man das? Die technischen Grundlagen (Indizierung, Gewichtung von Titel und Labels, Synonyme, Security Trimming) wurden in Modul 12 erklärt. Hier steht die Frage im Vordergrund, wie man die Suchqualität *überprüfbar* macht, damit Verbesserungen nicht auf Bauchgefühl beruhen.

Eine abgerufene Praxisquelle (Clearbox, ein Beratungsunternehmen für Intranets) stellt fest, dass die meisten Beschwerden über die Suche nicht an der Suchmaschine liegen, sondern an Inhalt, Struktur und Metadaten. Sie beschreibt vier Stufen, in denen Probleme entstehen können: Inhalt, Index, Abruf und Ergebnisse. Das passt zur Erfahrung: Wird ein Dokument nicht gefunden, kann der Titel unklar sein (Inhalt), die Seite nie indiziert worden sein (Index), die Anfrage das Wort des Lesers nicht treffen (Abruf) oder die Rangfolge das Dokument zu weit hinten zeigen (Ergebnisse). Wer Suchqualität messen will, braucht deshalb Beobachtungen aus der Sicht der Leser.

Der einfachste und aussagekräftigste Test ist eine *Testfragenliste*. Man sammelt zwanzig bis dreißig typische Fragen der Leser, legt zu jeder fest, welches Dokument die Antwort liefern soll, stellt die Fragen an die Suche und prüft, auf welchem Rang das erwartete Dokument erscheint. Zwei Kennzahlen fassen das zusammen: die *Top-3-Quote* (Anteil der Fragen, bei denen das erwartete Dokument unter den ersten drei Treffern liegt) und der *mittlere reziproke Rang* (englisch Mean Reciprocal Rank, MRR), der Rang eins mit 1, Rang zwei mit 0,5, Rang drei mit 0,33 und nicht gefunden mit 0 wertet und mittelt. Das folgende Skript berechnet beides aus einer Erwartungsliste und den von der Suche gelieferten Ergebnissen, die als Datei vorliegen.

```text
{"Wie starte ich den Shop neu": ["Neustart Shop", "Backup einrichten"],
 "Passwort zurücksetzen": ["Kantinenplan", "Notfallplan", "Passwortrichtlinie"],
 "VPN einrichten": [],
 "Backup wiederherstellen": ["Backup einrichten", "Restore Backup"]}
```

```python
import csv, json

ergebnisse = json.load(open("ergebnisse.json", encoding="utf-8"))
gold = list(csv.DictReader(open("gold.csv", encoding="utf-8"), delimiter=";"))
top3, rr = 0, 0.0
for z in gold:
    treffer = ergebnisse.get(z["frage"], [])
    rang = treffer.index(z["erwartet"]) + 1 if z["erwartet"] in treffer else None
    print(f"{z['frage']}: " + (f"Rang {rang}" if rang else "nicht gefunden"))
    top3 += bool(rang and rang <= 3)
    rr += 1 / rang if rang else 0
print(f"Top-3-Quote: {top3}/{len(gold)} = {100 * top3 / len(gold):.0f} Prozent")
print(f"Mittlerer reziproker Rang (MRR): {rr / len(gold):.2f}")
```

Die Erwartungsdatei `gold.csv` hat die Spalten `frage` und `erwartet` und listet die vier Fragen mit den Dokumenten Neustart Shop, Passwortrichtlinie, VPN Anleitung und Restore Backup. Die Ergebnisdatei oben simuliert, was die Suche lieferte. Das Skript meldet für die erste Frage Rang 1, für die zweite Rang 3, für die dritte „nicht gefunden“ (die Suche lieferte gar nichts) und für die vierte Rang 2. Die Top-3-Quote beträgt drei von vier, also 75 Prozent; der mittlere reziproke Rang ist 0,46, weil (1 + 0,33 + 0 + 0,5)/4 ergibt. Man sieht, dass die Quote allein gut aussieht, der MRR aber zeigt, dass die Treffer oft nicht ganz oben stehen. Wichtig ist der Vergleich im Zeitverlauf: Verbessert eine Maßnahme (neuer Titel, Synonym) die Werte, hat sie gewirkt.

Typische Fehler: Man misst nie; man testet mit dem Administratorkonto statt mit einem normalen Leserkonto, wodurch Berechtigungsprobleme verborgen bleiben (der Clearbox-Beitrag empfiehlt ausdrücklich, mit einem normalen Konto zu testen); die Testfragen stammen von den Autoren und nicht von echten Lesern; man ändert die Suche, ohne vorher und nachher zu messen.

| **Falsch**                        | **Richtig**                                                                           |
|:----------------------------------|:--------------------------------------------------------------------------------------|
| „Die Suche fühlt sich besser an.“ | Dieselben 25 Testfragen vor und nach der Änderung: Top-3-Quote von 55 auf 72 Prozent. |

Im Projekt lohnt sich ein vierteljährlicher Testlauf mit denselben Fragen, ergänzt um die häufigsten echten Anfragen aus dem Suchprotokoll (siehe Abschnitt Suchoptimierung intern).

## 15.4 Metadaten und Tags

Metadaten sind Daten über Dokumente: Titel, Owner, Status, Dokumentart, Zielgruppe, nächstes Prüfdatum, zugehöriges System. Sie machen aus einem Haufen Dateien einen durchsuchbaren, steuerbaren Bestand, denn nur über Metadaten kann man Fragen beantworten wie „Welche Dokumente des Teams Betrieb sind überfällig?“. Das Metadatenmodell wurde in Modul 03 entworfen; dieser Abschnitt betrachtet seine *Betriebsqualität*: Sind die Felder gefüllt, sind die Werte brauchbar? Der folgende Abschnitt „Tags und Labels“ behandelt die frei wählbaren Schlagwörter, die diese strukturierten Felder ergänzen.

Strukturierte Metadaten (feste Felder mit festen Werten) und Tags (frei oder aus einer Liste gewählte Schlagwörter) erfüllen verschiedene Aufgaben. Strukturierte Felder sind für Steuerung gedacht: Sie müssen vollständig und einheitlich sein, weil Auswertungen und Erinnerungen darauf beruhen. Tags dienen der Orientierung und dem Finden: Sie dürfen unvollständig sein, sollten aber nicht widersprüchlich sein. Wer beides vermischt, steuert mit unzuverlässigen Daten.

Der erste Schritt in der Pflege ist ein *Vollständigkeitsprofil*: Für jedes Feld wird gezählt, bei wie vielen Dokumenten es gefüllt ist. Das folgende Skript liefert dieses Profil aus einer Exportdatei und nennt die vollständig gepflegten Dokumente.

```text
titel;owner;status;naechste_pruefung;zielgruppe;tags
Notfallplan Shop;Leitung Betrieb;freigegeben;2027-03-01;Betrieb;notfall,shop
Runbook Neustart;Team Betrieb;freigegeben;;Betrieb;runbook
Runbook Backup;;freigegeben;2027-01-10;Betrieb;
Betriebshandbuch DB;Team Betrieb;entwurf;;;db
Grundlagen;Redaktion;freigegeben;2027-06-01;Alle;grundlagen,einstieg
```

```python
import csv

zeilen = list(csv.DictReader(open("meta.csv", encoding="utf-8"), delimiter=";"))
for feld in zeilen[0]:
    if feld == "titel":
        continue
    gefuellt = sum(1 for z in zeilen if z[feld].strip())
    print(f"{feld:18} {gefuellt}/{len(zeilen)} gefüllt ({100 * gefuellt // len(zeilen)} Prozent)")
vollstaendig = [z["titel"] for z in zeilen if all(z[f].strip() for f in z)]
print("Vollständig:", vollstaendig or "keine")
```

Das Ergebnis für die Beispieldaten: Der Status ist durchgängig gefüllt (100 Prozent), Owner, Zielgruppe und Tags sind zu 80 Prozent gefüllt, das nächste Prüfdatum nur zu 60 Prozent; vollständig gepflegt sind nur der Notfallplan und die Grundlagen. Das Profil sagt, wo der größte Hebel liegt: Das fehlende Prüfdatum macht Erinnerungen unmöglich, der fehlende Owner macht Verantwortung unklar. Beachten Sie: Ein gefülltes Feld ist nicht automatisch ein richtiges Feld. Das Skript prüft Vorhandensein, nicht Wahrheit; ein Owner, der längst ausgeschieden ist, zählt als gefüllt.

> **Ergänzung aus der Nachrecherche**
>
> Der abgerufene DMS-Fachartikel (siehe Modul 12) empfiehlt für jedes Dokument zwischen fünf und zehn Metainformationen und weist darauf hin, dass sie bei Daten aus Fachsystemen automatisch entstehen und bei eingescannten Dokumenten durch Texterkennung unterstützt werden können. Als Orientierung für die Praxis folgt daraus: Pflichtfelder auf wenige beschränken, möglichst automatisch füllen und nur dort manuelle Eingabe verlangen, wo sie nicht ableitbar ist. Die Zahl ist eine Empfehlung der Quelle, kein Standard. (Abruf 28.10.2026, siehe Quellenverzeichnis.)

Typische Fehler: Zu viele Pflichtfelder, die niemand pflegt; freie Textfelder, wo eine Auswahlliste nötig wäre; Felder mit Standardwerten, die nie geändert werden und daher nichts aussagen; Metadaten werden bei der Ablage gesetzt und nie wieder gepflegt.

| **Falsch**                                                        | **Richtig**                                                                                                                       |
|:------------------------------------------------------------------|:----------------------------------------------------------------------------------------------------------------------------------|
| Zwölf Pflichtfelder, davon acht stets mit dem Standardwert „n/a“. | Fünf Pflichtfelder (Dokumentart, Owner, Status, nächste Prüfung, Zielgruppe), Auswahllisten, automatische Vorbelegung wo möglich. |

Im Projekt führt man das Vollständigkeitsprofil monatlich und berichtet es an die Owner; eine sichtbare Quote ändert Verhalten stärker als jede Richtlinie.

## 15.5 Knowledge Base

Eine Knowledge Base (Wissensdatenbank) ist eine Sammlung von Artikeln, die konkrete Fragen und Probleme beantworten, meist in der Form „Wie löse ich X?“ oder „Was bedeutet Fehler Y?“. Sie unterscheidet sich von der Betriebsdokumentation, die ein System beschreibt, und von Richtlinien, die Regeln festlegen: Eine Knowledge Base ist *problemorientiert*. Leser kommen mit einem Symptom und wollen die Lösung; sie lesen nicht von vorn nach hinten. Die Informationsarchitektur (Modul 03) und die Schreibregeln (Modul 04) gelten auch hier, werden aber durch eine feste Artikelstruktur ergänzt.

Bewährt hat sich der Aufbau *Symptom, Ursache, Lösung, Betroffene Systeme*. Das Symptom beschreibt das, was der Leser sieht, in dessen Worten (nicht in Fachbegriffen des Entwicklers). Die Ursache erklärt, warum es auftritt, und hilft, Folgefehler zu verstehen. Die Lösung besteht aus nummerierten, prüfbaren Schritten. Die betroffenen Systeme und Versionen erlauben die Suche und die Zuordnung. Ein Artikel behandelt *ein* Problem; wer mehrere Probleme in einem Artikel mischt, findet sie schlecht.

Wie bei Vorlagen aus Modul 07 lässt sich die Struktur automatisch prüfen. Das folgende Skript durchsucht ein Verzeichnis von Artikeln und meldet fehlende Pflichtabschnitte, sehr kurze Artikel und vage Formulierungen.

```markdown
# Dienst startet nicht

## Symptom
Der Dienst shop startet nach dem Neustart nicht.

## Ursache
Port 8080 ist belegt.

## Lösung
1. Prozess auf dem Port ermitteln.
2. Prozess beenden und Dienst starten.

## Betroffene Systeme
shop
```

```python
import re, sys
from pathlib import Path

PFLICHT = ["Symptom", "Ursache", "Lösung", "Betroffene Systeme"]
for datei in sorted(Path(sys.argv[1]).glob("*.md")):
    text = datei.read_text(encoding="utf-8")
    abschnitte = re.findall(r"^## (.+)$", text, re.M)
    fehlt = [p for p in PFLICHT if p not in abschnitte]
    woerter = len(re.findall(r"\w+", text))
    befunde = []
    if fehlt:
        befunde.append("fehlende Abschnitte: " + ", ".join(fehlt))
    if woerter < 30:
        befunde.append(f"nur {woerter} Wörter")
    if re.search(r"\b(einfach|manchmal|irgendwie)\b", text, re.I):
        befunde.append("vage Formulierung")
    print(f"{datei.name}: " + ("; ".join(befunde) or "in Ordnung"))
```

Ich habe das Skript mit zwei Artikeln getestet: dem obigen und einem Artikel „Probleme mit dem Backup“ mit dem Inhalt „Manchmal geht das Backup nicht. Dann einfach nochmal probieren.“. Der erste wird als in Ordnung gemeldet, der zweite mit drei Befunden: Alle vier Pflichtabschnitte fehlen, er hat nur 13 Wörter, und er enthält vage Formulierungen. Das zweite Beispiel ist zugleich ein Anschauungsbeispiel für einen schlechten Artikel: Er nennt kein Symptom, keine Ursache und keine prüfbare Lösung. Die Prüfung findet Form, nicht Inhalt. Ob die Lösung stimmt, prüft nur ein Mensch, der sie ausprobiert.

Typische Fehler: Artikel erklären das System, statt ein Problem zu lösen; sie sind in der Sprache der Entwickler geschrieben; mehrere Probleme in einem Artikel; Lösungen ohne Versionsangabe, die nach dem nächsten Update nicht mehr funktionieren; Artikel ohne Owner und Prüfdatum, die nach einem Jahr falsch sind.

| **Falsch**                                                            | **Richtig**                                                                                               |
|:----------------------------------------------------------------------|:----------------------------------------------------------------------------------------------------------|
| Titel „Backup“, Inhalt: Beschreibung der gesamten Backup-Architektur. | Titel „Backup schlägt mit Fehler 12 fehl“, Symptom, Ursache, Lösung in vier Schritten, Version angegeben. |

Im Projekt entstehen die besten Artikel direkt aus gelösten Support-Fällen: Wer ein Problem löst, schreibt die Lösung in der Artikelstruktur auf, solange sie frisch ist (siehe Abschnitt FAQ und Knowledge Base).

## 15.6 Onboarding-Unterlagen

Onboarding-Unterlagen helfen neuen Mitarbeitenden, in der ersten Zeit produktiv zu werden. Dieser Abschnitt behandelt die *Zusammenstellung und Pflege* der Unterlagen für eine Rolle: Welche Dokumente braucht jemand in der ersten Woche, nach 30, 60 und 90 Tagen, und stimmen diese Dokumente noch? Der Abschnitt „Onboarding Dokumentation“ weiter unten behandelt dagegen die *Gestaltung der Einstiegsdokumente selbst* (Aufbau, Umfang, Lesezeit).

Der Wert guter Onboarding-Unterlagen ist hoch, weil sie jedes Mal genutzt werden, wenn jemand neu beginnt, und weil neue Mitarbeitende die Schwachstellen der Dokumentation besonders deutlich erleben: Sie kennen das Wissen noch nicht, das Erfahrene unbewusst ergänzen. Eine abgerufene Onboarding-Checkliste (HiBob, ein Anbieter von Personalsoftware) gliedert den Einstieg in die Phasen vor dem ersten Tag, erster Tag, erste Woche, mit Zielen für 30, 60 und 90 Tage und Rückblicken nach 30 und 90 Tagen. Für Dokumentation heißt das: Je Rolle ein Lernpfad, der in Phasen gegliedert ist, mit klarer Reihenfolge.

Entscheidend ist, dass der Pfad aus den *vorhandenen* Dokumenten besteht und nicht aus einer eigenen Kopie. So bleibt er automatisch aktuell, wenn die Dokumente gepflegt werden. Das folgende Skript erzeugt aus einer Rollenbeschreibung eine Checkliste und prüft dabei jedes Dokument gegen den Bestand: Existiert es, ist es freigegeben, ist seine Prüfung überfällig?

```yaml
rollen:
  betrieb:
    woche1: [Willkommen, Zugänge beantragen, Notfallplan Shop]
    tag30: [Runbook Neustart, Runbook Backup]
    tag60: [Betriebshandbuch DB]
    tag90: [Richtlinie Backup]
```

```python
import csv, sys, yaml
from datetime import date

HEUTE = date(2026, 10, 28)
doks = {z["titel"]: z for z in csv.DictReader(open("dokumente.csv", encoding="utf-8"), delimiter=";")}
plan = yaml.safe_load(open("onboarding.yaml", encoding="utf-8"))["rollen"][sys.argv[1]]

for phase, titel_liste in plan.items():
    print(f"## {phase}")
    for t in titel_liste:
        d = doks.get(t)
        if d is None:
            hinweis = "FEHLT im Bestand"
        elif d["status"] != "freigegeben":
            hinweis = f"Status {d['status']} - nicht freigegeben"
        elif date.fromisoformat(d["naechste_pruefung"]) < HEUTE:
            hinweis = "Prüfung überfällig"
        else:
            hinweis = "ok"
        print(f"- [ ] {t} ({hinweis})")
```

Der Aufruf `python3 onboarding_plan.py betrieb` gibt je Phase eine Markdown-Checkliste aus. Mit den Beispieldaten sind drei der sechs Dokumente der ersten beiden Phasen in Ordnung, „Zugänge beantragen“ hat eine überfällige Prüfung, das Runbook Backup ist nur ein Entwurf, das Betriebshandbuch DB ist überfällig, und die Richtlinie Backup fehlt im Bestand. Dieses Ergebnis ist eine *Reparaturliste*: Bevor die nächste Person beginnt, sollten die Lücken im Lernpfad geschlossen sein. Der Pfad zeigt damit nebenbei, welche Dokumente besonders wichtig sind, nämlich die, die jede neue Person liest.

> **Ergänzung aus der Nachrecherche**
>
> Nach der abgerufenen Checkliste umfasst die Vorbereitung vor dem ersten Tag unter anderem Konten und Systemzugänge, die erste Woche enthält die Vorstellung der Systeme und Prozesse sowie die Festlegung von Zielen für 30, 60 und 90 Tage, und es gibt Rückblicke nach 30 und 90 Tagen. Es handelt sich um die Empfehlung eines Anbieters von Personalsoftware, nicht um einen Standard; sie dient hier als Anregung für die Gliederung eines Lernpfads. (Abruf 28.10.2026, siehe Quellenverzeichnis.)

Typische Fehler: Die Unterlagen sind eine zusammenkopierte Mappe mit veralteten Inhalten; es gibt keine Reihenfolge, sodass Neue alles gleichzeitig lesen; die Unterlagen setzen Wissen voraus, das Neue nicht haben; es gibt keine Rückmeldung der Neuen; Zugänge fehlen, sodass verlinkte Dokumente gar nicht geöffnet werden können.

| **Falsch**                                                    | **Richtig**                                                                                                           |
|:--------------------------------------------------------------|:----------------------------------------------------------------------------------------------------------------------|
| Ein Ordner „Neue Mitarbeiter“ mit 60 Dateien, teils aus 2021. | Ein Pfad je Rolle mit Phasen, aus aktuellen Dokumenten zusammengesetzt, jede Phase mit Zeitbudget und Ansprechperson. |

Im Projekt bittet man jede neue Person, den Pfad nach 30 Tagen zu bewerten und Lücken zu melden; ihr unverstellter Blick ist die ehrlichste Qualitätsprüfung der Dokumentation.

## 15.7 Feedback-Prozesse

Leser sind die besten Prüfer der Dokumentation, weil sie sie tatsächlich benutzen. Damit ihr Wissen ankommt, braucht es einen *Prozess*: Er legt fest, wo Rückmeldungen eingehen, wer sie sichtet, wie schnell sie beantwortet werden und was mit ihnen geschieht. Dieser Abschnitt betrachtet den Ablauf und seine Verbindlichkeit; der Abschnitt „Feedback Mechanismen“ betrachtet die technischen Wege, auf denen Rückmeldungen erfasst werden (Bewertungsknöpfe, Kommentare, Meldeformulare).

Ein tragfähiger Feedback-Prozess hat fünf Schritte. *Erfassen*: Rückmeldungen werden an einer Stelle gesammelt, nicht in privaten Postfächern. *Sichten*: Jemand ordnet sie zu (Fehler, Frage, Verbesserungsvorschlag) und weist sie dem zuständigen Owner zu. *Beantworten*: Die Person erhält eine Rückmeldung, selbst wenn die Antwort „nicht umsetzbar, weil …“ lautet. *Umsetzen*: Berechtigte Rückmeldungen werden in die Pflege übernommen (Korrekturen) oder in einen Backlog gestellt (Verbesserungen, siehe Modul 16). *Rückkoppeln*: Auswertungen zeigen, welche Dokumente besonders oft Rückmeldungen auslösen. Der häufigste Grund, dass Rückmeldungen versiegen, ist, dass die ersten Meldungen ohne Antwort blieben: Wer erlebt, dass nichts passiert, meldet nicht mehr.

Die Verbindlichkeit macht man über *Antwortfristen* (Service Level) sichtbar, die nach Art der Rückmeldung gestaffelt sind: Ein Fehler in einer Betriebsanleitung braucht eine schnelle Reaktion, ein Verbesserungsvorschlag darf länger warten. Das folgende Skript wertet eine Liste von Rückmeldungen aus: Es meldet je Eintrag, ob und wann er beantwortet wurde und ob die Frist verletzt ist, und berechnet die mittlere Antwortzeit.

```text
id;seite;eingegangen;beantwortet;art
1;Runbook Neustart;2026-10-01;2026-10-03;fehler
2;Runbook Neustart;2026-10-10;;fehler
3;Notfallplan Shop;2026-09-01;;verbesserung
4;Backup;2026-10-25;2026-10-26;frage
5;Backup;2026-10-27;;frage
```

```python
import csv
from datetime import date

HEUTE = date(2026, 10, 28)
SLA = {"fehler": 5, "frage": 3, "verbesserung": 30}   # Tage bis zur ersten Antwort

dauern = []
for z in csv.DictReader(open("feedback.csv", encoding="utf-8"), delimiter=";"):
    ein = date.fromisoformat(z["eingegangen"])
    if z["beantwortet"]:
        tage = (date.fromisoformat(z["beantwortet"]) - ein).days
        dauern.append(tage)
        status = "beantwortet" + (f" nach {tage} Tagen" if tage <= SLA[z["art"]] else f" nach {tage} Tagen (SLA verletzt)")
    else:
        offen = (HEUTE - ein).days
        status = f"OFFEN seit {offen} Tagen" + (" (SLA verletzt)" if offen > SLA[z["art"]] else "")
    print(f"#{z['id']} {z['seite']} [{z['art']}]: {status}")
print(f"Mittlere Antwortzeit: {sum(dauern) / len(dauern):.1f} Tage")
```

Die Ausgabe: Meldung 1 wurde nach zwei Tagen beantwortet; Meldung 2 (ein Fehler) ist seit 18 Tagen offen und verletzt die Fünf-Tage-Frist; Meldung 3 (eine Verbesserung) ist seit 57 Tagen offen und verletzt die Frist von 30 Tagen; Meldung 4 wurde nach einem Tag beantwortet; Meldung 5 ist seit einem Tag offen und liegt noch in der Frist. Die mittlere Antwortzeit beträgt 1,5 Tage. Diese Zahl ist trügerisch gut, weil sie nur beantwortete Meldungen zählt und die beiden stark überfälligen ausblendet. Das ist ein Standardproblem von Kennzahlen: Wer nur das Erledigte misst, übersieht das Liegengebliebene. Die Zahl der verletzten Fristen und das Alter der ältesten offenen Meldung sind aussagekräftiger.

Typische Fehler: Rückmeldungen landen in persönlichen Postfächern; es gibt keine Zuständigkeit für die Sichtung; die Antwort bleibt aus; Rückmeldungen werden gesammelt, aber nie ausgewertet; es wird nur das Positive gezählt.

| **Falsch**                                               | **Richtig**                                                                                                          |
|:---------------------------------------------------------|:---------------------------------------------------------------------------------------------------------------------|
| Mail an „doku@…“, die ein Praktikant gelegentlich liest. | Zentraler Eingang, benannte Person für die Sichtung, Antwortfristen nach Art, wöchentliche Auswertung offener Fälle. |

Im Projekt genügt ein einfacher Rhythmus: Einmal pro Woche eine halbe Stunde, in der offene Rückmeldungen zugeordnet und beantwortet werden. Wichtiger als ein ausgefeiltes Werkzeug ist, dass jede Meldung eine Antwort bekommt.

## 15.8 Wissensmanagement-Troubleshooting

Dieser Abschnitt zeigt, wie man typische Fehlerbilder im Wissensmanagement anhand von Struktur, Aktualität, Zielgruppenfeedback und Review-Kommentaren eingrenzt und daraus Runbook-Schritte für Redaktion, Fachbereich und Betrieb ableitet. Anders als der Abschnitt zur Nutzungsanalyse betrachtet er die *Organisation insgesamt*: Wo steht die Wissensbasis, und was ist als Erstes zu tun?

Die Symptome sind bekannt: „Niemand findet etwas“, „alles ist veraltet“, „jeder fragt lieber Kollegen“, „die Rückmeldungen versanden“. Jedes hat mehrere mögliche Ursachen, und die Kunst besteht darin, die wahrscheinlichste zu finden, ohne zu raten. Dafür hilft eine kleine Reihe von Kennzahlen, die je ein Teilsystem beschreiben: die Owner-Quote (Anteil der Dokumente mit gültigem Owner), die Aktualitätsquote (Modul 14 und Modul 16), die Top-3-Quote der Suche, die Nulltreffer-Quote und die Antwortzeit auf Rückmeldungen. Aus Schwellenwerten lässt sich eine Diagnose ableiten, die eine Reihenfolge der Maßnahmen vorschlägt.

```yaml
top3_quote: 0.55
aktualitaetsquote: 0.48
nulltreffer_quote: 0.22
owner_quote: 0.91
antwortzeit_tage: 9
```

```python
import yaml

k = yaml.safe_load(open("kennzahlen.yaml", encoding="utf-8"))
REGELN = [
    ("owner_quote", "<", 0.95, "Owner fehlen: zuerst Verantwortliche zuordnen (Owner-Modell)"),
    ("aktualitaetsquote", "<", 0.70, "Bestand veraltet: Review-Kalender und Erinnerungen prüfen (Modul 14)"),
    ("top3_quote", "<", 0.70, "Suche findet zu selten: Titel, Metadaten, Synonyme verbessern"),
    ("nulltreffer_quote", ">", 0.10, "Viele Anfragen ohne Treffer: Lücken oder fehlende Synonyme"),
    ("antwortzeit_tage", ">", 5, "Feedback bleibt liegen: Zuständigkeit und SLA klären"),
]
for name, op, grenze, text in REGELN:
    wert = k[name]
    if (op == "<" and wert < grenze) or (op == ">" and wert > grenze):
        print(f"{name} = {wert} ({op} {grenze}): {text}")
```

Die Regeln stehen in einer Reihenfolge, die Ursachen vor Folgen setzt, wie schon in Modul 12 (Tool-Troubleshooting): Ohne Owner nützen Erinnerungen nichts, ohne aktuellen Bestand bringt eine bessere Suche wenig. Mit den Beispielwerten (die ich frei gewählt habe und die keine Benchmarks sind) schlagen alle fünf Regeln an. Das Skript nennt für jede die Kennzahl, ihren Wert, den Schwellenwert und die Maßnahme. Die Schwellen sind Beispiele, die jede Organisation selbst festlegen muss; die abgerufenen Quellen zur Aktualität (Metabase) nennen ausdrücklich kein allgemeingültiges Ziel.

Als Runbook ergibt sich: Kennzahlen erheben; die erste angeschlagene Regel in der Reihenfolge bearbeiten; nach vier bis acht Wochen neu messen; erst dann die nächste Regel. Es ist besser, eine Ursache gründlich zu beheben als fünf gleichzeitig anzufassen, weil man sonst nicht erkennt, was gewirkt hat. Zur Absicherung ergänzt man qualitative Beobachtungen: Zwei bis drei Gespräche mit Lesern decken oft auf, was die Zahlen nicht zeigen.

Typische Fehler: Man misst nicht und diskutiert Meinungen; man behebt die sichtbaren Symptome (Suche) statt der Ursachen (Owner); man nimmt Schwellen von anderen Organisationen unreflektiert; man steuert nur nach Kennzahlen und vergisst, dass sie Hilfsmittel sind (siehe Modul 16, KPI-Troubleshooting).

| **Falsch**                                                             | **Richtig**                                                                                                               |
|:-----------------------------------------------------------------------|:--------------------------------------------------------------------------------------------------------------------------|
| „Die Leute nutzen die Wissensbasis nicht, wir brauchen eine Schulung.“ | „Owner-Quote 91, Aktualität 48, Nulltreffer 22 Prozent: Erst Owner und Pflege, dann Suche; Schulung danach, falls nötig.“ |

Im Projekt macht eine einseitige Kennzahlenübersicht das Gespräch mit der Leitung sachlich: Sie zeigt, wo die Lücke ist, was zuerst zu tun ist und welche Ressourcen dafür nötig sind.

## 15.9 Wissensmanagement

Wissensmanagement ist der übergeordnete Begriff für alles, was eine Organisation tut, damit das Wissen ihrer Mitarbeitenden verfügbar, auffindbar und nutzbar bleibt. Dokumentation ist ein Teil davon, aber nicht das Ganze: Ein großer Teil dessen, was Menschen wissen, steht nirgends. Man unterscheidet *explizites Wissen*, das sich aufschreiben lässt (Anleitungen, Regeln, Konfigurationen), und *implizites Wissen*, das in Erfahrung, Routine und Urteilsvermögen steckt und sich nur schwer in Worte fassen lässt, etwa das Gefühl eines erfahrenen Administrators, welcher Fehler zu welchem Dienst passt. Ein bekanntes Modell von Nonaka und Takeuchi beschreibt, wie Wissen zwischen diesen Formen wechselt: durch gemeinsames Erleben, durch Aussprechen und Aufschreiben, durch Kombination vorhandener Dokumente und durch Verinnerlichung beim Anwenden (allgemeines Fachwissen, nicht aus einer abgerufenen Quelle belegt).

Für die Dokumentation folgt daraus eine nüchterne Prioritätenliste. Man kann nicht alles Wissen aufschreiben und sollte es auch nicht versuchen. Aufschreibenswert ist, was *kritisch* ist (Ausfall oder Fehler verursachen Schaden), was *selten* gebraucht wird (sonst erinnert man es nicht) und was *nur wenige wissen*. Gerade die dritte Gruppe ist gefährlich: Wissen, das nur bei einer Person liegt, geht mit ihr verloren. Eine *Wissenslandkarte* macht diese Risiken sichtbar. Sie listet Themen auf, nennt die Personen, die das Thema beherrschen (Träger), den Stand der Dokumentation und die Kritikalität.

Das folgende Skript berechnet aus einer solchen Karte ein einfaches Risiko je Thema: Kritikalität (eins bis drei) mal einer Zahl, die die Dokumentationslücke (null, eins oder zwei) und einen Zuschlag von zwei für einen einzigen Träger erfasst. Die Formel ist eine Konvention für dieses Beispiel, nicht ein Standard; sie soll die Rangfolge nachvollziehbar machen.

```text
thema;traeger;dokumentiert;kritikalitaet
Shop-Neustart;Meier,Huber;ja;hoch
Datenbank-Restore;Schmid;nein;hoch
Legacy-Schnittstelle;Berger;nein;mittel
Druckerwartung;Huber,Meier,Schmid;ja;niedrig
Zertifikatserneuerung;Meier;teilweise;hoch
```

```python
import csv

STUFE = {"niedrig": 1, "mittel": 2, "hoch": 3}
DOK = {"ja": 0, "teilweise": 1, "nein": 2}
ergebnis = []
for z in csv.DictReader(open("wissen.csv", encoding="utf-8"), delimiter=";"):
    traeger = z["traeger"].split(",")
    risiko = STUFE[z["kritikalitaet"]] * (DOK[z["dokumentiert"]] + (2 if len(traeger) == 1 else 0))
    ergebnis.append((risiko, z["thema"], len(traeger), z["dokumentiert"]))
for risiko, thema, n, dok in sorted(ergebnis, reverse=True):
    print(f"Risiko {risiko:2}: {thema} ({n} Träger, dokumentiert: {dok})")
```

Die Ausgabe ordnet die Themen nach Risiko: Der Datenbank-Restore führt mit zwölf Punkten (hohe Kritikalität, nur ein Träger, nicht dokumentiert), gefolgt von der Zertifikatserneuerung mit neun (ein Träger, teilweise dokumentiert) und der Legacy-Schnittstelle mit acht. Shop-Neustart und Druckerwartung liegen bei null, weil sie von mehreren Personen beherrscht und dokumentiert sind. Daraus ergibt sich die Arbeitsliste für die nächsten Wochen: Das Wissen des Datenbank-Restores sichern (aufschreiben lassen, besser: gemeinsam mit einer zweiten Person durchführen und dabei protokollieren), danach die Zertifikatserneuerung. Das Skript sagt nichts über die Qualität der Dokumentation, nur über ihre Existenz; „ja“ in der Spalte kann auch ein veraltetes Dokument bedeuten.

Typische Fehler: Man betrachtet nur geschriebene Dokumente und übersieht das, was in Köpfen steckt; man verlangt von Experten, „alles aufzuschreiben“, ohne Zeit dafür zu geben; das Wissen wird erst beim Ausscheiden gesichert, wenn es zu spät ist; die Landkarte ist ein einmaliges Projekt statt eines laufenden Instruments.

| **Falsch**                                                                                  | **Richtig**                                                                                                                                     |
|:--------------------------------------------------------------------------------------------|:------------------------------------------------------------------------------------------------------------------------------------------------|
| Wissenssicherung beginnt im Exit-Interview: „Schreiben Sie bitte noch auf, was Sie wissen.“ | Regelmäßige Wissenslandkarte; kritisches Einzelwissen wird gesichert, solange die Person da ist, durch gemeinsames Durchführen und Aufzeichnen. |

Im Projekt wirkt die Zusammenarbeit besser als die Aufforderung zum Schreiben: Ein Interview, ein gemeinsamer Durchlauf oder eine kurze Aufzeichnung mit anschließender Redaktion entlastet den Experten und erzeugt trotzdem ein Dokument.

## 15.10 Suchoptimierung intern

Suchoptimierung intern ist der laufende Verbesserungsprozess der Suche in der eigenen Wissensbasis. Während der Abschnitt „Suchbarkeit“ dieses Moduls die Messung der Suchqualität mit Testfragen beschreibt, geht es hier um die *Auswertung des tatsächlichen Verhaltens der Leser*, also um das Suchprotokoll: Wonach wird gesucht, was wird nicht gefunden, was wird gefunden, aber nicht angeklickt?

Die abgerufene Praxisquelle (Clearbox) empfiehlt, die Suchprotokolle zu prüfen und die häufigsten Anfragen zu betrachten; als Erfahrungswert nennt der Autor, dass einige dreißig bis vierzig Anfragen den Großteil aller Suchen ausmachen können. Das ist eine Aussage eines Praktikers, kein allgemeines Gesetz, passt aber zur Erfahrung, dass die Verteilung der Anfragen sehr ungleich ist: Wenige Begriffe machen viel aus, und eine Verbesserung bei diesen wenigen wirkt sofort. Weitere Empfehlungen derselben Quelle: die wichtigsten Begriffe selbst mit einem normalen Konto zu suchen, die Ursachen je Begriff zu diagnostizieren, Metadaten und Schlagwörter zu vereinheitlichen, Synonyme zu berücksichtigen, aussagekräftige Titel zu verwenden und lange Sammeldokumente in einzelne Seiten aufzuteilen.

Das folgende Skript wertet ein Suchprotokoll aus. Es zählt die häufigsten Anfragen, den Anteil der Anfragen ohne Treffer, die Anfragen, die ohne Treffer endeten, und die Klickrate bei Anfragen mit Treffern. Anfragen werden dabei in Kleinbuchstaben zusammengefasst, damit „VPN“ und „vpn“ gemeinsam zählen.

```text
anfrage;treffer;geklickt
vpn;0;nein
VPN;0;nein
neustart;3;ja
neustart shop;2;ja
kennwort;0;nein
passwort;4;ja
backup;5;nein
backup;5;ja
vpn einrichten;0;nein
```

```python
import csv
from collections import Counter

zeilen = list(csv.DictReader(open("suchlog.csv", encoding="utf-8"), delimiter=";"))
haeufig = Counter(z["anfrage"].lower() for z in zeilen)
print("Häufigste Anfragen:", haeufig.most_common(3))

null = [z for z in zeilen if z["treffer"] == "0"]
print(f"Ohne Treffer: {len(null)} von {len(zeilen)} ({100 * len(null) // len(zeilen)} Prozent)")
print("  davon:", dict(Counter(z["anfrage"].lower() for z in null)))

mit_treffer = [z for z in zeilen if z["treffer"] != "0"]
klick = sum(1 for z in mit_treffer if z["geklickt"] == "ja")
print(f"Klickrate bei Anfragen mit Treffern: {klick}/{len(mit_treffer)}")
```

Die Auswertung ergibt: Am häufigsten sind „vpn“ und „backup“ mit je zwei Anfragen, danach „neustart“. Vier von neun Anfragen, also 44 Prozent, blieben ohne Treffer, und zwar „vpn“ zweimal, „kennwort“ und „vpn einrichten“. Bei den fünf Anfragen mit Treffern wurde in vier Fällen geklickt. Daraus lassen sich zwei Maßnahmen ableiten: Zum Thema VPN fehlt offenbar ein Dokument (eine Lücke im Inhalt), und für „kennwort“ fehlt ein Synonym zu „passwort“, denn dieses Wort führt zu vier Treffern. Die Anfrage „backup“ lieferte fünf Treffer, wurde aber einmal nicht angeklickt; das ist ein Hinweis, die Rangfolge oder die Titel für diesen Begriff zu prüfen.

> **Ergänzung aus der Nachrecherche**
>
> Zur Gestaltung der Seite, die bei einer Suche ohne Treffer erscheint, nach einem abgerufenen Beitrag der Nielsen Norman Group: Die Seite soll erstens deutlich machen, dass es keine Treffer gibt, weil Nutzer unscheinbare Hinweise überlesen; zweitens einen Weg nach vorn anbieten (die Anfrage im Suchfeld belassen, ähnliche Anfragen oder Korrekturen vorschlagen, Hinweise zum Umformulieren geben); drittens den Nutzer nicht durch Humor bloßstellen. Für interne Wissensbasen heißt das: Eine Nulltreffer-Seite, die auf Synonyme, verwandte Themen und eine Möglichkeit verweist, eine Lücke zu melden, verwandelt eine gescheiterte Suche in eine Rückmeldung. (Abruf 28.10.2026, siehe Quellenverzeichnis.)

Typische Fehler: Man wertet das Suchprotokoll nie aus; man betrachtet nur die Gesamtzahl der Suchen; man ergänzt Synonyme auf Verdacht statt nach echten Anfragen; man vernachlässigt die Auswirkung kleiner Änderungen und misst nicht nach.

| **Falsch**                                                                 | **Richtig**                                                                                             |
|:---------------------------------------------------------------------------|:--------------------------------------------------------------------------------------------------------|
| Synonymliste mit 200 Einträgen, die jemand am Schreibtisch ausgedacht hat. | Synonyme aus den dreißig häufigsten erfolglosen Anfragen, nach vier Wochen mit dem Protokoll überprüft. |

Im Projekt reicht ein monatlicher Termin von einer Stunde, in dem man die zehn häufigsten Nulltreffer-Anfragen bespricht und je eine Maßnahme festlegt: Inhalt schreiben, Synonym ergänzen oder Titel ändern. Beachten Sie, dass Suchprotokolle personenbezogen sein können; werten Sie sie, wo möglich, ohne Benutzerkennung aus (Modul 13).

## 15.11 Tags und Labels

Tags und Labels sind Schlagwörter, mit denen man Dokumente über die Ordnerstruktur hinaus quer einordnet. Der Abschnitt „Metadaten und Tags“ hat betont, dass Tags der Orientierung dienen; hier geht es um die *Verwaltung des Vokabulars*. Die Plattformseite (Confluence-Labels, kontrollierte Vokabulare) wurde in Modul 12 behandelt. Hier steht der laufende Betrieb im Mittelpunkt: Wie hält man ein Vokabular sauber, wenn es über Jahre wächst?

Es gibt zwei Grundmodelle. In einem *kontrollierten Vokabular* darf nur verwendet werden, was in einer Liste steht; neue Begriffe werden zentral aufgenommen. Das sorgt für Einheitlichkeit, kostet aber Aufwand und Flexibilität. In einem *freien Vokabular* darf jeder beliebige Tags vergeben (im Fachjargon auch Folksonomie genannt), was schnell und anpassungsfähig ist, aber zu Schreibvarianten und Synonymen führt. In der Praxis wählt man oft einen Mittelweg: ein kleines kontrolliertes Kernvokabular für wichtige Kategorien und Freiheit für Ergänzungen, die regelmäßig gesichtet und entweder aufgenommen, zusammengeführt oder gelöscht werden.

Die Pflege des Vokabulars besteht aus drei Handgriffen: *Zusammenführen* (mehrere Schreibweisen auf eine reduzieren), *Umbenennen* (ein Tag erhält einen besseren Namen) und *Löschen* (ungenutzte oder nur einmal verwendete Tags entfernen). Das folgende Skript führt das Zusammenführen mit einer Zuordnungstabelle durch. Es wendet die Tabelle auf eine Seitenliste an, bringt alle Tags in Kleinbuchstaben, entfernt Doppelte und meldet, welche Seiten sich geändert haben, wie viele verschiedene Tags es vorher und nachher gab und welche Tags nur einmal vorkommen.

```yaml
runbooks: runbook
datenbank: db
sicherung: backup
```

```python
import csv, yaml
from collections import Counter

karte = yaml.safe_load(open("tagmap.yaml", encoding="utf-8"))
vorher, nachher = Counter(), Counter()
for z in csv.DictReader(open("seiten2.csv", encoding="utf-8"), delimiter=";"):
    alt = [t.strip() for t in z["tags"].split(",") if t.strip()]
    neu = []
    for t in alt:
        t2 = karte.get(t.lower(), t.lower())
        if t2 not in neu:
            neu.append(t2)
    vorher.update(alt)
    nachher.update(neu)
    if neu != alt:
        print(f"{z['titel']}: {','.join(alt)} -> {','.join(neu)}")
print("Verschiedene Tags vorher:", len(vorher), "nachher:", len(nachher))
print("Nur einmal verwendet:", sorted(t for t, n in nachher.items() if n == 1))
```

Die Seitenliste `seiten2.csv` enthielt vier Seiten: Neustart Shop („runbook,shop“), Backup einrichten („Runbook,sicherung“), Wartung DB („runbooks,datenbank,db“) und Kantinenplan („kantine“). Das Skript meldet zwei Änderungen: Backup einrichten wird zu „runbook,backup“, Wartung DB zu „runbook,db“ (aus drei Tags werden zwei, weil „datenbank“ und „db“ zu demselben Tag zusammenfallen). Die Zahl der verschiedenen Tags sinkt von acht auf fünf. Die Liste der nur einmal verwendeten Tags (backup, db, kantine, shop) zeigt Kandidaten für die Prüfung: Ein Tag, das nur eine Seite trägt, hilft beim Auffinden nicht, es sei denn, es wird künftig häufiger verwendet. Das Skript ändert keine Quelldateien, sondern liefert einen Vorschlag; die Umsetzung gehört in einen kontrollierten Vorgang mit Protokoll.

Typische Fehler: Kein Verantwortlicher für das Vokabular; neue Tags entstehen ungebremst; Tags und Dokumentarten werden vermischt; Zusammenführungen werden ohne Ankündigung durchgeführt und verwirren Nutzer, die ihre bekannten Tags nicht mehr finden; man löscht Tags, ohne dass man vorher geprüft hat, ob Auswertungen oder Makros darauf beruhen.

| **Falsch**                                                                                                 | **Richtig**                                                                                                       |
|:-----------------------------------------------------------------------------------------------------------|:------------------------------------------------------------------------------------------------------------------|
| Nach drei Jahren gibt es 900 Tags, 600 davon nur einmal verwendet, mit sieben Schreibweisen für „Runbook“. | Vorgegebener Kern von zwanzig Tags, vierteljährliche Pflege, Zuordnungstabelle für Synonyme und Schreibvarianten. |

Im Projekt benennt man einen *Vokabular-Verantwortlichen* (oft die Redaktion), der die Tag-Liste verwaltet, Änderungswünsche sammelt und vierteljährlich eine Bereinigung durchführt.

## 15.12 FAQ und Knowledge Base

Der Abschnitt „Knowledge Base“ hat den Aufbau einzelner Artikel behandelt. Hier geht es um das *Entstehen und Pflegen* von FAQ (häufig gestellte Fragen) und dem Zusammenhang zur Knowledge Base. Eine FAQ ist eine kurze Liste von Fragen mit knappen Antworten zu einem Thema; die Knowledge Base enthält die ausführlichen Artikel dazu. Die FAQ ist die schnelle Antwort, der Artikel die vollständige. Sie ergänzen sich, wenn jede FAQ-Antwort kurz bleibt und auf den passenden Artikel verweist.

Die wichtigste Regel für FAQ lautet: *häufig* ist keine Behauptung, sondern eine Messgröße. Eine Frage gehört in die FAQ, weil sie tatsächlich oft gestellt wird, nicht weil jemand sie für wichtig hält. Die beste Datenquelle sind Support-Tickets, Chat-Fragen und Suchanfragen. Wer sie systematisch auswertet, findet die Themen, die den meisten Aufwand verursachen, und kann sie mit einem einzigen guten Artikel an der Quelle lösen.

Das folgende Skript zeigt das Prinzip an Ticket-Titeln. Es zerlegt jeden Titel in Wörter, entfernt Füllwörter, zählt, in wie vielen Tickets jedes Wort vorkommt, und nennt Wörter mit mindestens zwei Tickets als FAQ-Kandidaten. Es ist bewusst einfach: Eine echte Auswertung würde Wortstämme (Verbindung und verbindet), Rechtschreibvarianten und Zusammenhänge berücksichtigen, was mehr Aufwand oder spezielle Bibliotheken erfordert.

```text
titel
VPN verbindet nicht
Passwort vergessen
VPN Verbindung bricht ab
Passwort zurücksetzen
VPN einrichten auf Laptop
Drucker druckt nicht
Passwort abgelaufen
VPN Fehler 809
```

```python
import csv, re
from collections import Counter

STOPP = {"auf", "nicht", "und", "der", "die", "das", "ein", "mit"}
zaehler = Counter()
for z in csv.DictReader(open("tickets_support.csv", encoding="utf-8")):
    for w in set(re.findall(r"\w+", z["titel"].lower())) - STOPP:
        zaehler[w] += 1
for wort, n in zaehler.most_common(5):
    if n >= 2:
        print(f"FAQ-Kandidat '{wort}': {n} Tickets")
```

Mit den acht Beispieltickets nennt das Skript zwei Kandidaten: „vpn“ mit vier Tickets und „passwort“ mit drei. Das Wort „nicht“ steht auf der Stoppliste, sonst käme es mit zwei Tickets ebenfalls vor. Aus den Kandidaten entsteht je ein Artikel und eine FAQ: für VPN etwa „VPN-Verbindung einrichten und Fehler beheben“, für Passwörter „Passwort zurücksetzen“. Dass die Zählung nach Wörtern arbeitet, ist zugleich die Schwäche: „VPN verbindet nicht“ und „VPN Verbindung bricht ab“ teilen nur das Wort „vpn“, obwohl beide um die gleiche Sache gehen. Die Auswertung liefert Hinweise, kein fertiges Ergebnis, und die Aufgabe, daraus Themen zu bilden, bleibt eine menschliche.

Typische Fehler: FAQ nach Gefühl statt nach Daten; zu viele Fragen (Hundert Fragen in einer Liste findet niemand); Antworten, die selbst lang sind und nicht auf Artikel verweisen; FAQ, die nie gepflegt werden; Fragen aus Sicht der Entwickler („Wie ist die Architektur?“) statt aus Sicht der Nutzer.

| **Falsch**                                                              | **Richtig**                                                                                                                                 |
|:------------------------------------------------------------------------|:--------------------------------------------------------------------------------------------------------------------------------------------|
| FAQ mit 120 Fragen, geschrieben von Entwicklern, zuletzt geändert 2022. | FAQ mit zehn bis fünfzehn Fragen aus den häufigsten Support-Tickets, je mit Kurzantwort und Verweis auf den Artikel, quartalsweise geprüft. |

Im Projekt schließt sich ein Kreis: Eine häufige Ticketart wird zum Artikel und zur FAQ, das Ticketsystem verweist in der Antwortvorlage darauf, und die Zahl dieser Tickets sinkt, was man wiederum als Erfolg des Wissensmanagements messen kann.

## 15.13 Onboarding Dokumentation

Während der Abschnitt „Onboarding-Unterlagen“ den Lernpfad aus vorhandenen Dokumenten zusammenstellt, behandelt dieser Abschnitt die *Gestaltung der Einstiegsdokumente selbst*: Wie lang dürfen sie sein, was gehört hinein, und wie stellt man sicher, dass der Pfad in der geplanten Zeit zu bewältigen ist? Neue Mitarbeitende lesen anders als Erfahrene. Sie haben keinen Kontext, kennen die Begriffe nicht und wissen nicht, was wichtig ist. Das verlangt Dokumente mit klarem Ziel, einfachen Sätzen, erklärten Begriffen und einer Reihenfolge, die vom Allgemeinen zum Besonderen führt.

Ein Einstiegsdokument beantwortet in dieser Reihenfolge: Was ist das, was ich hier tue und für wen (Überblick)? Wen frage ich, wenn ich nicht weiterkomme (Ansprechpersonen)? Was muss ich in der ersten Woche erledigen (Aufgaben, Zugänge)? Wo finde ich was (Karte der Dokumentation, Verweise auf Glossar aus Modul 03)? Was darf ich nicht tun (Sicherheitsregeln, Modul 13)? Wichtig ist, dass ein solches Dokument *kurz* bleibt und auf vertiefende Dokumente verweist, statt sie zu wiederholen.

Der Lernpfad hat ein Zeitbudget, und dieses kann man prüfen: Die Summe der Lesezeiten der Pflichtdokumente je Phase darf das Budget nicht überschreiten. Das folgende Skript schätzt die Lesezeit aus der Wortzahl, mit einem groben Richtwert von 200 Wörtern pro Minute für konzentriertes Lesen technischer Texte, und vergleicht sie mit dem Budget je Phase. Der Richtwert ist eine Annahme, keine Konstante; für Anleitungen, die man nachvollzieht und ausprobiert, ist die tatsächliche Zeit länger.

```python
import re
from pathlib import Path

WOERTER_PRO_MIN = 200       # grober Richtwert für konzentriertes Lesen
PLAN = {"Woche 1": (["willkommen", "notfallplan"], 4),
        "Tag 30": (["runbook"], 2),
        "Tag 60": (["db"], 2)}
for phase, (seiten, budget) in PLAN.items():
    minuten = sum(len(re.findall(r"\w+", Path("oboard", s + ".md").read_text())) / WOERTER_PRO_MIN
                  for s in seiten)
    stunden = minuten / 60
    print(f"{phase}: {stunden:.1f} h Lesezeit, Budget {budget} h - " + ("passt" if stunden <= budget else "ZU VIEL"))
```

Für den Test habe ich im Ordner `oboard` vier künstliche Dateien mit 600, 24 000, 15 000 und 60 000 Wörtern erzeugt (sie bestehen nur aus dem Wort „wort“ und dienen allein dem Zählen). Das Ergebnis: Woche 1 braucht rund zwei Stunden bei einem Budget von vier, Tag 30 rund 1,2 Stunden bei zwei, und Tag 60 fünf Stunden bei einem Budget von zwei, also zu viel. Das Betriebshandbuch mit 60 000 Wörtern ist als Pflichtlektüre für eine Phase offenbar zu groß. Mögliche Maßnahmen sind, nur die relevanten Kapitel verbindlich zu machen, das Handbuch zu teilen oder die Phase zu verlängern. Auch hier gilt die Grenze: Das Skript zählt Wörter, nicht Verständlichkeit.

Typische Fehler: Einstiegsdokumente, die alles erklären wollen; ungeklärte Abkürzungen; fehlende Ansprechpersonen; keine Aufgaben, sondern nur Lektüre; veraltete Zugangsanleitungen, die den Start blockieren; Pflichtlektüre, die niemand in der Zeit schaffen kann.

| **Falsch**                                                                                        | **Richtig**                                                                                                         |
|:--------------------------------------------------------------------------------------------------|:--------------------------------------------------------------------------------------------------------------------|
| Willkommens-Dokument mit 40 Seiten, das Architektur, Geschichte und Richtlinien in einem erklärt. | Zwei Seiten Überblick mit Ansprechpersonen, Checkliste für die erste Woche und Verweisen auf vertiefende Dokumente. |

Im Projekt lässt man das Dokument von jemandem testen, der es nicht kennt: Wer in der ersten Stunde ohne Rückfrage den Zugang einrichten kann, hat ein brauchbares Einstiegsdokument.

## 15.14 Nutzungsanalyse

Nutzungsanalyse bedeutet, auszuwerten, wie die Dokumentation tatsächlich genutzt wird: Welche Dokumente werden oft gelesen, welche nie, welche nur kurz geöffnet? Das liefert eine Datenbasis für Entscheidungen, die sonst auf Meinungen beruhen: Wo lohnt sich Pflege, was kann archiviert werden, wo fehlt Inhalt? Das Suchprotokoll (Abschnitt Suchoptimierung intern) zeigt, wonach gesucht wird; die Nutzungsdaten zeigen, was gelesen wird. Beides zusammen ergibt ein Bild der Leser.

Die interessantesten Aussagen entstehen, wenn man Nutzungsdaten mit dem Bestand verknüpft. Ein stark genutztes Dokument mit überfälliger Prüfung ist ein Risiko, weil viele Menschen sich auf möglicherweise Falsches verlassen. Ein nie genutztes Dokument ist ein Archivkandidat oder ein Hinweis auf mangelnde Auffindbarkeit. Ein wenig genutztes, aber kritisches Dokument, etwa ein Notfallplan, ist dagegen unauffällig: Notfallpläne werden selten gebraucht, und ihre Nützlichkeit misst man nicht an Aufrufen. Nutzungsdaten ersetzen also nie das Urteil über Kritikalität.

Das folgende Skript verknüpft das Inventar (mit Prüfterminen) mit den Aufrufzahlen der letzten 90 Tage und urteilt: Viel genutzt (ab 100 Aufrufen) und überfällig ergibt die höchste Priorität, null Aufrufe einen Archivkandidaten, unter zehn Aufrufen eine seltene Nutzung. Die Schwellen sind Beispielwerte.

```python
import csv
from datetime import date

HEUTE = date(2026, 10, 28)
aufrufe = {z["titel"]: int(z["aufrufe_90d"]) for z in csv.DictReader(open("aufrufe.csv", encoding="utf-8"), delimiter=";")}
for z in csv.DictReader(open("inventar.csv", encoding="utf-8"), delimiter=";"):
    n = aufrufe.get(z["titel"], 0)
    ueberfaellig = date.fromisoformat(z["naechste_pruefung"]) < HEUTE
    if n >= 100 and ueberfaellig:
        urteil = "PRIORITÄT: viel genutzt, Prüfung überfällig"
    elif n == 0:
        urteil = "nie aufgerufen: Archivkandidat prüfen"
    elif n < 10:
        urteil = "selten genutzt"
    else:
        urteil = "unauffällig"
    print(f"{z['titel']}: {n} Aufrufe in 90 Tagen - {urteil}")
```

Die Datei `inventar.csv` hat die Spalten `titel` und `naechste_pruefung`, die Datei `aufrufe.csv` die Spalten `titel` und `aufrufe_90d`. Das Ergebnis mit fünf Dokumenten: Der Notfallplan Shop wird 180-mal aufgerufen und ist überfällig, also Priorität; das Runbook Neustart (240 Aufrufe) und das Runbook Backup (35) sind unauffällig; die Richtlinie Backup mit zwei Aufrufen wird selten genutzt; das Dokument „Altes Verfahren“ fehlt in der Aufrufliste und gilt damit als nie aufgerufen, also Archivkandidat. Beachten Sie die Grenze: Ein Dokument, das nicht in der Aufrufliste steht, muss nicht ungenutzt sein; es kann sein, dass das Werkzeug es nicht erfasst, etwa wenn Leser es als heruntergeladene Datei nutzen.

Typische Fehler: Man verwechselt Aufrufe mit Nutzen (eine Seite kann oft geöffnet und sofort wieder verlassen werden, weil sie nicht hilft); man löscht oder archiviert allein nach Aufrufen, auch bei kritischen Dokumenten; man erfasst personenbezogene Nutzung, wo aggregierte Zahlen genügen würden. Nutzungsauswertungen können je nach Organisation und Land datenschutz- und mitbestimmungsrechtliche Fragen berühren; klären Sie das vorab mit den zuständigen Stellen (keine Rechtsberatung, Modul 13).

| **Falsch**                                                                             | **Richtig**                                                                                                                    |
|:---------------------------------------------------------------------------------------|:-------------------------------------------------------------------------------------------------------------------------------|
| „Dieses Dokument wurde nie aufgerufen, also löschen wir es.“ (Es ist der Notfallplan.) | Aufrufzahlen plus Kritikalität und Aufbewahrungspflicht entscheiden gemeinsam; für kritische Dokumente gelten eigene Maßstäbe. |

Im Projekt reichen aggregierte Zahlen je Seite und Quartal; Einzelpersonen interessieren nicht. Das senkt die Datenschutzrisiken und liefert alles, was für die Priorisierung nötig ist.

## 15.15 Feedback Mechanismen

Der Abschnitt „Feedback-Prozesse“ hat beschrieben, was mit Rückmeldungen geschieht. Dieser Abschnitt behandelt die *Wege*, auf denen sie erfasst werden: die Bewertung „War diese Seite hilfreich? Ja/Nein“, Kommentare, ein Meldeformular, direkte Verbesserungsvorschläge (bei Docs-as-Code als Änderungsvorschlag im Repository) und passive Signale wie Suchen nach der Seite. Jeder Weg hat Stärken und Grenzen. Eine Ja/Nein-Bewertung ist mit einem Klick erledigt und liefert viele Rückmeldungen, aber wenig Information, woran es liegt. Ein Freitextfeld liefert Gründe, aber weniger Rückmeldungen. Ein Änderungsvorschlag ist die wertvollste Rückmeldung, setzt aber Wissen und Mut voraus.

Eine Eigenart von Bewertungen ist, dass sie auf kleinen Stichproben beruhen. Drei von drei positiven Stimmen sind 100 Prozent, aber kein sicheres Zeichen von Qualität; 48 von 50 sind 96 Prozent und deutlich aussagekräftiger. Wer Seiten nach dem bloßen Anteil sortiert, bevorzugt zufällig die mit wenigen Stimmen. Die Statistik kennt dafür eine Methode: die *untere Grenze des Vertrauensbereichs* für den wahren Anteil, hier nach Wilson (allgemeines Fachwissen). Sie fragt: Wie schlecht könnte der wahre Anteil bei der gegebenen Stichprobe mit hoher Sicherheit höchstens sein? Je weniger Stimmen, desto niedriger die Grenze.

Das folgende Skript berechnet diese Untergrenze für jede Seite aus den Zählungen von „hilfreich“ und „nicht hilfreich“ und sortiert nach ihr. Die Formel ist die Standardform der Wilson-Untergrenze bei einem Sicherheitsniveau von rund 95 Prozent (z gleich 1,96).

```text
seite;hilfreich;nicht_hilfreich
Runbook Neustart;48;2
Backup einrichten;3;0
Notfallplan Shop;40;40
Passwortrichtlinie;9;1
```

```python
import csv
from math import sqrt

def untergrenze(ja, nein, z=1.96):
    n = ja + nein
    if n == 0:
        return 0.0
    p = ja / n
    return (p + z*z/(2*n) - z * sqrt((p*(1-p) + z*z/(4*n)) / n)) / (1 + z*z/n)

zeilen = []
for r in csv.DictReader(open("bewertungen.csv", encoding="utf-8"), delimiter=";"):
    ja, nein = int(r["hilfreich"]), int(r["nicht_hilfreich"])
    zeilen.append((untergrenze(ja, nein), r["seite"], ja, nein))
for u, seite, ja, nein in sorted(zeilen, reverse=True):
    print(f"{seite}: {ja} ja / {nein} nein, Anteil {100*ja/(ja+nein):.0f} Prozent, sichere Untergrenze {100*u:.0f} Prozent")
```

Die Ausgabe für die vier Seiten: Runbook Neustart hat 96 Prozent bei 50 Stimmen und eine sichere Untergrenze von 87 Prozent; die Passwortrichtlinie hat 90 Prozent bei zehn Stimmen und eine Untergrenze von 60 Prozent; Backup einrichten hat 100 Prozent, aber nur drei Stimmen, deshalb eine Untergrenze von 44 Prozent; der Notfallplan Shop hat 50 Prozent bei 80 Stimmen und eine Untergrenze von 39 Prozent. Die Reihenfolge nach der Untergrenze ist ehrlicher als die nach dem Anteil: Backup einrichten steht nicht an der Spitze, nur weil drei Leser zufrieden waren. Zugleich zeigt der Notfallplan, dass hier ein echtes Problem vorliegt, da die ungünstige Bewertung auf einer großen Stichprobe beruht.

Typische Fehler: Die Bewertung ist die einzige Rückmeldung, ohne Möglichkeit, Gründe zu nennen; die Rückmeldung ist versteckt oder umständlich; es gibt keine Antwort auf Rückmeldungen; kleine Stichproben werden überinterpretiert; Rückmeldungen werden nicht mit den Dokumenten verknüpft, sodass der Owner sie nie sieht.

| **Falsch**                                                                            | **Richtig**                                                                                                                             |
|:--------------------------------------------------------------------------------------|:----------------------------------------------------------------------------------------------------------------------------------------|
| Bewertungsknopf am Seitenende; 100 Prozent bei drei Stimmen gelten als „beste Seite“. | Bewertung mit optionalem Kommentarfeld und Meldelink; Auswertung mit Mindeststichprobe oder Untergrenze; Rückmeldungen gehen zum Owner. |

Im Projekt sollten mehrere Wege zusammenwirken: ein schneller Klick für die Masse, ein Freitext für Gründe und ein einfacher Weg für Korrekturvorschläge für die Engagierten.

## 15.16 Nutzungs-Troubleshooting

Dieser Abschnitt zeigt, wie man Probleme der Nutzung auf *Seitenebene* eingrenzt, indem man Aufrufe, Bewertungen, Anschlusssuchen und Prüfalter zusammen liest, und wie man aus dem Befund Handlungsschritte für Redaktion, Fachbereich und Betrieb ableitet. Er ergänzt den organisationsweiten Abschnitt „Wissensmanagement-Troubleshooting“ um die Frage: Welche einzelnen Seiten sind das Problem?

Die Kombination der Kennzahlen ist aussagekräftiger als jede einzelne. Eine Seite mit *vielen Aufrufen und schlechter Bewertung* ist ein dringender Überarbeitungsfall, denn viele Leser sind unzufrieden. Kommt *ein hohes Prüfalter* hinzu, ist Veralten die wahrscheinliche Ursache. Eine Seite mit *vielen Suchen unmittelbar nach dem Besuch* lässt vermuten, dass die Leser die Antwort dort nicht gefunden haben und weitersuchen. Eine Seite mit *kaum Aufrufen* ist entweder unwichtig oder schlecht auffindbar. Jede Aussage ist eine Hypothese, die man durch einen Blick in die Seite und ein kurzes Gespräch mit Lesern prüft.

Das folgende Skript wendet diese Regeln auf eine Seitenliste mit vier Kennzahlen an: Aufrufe, Untergrenze der Bewertung (aus dem Abschnitt Feedback Mechanismen), Zahl der Suchen unmittelbar nach dem Besuch und Tage seit der letzten Prüfung.

```text
seite;aufrufe;hilfreich_untergrenze;suchen_danach;tage_seit_pruefung
Runbook Neustart;240;0.87;3;120
Notfallplan Shop;180;0.39;25;400
Backup einrichten;35;0.44;1;30
Richtlinie Backup;2;0.20;0;500
```

```python
import csv

for z in csv.DictReader(open("seiten_kpi.csv", encoding="utf-8"), delimiter=";"):
    auf, h, suchen, alter = int(z["aufrufe"]), float(z["hilfreich_untergrenze"]), int(z["suchen_danach"]), int(z["tage_seit_pruefung"])
    befund = []
    if auf >= 100 and h < 0.5:
        befund.append("viel gelesen, aber wenig hilfreich: Inhalt überarbeiten")
        if alter > 365:
            befund.append("zudem über ein Jahr ungeprüft: wahrscheinlich veraltet")
    if suchen > 0.1 * auf:
        befund.append("viele Anschlusssuchen: Leser finden die Antwort nicht auf der Seite")
    if auf < 10:
        befund.append("kaum genutzt: Auffindbarkeit oder Bedarf prüfen")
    print(f"{z['seite']}: " + ("; ".join(befund) or "unauffällig"))
```

Das Ergebnis: Das Runbook Neustart und die Seite Backup einrichten sind unauffällig (Letzteres hat nur 35 Aufrufe und fällt unter keine Regel, auch wenn seine Bewertung mäßig ist, weil die Aufrufzahl für die Regel zu niedrig ist). Der Notfallplan Shop löst drei Befunde aus: Er wird viel gelesen, ist wenig hilfreich, wurde seit über einem Jahr nicht geprüft und löst 25 Anschlusssuchen bei 180 Aufrufen aus, mehr als zehn Prozent. Die Richtlinie Backup ist kaum genutzt. Aus dem Befund für den Notfallplan ergibt sich ein klarer Auftrag: Owner informieren, Inhalte prüfen und überarbeiten, gezielt Leser befragen, was gefehlt hat, und neu messen. Die Zahlen sind frei erfundene Beispielwerte; die Schwellen (100 Aufrufe, 0,5, zehn Prozent, 365 Tage, zehn Aufrufe) sind Annahmen.

Typische Fehler: Man betrachtet Kennzahlen einzeln und zieht falsche Schlüsse; man bessert eine Seite nach, ohne die Leser zu fragen, woran es lag; man überprüft nicht, ob die Maßnahme geholfen hat; man verwechselt wenige Aufrufe mit geringer Wichtigkeit.

| **Falsch**                                                        | **Richtig**                                                                                                                                                                               |
|:------------------------------------------------------------------|:------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| „Die Seite hat nur 50 Prozent Zustimmung, wir schreiben sie neu.“ | „50 Prozent bei 80 Stimmen, 25 Anschlusssuchen, 400 Tage ungeprüft: erst Inhalt gegen das System prüfen, dann Leserstimmen sichten, dann gezielt ändern und nach vier Wochen neu messen.“ |

Im Projekt führt man die Seitenauswertung monatlich für die zehn auffälligsten Seiten durch; das ist überschaubar und liefert die wirksamsten Verbesserungen.

## Übungsaufgaben

Die Aufgaben steigen von Verständnisfragen (1 bis 3) über Anwendungsaufgaben (4 bis 5) bis zu Programmier- und Transferaufgaben (6 bis 8) an.

**Aufgabe 1.** *(leicht)* Unterscheiden Sie korrigierende, vorbeugende und anpassende Pflege und nennen Sie je ein Beispiel aus einer Betriebsdokumentation.

**Aufgabe 2.** *(leicht)* Was bedeutet Bus-Faktor, und warum ist ein Bus-Faktor von eins für Dokumentation ein Risiko?

**Aufgabe 3.** *(leicht bis mittel)* Erklären Sie den Unterschied zwischen Top-3-Quote und mittlerem reziproken Rang. Welche Aussage liefert der eine, die der andere nicht?

**Aufgabe 4.** *(mittel)* Entwerfen Sie für die Rolle „Support-Mitarbeiter“ einen Onboarding-Lernpfad mit fünf Phasen (vor dem ersten Tag, erste Woche, Tag 30, 60, 90) und je zwei bis drei Dokumenten.

**Aufgabe 5.** *(mittel)* Sie finden im Suchprotokoll, dass „Urlaub“ 40-mal ohne Treffer gesucht wurde, obwohl es die Seite „Abwesenheiten melden“ gibt. Welche Maßnahmen schlagen Sie vor?

**Aufgabe 6.** *(mittel, praktisch)* Erweitern Sie das Owner-Skript so, dass es für jeden Owner meldet, wie viele aktive Dokumente er hat, und eine Warnung ausgibt, wenn es mehr als drei sind.

**Aufgabe 7.** *(anspruchsvoll, praktisch)* Erweitern Sie das FAQ-Skript so, dass es zusätzlich Zweiwortkombinationen (zum Beispiel „vpn verbindet“) zählt, und prüfen Sie, ob damit Themen genauer erkennbar werden.

**Aufgabe 8.** *(anspruchsvoll, Transfer)* Ihre Wissensbasis hat folgende Kennzahlen: Owner-Quote 80 Prozent, Aktualitätsquote 40 Prozent, Top-3-Quote 50 Prozent, Antwortzeit auf Rückmeldungen 12 Tage. Entwerfen Sie einen Verbesserungsplan über zwei Quartale und begründen Sie die Reihenfolge.

## Lösungen und Erläuterungen

**Lösung zu Aufgabe 1.** Korrigierend: Ein Leser meldet, dass im Runbook ein Befehl falsch ist, und der Owner behebt den Fehler. Vorbeugend: Der Owner prüft im Review-Termin planmäßig alle Befehle auf dem Testsystem, bevor jemand einen Fehler bemerkt. Anpassend: Nach einem Versionswechsel des Systems werden die betroffenen Anleitungen angepasst. Wichtig ist, dass jede Klasse einen anderen Auslöser hat; ein Betriebskonzept sollte alle drei abdecken.

**Lösung zu Aufgabe 2.** Der Bus-Faktor gibt an, wie viele Personen ausfallen müssten, bis ein Dokument oder Wissen nicht mehr gepflegt oder verstanden wird. Bei eins hängt alles an einer Person: Urlaub, Krankheit oder Weggang legen die Pflege lahm, und Wissen geht verloren. Maßnahmen sind benannte Vertretungen, Wissensweitergabe durch gemeinsames Arbeiten und die Aufnahme kritischer Themen in eine Wissenslandkarte.

**Lösung zu Aufgabe 3.** Die Top-3-Quote sagt, bei welchem Anteil der Fragen das erwartete Dokument unter den ersten drei Treffern erscheint; sie unterscheidet nicht, ob es auf Rang eins oder drei liegt. Der mittlere reziproke Rang wertet höhere Plätze stärker (1, 0,5, 0,33) und bestraft Nichtfinden mit null; er zeigt, ob die Treffer ganz oben stehen. Zwei Suchen mit gleicher Top-3-Quote können einen sehr unterschiedlichen MRR haben. Daher betrachtet man beide.

**Lösung zu Aufgabe 4.** Ein möglicher Pfad. Vor dem ersten Tag: Zugangsanleitung, Willkommensseite. Erste Woche: Überblick Support-Prozess, Ticketsystem-Einführung, Eskalationswege. Tag 30: Knowledge-Base-Artikel zu den zehn häufigsten Problemen, Gesprächsleitfaden. Tag 60: Sonderfälle und Übergabe an Fachteams, Reklamationsprozess. Tag 90: Qualitätsstandards, Feedback-Gespräch. Jede Phase sollte ein Zeitbudget und eine Ansprechperson haben, und die Dokumente stammen aus dem Bestand.

**Lösung zu Aufgabe 5.** Mögliche Maßnahmen: Ein Synonym „Urlaub“ auf „Abwesenheit“ in die Synonymliste aufnehmen; das Wort „Urlaub“ in den Titel oder als Label der Seite aufnehmen (zum Beispiel „Abwesenheiten und Urlaub melden“); prüfen, ob die Seite überhaupt indiziert und für normale Leser sichtbar ist, was sich mit einem Testkonto prüfen lässt; die Nulltreffer-Seite um einen Hinweis auf verwandte Themen ergänzen; nach vier Wochen im Protokoll prüfen, ob die Zahl der Nulltreffer gesunken ist.

**Lösung zu Aufgabe 6.** Die vorhandene Zählung steht bereits in der Variablen `last`. Eine mögliche Ergänzung nach der Schleife:

```text
for name, n in last.items():
    if n > 3:
        print(f"WARNUNG: {name} hat {n} aktive Dokumente")
```

Mit den Beispieldaten hat niemand mehr als zwei Dokumente, es gäbe also keine Warnung; zum Test genügt es, die Grenze auf eins zu setzen, dann melden Meier und Schmid (je zwei Dokumente) eine Warnung, Berger (ein Dokument) nicht. Die Schwelle ist eine Konvention, die Sie an die tatsächliche Pflegekapazität anpassen sollten (Abschnitt Dokumentationspflege).

**Lösung zu Aufgabe 7.** Eine mögliche Ergänzung: Nach der Bildung der Wortmenge je Titel bildet man Zweiwortkombinationen aus benachbarten Wörtern, zum Beispiel mit `zip(woerter, woerter[1:])`, und zählt sie in einem zweiten Zähler. Dabei sollte man die Reihenfolge der Wörter im Titel beachten und Stoppwörter vorher entfernen. Mit den Beispieltickets liefern die Kombinationen nur wenige Wiederholungen, weil die Titel kurz und unterschiedlich formuliert sind; bei größeren Mengen echter Tickets werden sie aussagekräftiger. Das Ergebnis zeigt, dass Wortkombinationen genauere Themen liefern können (etwa „vpn verbindet“ gegenüber „vpn“), aber auch mehr Rauschen erzeugen, und dass man in beiden Fällen die Kandidaten von Hand zu Themen verdichten muss.

**Lösung zu Aufgabe 8.** Reihenfolge nach Ursachen vor Folgen. Erstes Quartal, Monat eins: Owner-Quote von 80 auf nahezu 100 Prozent bringen (Owner und Vertretungen zuordnen, Austrittsprozess verknüpfen). Monat zwei und drei: Aktualität: Bestand nach Risiko und Nutzung priorisieren, Unbenutztes archivieren (Entlastung), Erinnerungen einführen. Parallel ab Monat zwei: Feedback-Prozess mit Antwortfristen, sodass die Antwortzeit von zwölf Tagen sinkt. Zweites Quartal: Suche verbessern (Testfragenliste, Nulltreffer auswerten, Synonyme, Titel), weil der Bestand dann aktuell ist und eine Optimierung sich lohnt. Kennzahlen monatlich erheben und die Maßnahmen danach justieren. Begründung: Ohne Owner und aktuelle Inhalte würde eine bessere Suche nur veraltete Inhalte schneller finden.
