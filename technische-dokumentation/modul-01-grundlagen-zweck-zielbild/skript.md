# Modul 01 - Grundlagen, Zweck und Zielbild technischer Dokumentation

> **Hinweis zu diesem Kapitel:** Das ist das Kapitel des Skripts „Technische Dokumentation und Dokumentations-Governance“, aus der LaTeX-Quelle in Markdown umgewandelt (Text und Listings unverändert, farbige Boxen als Zitatblöcke mit fettem Titel, Tabellen als Markdown-Tabellen, Übungsaufgaben und Lösungen als Absätze). Die Lerneinheiten sind wie in der Quelle nach Modul nummeriert (1.1 bis 1.13), danach folgen „Übungsaufgaben“ (8 Aufgaben) und „Lösungen und Erläuterungen“. Die Sprachangabe der Codeblöcke ist in der Quelle nur für Python und Bash gesetzt; die übrigen Blöcke sind hier nach ihrem Inhalt als `python`, `yaml`, `markdown`, `bash` oder `text` ausgezeichnet, der Inhalt selbst ist unverändert. **Prüfstand der Beispiele für dieses Repository:** Die Python-Beispiele wurden auf Syntax geprüft; welche Beispiele ausgeführt wurden und welche zusätzlich PyYAML brauchen, steht in der [README des Repositories](../README.md). Übersicht zum Modul: [README](README.md).

**Dauer:** 13 Stunden | **Priorität:** 1 | **Lerneinheiten:** 13

| **Nr.** | **Lerneinheit**                     | **Dauer (h)** | **Prio** |
|--------:|:------------------------------------|--------------:|---------:|
|       1 | Dokumentationsbegriff               |             1 |        3 |
|       2 | Zielgruppenanalyse                  |             1 |        1 |
|       3 | Dokumentationsarten                 |             1 |        1 |
|       4 | Informationsarchitektur             |             1 |        1 |
|       5 | Qualitätskriterien                  |             1 |        1 |
|       6 | Rechtliche Grundlagen               |             1 |        2 |
|       7 | Dokumentationslebenszyklus          |             1 |        2 |
|       8 | Grundlagen-Troubleshooting          |             1 |        2 |
|       9 | Dokumentations-Governance-Überblick |             1 |        3 |
|      10 | Governance vs Dokumentation         |             1 |        1 |
|      11 | Ziele und Nutzen                    |             1 |        1 |
|      12 | Rollen und Verantwortlichkeiten     |             1 |        1 |
|      13 | Einsatzszenarien                    |             1 |        2 |
|         | **Summe**                           |        **13** |          |

## 1.1 Dokumentationsbegriff

Wer im IT-Umfeld von *Dokumentation* spricht, meint erstaunlich Unterschiedliches: Der eine denkt an das Handbuch, das einem Produkt beiliegt, die andere an Kommentare im Quellcode, ein Dritter an das Wiki, in dem Teams ihr Wissen sammeln. Für diesen Kurs gilt eine arbeitsfähige Definition: **Technische Dokumentation ist die Gesamtheit aller dauerhaft festgehaltenen Informationen, die nötig sind, ein technisches System zu verstehen, zu betreiben, zu warten, zu verändern und seine Eigenschaften nachzuweisen.** Das Wort „dauerhaft“ ist wichtig. Eine Erklärung, die nur im Kopf eines Kollegen existiert oder in einem Chatverlauf versandet, ist keine Dokumentation, sondern implizites Wissen, das mit dem Personalwechsel verschwindet.

Aus der Definition folgen vier Funktionen, die sich in jedem Projekt wiederfinden. Erstens die *Betriebsfunktion*: Jemand muss nachts um drei Uhr herausfinden können, wie ein Dienst neu gestartet wird, ohne den Entwickler anzurufen. Zweitens die *Wartungsfunktion*: Wer ein System in zwei Jahren ändern soll, muss wissen, warum es so gebaut wurde, wie es ist. Drittens die *Schulungsfunktion*: Neue Mitarbeitende werden schneller produktiv, wenn sie sich Wissen selbst erarbeiten können. Viertens die *Nachweisfunktion*: Gegenüber Kunden, Prüfern und Behörden belegt Dokumentation, dass etwas wie vereinbart umgesetzt wurde. Diese vierte Funktion wird gern unterschätzt, ist aber der Grund, warum Dokumentation in regulierten Branchen nicht verhandelbar ist.

Wichtig ist die Abgrenzung zu verwandten Begriffen. *Information* ist jede Aussage über einen Sachverhalt, *Dokument* ist ein abgegrenzter, benannter und meist versionierter Informationsträger, und *Dokumentation* ist die geordnete Menge von Dokumenten mit einem erkennbaren Zweck. Ein einzelner Wiki-Eintrag ist demnach ein Dokument, die Summe aller Einträge zu einem System bildet die Systemdokumentation. Davon zu unterscheiden ist *Wissensmanagement*, das auch Informelles wie Erfahrung und Kontakte umfasst, während Dokumentation das Explizite, Nachprüfbare erfasst.

Ein weiterer Begriff, dem man ständig begegnet, ist *Single Source of Truth*, kurz SSoT. Gemeint ist, dass jede Information genau an einer maßgeblichen Stelle gepflegt wird und alle anderen Stellen darauf verweisen, statt Kopien zu führen. Der Grund ist banal: Kopien laufen auseinander. Sobald dieselbe IP-Adresse in drei Dokumenten steht, ist früher oder später eine davon falsch.

Um diese Begriffe greifbar zu machen, hilft ein kleines Werkzeug. Das folgende Python-Skript prüft, ob ein Markdown-Dokument die Mindestbestandteile enthält, die wir für eine „echte“ Dokumentation fordern: einen Titel, einen Zweck, einen Verantwortlichen und ein Änderungsdatum. Es ist bewusst klein gehalten und lässt sich mit einer normalen Python-3-Installation sofort ausführen.

```python
import re, sys

PFLICHT = {
    "Titel": r"^# .+",
    "Zweck": r"^\*\*Zweck:\*\* .+",
    "Owner": r"^\*\*Owner:\*\* .+",
    "Stand": r"^\*\*Stand:\*\* \d{4}-\d{2}-\d{2}",
}

def pruefe(text):
    fehlend = []
    for name, muster in PFLICHT.items():
        if not re.search(muster, text, re.MULTILINE):
            fehlend.append(name)
    return fehlend

if __name__ == "__main__":
    text = open(sys.argv[1], encoding="utf-8").read()
    fehlt = pruefe(text)
    if fehlt:
        print("Unvollständig, es fehlt:", ", ".join(fehlt))
        sys.exit(1)
    print("Mindestbestandteile vorhanden.")
```

Das Skript definiert in `PFLICHT` ein Wörterbuch, das jedem Pflichtbestandteil einen regulären Ausdruck zuordnet. Die Funktion `pruefe` wendet jeden Ausdruck auf den gesamten Text an. Die Option `re.MULTILINE` sorgt dafür, dass `^` den Beginn jeder Zeile meint und nicht nur den Textanfang. Fehlt ein Bestandteil, landet sein Name in der Liste `fehlend`. Im Hauptteil wird die Datei gelesen und der Rückgabewert des Programms auf 1 gesetzt, wenn etwas fehlt, sodass sich das Skript später in eine automatische Prüfung (etwa in einer CI-Pipeline) einhängen lässt.

Typische Fehler beim Begriff selbst sind drei. Der erste ist die Gleichsetzung von Dokumentation mit „Text schreiben“: Ein Architekturdiagramm, eine Konfigurationsdatei mit Kommentaren oder eine aufgezeichnete Entscheidung sind ebenfalls Dokumentation. Der zweite ist die Annahme, Dokumentation sei einmalig „fertig“: Sie ist ein Betriebsmittel, das gepflegt werden muss. Der dritte ist das Fehlen eines Adressaten. Ein Dokument ohne erkennbaren Leser ist wie ein Weg ohne Ziel.

| **Falsch**                                                                                                         | **Richtig**                                                                                                                 |
|:-------------------------------------------------------------------------------------------------------------------|:----------------------------------------------------------------------------------------------------------------------------|
| „Die Datenbank läuft auf dem Server. Passwort wie immer.“ (kein Bezug, kein Datum, kein Owner, Geheimnis implizit) | „Datenbank `db-prod-01`, PostgreSQL 16, Stand 2026-10-01, Owner: Team Plattform. Zugangsdaten im Passwortmanager unter `Plattform/DB`.“ |

Im Projektalltag begegnet Ihnen der Dokumentationsbegriff vor allem bei Übergaben: Wenn ein Entwicklungsteam ein System an den Betrieb übergibt, einigt man sich in der Regel auf eine Liste von Dokumenten, ohne die die Übergabe nicht akzeptiert wird. Wer diese Liste kennt, weiß, was „fertig“ bedeutet.

> **Merke**
>
> Dokumentation ist dauerhaft festgehaltenes, auffindbares und nachprüfbares Wissen über ein System. Sie erfüllt Betriebs-, Wartungs-, Schulungs- und Nachweisfunktionen.

## 1.2 Zielgruppenanalyse

Dokumentation wird nie „für alle“ geschrieben. Ein Dokument, das gleichzeitig dem Geschäftsführer, dem Administrator und dem externen Prüfer gerecht werden will, ist meist für keinen von ihnen brauchbar. Die *Zielgruppenanalyse* ist deshalb der erste Arbeitsschritt jeder Dokumentation: Sie klärt, wer das Dokument liest, was diese Person schon weiß, was sie damit tun will und in welcher Situation sie es liest.

Eine einfache Gliederung unterscheidet vier Dimensionen. Die *Rolle* beschreibt, welche Aufgabe die Leserin hat (Administrator, Entwicklerin, Projektleiter, Auditorin). Das *Vorwissen* legt fest, welche Begriffe erklärt werden müssen und welche vorausgesetzt werden dürfen. Das *Ziel* unterscheidet, ob jemand lernen, eine Aufgabe erledigen, etwas nachschlagen oder etwas bewerten will. Der *Kontext* schließlich beschreibt die Lesesituation: am Schreibtisch mit Ruhe, im Rechenzentrum mit einem Notebook auf dem Knie, bei einem Störfall unter Zeitdruck oder in einem Audit mit Papier in der Hand. Dieselbe Information muss in diesen Situationen völlig unterschiedlich aufbereitet werden.

In der Praxis hat sich bewährt, die Ergebnisse der Analyse in *Personas* festzuhalten. Eine Persona ist ein knapp beschriebener, typischer Leser, der stellvertretend für eine ganze Gruppe steht. Dabei geht es nicht um Fantasiegestalten, sondern um nüchtern formulierte Arbeitsprofile, die das Schreiben steuern. Sie reduzieren die Frage „Ist das verständlich?“ auf die konkretere Frage „Versteht Frau Berger, Systemadministratorin im zweiten Jahr, diesen Satz ohne Rückfrage?“.

Das folgende Beispiel hält zwei Personas als YAML-Datei fest. YAML ist ein einfaches, menschenlesbares Datenformat; es eignet sich hier, weil es sowohl von Menschen gepflegt als auch später von Werkzeugen ausgewertet werden kann.

```yaml
personas:
  - id: admin-berger
    rolle: Systemadministratorin Betrieb
    vorwissen: Linux gut, Netzwerke solide, kennt das System nicht im Detail
    ziel: Störungen beheben, Routineaufgaben erledigen
    kontext: Zeitdruck, oft nachts, Notebook, VPN
    braucht: kurze nummerierte Schritte, Befehle zum Kopieren, Rückfallweg
  - id: pruefer-huber
    rolle: Interner Auditor
    vorwissen: Normen und Prozesse gut, Technik oberflächlich
    ziel: Nachweisen, dass Vorgaben eingehalten werden
    kontext: Ruhe, Papier oder PDF, systematische Prüfung
    braucht: Freigabevermerke, Versionshistorie, Verweise auf Anforderungen
```

Jeder Eintrag beginnt mit einer eindeutigen `id`, damit man in Dokumenten und Metadaten darauf verweisen kann. Die Felder `rolle`, `vorwissen`, `ziel` und `kontext` entsprechen den vier Dimensionen. Besonders aufschlussreich ist das Feld `braucht`: Es übersetzt die Analyse unmittelbar in Gestaltungsregeln. Aus dem Profil von Frau Berger folgt, dass ein Runbook (Betriebsanleitung für wiederkehrende Aufgaben) aus nummerierten Schritten mit kopierbaren Befehlen bestehen sollte. Aus dem Profil von Herrn Huber folgt, dass dasselbe System zusätzlich ein Dokument mit Freigabevermerken und Verweisen auf Anforderungen braucht.

Häufige Fehler bei der Zielgruppenanalyse: Erstens wird sie übersprungen, weil „jeder weiß, wer das liest“. Meist stimmt das nicht, und das Dokument wird in der Folge zu technisch für die einen und zu banal für die anderen. Zweitens werden zu viele Zielgruppen in ein Dokument gepackt. Besser sind mehrere schlanke Dokumente mit Querverweisen. Drittens wird das Vorwissen überschätzt: Autoren kennen ihr System so gut, dass sie ihre eigenen Abkürzungen für Allgemeingut halten.

| **Falsch**                                                                                                              | **Richtig**                                                                                                                                                                                                                                      |
|:------------------------------------------------------------------------------------------------------------------------|:-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| „Nach dem Failover den VIP-Status per crm prüfen und STONITH reaktivieren.“ (für ein Team, das den Cluster nicht kennt) | „Nach dem Wechsel auf den zweiten Server (Failover) prüfen Sie mit `crm status`, ob die gemeinsame IP-Adresse (VIP) beim aktiven Server liegt. Anschließend schalten Sie den Schutzmechanismus gegen Doppelbetrieb (STONITH) wieder ein: Schritt 4.“ |

Im echten Projekt begegnet Ihnen die Zielgruppenanalyse spätestens, wenn eine Dokumentation „nicht gelesen“ wird. Fast immer liegt dann nicht Faulheit vor, sondern eine Fehlpassung zwischen Dokument und Lesesituation. Die methodische Vertiefung mit Interviews, Nutzungsanalyse und Persona-Pflege folgt in Modul 02 im Abschnitt Zielgruppenanalyse.

> **Praxisbeispiel**
>
> Fragen Sie vor dem Schreiben immer: Wer liest das, wann, und was soll danach möglich sein, was vorher nicht ging? Wenn Sie die dritte Frage nicht beantworten können, fehlt dem Dokument der Zweck.

## 1.3 Dokumentationsarten

Technische Dokumentation ist kein einheitliches Gebilde. Verschiedene Leserbedürfnisse verlangen verschiedene Dokumentarten, und wer sie vermischt, erzeugt Texte, die nichts richtig leisten. Eine bewährte Ordnung unterscheidet zunächst nach dem *Gegenstand*: Systemdokumentation beschreibt, wie ein technisches System aufgebaut ist; Betriebsdokumentation beschreibt, wie es betrieben wird; Prozessdokumentation beschreibt Arbeitsabläufe; Entwicklerdokumentation beschreibt Schnittstellen und Code; Anwenderdokumentation erklärt Endnutzern die Bedienung.

Eine zweite, quer dazu liegende Ordnung betrifft die *Leseabsicht*. Hier hat sich das Modell *Diátaxis* etabliert, das Daniele Procida in einem Beitrag für Canonical vorstellt und das Canonical für seine Dokumentation übernommen hat. Es unterscheidet vier Typen: *Tutorials* führen Lernende Schritt für Schritt zu einem ersten Erfolgserlebnis, *How-to-Guides* zeigen erfahrenen Anwendern, wie sie ein konkretes Ziel erreichen, die *Referenz* beschreibt sachlich und vollständig, wie etwas aufgebaut ist, und die *Erklärung* liefert Hintergrund und Begründungen. Entscheidend ist der Grundsatz, dass jeder Typ genau einen Zweck hat und von den anderen getrennt bleiben sollte.

> **Ergänzung aus der Nachrecherche**
>
> Diátaxis nach Canonical: Die vier Typen entsprechen vier Lesehaltungen. Tutorials dienen dem Lernen im Studienmodus und enthalten nur Handlungsanweisungen, How-to-Guides dienen dem Erledigen einer Aufgabe im Arbeitsmodus, die Referenz dient dem Nachschlagen verlässlicher Fakten, die Erklärung dient dem Verstehen des Warum. (Quelle: Canonical-Blogbeitrag, abgerufen am 28.10.2026, siehe Quellenverzeichnis.)

Wie sich beide Ordnungen verbinden, zeigt eine kleine Inventarliste. Jede Zeile beschreibt ein Dokument mit Gegenstand und Typ. Das Beispiel ist eine CSV-Datei (Werte durch Semikolon getrennt), die sich in Excel genauso öffnen lässt wie in einem Skript.

```text
titel;gegenstand;typ;owner
Architekturübersicht Shop;System;Erklärung;Team Plattform
Neustart Shop-Dienst;Betrieb;How-to;Team Betrieb
Konfigurationsparameter;System;Referenz;Team Plattform
Erste Schritte für neue Admins;Betrieb;Tutorial;Team Betrieb
Freigabe von Releases;Prozess;How-to;PMO
```

Mit wenigen Zeilen Python lässt sich auswerten, ob ein Typ im Bestand völlig fehlt, was in der Praxis häufig vorkommt (typischerweise gibt es viele Referenzen und kaum Tutorials).

```python
import csv
from collections import Counter

with open("inventar.csv", encoding="utf-8", newline="") as f:
    zeilen = list(csv.DictReader(f, delimiter=";"))

anzahl = Counter(z["typ"] for z in zeilen)
for typ in ["Tutorial", "How-to", "Referenz", "Erklärung"]:
    print(f"{typ:10s} {anzahl.get(typ, 0)}")
```

Das Skript liest die Inventardatei als Liste von Wörterbüchern ein (`DictReader` nutzt die erste Zeile als Spaltennamen). `Counter` zählt, wie oft jeder Typ vorkommt. Die Schleife gibt dann auch Typen mit Anzahl 0 aus, was wichtig ist: Die Lücke ist die Erkenntnis. Mit der Beispieldatei erscheinen Tutorial, Referenz und Erklärung je einmal und How-to zweimal.

Typische Fehler: Das häufigste Problem ist das Vermischen. Ein „Handbuch“, das auf Seite eins das Konzept erklärt, auf Seite zwei Schritte auflistet und auf Seite drei Parameter beschreibt, bedient niemanden gut. Der Lernende wird mit Details überschüttet, der Erfahrene muss sich durch Erklärungen kämpfen, und beim Nachschlagen findet niemand etwas. Ein zweiter Fehler ist, Dokumentarten nur nach dem Format zu benennen („Word-Datei“, „PDF“), statt nach dem Zweck.

| **Falsch**                                                                                                             | **Richtig**                                                                                                                                                   |
|:-----------------------------------------------------------------------------------------------------------------------|:--------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Ein Dokument „Datenbank“ mit Architektur, Installationsschritten, allen Parametern und Notfallhinweisen in einem Text. | Vier getrennte Dokumente: „Warum PostgreSQL?“ (Erklärung), „Installation“ (How-to), „Parameter“ (Referenz), „Datenbank neu aufsetzen nach Ausfall“ (Runbook). |

Im Projekt hilft die Unterscheidung bei der Planung: Wer einen Dokumentationsauftrag erhält, sollte zuerst klären, welche Dokumentarten benötigt werden. Das verhindert, dass monatelang nur die Art geschrieben wird, die den Autoren leichtfällt (meist Referenz), während der Betrieb in der Nacht vergeblich ein Runbook sucht.

## 1.4 Informationsarchitektur

Die *Informationsarchitektur* (IA) legt fest, wie Informationen organisiert, benannt, verknüpft und auffindbar gemacht werden. Sie ist für Dokumentation das, was die Statik für ein Gebäude ist: Man sieht sie nicht, aber ohne sie fällt alles in sich zusammen. In diesem Modul bekommen Sie die Grundidee; die Methoden (Taxonomie, Metadatenmodell, Ablagestruktur, Namenskonventionen) folgen ausführlich in Modul 03, Abschnitte Informationsarchitektur bis Klassifikation.

Eine Informationsarchitektur beantwortet vier Fragen. Wie sind die Inhalte *gegliedert* (nach System, Prozess, Zielgruppe)? Wie sind sie *beschriftet* (einheitliche Begriffe, sprechende Titel)? Wie sind sie *verknüpft* (Querverweise, Abhängigkeiten, Verlinkung zu Tickets)? Und wie werden sie *gefunden* (Navigation, Suche, Tags)? Ein häufiger Irrtum besteht darin, IA mit Ordnerstruktur gleichzusetzen. Die Ordnerstruktur ist nur eine Ausprägung; moderne Dokumentationswerkzeuge arbeiten stark mit Metadaten und Suche, sodass dasselbe Dokument unter mehreren Blickwinkeln auffindbar ist.

Warum ist das so wichtig? Studien in Unternehmen kommen immer wieder zu dem Ergebnis, dass Mitarbeitende einen großen Teil ihrer Arbeitszeit mit der Suche nach Informationen verbringen. Selbst wenn man solche Zahlen mit Vorsicht behandelt, lässt sich das Phänomen aus der Praxis bestätigen: Das Problem ist selten, dass es keine Dokumentation gibt, sondern dass man sie nicht findet. Gute Informationsarchitektur senkt diese Suchzeit und damit unmittelbar die Kosten.

Das folgende Beispiel zeigt eine einfache, nach Systemen gegliederte Ablage. Es ist als Verzeichnisbaum dargestellt, wie man ihn in einem Git-Repository oder auf einem Dateiserver anlegen könnte.

```text
doku/
  00-uebersicht/
    README.md
    glossar.md
  10-systeme/
    shop/
      architektur.md
      konfiguration-referenz.md
      runbook-neustart.md
    datenbank/
      architektur.md
      runbook-restore.md
  20-prozesse/
    release-freigabe.md
    stoerungsmanagement.md
  90-archiv/
```

Die Nummernpräfixe (00, 10, 20, 90) erzwingen eine feste Reihenfolge in jedem Dateimanager. Die Gliederung auf erster Ebene folgt dem Gegenstand (Übersicht, Systeme, Prozesse, Archiv). Innerhalb jedes Systems wiederholt sich dieselbe Struktur: `architektur`, `konfiguration-referenz`, `runbook-...`. Wer ein System kennt, findet daher das gleiche Muster bei jedem anderen wieder. Der Ordner `90-archiv` ist wichtig, weil überholte Dokumente nicht gelöscht, aber aus der aktiven Suche genommen werden sollen.

Typische Fehler sind das Nachbauen der Organisationsstruktur („Ordner Abteilung A, Abteilung B“), die sich bei jeder Umorganisation ändert, und „Sonstiges“-Ordner, die zum Sammelbecken werden. Ebenso problematisch sind inkonsistente Benennungen, bei denen dieselbe Sache mal „Backup“, mal „Sicherung“ und mal „Datensicherung“ heißt, sodass keine Suche alle Treffer liefert.

| **Falsch** | **Richtig** |
|:-----------|:------------|
| `Abteilung-IT/Neu/Sonstiges/Kopie von Anleitung final2.docx`   | `doku/10-systeme/shop/runbook-neustart.md`    |

Im Projekt wird Informationsarchitektur akut, wenn zwei Teams ihre Dokumentation zusammenführen müssen oder ein neues Wiki eingeführt wird. Dann entscheidet sich, ob die neue Plattform ein weiterer Ort für Unauffindbares wird oder tatsächlich Wissen zugänglich macht.

## 1.5 Qualitätskriterien

Wann ist Dokumentation „gut“? Ohne Maßstab bleibt diese Frage Geschmackssache. Die Qualitätskriterien geben einen gemeinsamen Maßstab, mit dem man Dokumente schreibt, prüft und freigibt. Hier lernen Sie die Grundkriterien kennen; die Ausarbeitung zu Standards, Templates und prüfbaren Checklisten erfolgt in Modul 07, Abschnitt Qualitätskriterien.

Sechs Kriterien haben sich in der Praxis bewährt. **Richtigkeit:** Der Inhalt stimmt mit dem tatsächlichen Zustand überein. **Vollständigkeit:** Alles, was für den Zweck nötig ist, steht da, und zwar nicht mehr, nicht weniger. **Verständlichkeit:** Die Zielgruppe versteht den Text ohne Rückfragen. **Aktualität:** Das Dokument ist nach dem letzten relevanten Wandel des Systems geprüft worden. **Auffindbarkeit:** Das Dokument liegt dort, wo man es erwartet, und trägt Titel und Schlagworte, die zur Suche passen. **Nachvollziehbarkeit:** Es ist ersichtlich, wer es wann freigegeben hat und was sich geändert hat.

Wichtig ist, dass die Kriterien zueinander in Spannung stehen. Vollständigkeit lässt Texte länger werden, was die Verständlichkeit gefährdet. Hohe Aktualität kostet Pflegeaufwand, der gegen den Nutzen abzuwägen ist. Gute Dokumentation ist daher nicht „maximal“, sondern „angemessen“: Ein Notfall-Runbook muss kurz und fehlerfrei sein, eine Architekturentscheidung darf ausführlicher begründet sein.

Das folgende Skript zeigt, wie sich zumindest das Kriterium Aktualität messbar machen lässt. Es prüft in einem Dokumentenverzeichnis, ob das im Dokument vermerkte Datum (Zeile `**Stand:** JJJJ-MM-TT`) älter als eine vorgegebene Anzahl von Tagen ist.

```python
import re, sys, pathlib
from datetime import date, timedelta

MAX_ALTER_TAGE = 180
muster = re.compile(r"^\*\*Stand:\*\* (\d{4})-(\d{2})-(\d{2})", re.M)
grenze = date.today() - timedelta(days=MAX_ALTER_TAGE)
veraltet = 0

for pfad in pathlib.Path(sys.argv[1]).rglob("*.md"):
    treffer = muster.search(pfad.read_text(encoding="utf-8"))
    if not treffer:
        print(f"OHNE STAND  {pfad}")
        veraltet += 1
        continue
    stand = date(*map(int, treffer.groups()))
    if stand < grenze:
        print(f"VERALTET    {pfad} ({stand})")
        veraltet += 1

print(f"{veraltet} Dokument(e) auffällig")
sys.exit(1 if veraltet else 0)
```

Das Skript durchsucht rekursiv (`rglob`) alle Markdown-Dateien. Der reguläre Ausdruck liest Jahr, Monat und Tag aus; `date(*map(int, ...))` wandelt die drei Textteile in ein Datum um. Dokumente ohne Datum werden ebenfalls gemeldet, denn fehlende Angaben sind ein eigener Qualitätsmangel. Am Ende gibt das Programm die Anzahl der Auffälligkeiten aus und liefert einen Fehlercode zurück, womit die Prüfung automatisierbar wird.

Typische Fehler: Qualität wird erst am Schluss „draufgeprüft“ statt von Beginn an eingebaut. Außerdem werden Kriterien so vage formuliert („gut verständlich“), dass zwei Prüfer zu gegensätzlichen Urteilen kommen. Besser sind beobachtbare Kriterien wie „jeder Schritt enthält genau eine Handlung“ oder „jeder Befehl ist kopierbar“.

| **Falsch**                      | **Richtig**                                                                                                     |
|:--------------------------------|:----------------------------------------------------------------------------------------------------------------|
| Prüfvermerk: „Dokument ist ok.“ | Prüfvermerk: „Schritte 1 bis 7 auf Testsystem nachvollzogen am 2026-10-12, Befehle korrekt, Schritt 5 ergänzt.“ |

Im Projekt zeigt sich Qualität an der Frage, ob jemand dem Dokument unter Druck vertraut. Ein einziger falscher Befehl in einem Runbook kostet mehr Vertrauen, als zehn korrekte aufbauen.

## 1.6 Rechtliche Grundlagen

Technische Dokumentation ist an vielen Stellen nicht nur eine gute Idee, sondern Pflicht. Dieser Abschnitt gibt einen Überblick über die wichtigsten Rechts- und Normenquellen, ordnet sie ein und zeigt, wie sie sich in den Dokumentationsalltag übersetzen. Er ist *keine Rechtsberatung*: Für verbindliche Auskünfte ist im Einzelfall juristischer Rat einzuholen.

Man unterscheidet grob drei Ebenen. Erstens *Gesetze und Verordnungen*, die Dokumentation direkt verlangen: Die Datenschutz-Grundverordnung (DSGVO) verpflichtet Verantwortliche zur Führung eines Verzeichnisses von Verarbeitungstätigkeiten, und im Produktrecht verlangt etwa die neue EU-Maschinenverordnung eine Betriebsanleitung. Zweitens *Normen und Standards*, die Anforderungen an Form und Inhalt stellen: Die Norm IEC/IEEE 82079-1 regelt die Erstellung von Gebrauchsinformationen, ISO/IEC 27001 verlangt für Informationssicherheits-Managementsysteme „dokumentierte Information“. Drittens *vertragliche und interne Vorgaben*: Kunden fordern in Verträgen bestimmte Dokumente, und das Unternehmen selbst gibt Richtlinien vor.

> **Ergänzung aus der Nachrecherche**
>
> Maschinenverordnung (EU) 2023/1230: Laut IHK Stuttgart wurde sie am 29. Juni 2023 im Amtsblatt veröffentlicht und löst nach einer Übergangszeit von 42 Monaten ab dem 20. Januar 2027 die Maschinenrichtlinie 2006/42/EG ab. Die Betriebsanleitung darf digital bereitgestellt werden, wenn der Zugang auf der Maschine oder Verpackung angegeben ist, ein Format zum Drucken, Herunterladen und Speichern angeboten wird und die Anleitung für die erwartete Lebensdauer, mindestens aber zehn Jahre nach dem Inverkehrbringen, online verfügbar bleibt. Verlangen Käufer eine Papierversion, ist diese innerhalb eines Monats kostenlos zu liefern. Für IT-Dokumentation ist die Maschinenverordnung nur mittelbar relevant, zeigt aber den Trend: Dokumentation wird zur Lieferpflicht mit Mindestaufbewahrung.

> **Ergänzung aus der Nachrecherche**
>
> DSGVO Art. 30 (Verzeichnis von Verarbeitungstätigkeiten): Nach Darstellung von secjur müssen Verantwortliche und Auftragsverarbeiter ein solches Verzeichnis führen. Für Verantwortliche gehören dazu Zwecke, Betroffenen- und Datenkategorien, Empfänger, Drittlandübermittlungen, Löschfristen und eine Beschreibung der Schutzmaßnahmen. Die Ausnahme für Unternehmen unter 250 Beschäftigten greift nur bei dreifach erfüllten Bedingungen und „praktisch fast nie“. Ein bestimmtes Format ist nicht vorgeschrieben, eine vollständige und aktuelle Tabelle genügt. (Keine Rechtsberatung.)

> **Ergänzung aus der Nachrecherche**
>
> ISO/IEC 27001, Klausel 7.5 (dokumentierte Information): Laut Advisera müssen Dokumente eindeutig gekennzeichnet, passend formatiert, geprüft und freigegeben werden; zu steuern sind Verteilung, Zugriff, Nutzung, Aufbewahrung und Aussonderung. Veraltete Dokumente sind aus dem Umlauf zu nehmen, Verantwortliche für Aktualisierungen zu benennen. Fehlen die geforderten Nachweise, gilt das als Nichtkonformität. Das deckt sich mit dem, was dieser Kurs als Governance bezeichnet.

Die Norm IEC/IEEE 82079-1:2019 enthält laut IEC-Webshop allgemeine Grundsätze und detaillierte Anforderungen für Entwurf und Formulierung aller Arten von Gebrauchsinformationen und gilt für Produkte vom Farbeimer bis zur Industrieanlage. Sie ist eine horizontale Norm, die erst wirkt, wenn eine konkrete Publikation sie referenziert.

Wie übersetzt man das in den Alltag? Am besten über eine *Anforderungszuordnung*: Man hält fest, welche externe Vorgabe welches Dokument verlangt und wer es verantwortet. So wird im Audit sichtbar, dass Vorgaben nicht nur bekannt sind, sondern erfüllt werden. Das Beispiel zeigt eine solche Zuordnung als YAML.

```yaml
anforderungen:
  - quelle: DSGVO Art. 30
    dokument: Verzeichnis von Verarbeitungstätigkeiten
    owner: Datenschutzbeauftragte
    pruefung: jährlich
  - quelle: ISO 27001 Klausel 7.5
    dokument: Richtlinie Dokumentenlenkung
    owner: ISMS-Manager
    pruefung: jährlich
  - quelle: Kundenvertrag Projekt Alpha
    dokument: Betriebshandbuch Alpha
    owner: Service Owner Alpha
    pruefung: bei jedem Release
```

Jede Zeile beantwortet vier Fragen: Woher kommt die Pflicht (`quelle`), welches Dokument erfüllt sie (`dokument`), wer ist verantwortlich (`owner`), und wie oft wird geprüft (`pruefung`). Das Muster ist deshalb nützlich, weil es die abstrakte Rechtspflicht in einen konkreten, steuerbaren Eintrag verwandelt, den man jedem Prüfer zeigen kann.

Typische Fehler: Rechtliche Anforderungen werden erst bei einem Audit entdeckt, weil niemand sie zuvor gesammelt hat. Ein zweiter Fehler ist das „Überdokumentieren“ aus Angst, etwa das Erfassen personenbezogener Daten in Wikis, wo sie nicht hingehören. Ein dritter ist die Annahme, eine Pflicht gelte nicht, weil man „klein“ sei; die Ausnahmen sind in der Regel enger, als man denkt.

| **Falsch**                                                                            | **Richtig**                                                                                                      |
|:--------------------------------------------------------------------------------------|:-----------------------------------------------------------------------------------------------------------------|
| Zugangsdaten und Mitarbeiternamen mit privater Telefonnummer im offenen Wiki ablegen. | Zugangsdaten im Passwortmanager, im Dokument nur der Verweis; Kontakt über Rollenpostfach statt privater Nummer. |

Im Projekt tritt das Rechtliche meist über Dritte auf: Ein Kunde bringt einen Fragebogen mit, eine Auditorin kündigt sich an, die Datenschutzbeauftragte fragt nach dem Verzeichnis. Wer die Zuordnung vorbereitet hat, beantwortet das in Minuten statt Wochen. Die vertiefte Behandlung von Datenschutz, Klassifizierung und Aufbewahrung folgt in Modul 13.

## 1.7 Dokumentationslebenszyklus

Dokumente entstehen nicht aus dem Nichts, und sie verschwinden nicht von allein. Wie jedes Betriebsmittel durchlaufen sie einen *Lebenszyklus*, und dieser muss gesteuert werden. Wer ihn nicht steuert, erlebt das typische Bild: Ein Wiki, das nach zwei Jahren hunderte Seiten enthält, von denen niemand weiß, welche noch stimmen.

Ein praxistauglicher Lebenszyklus kennt sechs Phasen. In der *Planung* wird festgelegt, welches Dokument mit welchem Zweck, für wen und von wem entstehen soll. In der *Erstellung* schreibt der Autor nach Vorlage und Standard. In der *Prüfung* kontrolliert ein zweiter Mensch Richtigkeit und Verständlichkeit (Vier-Augen-Prinzip). In der *Freigabe* bestätigt eine verantwortliche Stelle, dass das Dokument gültig ist, und vergibt einen Status. In der *Nutzung und Pflege* wird es gelesen, ergänzt, bei Änderungen am System angepasst und regelmäßig überprüft. In der *Archivierung oder Löschung* wird es schließlich außer Kraft gesetzt, aufbewahrt oder entfernt, je nach Vorgabe.

Diese Phasen lassen sich mit Dokumentenstatus abbilden, die im Dokument selbst oder in den Metadaten stehen. Typische Status sind *Entwurf*, *In Prüfung*, *Freigegeben*, *Überprüfung fällig* und *Archiviert*. Das folgende Beispiel zeigt einen Kopfblock eines Dokuments in YAML, wie er in vielen Docs-as-Code-Umgebungen üblich ist, und ein kleines Skript, das erlaubte Statusübergänge erzwingt.

```markdown
---
titel: Runbook Neustart Shop-Dienst
status: freigegeben
version: 1.3
owner: Team Betrieb
stand: 2026-10-01
naechste_pruefung: 2027-04-01
---
```

```python
ERLAUBT = {
    "entwurf": {"in_pruefung"},
    "in_pruefung": {"entwurf", "freigegeben"},
    "freigegeben": {"ueberpruefung_faellig", "archiviert"},
    "ueberpruefung_faellig": {"freigegeben", "archiviert"},
    "archiviert": set(),
}

def wechsel(alt, neu):
    if neu not in ERLAUBT.get(alt, set()):
        raise ValueError(f"Ungültiger Übergang: {alt} -> {neu}")
    return neu

status = "entwurf"
status = wechsel(status, "in_pruefung")
status = wechsel(status, "freigegeben")
print("Aktueller Status:", status)
# wechsel("entwurf", "freigegeben") würde einen Fehler auslösen
```

Der Kopfblock enthält alles, was für die Steuerung nötig ist: Status, Version, Owner, das Datum des letzten Stands und das Datum der nächsten Prüfung. Das Skript bildet die Phasen als Zustandsautomat ab. Das Wörterbuch `ERLAUBT` legt fest, von welchem Status aus welche Folgestatus möglich sind. Ein Dokument kann nicht direkt vom Entwurf zur Freigabe springen, weil die Prüfung dazwischen liegen muss. Der Aufruf mit `wechsel` löst bei einem unzulässigen Sprung einen Fehler aus. Auch wenn Sie in Ihrer Umgebung keinen Code ausführen, zeigt das Modell, was ein gutes Freigabeverfahren leisten muss: Es muss Abkürzungen verhindern.

Typische Fehler: Es gibt nur zwei Zustände, „existiert“ und „existiert nicht“. Dokumente haben kein Prüfdatum, sodass niemand erkennt, wann sie zuletzt zutrafen. Außerdem werden überholte Dokumente nie archiviert, sondern bleiben „zur Sicherheit“ im Suchindex und führen Leser in die Irre.

| **Falsch**                                                                       | **Richtig**                                                                                                                                   |
|:---------------------------------------------------------------------------------|:----------------------------------------------------------------------------------------------------------------------------------------------|
| Alte Anleitung bleibt unverändert im Wiki; die neue steht daneben, ohne Hinweis. | Alte Anleitung bekommt den Status „Archiviert“ und einen Verweis „Ersetzt durch: Runbook Neustart v2“; sie erscheint nicht mehr in der Suche. |

Im Projekt ist der Lebenszyklus der Grund, warum Dokumentation nicht beim Go-live endet. Nach Modul 10 (Versionierung, Review) und Modul 14 (Lifecycle Management) werden die einzelnen Phasen vertieft.

## 1.8 Grundlagen-Troubleshooting

Selbst eine gut begonnene Dokumentation läuft in typische Störungen. Dieser Abschnitt vermittelt eine systematische Methode, Fehlerbilder einzugrenzen und daraus Maßnahmen abzuleiten, die sich als Runbook-Schritte für Redaktion, Fachbereich und Betrieb festhalten lassen. Der Grundgedanke: Behandeln Sie schlechte Dokumentation wie einen technischen Störfall. Man beginnt mit dem Symptom, grenzt Ursachen ein und beseitigt sie gezielt.

Die häufigsten Symptome lassen sich vier Ursachenfeldern zuordnen. *„Niemand liest es“* deutet auf Probleme der Struktur oder Auffindbarkeit oder auf eine verfehlte Zielgruppe. *„Es stimmt nicht mehr“* deutet auf Probleme der Aktualität, also auf fehlende Pflege, fehlende Verantwortliche oder fehlende Kopplung an Änderungen. *„Es versteht keiner“* deutet auf Stil, Vorwissen oder Aufbau. *„Es gibt fünf Versionen“* deutet auf fehlende Single Source of Truth oder fehlende Versionierung.

Das Vorgehen lässt sich in vier Schritten festhalten: Symptom erfassen (Wer meldet was, wann?), Ursachenfeld bestimmen, Gegenprobe durchführen (kurzes Gespräch mit zwei Betroffenen oder Blick in Zugriffsstatistik und Review-Kommentare) und Maßnahme mit Verantwortlichem festlegen. Die Gegenprobe ist entscheidend, weil Vermutungen über die Ursache häufig falsch sind. Das nächste Beispiel zeigt ein Troubleshooting-Runbook im Markdown-Format, wie man es in der Redaktion ablegen würde.

```markdown
# Runbook: Dokument wird nicht genutzt

**Owner:** Redaktion  **Stand:** 2026-10-01

## Symptom
Beschwerde "Das findet man nicht" oder niedrige Zugriffszahlen.

## Schritte
1. Suchbegriff der Meldenden im Wiki eingeben. Wird das
   Dokument unter den ersten 5 Treffern angezeigt?
   - Nein: Titel und Schlagworte anpassen (Schritt 2).
   - Ja: weiter mit Schritt 3.
2. Titel um den Begriff ergänzen, den Nutzer verwenden.
   Neue Schlagworte setzen. Suche erneut testen.
3. Zwei Nutzer aus der Zielgruppe fragen: Was haben Sie
   erwartet? Wo sind Sie hängengeblieben?
4. Ergebnis im Verbesserungsbacklog festhalten.

## Eskalation
Wiederholte Fälle: Informationsarchitektur prüfen (Redaktionsleitung).
```

Das Runbook folgt dem Muster jeder guten Handlungsanweisung: ein benannter Anlass („Symptom“), nummerierte Schritte mit klaren Verzweigungen („Nein“/„Ja“), ein nachvollziehbares Ergebnis und ein Eskalationsweg. Die Verzweigung in Schritt 1 zeigt, wie man aus einem Problem zwei verschiedene Folgewege ableitet, statt immer dasselbe Mittel anzuwenden.

Die häufigsten Fehler beim Troubleshooting selbst sind: sofort neu schreiben, statt die Ursache zu klären (das Ergebnis scheitert dann am selben Problem), und Maßnahmen ohne Verantwortlichen zu beschließen. Ebenfalls verbreitet ist das „Einmalaufräumen“: Eine Aktion bereinigt das Wiki, aber ohne Ursachenbehebung ist es nach einem Jahr wieder so schlimm wie zuvor.

| **Falsch**                                                                              | **Richtig**                                                                                                                              |
|:----------------------------------------------------------------------------------------|:-----------------------------------------------------------------------------------------------------------------------------------------|
| „Die Seite wird nicht gelesen, also schreiben wir sie neu und formatieren sie schöner.“ | „Die Seite wird nicht gelesen. Wir prüfen zuerst, ob sie über die Suche auffindbar ist, und fragen zwei Nutzer, bevor wir etwas ändern.“ |

Im Projekt hilft die Methode vor allem Redaktionsteams und Service Ownern, weil sie Diskussionen in überprüfbare Schritte übersetzt. Weitere Troubleshooting-Abschnitte in den Modulen 02 bis 17 greifen dasselbe Muster mit modulspezifischen Symptomen auf.

## 1.9 Dokumentations-Governance-Überblick

Bis hierher ging es um das, was Dokumentation *ist*. Dokumentations-Governance beantwortet die Frage, wie man sicherstellt, dass sie *verlässlich bleibt*, auch wenn Teams, Systeme und Werkzeuge sich ändern. Der Begriff stammt aus der allgemeinen Governance-Lehre (Steuerung und Überwachung von Organisationen) und wird hier auf Dokumentation angewandt. Die Definition lautet: **Dokumentations-Governance ist der Steuerungsrahmen aus Regeln, Rollen, Prozessen und Kennzahlen, der festlegt, wie Dokumentation entsteht, geprüft, freigegeben, gepflegt und außer Dienst gestellt wird.**

Ein Beispiel verdeutlicht den Unterschied. Eine Kollegin schreibt ein sehr gutes Runbook; das ist Dokumentation. Governance ist die Antwort auf die Fragen, wer dieses Runbook überhaupt schreiben *muss*, nach welchem Muster, wer es prüft, wer es freigibt, wo es abgelegt wird, wie lange es gültig ist, was passiert, wenn das System sich ändert, und woran man merkt, dass es nicht mehr stimmt. Ohne diese Antworten hängt Qualität an Einzelpersonen und kippt, sobald diese die Firma verlassen.

Ein tragfähiger Governance-Rahmen besteht aus sieben Bausteinen, die in den folgenden Modulen einzeln behandelt werden: *Strategie* (Ziele, Zielgruppen, Umfang), *Rollen* (Owner, Autor, Reviewer, Approver), *Standards und Templates*, *Prozesse* (Erstellung, Review, Freigabe, Änderung), *Werkzeuge* (Ablageorte, Versionierung), *Compliance* (Datenschutz, Sicherheit, Aufbewahrung) und *Steuerung* (Kennzahlen, Audits, Verbesserung). Jeder Baustein ist für sich nützlich, die Wirkung entsteht aber durch das Zusammenspiel.

Als Beispiel zeigt die folgende Tabelle, wie sich ein Governance-Rahmen in einer einzigen Seite zusammenfassen lässt (ein sogenanntes *Governance-Statement*, das in vielen Organisationen als Einstieg dient). Als Markdown ist es in jedem Wiki darstellbar.

```markdown
# Dokumentations-Governance - Kurzfassung

| Baustein   | Regel                                           |
|------------|-------------------------------------------------|
| Ownership  | Jedes Dokument hat genau einen Owner.           |
| Standard   | Neue Dokumente nutzen das Template der Art.     |
| Review     | Vier-Augen-Prinzip vor jeder Freigabe.          |
| Ablage     | Nur in doku/ (Git) oder im zentralen Wiki.      |
| Aktualität | Prüfung mindestens alle 12 Monate.              |
| Schutz     | Keine Zugangsdaten und keine Klarnamen privat.  |
| Steuerung  | Quartalsbericht: Abdeckung, Aktualität, Lücken. |
```

Jede Zeile ist eine überprüfbare Regel, die nach dem Muster „wer, was, wie oft“ formuliert ist. Das ist die Mindestqualität eines Governance-Textes: Wer ihn liest, soll in einem Satz wissen, was er zu tun hat, und ein Auditor soll in einem Satz prüfen können, ob es getan wurde. Auffällig ist die Kürze: Eine Governance-Kurzfassung ersetzt nicht die ausführlichen Richtlinien, macht sie aber handhabbar.

Typische Fehler bei der Einführung sind drei. Erstens wird Governance als Bürokratie wahrgenommen, wenn sie ohne Nutzenargument auferlegt wird. Zweitens werden zu viele Regeln auf einmal eingeführt, und niemand befolgt sie. Drittens bleibt sie auf dem Papier, weil niemand ihre Einhaltung prüft.

| **Falsch**                                                                  | **Richtig**                                                                                          |
|:----------------------------------------------------------------------------|:-----------------------------------------------------------------------------------------------------|
| Eine 40-seitige Richtlinie, die niemand kennt, ohne Owner und ohne Prüfung. | Eine einseitige Kurzfassung mit sieben Regeln, benannten Verantwortlichen und einem Quartalsbericht. |

Im Projekt ist Governance oft der Hebel, der aus „alle schreiben irgendwas“ ein verlässliches System macht. Sie beginnt klein: mit einem Owner pro Dokument und einem Prüfdatum.

## 1.10 Governance vs Dokumentation

Die beiden Begriffe werden im Alltag gern verwechselt oder gegeneinander ausgespielt. „Wir haben doch Dokumentation, wozu noch Governance?“ oder umgekehrt „Wir haben Regeln, da muss nicht mehr jeder dokumentieren.“ Beide Aussagen verkennen, dass es sich um zwei verschiedene Ebenen handelt, die einander bedingen.

Dokumentation ist das *Objekt*: der Inhalt, den Menschen lesen und nutzen. Governance ist das *Steuerungssystem*, das sich um diese Objekte kümmert. Man kann das Verhältnis mit einer Bibliothek vergleichen. Die Bücher entsprechen der Dokumentation, die Katalogisierung, die Ausleihordnung, die Regeln zum Aussortieren und die Verantwortung der Bibliothekare entsprechen der Governance. Eine Bibliothek ohne Bücher ist sinnlos, aber eine Büchersammlung ohne Katalog ist nur ein Haufen.

Es hilft, die Unterschiede entlang einiger Fragen zu betrachten. Bei der Dokumentation lautet die Kernfrage „Was steht drin, und stimmt es?“, bei der Governance „Wer ist dafür verantwortlich, nach welcher Regel, und wie prüfen wir es?“. Dokumentation wird von Fachleuten verfasst, Governance wird von der Organisation gesetzt. Dokumentation ändert sich mit dem System, Governance ändert sich seltener und bewusst. Der Erfolg der Dokumentation zeigt sich in der Nutzbarkeit, der Erfolg der Governance in der Verlässlichkeit über die Zeit.

Die folgende Gegenüberstellung hält das in einer Tabelle fest. Sie ist als LaTeX-Tabelle mit `booktabs` gesetzt, wie Sie sie selbst in Skripten verwenden können.

```text
\begin{tabularx}{\linewidth}{@{}lXX@{}}
\toprule
 & Dokumentation & Governance \\
\midrule
Frage & Was steht drin? & Wer, wie, wie oft? \\
Ergebnis & Dokument & Regelwerk, Rollen \\
Wirkung & Nutzbarkeit & Verlässlichkeit \\
\bottomrule
\end{tabularx}
```

Der Code zeigt die Grundform einer professionellen Tabelle: `booktabs` liefert die Linien `\toprule`, `\midrule` und `\bottomrule`, die typografisch sauberer sind als Gitternetze. Der Spaltentyp `X` aus `tabularx` verteilt den restlichen Platz gleichmäßig. Das Muster ist in diesem Skript durchgängig verwendet.

Typische Fehler: Ein Team „löst“ ein Dokumentationsproblem, indem es mehr Dokumente schreibt, obwohl das Problem organisatorisch ist (kein Owner, keine Prüfung). Umgekehrt entstehen Governance-Frameworks, die an Inhalten vorbeigehen: perfekte Freigabeprozesse für Dokumente, die niemand braucht. Beides lässt sich vermeiden, wenn man bei jedem Problem fragt, auf welcher Ebene es liegt.

| **Falsch**                                                                             | **Richtig**                                                                                                                                            |
|:---------------------------------------------------------------------------------------|:-------------------------------------------------------------------------------------------------------------------------------------------------------|
| Problem: Runbooks sind veraltet. Maßnahme: ein Wochenende alle Runbooks neu schreiben. | Problem: Runbooks sind veraltet. Ursache: kein Owner, keine Prüffrist. Maßnahme: Owner benennen, Prüffrist im Dokumentkopf, Erinnerung automatisieren. |

Im Projekt trifft man diese Verwechslung typischerweise bei Budgetentscheidungen: Wer nur Inhalte finanziert, bekommt kurzfristig Dokumente und langfristig Verfall. Wer nur Governance finanziert, bekommt Prozesse ohne Inhalt. Nachhaltigkeit entsteht erst, wenn beides zusammenwirkt.

## 1.11 Ziele und Nutzen

Eine Organisation investiert Zeit und Geld in Dokumentations-Governance, wenn sie ihren Nutzen erkennt. Deshalb sollte jede Einführung mit klaren Zielen beginnen, die sich später messen lassen. Hier sind die wichtigsten Ziele und die zugehörigen Nutzenargumente zusammengefasst.

Das erste Ziel ist *Betriebssicherheit*: Systeme sollen auch ohne Spezialisten betreibbar und wiederherstellbar sein. Der Nutzen liegt in kürzeren Störungszeiten und geringerer Abhängigkeit von Einzelpersonen (der sogenannte „Bus-Faktor“: Wie viele Personen dürfen ausfallen, bevor das Wissen fehlt?). Das zweite Ziel ist *Effizienz*: Wissen soll schneller gefunden und wiederverwendet werden. Der Nutzen sind weniger Rückfragen, kürzere Einarbeitung und geringere Suchzeiten. Das dritte Ziel ist *Compliance*: Vorgaben aus Recht, Normen und Verträgen sollen nachweisbar erfüllt sein. Der Nutzen ist geringeres Prüfungsrisiko und weniger Aufwand bei Audits. Das vierte Ziel ist *Qualität und Konsistenz*: Dokumente sollen einheitlich, richtig und aktuell sein. Der Nutzen ist Vertrauen der Leser. Das fünfte Ziel ist *Wissenssicherung*: Erfahrungswissen soll im Unternehmen bleiben. Der Nutzen sind weniger Verluste bei Personalwechsel.

Ziele sind nur dann steuerbar, wenn sie messbar formuliert werden. Das gelingt mit Kennzahlen (KPIs), die in Modul 16 ausführlich behandelt werden. Dennoch lohnt sich ein erster Blick: Eine einfache Rechnung zeigt den Nutzen, auch wenn sie nur grob ist. Das folgende Skript berechnet die jährlichen Kosten durch Suchzeiten und die Einsparung durch eine Verbesserung. Die Zahlen darin sind Platzhalter, die Sie durch eigene Werte ersetzen müssen; sie sind keine Belege für allgemeine Durchschnittswerte.

```python
mitarbeitende = 40          # Annahme: Anzahl Nutzer der Doku
suche_min_pro_tag = 20      # Annahme: Minuten Suchzeit pro Tag
verbesserung = 0.25         # Annahme: 25 Prozent weniger Suche
stundensatz = 70            # Annahme: interne Kosten pro Stunde
arbeitstage = 220

stunden_gesamt = mitarbeitende * suche_min_pro_tag / 60 * arbeitstage
kosten = stunden_gesamt * stundensatz
ersparnis = kosten * verbesserung

print(f"Suchzeit pro Jahr: {stunden_gesamt:.0f} Stunden")
print(f"Kosten: {kosten:,.0f} Euro")
print(f"Mögliche Ersparnis: {ersparnis:,.0f} Euro")
```

Die ersten fünf Zeilen sind Annahmen, die jede Organisation selbst bestimmen muss. Daraus werden zuerst die jährlichen Suchstunden, dann die Kosten und schließlich die mögliche Ersparnis berechnet. Mit den Beispielwerten ergeben sich rund 2933 Suchstunden, etwa 205,333 Euro Kosten und rund 51,333 Euro Ersparnis (die Ausgabe verwendet das englische Tausendertrennzeichen). Wichtig ist nicht die genaue Zahl, sondern die Methode: Sie macht eine Behauptung („Dokumentation lohnt sich“) zu einer überprüfbaren Aussage, die man mit echten Messwerten untermauern kann.

Typische Fehler: Der Nutzen wird nur qualitativ beschrieben („verbessert die Zusammenarbeit“), sodass kein Budgetgeber überzeugt wird. Zudem werden Ziele und Maßnahmen verwechselt: „Wir führen ein Wiki ein“ ist eine Maßnahme, kein Ziel. Das Ziel wäre „neue Admins arbeiten nach 4 Wochen selbständig“.

| **Falsch**                                | **Richtig**                                                                                                              |
|:------------------------------------------|:-------------------------------------------------------------------------------------------------------------------------|
| Ziel: „Wir wollen bessere Dokumentation.“ | Ziel: „Bis Ende Q2 haben alle kritischen Systeme ein geprüftes Runbook, und die Aktualitätsquote liegt über 90 Prozent.“ |

Im Projekt entscheidet die Formulierung der Ziele darüber, ob Governance Unterstützung bekommt. Wer dem Management die Ersparnis oder das Risiko in Zahlen darlegt, hat deutlich bessere Karten als jemand, der „Qualität“ verspricht.

## 1.12 Rollen und Verantwortlichkeiten

Regeln ohne Verantwortliche bleiben wirkungslos. Dokumentations-Governance weist daher jedem Dokument und jeder Phase Rollen zu. Dieser Abschnitt stellt die Grundrollen vor; die detaillierte Ausgestaltung mit RACI-Matrix, Eskalation und Vertretung folgt in Modul 06 (Abschnitte Document Owner bis Vertretungsregelung).

Vier Rollen bilden den Kern. Der *Document Owner* trägt die Gesamtverantwortung für ein Dokument: Er stellt sicher, dass es existiert, aktuell bleibt und seinem Zweck dient. Der *Autor* schreibt oder ändert das Dokument. Der *Reviewer* prüft Inhalt und Verständlichkeit fachlich. Der *Approver* gibt das Dokument formal frei und bestätigt damit seine Gültigkeit. Daneben gibt es unterstützende Rollen wie die *Redaktion* (sprachliche und formale Qualität, Templates), den *Service Owner* (Verantwortung für ein System und damit für dessen Dokumentation), die *Datenschutz- und Security-Beauftragten* (Prüfung sensibler Inhalte) und den *Governance-Verantwortlichen* (Pflege der Regeln und Berichte).

Wichtig ist die Trennung von Rollen und Personen. Eine Rolle kann von einer Person oder einem Team ausgefüllt werden, und eine Person kann mehrere Rollen haben. Bei kleinen Teams ist Owner und Autor häufig dieselbe Person, nur Reviewer und Approver sollten nach dem Vier-Augen-Prinzip unterschiedliche Personen sein. Damit der Ausfall einer Person nicht alles blockiert, braucht jede Rolle eine Vertretung.

Das folgende Beispiel zeigt, wie sich Rollen direkt im Dokument festhalten lassen, indem man sie als Metadaten ablegt und mit einem kleinen Skript auf Vollständigkeit prüft.

```python
import re, sys

ROLLEN = ["owner", "autor", "reviewer", "approver"]

def lese_kopf(text):
    block = re.match(r"---\n(.*?)\n---", text, re.S)
    if not block:
        return {}
    kopf = {}
    for zeile in block.group(1).splitlines():
        if ":" in zeile:
            schluessel, wert = zeile.split(":", 1)
            kopf[schluessel.strip()] = wert.strip()
    return kopf

kopf = lese_kopf(open(sys.argv[1], encoding="utf-8").read())
fehlt = [r for r in ROLLEN if not kopf.get(r)]
if kopf.get("reviewer") and kopf.get("reviewer") == kopf.get("autor"):
    fehlt.append("reviewer ungleich autor")
print("OK" if not fehlt else "Fehlt: " + ", ".join(fehlt))
```

Die Funktion `lese_kopf` liest den Metadatenblock zwischen den beiden `---`-Zeilen und zerlegt jede Zeile am ersten Doppelpunkt in Schlüssel und Wert. Anschließend wird geprüft, ob alle vier Rollen belegt sind, und zusätzlich, ob Reviewer und Autor verschiedene Personen sind. Damit wird das Vier-Augen-Prinzip nicht nur gefordert, sondern prüfbar gemacht.

Typische Fehler: „Alle sind verantwortlich“, was in der Praxis bedeutet, dass es niemand ist. Ebenso problematisch sind Owner, die weder Zeit noch Befugnis haben, und Rollen, die nur im Handbuch stehen, aber nicht gelebt werden. Ein Warnzeichen ist es, wenn die Antwort auf die Frage „Wer ist für dieses Dokument zuständig?“ mit einem Achselzucken beginnt.

| **Falsch**            | **Richtig**                                                                              |
|:----------------------|:-----------------------------------------------------------------------------------------|
| Owner: „IT-Abteilung“ | Owner: „Team Plattform (Rollenpostfach plattform@example.org), Vertretung: Team Betrieb“ |

Im Projekt zeigt sich die Rollenklärung beim ersten Streitfall: Wenn zwei Teams dasselbe System dokumentieren, entscheidet die Frage „Wer ist Owner?“, wessen Version gilt.

## 1.13 Einsatzszenarien

Zum Abschluss des Moduls betrachten wir, wo Dokumentations-Governance in der IT- und Projektpraxis konkret ansetzt. Szenarien helfen, die Begriffe der vorangegangenen Abschnitte zu verbinden und zeigen, dass der Aufwand je nach Umgebung sehr unterschiedlich ausfällt.

Im *IT-Betrieb* liegt der Schwerpunkt auf Runbooks, Betriebshandbüchern, Konfigurations- und Notfalldokumentation. Hier wird Dokumentation unter Zeitdruck gelesen, weshalb Richtigkeit und Kürze zählen. Governance sichert vor allem Aktualität und Zugriff: Ein Runbook muss auch dann erreichbar sein, wenn das Wiki selbst ausfällt (Stichwort Offline-Kopie).

In *Projekten* entsteht Dokumentation entlang des Projektverlaufs: Anforderungen, Konzepte, Testprotokolle, Abnahmen, Übergabedokumente. Governance regelt hier, welche Dokumente zu welchem Meilenstein vorliegen müssen und wer sie freigibt. Typischer Stolperstein ist der Projektabschluss, bei dem das Team zum nächsten Vorhaben wechselt und niemand mehr Verantwortung für die Pflege übernimmt. Eine wirksame Gegenmaßnahme ist die Übergabe an einen Service Owner mit einer unterschriebenen Dokumentenliste.

In der *Softwareentwicklung* liegt Dokumentation oft im Repository (Docs-as-Code): README, API-Beschreibungen, Architekturentscheidungen. Governance nutzt hier die Werkzeuge der Entwicklung: Pull Requests als Review, Versionen als Freigabe, automatisierte Prüfungen als Qualitätssicherung. In *regulierten Umfeldern* (Finanzsektor, Gesundheit, kritische Infrastruktur) steht die Nachweisfunktion im Vordergrund; Audit-Trail, Aufbewahrung und Freigabe sind strenger geregelt. In *Migrations- und Konsolidierungsprojekten* geht es darum, gewachsene Dokumentenlandschaften zu bereinigen, wofür Modul 17 Methoden liefert.

Das folgende Beispiel zeigt eine einfache Entscheidungshilfe, die je nach Szenario den passenden Mindestumfang an Governance vorschlägt. Sie ist als Python-Funktion formuliert und lässt sich in Workshops auch als Tabelle verwenden.

```python
def mindestumfang(regulated, kritisch, team_groesse):
    regeln = ["Owner pro Dokument", "Prüfdatum im Dokumentkopf"]
    if kritisch:
        regeln += ["Vier-Augen-Review", "Offline-Kopie der Runbooks"]
    if regulated:
        regeln += ["Freigabeprozess mit Nachweis",
                   "Aufbewahrungsfristen", "Audit-Trail"]
    if team_groesse > 10:
        regeln += ["zentrale Redaktion", "einheitliche Templates"]
    return regeln

for r in mindestumfang(regulated=True, kritisch=True, team_groesse=25):
    print("-", r)
```

Die Funktion beginnt mit einem Basissatz, den jede Organisation braucht (Owner und Prüfdatum). Je nach Randbedingung werden Regeln ergänzt: kritische Systeme verlangen Review und Offline-Kopie, regulierte Umfelder zusätzlich Nachweise, große Teams eine Redaktion. Der Aufruf mit den Beispielwerten gibt alle neun Regeln aus. Der Nutzen liegt in der Botschaft: Governance ist nicht für alle gleich groß, sondern wächst mit Risiko und Größe.

Typische Fehler: Governance aus einem Großunternehmen unverändert auf ein kleines Team zu übertragen, wodurch sie als Last empfunden wird, oder umgekehrt in einem regulierten Umfeld mit improvisierten Regeln zu arbeiten, bis das Audit scheitert. Das richtige Maß findet man, indem man Risiko und Nutzen abwägt.

| **Falsch**                                                                         | **Richtig**                                                                                                                |
|:-----------------------------------------------------------------------------------|:---------------------------------------------------------------------------------------------------------------------------|
| Ein Fünf-Personen-Team führt ein dreistufiges Freigabeverfahren mit Ausschuss ein. | Das Team führt Vier-Augen-Review per Pull Request ein, benennt Owner und prüft einmal pro Quartal die kritischen Runbooks. |

Damit schließt das Modul: Sie kennen Begriff, Zielgruppen, Dokumentarten, Qualität, Rechtsrahmen, Lebenszyklus und die Grundidee der Governance. Die folgenden Module bauen darauf auf und machen aus den Grundlagen ein belastbares System.

## Übungsaufgaben

Die folgenden Aufgaben steigen in der Schwierigkeit an. Die Aufgaben 1 bis 3 prüfen das Verständnis der Begriffe, die Aufgaben 4 bis 6 verlangen Anwendung an Beispielen, die Aufgaben 7 und 8 sind Transferaufgaben, bei denen Sie selbst etwas entwerfen oder programmieren. Lösungen mit Erläuterung folgen im nächsten Abschnitt; versuchen Sie zuerst, jede Aufgabe ohne Blick darauf zu lösen.

**Aufgabe 1.** *(leicht)* Ordnen Sie jede Aussage einer der vier Funktionen von Dokumentation zu (Betrieb, Wartung, Schulung, Nachweis): (a) Eine neue Kollegin richtet allein ihren Arbeitsplatz ein. (b) Ein Auditor verlangt den Beleg, dass Änderungen freigegeben wurden. (c) Ein Entwickler fragt, warum ein Schutzmechanismus so gebaut wurde. (d) Nachts fällt ein Dienst aus, und der Bereitschaftsdienst sucht den Neustart-Befehl.

**Aufgabe 2.** *(leicht)* Erklären Sie in zwei bis drei Sätzen das Prinzip der Single Source of Truth und nennen Sie ein Beispiel aus dem IT-Alltag, bei dem es verletzt wird.

**Aufgabe 3.** *(leicht bis mittel)* Ordnen Sie die folgenden Dokumenttitel den vier Diátaxis-Typen zu und begründen Sie kurz: (a) „Warum wir Container statt virtueller Maschinen nutzen“, (b) „API-Parameter der Schnittstelle Bestellungen“, (c) „Zertifikat erneuern“, (d) „Ihr erstes Deployment in 30 Minuten“.

**Aufgabe 4.** *(mittel)* Erstellen Sie eine Persona (im YAML-Format aus dem Abschnitt Zielgruppenanalyse) für einen neu eingestellten Softwareentwickler, der ein bestehendes System übernimmt. Formulieren Sie zwei konkrete Gestaltungsregeln, die sich aus dem Feld `braucht` ergeben.

**Aufgabe 5.** *(mittel, praktisch)* Schreiben Sie ein Python-Skript, das den Metadatenblock eines Markdown-Dokuments einliest und prüft, ob das Feld `status` einen der erlaubten Werte (`entwurf`, `in_pruefung`, `freigegeben`, `archiviert`) hat. Das Skript soll bei einem ungültigen oder fehlenden Status den Rückgabewert 1 liefern.

**Aufgabe 6.** *(mittel)* Bewerten Sie den folgenden Absatz anhand der sechs Qualitätskriterien und nennen Sie mindestens drei Mängel: „Der Server wird bei Bedarf neu gestartet. Dazu die bekannten Schritte durchführen. Bei Problemen den Admin fragen. (zuletzt bearbeitet: irgendwann 2023)“

**Aufgabe 7.** *(anspruchsvoll)* Erstellen Sie für ein fiktives Unternehmen eine Anforderungszuordnung mit mindestens drei Einträgen (eine gesetzliche Quelle, eine Norm, eine vertragliche Vorgabe) im YAML-Format aus dem Abschnitt Rechtliche Grundlagen. Begründen Sie die gewählten Prüffristen.

**Aufgabe 8.** *(anspruchsvoll, Transfer)* Ein Team mit sechs Personen betreibt einen Online-Shop. Die Runbooks sind veraltet, niemand weiß, welche Version gilt, und neue Kollegen finden nichts. Führen Sie das Troubleshooting-Vorgehen (Symptom, Ursachenfeld, Gegenprobe, Maßnahme) für alle drei Symptome durch und entwerfen Sie eine Governance-Kurzfassung mit höchstens fünf Regeln.

## Lösungen und Erläuterungen

**Lösung zu Aufgabe 1.** (a) Schulung, denn die Kollegin erarbeitet sich Wissen selbst. (b) Nachweis, denn es geht um die Belegbarkeit gegenüber Dritten. (c) Wartung, denn das Warum einer Entscheidung ist für künftige Änderungen entscheidend. (d) Betrieb, denn der Bereitschaftsdienst braucht unter Zeitdruck eine verlässliche Handlungsanweisung. Einige Aussagen berühren mehrere Funktionen; entscheidend ist, die *überwiegende* Funktion benennen zu können.

**Lösung zu Aufgabe 2.** Single Source of Truth bedeutet, dass jede Information an genau einer maßgeblichen Stelle gepflegt wird und andere Stellen nur darauf verweisen. Beispiel für eine Verletzung: Die IP-Adresse eines Servers steht im Netzplan, im Betriebshandbuch und in einer Excel-Liste. Wird der Server umgezogen und nur eine Stelle geändert, widersprechen sich die Dokumente. Erkennen Sie die Verletzung daran, dass bei einer Änderung mehrere Dokumente angepasst werden müssten.

**Lösung zu Aufgabe 3.** (a) Erklärung, weil es um das Warum und die Abwägung geht. (b) Referenz, weil es eine sachliche, vollständige Beschreibung ist. (c) How-to-Guide, weil ein konkretes Ziel erreicht werden soll und Vorwissen vorausgesetzt wird. (d) Tutorial, weil ein Lernender geführt zu einem ersten Erfolg kommt. Merkhilfe: Lernen, Erledigen, Nachschlagen, Verstehen.

**Lösung zu Aufgabe 4.** Eine mögliche Persona:

```yaml
personas:
  - id: dev-neu
    rolle: Softwareentwickler, neu im Team
    vorwissen: Programmiert sicher, kennt das System nicht
    ziel: Das System verstehen und Änderungen sicher vornehmen
    kontext: Schreibtisch, Zeit zum Lesen, lokale Entwicklungsumgebung
    braucht: Architekturüberblick, Begründungen, lauffähiges Setup
```

Gestaltungsregeln, die sich daraus ergeben: Erstens braucht das System eine Erklärung-Seite mit Architekturdiagramm und den wichtigsten Entscheidungen samt Begründung, damit der Entwickler das *Warum* versteht. Zweitens braucht es ein Tutorial „Entwicklungsumgebung aufsetzen“ mit kopierbaren Befehlen und einem Überprüfungsschritt am Ende. Eine falsche Lösung wäre, nur eine Referenz bereitzustellen: Sie hilft erst, wenn man bereits weiß, was man sucht.

**Lösung zu Aufgabe 5.** Eine mögliche Lösung:

```python
import re, sys

ERLAUBT = {"entwurf", "in_pruefung", "freigegeben", "archiviert"}

text = open(sys.argv[1], encoding="utf-8").read()
kopf = re.match(r"---\n(.*?)\n---", text, re.S)
status = None
if kopf:
    for zeile in kopf.group(1).splitlines():
        if zeile.startswith("status:"):
            status = zeile.split(":", 1)[1].strip()

if status in ERLAUBT:
    print("Status gültig:", status)
else:
    print("Status fehlt oder ungültig:", status)
    sys.exit(1)
```

Das Skript sucht den Metadatenblock mit einem regulären Ausdruck, in dem `re.S` bewirkt, dass der Punkt auch Zeilenumbrüche erfasst. Es geht dann Zeile für Zeile vor, bis es `status:` findet. Der Test `status in ERLAUBT` deckt beide Fehlerfälle ab: Ist kein Status vorhanden, bleibt `status` bei `None`, und `None` ist nicht in der Menge. Typische Fehlerquelle: die Datei ohne Metadatenblock; deshalb wird `kopf` vor dem Zugriff geprüft.

**Lösung zu Aufgabe 6.** Mängel: *Richtigkeit/Vollständigkeit* („die bekannten Schritte“ nennt keinen einzigen Schritt; „bei Bedarf“ sagt nicht, wann), *Verständlichkeit* (ohne Vorwissen unbrauchbar), *Aktualität* („irgendwann 2023“ ist kein Datum), *Nachvollziehbarkeit* (kein Autor, kein Reviewer, keine Freigabe), *Auffindbarkeit* (kein Titel, kein System genannt). Die Eskalation „den Admin fragen“ nennt keine Person und keinen Weg. Ein gelungener Neuentwurf enthielte einen Titel, Anlass, nummerierte Schritte mit Befehlen, Eskalationskontakt und Stand.

**Lösung zu Aufgabe 7.** Eine mögliche Lösung:

```yaml
anforderungen:
  - quelle: DSGVO Art. 30
    dokument: Verzeichnis von Verarbeitungstätigkeiten
    owner: Datenschutzbeauftragte
    pruefung: jährlich
  - quelle: ISO/IEC 27001 Klausel 7.5
    dokument: Richtlinie Dokumentenlenkung
    owner: ISMS-Manager
    pruefung: jährlich
  - quelle: Wartungsvertrag Kunde Beta
    dokument: Betriebshandbuch Beta
    owner: Service Owner Beta
    pruefung: bei jedem Release, mindestens halbjährlich
```

Begründung der Fristen: Das Verzeichnis nach DSGVO muss vollständig und aktuell sein, ein jährlicher Zyklus ist üblich, bei neuen Verarbeitungen ist anlassbezogen zu ergänzen. Das ISMS-Dokument wird in der Regel im Jahresrhythmus bewertet. Das Betriebshandbuch ändert sich mit dem System, daher die Kopplung an Releases. Wichtig: Dies ist ein Gestaltungsvorschlag und keine Rechtsberatung; verbindliche Fristen ergeben sich aus der jeweiligen Rechtsgrundlage oder dem Vertrag.

**Lösung zu Aufgabe 8.** Symptom 1 „Runbooks veraltet“: Ursachenfeld Aktualität. Gegenprobe: Stichprobe von drei Runbooks gegen das System testen; gibt es Owner und Prüfdatum? Maßnahme: Owner benennen, Prüfdatum im Kopf, Erinnerung pro Quartal. Symptom 2 „niemand weiß, welche Version gilt“: Ursachenfeld Single Source of Truth und Versionierung. Gegenprobe: Prüfen, ob Kopien in Mail, Share und Wiki existieren. Maßnahme: Eine maßgebliche Ablage festlegen, Kopien ersetzen durch Links, Status „archiviert“ für alte Stände. Symptom 3 „neue Kollegen finden nichts“: Ursachenfeld Informationsarchitektur und Auffindbarkeit. Gegenprobe: zwei neue Kollegen bitten, drei Aufgaben nur mit dem Wiki zu lösen und Hänger zu notieren. Maßnahme: einheitliche Ablagestruktur, sprechende Titel, ein Tutorial „Erste Woche“.

Eine mögliche Governance-Kurzfassung mit fünf Regeln: (1) Jedes Runbook hat genau einen Owner und eine Vertretung. (2) Im Dokumentkopf stehen Status, Version, Stand und nächste Prüfung. (3) Änderungen werden per Vier-Augen-Review freigegeben. (4) Runbooks liegen nur im zentralen Wiki, Kopien sind Links. (5) Der Service Owner prüft kritische Runbooks einmal pro Quartal und berichtet im Teammeeting. Bewertungskriterium für Ihre eigene Lösung: Jede Regel ist überprüfbar und hat einen Verantwortlichen.
