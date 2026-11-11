# Modul 06 - Prozess-, Arbeits- und Verfahrensdokumentation

> **Hinweis zu diesem Kapitel:** Das ist das Kapitel des Skripts „Technische Dokumentation und Dokumentations-Governance“, aus der LaTeX-Quelle in Markdown umgewandelt (Text und Listings unverändert, farbige Boxen als Zitatblöcke mit fettem Titel, Tabellen als Markdown-Tabellen, Übungsaufgaben und Lösungen als Absätze). Die Lerneinheiten sind wie in der Quelle nach Modul nummeriert (6.1 bis 6.14), danach folgen „Übungsaufgaben“ (8 Aufgaben) und „Lösungen und Erläuterungen“. Die Sprachangabe der Codeblöcke ist in der Quelle nur für Python und Bash gesetzt; die übrigen Blöcke sind hier nach ihrem Inhalt als `python`, `yaml`, `markdown`, `bash` oder `text` ausgezeichnet, der Inhalt selbst ist unverändert. **Prüfstand der Beispiele für dieses Repository:** Die Python-Beispiele wurden auf Syntax geprüft; welche Beispiele ausgeführt wurden und welche zusätzlich PyYAML brauchen, steht in der [README des Repositories](../README.md). Übersicht zum Modul: [README](README.md).

**Dauer:** 14,5 Stunden | **Priorität:** 1 | **Lerneinheiten:** 14

| **Nr.** | **Lerneinheit**                 | **Dauer (h)** | **Prio** |
|--------:|:--------------------------------|--------------:|---------:|
|       1 | Prozessdokumentation            |             1 |        1 |
|       2 | SOPs                            |             1 |        1 |
|       3 | Arbeitsanweisungen              |             1 |        1 |
|       4 | Rollen und Verantwortlichkeiten |             1 |        1 |
|       5 | Eskalationswege                 |             1 |        1 |
|       6 | Prüf- und Freigabeprozesse      |             1 |        2 |
|       7 | Prozesslandkarten               |             1 |        2 |
|       8 | Prozess-Troubleshooting         |             1 |        2 |
|       9 | Document Owner                  |          1,25 |        1 |
|      10 | Author Rolle                    |          1,25 |        1 |
|      11 | Reviewer Rolle                  |             1 |        1 |
|      12 | Approver Rolle                  |             1 |        1 |
|      13 | RACI Matrix                     |             1 |        1 |
|      14 | Vertretungsregelung             |             1 |        2 |
|         | **Summe**                       |      **14,5** |          |

## 6.1 Prozessdokumentation

Ein Prozess ist eine Folge zusammenhängender Tätigkeiten, die aus einem Auslöser ein definiertes Ergebnis erzeugt, etwa die Bearbeitung einer Störung, die Freigabe einer Änderung oder die Anlage eines Benutzerkontos. Prozessdokumentation hält fest, wie diese Tätigkeiten ablaufen, wer sie ausführt und woran man ihren Erfolg erkennt. Sie unterscheidet sich von Systemdokumentation (Modul 05), die ein technisches Objekt beschreibt, dadurch, dass sie *Abläufe und Zuständigkeiten* beschreibt. Beide ergänzen sich: Ein Runbook beschreibt einen technischen Ablauf an einem System, die Prozessdokumentation beschreibt, wie dieser Ablauf in die Organisation eingebettet ist.

Eine vollständige Prozessbeschreibung beantwortet sieben Fragen. Was *löst* den Prozess aus (Trigger)? Was geht hinein (Eingaben), was kommt heraus (Ergebnis)? Welche *Schritte* führen dorthin? Wer *führt* jeden Schritt aus, wer verantwortet den Prozess insgesamt? Welche *Regeln und Vorgaben* gelten (Fristen, Genehmigungen, Compliance)? Welche *Hilfsmittel* (Systeme, Vorlagen) werden eingesetzt? Und woran *misst* man, ob der Prozess funktioniert (Kennzahlen)? Fehlt eine dieser Antworten, bleibt der Prozess in der Praxis unklar. Fehlt etwa der Trigger, weiß niemand, wann er überhaupt beginnt.

Eine gute Gewohnheit ist der *Prozesssteckbrief*, eine Kopfseite, die diese Antworten in strukturierter Form festhält, bevor die Schritte beschrieben werden. Das folgende Beispiel zeigt einen Steckbrief als YAML-Datei und ein Skript, das ihn auf Vollständigkeit prüft und als Markdown ausgibt. Die Daten sind frei erfunden.

```yaml
prozess: Benutzerkonto anlegen
id: PRO-012
owner: Leitung IT-Service
trigger: Genehmigter Antrag im Ticketsystem
eingaben: [Antragsformular, Genehmigung der Führungskraft]
ergebnis: Konto angelegt, Zugangsdaten sicher übermittelt
schritte:
  - Antrag auf Vollständigkeit prüfen
  - Konto im Verzeichnisdienst anlegen
  - Berechtigungen nach Rollenprofil vergeben
  - Zugangsdaten über getrennten Kanal übermitteln
  - Ticket schließen
rollen: [Service Desk, Administrator]
kennzahl: Durchlaufzeit höchstens 1 Arbeitstag
```

```python
import sys, yaml

PFLICHT = ["prozess", "id", "owner", "trigger", "eingaben", "ergebnis",
           "schritte", "rollen", "kennzahl"]

d = yaml.safe_load(open(sys.argv[1], encoding="utf-8"))
fehlt = [p for p in PFLICHT if not d.get(p)]
if fehlt:
    print("Unvollständig, es fehlt:", ", ".join(fehlt))
    sys.exit(1)

print(f"# {d['prozess']} ({d['id']})\n")
print(f"**Auslöser:** {d['trigger']}  \n**Ergebnis:** {d['ergebnis']}\n")
for nr, schritt in enumerate(d["schritte"], 1):
    print(f"{nr}. {schritt}")
print(f"\n**Prozessowner:** {d['owner']}  \n**Kennzahl:** {d['kennzahl']}")
```

Die Datei legt jede der sieben Antworten in einem eigenen Feld ab. Das Skript prüft, ob alle Pflichtfelder belegt sind, und gibt andernfalls eine Fehlermeldung aus. Sind sie vollständig, erzeugt es eine lesbare Seite mit Auslöser, Ergebnis, nummerierten Schritten, Owner und Kennzahl. Der Nutzen liegt in der Zwangsreihenfolge: Man kann den Steckbrief nicht ausfüllen, ohne den Prozess verstanden zu haben.

Typische Fehler: Prozesse werden nach dem Wunsch beschrieben, nicht nach der Praxis (Soll statt Ist), Ausnahmen und Fehlerfälle fehlen, und der Detailgrad ist unausgewogen: Triviales wird ausführlich beschrieben, die kritischen Entscheidungspunkte bleiben vage. Auch beliebt sind Prozessbeschreibungen, die keine Verantwortlichen nennen und deshalb nicht durchgesetzt werden können.

| **Falsch**                                                         | **Richtig**                                                                                            |
|:-------------------------------------------------------------------|:-------------------------------------------------------------------------------------------------------|
| „Wenn ein neuer Mitarbeiter anfängt, wird ihm ein Konto angelegt.“ | Steckbrief mit Auslöser (genehmigter Antrag), Eingaben, fünf Schritten, Rollen, Ergebnis und Kennzahl. |

Im Projekt beginnt gute Prozessdokumentation mit der Beobachtung des tatsächlichen Ablaufs: Man spricht mit denen, die den Prozess leben, und vergleicht das Ergebnis mit der offiziellen Beschreibung. Die Differenz ist der erste Verbesserungsansatz.

## 6.2 SOPs

SOP steht für *Standard Operating Procedure*, auf Deutsch Standardarbeitsanweisung oder Verfahrensanweisung. Eine SOP beschreibt verbindlich, wie eine wiederkehrende Tätigkeit *immer* auszuführen ist, damit das Ergebnis unabhängig vom Ausführenden gleichbleibend und nachprüfbar ist. Der Begriff stammt aus Industrie, Pharma und Medizin, wo gleichbleibende Qualität und Nachweisbarkeit Pflicht sind, und wird in der IT für kritische oder regulierte Tätigkeiten verwendet: Benutzerverwaltung, Datensicherung, Änderungen an Produktivsystemen, Behandlung von Sicherheitsvorfällen.

Vom Runbook unterscheidet sich die SOP durch ihre *Verbindlichkeit* und ihre *Dokumentenlenkung*. Ein Runbook hilft, die SOP schreibt vor. Daraus folgen formale Bestandteile, die ein einfaches Runbook nicht benötigt: eine eindeutige Kennung, Versionsnummer, Gültigkeitsdatum, Geltungsbereich, Verantwortlichkeiten, Verweise auf mitgeltende Unterlagen (Richtlinien, Formulare) und eine Änderungshistorie. Die Inhalte sind im Kern: Zweck, Geltungsbereich, Definitionen, Verantwortlichkeiten, Verfahren (die Schritte), Aufzeichnungen (welche Nachweise sind zu erstellen und aufzubewahren) und mitgeltende Unterlagen.

Wegen der Nachweisfunktion gehört zur SOP ein klarer Begriff von *Aufzeichnungen*: Wer die SOP befolgt, hinterlässt Spuren (Ticket, Protokoll, Unterschrift), die belegen, dass sie befolgt wurde. Das folgende Beispiel zeigt eine SOP im Markdown-Format mit Dokumentenkopf und ein Skript, das die Pflichtbestandteile prüft.

```markdown
# SOP-007 Datensicherung prüfen

| Feld            | Wert                       |
|-----------------|----------------------------|
| Version         | 2.1                        |
| Gültig ab       | 2026-10-01                 |
| Owner           | Leitung Betrieb            |
| Freigabe        | Leitung IT, 2026-09-28     |

## 1 Zweck
Sicherstellen, dass Datensicherungen vollständig und lesbar sind.

## 2 Geltungsbereich
Alle produktiven Datenbanken.

## 3 Verantwortlichkeiten
Administrator führt aus, Leitung Betrieb prüft das Protokoll.

## 4 Verfahren
1. Öffnen Sie die Sicherungsübersicht und prüfen Sie den Status.
2. Stellen Sie eine Stichprobe in der Testumgebung wieder her.
3. Tragen Sie das Ergebnis im Prüfprotokoll ein.

## 5 Aufzeichnungen
Prüfprotokoll, Aufbewahrung 3 Jahre.

## 6 Mitgeltende Unterlagen
Richtlinie Datensicherung, Formular Prüfprotokoll
```

```python
import re, sys

ABSCHNITTE = ["Zweck", "Geltungsbereich", "Verantwortlichkeiten", "Verfahren",
              "Aufzeichnungen", "Mitgeltende Unterlagen"]
KOPF = ["Version", "Gültig ab", "Owner", "Freigabe"]

text = open(sys.argv[1], encoding="utf-8").read()
titel = [t.strip() for t in re.findall(r"^## (?:\d+ )?(.+)$", text, re.M)]
fehler = [f"Abschnitt fehlt: {a}" for a in ABSCHNITTE if a not in titel]
for feld in KOPF:
    if not re.search(rf"^\|\s*{feld}\s*\|\s*\S+", text, re.M):
        fehler.append(f"Kopfzeile fehlt: {feld}")
if not re.match(r"# SOP-\d{3} ", text):
    fehler.append("Titel muss mit SOP-Nummer beginnen")
print("\n".join(fehler) or "SOP vollständig")
sys.exit(1 if fehler else 0)
```

Der Kopf der SOP enthält die Angaben der Dokumentenlenkung (Version, Gültigkeit, Owner, Freigabe), die darunter folgenden sechs Abschnitte entsprechen den Pflichtinhalten. Besonders wichtig ist Abschnitt 5, der festlegt, welche Aufzeichnungen entstehen und wie lange sie aufbewahrt werden (die Frist ist ein Beispielwert). Das Skript prüft, ob Titelkennung, Kopfzeilen und Abschnitte vorhanden sind. Es bewertet nicht, ob die Inhalte gut sind, aber es verhindert, dass eine SOP ohne Freigabevermerk oder Aufzeichnungspflicht in Umlauf kommt.

Typische Fehler: SOPs werden zu allgemein formuliert, sodass sie keine Verbindlichkeit schaffen, oder zu detailliert, sodass sie bei jeder Änderung des Systems veralten. Es gibt keine Kontrolle, ob sie befolgt werden, und niemand überprüft die Aufzeichnungen. Außerdem gibt es ungültige Altversionen im Umlauf, weil Dokumentenlenkung fehlt.

| **Falsch**                                                                                       | **Richtig**                                                                                                                 |
|:-------------------------------------------------------------------------------------------------|:----------------------------------------------------------------------------------------------------------------------------|
| SOP als Textdatei ohne Version, Freigabe und Aufzeichnungspflicht, in drei Ordnern gleichzeitig. | SOP mit Kopf (Version 2.1, gültig ab, Owner, Freigabe), einer einzigen maßgeblichen Ablage und festgelegten Aufzeichnungen. |

Im Projekt lohnt die Frage: „Müssen wir nachweisen können, dass wir das so gemacht haben?“ Wenn ja, ist eine SOP die richtige Form; wenn es nur um Hilfe bei der Aufgabe geht, genügt ein Runbook.

## 6.3 Arbeitsanweisungen

Eine Arbeitsanweisung beschreibt, wie eine *einzelne Tätigkeit* an einem konkreten Arbeitsplatz oder System auszuführen ist. Sie liegt eine Ebene unter SOP und Prozess: Der Prozess sagt, welche Tätigkeiten es gibt und wer sie in welcher Reihenfolge ausführt, die SOP schreibt das Verfahren verbindlich vor, die Arbeitsanweisung erklärt die Handgriffe. Man kann das als Dokumentenpyramide darstellen: Oben stehen Richtlinien (was gilt?), darunter Prozesse und SOPs (wie läuft es ab?), darunter Arbeitsanweisungen, Checklisten und Formulare (wie mache ich es konkret?).

Die Abgrenzung verschwimmt in der Praxis. Eine pragmatische Unterscheidung: Eine Arbeitsanweisung ist *kürzer* und *näher am Werkzeug*. Sie erklärt, welche Schaltflächen zu klicken und welche Befehle einzugeben sind, während die SOP vorschreibt, *was* zu tun ist und *welche Nachweise* entstehen. Entsprechend sind Arbeitsanweisungen häufiger von Änderungen betroffen, etwa wenn ein Werkzeug aktualisiert wird, und dürfen leichter geändert werden, ohne den formalen Freigabeweg der SOP zu durchlaufen. Dazu braucht man klare Regeln, welche Änderungen an Arbeitsanweisungen vereinfacht freigegeben werden können (zum Beispiel Korrekturen von Bezeichnungen) und welche nicht (Änderung des Ergebnisses).

Die Sprache folgt den Regeln aus Modul 04: eine Handlung pro Schritt, Imperativ, erwartetes Ergebnis. Zusätzlich sind *Checklisten* ein wertvolles Hilfsmittel für Arbeitsanweisungen mit vielen Prüfpunkten. Das folgende Beispiel erzeugt aus einer strukturierten Beschreibung eine abhakbare Checkliste, wie sie im Alltag verwendet werden kann (etwa als Ticketvorlage).

```yaml
titel: Neuen Laptop übergeben
schritte:
  - text: Gerät mit Inventarnummer im Inventar erfassen
    nachweis: Inventarnummer im Ticket
  - text: Festplattenverschlüsselung prüfen
    nachweis: Screenshot der Statusanzeige
  - text: Zugangsdaten über getrennten Kanal übermitteln
    nachweis: Vermerk im Ticket
  - text: Übergabe von der Nutzerin quittieren lassen
    nachweis: Unterschrift
```

```python
import sys, yaml

d = yaml.safe_load(open(sys.argv[1], encoding="utf-8"))
print(f"## Checkliste: {d['titel']}\n")
for s in d["schritte"]:
    print(f"- [ ] {s['text']} (Nachweis: {s['nachweis']})")
```

Die strukturierte Beschreibung verbindet jeden Schritt mit einem *Nachweis*, also dem, was bei Prüfung vorzulegen wäre. Das Skript erzeugt daraus eine Markdown-Checkliste mit Kästchen, die man in Ticketsystemen und Wikis direkt abhaken kann. Der Vorteil dieser Zweiteilung ist, dass sich Daten und Darstellung trennen lassen: Dieselbe Quelle kann später als Tabelle, als Formular oder als Auditnachweis ausgegeben werden.

Typische Fehler: Arbeitsanweisungen duplizieren Inhalte aus SOPs (und weichen ab), sie sind so lang, dass sie niemand liest, oder so kurz, dass sie ohne Vorwissen unbrauchbar sind. Außerdem fehlt häufig der Hinweis, welche übergeordnete SOP oder Richtlinie sie umsetzt, sodass die Verbindung zur Verbindlichkeit unsichtbar bleibt.

| **Falsch**                                                                                   | **Richtig**                                                                                                             |
|:---------------------------------------------------------------------------------------------|:------------------------------------------------------------------------------------------------------------------------|
| Arbeitsanweisung, die den Prozess erklärt, Rollen beschreibt und Richtlinienauszüge enthält. | Arbeitsanweisung, die nur die Handgriffe beschreibt und mit „Umsetzung von SOP-012“ auf die übergeordnete SOP verweist. |

Im Projekt ist die einfachste Faustregel: Alles, was sich mit dem Werkzeug ändert, gehört in die Arbeitsanweisung; alles, was sich mit den Anforderungen ändert, gehört in die SOP.

## 6.4 Rollen und Verantwortlichkeiten

In Modul 01 wurden die Grundrollen der Dokumentations-Governance vorgestellt. Dieser Abschnitt betrachtet Rollen im Kontext von *Prozessen*: Wer ist wofür zuständig, wenn ein Prozess läuft? Er bildet zugleich die Brücke zu den folgenden Abschnitten, die einzelne Rollen (Document Owner, Author, Reviewer, Approver), das RACI-Modell und Vertretungen im Detail behandeln.

Man unterscheidet *Prozessrollen* und *Dokumentationsrollen*. Zu den Prozessrollen zählen der *Prozessowner* (verantwortet Ziel, Gestaltung und Leistung des Prozesses), der *Prozessmanager* (steuert den laufenden Betrieb), die *Prozessbeteiligten* (führen Schritte aus) und die *Kunden und Lieferanten* des Prozesses (Empfänger und Zulieferer seiner Ergebnisse). Dokumentationsrollen sind Owner, Autor, Reviewer und Approver für die Dokumente, die den Prozess beschreiben. Beide Rollengruppen treffen sich: Der Prozessowner ist meist auch Document Owner der Prozessbeschreibung, weil er für Inhalt und Aktualität verantwortlich ist.

Entscheidend für funktionierende Verantwortlichkeit ist die Trennung dreier Dinge: *Verantwortung* (wer muss das Ergebnis vertreten?), *Durchführung* (wer tut es?) und *Befugnis* (wer darf entscheiden?). Gerät eines davon aus dem Gleichgewicht, entstehen typische Probleme: Verantwortung ohne Befugnis macht Owner ohnmächtig, Durchführung ohne Verantwortung führt zu Beliebigkeit. Das folgende Beispiel hält Rollen einer Organisation in einer Rollenübersicht fest und prüft sie auf Lücken: Jede Rolle braucht eine benannte Person oder ein Team und eine Vertretung.

```text
rolle;inhaber;vertretung
Prozessowner Benutzerverwaltung;Leitung IT-Service;Leitung Betrieb
Document Owner SOP-007;Leitung Betrieb;
Approver Richtlinien;CISO;Leitung IT
Reviewer Technik;Team Plattform;Team Betrieb
```

```python
import csv, sys

problem = 0
for z in csv.DictReader(open(sys.argv[1], encoding="utf-8"), delimiter=";"):
    if not z["inhaber"]:
        print("Kein Inhaber:", z["rolle"]); problem += 1
    if not z["vertretung"]:
        print("Keine Vertretung:", z["rolle"]); problem += 1
    if z["inhaber"] and z["inhaber"] == z["vertretung"]:
        print("Inhaber und Vertretung identisch:", z["rolle"]); problem += 1
print(problem, "Auffälligkeit(en)")
```

Die Übersicht ordnet jeder Rolle einen Inhaber und eine Vertretung zu. Das Skript meldet Rollen ohne Inhaber, ohne Vertretung oder mit identischem Inhaber und Vertreter. Im Beispiel wird die Rolle „Document Owner SOP-007“ ohne Vertretung gemeldet. Solche Funde sind keine Schuldzuweisungen, sondern Stellen, an denen die Organisation bei einem Ausfall blockiert wäre.

Typische Fehler: Rollen werden nach Personen statt nach Funktionen benannt („Herr Maier“ statt „Leitung Betrieb“), Rollenübersichten werden einmal erstellt und nie gepflegt, oder Rollen existieren auf Papier, aber die Inhaber wissen nichts davon. Auch problematisch sind Rollenhäufungen: Wer Owner, Autor, Reviewer und Approver in einer Person ist, hat kein Vier-Augen-Prinzip.

| **Falsch**                                | **Richtig**                                                                              |
|:------------------------------------------|:-----------------------------------------------------------------------------------------|
| „Für Dokumentation ist die IT zuständig.“ | „Document Owner: Leitung Betrieb (Vertretung: Leitung Plattform). Approver: Leitung IT.“ |

Im Projekt trägt eine Rollenübersicht, die von den Rolleninhabern bestätigt wurde, mehr als jede Richtlinie: Wer seine Rolle kennt und akzeptiert hat, nimmt sie wahr.

## 6.5 Eskalationswege

Eskalation bedeutet, ein Problem an eine höhere Stufe zu geben, wenn die aktuelle Stufe es nicht lösen kann oder die Zeit knapp wird. Eskalationswege legen vorab fest, *wann*, *an wen* und *wie* das geschieht. Wo sie fehlen, beginnen Menschen im Ernstfall zu improvisieren: Man ruft jemanden an, der gerade erreichbar ist, nicht jemanden, der zuständig ist, und verliert wertvolle Zeit.

Man unterscheidet zwei Arten. Bei der *funktionalen Eskalation* geht die Aufgabe an jemanden mit mehr Fachwissen, etwa von der ersten zur zweiten Supportstufe oder zu einem Spezialisten. Bei der *hierarchischen Eskalation* geht sie an eine Führungskraft, meist wegen Dringlichkeit, wegen wirtschaftlicher Tragweite oder weil Entscheidungen fällig werden, die über die Befugnisse der Bearbeiter hinausgehen. Eskaliert wird manuell, wenn jemand nicht weiterkommt, oder automatisch, wenn eine Regel greift, zum Beispiel ein Ticket zu lange offen ist oder eine vereinbarte Frist (SLA) zu verletzen droht.

> **Ergänzung aus der Nachrecherche**
>
> Eskalation: Laut dem abgerufenen Glossareintrag eines Anbieters von Support-Software ist Eskalation die Übergabe eines Tickets an eine höhere Stufe, einen Spezialisten oder eine Führungskraft, wenn der aktuelle Bearbeiter es nicht lösen kann oder ein SLA-Verstoß droht. Die Seite unterscheidet funktionale und hierarchische Eskalation und betont, dass eskaliert werden soll, bevor ein Kunde frustriert ist oder ein SLA gerissen wird. Die Eskalationsrate gilt als Signal: Eine hohe Rate kann auf fehlende Werkzeuge, Schulung oder Selbsthilfe in der ersten Stufe hindeuten. Die Quelle ist ein Herstellerglossar, keine Norm. (Abruf 28.10.2026, siehe Quellenverzeichnis.)

Ein dokumentierter Eskalationsweg enthält für jede Stufe vier Angaben: die *Auslöser* (nach welcher Zeit oder bei welchem Schweregrad wird eskaliert?), die *Adressaten* (wer ist Stufe 2, Stufe 3?), die *Erreichbarkeit* (wie, rund um die Uhr oder zu Geschäftszeiten?) und die *mitzugebenden Informationen* (was muss in der Eskalation stehen, damit der Empfänger sofort arbeiten kann?). Das folgende Beispiel zeigt eine Eskalationstabelle und ein Skript, das zu einem Schweregrad und einer verstrichenen Zeit bestimmt, welche Stufe zuständig ist.

```text
schweregrad;stufe1_min;stufe2_min;stufe3_min
kritisch;0;15;30
hoch;0;30;120
normal;0;240;1440
```

```python
import csv, sys

regeln = {z["schweregrad"]: z for z in csv.DictReader(open("eskalation.csv"), delimiter=";")}
schwere, minuten = sys.argv[1], int(sys.argv[2])

z = regeln[schwere]
stufe = 1
if minuten >= int(z["stufe2_min"]):
    stufe = 2
if minuten >= int(z["stufe3_min"]):
    stufe = 3
print(f"Schweregrad {schwere}, {minuten} min offen -> Stufe {stufe} zuständig")
```

Die Tabelle legt je Schweregrad die Minuten fest, nach denen die nächste Stufe einbezogen wird. Die Werte sind Beispielwerte; echte Werte folgen aus den vereinbarten Servicezeiten. Das Skript liest sie ein und bestimmt für einen Aufruf, zum Beispiel `kritisch 20`, die zuständige Stufe, hier Stufe 2. Das ist die Logik, die Ticketsysteme für automatische Eskalation nutzen, und sie ist als Dokumentation sofort überprüfbar.

Typische Fehler: Eskalationswege nennen Personen statt Rollen und veralten bei jedem Wechsel; sie fehlen für Nacht und Wochenende; und die Hemmschwelle ist hoch, weil Eskalation als Schwäche gilt. Eine gute Dokumentation sagt deshalb ausdrücklich: Eskalieren ist erwünscht, wenn die Kriterien erfüllt sind. Bei hohen Eskalationsraten ist die Ursache zu untersuchen, nicht die Rate zu senken.

| **Falsch**                        | **Richtig**                                                                                                                                                                                                 |
|:----------------------------------|:------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| „Bei Problemen den Chef anrufen.“ | „Kritisch: nach 15 Minuten ohne Lösung Eskalation an Stufe 2 (Bereitschaft Plattform, Rufnummer im Anhang), nach 30 Minuten an die Leitung Betrieb. Mitzugeben: Ticketnummer, Symptom, bisherige Schritte.“ |

Im Projekt lohnt sich ein Eskalationsprobelauf: Wer einmal in Ruhe getestet hat, ob die Nummer stimmt und die Person erreichbar ist, spart im Ernstfall die kostbarsten Minuten.

## 6.6 Prüf- und Freigabeprozesse

Ein Dokument wird verbindlich, wenn es geprüft und freigegeben wurde. Der Prüf- und Freigabeprozess legt fest, welche Schritte ein Dokument durchlaufen muss, bevor es gilt, und wer jeweils entscheidet. Hier geht es um den *Prozess*; die technische Umsetzung mit Versionierung, Git-Workflows und Qualitätssicherung folgt in Modul 10.

Der Grundablauf besteht aus fünf Schritten. Der *Autor* stellt das Dokument fertig und reicht es zur Prüfung ein. Der *Reviewer* prüft Inhalt und Form anhand einer Checkliste und gibt Rückmeldung. Der Autor arbeitet Rückmeldungen ein, bis der Reviewer zustimmt. Der *Approver* entscheidet formal über die Freigabe, in der Regel nach Sichtung des Review-Ergebnisses. Mit der Freigabe erhält das Dokument seinen Status und seine Gültigkeit; zugleich werden Nachweise festgehalten (wer, wann, welche Version). Der Ablauf kann je nach Risiko gestuft sein: Für unkritische Dokumente genügt ein einfaches Review, für kritische (SOPs, Sicherheitsrichtlinien) sind mehrere Reviews und eine formale Freigabe nötig.

Eine zentrale Regel dieses Prozesses ist das *Vier-Augen-Prinzip*: Niemand gibt sein eigenes Dokument frei. Praktisch heißt das, dass Autor, Reviewer und Approver verschiedene Personen sind, zumindest dass der Approver nicht zugleich Autor ist. Das nachstehende Beispiel zeigt einen Freigabevorgang als strukturierten Eintrag und ein Skript, das die Regeln durchsetzt: Die Reihenfolge der Status ist einzuhalten, Autor und Freigeber müssen verschieden sein, und Freigaben sind nur durch berechtigte Personen möglich.

```yaml
dokument: SOP-007
version: 2.1
autor: Anna Berger
reviewer: Bernd Huber
approver: Cora Maier
status_verlauf:
  - {status: entwurf, datum: 2026-09-10}
  - {status: in_pruefung, datum: 2026-09-15}
  - {status: freigegeben, datum: 2026-09-28}
```

```python
import sys, yaml

REIHENFOLGE = ["entwurf", "in_pruefung", "freigegeben"]
FREIGEBER = {"Cora Maier", "Dieter Koch"}      # Beispiel einer Berechtigtenliste

d = yaml.safe_load(open(sys.argv[1], encoding="utf-8"))
fehler = []
status = [s["status"] for s in d["status_verlauf"]]
if status != REIHENFOLGE[:len(status)]:
    fehler.append(f"Ungültige Statusfolge: {status}")
if d["approver"] == d["autor"]:
    fehler.append("Autor darf nicht selbst freigeben")
if d["reviewer"] == d["autor"]:
    fehler.append("Reviewer darf nicht der Autor sein")
if status[-1] == "freigegeben" and d["approver"] not in FREIGEBER:
    fehler.append(f"{d['approver']} ist nicht freigabeberechtigt")
print("\n".join(fehler) or "Freigabevorgang regelkonform")
sys.exit(1 if fehler else 0)
```

Der Eintrag dokumentiert alle Beteiligten und den zeitlichen Verlauf der Status. Das Skript prüft vier Regeln: die Reihenfolge der Status, die Trennung von Autor und Freigeber, die Trennung von Autor und Reviewer und die Freigabeberechtigung anhand einer Liste. Der Ausdruck `REIHENFOLGE[:len(status)]` schneidet die Soll-Reihenfolge auf die bisherige Länge, sodass auch unvollständige Verläufe (etwa ein Entwurf in Prüfung) korrekt bewertet werden. Auch hier gilt: Die Technik ist nur das Mittel, die Regel entsteht im Prozess.

Typische Fehler: Der Freigabeprozess ist für alle Dokumente gleich schwer, sodass Bagatellen genauso lange dauern wie Sicherheitsrichtlinien und die Beteiligten Wege drumherum suchen. Reviews werden zu Formalitäten („sieht gut aus“). Und Freigaben werden nicht nachweisbar festgehalten, sodass im Audit niemand belegen kann, wer wann zugestimmt hat.

| **Falsch**                                         | **Richtig**                                                                                       |
|:---------------------------------------------------|:--------------------------------------------------------------------------------------------------|
| Freigabe per Zuruf: „Passt schon, nimm die Datei.“ | Freigabevermerk mit Version, Freigeber und Datum im Dokumentenkopf und in der Versionsverwaltung. |

Im Projekt zahlt sich ein gestufter Prozess aus: Wenige, wirklich kritische Dokumente werden streng geführt, der Rest einfach. So bleibt der Prozess akzeptiert.

## 6.7 Prozesslandkarten

Eine Prozesslandkarte gibt einen Überblick über alle Prozesse einer Organisation oder eines Bereichs und ihre Zusammenhänge. Sie zeigt nicht die einzelnen Schritte (das tun die Prozessbeschreibungen), sondern *welche Prozesse es gibt, wie sie zusammenhängen und zu welcher Gruppe sie gehören*. Damit ist sie das Inhaltsverzeichnis der Prozessdokumentation und ein wichtiges Mittel, Lücken und Doppelungen zu erkennen.

Üblich ist die Gliederung in drei Gruppen. *Führungs- oder Managementprozesse* steuern die Organisation (Strategie, Planung, Steuerung). *Kernprozesse* erzeugen den unmittelbaren Nutzen für Kunden (im IT-Service etwa Störungsbehandlung, Anfragenerfüllung, Änderungen). *Unterstützungsprozesse* schaffen die Voraussetzungen (Beschaffung, Personal, Dokumentenlenkung). Die Karte wird meist von links nach rechts oder von oben nach unten gezeichnet: Kundenanforderung in, Kundennutzen aus. Mit jedem Prozess sind Owner und Dokumentverweis verbunden.

Die Detailtiefe richtet sich nach dem Zweck. Auf der obersten Ebene stehen zehn bis zwanzig Prozesse, die man auf einer Seite überblickt. Jeder lässt sich in Teilprozesse zerlegen, die auf eigenen Seiten stehen. Für die Darstellung von Abläufen auf Schritt-Ebene wird häufig die Notation BPMN verwendet; sie wird in Modul 09 behandelt. Das folgende Beispiel erzeugt aus einer Prozessliste automatisch ein Diagramm in Mermaid-Syntax. Dadurch bleibt die Landkarte immer konsistent mit der Prozessliste.

```yaml
prozesse:
  - {id: P1, name: Störungsmanagement, gruppe: kern}
  - {id: P2, name: Änderungsmanagement, gruppe: kern}
  - {id: P3, name: Dokumentenlenkung, gruppe: unterstuetzung}
  - {id: P4, name: Strategie und Planung, gruppe: fuehrung}
```

```python
import sys, yaml

d = yaml.safe_load(open(sys.argv[1], encoding="utf-8"))
titel = {"fuehrung": "Führung", "kern": "Kernprozesse",
         "unterstuetzung": "Unterstützung"}
print("flowchart TB")
for gruppe, name in titel.items():
    print(f'  subgraph {gruppe}["{name}"]')
    for p in d["prozesse"]:
        if p["gruppe"] == gruppe:
            print(f'    {p["id"]}["{p["name"]}"]')
    print("  end")
```

Die Prozessliste enthält je Prozess Kennung, Name und Gruppe. Das Skript gibt daraus Mermaid-Code aus, in dem jede Gruppe ein Rahmen (`subgraph`) ist, der ihre Prozesse enthält. Die Ausgabe lässt sich in ein Wiki einfügen oder mit dem Mermaid-Werkzeug als Bild erzeugen. Das Beispiel zeigt auch ein Grundprinzip der Diagrammpflege: Wer das Diagramm aus Daten erzeugt, muss es nicht von Hand nachführen.

Typische Fehler: Die Landkarte ist ein Organigramm in Prozessgewand und bildet Abteilungen statt Prozesse ab. Sie enthält Prozesse, die es nicht gibt, oder lässt tatsächliche Prozesse aus, besonders die unbeliebten (Aufräumen, Archivieren). Und sie ist so detailliert, dass sie nicht mehr auf eine Seite passt.

| **Falsch**                                                                  | **Richtig**                                                                                                               |
|:----------------------------------------------------------------------------|:--------------------------------------------------------------------------------------------------------------------------|
| Karte mit Kästchen für „Abteilung A“, „Abteilung B“ und Pfeilen dazwischen. | Karte mit drei Gruppen, fünfzehn Prozessen, Kennungen, die auf die Prozessbeschreibungen verweisen, und benannten Ownern. |

Im Projekt hilft die Prozesslandkarte, wenn jemand fragt „Gibt es dazu einen Prozess?“: Man schlägt nach, statt zu raten.

## 6.8 Prozess-Troubleshooting

Prozessdokumentation ist wirksam, wenn Menschen nach ihr arbeiten. Dieser Abschnitt zeigt, wie man typische Fehlerbilder anhand von Struktur, Aktualität, Zielgruppenfeedback und Review-Kommentaren eingrenzt und daraus Runbook-Schritte für Redaktion, Fachbereich und Betrieb ableitet.

Die häufigsten Symptome: „Niemand hält sich daran“ deutet auf einen praxisfernen Prozess, fehlende Akzeptanz oder fehlende Kontrolle. „Jeder macht es anders“ deutet auf unklare Schritte, fehlende Schulung oder mehrere widersprüchliche Beschreibungen. „Es dauert zu lange“ deutet auf überflüssige Freigaben oder Wartezeiten, die in der Beschreibung nicht sichtbar sind. „Keiner fühlt sich zuständig“ deutet auf fehlende Rollenzuordnung. „Die Beschreibung stimmt nicht mehr“ deutet auf fehlende Pflege bei Änderungen.

Zur Eingrenzung sind zwei Gegenproben nützlich. Erstens der *Walkthrough*: Man geht den Prozess zusammen mit zwei Beteiligten Schritt für Schritt durch und notiert jede Stelle, an der die Beschreibung von der Wirklichkeit abweicht. Zweitens die *Datenprüfung*: Man misst Durchlaufzeiten und Ausnahmequoten aus Tickets und sieht, wo der Prozess hakt. Das folgende Skript prüft die Prozessdokumentation selbst auf strukturelle Ursachen: Es meldet Prozesse ohne Owner, Prozesse, die Rollen nennen, die in der Rollenübersicht nicht existieren, und Prozesse ohne Prüfdatum in den letzten zwölf Monaten.

```text
id;name;owner;rollen;geprueft
P1;Störungsmanagement;Leitung Betrieb;Service Desk|Bereitschaft;2026-08-01
P2;Änderungsmanagement;;Change Manager;2026-03-01
P3;Dokumentenlenkung;Redaktion;Redakteur;2025-05-01
```

```python
import csv
from datetime import date

BEKANNTE_ROLLEN = {"Service Desk", "Bereitschaft", "Change Manager"}
HEUTE = date(2026, 10, 28)

for z in csv.DictReader(open("prozesse.csv", encoding="utf-8"), delimiter=";"):
    hinweise = []
    if not z["owner"]:
        hinweise.append("kein Owner")
    for r in z["rollen"].split("|"):
        if r not in BEKANNTE_ROLLEN:
            hinweise.append(f"unbekannte Rolle '{r}'")
    if (HEUTE - date.fromisoformat(z["geprueft"])).days > 365:
        hinweise.append("Prüfung älter als 12 Monate")
    print(z["id"], z["name"], "->", "; ".join(hinweise) or "ok")
```

Die Datei listet Prozesse mit Owner, Rollen (durch senkrechte Striche getrennt) und Prüfdatum. Das Skript prüft pro Prozess drei Dinge und gibt eine Zeile aus. Mit den Beispieldaten ist P1 in Ordnung, P2 hat keinen Owner, und P3 hat eine unbekannte Rolle sowie eine zu alte Prüfung. Die Ausgabe ist die Arbeitsliste für die Redaktion. Das Datum ist fest eingetragen, damit das Beispiel reproduzierbar bleibt.

Als Runbook ergibt sich: Auffälligkeiten sammeln, mit dem Prozessowner einen Walkthrough vereinbaren, Abweichungen klassifizieren (Prozess ändern oder Praxis anpassen), Änderung per Prüf- und Freigabeprozess umsetzen, Beteiligte informieren und schulen. Entscheidend ist die Frage, ob die Praxis oder die Beschreibung falsch liegt: Manchmal ist die Praxis klüger als der Prozess.

Typische Fehler: Man ändert die Dokumentation, ohne die Beteiligten einzubeziehen, oder erzwingt den Prozess, ohne zu prüfen, ob er praktikabel ist. Ebenso verbreitet: Abweichungen werden als Verstoß verfolgt, statt als Signal für einen schlechten Prozess ausgewertet.

| **Falsch**                                                                           | **Richtig**                                                                                                                                            |
|:-------------------------------------------------------------------------------------|:-------------------------------------------------------------------------------------------------------------------------------------------------------|
| „Die Mitarbeiter halten sich nicht an den Prozess, wir verschicken eine Erinnerung.“ | „Im Walkthrough zeigt sich, dass Schritt 4 nicht durchführbar ist, weil die Berechtigung fehlt. Wir ändern den Prozess und vergeben die Berechtigung.“ |

Im Projekt gilt: Wer Abweichungen von Prozessen als Daten behandelt, lernt mehr als wer sie bestraft.

## 6.9 Document Owner

Der Document Owner ist die Person, die für ein Dokument verantwortlich ist, und zwar über seinen gesamten Lebenszyklus. Er schreibt es nicht notwendigerweise selbst, aber er sorgt dafür, dass es existiert, seinem Zweck dient, aktuell bleibt und zu gegebener Zeit überarbeitet oder außer Dienst gestellt wird. Ohne Owner wird ein Dokument zur Waise: Niemand fühlt sich zuständig, Fehler bleiben stehen, Veraltetes bleibt gültig.

Die Aufgaben des Owners lassen sich in sechs Gruppen ordnen. Er *legt das Dokument an* oder beauftragt es, sorgt also für Zweck, Zielgruppe und Vorlage. Er *bestimmt Autor, Reviewer und Approver* oder stimmt sie ab. Er *hält es aktuell*: Er reagiert auf Änderungen am System oder Prozess, wird an Prüffristen erinnert und führt die Prüfungen durch oder veranlasst sie. Er *beantwortet Rückfragen und nimmt Verbesserungsvorschläge auf*. Er *entscheidet über Änderungen* im Rahmen seiner Befugnis. Und er *beendet den Lebenszyklus*, indem er die Archivierung veranlasst, wenn das Dokument nicht mehr gebraucht wird.

Wer eignet sich als Owner? Ideal ist eine Person, die das Thema fachlich verantwortet und Änderungen früh mitbekommt: der Service Owner für Systemdokumente, der Prozessowner für Prozessbeschreibungen. Ungeeignet sind Personen ohne Bezug zum Gegenstand oder ohne Zeitbudget. Damit die Rolle nicht an einzelnen Personen hängt, wird sie wo immer möglich an eine Funktion gebunden („Service Owner Webshop“) und hat eine Vertretung (siehe Abschnitt Vertretungsregelung).

Das folgende Beispiel zeigt einen Ownerbericht: Er listet pro Owner seine Dokumente und markiert überfällige Prüfungen. Solche Berichte sind in vielen Organisationen die wirksamste Form der Erinnerung.

```text
titel;owner;naechste_pruefung
Runbook Neustart Shop;Team Betrieb;2026-12-01
Architektur Shop;Team Plattform;2026-06-01
Betriebshandbuch DB;Team Betrieb;2026-09-15
Richtlinie Backup;Leitung IT;2027-03-01
```

```python
import csv
from collections import defaultdict
from datetime import date

HEUTE = date(2026, 10, 28)
je_owner = defaultdict(list)
for z in csv.DictReader(open("dokumente.csv", encoding="utf-8"), delimiter=";"):
    faellig = date.fromisoformat(z["naechste_pruefung"])
    je_owner[z["owner"]].append((z["titel"], faellig, faellig < HEUTE))

for owner, docs in sorted(je_owner.items()):
    ueberfaellig = [d for d in docs if d[2]]
    print(f"{owner}: {len(docs)} Dokument(e), {len(ueberfaellig)} überfällig")
    for titel, faellig, _ in ueberfaellig:
        print(f"   - {titel} (fällig seit {faellig})")
```

Das Skript gruppiert die Dokumente nach Owner mit einem `defaultdict` und markiert jene, deren Prüftermin vor dem Stichtag liegt. Die Ausgabe ist ein Bericht pro Owner: Team Betrieb hat zwei Dokumente, eines davon (Betriebshandbuch DB) überfällig; Team Plattform hat ein überfälliges Dokument. In der Praxis würde man diesen Bericht als E-Mail oder Ticket versenden. Das Muster ist das gleiche wie bei jeder Erinnerung: Wer verantwortet, bekommt eine kurze, konkrete Liste.

Typische Fehler: Der Owner ist eine Abteilung oder ein Verteiler statt einer verantwortlichen Stelle. Er weiß nicht, dass er Owner ist, weil die Rolle automatisch vergeben wurde. Oder er hat die Rolle, aber keine Zeit: Dann ist sie ein Etikett. Ein weiteres Problem sind Owner, die ausscheiden, ohne dass jemand die Dokumente neu zuordnet.

| **Falsch**               | **Richtig**                                                                                                              |
|:-------------------------|:-------------------------------------------------------------------------------------------------------------------------|
| Owner: „alle“ oder „IT“. | Owner: „Service Owner Webshop (Rollenpostfach, Vertretung: Leitung Plattform)“, dem Owner bekannt und von ihm bestätigt. |

Im Projekt ist der Austritt von Mitarbeitenden der kritische Moment: Bei jedem Wechsel sollte automatisch geprüft werden, für welche Dokumente die Person Owner war.

## 6.10 Author Rolle

Der Autor ist die Person, die ein Dokument schreibt oder ändert. Er trägt die Verantwortung für den Inhalt in der Entwurfsphase: Richtigkeit, Vollständigkeit, Verständlichkeit und Einhaltung von Vorlage, Standards und Stilregeln. Ein Autor ist nicht notwendigerweise Technischer Redakteur. In vielen IT-Organisationen sind die Fachleute, die das System betreiben, die besten Autoren, weil nur sie die Details kennen. Die Redaktion unterstützt dann mit Vorlagen, Beratung und Qualitätsprüfung.

Die Aufgaben eines Autors folgen dem Arbeitsablauf. Er klärt vor dem Schreiben Zweck und Zielgruppe. Er nutzt die passende Vorlage und beachtet Standards und Terminologie. Er prüft, was bereits existiert, damit er nicht Doppelungen erzeugt. Er schreibt, und zwar im Sinne der technischen Schreibregeln (Modul 04). Er testet seine Anleitungen, wo es möglich ist. Und er reicht das Dokument mit einer kurzen Änderungsbeschreibung zur Prüfung ein, damit der Reviewer weiß, worauf er achten soll. Das Zusammenspiel mit Versionsverwaltung ist für Autoren zunehmend selbstverständlich: Änderungen entstehen in einem eigenen Arbeitszweig und werden über einen Änderungsantrag (Pull Request oder Merge Request) eingereicht.

Das folgende Beispiel zeigt diesen Arbeitsablauf mit Git, dem verbreiteten Versionsverwaltungswerkzeug. Die Befehle sind vollständig und lassen sich in einem leeren Testverzeichnis ausführen. Das Beispiel dient dem Verständnis der Autorenrolle; Git im Detail behandelt Modul 10.

```bash
git init doku-test && cd doku-test
git config user.name "Anna Berger"
git config user.email "anna@example.org"

printf '# Runbook Neustart\n' > runbook-neustart.md
git add runbook-neustart.md
git commit -m "Runbook Neustart: Entwurf angelegt"

git switch -c aenderung/runbook-neustart-pruefung
printf '3. Prüfen Sie den Status mit systemctl status shop.\n' >> runbook-neustart.md
git commit -am "Runbook Neustart: Prüfschritt ergänzt"

git log --oneline
```

Die ersten Befehle legen ein Repository an und setzen die Autorenangaben. Danach wird eine Datei angelegt und in der Hauptlinie festgehalten (`commit`). Der Befehl `git switch -c` erzeugt einen neuen Arbeitszweig für die Änderung, in dem der Autor arbeitet, ohne die freigegebene Fassung zu verändern. Der letzte `commit` hält die Ergänzung fest, die Meldung beschreibt, was geändert wurde. `git log` zeigt die Historie. Aus diesem Arbeitszweig würde der Autor einen Änderungsantrag stellen, den Reviewer und Approver bearbeiten.

Typische Fehler: Autoren schreiben, ohne die Zielgruppe zu klären, übernehmen Texte aus alten Dokumenten ungeprüft, testen ihre Anleitungen nicht oder reichen Entwürfe ohne Änderungsbeschreibung ein. Häufig kommt es auch zu Zeitdruck: Dokumentation ist die erste Aufgabe, die gestrichen wird. Das lässt sich nur organisatorisch lösen, indem Dokumentation als Teil der Aufgabe eingeplant wird (siehe Modul 02, Abschnitt Betriebsmodell).

| **Falsch**                       | **Richtig**                                                                                                                                          |
|:---------------------------------|:-----------------------------------------------------------------------------------------------------------------------------------------------------|
| Änderungsbeschreibung: „Update“. | Änderungsbeschreibung: „Runbook Neustart: Prüfschritt 3 ergänzt, weil das Ergebnis des Neustarts bisher nicht kontrolliert wurde (Ticket OPS-2201).“ |

Im Projekt bewährt sich ein Autoren-Leitfaden von einer Seite, der Vorlage, Terminologie, Test und Einreichung beschreibt und neuen Kolleginnen und Kollegen den Einstieg erleichtert.

## 6.11 Reviewer Rolle

Der Reviewer prüft ein Dokument, bevor es freigegeben wird. Seine Aufgabe ist es, Fehler zu finden, die dem Autor nicht auffallen, weil dieser seinen eigenen Text zu gut kennt. Ein wirksamer Review ist deshalb kein Korrekturlesen, sondern eine strukturierte Prüfung nach festgelegten Kriterien. Dazu gehört, dass der Reviewer unabhängig vom Autor ist und selbst über genug Fachwissen oder Leseperspektive verfügt, um die Aussagen zu beurteilen.

Man unterscheidet mehrere Review-Arten, die auch von verschiedenen Personen übernommen werden können. Der *fachliche Review* prüft die Richtigkeit des Inhalts (stimmt der Befehl, passt der Parameter?). Der *redaktionelle Review* prüft Sprache, Struktur, Terminologie und Einhaltung des Styleguides. Der *Praxistest-Review* führt die Anleitung tatsächlich aus. Der *Compliance-Review* prüft Vorgaben aus Datenschutz, Informationssicherheit und Normen. Je nach Risiko des Dokuments sind nicht alle Arten nötig; ein Runbook für eine kritische Produktivumgebung verlangt mindestens fachlichen Review und Praxistest.

Gutes Reviewen braucht Struktur. Eine *Review-Checkliste* legt fest, was geprüft wird, und verhindert, dass wichtige Punkte vergessen werden. Das folgende Beispiel zeigt eine solche Checkliste im YAML-Format und ein Skript, das ein Review-Ergebnis mit ihr abgleicht: Jede Frage muss beantwortet sein, offene Mängel verhindern die Freigabe.

```yaml
checkliste:
  - id: F1
    frage: Sind alle Befehle und Parameter fachlich korrekt?
    art: fachlich
  - id: R1
    frage: Hat jeder Schritt genau eine Handlung?
    art: redaktionell
  - id: P1
    frage: Wurde die Anleitung auf dem Testsystem ausgeführt?
    art: praxis
```

```yaml
antworten:
  F1: {ergebnis: ok}
  R1: {ergebnis: mangel, kommentar: Schritt 3 enthält zwei Handlungen}
```

```python
import sys, yaml

frage = yaml.safe_load(open("checkliste.yml", encoding="utf-8"))["checkliste"]
antw = yaml.safe_load(open("review.yml", encoding="utf-8"))["antworten"]

offen = [f["id"] for f in frage if f["id"] not in antw]
maengel = [(i, a.get("kommentar", "")) for i, a in antw.items() if a["ergebnis"] == "mangel"]

for i in offen:
    print("Nicht beantwortet:", i)
for i, k in maengel:
    print("Mangel", i + ":", k)
print("Freigabe möglich" if not offen and not maengel else "Freigabe nicht möglich")
```

Die Checkliste definiert drei Fragen aus drei Review-Arten. Die Antwortdatei enthält das Ergebnis des Reviewers. Das Skript prüft, ob alle Fragen beantwortet sind, und listet Mängel auf. Mit den Beispieldaten ist die Frage P1 nicht beantwortet, und R1 meldet einen Mangel, sodass die Freigabe nicht möglich ist. Das Beispiel zeigt zugleich, wie wichtig ein konstruktiver Kommentar ist: Der Mangel nennt die Stelle (Schritt 3) und das Problem (zwei Handlungen).

Typische Fehler: Der Review ist ein Überfliegen („sieht gut aus“), der Reviewer hat keine Zeit oder keine Kompetenz, oder er bewertet die Person statt den Text. Ein weiterer Fehler ist der Review nur durch Vorgesetzte, die den Inhalt nicht prüfen können. Auch gefährlich: Reviewer und Autor sind befreundet und winken gegenseitig durch.

| **Falsch**                 | **Richtig**                                                                                                                                               |
|:---------------------------|:----------------------------------------------------------------------------------------------------------------------------------------------------------|
| Review-Kommentar: „Passt.“ | Review-Kommentar: „F1 ok (auf Testsystem geprüft). R1 Mangel: Schritt 3 enthält zwei Handlungen, bitte teilen. P1 offen: Praxistest folgt am Donnerstag.“ |

Im Projekt hilft es, das Review-Ergebnis im Dokument oder Änderungsantrag sichtbar zu halten. So kann später nachvollzogen werden, was geprüft wurde.

## 6.12 Approver Rolle

Der Approver gibt ein Dokument formal frei. Er bestätigt damit, dass es seinen Zweck erfüllt, geprüft wurde und in Kraft treten darf. Anders als der Reviewer prüft er nicht jedes Detail, sondern trägt die *Verantwortung für die Gültigkeit*: Er entscheidet auf Grundlage des Review-Ergebnisses, ob die Prüfung ausreichend war und das Dokument mit den Zielen und Vorgaben der Organisation übereinstimmt. Seine Unterschrift hat Gewicht, weil sie im Audit zeigt, dass die Organisation das Dokument gebilligt hat.

Für die Rolle gelten besondere Anforderungen. Der Approver muss die *Befugnis* haben, im Namen der Organisation zu entscheiden, in der Regel durch seine Funktion (Bereichsleitung, Service Owner, Informationssicherheitsbeauftragter). Er muss *unabhängig* vom Autor sein. Und er muss *informiert* entscheiden können, also die Review-Nachweise sehen. Welche Freigabestufe für welches Dokument gilt, wird idealerweise in einer *Freigabematrix* festgelegt: Je höher das Risiko oder die Reichweite, desto höher die Freigabestufe. Eine Betriebsanleitung für ein Testsystem kann der Service Owner freigeben, eine Informationssicherheitsrichtlinie die Geschäftsleitung.

Auch die Freigabe selbst muss nachweisbar sein. Das kann durch Unterschrift, durch eine Freigabe im Dokumentenmanagementsystem oder durch den Merge in einen geschützten Zweig der Versionsverwaltung erfolgen, bei dem nur Berechtigte zustimmen dürfen. Das nachstehende Beispiel zeigt eine Freigabematrix und ein Skript, das prüft, ob der angegebene Freigeber für die Dokumentenart berechtigt ist.

```text
dokumentenart;freigabestufe;berechtigte_rollen
runbook;1;Service Owner|Leitung Betrieb
sop;2;Leitung Betrieb|Leitung IT
richtlinie;3;Leitung IT|Geschäftsleitung
```

```python
import csv, sys

matrix = {z["dokumentenart"]: set(z["berechtigte_rollen"].split("|"))
          for z in csv.DictReader(open("freigabematrix.csv", encoding="utf-8"), delimiter=";")}

art, rolle = sys.argv[1], sys.argv[2]
if art not in matrix:
    print("Unbekannte Dokumentenart:", art); sys.exit(2)
if rolle in matrix[art]:
    print(f"{rolle} darf {art} freigeben")
else:
    print(f"{rolle} darf {art} NICHT freigeben (berechtigt: {', '.join(sorted(matrix[art]))})")
    sys.exit(1)
```

Die Matrix ordnet jeder Dokumentenart eine Stufe und die berechtigten Rollen zu. Das Skript liest sie als Wörterbuch von Mengen und prüft, ob die angegebene Rolle dazugehört. Ruft man es mit `richtlinie "Service Owner"` auf, gibt es eine Ablehnung mit der Liste der Berechtigten aus. Die Rückgabewerte unterscheiden zwischen unbekannter Art (2) und fehlender Berechtigung (1), damit aufrufende Werkzeuge reagieren können. In der Praxis wird diese Logik in Freigabeworkflows von Dokumentenmanagementsystemen umgesetzt, und das Beispiel zeigt, was sie im Kern leistet.

Typische Fehler: Zu viele Freigabestufen, die den Prozess lähmen; Freigeber, die ohne Prüfung unterschreiben; Freigeber, die weder Befugnis noch Überblick haben; und Freigaben, die nicht nachweisbar sind. Besonders problematisch ist die *Gummistempel-Freigabe*: Sie sieht formal korrekt aus, hat aber keine Wirkung, weil der Freigeber nur abzeichnet.

| **Falsch**                                                                             | **Richtig**                                                                                                   |
|:---------------------------------------------------------------------------------------|:--------------------------------------------------------------------------------------------------------------|
| Freigabe durch den Praktikanten, weil der Leiter im Urlaub ist, ohne Vertretungsregel. | Freigabe durch die in der Freigabematrix benannte Stelle, bei Abwesenheit durch die dort benannte Vertretung. |

Im Projekt ist die Freigabematrix eine der wirksamsten Maßnahmen gegen Diskussionen: Sie entscheidet im Voraus, wer wofür freigeben darf.

## 6.13 RACI Matrix

Die RACI-Matrix ist ein einfaches Werkzeug, um Verantwortlichkeiten für Aufgaben, Prozessschritte oder Dokumente übersichtlich festzulegen. Die Buchstaben stehen für vier Rollen, die jede Person in Bezug auf eine Aufgabe haben kann. *R* (Responsible, durchführend) führt die Aufgabe aus. *A* (Accountable, verantwortlich im Sinne von rechenschaftspflichtig) trägt die Gesamtverantwortung und gibt das Ergebnis frei. *C* (Consulted, konsultiert) wird vor einer Entscheidung um Rat gefragt. *I* (Informed, informiert) wird über Ergebnisse unterrichtet.

> **Ergänzung aus der Nachrecherche**
>
> RACI-Regeln: Laut dem abgerufenen CIO-Artikel gilt: Jede Aufgabe braucht mindestens ein R, jede Aufgabe hat nur ein A, und jedes Teammitglied hat bei jeder Aufgabe eine Rolle, notfalls nur I. Als typische Fehler nennt der Artikel: zu viele R bei einer Person oder bei einem Schritt, kein R, kein A, mehr als ein A (unklare Entscheidungsrechte), zu viele C (verlangsamt), leere oder komplett gefüllte Zellen, fehlende Zustimmung der Beteiligten und vergessene Stakeholder. Der Artikel hebt die Trennung von R und A als zentrales Prinzip hervor. (Abruf 28.10.2026, siehe Quellenverzeichnis.)

Eine RACI-Matrix ist eine Tabelle: In den Zeilen stehen die Aufgaben (zum Beispiel Schritte des Dokumentationsprozesses), in den Spalten die Rollen oder Personen, in den Zellen die Buchstaben. Sie beantwortet auf einen Blick, wer was tut, wer entscheidet, wer gefragt und wer informiert wird. In der Dokumentations-Governance wird sie typischerweise für den Dokumentenlebenszyklus aufgestellt, etwa: Dokument anlegen, schreiben, prüfen, freigeben, veröffentlichen, überprüfen, archivieren. Je nach Organisation sind Erweiterungen verbreitet (zum Beispiel RASCI mit einem S für Support); die Grundform genügt für den Einstieg.

Die Qualität einer RACI-Matrix lässt sich prüfen. Die Regeln (genau ein A, mindestens ein R pro Zeile) sind formal und eignen sich für eine automatische Kontrolle. Das folgende Beispiel zeigt eine Matrix für den Dokumentationsprozess und ein Skript, das die Regeln prüft.

```text
aufgabe;owner;autor;reviewer;approver;redaktion
Dokument anlegen;A;R;I;I;C
Dokument schreiben;A;R;C;I;C
Dokument prüfen;I;C;R;A;C
Dokument freigeben;C;I;C;A;R
Dokument überprüfen;A;C;R;I;I
Dokument archivieren;A;R;I;C;I
```

```python
import csv, sys

fehler = 0
with open(sys.argv[1], encoding="utf-8", newline="") as f:
    leser = csv.DictReader(f, delimiter=";")
    rollen = [r for r in leser.fieldnames if r != "aufgabe"]
    for z in leser:
        werte = [z[r] for r in rollen]
        a = werte.count("A")
        r = werte.count("R")
        if a != 1:
            print(f"{z['aufgabe']}: {a} mal A (genau 1 erforderlich)"); fehler += 1
        if r < 1:
            print(f"{z['aufgabe']}: kein R"); fehler += 1
print("RACI regelkonform" if not fehler else f"{fehler} Verstoß/Verstöße")
sys.exit(1 if fehler else 0)
```

Die Tabelle zeigt sechs Aufgaben und fünf Rollen. Das Skript liest die Kopfzeile aus, um die Rollen zu ermitteln, und zählt pro Zeile die Buchstaben A und R. Verstöße werden gemeldet. Wenn Sie die Beispielmatrix prüfen, werden Sie feststellen, dass die Zeile „Dokument freigeben“ ein A beim Approver und ein R bei der Redaktion hat: Das ist regelkonform, aber ein Anlass für ein Gespräch, ob die Redaktion die Freigabe wirklich durchführen soll oder nur den Vermerk eintragen. Die formale Prüfung ersetzt also nicht die inhaltliche Diskussion, sie macht sie nur möglich.

Typische Fehler: Mehrere A in einer Zeile („alle sind verantwortlich“), kein A bei Aufgaben, die nach dem Projekt liegen (Pflege), zu viele C, die jede Entscheidung verlangsamen, und eine Matrix, die niemand mit den Beteiligten abgestimmt hat. Eine RACI-Matrix, die nur der Ersteller kennt, ist wertlos.

| **Falsch**                                                               | **Richtig**                                                                                        |
|:-------------------------------------------------------------------------|:---------------------------------------------------------------------------------------------------|
| Zeile „Dokument prüfen“ mit A bei Reviewer und Approver und R bei allen. | Zeile „Dokument prüfen“ mit genau einem A (Approver), R beim Reviewer, C beim Autor, I beim Owner. |

Im Projekt hilft die RACI-Matrix besonders bei Übergaben und Reorganisationen: Sie macht sichtbar, welche Aufgaben niemandem gehören.

## 6.14 Vertretungsregelung

Rollen sind nur so zuverlässig wie die Menschen, die sie ausfüllen. Urlaub, Krankheit, Dienstreisen und Personalwechsel gehören zum Alltag. Eine Vertretungsregelung legt fest, wer eine Rolle übernimmt, wenn ihr Inhaber ausfällt, und mit welchen Befugnissen. Sie verhindert, dass Freigaben, Reviews oder Eskalationen blockieren. Ohne sie entstehen die bekannten Engpässe: Das Dokument ist fertig, aber der Approver ist drei Wochen im Urlaub, oder es wird behelfsmäßig von jemandem freigegeben, der dazu nicht befugt ist.

Eine Vertretungsregelung enthält fünf Angaben. Wer ist *Vertreter* der Rolle? Ab wann und bis wann gilt die Vertretung (*Zeitraum*)? Mit welchen *Befugnissen* handelt der Vertreter (alle oder nur bestimmte)? Wie wird der Vertreter *informiert* und eingewiesen? Und wie wird die Vertretung *nachweisbar* (Eintrag im System, damit im Audit ersichtlich ist, wer gehandelt hat)? Wichtig ist außerdem die Frage der *Unabhängigkeit*: Der Vertreter darf nicht dieselbe Person sein, die im selben Vorgang bereits eine andere Rolle hat; sonst wird das Vier-Augen-Prinzip untergraben.

Man unterscheidet *geplante* Vertretung (Urlaub, Dienstreise) und *ungeplante* (Krankheit, Ausscheiden). Für die ungeplante ist eine *dauerhaft hinterlegte* Vertretung nötig, die ohne weitere Absprache gilt. Das folgende Beispiel zeigt Rollenzuordnung und Abwesenheiten sowie ein Skript, das für ein Datum bestimmt, wer eine Rolle tatsächlich wahrnimmt.

```yaml
rollen:
  Approver Richtlinien:
    inhaber: Cora Maier
    vertretung: [Dieter Koch, Eva Lang]
abwesend:
  Cora Maier: [2026-10-20, 2026-11-03]
  Dieter Koch: [2026-10-27, 2026-10-30]
```

```python
import sys, yaml
from datetime import date

d = yaml.safe_load(open(sys.argv[1], encoding="utf-8"))
rolle, tag = sys.argv[2], date.fromisoformat(sys.argv[3])

def anwesend(person):
    zeitraum = d["abwesend"].get(person)
    if not zeitraum:
        return True
    von, bis = zeitraum
    return not (von <= tag <= bis)

kandidaten = [d["rollen"][rolle]["inhaber"]] + d["rollen"][rolle]["vertretung"]
for person in kandidaten:
    if anwesend(person):
        print(f"{rolle} am {tag}: {person}")
        break
else:
    print(f"{rolle} am {tag}: NIEMAND verfügbar - Eskalation")
    sys.exit(1)
```

Die Datei ordnet jeder Rolle einen Inhaber und eine geordnete Liste von Vertretern zu und nennt Abwesenheitszeiträume. Das Skript geht die Kandidaten der Reihe nach durch und gibt die erste anwesende Person aus. Fällt für ein Datum niemand an, wird das ausdrücklich gemeldet. Der Aufruf mit dem Datum 2026-10-28 liefert Eva Lang, weil sowohl der Inhaber als auch der erste Vertreter abwesend sind. Das Muster entspricht dem, was Ticketsysteme für Bereitschaftspläne und Genehmigungsworkflows tun.

Typische Fehler: Es gibt keine Vertretung, oder die Vertretung ist ebenfalls selten erreichbar, es gibt nur einen einzigen Vertreter, der selbst Urlaub hat, oder die Vertretung ist nur mündlich vereinbart. Ein weiteres Problem sind Vertreter, die nicht wissen, dass sie es sind, und deshalb nicht handeln. Und schließlich: Vertreter ohne Zugriffsrechte, die Dokumente nicht öffnen oder freigeben dürfen.

| **Falsch**                                   | **Richtig**                                                                                                                                               |
|:---------------------------------------------|:----------------------------------------------------------------------------------------------------------------------------------------------------------|
| „Wenn ich weg bin, fragt einfach irgendwen.“ | „Approver Richtlinien: Cora Maier, Vertretung in dieser Reihenfolge: Dieter Koch, Eva Lang. Berechtigungen im System eingerichtet, Vertreter informiert.“ |

Im Projekt gehört der Test der Vertretung in jede Rollenübersicht: Einmal im Jahr wird geprüft, ob die Vertreter wissen, dass sie es sind, und ob sie ihre Aufgaben ausführen könnten.

## Übungsaufgaben

Die Aufgaben steigen von Verständnisfragen (1 bis 3) über Anwendungs- und Entwurfsaufgaben (4 bis 6) bis zu Programmier- und Transferaufgaben (7 und 8) an.

**Aufgabe 1.** *(leicht)* Nennen Sie die sieben Fragen, die eine vollständige Prozessbeschreibung beantwortet, und erklären Sie, warum ein Prozess ohne Trigger nicht funktioniert.

**Aufgabe 2.** *(leicht)* Worin unterscheiden sich Richtlinie, SOP, Arbeitsanweisung und Checkliste? Ordnen Sie sie in einer Dokumentenpyramide.

**Aufgabe 3.** *(leicht bis mittel)* Erklären Sie funktionale und hierarchische Eskalation. Welche Art wäre in den folgenden Fällen angemessen? (a) Ein Service-Desk-Mitarbeiter kann ein Netzwerkproblem nicht diagnostizieren. (b) Ein Großkunde droht mit Kündigung, die Frist läuft in zwei Stunden ab.

**Aufgabe 4.** *(mittel)* Erstellen Sie den Prozesssteckbrief (YAML) für den Prozess „Dokument außer Dienst stellen“ mit Trigger, Eingaben, Ergebnis, mindestens vier Schritten, Rollen und Kennzahl.

**Aufgabe 5.** *(mittel)* Erstellen Sie eine RACI-Matrix für den Prozess „Runbook nach Systemänderung aktualisieren“ mit mindestens fünf Aufgaben und vier Rollen und überprüfen Sie sie gegen die Regeln.

**Aufgabe 6.** *(mittel, praktisch)* Schreiben Sie ein Skript, das eine Rollenübersicht (CSV mit `rolle;inhaber;vertretung`) einliest und alle Personen ausgibt, die mehr als drei Rollen innehaben.

**Aufgabe 7.** *(anspruchsvoll, praktisch)* Erweitern Sie das Vertretungsskript so, dass es für einen Zeitraum von Beginn bis Ende (zwei Daten) alle Tage ausgibt, an denen niemand für die Rolle verfügbar ist.

**Aufgabe 8.** *(anspruchsvoll, Transfer)* In einem Team werden Freigaben regelmäßig um Wochen verzögert, weil der einzige Approver oft unterwegs ist. Gleichzeitig freigeben Autoren aus Zeitdruck ihre Dokumente selbst. Analysieren Sie die Ursachen und entwerfen Sie ein Freigabekonzept mit Freigabematrix, Vertretungsregel und Eskalation.

## Lösungen und Erläuterungen

**Lösung zu Aufgabe 1.** Die sieben Fragen: Was löst den Prozess aus (Trigger)? Was geht hinein und was kommt heraus (Eingaben, Ergebnis)? Welche Schritte führen dorthin? Wer führt aus, wer verantwortet? Welche Regeln gelten? Welche Hilfsmittel werden genutzt? Woran wird der Erfolg gemessen? Ohne Trigger weiß niemand, wann der Prozess beginnt: Anträge bleiben liegen, weil keiner sich zuständig fühlt, oder werden doppelt bearbeitet. Der Trigger legt den Startpunkt eindeutig fest.

**Lösung zu Aufgabe 2.** Die Richtlinie legt fest, was gilt und warum (Regeln, Grundsätze). Die SOP beschreibt verbindlich, wie ein wiederkehrendes Verfahren abläuft und welche Nachweise entstehen. Die Arbeitsanweisung erklärt die konkreten Handgriffe an einem Werkzeug. Die Checkliste ist ein Hilfsmittel zum Abhaken. In der Pyramide stehen Richtlinien oben, darunter Prozesse und SOPs, darunter Arbeitsanweisungen, Checklisten und Formulare. Je weiter unten, desto häufiger ändert sich der Inhalt und desto einfacher darf die Freigabe sein.

**Lösung zu Aufgabe 3.** Funktionale Eskalation: Weitergabe an jemanden mit mehr Fachwissen; hierarchische Eskalation: Weitergabe an eine Führungskraft wegen Dringlichkeit oder Entscheidungsbedarf. (a) funktional, an die zweite Supportstufe oder den Netzwerkspezialisten. (b) hierarchisch, an die Führungskraft, weil Entscheidungen und Zusagen nötig werden, die über die Befugnisse des Bearbeiters hinausgehen; zusätzlich sollte funktional eskaliert werden, falls auch ein technisches Problem vorliegt. Beide Arten können parallel nötig sein.

**Lösung zu Aufgabe 4.** Eine mögliche Lösung:

```yaml
prozess: Dokument außer Dienst stellen
id: PRO-031
owner: Redaktion
trigger: Dokument ist veraltet oder ersetzt
eingaben: [Dokument, Begründung des Owners]
ergebnis: Dokument archiviert, Verweis auf Nachfolger gesetzt
schritte:
  - Entscheidung des Owners dokumentieren
  - Abhängige Dokumente und Verlinkungen prüfen
  - Status auf archiviert setzen und Nachfolger verlinken
  - Aus Suche und Navigation entfernen
  - Aufbewahrungsfrist festhalten
rollen: [Owner, Redaktion]
kennzahl: Anteil archivierter Dokumente mit Nachfolgerverweis
```

Wichtig ist, dass der Trigger konkret ist („veraltet oder ersetzt“) und der Prozess mit einem prüfbaren Ergebnis endet. Der Schritt „Abhängige Dokumente prüfen“ verhindert tote Links, der letzte Schritt verweist auf Aufbewahrungsfristen (Modul 13).

**Lösung zu Aufgabe 5.** Eine mögliche Matrix:

```text
aufgabe;service_owner;autor;reviewer;approver
Änderung erkennen;A;R;I;I
Runbook anpassen;C;A;I;I
Anpassung testen;I;R;A;I
Anpassung prüfen;I;C;R;A
Freigeben und veröffentlichen;I;I;C;A
```

Die Prüfung ergibt: In der Zeile „Runbook anpassen“ fehlt ein R (nur A beim Autor), in der Zeile „Freigeben und veröffentlichen“ ebenfalls. Das sind genau die Verstöße, die das Skript meldet: Jede Aufgabe braucht mindestens ein R. Korrektur: In der Zeile „Runbook anpassen“ wird der Autor R und der Service Owner A (`A;R;I;I`); in der Zeile „Freigeben und veröffentlichen“ bleibt der Approver A, und der Reviewer wird R (`I;I;R;A`). Die Aufgabe zeigt, dass selbst kleine Matrizen Fehler enthalten, die erst die systematische Prüfung sichtbar macht.

**Lösung zu Aufgabe 6.** Eine mögliche Lösung:

```python
import csv, sys
from collections import Counter

zaehler = Counter()
for z in csv.DictReader(open(sys.argv[1], encoding="utf-8"), delimiter=";"):
    if z["inhaber"]:
        zaehler[z["inhaber"]] += 1

for person, n in zaehler.most_common():
    if n > 3:
        print(f"{person}: {n} Rollen")
```

Der `Counter` zählt, wie oft jede Person als Inhaber vorkommt, und die Ausgabe beschränkt sich auf Personen mit mehr als drei Rollen. Eine Häufung ist ein Risiko aus zwei Gründen: Es entsteht ein Engpass, und bei Ausfall dieser Person fallen mehrere Rollen zugleich aus. Außerdem ist bei Häufungen das Vier-Augen-Prinzip gefährdet.

**Lösung zu Aufgabe 7.** Eine mögliche Ergänzung des Skripts:

```python
from datetime import timedelta

def luecken(von, bis):
    tag = von
    while tag <= bis:
        kand = [d["rollen"][rolle]["inhaber"]] + d["rollen"][rolle]["vertretung"]
        if not any(anwesend_am(p, tag) for p in kand):
            print("Keine Besetzung am", tag)
        tag += timedelta(days=1)
```

Dazu muss die Funktion `anwesend` so umgestellt werden, dass der Tag als Parameter übergeben wird (hier `anwesend_am(person, tag)`). Die Schleife geht Tag für Tag durch den Zeitraum und prüft, ob mindestens eine Person verfügbar ist. Mit den Beispieldaten gibt es keine Lücke, weil Eva Lang nie abwesend ist; fügt man für sie einen Abwesenheitszeitraum ein, der sich mit den anderen überlappt, erscheinen die entsprechenden Tage. Die Auswertung zeigt, warum mehrere Vertreter notwendig sind.

**Lösung zu Aufgabe 8.** Ursachen: Es gibt nur einen Approver, und die Rolle hat keine hinterlegte Vertretung (Engpass). Außerdem fehlt eine abgestufte Freigabe; für alle Dokumente gilt derselbe Weg, sodass Zeitdruck zu Umgehungen (Selbstfreigabe) führt. Konzept: (1) Freigabematrix mit Stufen nach Risiko: Runbooks der Stufe C kann der Service Owner freigeben, SOPs und Richtlinien die Leitung. (2) Vertretung: Pro Stufe mindestens zwei benannte Vertreter, im System hinterlegt, mit Reihenfolge. (3) Eskalation: Wenn eine Freigabe länger als drei Arbeitstage offen ist, wird automatisch an den Vertreter eskaliert; nach fünf Tagen an die Leitung. (4) Vier-Augen-Regel technisch erzwingen: Der Autor darf nicht Approver sein (geschützter Zweig in der Versionsverwaltung). (5) Kennzahl: Durchlaufzeit der Freigabe, Auswertung monatlich. Die Fristen sind Beispielwerte. Erfolgskriterium: Median der Freigabedauer unter drei Arbeitstagen und keine Selbstfreigaben in der Auswertung.
