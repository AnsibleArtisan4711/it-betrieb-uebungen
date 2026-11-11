# Modul 10 - Versionierung, Review und Qualitaetssicherung

> **Hinweis zu diesem Kapitel:** Das ist das Kapitel des Skripts „Technische Dokumentation und Dokumentations-Governance“, aus der LaTeX-Quelle in Markdown umgewandelt (Text und Listings unverändert, farbige Boxen als Zitatblöcke mit fettem Titel, Tabellen als Markdown-Tabellen, Übungsaufgaben und Lösungen als Absätze). Die Lerneinheiten sind wie in der Quelle nach Modul nummeriert (10.1 bis 10.16), danach folgen „Übungsaufgaben“ (8 Aufgaben) und „Lösungen und Erläuterungen“. Die Sprachangabe der Codeblöcke ist in der Quelle nur für Python und Bash gesetzt; die übrigen Blöcke sind hier nach ihrem Inhalt als `python`, `yaml`, `markdown`, `bash` oder `text` ausgezeichnet, der Inhalt selbst ist unverändert. **Prüfstand der Beispiele für dieses Repository:** Die Python-Beispiele wurden auf Syntax geprüft; welche Beispiele ausgeführt wurden und welche zusätzlich PyYAML brauchen, steht in der [README des Repositories](../README.md). Übersicht zum Modul: [README](README.md).

**Dauer:** 16,75 Stunden | **Priorität:** 1 | **Lerneinheiten:** 16

| **Nr.** | **Lerneinheit**                | **Dauer (h)** | **Prio** |
|--------:|:-------------------------------|--------------:|---------:|
|       1 | Versionskontrolle              |             1 |        1 |
|       2 | Git für Dokumentation          |             1 |        1 |
|       3 | Review-Prozesse                |             1 |        1 |
|       4 | Vier-Augen-Prinzip             |             1 |        1 |
|       5 | Freigabestatus                 |             1 |        1 |
|       6 | Qualitätschecklisten           |             1 |        2 |
|       7 | Dokumentationsmetriken         |             1 |        2 |
|       8 | QA-Troubleshooting             |             1 |        2 |
|       9 | Versionierung                  |          1,25 |        1 |
|      10 | Freigabeprozess                |          1,25 |        1 |
|      11 | Änderungsprozess               |             1 |        1 |
|      12 | Review Zyklus                  |             1 |        1 |
|      13 | Dokumentenstatus               |             1 |        1 |
|      14 | Archivierung                   |             1 |        2 |
|      15 | Audit Trail                    |             1 |        2 |
|      16 | Versionierungs-Troubleshooting |          1,25 |        2 |
|         | **Summe**                      |     **16,75** |          |

## 10.1 Versionskontrolle

Versionskontrolle bedeutet, die Geschichte eines Dokuments systematisch festzuhalten: Wer hat was wann geändert und warum, und wie sah der Stand vor einer Woche aus? Ohne sie verfällt man auf Behelfe wie Dateinamen mit „\_final_neu2“, Kopien auf dem Desktop und Mailanhänge, bei denen niemand weiß, welche Fassung gilt. Das ist nicht nur lästig, sondern ein echtes Risiko: Wer nach einer veralteten Anleitung eine Produktionsumgebung ändert, richtet Schaden an.

Ein Versionskontrollsystem löst drei Probleme gleichzeitig. Es *speichert die Geschichte*: Jeder gespeicherte Stand (eine *Revision* oder *Commit*) bleibt abrufbar. Es *ermöglicht Zusammenarbeit*: Mehrere Personen arbeiten gleichzeitig an Dateien, und das System führt ihre Änderungen zusammen oder zeigt Konflikte. Und es *schafft Nachvollziehbarkeit*: Zu jeder Änderung gehören Autor, Zeitpunkt und eine Begründung. Letzteres ist für die Governance entscheidend, weil sich damit ein Teil der Nachweispflichten erfüllen lässt (siehe Audit Trail in diesem Modul).

Man unterscheidet zentrale und verteilte Systeme. Bei *zentralen* Systemen liegt die Geschichte auf einem Server, und Arbeitskopien holen sich dort Stände. Bei *verteilten* Systemen wie Git hat jede Arbeitskopie die gesamte Geschichte, was Offline-Arbeit und schnelle Verzweigung erlaubt. Daneben gibt es Dokumentenmanagementsysteme und Wikis, die eine eigene Versionshistorie führen; für Texte und Quelldateien hat sich Git als Standard durchgesetzt.

Das Prinzip lässt sich ohne Werkzeug an einem einfachen Skript zeigen, das einen Stand einer Datei unter einer Revisionsnummer sichert und Änderungen zwischen Ständen anzeigt. Es ist kein Ersatz für Git, macht aber die Idee greifbar: Eine Geschichte besteht aus unveränderlichen Ständen mit Begründung.

```python
import difflib, shutil, sys, time
from pathlib import Path

archiv = Path("historie")
archiv.mkdir(exist_ok=True)
datei, grund = Path(sys.argv[1]), sys.argv[2]

nummer = len(list(archiv.glob("*.rev"))) + 1
ziel = archiv / f"{nummer:03d}_{datei.name}.rev"
if nummer > 1:
    vorher = sorted(archiv.glob("*.rev"))[-1].read_text(encoding="utf-8").splitlines()
    jetzt = datei.read_text(encoding="utf-8").splitlines()
    print("\n".join(difflib.unified_diff(vorher, jetzt, "alt", "neu", lineterm="")))
shutil.copy(datei, ziel)
with open(archiv / "log.txt", "a", encoding="utf-8") as f:
    f.write(f"{nummer:03d} {time.strftime('%Y-%m-%d')} {grund}\n")
print("Gesichert als Revision", nummer)
```

Das Skript legt einen Ordner an, vergibt eine fortlaufende Revisionsnummer, zeigt mit der Funktion `unified_diff` des Moduls `difflib` die Unterschiede zum vorherigen Stand und kopiert die Datei unter der Nummer in den Archivordner. Zusätzlich trägt es Datum und Begründung in ein Protokoll ein. Beim ersten Aufruf gibt es keinen Vergleich, ab dem zweiten zeigt es die geänderten Zeilen mit vorangestelltem Plus oder Minus. Richtige Versionskontrolle tut dasselbe effizienter und mit Verzweigung, Zusammenführung und Rechtekonzept.

Typische Fehler: Versionsstände leben in Dateinamen statt im System; Änderungen werden ohne Begründung festgehalten; Binärdateien (Word, Bilder) werden versioniert, obwohl sich ihre Änderungen nicht vergleichen lassen; es wird so selten gesichert, dass die Geschichte keinen Nutzen hat.

| **Falsch**                                                                           | **Richtig**                                                                |
|:-------------------------------------------------------------------------------------|:---------------------------------------------------------------------------|
| Dateien „Runbook_final.docx“, „Runbook_final_neu.docx“, „Runbook_final_neu_ok.docx“. | Eine Datei `runbook.md` mit Geschichte im System, jede Änderung mit Begründung. |

Im Projekt ist die Einführung der Versionskontrolle der wichtigste einzelne Schritt hin zu verlässlicher Dokumentation. Alles Weitere (Review, Freigabe, Audit) baut darauf auf.

## 10.2 Git für Dokumentation

Git ist das am weitesten verbreitete verteilte Versionskontrollsystem. Es wurde für die Entwicklung des Linux-Kernels geschaffen und wird heute auch für Dokumentation eingesetzt, besonders in Docs-as-Code-Umgebungen, in denen Dokumente als Textdateien neben dem Code liegen. Dass Git ursprünglich für Quelltext entworfen wurde, ist für Dokumentation ein Vorteil: Textbasierte Formate wie Markdown, AsciiDoc oder LaTeX lassen sich Zeile für Zeile vergleichen und zusammenführen.

Zum Verständnis genügen wenige Begriffe. Ein *Repository* ist das Verzeichnis samt Geschichte. Ein *Commit* ist ein gespeicherter Stand mit Autor, Zeitpunkt und Beschreibung. Die *Staging-Area* sammelt, welche Änderungen in den nächsten Commit eingehen. Ein *Branch* (Zweig) ist eine eigenständige Entwicklungslinie, in der man arbeiten kann, ohne den Hauptzweig zu stören. Ein *Merge* führt Zweige zusammen. Ein *Tag* markiert einen bestimmten Stand dauerhaft, etwa „v1.0“. Ein *Remote* ist ein anderes Repository, etwa auf einem Server, mit dem man abgleicht.

> **Ergänzung aus der Nachrecherche**
>
> Git laut Pro Git: Die abgerufene Buchbeschreibung nennt Git als Versionskontrollsystem von Linus Torvalds für die Linux-Kernel-Entwicklung; das Buch *Pro Git* behandelt Grundlagen, Verzweigungen, Server, verteilte Arbeitsabläufe und Interna. Die Webseite des Buches wurde nicht abgerufen, die Seitenangaben beziehen sich auf eine Katalogseite. Für den Befehlsumfang ist die jeweils aktuelle Git-Dokumentation maßgeblich. (Abruf 28.10.2026, siehe Quellenverzeichnis.)

Der folgende vollständige Ablauf führt durch den Alltag einer Dokumentationsänderung. Er lässt sich in einem leeren Verzeichnis ausführen: Ein Dokument wird angelegt, in einem eigenen Zweig geändert, mit einem Vergleich geprüft, zurückgeführt und mit einem Tag als Stand markiert.

```bash
git init -b main doku && cd doku
git config user.name "Anna Berger"
git config user.email "anna@example.org"

printf '# Runbook Neustart\n\n1. Dienst stoppen.\n2. Dienst starten.\n' > runbook.md
git add runbook.md
git commit -m "Runbook Neustart angelegt"

git switch -c aenderung/pruefschritt
printf '3. Status pruefen.\n' >> runbook.md
git diff
git commit -am "Pruefschritt ergaenzt"

git switch main
git merge --no-ff aenderung/pruefschritt -m "Pruefschritt uebernommen"
git tag -a v1.1 -m "Runbook Neustart, Stand 1.1"

git log --oneline --graph
git show v1.1:runbook.md
```

Der erste Block legt das Repository an (`-b main` benennt den Hauptzweig) und setzt die Kennung des Autors, die in jedem Commit steht. Dann wird das Dokument angelegt, in die Staging-Area übernommen (`git add`) und gesichert (`git commit`). Mit `git switch -c` entsteht ein Arbeitszweig für die Änderung. `git diff` zeigt vor dem Commit, was sich geändert hat, und der Schalter `-a` im Commit übernimmt alle geänderten, bereits bekannten Dateien. Zurück im Hauptzweig führt `git merge --no-ff` den Zweig mit einem eigenen Merge-Commit zusammen, sodass in der Geschichte sichtbar bleibt, dass hier eine Änderung eingebracht wurde. Der Tag markiert den Stand, `git log --graph` zeigt die Geschichte, und `git show v1.1:runbook.md` gibt die Datei im Stand des Tags aus.

Typische Fehler: Große Binärdateien im Repository, die es aufblähen; Commit-Meldungen wie „Änderungen“ ohne Aussage; direkte Arbeit im Hauptzweig ohne Review; versehentlich eingechecktes Geheimnis (Zugangsdaten), das auch nach dem Löschen in der Geschichte bleibt (siehe Modul 13).

| **Falsch**                                          | **Richtig**                                                                                              |
|:----------------------------------------------------|:---------------------------------------------------------------------------------------------------------|
| Commit-Meldung „update“, direkt auf den Hauptzweig. | Commit-Meldung „Runbook Neustart: Prüfschritt ergänzt (OPS-2201)“, Änderung in eigenem Zweig mit Review. |

Im Projekt lohnt es, Autoren nicht mit Git zu überfordern: Für Einsteiger reichen grafische Oberflächen oder die Weboberfläche der Plattform, die Branch, Commit und Änderungsantrag im Browser erlauben.

## 10.3 Review-Prozesse

Ein Review-Prozess regelt, wie Änderungen an Dokumenten geprüft werden, bevor sie gelten. Die fachlichen Rollen (Autor, Reviewer, Approver) wurden in Modul 06 beschrieben; hier geht es um die technische Umsetzung des Ablaufs in der Versionsverwaltung. Das verbreitete Muster heißt *Änderungsantrag* (Pull Request oder Merge Request): Der Autor arbeitet in einem eigenen Zweig und beantragt, dass seine Änderungen in den Hauptzweig übernommen werden. Der Antrag zeigt alle Änderungen im Vergleich, bietet Platz für Kommentare und dokumentiert die Entscheidung.

Ein wirksamer Review-Prozess folgt festen Schritten. Der Autor beschreibt die Änderung und ihren Grund. Das System führt automatische Prüfungen aus (Rechtschreibung, Linkprüfung, Stilprüfung wie in Modul 07). Mindestens ein Reviewer prüft anhand einer Checkliste und kommentiert; der Autor arbeitet Rückmeldungen ein. Erst wenn die Vorgaben erfüllt sind, wird übernommen. Wesentlich ist die Trennung: Die Übernahme in den Hauptzweig ist der technische Ausdruck der Freigabe. Ob die Plattform Regeln wie „mindestens ein Review“ technisch erzwingen kann, hängt von der Plattform ab und ist in deren Dokumentation nachzulesen; das Prinzip bleibt gleich.

Das folgende Beispiel zeigt eine Vorlage für Änderungsanträge und ein Skript, das eine ausgefüllte Beschreibung auf Vollständigkeit prüft. Solche Vorlagen werden von vielen Plattformen automatisch beim Anlegen eines Antrags angeboten.

```markdown
## Was wurde geändert?
Prüfschritt in Runbook Neustart ergänzt.

## Warum?
Das Ergebnis des Neustarts wurde bisher nicht kontrolliert (OPS-2201).

## Checkliste
- [x] Auf Testsystem ausgeführt
- [x] Vorlage und Stilregeln beachtet
- [ ] Changelog ergänzt

## Betroffene Dokumente
runbook.md
```

```python
import re, sys

text = open(sys.argv[1], encoding="utf-8").read()
abschnitte = dict(re.findall(r"^## ([^\n]+)\n(.*?)(?=^## |\Z)", text, re.S | re.M))
fehler = []

for pflicht in ("Was wurde geändert?", "Warum?", "Checkliste"):
    inhalt = abschnitte.get(pflicht, "").strip()
    if not inhalt:
        fehler.append(f"Abschnitt leer oder fehlt: {pflicht}")

offen = re.findall(r"^- \[ \] (.+)$", abschnitte.get("Checkliste", ""), re.M)
for punkt in offen:
    fehler.append(f"Checkliste offen: {punkt}")
print("\n".join(fehler) or "Antrag vollständig")
sys.exit(1 if fehler else 0)
```

Die Vorlage gliedert den Antrag in vier Abschnitte. Das Skript zerlegt den Text mit einem regulären Ausdruck in ein Wörterbuch aus Überschrift und Inhalt, prüft die Pflichtabschnitte auf Inhalt und sucht in der Checkliste nach offenen Punkten (`[ ]`). Für das Beispiel meldet es, dass der Punkt „Changelog ergänzt“ offen ist. Der Rückgabewert 1 erlaubt es, diese Prüfung in automatische Abläufe einzubinden.

Typische Fehler: Reviews werden als Formalität behandelt; sehr große Änderungsanträge, die niemand sinnvoll prüfen kann; kein Zeitrahmen, sodass Anträge wochenlang liegen; Kommentare werden als Kritik an der Person empfunden. Gegenmittel sind kleine Anträge, klare Fristen und ein konstruktiver Ton.

| **Falsch**                                                               | **Richtig**                                                                                         |
|:-------------------------------------------------------------------------|:----------------------------------------------------------------------------------------------------|
| Antrag mit 60 geänderten Dateien und der Beschreibung „diverse Updates“. | Antrag mit einer thematischen Änderung, Begründung, ausgefüllter Checkliste und benanntem Reviewer. |

Im Projekt hat sich bewährt, Änderungsanträge klein zu halten: Ein Antrag, den ein Reviewer in 15 Minuten prüfen kann, wird auch in 15 Minuten geprüft.

## 10.4 Vier-Augen-Prinzip

Das Vier-Augen-Prinzip verlangt, dass wichtige Entscheidungen oder Änderungen von mindestens zwei Personen verantwortet werden: Eine führt aus, eine prüft. Der organisatorische Hintergrund steht in Modul 06 (Prüf- und Freigabeprozesse); hier geht es darum, wie das Prinzip *technisch durchgesetzt und nachweisbar* wird. Eine Regel, die nur im Handbuch steht, wird im Zeitdruck gebrochen; eine Regel, die das System erzwingt oder zumindest sichtbar macht, hält.

Die technische Umsetzung hat drei Stufen. Auf der ersten Stufe steht die *Konvention*: Das Team vereinbart, dass niemand eigene Änderungen übernimmt. Auf der zweiten die *Plattformregel*: Der Hauptzweig ist geschützt, Änderungen kommen nur über Änderungsanträge, und die Plattform verlangt eine Zustimmung durch eine andere Person als den Autor (ob und wie das konfigurierbar ist, hängt von der Plattform ab). Auf der dritten die *Nachprüfung*: Ein Skript wertet die Historie aus und meldet Verstöße. Die dritte Stufe ist auch dann nützlich, wenn die zweite vorhanden ist, denn sie belegt gegenüber Dritten, dass das Prinzip eingehalten wurde.

Das folgende Beispiel führt eine solche Nachprüfung vor. Es legt ein Repository an, in dem zwei Änderungen von Personen kommen, und eine Freigabedatei, die festhält, wer jeweils geprüft hat. Das Skript meldet Änderungen, bei denen Autor und Prüfer identisch sind oder die Freigabe fehlt.

```text
commit;pruefer
a1;Bernd Huber
b2;Anna Berger
c3;
```

```python
import csv, subprocess

def autoren():
    ausgabe = subprocess.run(["git", "log", "--pretty=format:%h;%an"],
                             capture_output=True, text=True, check=True).stdout
    return dict(z.split(";") for z in ausgabe.splitlines())

freigaben = {z["commit"]: z["pruefer"]
             for z in csv.DictReader(open("freigaben.csv", encoding="utf-8"), delimiter=";")}

for kurz, autor in autoren().items():
    pruefer = next((p for c, p in freigaben.items() if kurz.startswith(c) or c.startswith(kurz)), "")
    if not pruefer:
        print(f"{kurz}: keine Freigabe eingetragen (Autor {autor})")
    elif pruefer == autor:
        print(f"{kurz}: Autor und Prüfer identisch ({autor})")
    else:
        print(f"{kurz}: ok ({autor} / {pruefer})")
```

Das Skript fragt Git nach Kurzkennung und Autorenname jedes Commits (`git log` mit eigenem Ausgabeformat) und gleicht sie mit einer Freigabetabelle ab. Der Vergleich der Kennungen mit `startswith` berücksichtigt, dass Kurzkennungen unterschiedlich lang sein können. Für jeden Commit entsteht eine Zeile mit dem Befund. In echten Umgebungen stammen die Freigaben aus der Plattform und nicht aus einer Tabelle; das Beispiel zeigt die Logik des Abgleichs. Beachten Sie die Grenze: Das Skript prüft, dass zwei Personen beteiligt waren, nicht dass die Prüfung gründlich war.

Typische Fehler: Zwei Rollen in einer Person (der Administrator genehmigt seine eigene Änderung); gegenseitiges Abnicken; Ausnahmen für Notfälle ohne Nachprüfung; Freigaben durch Konten, die mehrere Personen teilen und deshalb keine Person erkennen lassen.

| **Falsch**                                                              | **Richtig**                                                                                                                                  |
|:------------------------------------------------------------------------|:---------------------------------------------------------------------------------------------------------------------------------------------|
| Gemeinsames Team-Konto „doku-admin“, mit dem jeder Änderungen freigibt. | Persönliche Konten, Hauptzweig geschützt, Zustimmung einer zweiten Person erforderlich, Notfallweg mit Nachprüfung innerhalb von 24 Stunden. |

Im Projekt ist ein dokumentierter Notfallweg wichtig: Das Vier-Augen-Prinzip darf bei einer Störung nicht der Grund sein, dass eine dringende Korrektur tagelang wartet. Die Abweichung wird erlaubt, aber festgehalten und nachträglich geprüft.

## 10.5 Freigabestatus

Der Freigabestatus gibt an, wie weit ein Dokument im Prüf- und Freigabeprozess ist. Er beantwortet die Frage „Darf ich mich darauf verlassen?“ und unterscheidet sich damit vom Lebenszyklusstatus (Dokumentenstatus, siehe unten): Der Freigabestatus beschreibt *eine Änderung* im Prozess (Entwurf, in Prüfung, freigegeben, abgelehnt), der Dokumentenstatus das *Dokument* im Lebenslauf (gültig, überarbeitungsbedürftig, ersetzt, archiviert). In einfachen Umgebungen fallen beide zusammen; je größer die Organisation, desto nützlicher ist die Trennung.

Ein Statusmodell besteht aus Zuständen und erlaubten Übergängen. Ein typisches Modell: `entwurf` geht zu `in_pruefung`; von dort entweder zu `freigegeben` oder zurück zu `entwurf` (Überarbeitung) oder zu `abgelehnt`. Aus `freigegeben` führt der Weg nur über eine neue Version wieder in den Entwurf. Entscheidend ist, dass *nicht jeder Übergang erlaubt* ist: Ein Entwurf kann nicht direkt freigegeben werden, und eine freigegebene Fassung wird nicht stillschweigend verändert. Solche Regeln lassen sich als Zustandsautomat abbilden und automatisch durchsetzen.

Das folgende Beispiel hält das Statusmodell als Daten fest und prüft einen Statusverlauf gegen die erlaubten Übergänge. Dazu kommt, wer den Übergang auslösen darf, sodass das Modell auch Rollen berücksichtigt.

```yaml
uebergaenge:
  entwurf:
    in_pruefung: [autor]
  in_pruefung:
    freigegeben: [approver]
    entwurf: [reviewer, approver]
    abgelehnt: [approver]
  freigegeben: {}
  abgelehnt: {}
```

```python
import sys, yaml

modell = yaml.safe_load(open("status.yml", encoding="utf-8"))["uebergaenge"]
verlauf = [tuple(z.split(":")) for z in sys.argv[1:]]   # status:rolle

aktuell = "entwurf"
for neu, rolle in verlauf:
    erlaubt = modell.get(aktuell, {})
    if neu not in erlaubt:
        print(f"Unzulässig: {aktuell} -> {neu}")
        break
    if rolle not in erlaubt[neu]:
        print(f"Rolle {rolle} darf {aktuell} -> {neu} nicht auslösen")
        break
    aktuell = neu
else:
    print("Verlauf zulässig, Endstatus:", aktuell)
```

Das Modell ordnet jedem Zustand die erlaubten Folgezustände und die berechtigten Rollen zu. Das Skript erwartet einen Verlauf in der Form `in_pruefung:autor freigegeben:approver` und prüft Schritt für Schritt Übergang und Rolle. Die Konstruktion `for ... else` führt den `else`-Zweig nur aus, wenn die Schleife nicht durch `break` beendet wurde, also wenn alle Schritte zulässig waren. Ein Verlauf `freigegeben:autor` direkt aus dem Entwurf würde als unzulässig gemeldet.

Typische Fehler: Es gibt zu viele Status, die niemand auseinanderhält; der Status steht nur im Dateinamen oder Kopf und wird nicht gepflegt; freigegebene Dokumente werden nachträglich ohne neuen Status geändert; Leser können den Status nicht erkennen.

| **Falsch**                                                                  | **Richtig**                                                                                                                             |
|:----------------------------------------------------------------------------|:----------------------------------------------------------------------------------------------------------------------------------------|
| Status im Dateinamen („runbook_FREIGEGEBEN.docx“), nachträglich bearbeitet. | Status im Metadatenkopf und im System, Übergang nur durch berechtigte Rolle, Änderung einer freigegebenen Fassung nur als neue Version. |

Im Projekt sollte der Status *am Dokument sichtbar* sein. Wer eine Seite liest, muss sofort erkennen, ob es sich um einen Entwurf oder eine freigegebene Fassung handelt.

## 10.6 Qualitätschecklisten

Qualitätschecklisten übersetzen Qualitätskriterien und Mindestinhalte in konkrete Prüffragen. Das Prinzip und die Gestaltung guter Checklisten wurden in Modul 07 beschrieben. In diesem Modul geht es darum, sie in den Prüfablauf der Versionsverwaltung einzubinden und möglichst viele Punkte *automatisch* zu prüfen, damit Reviewer ihre Aufmerksamkeit auf die Inhalte richten können.

Man teilt die Prüfpunkte nach Prüfbarkeit. Manche Punkte sind *maschinell prüfbar*: Der Metadatenkopf ist vollständig, es gibt keine toten Links, Pflichtabschnitte sind vorhanden, verbotene Begriffe kommen nicht vor. Andere erfordern *menschliches Urteil*: Ist die Anleitung verständlich? Stimmen die Schritte fachlich? Wurde auf dem Testsystem ausgeführt? Eine gute Checkliste hat einen automatischen und einen manuellen Teil, und die Automatik läuft vor dem menschlichen Review. So bleiben dem Reviewer nur die Fragen, die nur Menschen beantworten können.

Das folgende Beispiel zeigt einen kleinen automatischen Prüflauf für Markdown-Dateien. Er prüft Metadatenkopf, Pflichtabschnitte und interne Links, gibt für jede Datei einen Befund aus und endet mit einem Rückgabewert, den Pipelines auswerten können.

```python
import re, sys
from pathlib import Path

PFLICHTFELDER = ["titel", "owner", "status"]
wurzel = Path(sys.argv[1])
fehler = 0

for datei in sorted(wurzel.glob("*.md")):
    text = datei.read_text(encoding="utf-8")
    kopf = re.match(r"---\n(.*?)\n---", text, re.S)
    felder = set(re.findall(r"^(\w+):", kopf.group(1), re.M)) if kopf else set()
    for f in PFLICHTFELDER:
        if f not in felder:
            print(f"{datei.name}: Feld '{f}' fehlt"); fehler += 1
    for ziel in re.findall(r"\]\(([^)#:]+\.md)\)", text):
        if not (wurzel / ziel).exists():
            print(f"{datei.name}: Link auf fehlende Datei {ziel}"); fehler += 1

print("Alle Prüfungen bestanden" if not fehler else f"{fehler} Befund(e)")
sys.exit(1 if fehler else 0)
```

Das Skript geht alle Markdown-Dateien eines Ordners durch. Aus dem Metadatenkopf liest es die vorhandenen Feldnamen und vergleicht sie mit den Pflichtfeldern. Außerdem sucht es Verweise der Form `[Text](datei.md)` und prüft, ob die Zieldatei existiert. Der reguläre Ausdruck `[\^{})#:]+` schließt Ankerverweise (`#`) und externe Adressen (Doppelpunkt) aus. Links auf Webseiten zu prüfen erfordert Netzwerkzugriff und gehört in einen eigenen Lauf.

Typische Fehler: Alles wird dem Reviewer aufgebürdet, obwohl es sich automatisieren ließe; die Automatik ist zu streng und erzeugt Fehlalarme, sodass sie ignoriert wird; die manuelle Checkliste enthält Punkte, die längst automatisch laufen.

| **Falsch**                                                                                  | **Richtig**                                                                                                 |
|:--------------------------------------------------------------------------------------------|:------------------------------------------------------------------------------------------------------------|
| Reviewer prüft von Hand, ob der Metadatenkopf vollständig ist und alle Links funktionieren. | Pipeline prüft Kopf und interne Links, der Reviewer konzentriert sich auf Richtigkeit und Verständlichkeit. |

Im Projekt wächst die Automatik mit den Erfahrungen: Jeder Fehler, der im Review gefunden wurde und sich maschinell erkennen lässt, wird zu einer neuen Prüfregel.

## 10.7 Dokumentationsmetriken

Metriken machen den Zustand der Dokumentation messbar. Sie beantworten Fragen wie „Wie aktuell ist unser Bestand?“, „Wie vollständig?“ und „Wird er genutzt?“. Ohne Zahlen bleibt Dokumentationsqualität eine Meinung. Mit ihnen lassen sich Verbesserungen belegen, Prioritäten setzen und Fortschritte zeigen. Die Gefahr besteht darin, Zahlen mit Qualität zu verwechseln und auf Zahlen statt auf Leser zu optimieren.

Man unterscheidet drei Gruppen. *Bestandsmetriken* betrachten die Dokumente selbst: Anzahl, Anteil mit Owner, Anteil mit gültigem Prüfdatum, durchschnittliches Alter seit der letzten Prüfung, Abdeckung (für wie viele Systeme gibt es ein aktuelles Betriebshandbuch?). *Prozessmetriken* betrachten die Abläufe: Durchlaufzeit eines Änderungsantrags, Anteil der Anträge mit Nachbesserung, Zeit bis zur Freigabe. *Nutzungsmetriken* betrachten die Leser: Seitenaufrufe, erfolglose Suchen, Bewertungen („War diese Seite hilfreich?“), Rückfragen im Support zu Themen, die dokumentiert sind.

Eine gute Metrik ist *handlungsleitend*: Aus ihr folgt, was zu tun ist. Der Anteil überfälliger Prüfungen führt zu einer Liste, die der Owner abarbeitet; die Zahl der Seitenaufrufe allein führt zu nichts. Das folgende Beispiel berechnet aus einer Bestandsliste vier Kennzahlen: Anteil mit Owner, Anteil überfälliger Prüfungen, mittleres Alter und Abdeckung der Systeme.

```text
titel;system;owner;geprueft
Betriebshandbuch Shop;shop;Team Betrieb;2026-09-01
Runbook Neustart Shop;shop;Team Betrieb;2026-03-10
Architektur Shop;shop;;2025-04-01
Betriebshandbuch CRM;crm;Team CRM;2026-10-01
```

```python
import csv, statistics
from datetime import date

HEUTE = date(2026, 10, 28)
SYSTEME = {"shop", "crm", "erp"}
dok = list(csv.DictReader(open("bestand.csv", encoding="utf-8"), delimiter=";"))

mit_owner = sum(1 for d in dok if d["owner"])
alter = [(HEUTE - date.fromisoformat(d["geprueft"])).days for d in dok]
ueberfaellig = sum(1 for a in alter if a > 365)
abgedeckt = {d["system"] for d in dok}

print(f"Dokumente: {len(dok)}")
print(f"Mit Owner: {mit_owner} von {len(dok)} ({round(100 * mit_owner / len(dok))} Prozent)")
print(f"Prüfung überfällig (über 365 Tage): {ueberfaellig}")
print(f"Mittleres Alter seit Prüfung: {round(statistics.mean(alter))} Tage, Median {round(statistics.median(alter))}")
print(f"Systeme ohne Dokumentation: {', '.join(sorted(SYSTEME - abgedeckt)) or 'keine'}")
```

Das Skript liest die Bestandsliste, berechnet die Alter in Tagen und gibt die Kennzahlen aus. Mittelwert und Median werden beide angegeben, weil ein einzelnes sehr altes Dokument den Mittelwert stark verschiebt, den Median aber kaum. Die Differenz der Mengen `SYSTEME - abgedeckt` liefert die Systeme, für die gar keine Dokumentation existiert; im Beispiel ist das `erp`. Das Datum ist fest eingetragen, damit das Beispiel reproduzierbar ist; im Betrieb würde `date.today()` verwendet. Die Schwelle von 365 Tagen ist ein Beispielwert, den Sie je Dokumentart festlegen sollten.

Typische Fehler: Zahlen ohne Konsequenz; Ziele, die zur Manipulation einladen (wer nach Seitenzahl bewertet wird, schreibt mehr statt besser); fehlende Definition der Messung, sodass zwei Auswertungen verschiedene Ergebnisse liefern; Konzentration auf einfach Messbares, während das Wesentliche (Verständlichkeit) unbeachtet bleibt.

| **Falsch**                             | **Richtig**                                                                                                         |
|:---------------------------------------|:--------------------------------------------------------------------------------------------------------------------|
| „Wir haben 1200 Seiten Dokumentation.“ | „86 Prozent der Dokumente haben einen Owner, 14 Prozent sind überfällig, zwei Systeme haben kein Betriebshandbuch.“ |

Im Projekt genügen wenige, regelmäßig ausgewertete Kennzahlen mehr als ein Dashboard, das niemand ansieht. Wählen Sie drei und beobachten Sie deren Entwicklung über Quartale.

## 10.8 QA-Troubleshooting

Dieser Abschnitt zeigt, wie man typische Fehlerbilder in der Qualitätssicherung anhand von Struktur, Aktualität, Zielgruppenfeedback und Review-Kommentaren eingrenzt und daraus Runbook-Schritte für Redaktion, Fachbereich und Betrieb ableitet.

Die häufigsten Symptome: „Reviews finden nichts, trotzdem melden Nutzer Fehler“ deutet auf oberflächliche Reviews oder fehlende Praxistests. „Reviews dauern zu lange“ deutet auf zu große Anträge, unklare Zuständigkeit oder fehlende Fristen. „Dieselben Fehler tauchen immer wieder auf“ deutet auf fehlende Rückführung von Befunden in Checkliste und Automatik. „Die Zahlen sind gut, aber keiner ist zufrieden“ deutet auf falsche Metriken. „Die Pipeline wird umgangen“ deutet auf zu viele Fehlalarme oder zu lange Laufzeiten.

Ein wirksames Mittel ist die *Auswertung der Review-Befunde*: Man zählt, welche Arten von Mängeln im Review gefunden werden, und prüft, ob sie sich automatisieren lassen. Das folgende Skript wertet eine Befundliste aus und rechnet aus, welche Kategorien häufig sind und welche davon als maschinell prüfbar gekennzeichnet sind. So sieht man, wo Automatisierung den größten Nutzen hätte.

```text
dokument;kategorie;pruefbar
RB-001;Tippfehler;ja
RB-001;Link tot;ja
RB-002;Schritt fehlt;nein
RB-003;Link tot;ja
RB-003;Terminologie;ja
RB-004;Schritt fehlt;nein
RB-004;Link tot;ja
```

```python
import csv
from collections import Counter

zeilen = list(csv.DictReader(open("befunde.csv", encoding="utf-8"), delimiter=";"))
zaehler = Counter(z["kategorie"] for z in zeilen)
pruefbar = {z["kategorie"] for z in zeilen if z["pruefbar"] == "ja"}

gesamt = len(zeilen)
for kategorie, n in zaehler.most_common():
    markierung = "automatisierbar" if kategorie in pruefbar else "nur manuell"
    print(f"{kategorie}: {n} ({round(100 * n / gesamt)} Prozent, {markierung})")

auto = sum(n for k, n in zaehler.items() if k in pruefbar)
print(f"Automatisierbar: {round(100 * auto / gesamt)} Prozent aller Befunde")
```

Der `Counter` zählt die Kategorien, die Menge `pruefbar` sammelt die als maschinell prüfbar gekennzeichneten. Das Skript gibt die Kategorien nach Häufigkeit aus und berechnet den Anteil der Befunde, die sich automatisieren ließen. Mit den Beispieldaten sind das 71 Prozent (5 von 7), wobei „Link tot“ mit drei Nennungen die häufigste Kategorie ist. Das ist ein klarer Auftrag: Die Linkprüfung gehört in die Pipeline, und der Reviewer kann sich dem fehlenden Schritt widmen.

Als Runbook für die Redaktion ergibt sich: Befunde sammeln und kategorisieren; Häufigkeiten auswerten; die häufigsten automatisierbaren Kategorien in die Pipeline aufnehmen; Checkliste aktualisieren; Wirkung nach einem Quartal messen; Fehlalarme beobachten und Regeln anpassen.

Typische Fehler: Man verschärft Reviews, statt Ursachen zu beheben; man führt neue Prüfungen ein, ohne die alten zu bereinigen; man misst nicht, ob die Maßnahme wirkt.

| **Falsch**                                        | **Richtig**                                                                                                                       |
|:--------------------------------------------------|:----------------------------------------------------------------------------------------------------------------------------------|
| „Wir verlangen ab jetzt zwei Reviewer für alles.“ | „70 Prozent der Befunde sind maschinell prüfbar; wir automatisieren die drei häufigsten und lassen weiter einen Reviewer prüfen.“ |

Im Projekt sollten Sie aus jedem Befund lernen: Was im Review gefunden wurde, ist ein Kandidat für Automatik, Checkliste oder Schulung.

## 10.9 Versionierung

Versionierung bezeichnet die Vergabe und Pflege von Versionsangaben für Dokumente: Welche Nummer trägt ein Stand, wann wird sie erhöht, und wie hängt sie mit dem Stand der Versionsverwaltung zusammen? Die Versionskontrolle (oben) speichert jeden Commit; die *Versionierung* legt fest, welche Stände als benannte, geprüfte *Ausgaben* gelten. Ein Dokument kann Hunderte von Commits haben, aber nur wenige Versionen.

Ein einfaches und verbreitetes Schema ist `Haupt.Neben`, etwa 2.1. Die Hauptnummer wird erhöht, wenn sich Inhalt und Aussage wesentlich ändern (neue Vorgehensweise, neuer Geltungsbereich), die Nebennummer bei kleineren Änderungen (Korrektur, Klarstellung). Für technische Dokumentation, die mit Software ausgeliefert wird, bietet sich die Anlehnung an die semantische Versionierung aus Modul 08 an. Wichtig ist nicht das Schema, sondern dass es *dokumentiert* ist und alle es gleich anwenden. Bei freigabepflichtigen Dokumenten gilt: Eine Version ist ein freigegebener, unveränderlicher Stand; Änderungen führen zu einer neuen Version.

Die Verbindung zur Versionsverwaltung stellen Tags her. Das folgende Beispiel zeigt ein Skript, das für ein Dokument mit Versionsangabe im Kopf prüft, ob die angegebene Version als Tag existiert und ob die Datei seit diesem Tag verändert wurde. So erkennt man, wenn jemand nach der Freigabe still weitergearbeitet hat.

```python
import re, subprocess, sys

datei = sys.argv[1]
text = open(datei, encoding="utf-8").read()
version = re.search(r"^version:\s*(\S+)", text, re.M).group(1)
tag = f"v{version}"

def git(*args):
    return subprocess.run(["git", *args], capture_output=True, text=True)

if git("rev-parse", "-q", "--verify", f"refs/tags/{tag}").returncode != 0:
    print(f"Tag {tag} existiert nicht - Version {version} ist nicht festgeschrieben")
    sys.exit(1)

diff = git("diff", "--stat", tag, "--", datei).stdout.strip()
if diff:
    print(f"Datei seit {tag} verändert, aber Version noch {version}:\n{diff}")
    sys.exit(1)
print(f"{datei}: Stand entspricht {tag}")
```

Das Skript liest die Version aus dem Kopf und bildet den Tag-Namen. `git rev-parse --verify` prüft, ob der Tag existiert; `git diff --stat` vergleicht die Datei mit dem getaggten Stand und gibt eine Zusammenfassung aus, falls es Unterschiede gibt. Die Hilfsfunktion `git` kapselt den Aufruf, sodass der Rest des Skripts lesbar bleibt. In Verbindung mit dem Ablauf aus dem Abschnitt zu Git ergibt sich: Wer eine Version freigibt, setzt einen Tag; wer danach weiterarbeitet, erhöht die Version vor der nächsten Freigabe.

Typische Fehler: Versionsnummern werden von Hand geführt und weichen vom System ab; die Nummer ändert sich nie, obwohl der Inhalt sich ändert; alte Versionen sind nicht mehr abrufbar, obwohl sie für Nachweise nötig wären.

| **Falsch**                                                               | **Richtig**                                                                            |
|:-------------------------------------------------------------------------|:---------------------------------------------------------------------------------------|
| Version 1.0 im Kopf, seit zwei Jahren, obwohl 40 Änderungen stattfanden. | Version 2.3 im Kopf, Tag `v2.3` im Repository, Änderungsverlauf mit Datum und Grund. |

Im Projekt hilft es, die Versionsnummer im Dokument *automatisch* aus dem Tag zu erzeugen, wenn die Werkzeuge es erlauben. Was automatisch entsteht, kann nicht vergessen werden.

## 10.10 Freigabeprozess

Der Freigabeprozess ist der geregelte Weg von der fertigen Änderung zum gültigen Dokument. Das organisatorische Konzept (Rollen, Freigabematrix, Stufen) wurde in Modul 06 behandelt. Hier geht es um den *Ablauf als technischer Prozess* mit Auslösern, Prüfungen und Nachweisen, wie er in Plattformen umgesetzt wird, und um das Zusammenspiel mit der Versionierung.

Ein technischer Freigabeprozess besteht aus fünf Stationen. Die *Einreichung* erfolgt durch einen Änderungsantrag. Die *automatische Vorprüfung* lässt Pipeline und Checkliste laufen. Der *Review* wird durch zugewiesene Personen durchgeführt. Die *Freigabeentscheidung* trifft die berechtigte Rolle. Die *Veröffentlichung* umfasst die Übernahme in den Hauptzweig, das Setzen der Version (Tag), das Bauen und Bereitstellen der Ausgabe und die Information der Beteiligten. Jede Station hinterlässt einen Nachweis: Antrag, Pipeline-Ergebnis, Kommentare, Freigabevermerk, Tag.

Das folgende Beispiel zeigt einen *Freigabe-Gatekeeper*: ein Skript, das vor der Veröffentlichung prüft, ob alle Bedingungen erfüllt sind. Es liest eine Beschreibung des Vorgangs und entscheidet, ob veröffentlicht werden darf. Dies ist die Logik, die in Pipelines als „Freigabetor“ umgesetzt wird.

```yaml
dokument: SOP-007
version: 2.2
pipeline: bestanden
reviews:
  - {von: Bernd Huber, ergebnis: ok}
freigabe:
  von: Cora Maier
  rolle: Leitung Betrieb
autor: Anna Berger
```

```python
import sys, yaml

BERECHTIGT = {"sop": {"Leitung Betrieb", "Leitung IT"}}
d = yaml.safe_load(open(sys.argv[1], encoding="utf-8"))
art = d["dokument"].split("-")[0].lower()
gruende = []

if d.get("pipeline") != "bestanden":
    gruende.append("Pipeline nicht bestanden")
if not any(r["ergebnis"] == "ok" and r["von"] != d["autor"] for r in d.get("reviews", [])):
    gruende.append("Kein positives Review durch eine andere Person")
f = d.get("freigabe")
if not f:
    gruende.append("Keine Freigabe")
else:
    if f["von"] == d["autor"]:
        gruende.append("Autor darf nicht selbst freigeben")
    if f["rolle"] not in BERECHTIGT.get(art, set()):
        gruende.append(f"Rolle {f['rolle']} nicht berechtigt für {art}")

if gruende:
    print("VERÖFFENTLICHUNG GESPERRT:", *gruende, sep="\n  - ")
    sys.exit(1)
print(f"Veröffentlichung von {d['dokument']} Version {d['version']} freigegeben")
```

Der Vorgang enthält alle Nachweise: Pipeline-Ergebnis, Reviews, Freigabe, Autor. Das Skript sammelt Gründe, die die Veröffentlichung sperren, und gibt sie gesammelt aus, statt beim ersten Fehler abzubrechen; so sieht der Autor auf einmal, was fehlt. Die Art des Dokuments wird aus der Kennung abgeleitet (`SOP-007` wird zu `sop`) und mit der Berechtigungstabelle abgeglichen. Mit den Beispieldaten ist alles erfüllt, und das Skript gibt die Freigabe aus. Ändert man etwa die Freigabe auf `von: Anna Berger`, wird die Veröffentlichung gesperrt.

Typische Fehler: Der Prozess ist so schwergewichtig, dass er umgangen wird; die Nachweise liegen in drei Systemen und lassen sich nicht zusammenführen; die Veröffentlichung ist ein manueller Schritt, der vergessen wird, sodass freigegebene Fassungen nicht erscheinen.

| **Falsch**                                                        | **Richtig**                                                                                                                                        |
|:------------------------------------------------------------------|:---------------------------------------------------------------------------------------------------------------------------------------------------|
| Freigabe per E-Mail, danach kopiert jemand die Datei in das Wiki. | Freigabe im System, Veröffentlichung automatisch durch die Pipeline nach Übernahme in den Hauptzweig, Tag und Freigabevermerk automatisch erzeugt. |

Im Projekt ist die Automatisierung der Veröffentlichung eine der besten Investitionen: Sie beseitigt die Lücke zwischen „freigegeben“ und „verfügbar“.

## 10.11 Änderungsprozess

Der Änderungsprozess regelt, wie Änderungen an bestehenden, freigegebenen Dokumenten beantragt, bewertet, umgesetzt und mitgeteilt werden. Er ist ein Spezialfall des Freigabeprozesses für Dokumente, die bereits gelten und deshalb nicht einfach überschrieben werden dürfen. Ein Änderungsprozess sorgt dafür, dass Änderungen nachvollziehbar sind, die richtigen Personen informiert werden und keine Folgedokumente vergessen werden.

Auslöser von Änderungen sind verschieden: Eine Systemänderung macht ein Runbook ungültig, ein Review findet einen Fehler, ein Nutzer meldet ein Problem, eine neue Vorschrift verlangt eine Anpassung. Der Prozess unterscheidet deshalb nach Dringlichkeit und Tragweite. *Korrekturen* (Tippfehler, Klarstellungen) können vereinfacht freigegeben werden, *inhaltliche Änderungen* durchlaufen den vollen Freigabeprozess, *dringende Änderungen* (Fehler in einer Betriebsanleitung mit Risiko) gehen einen beschleunigten Weg mit Nachprüfung. Die Einteilung gehört in den Standard (Modul 07).

Zu jeder Änderung gehört eine *Auswirkungsanalyse*: Welche anderen Dokumente verweisen auf dieses? Das folgende Beispiel zeigt eine Änderungsanfrage als Datei und ein Skript, das fehlende Angaben meldet und mit Hilfe einer Verweisliste die betroffenen Folgedokumente ermittelt, damit sie im selben Zug geprüft werden. So wird verhindert, dass ein Runbook geändert wird, während drei Dokumente weiter die alte Fassung zitieren.

```yaml
aenderung: AEN-0042
dokument: Runbook Neustart Shop
art: inhaltlich
grund: Neuer Dienstname nach Migration
beschreibung: Dienstname von shop-alt auf shop-neu ändern
```

```text
von;nach
Betriebshandbuch Shop;Runbook Neustart Shop
Notfallplan;Runbook Neustart Shop
Architektur Shop;Betriebshandbuch Shop
```

```python
import csv, sys, yaml

PFLICHT = ["aenderung", "dokument", "art", "grund", "beschreibung"]
ARTEN = {"korrektur", "inhaltlich", "dringend"}
a = yaml.safe_load(open(sys.argv[1], encoding="utf-8"))

fehler = [f"Angabe fehlt: {p}" for p in PFLICHT if not a.get(p)]
if a.get("art") not in ARTEN:
    fehler.append(f"Art muss eine von {sorted(ARTEN)} sein")
if fehler:
    sys.exit("\n".join(fehler))

verweise = list(csv.DictReader(open("verweise.csv", encoding="utf-8"), delimiter=";"))
betroffen, offen = set(), [a["dokument"]]
while offen:
    ziel = offen.pop()
    for v in verweise:
        if v["nach"] == ziel and v["von"] not in betroffen:
            betroffen.add(v["von"]); offen.append(v["von"])

print(f"{a['aenderung']} ({a['art']}): {a['dokument']}")
print("Zu prüfende Folgedokumente:", ", ".join(sorted(betroffen)) or "keine")
```

Die Anfrage enthält Kennung, Dokument, Art, Grund und Beschreibung; das Skript prüft die Vollständigkeit und die Art. Danach durchläuft es die Verweisliste mit einem Stapel, sammelt alle Dokumente, die direkt oder indirekt auf das geänderte verweisen, und gibt sie aus. Im Beispiel gehören Betriebshandbuch, Notfallplan und, über das Betriebshandbuch, die Architekturbeschreibung dazu. Die Schleife mit der Menge `betroffen` verhindert, dass zyklische Verweise endlos laufen.

Typische Fehler: Änderungen werden ohne Begründung eingereicht; die Auswirkung auf andere Dokumente wird übersehen; Änderungen an freigegebenen Fassungen erfolgen still; der Änderungsverlauf ist nicht im Dokument sichtbar.

| **Falsch**                                                                                       | **Richtig**                                                                                                                                |
|:-------------------------------------------------------------------------------------------------|:-------------------------------------------------------------------------------------------------------------------------------------------|
| „Habe den Dienstnamen im Runbook geändert.“ Die Betriebsdokumente nennen weiter den alten Namen. | Änderungsanfrage AEN-0042 mit Begründung, Auswirkungsanalyse (drei Folgedokumente), Änderung in einem Antrag, Eintrag im Änderungsverlauf. |

Im Projekt ist die Verweisliste der Schlüssel. Wer pflegt, welche Dokumente aufeinander verweisen (siehe Modul 05, Abhängigkeiten), kann Änderungen mit überschaubarem Aufwand konsistent durchführen.

## 10.12 Review Zyklus

Ein Review-Zyklus legt fest, in welchen Abständen ein Dokument *unabhängig von konkreten Änderungen* erneut geprüft wird. Während der Review-Prozess (oben) eine Änderung begleitet, sorgt der Zyklus dafür, dass auch unveränderte Dokumente nicht veralten, weil sich die Umgebung geändert hat, ohne dass jemand es dokumentiert hat. Die Verwaltung dieser Termine im Detail (Review-Kalender, Ablaufdaten, Erinnerungen) behandelt Modul 14; hier steht der Zyklus als Qualitätssicherungsmaßnahme.

Der Abstand richtet sich nach Risiko und Änderungshäufigkeit. Ein Notfallplan oder eine Sicherheitsrichtlinie wird häufiger geprüft (zum Beispiel jährlich), ein stabiles Grundlagendokument seltener. Die Werte sind Beispiele und gehören in den Standard. Zusätzlich gibt es *ereignisgesteuerte Reviews*: Nach einem Vorfall, einer Systemänderung oder einer neuen Vorschrift wird geprüft, ob Dokumente angepasst werden müssen. Ein guter Review-Zyklus kombiniert beides.

Das folgende Beispiel berechnet aus Dokumentarten und deren Zyklus die nächsten Prüftermine und markiert überfällige. Es zeigt, wie man aus einem Zyklus pro Art und dem Datum der letzten Prüfung einen Termin ableitet, ohne ihn von Hand zu pflegen.

```text
art;zyklus_monate
notfallplan;6
sicherheitsrichtlinie;12
runbook;12
grundlagen;24
```

```text
titel;art;geprueft
Notfallplan Shop;notfallplan;2026-03-15
Richtlinie Backup;sicherheitsrichtlinie;2026-01-10
Runbook Neustart;runbook;2025-10-01
Doku-Grundlagen;grundlagen;2025-02-01
```

```python
import csv
from datetime import date

HEUTE = date(2026, 10, 28)

def plus_monate(d, n):
    monat = d.month - 1 + n
    jahr, monat = d.year + monat // 12, monat % 12 + 1
    tag = min(d.day, [31, 29 if jahr % 4 == 0 and (jahr % 100 or jahr % 400 == 0) else 28,
                      31, 30, 31, 30, 31, 31, 30, 31, 30, 31][monat - 1])
    return date(jahr, monat, tag)

zyklus = {z["art"]: int(z["zyklus_monate"])
          for z in csv.DictReader(open("zyklen.csv", encoding="utf-8"), delimiter=";")}
for z in csv.DictReader(open("dokumente.csv", encoding="utf-8"), delimiter=";"):
    faellig = plus_monate(date.fromisoformat(z["geprueft"]), zyklus[z["art"]])
    stand = "ÜBERFÄLLIG" if faellig < HEUTE else f"in {(faellig - HEUTE).days} Tagen"
    print(f"{z['titel']}: fällig {faellig} ({stand})")
```

Die Funktion `plus_monate` addiert Monate zu einem Datum, ohne eine Zusatzbibliothek zu benötigen. Sie berechnet Jahr und Monat neu und begrenzt den Tag auf die Länge des Zielmonats, damit etwa der 31. Januar plus einen Monat nicht ungültig wird. Das Skript ordnet jedem Dokument den Zyklus seiner Art zu und gibt den Termin und den Stand aus. Mit den Beispieldaten ist der Notfallplan seit dem 15. September 2026 überfällig, das Runbook seit 1. Oktober 2026, und die Sicherheitsrichtlinie ist fällig am 10. Januar 2027.

Typische Fehler: Alle Dokumente haben denselben Zyklus; der Zyklus existiert nur im Standard, aber keine Termine im System; Prüfungen werden durch Weiterschieben des Datums ohne Prüfung „erledigt“. Letzteres ist besonders gefährlich, weil es den Anschein von Aktualität erweckt.

| **Falsch**                                                               | **Richtig**                                                                                                               |
|:-------------------------------------------------------------------------|:--------------------------------------------------------------------------------------------------------------------------|
| Alle Dokumente werden jährlich im Januar geprüft, in einem großen Block. | Zyklus nach Risiko (6, 12, 24 Monate), Termine automatisch berechnet und verteilt, ereignisgesteuerte Reviews zusätzlich. |

Im Projekt sollte jede Prüfung ein Ergebnis haben: „unverändert gültig“, „angepasst“ oder „außer Dienst gestellt“, mit Datum und Namen des Prüfers.

## 10.13 Dokumentenstatus

Der Dokumentenstatus beschreibt die Lebenslage eines Dokuments: Ist es in Arbeit, gültig, überarbeitungsbedürftig, ersetzt oder archiviert? Er ergänzt den Freigabestatus: Dieser sagt, wo eine *Änderung* im Freigabeprozess steht; der Dokumentenstatus sagt, ob das *Dokument* heute gilt. Ein Dokument kann den Freigabestatus „freigegeben“ und zugleich den Dokumentenstatus „überarbeitungsbedürftig“ haben, weil sein Prüftermin überschritten ist.

Typische Lebenslagen sind Entwurf, gültig, überarbeitung fällig, ersetzt und archiviert. Es lohnt sich, sie *aus Daten abzuleiten*, wo es geht, statt sie von Hand zu pflegen: Ob die Prüfung überfällig ist, folgt aus dem Datum, ob ein Dokument ersetzt wurde, aus einem Nachfolgerverweis. Abgeleitete Status sind nie veraltet. Das folgende Beispiel leitet den Dokumentenstatus aus Metadaten ab.

```text
- {titel: Runbook Neustart, freigegeben: ja, naechste_pruefung: 2027-02-01}
- {titel: Altes Backup-Verfahren, freigegeben: ja, naechste_pruefung: 2025-12-01, nachfolger: Backup-Verfahren 2}
- {titel: Notfallplan, freigegeben: ja, naechste_pruefung: 2026-09-01}
- {titel: Neues Konzept, freigegeben: nein, naechste_pruefung: 2027-06-01}
- {titel: Altlast, freigegeben: ja, naechste_pruefung: 2024-01-01, archiviert: ja}
```

```python
import sys, yaml
from datetime import date

HEUTE = date(2026, 10, 28)

def status(d):
    if d.get("archiviert") == "ja":
        return "archiviert"
    if d.get("nachfolger"):
        return "ersetzt"
    if d["freigegeben"] != "ja":
        return "entwurf"
    if d["naechste_pruefung"] < HEUTE:
        return "überarbeitung fällig"
    return "gültig"

for d in yaml.safe_load(open(sys.argv[1], encoding="utf-8")):
    print(f"{d['titel']}: {status(d)}")
```

Die Funktion prüft die Bedingungen in einer festen Reihenfolge, die selbst eine Regel ist: Archiviertes bleibt archiviert, auch wenn der Prüftermin überschritten ist; ein ersetztes Dokument gilt nicht mehr, auch wenn es einmal freigegeben war; erst dann folgt die Unterscheidung zwischen Entwurf, überfällig und gültig. YAML liest unquotierte Datumsangaben als Datumsobjekte, sodass der Vergleich mit `HEUTE` direkt möglich ist. Für das Beispiel ergibt sich: gültig, ersetzt, überarbeitung fällig, entwurf, archiviert.

Typische Fehler: Status wird von Hand gepflegt und weicht von der Wirklichkeit ab; veraltete Dokumente erscheinen weiter in der Suche ohne Warnhinweis; der Status ist für Leser nicht sichtbar; es gibt keinen Status für „ersetzt“, sodass alte und neue Fassung gleichberechtigt auftauchen.

| **Falsch**                                                                             | **Richtig**                                                                                                     |
|:---------------------------------------------------------------------------------------|:----------------------------------------------------------------------------------------------------------------|
| Zwei Seiten „Backup-Verfahren“ und „Backup-Verfahren (alt)“, beide ohne Statushinweis. | Altes Verfahren mit Status „ersetzt“, Hinweisbanner und Verweis auf den Nachfolger, aus der Suche herabgestuft. |

Im Projekt ist die Sichtbarkeit entscheidend: Ein Banner „Dieses Dokument ist veraltet, siehe …“ verhindert mehr Fehler als jede Richtlinie.

## 10.14 Archivierung

Archivierung bedeutet, Dokumente, die nicht mehr gelten, kontrolliert aus dem aktiven Bestand zu nehmen und zugleich aufzubewahren, soweit es nötig ist. Sie ist keine Löschung: Ein archiviertes Dokument bleibt auffindbar und lesbar, wird aber als nicht mehr gültig gekennzeichnet und aus normalen Suchen und Navigationen herausgehalten. Der Zweck ist doppelt: Der aktive Bestand soll übersichtlich und verlässlich bleiben, und die Organisation soll Nachweise über frühere Stände behalten können.

Eine Archivierung folgt einem Ablauf. Zuerst die *Entscheidung* durch den Owner (Modul 14 behandelt Entscheidungskriterien). Dann die *Prüfung auf Abhängigkeiten*: Verweist noch ein aktives Dokument darauf? Danach die *Kennzeichnung* (Status, Archivierungsdatum, Grund, Nachfolger) und die *Verlagerung* in den Archivbereich. Schließlich die *Festlegung der Aufbewahrungsfrist* (Modul 13) und, nach deren Ablauf, die kontrollierte Löschung. Die Versionsverwaltung hilft dabei: Eine Datei, die aus dem aktuellen Stand entfernt wird, bleibt in der Geschichte erhalten. Für Nachweise sollte aber der Stand zum Archivierungszeitpunkt per Tag markiert werden.

Das folgende Beispiel archiviert eine Datei: Es verschiebt sie in einen Archivordner, ergänzt einen Hinweis im Kopf und schreibt einen Eintrag ins Archivprotokoll. Es verweigert die Archivierung, wenn andere Dateien noch auf sie verweisen.

```python
import re, shutil, sys, time
from pathlib import Path

wurzel, name, grund = Path(sys.argv[1]), sys.argv[2], sys.argv[3]
ziel = wurzel / name

noch_verlinkt = [d.name for d in wurzel.glob("*.md")
                 if d.name != name and f"({name})" in d.read_text(encoding="utf-8")]
if noch_verlinkt:
    sys.exit(f"Archivierung abgelehnt, noch verlinkt von: {', '.join(noch_verlinkt)}")

archiv = wurzel / "archiv"
archiv.mkdir(exist_ok=True)
text = ziel.read_text(encoding="utf-8")
heute = time.strftime("%Y-%m-%d")
text = re.sub(r"^status:.*$", f"status: archiviert\narchiviert_am: {heute}\narchiv_grund: {grund}",
              text, count=1, flags=re.M)
(archiv / name).write_text(text, encoding="utf-8")
ziel.unlink()
with open(archiv / "protokoll.txt", "a", encoding="utf-8") as f:
    f.write(f"{heute};{name};{grund}\n")
print(f"{name} archiviert")
```

Das Skript sucht zunächst in allen Dateien nach Verweisen der Form `(datei.md)` und lehnt ab, wenn welche existieren. Andernfalls ersetzt es die Statuszeile im Kopf durch drei Zeilen (Status, Datum, Grund) mit `re.sub` und `count=1`, damit nur die erste Fundstelle verändert wird, schreibt die Datei in den Archivordner, löscht das Original und protokolliert den Vorgang. In einem Repository würde man statt `unlink` `git mv` verwenden, damit die Geschichte der Datei zusammenhängend bleibt.

Typische Fehler: Dokumente werden einfach gelöscht und sind später für Nachweise nicht mehr da; das Archiv wird zu einem unstrukturierten Sammelordner; archivierte Dokumente tauchen weiter in der Suche auf und werden für gültig gehalten; Aufbewahrungsfristen fehlen, sodass nie etwas gelöscht wird.

| **Falsch**                                         | **Richtig**                                                                                                     |
|:---------------------------------------------------|:----------------------------------------------------------------------------------------------------------------|
| Ordner „Alt“ mit 400 Dateien ohne Datum und Grund. | Archivbereich mit Protokoll (Datum, Grund, Nachfolger), Status „archiviert“, Aufbewahrungsfrist je Dokumentart. |

Im Projekt gehört zur Archivierung die Frage, *wer* Zugriff auf Archivbestände hat. Archivierte Dokumente können noch vertrauliche Inhalte enthalten, und die Zugriffsregeln gelten weiter (Modul 13).

## 10.15 Audit Trail

Ein Audit Trail (Prüfpfad) ist die lückenlose, nachträglich nicht veränderbare Aufzeichnung dessen, was mit einem Dokument geschehen ist: wer es angelegt, geändert, geprüft und freigegeben hat, wann und warum. Er dient dem Nachweis gegenüber Auditoren, Kunden und Behörden und der internen Aufklärung („Wie kam diese Änderung in das Runbook?“). Die Anforderungen an Auditierbarkeit im Zusammenhang mit Datenschutz und Compliance werden in Modul 13 behandelt; hier geht es um die technische Gewinnung des Pfades aus der Versionsverwaltung.

Git liefert einen großen Teil des Audit Trails ohne Zusatzaufwand: Jeder Commit hat Autor, Zeitpunkt, Beschreibung und die geänderten Zeilen, und die Kommentare der Änderungsanträge dokumentieren Review und Freigabe. Zwei Einschränkungen sind zu beachten. Erstens lassen sich Commits in Git grundsätzlich umschreiben, wenn jemand die Geschichte neu schreibt; für Nachweise sollte der Hauptzweig gegen solche Eingriffe geschützt sein (die Konfiguration hängt von der Plattform ab). Zweitens sind Angaben wie der Autorenname im Commit von demjenigen frei konfigurierbar; ein belastbarer Nachweis erfordert bei höheren Anforderungen zusätzlich Signaturen oder die Protokolle der Plattform.

Das folgende Beispiel zeigt zwei Dinge. Zuerst einen Git-Befehl, der die Geschichte einer Datei als Tabelle ausgibt. Dann ein Skript für eine *verkettete Protokolldatei*: Jeder Eintrag enthält die Prüfsumme des vorherigen Eintrags, sodass jede nachträgliche Änderung die Kette bricht und erkennbar wird. Das Prinzip steckt hinter vielen manipulationssicheren Protokollen.

```bash
git log --follow --date=short --pretty=format:'%h;%an;%ad;%s' -- runbook.md
```

```python
import hashlib, json, sys, time
from pathlib import Path

LOG = Path("audit.jsonl")

def pruefsumme(eintrag):
    return hashlib.sha256(json.dumps(eintrag, sort_keys=True).encode("utf-8")).hexdigest()

def anhaengen(wer, was):
    vorher = LOG.read_text(encoding="utf-8").splitlines() if LOG.exists() else []
    letzte = json.loads(vorher[-1])["hash"] if vorher else "0" * 64
    eintrag = {"zeit": time.strftime("%Y-%m-%dT%H:%M:%S"), "wer": wer, "was": was, "vorher": letzte}
    eintrag["hash"] = pruefsumme(eintrag)
    with open(LOG, "a", encoding="utf-8") as f:
        f.write(json.dumps(eintrag) + "\n")

def pruefen():
    letzte = "0" * 64
    for nr, zeile in enumerate(LOG.read_text(encoding="utf-8").splitlines(), 1):
        e = json.loads(zeile)
        h = e.pop("hash")
        if e["vorher"] != letzte or pruefsumme(e) != h:
            return f"Kette gebrochen in Zeile {nr}"
        letzte = h
    return "Kette intakt"

if sys.argv[1] == "anhaengen":
    anhaengen(sys.argv[2], sys.argv[3])
else:
    print(pruefen())
```

Der Git-Befehl gibt je Commit Kurzkennung, Autor, Datum und Betreff aus; `--follow` verfolgt die Datei auch über Umbenennungen. Das Skript speichert jeden Eintrag als JSON-Zeile mit den Feldern Zeit, Akteur, Aktion und der Prüfsumme des Vorgängers; die eigene Prüfsumme wird über den Inhalt gebildet. Die Funktion `pruefen` geht die Zeilen durch, vergleicht jeweils den Verweis auf den Vorgänger und berechnet die Prüfsumme neu. Ändert jemand eine Zeile nachträglich, stimmt ihre Prüfsumme nicht mehr; löscht er eine Zeile, stimmt der Verweis der folgenden nicht. Eine Einschränkung bleibt: Wer die gesamte Datei samt aller Prüfsummen neu erzeugt, wird nicht erkannt; für starke Nachweise muss die letzte Prüfsumme an anderer Stelle hinterlegt werden.

Typische Fehler: Der Audit Trail ist lückenhaft, weil Änderungen am System vorbei geschehen (direkt auf dem Server); er enthält zu viel (jede Kleinigkeit) und wird nicht ausgewertet; er enthält schützenswerte Daten ohne Zugriffsschutz; er wird nach kurzer Zeit gelöscht, bevor der Nachweiszeitraum abgelaufen ist.

| **Falsch**                                                                    | **Richtig**                                                                                                                                     |
|:------------------------------------------------------------------------------|:------------------------------------------------------------------------------------------------------------------------------------------------|
| Änderungen werden auf dem Wiki-Server direkt vorgenommen, ein Nachweis fehlt. | Alle Änderungen laufen über Änderungsanträge, Hauptzweig geschützt, Plattformprotokolle aufbewahrt, Prüfsumme des Protokolls extern hinterlegt. |

Im Projekt lohnt ein Probelauf: Wählen Sie ein Dokument und versuchen Sie, seine Geschichte lückenlos zu rekonstruieren. Wo es hakt, fehlt Nachweisbarkeit.

## 10.16 Versionierungs-Troubleshooting

Dieser Abschnitt zeigt, wie man typische Fehlerbilder bei der Versionierung anhand von Struktur, Aktualität, Zielgruppenfeedback und Review-Kommentaren eingrenzt und daraus Runbook-Schritte für Redaktion, Fachbereich und Betrieb ableitet.

Die häufigsten Symptome: „Es kursieren mehrere Fassungen“ deutet auf Kopien außerhalb des Systems. „Die Versionsnummer stimmt nicht“ deutet auf manuelle Pflege. „Eine freigegebene Fassung wurde verändert“ deutet auf fehlenden Schutz. „Merge-Konflikte häufen sich“ deutet auf große, lange laufende Zweige oder mehrere Personen, die an denselben Stellen arbeiten. „Ein Geheimnis steht in der Geschichte“ deutet auf fehlende Vorabprüfung (Modul 13). „Das Repository ist riesig“ deutet auf eingecheckte Binärdateien.

Ein Teil dieser Probleme lässt sich in einem Bestandsscan aufspüren. Das folgende Skript durchsucht ein Verzeichnis nach Dateinamen, die auf Handversionierung deuten („final“, „neu“, „v2“, „kopie“), nach Dateien mit gleichem Namensstamm und prüft, ob die Versionsangabe im Kopf mit dem Tag übereinstimmt. Die Funde sind Arbeitsliste für die Aufräumaktion.

```python
import re, sys
from collections import defaultdict
from pathlib import Path

VERDAECHTIG = re.compile(r"(final|neu|kopie|copy|_v\d+|\(\d\))", re.I)
stamm = defaultdict(list)

for datei in sorted(Path(sys.argv[1]).rglob("*")):
    if not datei.is_file():
        continue
    if VERDAECHTIG.search(datei.stem):
        print(f"Handversionierung vermutet: {datei.name}")
    basis = VERDAECHTIG.sub("", datei.stem).strip(" _-").lower()
    stamm[(datei.parent, basis)].append(datei.name)

for (ordner, basis), namen in stamm.items():
    if len(namen) > 1:
        print(f"Mehrere Fassungen von '{basis}': {', '.join(namen)}")
```

Der reguläre Ausdruck erkennt typische Marker im Dateinamen, ohne die Groß-/Kleinschreibung zu beachten. Zusätzlich werden die Marker aus dem Namen entfernt, um den Stamm zu bilden; Dateien im selben Ordner mit gleichem Stamm gelten als Fassungen desselben Dokuments. Das Skript meldet beides. Es ist eine Heuristik: Eine Datei, die legitim „neu“ im Namen trägt, wird gemeldet, und Fassungen mit komplett abweichenden Namen werden übersehen. Das Ergebnis ist eine Liste von Kandidaten, die ein Mensch prüft.

Als Runbook ergibt sich: Bestandsscan durchführen; pro Fundstelle entscheiden, welche Fassung maßgeblich ist; die maßgebliche Fassung ins System überführen; die übrigen archivieren oder löschen; die Beteiligten informieren und ihnen den Ablageort nennen; die Regel (keine Kopien außerhalb des Systems) in den Standard aufnehmen; nach einem Quartal erneut scannen.

Typische Fehler: Man räumt einmal auf und ändert nichts an der Ursache; man löscht Fassungen, ohne die maßgebliche zu klären; man führt Regeln ein, ohne den Beteiligten einen einfachen Weg zu zeigen.

| **Falsch**                         | **Richtig**                                                                                                                      |
|:-----------------------------------|:---------------------------------------------------------------------------------------------------------------------------------|
| „Bitte keine Kopien mehr anlegen.“ | Bestandsscan, maßgebliche Fassung im System, Ablageort bekanntgegeben, Vorlage für den Antrag bereitgestellt, regelmäßiger Scan. |

Im Projekt ist der wichtigste Hebel der leichte Weg: Wenn die richtige Art zu arbeiten einfacher ist als die falsche, setzt sie sich durch.

## Übungsaufgaben

Die Aufgaben steigen von Verständnisfragen (1 bis 3) über Anwendungsaufgaben (4 bis 6) bis zu Programmier- und Transferaufgaben (7 und 8) an.

**Aufgabe 1.** *(leicht)* Erklären Sie die Begriffe Commit, Branch, Merge und Tag in je einem Satz.

**Aufgabe 2.** *(leicht)* Worin unterscheiden sich Freigabestatus und Dokumentenstatus? Geben Sie ein Beispiel, bei dem beide verschieden sind.

**Aufgabe 3.** *(leicht bis mittel)* Warum sollte der Hauptzweig geschützt sein? Welche zwei Einschränkungen hat Git als Audit Trail?

**Aufgabe 4.** *(mittel)* Entwerfen Sie ein Statusmodell (Zustände, Übergänge, Rollen) für Richtlinien, bei dem ein Rückfall von „freigegeben“ nur über eine neue Version möglich ist.

**Aufgabe 5.** *(mittel)* Erstellen Sie eine Vorlage für Änderungsanträge mit fünf Abschnitten und begründen Sie jeden.

**Aufgabe 6.** *(mittel, praktisch)* Führen Sie im Testverzeichnis den Git-Ablauf aus dem Modul aus und beantworten Sie: Was zeigt `git log --oneline --graph` nach dem Merge mit `--no-ff`? Was würde ohne `--no-ff` anders aussehen?

**Aufgabe 7.** *(anspruchsvoll, praktisch)* Erweitern Sie das Metrikskript um die Kennzahl „Anteil der Dokumente, die in den letzten 90 Tagen geprüft wurden“ und um eine Ausgabe der drei ältesten Dokumente.

**Aufgabe 8.** *(anspruchsvoll, Transfer)* Ein Team arbeitet mit Word-Dateien auf einem Netzlaufwerk. Es gibt häufig Streit um die gültige Fassung. Entwerfen Sie einen Umstieg auf Versionskontrolle mit Review und Freigabe, der auch für Mitarbeitende ohne Git-Kenntnisse praktikabel ist.

## Lösungen und Erläuterungen

**Lösung zu Aufgabe 1.** Ein Commit ist ein gespeicherter Stand mit Autor, Zeit und Beschreibung. Ein Branch ist eine eigenständige Entwicklungslinie, in der man ändern kann, ohne den Hauptzweig zu beeinflussen. Ein Merge führt die Änderungen eines Zweigs in einen anderen zusammen. Ein Tag ist eine dauerhafte Markierung eines bestimmten Standes, zum Beispiel einer freigegebenen Version.

**Lösung zu Aufgabe 2.** Der Freigabestatus beschreibt, wie weit eine Änderung im Prüf- und Freigabeprozess ist; der Dokumentenstatus, ob das Dokument aktuell gilt. Beispiel: Ein Runbook wurde im März freigegeben (Freigabestatus freigegeben), die Jahresprüfung ist aber seit September überfällig (Dokumentenstatus überarbeitung fällig). Ein anderes Beispiel: Ein freigegebenes Dokument, das durch einen Nachfolger ersetzt wurde, hat weiter den Freigabestatus freigegeben, aber den Dokumentenstatus ersetzt.

**Lösung zu Aufgabe 3.** Ein geschützter Hauptzweig verhindert, dass Änderungen am Review vorbei und ohne Nachweis hineingelangen oder die Geschichte umgeschrieben wird. Die Einschränkungen: Commits lassen sich bei fehlendem Schutz umschreiben, und Angaben wie der Autorenname sind frei konfigurierbar, ein Nachweis der Person erfordert daher zusätzliche Mittel (Signaturen, Plattformprotokolle, persönliche Konten).

**Lösung zu Aufgabe 4.** Eine mögliche Lösung:

```yaml
uebergaenge:
  entwurf:
    in_pruefung: [autor]
  in_pruefung:
    entwurf: [reviewer, approver]
    freigegeben: [approver]
    abgelehnt: [approver]
  freigegeben:
    ersetzt: [approver]
  ersetzt: {}
  abgelehnt:
    entwurf: [autor]
```

Aus „freigegeben“ führt kein Weg zurück in den Entwurf. Änderungen erfolgen in einer neuen Version, die ihrerseits mit `entwurf` beginnt; wird sie freigegeben, geht die alte in den Zustand „ersetzt“ über. Damit bleibt jede freigegebene Fassung unverändert erhalten. Das Statusprüfskript des Moduls kann dieses Modell direkt verarbeiten.

**Lösung zu Aufgabe 5.** Eine mögliche Vorlage: (1) „Was wurde geändert?“ gibt dem Reviewer den Überblick. (2) „Warum?“ liefert die Begründung für die Nachvollziehbarkeit. (3) „Auswirkungen auf andere Dokumente“ verhindert vergessene Folgeänderungen. (4) „Checkliste“ stellt die Mindestprüfung sicher. (5) „Nachweis der Prüfung“ (zum Beispiel Testsystem, Datum) belegt, dass Anleitungen wirklich ausgeführt wurden.

**Lösung zu Aufgabe 6.** Nach dem Merge zeigt die Graphansicht den Zweig mit dem Prüfschritt-Commit, der in einen eigenen Merge-Commit mündet; die Verzweigung bleibt als Struktur sichtbar. Ohne `--no-ff` wäre ein Zusammenführen als sogenannter *Fast-Forward* möglich, weil der Hauptzweig seit der Verzweigung nicht verändert wurde: Git würde die Zeiger einfach nach vorn setzen, die Geschichte wäre linear, und der Merge-Commit entfiele. Dann sähe man später nicht mehr, dass diese Änderung über einen eigenen Zweig kam. Probieren Sie beides in einem Testverzeichnis aus.

**Lösung zu Aufgabe 7.** Eine mögliche Ergänzung:

```text
frisch = sum(1 for a in alter if a <= 90)
print(f"In den letzten 90 Tagen geprüft: {frisch} von {len(dok)} ({round(100 * frisch / len(dok))} Prozent)")
aelteste = sorted(zip(alter, (d['titel'] for d in dok)), reverse=True)[:3]
for tage, titel in aelteste:
    print(f"Ältestes: {titel} ({tage} Tage)")
```

Die Liste `alter` wurde im Skript bereits berechnet. Mit `zip` werden Alter und Titel gepaart, absteigend sortiert, und die ersten drei ausgegeben. Beachten Sie, dass `zip` die Reihenfolge der Dokumente benötigt, die zur Liste der Alter passt; deshalb nutzt das Beispiel dieselbe Liste `dok`.

**Lösung zu Aufgabe 8.** Ausgangslage: Word-Dateien ohne Versionsführung, parallele Kopien. Umstieg: (1) Zielbild definieren: Eine maßgebliche Ablage, Änderungen über Anträge, Freigabe nachweisbar. (2) Format prüfen: Wo möglich auf Textformate (Markdown) umstellen, andere Dokumente zunächst in einem Dokumentenmanagementsystem mit Versionsführung, Check-in und Check-out ablegen, weil Word-Dateien in Git nicht vergleichbar sind. (3) Zugang für Nicht-Entwickler: Weboberfläche der Plattform oder ein Wiki mit Seitenhistorie, damit niemand Kommandozeile oder Git-Begriffe braucht. (4) Review und Freigabe: Status und Genehmigung in der Plattform, die gültige Fassung mit Banner gekennzeichnet. (5) Einführung: Pilot mit einem Team, Schulung (eine Stunde, praktisch), Kurzanleitung, Ansprechpartner. (6) Alte Ablage schreibgeschützt, später archiviert. (7) Erfolgskriterium: nach drei Monaten kein neuer Streit um die gültige Fassung, kein Dokument ohne Versionsangabe. Entscheidend ist der Weg des geringsten Widerstands: Wenn das neue System mühsamer ist als das alte, kehren die Leute zurück.
