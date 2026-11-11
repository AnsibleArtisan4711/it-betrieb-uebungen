# Modul 14 - Review, Aktualitaet und Lifecycle Management

> **Hinweis zu diesem Kapitel:** Das ist das Kapitel des Skripts „Technische Dokumentation und Dokumentations-Governance“, aus der LaTeX-Quelle in Markdown umgewandelt (Text und Listings unverändert, farbige Boxen als Zitatblöcke mit fettem Titel, Tabellen als Markdown-Tabellen, Übungsaufgaben und Lösungen als Absätze). Die Lerneinheiten sind wie in der Quelle nach Modul nummeriert (14.1 bis 14.8), danach folgen „Übungsaufgaben“ (8 Aufgaben) und „Lösungen und Erläuterungen“. Die Sprachangabe der Codeblöcke ist in der Quelle nur für Python und Bash gesetzt; die übrigen Blöcke sind hier nach ihrem Inhalt als `python`, `yaml`, `markdown`, `bash` oder `text` ausgezeichnet, der Inhalt selbst ist unverändert. **Prüfstand der Beispiele für dieses Repository:** Die Python-Beispiele wurden auf Syntax geprüft; welche Beispiele ausgeführt wurden und welche zusätzlich PyYAML brauchen, steht in der [README des Repositories](../README.md). Übersicht zum Modul: [README](README.md).

**Dauer:** 8,75 Stunden | **Priorität:** 1 | **Lerneinheiten:** 8

| **Nr.** | **Lerneinheit**           | **Dauer (h)** | **Prio** |
|--------:|:--------------------------|--------------:|---------:|
|       1 | Lifecycle Management      |          1,25 |        1 |
|       2 | Review Kalender           |          1,25 |        1 |
|       3 | Ablaufdatum Expiry        |             1 |        1 |
|       4 | Obsoleszenz Erkennung     |             1 |        1 |
|       5 | Dokumentenpflege          |             1 |        1 |
|       6 | Owner Reminder            |             1 |        2 |
|       7 | Archivierungsentscheidung |             1 |        2 |
|       8 | Lifecycle-Troubleshooting |          1,25 |        2 |
|         | **Summe**                 |      **8,75** |          |

## 14.1 Lifecycle Management

Jedes Dokument hat ein Leben: Es wird geplant, geschrieben, geprüft, veröffentlicht, gepflegt, überarbeitet und irgendwann nicht mehr gebraucht. Lifecycle Management (Lebenszyklusverwaltung) bedeutet, dieses Leben bewusst zu steuern, statt Dokumente nach der Veröffentlichung sich selbst zu überlassen. Das ist keine Nebensache, denn der größte Teil der Qualitätsprobleme in Dokumentation entsteht nicht beim Schreiben, sondern danach: Das Dokument war einmal richtig und wurde im Lauf der Zeit falsch, ohne dass jemand es bemerkte.

Der Lebenszyklus gliedert sich in acht Phasen. In der *Planung* wird entschieden, dass das Dokument gebraucht wird, für wen und von wem es gepflegt wird. In der *Erstellung* entsteht der Inhalt (Modul 04 und 07). In *Prüfung und Freigabe* wird er geprüft und in Kraft gesetzt (Modul 06 und 10). In der *Veröffentlichung* wird er zugänglich gemacht. Die längste Phase ist die *Pflege*: Das Dokument wird genutzt, regelmäßig geprüft und bei Änderungen angepasst. Bei größeren Änderungen folgt eine *Überarbeitung*, die wie eine neue Erstellung mit Freigabe abläuft. Am Ende steht die *Archivierung*, wenn das Dokument nicht mehr gilt, und schließlich die *Löschung* nach Ablauf der Aufbewahrungsfrist (Modul 13).

Die technische Umsetzung vieler dieser Phasen wurde in Modul 10 behandelt (Versionierung, Freigabestatus, Dokumentenstatus, Archivierung) und die rechtliche Seite in Modul 13 (Aufbewahrung, Löschung). Dieses Modul betrachtet, wie man den Lebenszyklus *im Betrieb* steuert: Wann ist welches Dokument zu prüfen (Review-Kalender), wann gilt es als abgelaufen (Ablaufdatum), woran erkennt man Veraltetes (Obsoleszenz), wie hält man den Bestand sauber (Pflege), wie erinnert man Verantwortliche und wie entscheidet man über Archivierung.

> **Ergänzung aus der Nachrecherche**
>
> Pflegepraxis laut Quellen: Ein abgerufener Beitrag eines Herstellers von Wissensmanagement-Software empfiehlt unter anderem, jedem Dokument eine verantwortliche Person statt einer Gruppe zuzuordnen, verwaiste Dokumente beim Weggang von Mitarbeitenden neu zuzuordnen, die meisten Dokumente etwa halbjährlich neu zu verifizieren (schnelllebige häufiger, Richtlinien und Sicherheitsdokumente nach festem Plan) und Verifizierungen ablaufen zu lassen, damit das Signal aussagekräftig bleibt. Ein weiterer abgerufener Beitrag definiert die *Aktualitätsquote* als Anteil der aktiven Inhalte, die innerhalb ihres Zeitfensters geprüft wurden, nennt kein allgemeingültiges Ziel und warnt, dass eine automatische Änderung kein Beleg für eine Prüfung ist. Beide Quellen sind Herstellerbeiträge, keine Normen; Zahlen darin sind Beispiele. (Abruf 28.10.2026, siehe Quellenverzeichnis.)

Damit der Lebenszyklus steuerbar wird, muss man jedem Dokument ansehen, in welcher Phase es sich befindet und was als Nächstes zu tun ist. Das folgende Beispiel leitet aus den Metadaten eines Dokuments die Phase und die nächste Aktion ab. Es baut auf dem Dokumentenstatus aus Modul 10 auf und ergänzt die Frage, welche Handlung nun fällig ist.

```text
- {titel: Runbook Neustart, status: freigegeben, naechste_pruefung: 2027-02-01}
- {titel: Notfallplan, status: freigegeben, naechste_pruefung: 2026-09-01}
- {titel: Neues Konzept, status: in_pruefung, naechste_pruefung: 2027-06-01}
- {titel: Altes Verfahren, status: freigegeben, nachfolger: Verfahren 2, naechste_pruefung: 2026-01-01}
- {titel: Altlast, status: archiviert, loeschen_nach: 2026-06-30}
```

```python
import sys, yaml
from datetime import date

HEUTE = date(2026, 10, 28)

def phase_und_aktion(d):
    if d["status"] == "archiviert":
        if d.get("loeschen_nach") and d["loeschen_nach"] < HEUTE:
            return "Archiv", "Löschung prüfen (Frist abgelaufen)"
        return "Archiv", "aufbewahren"
    if d["status"] in ("entwurf", "in_pruefung"):
        return "Prüfung/Freigabe", "Review abschließen"
    if d.get("nachfolger"):
        return "Pflege", "archivieren (ersetzt durch " + d["nachfolger"] + ")"
    if d["naechste_pruefung"] < HEUTE:
        return "Pflege", "Prüfung überfällig - Owner anstoßen"
    return "Pflege", "nichts zu tun"

for d in yaml.safe_load(open(sys.argv[1], encoding="utf-8")):
    phase, aktion = phase_und_aktion(d)
    print(f"{d['titel']}: {phase} -> {aktion}")
```

Die Funktion prüft die Bedingungen in einer Reihenfolge, die selbst Regeln ausdrückt: Archivierte Dokumente werden zuerst betrachtet, damit eine abgelaufene Aufbewahrungsfrist erkannt wird; laufende Freigaben haben Vorrang vor Pflegefragen; ein ersetztes Dokument soll archiviert werden, auch wenn sein Prüftermin in der Zukunft liegt. Das Ergebnis für die Beispieldaten ist eine Liste von Aufgaben: nichts beim Runbook, Anstoß beim Notfallplan, Review beim neuen Konzept, Archivierung beim alten Verfahren und Löschprüfung bei der Altlast.

Typische Fehler: Der Lebenszyklus endet gedanklich mit der Veröffentlichung; es gibt keine Pflegephase im Budget oder Plan; Dokumente haben keinen Nachfolgerverweis, sodass Altes und Neues nebeneinander stehen; am Lebensende passiert nichts, und der Bestand wächst unkontrolliert.

| **Falsch**                                                                   | **Richtig**                                                                               |
|:-----------------------------------------------------------------------------|:------------------------------------------------------------------------------------------|
| Dokumentationsprojekt endet mit der Veröffentlichung; Pflege ist „nebenher“. | Pflegephase mit Owner, Prüfzyklus, Zeitbudget und definierter Entscheidung am Lebensende. |

Im Projekt ist der wichtigste Schritt, Pflege *einzuplanen*: Wer ein Dokument anlegt, legt gleichzeitig Owner, Prüfzyklus und die Bedingung für das Lebensende fest.

## 14.2 Review Kalender

Ein Review-Kalender legt fest, *wann* welches Dokument geprüft wird, und macht diese Termine sichtbar. In Modul 10 wurde der Review-Zyklus als Qualitätsmaßnahme eingeführt und gezeigt, wie sich Termine aus einem Zyklus je Dokumentart berechnen lassen. Hier steht die Organisation der Termine im Vordergrund: Wie verteilt man die Last, wie macht man Termine sichtbar, und wie geht man mit Terminen um, die nicht eingehalten werden?

Das wichtigste Gestaltungsprinzip ist die *Lastverteilung*. Wenn alle Dokumente im Januar geprüft werden sollen, entsteht ein Berg, den niemand abarbeitet. Besser ist es, Termine über das Jahr zu verteilen, etwa indem der erste Prüftermin eines neuen Dokuments aus dem Veröffentlichungsdatum folgt und weitere im Abstand des Zyklus. Zusätzlich gelten *Auslöser*: Ein Vorfall, eine Systemänderung oder eine neue Vorschrift lösen einen außerplanmäßigen Review aus. Priorisiert wird nach Risiko und Nutzung: Eine häufig gelesene Betriebsanleitung wird eher geprüft als ein selten gelesenes Konzept.

Sichtbar werden Termine, wenn sie dort erscheinen, wo Menschen ohnehin hinschauen: im Teamkalender, in der Ticketliste oder im Wiki. Das folgende Beispiel erzeugt aus einer Dokumentenliste eine Kalenderdatei im Format iCalendar (Dateiendung `.ics`), das von gängigen Kalenderprogrammen importiert werden kann. Die Datei enthält je Dokument einen ganztägigen Termin am Prüftag.

```text
titel;owner;naechste_pruefung
Notfallplan Shop;Leitung Betrieb;2026-11-16
Runbook Neustart;Team Betrieb;2026-12-01
Richtlinie Backup;Leitung IT;2027-01-10
```

```python
import csv, sys
from datetime import date, timedelta

zeilen = ["BEGIN:VCALENDAR", "VERSION:2.0", "PRODID:-//Doku Review//DE"]
for i, z in enumerate(csv.DictReader(open(sys.argv[1], encoding="utf-8"), delimiter=";")):
    tag = date.fromisoformat(z["naechste_pruefung"])
    zeilen += [
        "BEGIN:VEVENT",
        f"UID:review-{i}@doku.example.org",
        f"DTSTAMP:20261028T000000Z",
        f"DTSTART;VALUE=DATE:{tag:%Y%m%d}",
        f"DTEND;VALUE=DATE:{tag + timedelta(days=1):%Y%m%d}",
        f"SUMMARY:Review: {z['titel']}",
        f"DESCRIPTION:Verantwortlich: {z['owner']}",
        "END:VEVENT",
    ]
zeilen.append("END:VCALENDAR")
open("reviews.ics", "w", encoding="utf-8", newline="").write("\r\n".join(zeilen) + "\r\n")
print(len(zeilen), "Zeilen geschrieben")
```

Das Format iCalendar besteht aus Zeilen mit Schlüssel und Wert; jedes Ereignis steht zwischen `BEGIN:VEVENT` und `END:VEVENT`. Jedes Ereignis braucht eine eindeutige Kennung (`UID`) und einen Zeitstempel (`DTSTAMP`); bei ganztägigen Terminen steht das Datum ohne Uhrzeit, und das Ende ist der Folgetag. Zeilen werden nach der Norm mit Wagenrücklauf und Zeilenvorschub getrennt, deshalb schreibt das Skript `\r\n`. Der feste Zeitstempel im Beispiel dient der Reproduzierbarkeit. Der Vorteil der Dateiform ist, dass sich der Kalender aus den Metadaten jederzeit neu erzeugen lässt und somit nie von den Daten abweicht.

Typische Fehler: Der Kalender wird von Hand gepflegt und weicht ab; alle Termine liegen im gleichen Monat; Termine ohne Ergebnis („geprüft“ ohne Vermerk); Verschiebungen ohne Begründung, bis aus dem halbjährlichen ein jahrelanger Zyklus wird.

| **Falsch**                                                      | **Richtig**                                                                                                                                              |
|:----------------------------------------------------------------|:---------------------------------------------------------------------------------------------------------------------------------------------------------|
| Eine Excel-Liste „Prüftermine 2026“, die nur eine Person kennt. | Termine aus den Dokumentmetadaten erzeugt, im Teamkalender sichtbar, Ergebnis jeder Prüfung (unverändert, angepasst, archiviert) mit Datum festgehalten. |

Im Projekt sollte jeder Termin einen *kleinen Auftrag* enthalten: nicht „Dokument prüfen“, sondern „Befehle auf Testsystem ausführen und Verweise prüfen“. So wird aus dem Termin eine Arbeit, die man in einer halben Stunde erledigen kann.

## 14.3 Ablaufdatum Expiry

Ein Ablaufdatum (Expiry) legt fest, bis wann ein Dokument als gültig gilt, wenn es nicht erneut bestätigt wird. Es ist das Gegenstück zum Review-Termin: Der Termin sagt, wann geprüft werden *soll*, das Ablaufdatum sagt, was passiert, wenn es *nicht* geprüft wird. Der Grundgedanke ist, dass ein ungeprüftes Dokument nicht einfach weiter als vertrauenswürdig gelten darf. Vertrauen muss erneuert werden.

Üblich ist ein gestuftes Verfahren. Bis zum Ablaufdatum gilt das Dokument uneingeschränkt. Eine Frist vor dem Ablauf (zum Beispiel 30 Tage) löst Erinnerungen aus. Nach dem Ablauf wird das Dokument sichtbar gekennzeichnet („Prüfung abgelaufen, Inhalt möglicherweise veraltet“), aber nicht sofort entfernt, denn eine plötzlich verschwundene Betriebsanleitung ist im Ernstfall schlimmer als eine veraltete. Erst nach einer weiteren Frist ohne Reaktion erfolgt eine strengere Maßnahme: Herabstufung in der Suche oder Archivierungsentscheidung. Wie streng die Folgen sind, hängt von der Risikostufe des Dokuments ab.

Das folgende Beispiel zeigt, wie man aus Ablaufdatum und Stufen einen Ampelstatus ableitet und für abgelaufene Dokumente einen Hinweisbanner erzeugt, den das Publikationswerkzeug einfügen kann. Es erzeugt auch einen Hinweis, wenn kein Ablaufdatum gepflegt ist, denn ein fehlendes Datum ist selbst ein Befund.

```text
- {titel: Runbook Neustart, gueltig_bis: 2027-02-01}
- {titel: Notfallplan, gueltig_bis: 2026-11-10}
- {titel: Backup-Anleitung, gueltig_bis: 2026-09-15}
- {titel: Altes Konzept, gueltig_bis: 2026-03-01}
- {titel: Wiki-Seite ohne Datum}
```

```python
import sys, yaml
from datetime import date

HEUTE = date(2026, 10, 28)
WARNFRIST = 30       # Tage vor Ablauf: Erinnerung
KARENZ = 60          # Tage nach Ablauf: nur Banner, danach Herabstufung

for d in yaml.safe_load(open(sys.argv[1], encoding="utf-8")):
    ende = d.get("gueltig_bis")
    if ende is None:
        print(f"{d['titel']}: KEIN ABLAUFDATUM gepflegt")
        continue
    rest = (ende - HEUTE).days
    if rest > WARNFRIST:
        ampel = "grün"
    elif rest >= 0:
        ampel = f"gelb (läuft in {rest} Tagen ab)"
    elif -rest <= KARENZ:
        ampel = f"rot, Banner: 'Prüfung seit {-rest} Tagen abgelaufen'"
    else:
        ampel = f"rot, seit {-rest} Tagen abgelaufen -> Herabstufung/Archivierung prüfen"
    print(f"{d['titel']}: {ampel}")
```

Die Datei nutzt YAML-Datumsangaben, die als Datumsobjekte eingelesen werden. Das Skript unterscheidet vier Fälle über die verbleibende Zeit: weit entfernt (grün), innerhalb der Warnfrist (gelb), abgelaufen innerhalb der Karenz (rot mit Banner) und länger abgelaufen (rot mit Hinweis auf Herabstufung). Die Werte der Fristen sind Beispiele; sie gehören in den Standard und können je Dokumentart verschieden sein. Der Fall ohne Datum wird gesondert gemeldet, weil Dokumente ohne Ablaufdatum die größte unsichtbare Gruppe sind.

Typische Fehler: Das Ablaufdatum wird beim Prüfen „mechanisch“ verlängert, ohne dass geprüft wird; abgelaufene Dokumente verschwinden ohne Vorwarnung; alle Dokumente haben dasselbe Ablaufdatum; das Datum ist im System, aber für Leser nicht sichtbar.

| **Falsch**                                                                            | **Richtig**                                                                                      |
|:--------------------------------------------------------------------------------------|:-------------------------------------------------------------------------------------------------|
| Ablaufdatum wird automatisch um ein Jahr verschoben, wenn jemand die Seite speichert. | Ablaufdatum wird nur durch eine dokumentierte Prüfung verlängert, Speichern allein genügt nicht. |

Im Projekt hat sich bewährt, abgelaufene Dokumente *sichtbar zu markieren, aber nicht zu verstecken*. Leser sollen wissen, dass sie vorsichtig sein müssen, und sie dürfen nicht ohne Dokumentation dastehen.

## 14.4 Obsoleszenz Erkennung

Obsoleszenz bedeutet Veralten. Ein Dokument ist obsolet, wenn sein Inhalt nicht mehr zur Wirklichkeit passt, auch wenn niemand ihn je geändert hat: Die Software wurde aktualisiert, das System ersetzt, die Vorschrift geändert. Ablaufdaten fangen den Fall ab, dass *niemand* prüft; sie sagen nichts darüber, ob das Dokument *tatsächlich* veraltet ist. Obsoleszenz-Erkennung versucht daher, Anzeichen des Veraltens aus Daten abzulesen, bevor ein Mensch darauf stößt.

Man kann vier Gruppen von Signalen unterscheiden. *Änderungssignale*: Das beschriebene System hat sich geändert (neue Version, Änderungseintrag im Betrieb), das Dokument aber nicht. *Referenzsignale*: Links sind tot, referenzierte Dokumente sind archiviert, genannte Versionen oder Produktnamen existieren nicht mehr. *Nutzungssignale*: Das Dokument wird nicht mehr gelesen, oder Leser melden Fehler. *Personensignale*: Der Owner ist ausgeschieden oder hat die Rolle gewechselt. Keines dieser Signale beweist Veralten, jedes ist ein Anlass zur Prüfung.

Das folgende Beispiel prüft zwei Änderungssignale und ein Referenzsignal. Es vergleicht das Datum der letzten Dokumentänderung mit dem Datum der letzten Änderung am beschriebenen System, es prüft, ob im Dokument genannte Versionsnummern noch aktuell sind, und es meldet Verweise auf archivierte Dokumente.

```text
system;aktuelle_version;letzte_aenderung
shop;4.2;2026-10-10
crm;7.0;2026-04-01
```

```text
titel;system;doku_stand;erwaehnte_version;verweist_auf
Betriebshandbuch Shop;shop;2026-06-01;4.0;Runbook Neustart
Runbook Neustart;shop;2026-10-12;4.2;
Betriebshandbuch CRM;crm;2026-05-01;7.0;Altes Verfahren
```

```text
Altes Verfahren
```

```python
import csv
from datetime import date

lese = lambda name: list(csv.DictReader(open(name, encoding="utf-8"), delimiter=";"))
systeme = {s["system"]: s for s in lese("systeme.csv")}
archiviert = {z.strip() for z in open("archiviert.txt", encoding="utf-8") if z.strip()}

for d in lese("dokumente.csv"):
    s = systeme[d["system"]]
    signale = []
    if date.fromisoformat(s["letzte_aenderung"]) > date.fromisoformat(d["doku_stand"]):
        signale.append(f"System seit {s['letzte_aenderung']} geändert, Doku Stand {d['doku_stand']}")
    if d["erwaehnte_version"] != s["aktuelle_version"]:
        signale.append(f"nennt Version {d['erwaehnte_version']}, aktuell {s['aktuelle_version']}")
    if d["verweist_auf"] in archiviert:
        signale.append(f"verweist auf archiviertes Dokument '{d['verweist_auf']}'")
    print(f"{d['titel']}: " + ("; ".join(signale) or "keine Signale"))
```

Das Skript liest drei Quellen: die Systemliste mit aktueller Version und letzter Änderung, die Dokumentenliste und eine Liste archivierter Dokumente. Pro Dokument prüft es die drei Signale und gibt eine Zeile aus. Mit den Beispieldaten meldet es für das Betriebshandbuch Shop zwei Signale (System seit Oktober geändert, nennt Version 4.0 statt 4.2), für das Runbook Neustart keines, und für das Betriebshandbuch CRM den Verweis auf ein archiviertes Dokument. Das ist die Arbeitsliste für den nächsten Review. Wichtig ist die Haltung: Signale sind Hinweise, keine Urteile. Ein System kann geändert worden sein, ohne dass das Dokument betroffen ist.

Typische Fehler: Man verlässt sich allein auf Ablaufdaten; Signale werden erhoben, aber nicht ausgewertet; es gibt zu viele Fehlalarme, sodass niemand mehr hinschaut; Systemänderungen werden nicht an die Dokumentation gemeldet, weil kein Ablauf existiert.

| **Falsch**                                                                                    | **Richtig**                                                                                               |
|:----------------------------------------------------------------------------------------------|:----------------------------------------------------------------------------------------------------------|
| Ein Dokument zeigt Version 4.0, das System läuft seit vier Monaten auf 4.2, niemand merkt es. | Der Abgleich meldet die Abweichung automatisch, der Owner erhält eine Aufgabe, der Review wird ausgelöst. |

Im Projekt ist die wirksamste Quelle für Änderungssignale der Änderungsprozess der IT: Wer ein System ändert, trägt im selben Ticket ein, welche Dokumente betroffen sind (siehe Modul 10, Änderungsprozess).

## 14.5 Dokumentenpflege

Dokumentenpflege ist die laufende, überwiegend kleine Arbeit, die einen Bestand gesund hält: Fehler korrigieren, Verweise reparieren, Formulierungen klären, Überholtes entfernen, Struktur anpassen. Sie unterscheidet sich von der Überarbeitung (größere, inhaltliche Änderung mit Freigabe) und vom Review (Prüfung zu einem Termin). Pflege geschieht ständig und nebenbei, und deshalb braucht sie einen leichten Weg: Wenn jede Korrektur einen vollen Freigabeprozess auslöst, unterbleibt sie.

Ein bewährter Ansatz ist die *Pfadfinderregel*: Wer ein Dokument benutzt und etwas Falsches oder Unklares bemerkt, korrigiert es sofort oder legt eine kleine Aufgabe an, und hinterlässt das Dokument besser als er es vorfand. Voraussetzung sind ein einfacher Änderungsweg für Korrekturen (Modul 10, Änderungsprozess: Korrekturen mit vereinfachter Freigabe), klare Regeln, was als Korrektur gilt, und ein Rückmeldekanal für Leser. Ergänzend gibt es regelmäßige *Pflegeläufe*, in denen automatische Prüfungen laufen und die Ergebnisse als Aufgabenliste abgearbeitet werden: Linkprüfung, Suche nach offenen Markierungen („TODO“, „TBD“, „FIXME“), Prüfung auf fehlende Pflichtfelder, Suche nach verbotenen Begriffen.

Das folgende Beispiel führt einen solchen Pflegelauf für ein Verzeichnis mit Markdown-Dateien durch. Es zählt offene Markierungen, findet tote interne Verweise und meldet Dateien, die lange nicht geändert wurden (anhand der Änderungszeit der Datei). Es endet mit einer Zusammenfassung pro Datei, die als Aufgabenliste dient.

```python
import os, re, sys, time
from pathlib import Path

wurzel = Path(sys.argv[1])
MARKER = re.compile(r"\b(TODO|TBD|FIXME|XXX)\b")
jetzt = time.time()

for datei in sorted(wurzel.glob("*.md")):
    text = datei.read_text(encoding="utf-8")
    aufgaben = []
    marker = MARKER.findall(text)
    if marker:
        aufgaben.append(f"{len(marker)} offene Markierung(en)")
    for ziel in re.findall(r"\]\(([^)#:]+\.md)\)", text):
        if not (wurzel / ziel).exists():
            aufgaben.append(f"toter Verweis auf {ziel}")
    alter = (jetzt - os.path.getmtime(datei)) / 86400
    if alter > 365:
        aufgaben.append(f"seit {round(alter)} Tagen unverändert")
    print(f"{datei.name}: " + ("; ".join(aufgaben) or "sauber"))
```

Das Skript nutzt das Muster aus Modul 10 (Qualitätschecklisten) für Verweise und ergänzt es um offene Markierungen und das Alter der Datei. Der Ausdruck `\b(TODO|TBD|FIXME|XXX)\b` findet die Markierungen als ganze Wörter. Die Ausgabe ist eine Zeile pro Datei; Dateien ohne Befund heißen „sauber“. Beachten Sie die Grenzen: Das Dateialter ist nur ein schwaches Signal, denn ein stabiles Dokument darf alt sein, und die Änderungszeit der Datei kann durch Kopieren oder Synchronisieren verändert werden. Die Ergebnisse sind Anlass für Fragen, keine Urteile.

Typische Fehler: Pflege wird als Nebensache behandelt und fällt dem Zeitdruck zum Opfer; jede Kleinigkeit löst einen schweren Freigabeprozess aus; Korrekturen werden nicht festgehalten, sodass niemand weiß, was sich geändert hat; Leser wissen nicht, wie sie Fehler melden können.

| **Falsch**                                             | **Richtig**                                                                                                               |
|:-------------------------------------------------------|:--------------------------------------------------------------------------------------------------------------------------|
| Tippfehler wird bemerkt, aber „dafür ist später Zeit“. | Fehler wird mit zwei Klicks in einem Korrekturantrag gemeldet oder direkt behoben; vereinfachte Freigabe für Korrekturen. |

Im Projekt wirkt ein monatlicher *Pflegetag* oft mehr als jede Richtlinie: Zwei Stunden, in denen das Team die Ergebnisse des Pflegelaufs abarbeitet.

## 14.6 Owner Reminder

Verantwortlichkeit allein genügt nicht, man muss sie auch im Alltag erinnern. Owner Reminder sind Erinnerungen an Dokumentverantwortliche, wenn eine Prüfung ansteht oder überfällig ist. Sie sind die wirksamste Maßnahme gegen das häufigste Versagen der Pflege: Es sagt niemand Bescheid. Die Rolle des Document Owners wurde in Modul 06 beschrieben; hier geht es um das Erinnerungsverfahren.

Ein gutes Erinnerungsverfahren folgt vier Regeln. Die Erinnerung ist *rechtzeitig*: Sie kommt vor dem Termin (zum Beispiel 30 und 7 Tage), nicht erst danach. Sie ist *konkret*: Sie nennt Dokument, Termin, Link und die Handlung (prüfen, bestätigen, anpassen). Sie ist *gebündelt*: Ein Owner mit zehn Dokumenten erhält eine Nachricht mit zehn Zeilen, nicht zehn Nachrichten. Und sie *eskaliert*: Bleibt sie unbeantwortet, geht nach einer Frist eine Nachricht an die nächste Ebene (Vertretung, Vorgesetzte), wie in den Eskalationswegen aus Modul 06.

Das folgende Beispiel erzeugt aus der Dokumentenliste Erinnerungstexte, gebündelt pro Owner, mit einer Eskalationsstufe nach Überfälligkeit. Es versendet nichts, sondern gibt die Texte aus; die Anbindung an E-Mail oder Chat hängt von der Umgebung ab und ist ein eigener Schritt.

```text
titel;owner;vertretung;naechste_pruefung
Notfallplan Shop;Leitung Betrieb;Leitung IT;2026-09-01
Runbook Neustart;Team Betrieb;Team Plattform;2026-11-10
Betriebshandbuch DB;Team Betrieb;Team Plattform;2026-10-01
Richtlinie Backup;Leitung IT;Leitung Betrieb;2027-03-01
```

```python
import csv, sys
from collections import defaultdict
from datetime import date

HEUTE = date(2026, 10, 28)
VORLAUF = 30        # Erinnerung ab 30 Tagen vor dem Termin
ESKALATION = 30     # nach 30 Tagen Überfälligkeit an die Vertretung

je_owner = defaultdict(list)
for z in csv.DictReader(open(sys.argv[1], encoding="utf-8"), delimiter=";"):
    rest = (date.fromisoformat(z["naechste_pruefung"]) - HEUTE).days
    if rest <= VORLAUF:
        je_owner[z["owner"]].append((rest, z))

for owner, eintraege in sorted(je_owner.items()):
    print(f"An: {owner}\nBetreff: {len(eintraege)} Dokument(e) zur Prüfung")
    for rest, z in sorted(eintraege, key=lambda e: e[0]):
        if rest < 0:
            zusatz = f"seit {-rest} Tagen ÜBERFÄLLIG"
            if -rest > ESKALATION:
                zusatz += f" - Kopie an Vertretung: {z['vertretung']}"
        else:
            zusatz = f"fällig in {rest} Tagen"
        print(f"  - {z['titel']}: {zusatz}")
    print()
```

Das Skript sammelt Dokumente, die in den nächsten 30 Tagen fällig oder bereits überfällig sind, gruppiert sie nach Owner, sortiert sie nach Dringlichkeit und fügt bei Überfälligkeit über 30 Tage die Vertretung hinzu. Mit den Beispieldaten erhält das Team Betrieb eine Nachricht mit dem überfälligen Betriebshandbuch der Datenbank (27 Tage, noch ohne Eskalation) und dem Runbook (in 13 Tagen), die Leitung Betrieb eine Nachricht zum Notfallplan, der 57 Tage überfällig ist und deshalb mit einer Kopie an die Leitung IT versehen wird. Die Richtlinie Backup erscheint nicht, weil sie noch weit entfernt ist.

Typische Fehler: Erinnerungen gehen an eine Verteileradresse, bei der sich niemand zuständig fühlt; sie sind so häufig, dass sie ignoriert werden; sie sind so allgemein, dass der Empfänger nicht weiß, was zu tun ist; es gibt keine Eskalation, und nach der dritten Erinnerung passiert nichts.

| **Falsch**                                                       | **Richtig**                                                                                                                    |
|:-----------------------------------------------------------------|:-------------------------------------------------------------------------------------------------------------------------------|
| Monatliche Rundmail an alle: „Bitte denkt an die Dokumentation.“ | Gebündelte Nachricht an den Owner mit Dokumentenliste, Fristen und Links; bei 30 Tagen Überfälligkeit Kopie an die Vertretung. |

Im Projekt lohnt sich eine Rückmeldung an die Erinnerung: Wer in der Mail mit einem Klick „geprüft, unverändert gültig“ bestätigen kann, erledigt den Fall in Sekunden und erzeugt zugleich den Nachweis.

## 14.7 Archivierungsentscheidung

Nicht jedes veraltete Dokument ist ein Fall für die Archivierung, und nicht jedes unbenutzte darf archiviert werden. Die Archivierungsentscheidung wägt ab: Wird das Dokument noch gebraucht? Gibt es einen Nachfolger? Verweisen aktive Dokumente darauf? Besteht eine Aufbewahrungs- oder Nachweispflicht? Die technische Durchführung der Archivierung wurde in Modul 10 beschrieben, die Fristen und Löschregeln in Modul 13; hier geht es um die Entscheidung selbst und ihre Dokumentation.

Zu jedem Dokument am Ende seines Lebens gibt es vier mögliche Ergebnisse. *Behalten und aktualisieren*: Das Dokument wird noch gebraucht, es braucht einen Review. *Zusammenführen*: Der Inhalt gehört in ein anderes Dokument, das Duplikat wird danach archiviert. *Archivieren*: Das Dokument gilt nicht mehr, wird aber aufbewahrt. *Löschen*: Weder Aufbewahrungspflicht noch Nachweisinteresse, und das Löschen ist zulässig. Löschen ist die seltenste Entscheidung und sollte nie die einzige sein, die man kennt; die häufigste Fehlentscheidung ist, aus Angst vor Verlust nie etwas zu entfernen.

Die Entscheidung folgt Kriterien, die sich als Entscheidungsbaum festhalten lassen. Der Baum ist keine Automatik, sondern ein Vorschlag, der dem Owner die Entscheidung erleichtert und einheitlich macht. Das folgende Beispiel setzt ihn um.

```text
titel;genutzt_90d;nachfolger;verweise_aktiv;aufbewahrungspflicht;legal_hold
Altes Backup-Verfahren;2;Backup 2;0;nein;nein
Netzplan 2019;0;;0;ja;nein
Projekt Alpha Abschlussbericht;0;;3;nein;nein
Kantinenplan 2018;0;;0;nein;nein
Vertrag Dienstleister A;0;;0;ja;ja
Runbook Neustart;45;;5;nein;nein
```

```python
import csv, sys

def entscheide(z):
    if z["legal_hold"] == "ja":
        return "SPERRE - weder archivieren noch löschen, Rechtsabteilung fragen"
    if int(z["verweise_aktiv"]) > 0:
        return "behalten (aktive Dokumente verweisen darauf) - Review prüfen"
    if int(z["genutzt_90d"]) > 0 and not z["nachfolger"]:
        return "behalten und aktualisieren"
    if z["nachfolger"]:
        return f"archivieren, Verweis auf Nachfolger '{z['nachfolger']}' setzen"
    if z["aufbewahrungspflicht"] == "ja":
        return "archivieren (Aufbewahrungspflicht), Frist festhalten"
    return "löschen vorschlagen (keine Nutzung, keine Pflicht)"

for z in csv.DictReader(open(sys.argv[1], encoding="utf-8"), delimiter=";"):
    print(f"{z['titel']}: {entscheide(z)}")
```

Die Funktion prüft die Kriterien in einer festgelegten Reihenfolge. Zuerst kommt die Sperre, weil sie alles andere übersteuert. Dann folgt der Schutz vor toten Verweisen: Verweisen aktive Dokumente darauf, wird nicht archiviert, bevor sie angepasst sind. Danach unterscheidet sie zwischen genutzt und nicht genutzt, Nachfolger vorhanden oder nicht, Aufbewahrungspflicht oder nicht. Für die Beispieldaten ergibt sich unter anderem, dass das Netzplan-Dokument wegen der Pflicht archiviert wird, das Projektdokument wegen aktiver Verweise zunächst bleibt und der Kantinenplan zum Löschen vorgeschlagen wird. Das Wort „vorschlagen“ ist wichtig: Die Löschung selbst wird erst nach Freigabe durch den Owner und die Prüfung der Aufbewahrungsregeln vollzogen (Modul 13).

Typische Fehler: Entscheidung nach Gefühl und von jedem anders; kein Nachweis der Entscheidung, sodass später niemand weiß, warum etwas verschwand; Archivierung ohne Prüfung der Verweise; Löschung ohne Prüfung der Pflichten; und die Gegenrichtung, ewiges Aufbewahren aus Unsicherheit.

| **Falsch**                      | **Richtig**                                                                                                              |
|:--------------------------------|:-------------------------------------------------------------------------------------------------------------------------|
| „Das sieht alt aus, weg damit.“ | Entscheidung nach Kriterien (Nutzung, Nachfolger, Verweise, Pflichten, Sperre), Begründung und Datum im Archivprotokoll. |

Im Projekt sollte jede Archivierungsentscheidung mit einem Satz begründet werden: Er kostet 30 Sekunden und erspart später die Frage, wer das entschieden hat und warum.

## 14.8 Lifecycle-Troubleshooting

Dieser Abschnitt zeigt, wie man typische Fehlerbilder im Lebenszyklusmanagement anhand von Struktur, Aktualität, Zielgruppenfeedback und Review-Kommentaren eingrenzt und daraus Runbook-Schritte für Redaktion, Fachbereich und Betrieb ableitet.

Die häufigsten Symptome: „Niemand prüft die Dokumente“ deutet auf fehlende Owner oder Erinnerungen. „Alles ist überfällig“ deutet auf zu enge Zyklen oder fehlende Kapazität. „Wir prüfen, aber nichts ändert sich“ deutet auf „Abnick-Reviews“ oder mechanisches Verlängern der Termine. „Der Bestand wächst unaufhörlich“ deutet auf fehlende Archivierung. „Leser finden Veraltetes“ deutet auf fehlende Kennzeichnung oder schlechte Suche. „Der Owner ist weg“ deutet auf einen fehlenden Austrittsprozess.

Zur Eingrenzung hilft eine Kennzahl, die *Aktualitätsquote*: der Anteil der Dokumente, die innerhalb ihres Zeitfensters geprüft wurden. Die abgerufene Quelle weist darauf hin, dass dabei die Prüfung und nicht bloße Änderung zählt und dass verschiedene Dokumentarten verschiedene Fenster haben. Das folgende Skript berechnet die Quote je Dokumentart, die Zahl der Dokumente ohne gültigen Owner und die Zahl der Dokumente, deren Prüfdatum ausschließlich aus einer technischen Änderung stammt.

```text
titel;art;owner;geprueft;pruefquelle
Notfallplan Shop;notfallplan;Leitung Betrieb;2026-09-01;review
Runbook Neustart;runbook;Team Betrieb;2026-06-01;review
Runbook Backup;runbook;;2025-09-01;review
Betriebshandbuch DB;runbook;Team Betrieb;2026-10-20;automatisch
Grundlagen;grundlagen;Redaktion;2024-08-01;review
```

```python
import csv
from collections import defaultdict
from datetime import date

HEUTE = date(2026, 10, 28)
FENSTER = {"notfallplan": 180, "runbook": 365, "grundlagen": 730}
OWNER_OK = {"Leitung Betrieb", "Team Betrieb", "Redaktion"}

je_art = defaultdict(lambda: [0, 0])      # [im Fenster geprüft, gesamt]
ohne_owner, automatisch = [], []
for z in csv.DictReader(open("bestand.csv", encoding="utf-8"), delimiter=";"):
    alter = (HEUTE - date.fromisoformat(z["geprueft"])).days
    je_art[z["art"]][1] += 1
    if alter <= FENSTER[z["art"]] and z["pruefquelle"] == "review":
        je_art[z["art"]][0] += 1
    if z["owner"] not in OWNER_OK:
        ohne_owner.append(z["titel"])
    if z["pruefquelle"] != "review":
        automatisch.append(z["titel"])

for art, (ok, gesamt) in sorted(je_art.items()):
    print(f"{art}: {ok} von {gesamt} im Zeitfenster geprüft ({round(100 * ok / gesamt)} Prozent)")
print("Ohne gültigen Owner:", ohne_owner or "keine")
print("Prüfdatum nur durch Automatik:", automatisch or "keine")
```

Das Skript zählt je Dokumentart, wie viele Dokumente innerhalb ihres Fensters durch ein echtes Review geprüft wurden. Eine automatische Änderung zählt bewusst nicht, im Sinne des Hinweises, dass eine automatische Änderung kein Beleg einer Prüfung ist. Zusätzlich meldet es Dokumente ohne gültigen Owner. Mit den Beispieldaten hat der Notfallplan 100 Prozent, die Runbooks erreichen nur 33 Prozent (eines ist nur automatisch „geprüft“, eines hat keinen Owner und ist zu alt), und die Grundlagen liegen mit 0 Prozent außerhalb ihres Fensters von 24 Monaten. Die Fenster sind Beispielwerte. Das Datum ist fest eingetragen, damit das Beispiel reproduzierbar ist.

Als Runbook ergibt sich: Bestand auswerten; Dokumente ohne Owner zuordnen (zuerst die kritischen); überfällige Prüfungen nach Risiko ordnen und in Tranchen abarbeiten; Erinnerungen und Eskalation einrichten; mechanisches Verlängern unterbinden (Prüfdatum nur mit Vermerk); abgelaufene Dokumente kennzeichnen; Archivierungskandidaten nach Kriterien entscheiden; Kennzahl monatlich beobachten.

Typische Fehler: Man verlängert Fristen, statt zu prüfen; man verteilt Prüfaufträge, ohne Zeit einzuplanen; man bestraft überfällige Owner, statt die Last zu verteilen; man misst nur die Quote, nicht die Qualität der Prüfung.

| **Falsch**                                                            | **Richtig**                                                                                                                                         |
|:----------------------------------------------------------------------|:----------------------------------------------------------------------------------------------------------------------------------------------------|
| „Wir verlängern alle Fristen um ein Jahr, damit die Liste grün wird.“ | „Wir priorisieren nach Risiko: Notfallplan und Runbooks im ersten Monat, Grundlagen im Quartal danach; die Quote steigt nur durch echte Prüfungen.“ |

Im Projekt ist der wichtigste Erfolgsfaktor das Zeitbudget: Prüfungen finden statt, wenn sie eingeplant sind, und werden zur Formalität, wenn sie zusätzlich zum Tagesgeschäft laufen sollen.

## Übungsaufgaben

Die Aufgaben steigen von Verständnisfragen (1 bis 3) über Anwendungsaufgaben (4 bis 5) bis zu Programmier- und Transferaufgaben (6 bis 8) an.

**Aufgabe 1.** *(leicht)* Nennen Sie die acht Phasen des Dokumentenlebenszyklus und ordnen Sie jeder Phase eine verantwortliche Rolle zu.

**Aufgabe 2.** *(leicht)* Worin unterscheiden sich Review-Termin und Ablaufdatum? Warum braucht man beides?

**Aufgabe 3.** *(leicht bis mittel)* Nennen Sie je zwei Beispiele für Änderungs-, Referenz-, Nutzungs- und Personensignale der Obsoleszenz. Warum sind sie keine Beweise?

**Aufgabe 4.** *(mittel)* Entwerfen Sie ein Stufenmodell für das Ablaufdatum eines Notfallplans (Warnfrist, Banner, Herabstufung) und begründen Sie die Fristen.

**Aufgabe 5.** *(mittel)* Formulieren Sie den Text einer gebündelten Owner-Erinnerung für drei Dokumente, davon eines überfällig. Er soll konkret sein und die nötige Handlung benennen.

**Aufgabe 6.** *(mittel, praktisch)* Erweitern Sie das Pflegeskript um eine Prüfung, die Markdown-Dateien meldet, in denen eine Überschrift der ersten Ebene (eine Zeile mit `# `) fehlt oder mehrfach vorkommt.

**Aufgabe 7.** *(anspruchsvoll, praktisch)* Erweitern Sie das Kalenderskript so, dass jedes Ereignis eine Erinnerung sieben Tage vorher auslöst (Baustein `VALARM` im iCalendar-Format), und prüfen Sie die Datei mit einem Kalenderprogramm Ihrer Wahl.

**Aufgabe 8.** *(anspruchsvoll, Transfer)* In einer Organisation sind 60 Prozent aller Dokumente überfällig, die Owner klagen über fehlende Zeit. Entwerfen Sie einen Sanierungsplan über zwei Quartale, der Priorisierung, Entlastung durch Archivierung, Verantwortlichkeiten und Kennzahlen enthält.

## Lösungen und Erläuterungen

**Lösung zu Aufgabe 1.** Die Phasen sind Planung, Erstellung, Prüfung und Freigabe, Veröffentlichung, Pflege, Überarbeitung, Archivierung, Löschung. Rollen: Planung durch den Owner, Erstellung durch den Autor, Prüfung durch den Reviewer, Freigabe durch den Approver, Veröffentlichung durch Redaktion oder Pipeline, Pflege durch den Owner, Überarbeitung wieder wie Erstellung, Archivierung durch Owner und Redaktion, Löschung durch die dafür benannte Stelle nach Prüfung der Aufbewahrungsregeln (Modul 13). Die Zuordnung kann je Organisation abweichen; wichtig ist, dass jede Phase einen Verantwortlichen hat.

**Lösung zu Aufgabe 2.** Der Review-Termin ist der Zeitpunkt, an dem die Prüfung geplant ist. Das Ablaufdatum legt fest, wie lange das Dokument ohne erneute Bestätigung als gültig gilt, und was geschieht, wenn nicht geprüft wird (Banner, Herabstufung). Der Termin steuert die Arbeit, das Ablaufdatum schützt die Leser: Selbst wenn ein Termin versäumt wird, erkennen sie, dass sie vorsichtig sein müssen. Ohne Ablaufdatum bleibt ein ungeprüftes Dokument gleich vertrauenswürdig wie ein geprüftes.

**Lösung zu Aufgabe 3.** Änderungssignale: System wurde aktualisiert, Dokument nicht; Änderungsticket nennt das Dokument, es wurde aber nicht angepasst. Referenzsignale: tote Links; Verweis auf archiviertes Dokument. Nutzungssignale: keine Aufrufe in einem Jahr; häufige Rückfragen im Support zum Thema. Personensignale: Owner ausgeschieden; Team aufgelöst. Sie sind keine Beweise, weil jedes eine harmlose Erklärung haben kann: Das System wurde geändert, aber nicht in dem Teil, den das Dokument beschreibt; ein stabiles Dokument wird selten gelesen; ein Link ist vorübergehend nicht erreichbar.

**Lösung zu Aufgabe 4.** Ein mögliches Modell für einen Notfallplan: Gültig bis Datum X (Zyklus 6 Monate). 30 Tage vorher gelb mit Erinnerung an Owner und Vertretung, weil Zeit für Test und Abstimmung nötig ist. Ab Ablauf Banner „Prüfung abgelaufen“, aber keine Entfernung, weil ein Notfallplan im Ernstfall verfügbar sein muss. Nach 30 Tagen Eskalation an die Leitung; keine Herabstufung in der Suche, weil das Dokument kritisch ist. Die Begründung ist, dass bei kritischen Dokumenten Verfügbarkeit Vorrang vor strengen Folgen hat, die Eskalation aber den Druck erhöht. Für unkritische Dokumente wären längere Zyklen und strengere Folgen (Herabstufung nach 60 Tagen) angemessen.

**Lösung zu Aufgabe 5.** Ein mögliches Beispiel: „Betreff: 3 Dokumente zur Prüfung. Hallo Team Betrieb, folgende Dokumente brauchen Ihre Prüfung: (1) Betriebshandbuch DB, seit 27 Tagen überfällig: bitte Befehle auf dem Testsystem ausführen und den Stand bestätigen; (2) Runbook Neustart, fällig in 13 Tagen: bitte Prüfschritt und Verweise kontrollieren; (3) Runbook Backup, fällig in 25 Tagen: bitte nach der Migration die Dienstnamen prüfen. Zum Bestätigen genügt ein Klick auf „geprüft“ im jeweiligen Dokument. Bei Fragen wenden Sie sich an die Redaktion.“ Wichtig sind die Gruppierung, die konkrete Handlung je Dokument und der einfache Weg zur Bestätigung.

**Lösung zu Aufgabe 6.** Eine mögliche Ergänzung in der Schleife über die Dateien:

```text
    ueberschriften = re.findall(r"^# [^\n]+", text, re.M)
    if len(ueberschriften) != 1:
        aufgaben.append(f"{len(ueberschriften)} Überschriften der ersten Ebene (genau 1 erwartet)")
```

Der Ausdruck findet Zeilen, die mit genau einer Raute und einem Leerzeichen beginnen; Überschriften zweiter Ebene (`## `) beginnen mit zwei Rauten, das Leerzeichen nach der ersten verhindert den Treffer. Beachten Sie die Grenze: Zeilen mit `# ` innerhalb von Codeblöcken (etwa Kommentare in Skripten) würden fälschlich gezählt; eine genauere Prüfung müsste Codeblöcke ausschließen.

**Lösung zu Aufgabe 7.** Ergänzung im Ereignis, vor `END:VEVENT`:

```text
        "BEGIN:VALARM",
        "ACTION:DISPLAY",
        "DESCRIPTION:Review in 7 Tagen",
        "TRIGGER:-P7D",
        "END:VALARM",
```

Der Baustein `VALARM` beschreibt eine Erinnerung; `TRIGGER:-P7D` bedeutet sieben Tage vor dem Beginn des Ereignisses (die Dauer `P7D` steht für 7 Tage). Beachten Sie, dass nicht jedes Kalenderprogramm Erinnerungen aus importierten Dateien übernimmt; prüfen Sie das Verhalten in Ihrem Programm. Die Zeilen müssen zwischen `DTEND`, `SUMMARY` und `DESCRIPTION` des Ereignisses eingefügt sein, also innerhalb des Ereignisblocks.

**Lösung zu Aufgabe 8.** Ausgangslage: 60 Prozent überfällig, wenig Zeit, wahrscheinlich viele nicht mehr benötigte Dokumente. Sanierungsplan: (1) Bestandsaufnahme: Dokumente inventarisieren, Owner prüfen und fehlende zuordnen. (2) Entlastung: Nach den Kriterien der Archivierungsentscheidung zuerst alles Unbenutzte und Ersetzte archivieren; das senkt die Zahl der Prüfungen oft deutlich. (3) Priorisierung nach Risiko und Nutzung: Notfallpläne, Betriebsanleitungen und Sicherheitsdokumente im ersten Quartal, Konzepte und Grundlagen im zweiten. (4) Zeitbudget: Pro Owner feste Prüfzeit im Kalender (zum Beispiel zwei Stunden pro Woche), Pflegetag monatlich. (5) Verfahren: vereinfachte Freigabe für unveränderte Bestätigungen, Prüfdatum nur mit Vermerk, Erinnerungen und Eskalation einrichten. (6) Kennzahlen: Aktualitätsquote je Dokumentart, Anteil ohne Owner, Archivierungsquote, monatlich berichtet. (7) Erfolgskriterium: Nach zwei Quartalen unter 15 Prozent überfällig bei kritischen Dokumenten unter 5 Prozent (Beispielwerte), und ein stabiler Prüfrhythmus ohne Rückstau.
