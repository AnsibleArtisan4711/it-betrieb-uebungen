# Modul 07 - Standards, Templates und Qualitaetskriterien

> **Hinweis zu diesem Kapitel:** Das ist das Kapitel des Skripts „Technische Dokumentation und Dokumentations-Governance“, aus der LaTeX-Quelle in Markdown umgewandelt (Text und Listings unverändert, farbige Boxen als Zitatblöcke mit fettem Titel, Tabellen als Markdown-Tabellen, Übungsaufgaben und Lösungen als Absätze). Die Lerneinheiten sind wie in der Quelle nach Modul nummeriert (7.1 bis 7.8), danach folgen „Übungsaufgaben“ (8 Aufgaben) und „Lösungen und Erläuterungen“. Die Sprachangabe der Codeblöcke ist in der Quelle nur für Python und Bash gesetzt; die übrigen Blöcke sind hier nach ihrem Inhalt als `python`, `yaml`, `markdown`, `bash` oder `text` ausgezeichnet, der Inhalt selbst ist unverändert. **Prüfstand der Beispiele für dieses Repository:** Die Python-Beispiele wurden auf Syntax geprüft; welche Beispiele ausgeführt wurden und welche zusätzlich PyYAML brauchen, steht in der [README des Repositories](../README.md). Übersicht zum Modul: [README](README.md).

**Dauer:** 8,75 Stunden | **Priorität:** 1 | **Lerneinheiten:** 8

| **Nr.** | **Lerneinheit**          | **Dauer (h)** | **Prio** |
|--------:|:-------------------------|--------------:|---------:|
|       1 | Dokumentationsstandard   |          1,25 |        1 |
|       2 | Template Management      |          1,25 |        1 |
|       3 | Mindestinhalte           |             1 |        1 |
|       4 | Schreibregeln            |             1 |        1 |
|       5 | Qualitätskriterien       |             1 |        1 |
|       6 | Checklisten              |             1 |        2 |
|       7 | Styleguide               |             1 |        2 |
|       8 | Standard-Troubleshooting |          1,25 |        2 |
|         | **Summe**                |      **8,75** |          |

## 7.1 Dokumentationsstandard

Ein Dokumentationsstandard ist die verbindliche Vereinbarung darüber, *wie* in einer Organisation dokumentiert wird: welche Dokumentarten es gibt, welchen Aufbau sie haben, welche Sprache und Terminologie gelten, wo Dokumente abgelegt werden und wie sie geprüft werden. Er ist das Regelwerk, auf das sich alle Beteiligten berufen können, wenn Fragen entstehen wie „Gehört das in die Doku?“ oder „Wie heißt das hier richtig?“. Ohne Standard dokumentiert jeder nach eigenem Geschmack, und das Ergebnis ist ein Sammelsurium, in dem sich Leserinnen und Leser nie zurechtfinden.

Man muss den *internen* Dokumentationsstandard von *externen* Normen unterscheiden. Externe Normen und Gesetze, etwa die in Modul 01 genannte Norm IEC 82079-1 für Gebrauchsanleitungen oder die Anforderungen an dokumentierte Information in Managementsystemen, setzen einen Rahmen von außen. Der interne Standard übersetzt diesen Rahmen in konkrete Regeln für den eigenen Alltag. Er ist deshalb selten eine neue Erfindung, sondern meist eine Auswahl und Konkretisierung: Welche Dokumentarten brauchen wir wirklich, und welche Vorgaben gelten für jede?

Ein tragfähiger Standard besteht aus fünf Bausteinen. Erstens das *Dokumentenmodell*: die Liste der Dokumentarten mit Zweck und Zielgruppe (siehe Diátaxis in Modul 01 und die Dokumentarten in den Modulen 05 und 06). Zweitens die *Struktur- und Inhaltsvorgaben* je Art, also Vorlagen und Mindestinhalte (die folgenden Abschnitte). Drittens die *Sprach- und Gestaltungsregeln*, zusammengefasst im Styleguide. Viertens die *Prozessregeln*: Rollen, Prüfung, Freigabe, Änderung (Modul 06). Fünftens die *Ablage- und Benennungsregeln*, damit Dokumente auffindbar sind (Modul 03). Entscheidend ist, dass der Standard kurz bleibt. Ein Standard von hundert Seiten wird nicht gelesen. Besser sind wenige Seiten mit Verweisen auf Vorlagen und Beispiele.

Ein Standard ist nur dann wirksam, wenn man ihn prüfen kann. Das folgende Beispiel zeigt eine kleine Konformitätsprüfung: Eine Konfigurationsdatei beschreibt die Dokumentarten des Standards mit ihren Pflichtabschnitten, ein Skript prüft Markdown-Dokumente gegen diese Vorgaben und liefert einen Befund je Datei. Die Daten sind frei erfunden.

```yaml
runbook:
  praefix: RB-
  abschnitte: [Zweck, Voraussetzungen, Schritte, Rueckfall]
anleitung:
  praefix: AN-
  abschnitte: [Zweck, Voraussetzungen, Schritte]
```

```python
import re, sys, yaml
from pathlib import Path

standard = yaml.safe_load(open("standard.yml", encoding="utf-8"))

def pruefe(datei):
    name = datei.name
    art = next((a for a, v in standard.items() if name.startswith(v["praefix"])), None)
    if art is None:
        return f"{name}: Dateiname passt zu keiner Dokumentart"
    text = datei.read_text(encoding="utf-8")
    titel = set(re.findall(r"^## (.+)$", text, re.M))
    fehlt = [a for a in standard[art]["abschnitte"] if a not in titel]
    return f"{name}: " + (f"es fehlt {', '.join(fehlt)}" if fehlt else "ok")

for d in sorted(Path(sys.argv[1]).glob("*.md")):
    print(pruefe(d))
```

Die Konfiguration legt für jede Dokumentart ein Namenspräfix und die Pflichtabschnitte fest. Das Skript bestimmt anhand des Dateinamens die Art, liest die Überschriften zweiter Ebene mit einem regulären Ausdruck und meldet fehlende Abschnitte. Dabei ist `next(..., None)` ein Python-Idiom, das das erste passende Element liefert oder, wenn keines passt, `None`. Die Abschnittsnamen sind hier ohne Umlaut gewählt, damit das Beispiel unabhängig von der Dateikodierung bleibt. Entscheidend ist der Gedanke: Ein Standard, der sich maschinell prüfen lässt, wird zu einer Qualitätsschranke und nicht zu einer Bitte.

Typische Fehler: Der Standard wird einmal verabschiedet und nie angepasst, er ist so umfassend, dass ihn niemand kennt, oder er beschreibt Wunschzustände, die im Alltag nicht erreichbar sind. Ebenso verbreitet: Es gibt keine Ausnahmeregel, sodass sich Teams den Standard am Rand der Organisation durch Schattendokumentation umgehen.

| **Falsch**                                                              | **Richtig**                                                                                                                   |
|:------------------------------------------------------------------------|:------------------------------------------------------------------------------------------------------------------------------|
| Standard als 80-seitiges PDF ohne Vorlagen, das auf dem Laufwerk liegt. | Standard auf drei Seiten, mit Vorlagen im Repository, automatischer Prüfung und einer benannten Ansprechperson für Ausnahmen. |

Im Projekt ist der beste Start ein *minimaler Standard*: zwei oder drei Dokumentarten, je eine Vorlage, ein Styleguide auf einer Seite. Erweitert wird erst, wenn ein echter Bedarf auftritt.

## 7.2 Template Management

Eine Vorlage (Template) ist ein vorbereitetes Dokument mit Struktur, Platzhaltern und Hinweisen, das Autorinnen und Autoren ausfüllen, statt bei null zu beginnen. Vorlagen setzen den Dokumentationsstandard in die Praxis um: Wer die Vorlage nutzt, hält Struktur und Mindestinhalte nahezu automatisch ein. Template Management bezeichnet die Pflege dieser Vorlagen über ihren gesamten Lebenszyklus: Entwurf, Freigabe, Veröffentlichung, Versionierung, Änderung und Außerdienststellung.

Eine gute Vorlage hat vier Eigenschaften. Sie ist *kurz*, enthält also nur Abschnitte, die wirklich gebraucht werden. Sie ist *selbsterklärend*: Hinweise in jedem Abschnitt sagen, was dort hinein gehört, und enthalten ein Beispiel. Sie ist *prüfbar*: Struktur und Pflichtfelder sind so definiert, dass man ihre Einhaltung kontrollieren kann. Und sie ist *versioniert*: Eine Vorlagenversion ist im fertigen Dokument vermerkt, damit später erkennbar ist, nach welchem Stand es entstanden ist.

Die technische Ablage der Vorlagen richtet sich nach der Werkzeugkette. In Wikis gibt es Seitenvorlagen, in Textverarbeitung Dokumentvorlagen, in Docs-as-Code-Umgebungen (Modul 10) Dateien in einem Vorlagenverzeichnis des Repositorys. Wichtig ist, dass es genau eine maßgebliche Quelle gibt und dass Kopien nicht wild entstehen. Das folgende Beispiel zeigt eine Markdown-Vorlage mit Metadatenkopf und ein Skript, das aus ihr ein neues Dokument erzeugt, den Platzhalter für Titel und Datum ersetzt und die Vorlagenversion einträgt.

```markdown
---
titel: {{TITEL}}
owner: {{OWNER}}
vorlage: runbook-v1.2
erstellt: {{DATUM}}
status: entwurf
---

## Zweck
<!-- Ein Satz: Was erreicht man mit diesem Runbook? -->

## Voraussetzungen
<!-- Rechte, Werkzeuge, Zugänge -->

## Schritte
1. <!-- Eine Handlung pro Schritt -->

## Rueckfall
<!-- Was tun, wenn ein Schritt fehlschlägt? -->
```

```python
import sys
from datetime import date
from pathlib import Path

titel, owner, ziel = sys.argv[1], sys.argv[2], Path(sys.argv[3])
if ziel.exists():
    sys.exit(f"{ziel} existiert bereits, Abbruch")

text = Path("runbook-vorlage.md").read_text(encoding="utf-8")
text = (text.replace("{{TITEL}}", titel)
            .replace("{{OWNER}}", owner)
            .replace("{{DATUM}}", date.today().isoformat()))
ziel.write_text(text, encoding="utf-8")
print("Angelegt:", ziel)
```

Die Vorlage beginnt mit einem Metadatenblock zwischen zwei Dreifachstrichen, der Titel, Verantwortlichen, Vorlagenversion, Erstellungsdatum und Status festhält. Darunter folgen die Pflichtabschnitte mit Kommentaren, die beim Rendern unsichtbar bleiben, aber beim Schreiben als Anleitung dienen. Das Skript ersetzt die Platzhalter und verweigert das Überschreiben vorhandener Dateien, damit kein bestehendes Dokument versehentlich verloren geht. Ein Aufruf wie `python3 neu.py "Neustart Shop" "Team Betrieb" RB-017.md` erzeugt das neue Dokument.

Typische Fehler: Es gibt mehrere Kopien der Vorlage in unterschiedlichen Ständen, die Vorlage ist so detailliert, dass das Ausfüllen mehr Arbeit macht als das Schreiben, oder es gibt keinen Weg, Änderungen an der Vorlage in bestehende Dokumente zu übertragen. Letzteres lässt sich nur durch Disziplin lösen: Bei jeder Überarbeitung eines Dokuments wird auch die Vorlagenversion aktualisiert.

| **Falsch**                                                               | **Richtig**                                                                                                                |
|:-------------------------------------------------------------------------|:---------------------------------------------------------------------------------------------------------------------------|
| Vorlage als Word-Datei, die jeder auf dem Desktop speichert und anpasst. | Vorlage in einem zentralen Verzeichnis mit Versionsnummer, die Dokumente enthalten die Vorlagenversion in ihren Metadaten. |

Im Projekt lohnt es sich, Vorlagen wie Software zu behandeln: mit Änderungsprotokoll, Test (Probe-Dokument) und Freigabe. Eine Vorlage, die ein Dutzend Dokumente prägt, verdient dieselbe Sorgfalt wie ein Code-Modul, das ein Dutzend Programme nutzt.

## 7.3 Mindestinhalte

Mindestinhalte legen fest, was ein Dokument einer bestimmten Art *mindestens* enthalten muss, damit es seinen Zweck erfüllen kann. Sie sind die Untergrenze der Qualität: Ein Dokument, das sie unterschreitet, gilt als unvollständig und darf nicht freigegeben werden. Darüber hinaus steht es dem Autor frei, mehr zu liefern.

Man unterscheidet zwei Ebenen. Die *allgemeinen Mindestinhalte* gelten für jedes Dokument: Titel, eindeutige Kennung, Version, Datum, Verantwortlicher (Owner), Status und Zielgruppe. Diese Angaben ermöglichen die Verwaltung des Dokuments, wie in Modul 02 und 03 beschrieben. Die *artspezifischen Mindestinhalte* hängen vom Zweck ab: Eine Anleitung braucht Voraussetzungen, Schritte und erwartetes Ergebnis, ein Runbook zusätzlich Rückfallmaßnahmen, ein Architekturdokument Kontext, Bausteine und Entscheidungen, eine Richtlinie Geltungsbereich und Verantwortlichkeiten.

Wie man Mindestinhalte herleitet, ist eine praktische Frage: Man fragt die Leserinnen und Leser. Für jede Dokumentart wird die Frage gestellt „Was muss ich wissen, um in der typischen Situation handeln zu können?“ Bei einem Runbook, das nachts bei einer Störung geöffnet wird, sind es die Voraussetzungen, die exakten Befehle und der Rückweg, nicht die Geschichte des Systems. Das Beispiel zeigt Mindestinhalte als Tabelle und ein Skript, das Dokumente auf ihre Einhaltung prüft und die Vollständigkeit in Prozent angibt, sodass sich der Stand eines ganzen Bestands auf einen Blick beurteilen lässt.

```text
art;pflichtfeld
alle;titel
alle;owner
alle;version
alle;status
runbook;voraussetzungen
runbook;schritte
runbook;rueckfall
richtlinie;geltungsbereich
richtlinie;verantwortlichkeiten
```

```python
import csv, sys, yaml
from collections import defaultdict

pflicht = defaultdict(list)
for z in csv.DictReader(open("mindestinhalte.csv", encoding="utf-8"), delimiter=";"):
    pflicht[z["art"]].append(z["pflichtfeld"])

dokumente = yaml.safe_load(open(sys.argv[1], encoding="utf-8"))
for d in dokumente:
    soll = pflicht["alle"] + pflicht.get(d["art"], [])
    ist = [f for f in soll if d.get(f)]
    prozent = round(100 * len(ist) / len(soll))
    fehlt = [f for f in soll if f not in ist]
    print(f"{d['titel']}: {prozent} Prozent", ("- fehlt: " + ", ".join(fehlt)) if fehlt else "")
```

```text
- {titel: Neustart Shop, art: runbook, owner: Team Betrieb, version: "1.0", status: freigegeben, voraussetzungen: Root-Rechte, schritte: "1-4", rueckfall: ""}
- {titel: Richtlinie Backup, art: richtlinie, owner: Leitung IT, version: "2.0", status: entwurf, geltungsbereich: Produktion}
```

Die Tabelle trennt allgemeine Pflichtfelder (`alle`) und artspezifische. Das Skript sammelt sie in einem `defaultdict` und rechnet für jedes Dokument aus, wie viele der geforderten Felder belegt sind. Für das Runbook im Beispiel fehlt der Rückfall (leerer Wert), für die Richtlinie fehlen die Verantwortlichkeiten. Der Prozentwert ist kein Qualitätsurteil, sondern ein Vollständigkeitsindikator, der Gespräche anstößt.

Typische Fehler: Mindestinhalte werden formal erfüllt, aber inhaltlich leer („Rückfall: siehe oben“), oder sie sind so streng, dass Autoren Platzhaltertexte eintragen, nur um die Prüfung zu bestehen. Das Gegenmittel ist die Kombination aus automatischer Prüfung auf Vorhandensein und menschlichem Review auf Inhalt.

| **Falsch**                                                        | **Richtig**                                                                                                                                         |
|:------------------------------------------------------------------|:----------------------------------------------------------------------------------------------------------------------------------------------------|
| Rückfall: „n/a“ in einem Runbook, das ein Produktivsystem ändert. | Rückfall: „Bei Fehler in Schritt 3 Konfiguration aus Sicherung zurückspielen (siehe Abschnitt 4), danach Dienst neu starten und Ticket eskalieren.“ |

Im Projekt sollten Mindestinhalte aus Fehlern der Vergangenheit entstehen: Jeder Vorfall, bei dem ein Dokument eine wichtige Information vermissen ließ, kann zu einem neuen Pflichtfeld werden.

## 7.4 Schreibregeln

Schreibregeln sind die verbindlichen Vorgaben für Wortwahl, Satzbau und Textaufbau. Die inhaltliche Grundlage haben Sie in Modul 04 kennengelernt: kurze Sätze, aktive Formulierungen, ein Gedanke pro Satz, eine Handlung pro Schritt, konsistente Terminologie. Dieser Abschnitt behandelt, wie solche Regeln in einem *organisationsweiten Standard* festgeschrieben und durchgesetzt werden, und verweist für die Regeln selbst auf Modul 04.

Für die Festlegung hat sich bewährt, nur wenige Regeln aufzunehmen, die sich eindeutig entscheiden lassen. „Schreiben Sie klar“ ist keine Regel, sondern ein Wunsch. „Ein Satz hat höchstens 25 Wörter“ ist eine Regel, die man prüfen kann (der Wert ist ein Beispiel; legen Sie ihn für Ihre Organisation anhand von Beispieltexten fest). Gut prüfbar sind auch Verbotslisten für unscharfe Wörter („eventuell“, „ggf.“, „usw.“) und Regeln zur Schreibweise (Anführungszeichen, Zahlen, Datumsformat, Schreibung von Produktnamen).

> **Ergänzung aus der Nachrecherche**
>
> Prosa-Linting mit Vale: Laut dem abgerufenen Beitrag ist Vale ein quelloffenes Werkzeug, das Prosa wie Code prüft. Die Konfiguration steht in einer Datei `.vale.ini`, in der man unter anderem den Ordner der Regeln (`StylesPath`), die niedrigste anzuzeigende Stufe (`MinAlertLevel`) und die verwendeten Regelsätze (`BasedOnStyles`) angibt. Eigene Wörterbücher (`accept.txt` für erlaubte, `reject.txt` für abgelehnte Begriffe) ergänzen das. Die Regeltypen reichen von Existenzprüfungen über Wiederholungen bis zur Rechtschreibung. Der Beitrag empfiehlt, mit wenigen Regeln zu beginnen und die Prüfung automatisch bei Änderungsanträgen laufen zu lassen. Ob Vale für Ihre Sprache und Ihr Umfeld geeignet ist, sollten Sie in einem kleinen Test klären; im Rahmen dieses Skripts wurde das Werkzeug nicht ausgeführt. (Abruf 28.10.2026, siehe Quellenverzeichnis.)

Auch ohne Spezialwerkzeug lässt sich ein einfacher Prüfer in wenigen Zeilen schreiben. Das folgende Skript prüft Textdateien auf drei Regeln: Satzlänge, verbotene Füllwörter und Mehrfach-Leerzeichen. Es zeigt das Prinzip, das auch Vale zugrunde liegt, nämlich Regeln als Daten zu führen und Fundstellen mit Zeilennummer auszugeben.

```python
import re, sys

MAX_WOERTER = 25
VERBOTEN = ["eventuell", "ggf.", "usw.", "gegebenenfalls", "etc."]

for nr, zeile in enumerate(open(sys.argv[1], encoding="utf-8"), 1):
    for satz in re.split(r"(?<=[.!?])\s+", zeile):
        n = len(satz.split())
        if n > MAX_WOERTER:
            print(f"Zeile {nr}: Satz mit {n} Wörtern (Maximum {MAX_WOERTER})")
    for wort in VERBOTEN:
        if wort in zeile:
            print(f"Zeile {nr}: unscharfes Wort '{wort}'")
    if "  " in zeile.strip():
        print(f"Zeile {nr}: mehrfaches Leerzeichen")
```

Das Skript liest die Datei zeilenweise und zerlegt jede Zeile mit einem regulären Ausdruck an Satzenden (ein Satzzeichen, gefolgt von Leerraum). Der Ausdruck `(?<=[.!?])` ist ein sogenanntes Lookbehind: Er trennt *nach* dem Satzzeichen, ohne es zu entfernen. Die Wortzahl wird mit `split()` ermittelt. Die Verbotsliste wird als einfache Teilzeichenfolgensuche geprüft. Die Schwäche ist offensichtlich: Abkürzungen wie „z. B.“ werden als Satzende erkannt, und die Prüfung kennt keine Grammatik. Deshalb sind solche Prüfungen Hinweise, keine Urteile.

Typische Fehler: Zu viele Regeln, die niemand behält; Regeln, die sich widersprechen; und Prüfungen, die so viele Fehlalarme erzeugen, dass Autoren sie ignorieren. Eine Prüfung, die zu laut ist, verliert ihre Wirkung. Besser ist es, wenige Regeln streng zu prüfen und alles andere als Empfehlung zu führen.

| **Falsch**                                        | **Richtig**                                                                                                                 |
|:--------------------------------------------------|:----------------------------------------------------------------------------------------------------------------------------|
| Regel: „Schreibe verständlich und professionell.“ | Regel: „Sätze haben höchstens 25 Wörter. Anweisungen stehen im Imperativ. Unscharfe Wörter aus Liste X sind nicht erlaubt.“ |

Im Projekt führen Sie Regeln am besten als Datei im Repository und lassen Neuerungen wie Code reviewen: Jede neue Regel braucht eine Begründung und ein Beispiel für richtig und falsch.

## 7.5 Qualitätskriterien

Qualitätskriterien beantworten die Frage, woran man erkennt, dass ein Dokument gut ist. Ohne sie bleibt Qualität Geschmackssache, und Reviews ufern in Diskussionen über Stil aus. Mit ihnen lässt sich Qualität beschreiben, prüfen und verbessern. Zu den klassischen Kriterien technischer Dokumentation zählen die folgenden.

Die *Richtigkeit* fragt, ob die Aussagen stimmen und die Anleitung funktioniert. Die *Vollständigkeit* fragt, ob alles enthalten ist, was die Zielgruppe zur Aufgabe braucht (siehe Mindestinhalte). Die *Verständlichkeit* fragt, ob Sprache, Aufbau und Fachbegriffe zur Zielgruppe passen. Die *Aktualität* fragt, ob das Dokument dem heutigen Stand entspricht. Die *Auffindbarkeit* fragt, ob man es mit vertretbarem Aufwand findet. Die *Konsistenz* fragt, ob Terminologie, Gestaltung und Aufbau einheitlich sind. Hinzu kommen für bestimmte Dokumente die *Nachweisbarkeit* (Version, Freigabe, Historie) und die *Barrierefreiheit* (Modul 11 und 13).

Damit Kriterien wirksam werden, müssen sie in *messbare Indikatoren* übersetzt werden. Aktualität kann man als Alter seit der letzten Prüfung messen, Auffindbarkeit als Trefferquote bei Teststichworten, Verständlichkeit als Ergebnis eines Lesetests mit Zielgruppenvertretern, Richtigkeit als Anteil erfolgreich nachvollzogener Schritte. Nicht alles lässt sich in Zahlen fassen, und eine Zahl ersetzt kein Urteil, aber ein Indikator macht Verbesserungen sichtbar. Das folgende Beispiel berechnet aus einer Bewertungstabelle einen Gesamtindex je Dokument mit gewichteten Kriterien.

```text
titel;richtigkeit;vollstaendigkeit;verstaendlichkeit;aktualitaet
Neustart Shop;3;3;2;3
Betriebshandbuch DB;2;2;3;1
Architektur Shop;3;2;2;2
```

```python
import csv

GEWICHT = {"richtigkeit": 3, "vollstaendigkeit": 2, "verstaendlichkeit": 2, "aktualitaet": 3}
MAX_PUNKTE = 3

for z in csv.DictReader(open("bewertung.csv", encoding="utf-8"), delimiter=";"):
    summe = sum(int(z[k]) * g for k, g in GEWICHT.items())
    maximum = MAX_PUNKTE * sum(GEWICHT.values())
    index = round(100 * summe / maximum)
    schwach = [k for k in GEWICHT if int(z[k]) <= 1]
    print(f"{z['titel']}: Index {index}", ("(schwach: " + ", ".join(schwach) + ")") if schwach else "")
```

Jedes Kriterium wird auf einer Skala von 0 bis 3 bewertet. Das Skript gewichtet sie (Richtigkeit und Aktualität zählen dreifach, die anderen zweifach, beides Beispielwerte), teilt die Summe durch den Höchstwert und gibt einen Index in Prozent aus. Zusätzlich nennt es Kriterien mit höchstens einem Punkt als Schwachstellen. So erkennt man auf einen Blick, dass das Betriebshandbuch der Datenbank wegen der Aktualität auffällt. Wichtig ist: Die Gewichte sind eine Entscheidung der Organisation und gehören in den Standard.

Typische Fehler: Kriterien werden nur genannt, aber nie angewandt; Indikatoren werden zum Selbstzweck (Dokumente werden auf Kennzahl optimiert statt für Leser); oder eine einzelne Kennzahl wie die Seitenzahl wird als Qualitätsmaß missverstanden.

| **Falsch**                                     | **Richtig**                                                                                                                         |
|:-----------------------------------------------|:------------------------------------------------------------------------------------------------------------------------------------|
| „Das Dokument ist gut, weil es 40 Seiten hat.“ | „Das Dokument erreicht Index 82: Richtigkeit 3 von 3 (Schritte nachvollzogen), Aktualität 1 von 3 (letzte Prüfung vor 18 Monaten).“ |

Im Projekt genügt oft eine einfache Stichprobe: Jeden Monat werden fünf Dokumente anhand der Kriterien bewertet, und die Ergebnisse fließen in die Prioritäten der Redaktion.

## 7.6 Checklisten

Eine Checkliste ist eine strukturierte Liste von Prüfpunkten, die jemand abarbeitet, um nichts zu vergessen. In der Dokumentation dienen Checklisten vor allem dem Review und der Freigabe: Sie übersetzen Qualitätskriterien und Mindestinhalte in konkrete Fragen. Sie entlasten das Gedächtnis und machen Prüfungen vergleichbar, weil jeder Prüfer dieselben Punkte betrachtet.

Checklisten sind nur dann wirksam, wenn sie gut gestaltet sind. Sie sind *kurz* (mehr als etwa zehn Punkte werden nachlässig abgehakt), *eindeutig* (jeder Punkt lässt sich mit ja, nein oder nicht zutreffend beantworten) und *auf die Dokumentart zugeschnitten*. Sie stellen kritische Punkte an den Anfang und sind für einen bestimmten Zeitpunkt gedacht, etwa vor der Einreichung oder vor der Freigabe. Eine Checkliste ersetzt kein Denken; sie sichert das Offensichtliche ab, damit Aufmerksamkeit für das Nichtoffensichtliche frei bleibt.

Das folgende Beispiel zeigt eine Review-Checkliste als Datei, die in Ticketsysteme und Änderungsanträge übernommen werden kann, und ein Skript, das aus einer ausgefüllten Checkliste in Markdown ermittelt, ob alle Pflichtpunkte erfüllt sind. In Markdown sind abgehakte Punkte mit `[x]` markiert, offene mit `[ ]`.

```markdown
## Review-Checkliste Runbook
- [x] Zweck steht im ersten Absatz
- [x] Voraussetzungen vollständig
- [ ] Jeder Schritt hat genau eine Handlung
- [x] Erwartetes Ergebnis ist angegeben
- [ ] Rückfallmaßnahme beschrieben
- [x] Auf Testsystem ausgeführt
```

```python
import re, sys

text = open(sys.argv[1], encoding="utf-8").read()
punkte = re.findall(r"^- \[( |x)\] (.+)$", text, re.M)
offen = [t for status, t in punkte if status == " "]

print(f"{len(punkte) - len(offen)} von {len(punkte)} Punkten erfüllt")
for t in offen:
    print("  offen:", t)
sys.exit(1 if offen else 0)
```

Der reguläre Ausdruck erfasst jede Zeile, die mit `- [` beginnt, dann ein Leerzeichen oder ein `x` enthält und den Text dahinter. Das Skript zählt die erfüllten Punkte und listet die offenen auf; der Rückgabewert 1 erlaubt es, die Prüfung in automatische Abläufe einzubinden und eine Freigabe zu blockieren, solange Punkte offen sind. Für die Beispieldatei ergibt sich „4 von 6 Punkten erfüllt“ mit zwei offenen Punkten.

Typische Fehler: Checklisten werden mechanisch abgehakt, ohne zu prüfen („Abhakmüdigkeit“), sie wachsen mit jedem Vorfall, bis sie niemand mehr liest, oder sie enthalten Punkte, die sich nicht entscheiden lassen („Text ist gut verständlich“). Ein Hilfsmittel dagegen ist, Punkte regelmäßig zu streichen, die nie zu Befunden führen.

| **Falsch**                                                 | **Richtig**                                                                                                     |
|:-----------------------------------------------------------|:----------------------------------------------------------------------------------------------------------------|
| „Dokument ist gut und vollständig“ als einziger Prüfpunkt. | Sechs konkrete Punkte, von denen jeder mit ja oder nein zu beantworten ist und die ein Dritter nachprüfen kann. |

Im Projekt empfiehlt sich, die Checkliste direkt in die Vorlage des Änderungsantrags zu legen, sodass der Reviewer sie nicht suchen muss.

## 7.7 Styleguide

Der Styleguide fasst alle Regeln für Sprache, Schreibweise, Gestaltung und Aufbau in einem Dokument zusammen, das Autorinnen und Autoren beim Schreiben zur Hand nehmen. Er ist die praktische Ausprägung der Schreibregeln und der Gestaltungsvorgaben. Bekannte Beispiele aus der Praxis sind die offenen Styleguides großer Technologieunternehmen, die als Orientierung dienen können; sie zeigen auch, dass ein Styleguide ein lebendes Dokument ist, das wächst und gepflegt wird.

> **Ergänzung aus der Nachrecherche**
>
> Praxisvorbilder: Abgerufen wurden die Kurzübersicht („highlights“) eines öffentlich verfügbaren Entwickler-Styleguides eines großen Technologieunternehmens und ein Beitrag eines Softwareherstellers mit zehn Tipps zum Schreiben technischer Texte. Beide zeigen, dass sich ein Styleguide auf wenige, leicht merkbare Kernregeln verdichten lässt. Sie sind Beispiele für ein Prinzip, keine Normen und liegen nicht (alle) in deutscher Sprache vor: Übernehmen Sie, was zu Ihrer Zielgruppe passt, und prüfen Sie die Übertragbarkeit ins Deutsche selbst. (Abruf 28.10.2026, siehe Quellenverzeichnis.)

Ein Styleguide für eine typische IT-Organisation enthält sechs Teile. Zunächst die *Grundhaltung*: Ton und Anrede (siezen oder duzen, Imperativ in Anleitungen). Dann die *Sprachregeln*: Satzlänge, Aktiv, Terminologie, Umgang mit Anglizismen und Abkürzungen. Weiter die *Schreibweisen*: Zahlen, Datum, Uhrzeit, Einheiten, Anführungszeichen, Schreibung von Produktnamen und Befehlen. Es folgen die *Formatierungsregeln*: Wie werden Bedienelemente, Dateinamen, Befehle und Warnhinweise ausgezeichnet? Dann der *Aufbau*: Überschriftenebenen, Listen, Tabellen, Abbildungen mit Beschriftung. Und schließlich ein *Glossar* der verbindlichen Begriffe mit Schreibweise und Verbot von Synonymen (Modul 04).

Der Styleguide wird am wirksamsten, wenn jede Regel ein Beispiel für *falsch* und *richtig* enthält und wenn Regeln, wo möglich, maschinell prüfbar sind. Das folgende Beispiel zeigt eine Terminologieliste und ein Skript, das Texte auf verbotene Synonyme prüft und den bevorzugten Begriff vorschlägt. So wird ein Teil des Styleguides unmittelbar durchsetzbar.

```text
bevorzugt;verboten
Anmeldung;Login|Log-in|Einloggen
Datensicherung;Backup
Benutzerkonto;User-Account|Useraccount
```

```python
import csv, re, sys

regeln = []
for z in csv.DictReader(open("terminologie.csv", encoding="utf-8"), delimiter=";"):
    for v in z["verboten"].split("|"):
        regeln.append((v, z["bevorzugt"]))

for nr, zeile in enumerate(open(sys.argv[1], encoding="utf-8"), 1):
    for verboten, besser in regeln:
        if re.search(rf"\b{re.escape(verboten)}\b", zeile, re.I):
            print(f"Zeile {nr}: '{verboten}' -> besser '{besser}'")
```

Die Terminologieliste ordnet jedem bevorzugten Begriff mehrere verbotene Varianten zu, getrennt durch senkrechte Striche. Das Skript erzeugt aus ihr Paare und sucht jede verbotene Variante als ganzes Wort (`\b` steht für eine Wortgrenze) ohne Beachtung der Groß- und Kleinschreibung. Die Funktion `re.escape` schützt Sonderzeichen wie den Bindestrich in „Log-in“. Bei Fundstellen schlägt es den bevorzugten Begriff vor. Die Wortgrenze verhindert Fehlalarme, etwa wenn ein verbotenes Wort Teil eines längeren Wortes ist.

Typische Fehler: Der Styleguide wird kopiert, ohne ihn anzupassen; er enthält Regeln, die sich widersprechen; er liegt irgendwo, wo ihn niemand findet; oder er ist ein Verbotskatalog ohne Begründung, den Autoren als Gängelung empfinden. Begründete Regeln werden eher akzeptiert.

| **Falsch**                                                    | **Richtig**                                                                        |
|:--------------------------------------------------------------|:-----------------------------------------------------------------------------------|
| „Bitte mit dem Login einloggen und danach das Backup prüfen.“ | „Melden Sie sich mit Ihrer Anmeldung an und prüfen Sie danach die Datensicherung.“ |

Im Projekt hilft eine Seite „Die zehn wichtigsten Regeln“ am Anfang des Styleguides, weil viele Autoren nur diese Seite lesen werden.

## 7.8 Standard-Troubleshooting

Auch gut eingeführte Standards funktionieren nicht von allein. Dieser Abschnitt zeigt, wie man typische Fehlerbilder anhand von Struktur, Aktualität, Zielgruppenfeedback und Review-Kommentaren eingrenzt und daraus Runbook-Schritte für Redaktion, Fachbereich und Betrieb ableitet. Die Methode entspricht der in Modul 06 beschriebenen, bezogen auf Standards statt auf Prozesse.

Die häufigsten Symptome sind schnell benannt. „Niemand nutzt die Vorlagen“ deutet darauf hin, dass sie schwer zu finden, zu aufwendig oder nicht passend sind. „Die Qualität schwankt stark“ deutet auf unklare Mindestinhalte, fehlende Prüfungen oder ungeübte Reviewer. „Dokumente sehen uneinheitlich aus“ deutet auf mehrere Vorlagenstände oder fehlenden Styleguide. „Reviews dauern ewig“ deutet auf zu viele Regeln, fehlende Automatisierung oder unklare Kriterien. „Die Regeln werden ignoriert“ deutet auf mangelnde Akzeptanz, fehlende Begründung oder fehlende Konsequenz.

Zur Eingrenzung hilft die Datenlage. Das folgende Skript prüft einen Dokumentenbestand auf drei messbare Ursachen: Dokumente ohne gültige Vorlagenversion (Hinweis auf veraltete Kopien), Dokumente mit unbekanntem Status (Hinweis auf fehlende Pflichtfelder) und Dokumente mit überfälliger Prüfung. Aus den Anteilen ergibt sich, wo anzusetzen ist.

```text
titel;vorlage;status;geprueft
Neustart Shop;runbook-v1.2;freigegeben;2026-09-01
Backup prüfen;runbook-v1.0;freigegeben;2026-02-01
DB Wartung;;entwurf;2025-03-01
Zugriff beantragen;anleitung-v2.0;unklar;2026-08-15
```

```python
import csv
from datetime import date

AKTUELL = {"runbook-v1.2", "anleitung-v2.0"}
STATI = {"entwurf", "in_pruefung", "freigegeben", "archiviert"}
HEUTE = date(2026, 10, 28)

zeilen = list(csv.DictReader(open("bestand.csv", encoding="utf-8"), delimiter=";"))
alt = [z["titel"] for z in zeilen if z["vorlage"] not in AKTUELL]
status = [z["titel"] for z in zeilen if z["status"] not in STATI]
faellig = [z["titel"] for z in zeilen
           if (HEUTE - date.fromisoformat(z["geprueft"])).days > 365]

for name, liste in [("Veraltete/fehlende Vorlage", alt),
                    ("Ungültiger Status", status),
                    ("Prüfung älter als 12 Monate", faellig)]:
    print(f"{name}: {len(liste)} von {len(zeilen)}", liste)
```

Das Skript vergleicht die Vorlagenangabe mit der Liste aktueller Versionen, den Status mit erlaubten Werten und das Prüfdatum mit einem Stichtag. Mit den Beispieldaten ergibt sich: Bei der Vorlage fallen zwei von vier Dokumenten auf („Backup prüfen“ nutzt eine alte Vorlagenversion, „DB Wartung“ nennt keine), ein Dokument hat einen ungültigen Status („Zugriff beantragen“), und eines ist seit über zwölf Monaten ungeprüft („DB Wartung“). „DB Wartung“ fällt damit bei Vorlage und Prüffrist auf und ist ein guter Kandidat für die erste Überarbeitung. Das Datum ist fest eingetragen, damit das Beispiel reproduzierbar ist.

Als Runbook ergibt sich für die Redaktion: Befund erheben, Ursache klassifizieren (Vorlage, Prüfung, Akzeptanz), mit den Betroffenen sprechen, Gegenmaßnahme wählen (Vorlage vereinfachen, Schulung, Automatisierung, Regel streichen), Wirkung nach einem Quartal erneut messen. Die wichtigste Erkenntnis: Ein Standard, der nicht eingehalten wird, ist ein Hinweis auf ein Problem des Standards, nicht nur der Menschen.

Typische Fehler: Man verschärft Regeln, statt Ursachen zu klären; man bestraft Verstöße, statt sie auszuwerten; oder man ändert den Standard, ohne die Dokumente anzupassen, sodass der Bestand uneinheitlich wird.

| **Falsch**                                                       | **Richtig**                                                                                                                |
|:-----------------------------------------------------------------|:---------------------------------------------------------------------------------------------------------------------------|
| „Die Vorlagen werden nicht benutzt, wir machen sie zur Pflicht.“ | „Die Vorlage hat 14 Abschnitte, Autoren nutzen davon fünf. Wir kürzen auf sechs und messen nach drei Monaten die Nutzung.“ |

Im Projekt sind die einfachsten Gegenmittel oft die wirksamsten: Vorlage kürzen, Beispiele ergänzen, automatische Prüfung einführen.

## Übungsaufgaben

Die Aufgaben steigen von Verständnisfragen (1 bis 3) über Anwendungsaufgaben (4 bis 5) bis zu Programmier- und Transferaufgaben (6 bis 8) an.

**Aufgabe 1.** *(leicht)* Nennen Sie die fünf Bausteine eines Dokumentationsstandards und erklären Sie, warum ein Standard kurz bleiben sollte.

**Aufgabe 2.** *(leicht)* Worin besteht der Unterschied zwischen allgemeinen und artspezifischen Mindestinhalten? Nennen Sie je drei Beispiele.

**Aufgabe 3.** *(leicht bis mittel)* Warum ist „Schreibe klar und verständlich“ keine brauchbare Schreibregel? Formulieren Sie drei prüfbare Alternativen.

**Aufgabe 4.** *(mittel)* Entwerfen Sie eine Vorlage für eine „Anleitung“ mit Metadatenkopf, vier Pflichtabschnitten und Hinweiskommentaren.

**Aufgabe 5.** *(mittel)* Erstellen Sie eine Review-Checkliste mit höchstens acht Punkten für ein Runbook. Jeder Punkt muss sich mit ja oder nein beantworten lassen.

**Aufgabe 6.** *(mittel, praktisch)* Erweitern Sie das Schreibregel-Skript um eine Regel, die Sätze meldet, die mit „Es“ beginnen und das Wort „wird“ enthalten (Hinweis auf Passiv).

**Aufgabe 7.** *(anspruchsvoll, praktisch)* Schreiben Sie ein Skript, das in einem Verzeichnis alle Markdown-Dateien prüft, ob im Metadatenkopf (zwischen zwei `---`-Zeilen) die Felder `titel`, `owner` und `status` vorhanden sind.

**Aufgabe 8.** *(anspruchsvoll, Transfer)* In einer Organisation nutzen nur zwei von zehn Teams die Dokumentvorlagen. Beschreiben Sie, wie Sie die Ursachen ermitteln, und entwerfen Sie drei Maßnahmen mit einem Erfolgskriterium.

## Lösungen und Erläuterungen

**Lösung zu Aufgabe 1.** Die fünf Bausteine sind: Dokumentenmodell, Struktur- und Inhaltsvorgaben, Sprach- und Gestaltungsregeln, Prozessregeln sowie Ablage- und Benennungsregeln. Ein Standard bleibt kurz, weil nur Regeln wirken, die bekannt sind. Wer hundert Seiten Regeln veröffentlicht, erreicht, dass niemand sie liest und alle nach Gefühl schreiben. Kurze Regeln mit Vorlagen und Beispielen werden dagegen tatsächlich angewendet.

**Lösung zu Aufgabe 2.** Allgemeine Mindestinhalte gelten für jedes Dokument, zum Beispiel Titel, Version, Owner. Artspezifische hängen vom Zweck ab: beim Runbook Voraussetzungen, Schritte, Rückfall; bei der Richtlinie Geltungsbereich, Verantwortlichkeiten, Gültigkeit. Die Trennung vermeidet Doppelungen und macht Prüfungen einfach: Die allgemeinen Felder lassen sich über alle Dokumente hinweg automatisch prüfen.

**Lösung zu Aufgabe 3.** Die Regel ist nicht prüfbar: Zwei Prüfer können sie unterschiedlich auslegen, und der Autor weiß nicht, was er konkret tun soll. Prüfbare Alternativen: (1) Ein Satz hat höchstens 25 Wörter. (2) Jeder Arbeitsschritt enthält genau ein Verb im Imperativ. (3) Abkürzungen werden beim ersten Auftreten ausgeschrieben.

**Lösung zu Aufgabe 4.** Eine mögliche Vorlage:

```markdown
---
titel: {{TITEL}}
owner: {{OWNER}}
vorlage: anleitung-v2.0
status: entwurf
---

## Zweck
<!-- Was erreicht die Leserin mit dieser Anleitung? -->

## Voraussetzungen
<!-- Rechte, Werkzeuge, Vorarbeiten -->

## Schritte
1. <!-- Eine Handlung pro Schritt, mit erwartetem Ergebnis -->

## Ergebnis pruefen
<!-- Woran erkennt man, dass es geklappt hat? -->
```

Wichtig sind die Vorlagenversion im Kopf (für spätere Migrationen) und der Abschnitt zur Ergebnisprüfung, der in vielen Anleitungen fehlt.

**Lösung zu Aufgabe 5.** Eine mögliche Checkliste: Zweck im ersten Absatz; Voraussetzungen vollständig; jeder Schritt hat genau eine Handlung; Befehle sind kopierbar und in Codeformat; erwartetes Ergebnis je kritischem Schritt; Rückfallmaßnahme vorhanden; auf Testsystem ausgeführt; Owner und Version im Kopf. Jeder Punkt lässt sich mit ja oder nein beantworten. Punkte wie „gut verständlich“ wären nicht entscheidbar und gehören nicht hinein.

**Lösung zu Aufgabe 6.** Eine mögliche Ergänzung in der Schleife über die Sätze:

```text
        if satz.startswith("Es ") and " wird " in f" {satz} ":
            print(f"Zeile {nr}: möglicherweise Passiv: {satz[:40]}")
```

Die Einrückung entspricht der Schleife über `satz`. Der Umweg über `f" {satz} "` stellt sicher, dass „wird“ als ganzes Wort mit Leerzeichen gefunden wird, auch am Satzende. Beachten Sie, dass die Regel nur einen Hinweis liefert: „Es wird dunkel“ ist kein Passiv. Deshalb ist die Meldung als „möglicherweise“ formuliert.

**Lösung zu Aufgabe 7.** Eine mögliche Lösung:

```python
import re, sys
from pathlib import Path

PFLICHT = ["titel", "owner", "status"]
for datei in sorted(Path(sys.argv[1]).glob("*.md")):
    text = datei.read_text(encoding="utf-8")
    m = re.match(r"---\n(.*?)\n---", text, re.S)
    if not m:
        print(datei.name, ": kein Metadatenkopf")
        continue
    felder = set(re.findall(r"^(\w+):", m.group(1), re.M))
    fehlt = [p for p in PFLICHT if p not in felder]
    print(datei.name, ":", ("fehlt " + ", ".join(fehlt)) if fehlt else "ok")
```

Der Ausdruck `---\n(.*?)\n---` mit dem Schalter `re.S` erfasst alles zwischen den beiden Trennlinien am Dateianfang, auch über Zeilenumbrüche hinweg. Der zweite Ausdruck liest die Feldnamen am Zeilenanfang. Das Skript prüft nur das Vorhandensein der Felder, nicht deren Inhalt; leere Felder würden durchgehen. Eine Verschärfung wäre, auch den Wert hinter dem Doppelpunkt auf Nichtleere zu prüfen.

**Lösung zu Aufgabe 8.** Ursachenermittlung: Kurze Interviews mit je einem Teammitglied der acht Teams, die die Vorlagen nicht nutzen (Kennen Sie die Vorlagen? Wo suchen Sie sie? Was hindert Sie?), ergänzt um eine Auswertung der Dokumente (Anteil mit Vorlagenangabe im Kopf). Maßnahmen: (1) Die Vorlagen werden gekürzt und mit Beispielen versehen; Erfolgskriterium: Ausfüllzeit unter 15 Minuten in einem Test. (2) Die Vorlagen werden dort angeboten, wo gearbeitet wird (Menüpunkt „Neue Seite aus Vorlage“ im Wiki); Erfolgskriterium: Nutzungsanteil in Neuanlagen über 70 Prozent nach drei Monaten (Beispielwert). (3) Das Review prüft die Vorlagenversion automatisch; Erfolgskriterium: weniger als 10 Prozent Dokumente ohne Versionsangabe. Die Kombination aus Entlastung, Auffindbarkeit und Durchsetzung adressiert die drei häufigsten Ursachen.
