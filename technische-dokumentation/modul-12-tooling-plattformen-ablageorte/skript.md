# Modul 12 - Tooling, Plattformen und Ablageorte

> **Hinweis zu diesem Kapitel:** Das ist das Kapitel des Skripts „Technische Dokumentation und Dokumentations-Governance“, aus der LaTeX-Quelle in Markdown umgewandelt (Text und Listings unverändert, farbige Boxen als Zitatblöcke mit fettem Titel, Tabellen als Markdown-Tabellen, Übungsaufgaben und Lösungen als Absätze). Die Lerneinheiten sind wie in der Quelle nach Modul nummeriert (12.1 bis 12.8), danach folgen „Übungsaufgaben“ (8 Aufgaben) und „Lösungen und Erläuterungen“. Die Sprachangabe der Codeblöcke ist in der Quelle nur für Python und Bash gesetzt; die übrigen Blöcke sind hier nach ihrem Inhalt als `python`, `yaml`, `markdown`, `bash` oder `text` ausgezeichnet, der Inhalt selbst ist unverändert. **Prüfstand der Beispiele für dieses Repository:** Die Python-Beispiele wurden auf Syntax geprüft; welche Beispiele ausgeführt wurden und welche zusätzlich PyYAML brauchen, steht in der [README des Repositories](../README.md). Übersicht zum Modul: [README](README.md).

**Dauer:** 8 Stunden | **Priorität:** 2 | **Lerneinheiten:** 8

| **Nr.** | **Lerneinheit**        | **Dauer (h)** | **Prio** |
|--------:|:-----------------------|--------------:|---------:|
|       1 | Tool Landschaft        |             1 |        1 |
|       2 | SharePoint Bezug       |             1 |        1 |
|       3 | Confluence Bezug       |             1 |        1 |
|       4 | DMS Bezug              |             1 |        1 |
|       5 | Git Docs as Code Bezug |             1 |        1 |
|       6 | Ticket Verknüpfung     |             1 |        2 |
|       7 | Suchbarkeit            |             1 |        2 |
|       8 | Tool-Troubleshooting   |             1 |        2 |
|         | **Summe**              |         **8** |          |

## 12.1 Tool Landschaft

In fast jeder Organisation liegt Dokumentation an mehreren Orten: Richtlinien und Verträge in einem Dokumentenlaufwerk, Betriebsanleitungen in einem Wiki, Schnittstellenbeschreibungen im Code-Repository, Absprachen in Tickets und Chats, und dazu die Ordner und Postfächer einzelner Personen. Diese Mischung nennt man *Tool-Landschaft*. Sie ist selten das Ergebnis eines Plans, sondern entsteht historisch: Jedes Team wählt, was zu seiner Arbeit passt, Werkzeuge werden gekauft, übernommen oder vergessen. Das Problem ist nicht die Vielfalt an sich, denn verschiedene Dokumentarten brauchen verschiedene Werkzeuge. Das Problem entsteht, wenn niemand weiß, *wo welche Information maßgeblich liegt*.

Governance-fähig wird eine Landschaft durch vier Festlegungen. Erstens besitzt jedes Werkzeug einen *Owner*, der es betreibt und für Berechtigungen und Regeln verantwortlich ist. Zweitens ist je Dokumentart ein *maßgebliches System* (englisch „system of record“) bestimmt, in dem die gültige Fassung liegt; alles andere sind Verweise oder Kopien. Drittens gilt für jedes Werkzeug ein Mindeststandard für Metadaten, Berechtigungen, Aufbewahrung und Suchbarkeit. Viertens gibt es einen Weg, Inhalte zwischen den Werkzeugen zu verknüpfen, statt sie zu kopieren. Die folgenden Abschnitte behandeln diese Punkte für die wichtigsten Plattformtypen: SharePoint (Dateiablage mit Metadaten), Confluence (Wiki), ein DMS (Dokumentenmanagementsystem), Git mit Docs-as-Code (Modul 11) und Tickets.

Das folgende Beispiel hält die Landschaft in einer Datei fest und prüft sie auf Lücken. Die Datei listet jedes Werkzeug mit Owner und den Dokumentarten, die dort liegen, und legt darunter fest, welches System je Dokumentart maßgeblich ist. Das Skript meldet Werkzeuge ohne Owner, Dokumentarten ohne maßgebliches System und Dokumentarten, die in mehreren Werkzeugen liegen.

```yaml
tools:
  - {name: SharePoint, owner: IT, dokumentarten: [richtlinie, vertrag, protokoll]}
  - {name: Confluence, owner: Plattform, dokumentarten: [runbook, anleitung, protokoll]}
  - {name: Repo docs, owner: Entwicklung, dokumentarten: [api, anleitung]}
  - {name: Altes Wiki, owner: null, dokumentarten: [anleitung, runbook]}
massgeblich:
  richtlinie: SharePoint
  vertrag: SharePoint
  runbook: Confluence
  api: Repo docs
```

```python
import sys, yaml
from collections import defaultdict

d = yaml.safe_load(open(sys.argv[1], encoding="utf-8"))
massgeblich = d["massgeblich"]
je_art = defaultdict(list)
for t in d["tools"]:
    if not t["owner"]:
        print(f"Tool ohne Owner: {t['name']}")
    for art in t["dokumentarten"]:
        je_art[art].append(t["name"])

for art, tools in sorted(je_art.items()):
    if art not in massgeblich:
        print(f"{art}: kein maßgebliches System festgelegt (liegt in: {', '.join(tools)})")
    elif len(tools) > 1:
        kopien = [t for t in tools if t != massgeblich[art]]
        print(f"{art}: maßgeblich {massgeblich[art]}, zusätzlich in {', '.join(kopien)} (Dubletten prüfen)")
```

Das Skript baut zunächst eine Zuordnung von jeder Dokumentart zu den Werkzeugen auf, in denen sie liegt. Im zweiten Schritt geht es die Dokumentarten durch: Gibt es kein maßgebliches System, ist das die gravierendste Lücke; gibt es eines, aber die Art liegt auch anderswo, sind das Kandidaten für Dubletten. Mit den Beispieldaten meldet es, dass das „Altes Wiki“ keinen Owner hat, dass für Anleitungen und Protokolle kein maßgebliches System festgelegt ist (Anleitungen liegen in drei Werkzeugen, Protokolle in zwei) und dass Runbooks neben Confluence auch im alten Wiki liegen. Aus der Meldung ergibt sich die Arbeitsliste: Owner für das alte Wiki klären oder es abschalten, ein maßgebliches System für Anleitungen und Protokolle bestimmen, die Runbook-Kopien im alten Wiki prüfen.

Typische Fehler: Man diskutiert Werkzeuge, bevor man Dokumentarten und Anforderungen geklärt hat; die Landschaft wird nur einmal erhoben und danach nicht gepflegt; „maßgeblich“ bleibt eine mündliche Absprache; man führt ein neues Werkzeug ein, ohne das alte abzuschalten, und verdoppelt damit die Pflege.

| **Falsch**                                                                                        | **Richtig**                                                                                                     |
|:--------------------------------------------------------------------------------------------------|:----------------------------------------------------------------------------------------------------------------|
| Anleitungen liegen in Wiki, Repository und Laufwerk, jeder meint, seine Fassung sei die richtige. | Pro Dokumentart ein maßgebliches System, in der Tool-Übersicht festgehalten; Kopien verweisen auf das Original. |

Im Projekt beginnt man mit einer Bestandsaufnahme, die auch die inoffiziellen Ablageorte erfasst (Teamlaufwerke, persönliche Ordner, Chat-Kanäle). Die Konsolidierung ist Thema von Modul 17; hier genügt die Erkenntnis, dass jede Entscheidung über Werkzeuge zuerst eine Entscheidung über Zuständigkeiten ist.

## 12.2 SharePoint Bezug

SharePoint ist die Dokumentenablage und Intranet-Plattform von Microsoft, in Organisationen mit Microsoft 365 meist bereits vorhanden. Für Dokumentation ist es vor allem als *Dokumentbibliothek* interessant: ein Ordner mit Zusatzfunktionen. Jede Datei kann zusätzliche Eigenschaften tragen (Spalten wie Dokumentart, Owner, Status, Aufbewahrung), die man filtern, sortieren und gruppieren kann, und jede Bibliothek führt eine Versionshistorie. Gemeinsam mit Office-Dateien ist das für Fachbereiche der naheliegende Ort für Richtlinien, Verträge, Protokolle und formale Dokumente.

Die Stärke von SharePoint liegt in den *Metadaten statt Ordnern*. In einer tiefen Ordnerstruktur muss jedes Dokument an genau einer Stelle liegen; mit Metadaten kann es über verschiedene Sichten gefunden werden (alle freigegebenen Richtlinien, alle Dokumente mit Owner X, alle, deren Prüfung fällig ist). Das setzt voraus, dass die Metadaten gepflegt werden. Deshalb sind Pflichtspalten und ein Namensschema die wichtigsten Governance-Entscheidungen einer Bibliothek. Die Konzepte von Metadatenmodell und Namenskonvention stammen aus Modul 03; hier geht es um ihre Durchsetzung.

Das folgende Beispiel prüft einen Export einer Bibliothek als CSV-Datei. Es verlangt einen Dateinamen nach dem Schema Kürzel, Jahr, laufende Nummer, Titel und es verlangt vier Pflichtmetadaten. Das Beispiel nutzt nur Exportdaten und greift nicht auf SharePoint selbst zu; die Anbindung an die Plattform wäre ein eigener Schritt.

```text
Name;Dokumentart;Owner;Status;Aufbewahrung
RL-2026-001 Passwortrichtlinie.docx;richtlinie;Leitung IT;freigegeben;10 Jahre
Neu Dokument 3.docx;;;;
VT-2025-014 Dienstleister A.pdf;vertrag;Einkauf;freigegeben;
Protokoll Sitzung.docx;protokoll;Leitung IT;entwurf;3 Jahre
```

```python
import csv, re, sys

PFLICHT = ["Dokumentart", "Owner", "Status", "Aufbewahrung"]
NAME = re.compile(r"^(RL|VT|PR|AN)-\d{4}-\d{3} .+\.(docx|pdf|xlsx)$")

for z in csv.DictReader(open(sys.argv[1], encoding="utf-8"), delimiter=";"):
    probleme = []
    if not NAME.match(z["Name"]):
        probleme.append("Name entspricht nicht der Konvention")
    fehlt = [f for f in PFLICHT if not z[f].strip()]
    if fehlt:
        probleme.append("Pflichtmetadaten fehlen: " + ", ".join(fehlt))
    print(f"{z['Name']}: " + ("; ".join(probleme) or "in Ordnung"))
```

Der reguläre Ausdruck verlangt eines von vier Kürzeln, ein vierstelliges Jahr, eine dreistellige Nummer, ein Leerzeichen, einen Titel und eine erlaubte Endung. Das Skript meldet für die Passwortrichtlinie „in Ordnung“, für „Neu Dokument 3“ sowohl Namensverstoß als auch vier fehlende Metadaten, für den Vertrag die fehlende Aufbewahrung und für das Protokoll den Namensverstoß, weil ihm Kürzel, Jahr und Nummer fehlen. Solche Prüfungen laufen in der Praxis regelmäßig und erzeugen eine Bereinigungsliste.

Zwei Plattformfunktionen sind für die Governance wichtig. Die erste ist die *Versionierung*. Nach der abgerufenen Herstellerdokumentation lassen sich Versionsgrenzen auf vier Ebenen festlegen (Organisation, Website, Bibliothek, OneDrive-Konto), wobei untere Ebenen die oberen überschreiben. Es gibt eine automatische Einstellung, die nach Herstellerangabe Datensicherheit und Speicherplatz ausbalanciert, und manuelle Grenzen nach Anzahl und Alter. Über die Oberfläche lassen sich mindestens 100 Hauptversionen und mindestens 30 Tage Ablauf einstellen. Versionen, die über die Grenze hinausgehen, werden dauerhaft gelöscht und gelangen nicht in den Papierkorb; Dateien unter einer Aufbewahrungsrichtlinie oder einer Rechtssperre sind von diesen Grenzen ausgenommen, solange die Aufbewahrung gilt. Für die Dokumentation heißt das: Die Versionshistorie ist kein Archiv, und wer Nachweise braucht, muss die Aufbewahrung ausdrücklich einrichten.

> **Ergänzung aus der Nachrecherche**
>
> Aufbewahrung in SharePoint nach der abgerufenen Herstellerdokumentation (Microsoft Purview): Dateien lassen sich durch eine *Aufbewahrungsrichtlinie* (gilt breit für ganze Websites) oder ein *Aufbewahrungslabel* (gilt je Datei und kann Inhalte als Aufzeichnung einstufen) schützen. Wird geschützter Inhalt bearbeitet oder gelöscht, sichert das System eine Kopie des Originals in einer versteckten Bibliothek (Preservation Hold Library). Bei einer Richtlinie entsteht beim Bearbeiten und beim Löschen eine Kopie; bei einem einfachen Label nur beim Löschen; bei einem Aufzeichnungslabel wird das Löschen blockiert und das Bearbeiten nur zugelassen, wenn die Aufzeichnung nicht gesperrt ist; bei einer regulatorischen Aufzeichnung sind beide Aktionen blockiert. Nach Ablauf der Frist wandern Inhalte in den Papierkorb und werden nach der Herstellerangabe 93 Tage nach Ablauf endgültig gelöscht; die Löschung kann bis zu 37 Tage verzögert sein, und sie ruht, solange eine andere Richtlinie, ein Label oder eine Rechtssperre den Inhalt noch erfordert. Welche Frist rechtlich gilt, ist eine Frage von Modul 13 und der eigenen Rechtsberatung, nicht dieser Plattformfunktion. (Abruf 28.10.2026, siehe Quellenverzeichnis; Produktverhalten kann sich ändern.)

Die zweite wichtige Funktion sind *Berechtigungen*. Sie lassen sich auf Website-, Bibliotheks-, Ordner- und Dateiebene vergeben. Je feiner man sie vergibt, desto unübersichtlicher wird es: Eine Datei mit einer Sonderberechtigung inmitten einer offenen Bibliothek ist für Außenstehende kaum zu finden und bei Personalwechseln leicht vergessen. Die Faustregel lautet, Berechtigungen über wenige, benannte Gruppen auf Bibliotheksebene zu steuern und Einzelfreigaben die Ausnahme sein zu lassen (Modul 13, Berechtigungskonzept).

Typische Fehler: Eine tiefe Ordnerstruktur ersetzt Metadaten; Pflichtspalten sind freiwillig, sodass die Hälfte leer bleibt; Versionsgrenzen werden als Archiv missverstanden; Sonderberechtigungen häufen sich; Dateien werden per E-Mail verschickt statt verlinkt, sodass Kopien mit veraltetem Stand entstehen.

| **Falsch**                                                              | **Richtig**                                                                                                                       |
|:------------------------------------------------------------------------|:----------------------------------------------------------------------------------------------------------------------------------|
| Ordner „Richtlinien neu“/„2026“/„IT“/„final“/„final2“, keine Metadaten. | Eine Bibliothek „Richtlinien“ mit Pflichtspalten Dokumentart, Owner, Status, Aufbewahrung und Sichten nach Status und Fälligkeit. |

Im Projekt lohnt sich ein Bibliotheksstandard als Vorlage: Spalten, Namensschema, Sichten und Berechtigungsgruppen sind für jede neue Bibliothek gleich, sodass Governance nicht jedes Mal neu verhandelt wird.

## 12.3 Confluence Bezug

Confluence ist ein verbreitetes Wiki-System, das Atlassian als Cloud-Dienst und für den eigenen Betrieb anbietet. Allgemeine Eigenschaften von Wikis (Seitenbaum, Verweise, Pflegeprobleme) wurden in Modul 11 behandelt; hier geht es um Confluence-spezifische Mittel der Ordnung und Steuerung. Nach der abgerufenen Herstellerdokumentation besteht Inhalt in Confluence aus Seiten, Live-Dokumenten und Blogbeiträgen. Seiten eignen sich für versionierte Dokumentation und Richtlinien, die als dauerhafte Wahrheit dienen sollen, Live-Dokumente für gemeinsames, sich entwickelndes Arbeiten wie Besprechungsnotizen, Blogbeiträge für zeitgebundene Nachrichten.

Inhalte liegen in *Bereichen* (englisch Spaces), die jeweils einen eigenen Seitenbaum, eine eigene Übersichtsseite, Berechtigungen und eine Seitenleiste haben. Ein Bereich für das Team Betrieb, einer für Entwicklung, einer für Richtlinien ist ein üblicher Zuschnitt. Innerhalb eines Bereichs strukturieren Elternseiten und Unterseiten die Inhalte, und *Labels* (Schlagwörter) ergänzen die Hierarchie um Querschnitte: Ein Label kann beliebig vielen Seiten zugewiesen werden, eine Seite kann mehrere Labels tragen, und mit dem Makro „Content by Label“ lassen sich daraus automatische Übersichten erzeugen. Die Herstellerdokumentation empfiehlt, im Team zu vereinbaren, welche Ordner und welche Standard-Labels verwendet werden, damit Inhalte einheitlich eingeordnet sind. Vorlagen (Blueprints und eigene Templates) sorgen für gleichen Aufbau wiederkehrender Seiten und machen Mindestinhalte aus Modul 07 durchsetzbar.

> **Ergänzung aus der Nachrecherche**
>
> Hinweis zur Plattformzukunft nach einer abgerufenen Seite eines Atlassian-Partners (Seibert Group, die auch Beratung verkauft; die Angaben sind als Herstellerankündigung zu verstehen und vor Entscheidungen bei Atlassian zu prüfen): Atlassian stellt die Data-Center-Produktlinie, darunter Confluence, ein. Genannt werden der 30. März 2026 (keine neuen Data-Center-Lizenzen für Neukunden), der 30. März 2028 (letzter Tag, an dem Bestandskunden neue Lizenzen oder Erweiterungen kaufen können) und der 28. März 2029 als Ende der Laufzeit, ab dem Instanzen in einen schreibgeschützten Modus wechseln. Bis dahin soll es Wartung und Sicherheitsupdates geben, aber keine Weiterentwicklung. Wer Confluence selbst betreibt, sollte diese Termine in die Plattformplanung (Modul 17, Migration und Roadmap) aufnehmen. (Abruf 28.10.2026, siehe Quellenverzeichnis.)

Eine kontrollierte Verschlagwortung ist die wirksamste Steuerung in einem Wiki, aber auch die am häufigsten verfehlte: Freie Labels führen zu Schreibvarianten („runbook“, „Runbook“, „runbooks“), zu Synonymen und zu Labels, die nur eine Seite trägt. Das folgende Skript prüft einen Export von Seiten und ihren Labels gegen ein festgelegtes Vokabular. Für Labels außerhalb des Vokabulars sucht es mit der Standardbibliothek `difflib` nach einem ähnlichen erlaubten Label und schlägt es vor.

```text
titel;labels
Neustart Shop;runbook,shop
Backup einrichten;Runbook,backup
Notfallplan;notfallplan,runbooks
Kantinenplan;
Wartung DB;runbook,db,datenbank
```

```python
import csv, difflib, sys
from collections import Counter

ERLAUBT = {"runbook", "anleitung", "richtlinie", "notfallplan", "shop", "backup", "db"}
alle = Counter()
for z in csv.DictReader(open(sys.argv[1], encoding="utf-8"), delimiter=";"):
    labels = [l for l in z["labels"].split(",") if l]
    if not labels:
        print(f"{z['titel']}: keine Labels")
    for l in labels:
        alle[l] += 1
        if l not in ERLAUBT:
            vorschlag = difflib.get_close_matches(l.lower(), ERLAUBT, n=1, cutoff=0.8)
            hinweis = f" (meinten Sie '{vorschlag[0]}'?)" if vorschlag else ""
            print(f"{z['titel']}: Label '{l}' nicht im Vokabular{hinweis}")
print("Häufigkeit:", dict(alle))
```

Die Funktion `get_close_matches` vergleicht Zeichenketten nach Ähnlichkeit; der Schwellenwert 0,8 sorgt dafür, dass nur nahe Varianten vorgeschlagen werden. Das Ergebnis für die Beispieldaten: „Runbook“ (Großschreibung) und „runbooks“ (Mehrzahl) werden als Varianten von „runbook“ erkannt; „datenbank“ wird als nicht erlaubt gemeldet, aber ohne Vorschlag, weil es lexikalisch nicht nah an „db“ liegt, obwohl es dasselbe meint; das Kantinenplan-Beispiel hat gar keine Labels. Die Auswertung der Häufigkeit zeigt, dass „runbook“ zweimal und „Runbook“ einmal gezählt werden, also dieselbe Sache in zwei Zählern steht. Das macht die Grenze sichtbar: Ähnlichkeit findet Schreibvarianten, aber keine Synonyme; diese braucht man als Zuordnungstabelle (siehe Abschnitt Suchbarkeit).

Typische Fehler: Jeder legt eigene Labels an; Bereiche werden nach der Organisationsstruktur statt nach Themen und Zielgruppen zugeschnitten und müssen bei jeder Umorganisation neu gebaut werden; die Seitenleiste ist überfüllt; Seiten ohne Owner; Vorlagen werden nicht verwendet; Berechtigungen auf Seitenebene häufen sich.

| **Falsch**                                                                                              | **Richtig**                                                                                                                      |
|:--------------------------------------------------------------------------------------------------------|:---------------------------------------------------------------------------------------------------------------------------------|
| Drei Schreibweisen für dasselbe Label, Bereich „Abteilung X“ mit 400 Seiten flach unter der Startseite. | Vokabular von zehn bis zwanzig abgestimmten Labels, Seitenbaum mit höchstens drei bis vier Ebenen, Vorlage für jede Dokumentart. |

Im Projekt benennt man pro Bereich einen *Space Owner*, der Vokabular, Seitenbaum und Berechtigungen verantwortet und die Pflegeläufe aus Modul 14 anstößt.

## 12.4 DMS Bezug

Ein Dokumentenmanagementsystem (DMS) ist nach einem abgerufenen Fachartikel ein elektronisches Archiv, in dem Geschäftsdokumente digital und zentral abgelegt werden, auf eigenen Servern oder in der Cloud. Wo SharePoint und Wiki auf Zusammenarbeit und laufende Bearbeitung zielen, zielt ein DMS auf *Ordnung, Nachweisbarkeit und Aufbewahrung* von Dokumenten, die in der Regel fertig sind: Rechnungen, Verträge, Zertifikate, Prüfberichte, freigegebene Richtlinien. Manche Organisationen nutzen dafür ein eigenes Produkt, andere ergänzen Funktionen in vorhandenen Plattformen; entscheidend ist, was ein DMS leisten muss.

Nach dem abgerufenen Artikel gehören dazu fünf Kernfunktionen. Die *revisionssichere Archivierung*: Das Dokument muss jederzeit exakt so aussehen wie bei der Erstellung oder Ablage. Die *Verschlagwortung mit Metadaten*: Der Artikel empfiehlt für jedes Dokument zwischen fünf und zehn Metainformationen, die bei Daten aus Fachsystemen automatisch entstehen und bei eingescannten Dokumenten durch Texterkennung unterstützt werden können. Die *Volltextsuche* ergänzt die Schlagwörter. Die *Berechtigungen* stellen sicher, dass Mitarbeitende nur die für sie relevanten Dokumente sehen. Das *Fristenmanagement* ordnet jedem Dokument eine Aufbewahrungsfrist zu und löscht es danach, etwa bei personenbezogenen Daten nach DSGVO. Hinzu kommen Vorlagen je Dokumenttyp. Versionierung und Ein- und Auschecken sind in diesem Artikel nicht beschrieben; sie sind in der Praxis ebenfalls üblich, die Quelle belegt sie aber nicht.

Die Anforderung der Revisionssicherheit lässt sich technisch am Beispiel einer Prüfsumme verstehen. Beim Ablegen berechnet das System einen Fingerabdruck des Dokuments (hier SHA-256), speichert ihn mit den Metadaten und kann später jederzeit prüfen, ob der Inhalt noch derselbe ist. Das folgende Skript führt dieses Prinzip in kleinem Maßstab vor. Es legt eine Datei ab, verlangt fünf Pflichtmetadaten, speichert Fingerabdruck und Metadaten in einer Begleitdatei und prüft die Unveränderlichkeit. Dann verändert es die Datei absichtlich und prüft erneut.

```python
import hashlib, json, sys
from datetime import date
from pathlib import Path

PFLICHT = ["titel", "dokumentart", "owner", "status", "datum"]

def hash_von(pfad):
    return hashlib.sha256(Path(pfad).read_bytes()).hexdigest()

def ablegen(quelle, meta):
    fehlt = [f for f in PFLICHT if not meta.get(f)]
    if fehlt:
        raise ValueError("Pflichtmetadaten fehlen: " + ", ".join(fehlt))
    ziel = Path("ablage") / Path(quelle).name
    ziel.write_bytes(Path(quelle).read_bytes())
    meta["sha256"] = hash_von(ziel)
    ziel.with_suffix(".meta.json").write_text(json.dumps(meta, ensure_ascii=False, indent=1), encoding="utf-8")
    return ziel

def pruefen(ziel):
    meta = json.loads(Path(ziel).with_suffix(".meta.json").read_text(encoding="utf-8"))
    return hash_von(ziel) == meta["sha256"]

meta = {"titel": "Vertrag Dienstleister A", "dokumentart": "vertrag", "owner": "Einkauf",
        "status": "freigegeben", "datum": str(date(2026, 10, 28))}
ziel = ablegen("eingang/vertrag.txt", meta)
print("Abgelegt:", ziel, "- unverändert:", pruefen(ziel))
Path(ziel).write_text("Vertrag Version 2 (heimlich geändert)")
print("Nach Änderung - unverändert:", pruefen(ziel))
try:
    ablegen("eingang/vertrag.txt", {"titel": "Ohne Owner"})
except ValueError as e:
    print("Abgelehnt:", e)
```

Das Skript braucht die Ordner `eingang` (mit der Datei `vertrag.txt`) und `ablage`. Die Ausgabe: Die Datei wird abgelegt und als unverändert bestätigt (True); nach dem absichtlichen Ändern meldet die Prüfung False; die Ablage ohne Pflichtmetadaten wird mit der Meldung abgelehnt, dass dokumentart, owner, status und datum fehlen. Die Funktion `ablegen` erzwingt also die Metadaten, bevor ein Dokument überhaupt ins Archiv kommt; die Prüfsumme macht nachträgliche Änderungen erkennbar. Wichtig ist die Grenze: Eine Begleitdatei im selben Ordner schützt nicht gegen jemanden, der beide Dateien ändert. Echte Systeme sichern Fingerabdrücke getrennt oder schreibgeschützt (vgl. das Hash-Ketten-Prinzip in Modul 10, Audit Trail), und ob eine Lösung im rechtlichen Sinn revisionssicher ist, ist keine Frage eines Skripts, sondern einer Prüfung durch Fachleute (keine Rechtsberatung).

Typische Fehler: Ein DMS wird eingeführt, ohne Metadaten zu definieren, und wird zur teuren Ablage; Dokumente werden doppelt geführt (DMS und Laufwerk); Aufbewahrungsfristen werden nicht hinterlegt; Berechtigungen werden zu grob oder zu fein vergeben; das DMS wird für Arbeitsdokumente im Entwurf benutzt, die sich ständig ändern.

| **Falsch**                                                                 | **Richtig**                                                                                                               |
|:---------------------------------------------------------------------------|:--------------------------------------------------------------------------------------------------------------------------|
| Alle Dokumente, auch Entwürfe, werden ins DMS geladen, Metadaten optional. | Nur freigegebene Dokumente werden abgelegt, fünf bis zehn Pflichtmetadaten, Aufbewahrungsfrist je Dokumenttyp hinterlegt. |

Im Projekt grenzt man die Rollen ab: Das Wiki oder die Dateiablage für die laufende Arbeit, das DMS für das, was fertig, freigegeben und aufbewahrungspflichtig ist. Der Übergang (Archivierung, Modul 10 und 14) wird als Prozess beschrieben und nicht dem Zufall überlassen.

## 12.5 Git Docs as Code Bezug

Die Grundlagen von Git, Review und Docs-as-Code wurden in Modul 10 und Modul 11 behandelt. Hier geht es um die Rolle des Repositories als *Ablageort* im Verhältnis zu den anderen Plattformen und um die Governance-Fragen, die sich daraus ergeben: Wer ist für welche Dateien verantwortlich, wie sieht man die Aktualität, und wie stellt man sicher, dass die Dokumentation im Repository mit den anderen Ablageorten verbunden ist. Das Repository ist der natürliche Ort für Inhalte, die eng am Code liegen: Schnittstellenbeschreibungen, Installationshinweise, Architekturentscheidungen, Betriebsanleitungen der Entwickler. Es ist weniger geeignet für Dokumente, die Fachbereiche ohne technische Vorkenntnisse pflegen sollen.

Eine wichtige Governance-Frage ist die Zuständigkeit je Datei. Viele Git-Plattformen kennen dafür eine Datei, die Pfadmuster Verantwortlichen zuordnet; sie heißt meist `CODEOWNERS`. Wird eine Datei geändert, erhalten die zugeordneten Personen automatisch eine Review-Anfrage. Das Zuordnen ist damit nicht nur Information, sondern Teil des Arbeitsablaufs. Die genaue Syntax und Wirkung unterscheidet sich je Plattform; das folgende Beispiel vereinfacht sie und dient dem Verständnis des Prinzips. Es liest eine solche Zuordnung, ordnet jeder Markdown-Datei im Ordner `docs` den Owner zu und ermittelt über den Befehl `git log`, wann die Datei zuletzt geändert wurde.

```markdown
# Zuständigkeiten
/docs/betrieb/ @team-betrieb
/docs/api/ @team-entwicklung
```

```python
import subprocess
from datetime import date
from fnmatch import fnmatch
from pathlib import Path

HEUTE = date(2026, 10, 28)
regeln = []
for zeile in Path("CODEOWNERS").read_text(encoding="utf-8").splitlines():
    if zeile.strip() and not zeile.startswith("#"):
        muster, *owner = zeile.split()
        regeln.append((muster.lstrip("/") + "*", owner))

def letzte_aenderung(datei):
    aus = subprocess.run(["git", "log", "-1", "--format=%cs", "--", datei],
                         capture_output=True, text=True).stdout.strip()
    return date.fromisoformat(aus)

for datei in sorted(Path("docs").rglob("*.md")):
    pfad = datei.as_posix()
    owner = next((o for m, o in regeln if fnmatch(pfad, m)), None)
    alter = (HEUTE - letzte_aenderung(pfad)).days
    print(f"{pfad}: Owner {', '.join(owner) if owner else 'FEHLT'}, letzte Änderung vor {alter} Tagen")
```

Ich habe das Skript in einem Testrepository mit drei Dateien ausgeführt: `docs/api/auth.md` (zuletzt am 1. Oktober 2026 geändert), `docs/betrieb/neustart.md` und `docs/notiz.md` (beide zuletzt am 1. Juni 2025). Die Ausgabe: Die API-Datei gehört dem Team Entwicklung und wurde vor 27 Tagen geändert, die Betriebsdatei gehört dem Team Betrieb und wurde vor 514 Tagen geändert, und für `notiz.md` wurde kein Owner gefunden. Die Aussagekraft ist begrenzt: `git log` zeigt, wann *irgendetwas* an der Datei geändert wurde, nicht, ob sie inhaltlich geprüft wurde. Ein Rechtschreibfehler-Commit setzt die Uhr genauso zurück wie eine echte Überarbeitung. Deshalb gehören ein Prüfdatum und ein Prüfer in die Metadaten der Datei (Modul 14, Review-Kalender), und das Git-Datum dient nur als Hinweis.

Die Verbindung zu den anderen Plattformen entsteht über Verweise. Eine Seite im Wiki kann auf die maßgebliche Datei im Repository zeigen, statt deren Inhalt zu kopieren; das Repository verweist umgekehrt auf Tickets und auf Freigabedokumente im DMS. Wichtig ist, dass diese Verweise stabile Adressen verwenden, also Adressen, die nicht brechen, wenn eine Datei verschoben wird.

Typische Fehler: Keine Zuordnung von Zuständigkeiten, sodass Pull Requests ohne Review durchlaufen; Dokumentation im Repository ist von außen nicht auffindbar, weil das Repository nicht an die Suche angebunden ist; Inhalte werden zwischen Repository und Wiki kopiert und laufen auseinander; das Änderungsdatum wird mit dem Prüfdatum verwechselt.

| **Falsch**                                                                               | **Richtig**                                                                                                                        |
|:-----------------------------------------------------------------------------------------|:-----------------------------------------------------------------------------------------------------------------------------------|
| Das Wiki enthält eine kopierte Fassung der API-Beschreibung, das Repository eine neuere. | Das Wiki enthält eine kurze Einführung und einen Verweis auf die maßgebliche Beschreibung im Repository; es gibt nur eine Fassung. |

Im Projekt legt man fest, welche Inhalte im Repository liegen (nahe am Code, von Technikern gepflegt) und wie sie für andere sichtbar werden: durch einen Generator, der eine durchsuchbare Webseite erzeugt (Modul 11), und durch Verweise aus Wiki und Tickets.

## 12.6 Ticket Verknüpfung

Tickets (in Systemen wie Jira, aber auch in jedem anderen Aufgabenverwaltungssystem) halten fest, *was getan werden soll und wurde*: eine Störung, eine Änderung, eine Anfrage. Dokumentation hält fest, *wie etwas ist und wie man damit umgeht*. Beide Welten gehören zusammen: Eine Änderung am System sollte die Dokumentation ändern, und ein Dokument sollte erkennen lassen, durch welche Änderung es entstand. Die Verknüpfung stellt *Nachvollziehbarkeit* her, in beide Richtungen: vom Ticket zur betroffenen Dokumentation (wurde sie angepasst?) und vom Dokument zu den Tickets, die zu seinem Inhalt geführt haben (warum steht das so da?).

Die technischen Möglichkeiten sind plattformabhängig. Nach einem abgerufenen Beitrag von Atlassian verknüpfen sich Jira und Confluence auf mehreren Wegen: Erwähnt man ein Jira-Vorgang in einer Confluence-Seite mit dem Jira-Makro, erzeugt Jira automatisch einen Verweis zurück auf die Seite; über den Verknüpfungsdialog lässt sich ein Vorgang mit einer beliebigen Seite verbinden; ein eingefügter Jira-Link wird zu einer Karte mit Vorgangsdaten umgewandelt; und aus Confluence heraus lassen sich neue Vorgänge anlegen. Der Beitrag nennt auch, dass Berichte aus Jira als Diagramme in Confluence-Seiten angezeigt werden können. Das ist die Sicht eines Herstellers; die Details der Bedienung sollten Sie in der aktuellen Produktdokumentation nachsehen. Unabhängig von der Plattform funktioniert auch die einfachste Form: die Ticketnummer im Kopf des Dokuments und in der Nachricht jeder Änderung.

Das folgende Beispiel zeigt eine solche einfache Prüfung. Es liest eine Ticketliste (als Export) und Dokumente mit einer Ticketliste im Kopf, und es meldet zwei Arten von Lücken: Dokumente, die auf unbekannte Tickets verweisen, und erledigte Tickets, bei denen die Dokumentation betroffen war, aber keine Seite verknüpft ist.

```text
id;titel;status;doku_betroffen
PROJ-12;API-Authentifizierung umgestellt;erledigt;ja
PROJ-15;DB-Upgrade;erledigt;ja
PROJ-18;Neues Monitoring;offen;ja
PROJ-20;Farbe Button;erledigt;nein
```

```markdown
---
titel: API Authentifizierung
tickets: [PROJ-12, PROJ-99]
---
Text
```

```python
import csv, sys, yaml
from pathlib import Path

tickets = {z["id"]: z for z in csv.DictReader(open(sys.argv[1], encoding="utf-8"), delimiter=";")}
verknuepft = set()
for datei in sorted(Path(sys.argv[2]).glob("*.md")):
    kopf = yaml.safe_load(datei.read_text(encoding="utf-8").split("---")[1])
    for t in kopf.get("tickets", []):
        verknuepft.add(t)
        if t not in tickets:
            print(f"{datei.name}: verweist auf unbekanntes Ticket {t}")

for tid, z in tickets.items():
    if z["doku_betroffen"] == "ja" and z["status"] == "erledigt" and tid not in verknuepft:
        print(f"{tid} ({z['titel']}): erledigt, Doku betroffen, aber keine Seite verknüpft")
```

In meinem Test gab es zwei Dokumente: die obige API-Seite (verweist auf PROJ-12 und PROJ-99) und eine Monitoring-Seite (verweist auf PROJ-18). Das Skript meldete, dass die API-Seite auf ein unbekanntes Ticket PROJ-99 verweist (Tippfehler oder gelöscht) und dass PROJ-15 (DB-Upgrade) erledigt ist, die Dokumentation betroffen war, aber keine Seite verknüpft ist. Für PROJ-12 und PROJ-18 gab es keine Meldung: das erste ist verknüpft, das zweite ist noch offen. PROJ-20 betrifft die Dokumentation nicht. Die Regel „doku_betroffen“ muss im Änderungsprozess (Modul 10) ausgefüllt werden; sie ist die Schnittstelle zwischen Ticket und Dokumentation, und eine Ticketvorlage mit einer Pflichtfrage „Welche Dokumente sind betroffen?“ ist die wirksamste Einzelmaßnahme.

Typische Fehler: Die Ticketnummer wird nirgends im Dokument erwähnt; „Doku folgt“ steht im Ticket, wird aber nie nachgeholt und das Ticket geschlossen; Dokumente verweisen auf Tickets in einem System, das später abgelöst wird und dessen Nummern dann nicht mehr auflösbar sind; Gespräche und Entscheidungen bleiben im Ticket und gehen für die Dokumentation verloren.

| **Falsch**                                                                               | **Richtig**                                                                                                             |
|:-----------------------------------------------------------------------------------------|:------------------------------------------------------------------------------------------------------------------------|
| Ticket „erledigt“ mit dem Kommentar „Doku muss noch angepasst werden“, kein Folgeticket. | Ticket kann nur geschlossen werden, wenn die Frage „Doku betroffen?“ beantwortet und die betroffene Seite verlinkt ist. |

Im Projekt hat sich die *Definition of Done* bewährt: Ein Ticket gilt erst als erledigt, wenn die betroffene Dokumentation angepasst oder ausdrücklich als nicht betroffen bestätigt wurde.

## 12.7 Suchbarkeit

Dokumentation, die niemand findet, ist praktisch nicht vorhanden. Die Suchbarkeit ist deshalb die gemeinsame Eigenschaft aller Plattformen, an der sich ihr Wert für die Leser entscheidet. Dieser Abschnitt behandelt die *Plattformseite*: Wie funktioniert eine Suche, was kann man in den Plattformen einstellen, und wo liegen die Grenzen. Die organisatorische Seite (Suchoptimierung im Betrieb, Auswertung von Suchanfragen, Verbesserungsprozess) behandelt Modul 15, die Metadaten und Tags eben dort in eigenen Abschnitten.

Eine Volltextsuche arbeitet vereinfacht in zwei Schritten. Beim *Indizieren* zerlegt sie jedes Dokument in Wörter und baut ein Verzeichnis auf, das zu jedem Wort die Fundstellen enthält. Bei der *Abfrage* zerlegt sie die Anfrage ebenfalls in Wörter, schlägt sie im Verzeichnis nach und ordnet die Treffer nach einer Bewertung. Aus dieser Funktionsweise ergeben sich die wichtigsten Stellschrauben. Der *Titel* zählt mehr als der Fließtext, deshalb entscheidet ein aussagekräftiger Titel über die Auffindbarkeit. *Metadaten und Labels* erlauben zielgenaues Filtern und können höher gewichtet werden. *Synonyme* schließen Lücken zwischen Sprache der Leser und Sprache der Autoren. Berechtigungen wirken ebenfalls: Eine Suche zeigt idealerweise nur, was die suchende Person lesen darf, sonst verrät schon die Trefferliste vertrauliche Titel. In der Fachsprache heißt das Ausblenden nicht berechtigter Treffer „Security Trimming“ (allgemeines Fachwissen; die Umsetzung hängt von der Plattform ab).

Das folgende Skript ist eine Miniatur einer solchen Suche. Es liest Seiten mit Kopfdaten, gewichtet Titeltreffer mit fünf, Labeltreffer mit drei und Textreffer mit einem Punkt, wendet eine Synonymtabelle an und gibt die Treffer nach Punkten sortiert aus. Gegenstand sind drei Beispielseiten (Neustart Shop, Backup einrichten, Passwortrichtlinie).

```python
import re, sys, yaml
from pathlib import Path

SYNONYME = {"restart": "neustart", "sicherung": "backup", "kennwort": "passwort"}

def woerter(text):
    return re.findall(r"\w+", text.lower())

index = []
for datei in Path(sys.argv[1]).glob("*.md"):
    teile = datei.read_text(encoding="utf-8").split("---", 2)
    kopf = yaml.safe_load(teile[1])
    index.append({"titel": kopf["titel"], "titelw": woerter(kopf["titel"]),
                  "labels": kopf.get("labels", []), "text": woerter(teile[2])})

def suche(anfrage):
    begriffe = [SYNONYME.get(w, w) for w in woerter(anfrage)]
    treffer = []
    for s in index:
        punkte = 0
        for b in begriffe:
            punkte += 5 * any(w.startswith(b) for w in s["titelw"])
            punkte += 3 * (b in s["labels"])
            punkte += 1 * any(w.startswith(b) for w in s["text"])
        if punkte:
            treffer.append((punkte, s["titel"]))
    return sorted(treffer, reverse=True)

for frage in ["neustart", "restart", "sicherung", "kennwort ändern", "vpn"]:
    print(f"{frage!r}:", suche(frage) or "KEINE TREFFER")
```

Die Funktion `woerter` zerlegt Text in Kleinbuchstaben-Wörter. Beim Aufbau des Verzeichnisses werden Titel, Labels und Text getrennt gehalten, damit sie verschieden gewichtet werden können. Die Funktion `suche` ersetzt Synonyme, vergibt Punkte und sortiert. Die Ausgabe für die fünf Testanfragen: „neustart“ findet die Seite Neustart Shop mit fünf Punkten (Titeltreffer) und die Seite Backup einrichten mit einem Punkt (das Wort steht im Text); „restart“ liefert dank Synonym dasselbe Ergebnis; „sicherung“ wird zu „backup“ und findet Backup einrichten mit neun Punkten (Titel, Label und Text); „kennwort ändern“ findet über das Synonym die Passwortrichtlinie mit fünf Punkten, obwohl das zweite Wort nirgends vorkommt; „vpn“ liefert keine Treffer. Der letzte Fall ist besonders aufschlussreich: Eine Anfrage ohne Treffer ist ein Hinweis auf fehlenden Inhalt, ein fehlendes Synonym oder ein falsches Wort, und die Auswertung solcher Anfragen ist ein wichtiger Auslöser für Verbesserungen (Modul 15, Nutzungsanalyse).

Typische Fehler: Titel wie „Notizen“ oder „Übersicht“ sagen nichts aus; Dateianhänge (PDF, Word) sind nicht durchsuchbar, weil sie als Bild gescannt wurden; die Suche über mehrere Plattformen fehlt, sodass man an fünf Orten suchen muss; Synonyme der Leser sind unbekannt; die Suche zeigt Treffer, die der Nutzer nicht öffnen darf, oder verbirgt Treffer, die er öffnen dürfte.

| **Falsch**                                           | **Richtig**                                                                              |
|:-----------------------------------------------------|:-----------------------------------------------------------------------------------------|
| Seitentitel „Doku“, Anhang „scan0042.pdf“ ohne Text. | Titel „Neustart Shop-Dienst (Runbook)“, Anhang mit durchsuchbarem Text, Label „runbook“. |

Im Projekt lohnt sich der einfache Test: Zehn typische Fragen von Lesern an die Suche stellen und prüfen, ob das gewünschte Dokument unter den ersten drei Treffern erscheint. Diese Zahl ist die ehrlichste Kennzahl der Suchbarkeit.

## 12.8 Tool-Troubleshooting

Dieser Abschnitt zeigt, wie man Probleme mit Dokumentationsplattformen systematisch eingrenzt, indem man die Ursachen nicht zuerst im Werkzeug, sondern in den Voraussetzungen sucht: Zielklarheit, Dokumentationsumfang, Owner, Rollen, Standards, Metadaten, Freigaben, Aktualität, Berechtigungen und Auffindbarkeit. Aus der Eingrenzung leitet man dann Handlungsschritte für Redaktion, Fachbereich und Betrieb ab. Die Grundhaltung ist, dass die meisten „Tool-Probleme“ Organisationsprobleme sind, die im Werkzeug sichtbar werden. Ein Wechsel der Plattform löst sie nur, wenn die Ursachen zugleich behoben werden; sonst wandert das Problem mit.

Die zehn Kriterien lassen sich als Prüfreihenfolge verstehen, weil sie aufeinander aufbauen. Ohne klares *Ziel* lässt sich der *Umfang* nicht bestimmen. Ohne festgelegten Umfang gibt es keine sinnvollen *Owner*, und ohne Owner keine eindeutigen *Rollen* für Autor, Reviewer und Freigeber. *Standards* (Vorlagen, Schreibregeln) und *Metadaten* brauchen Zuständige, die sie pflegen. *Freigaben* setzen Rollen und Standards voraus. *Aktualität* setzt Owner und Review voraus. *Berechtigungen* setzen Klassifizierung voraus, und *Auffindbarkeit* ist das Ergebnis von Metadaten, Struktur und Aktualität. Wer in dieser Reihenfolge prüft, behebt zuerst die Ursachen und nicht die Folgen.

Das folgende Beispiel bewertet drei Bereiche anhand der zehn Kriterien (ja oder nein) und gibt je Bereich die Lücken aus, beginnend mit der, die zuerst zu beheben ist. Die Bewertung stammt aus einer Selbsteinschätzung oder einem kurzen Audit und liegt als YAML-Datei vor.

```text
- {bereich: Betrieb, ziel: ja, umfang: ja, owner: ja, rollen: ja, standards: ja, metadaten: ja, freigabe: ja, aktuell: nein, berechtigung: ja, auffindbar: nein}
- {bereich: Vertrieb, ziel: nein, umfang: nein, owner: nein, rollen: nein, standards: ja, metadaten: nein, freigabe: nein, aktuell: nein, berechtigung: nein, auffindbar: nein}
- {bereich: Entwicklung, ziel: ja, umfang: ja, owner: ja, rollen: ja, standards: ja, metadaten: ja, freigabe: ja, aktuell: ja, berechtigung: ja, auffindbar: ja}
```

```python
import sys, yaml

REIHENFOLGE = ["ziel", "umfang", "owner", "rollen", "standards", "metadaten",
               "freigabe", "aktuell", "berechtigung", "auffindbar"]
for b in yaml.safe_load(open(sys.argv[1], encoding="utf-8")):
    luecken = [k for k in REIHENFOLGE if b[k] != "ja"]
    if not luecken:
        print(f"{b['bereich']}: alle zehn Kriterien erfüllt")
        continue
    print(f"{b['bereich']}: {len(luecken)} Lücke(n), zuerst beheben: {luecken[0]} (weitere: {', '.join(luecken[1:]) or '-'})")
```

Das Skript ist bewusst einfach. Die Ausgabe: Der Bereich Betrieb hat zwei Lücken, zuerst Aktualität, dann Auffindbarkeit; der Vertrieb hat neun Lücken, zuerst das Ziel; Entwicklung erfüllt alle Kriterien. Das Ergebnis für den Vertrieb zeigt die Logik der Reihenfolge: Es nützt wenig, dort zuerst die Auffindbarkeit zu verbessern, solange nicht einmal klar ist, wozu die Dokumentation dient. Für Betrieb dagegen ist klar, dass die Grundlagen stehen und Pflege (Modul 14) und Suche (Abschnitt Suchbarkeit, Modul 15) die Hebel sind. Beachten Sie die Grenze der Methode: Ja und Nein sind grobe Urteile, und die Bewertung ist nur so gut wie die Ehrlichkeit der Selbsteinschätzung. Sie ersetzt keine Stichprobe an echten Dokumenten.

Als Runbook für die Eingrenzung ergibt sich: Symptom und betroffene Plattform notieren; die zehn Kriterien für den betroffenen Bereich prüfen; die erste Lücke in der Reihenfolge als Ursache annehmen und beheben; erst danach Werkzeugeinstellungen anfassen; Wirkung nach vier bis acht Wochen anhand der Suchtreffer, der Rückmeldungen und der Pflegekennzahlen messen. Typische Symptom-Ursachen-Paare: „Niemand pflegt das Wiki“ weist auf Owner und Rollen, „Wir finden nichts“ auf Metadaten und Titel, „Das ist veraltet“ auf Review und Aktualität, „Jeder sieht alles“ auf Klassifizierung und Berechtigungen, „Jeder schreibt anders“ auf Standards und Vorlagen.

Typische Fehler: Man wechselt die Plattform, weil die alte „nicht funktioniert“, ohne die Ursachen zu klären; man führt eine zusätzliche Plattform ein, die eine Lücke schließen soll, und erzeugt eine neue Ablage; man bewertet nur das Werkzeug und nicht die Organisation drumherum; man behebt Symptome (zum Beispiel Suchoptimierung), während Owner fehlen.

| **Falsch**                                                 | **Richtig**                                                                                                                                                                                                 |
|:-----------------------------------------------------------|:------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| „Die Suche ist schlecht, wir brauchen ein neues Werkzeug.“ | „Die Suche zeigt keine Treffer für Begriffe der Leser; Titel und Labels sind uneinheitlich, es gibt keine Synonymliste und keinen Owner für die Verschlagwortung; zuerst diese Punkte, dann erneut messen.“ |

Im Projekt ist der Wert dieser Eingrenzung, dass sie Diskussionen über Werkzeuge in Diskussionen über Zuständigkeiten und Standards übersetzt, wo sie sich lösen lassen.

## Übungsaufgaben

Die Aufgaben steigen von Verständnisfragen (1 bis 3) über Anwendungsaufgaben (4 bis 5) bis zu Programmier- und Transferaufgaben (6 bis 8) an.

**Aufgabe 1.** *(leicht)* Erklären Sie den Begriff „maßgebliches System“ und warum er für die Governance einer Tool-Landschaft zentral ist.

**Aufgabe 2.** *(leicht)* Worin unterscheiden sich Aufbewahrungsrichtlinie und Aufbewahrungslabel in SharePoint (nach der Herstellerdokumentation)? Wann ist welches geeigneter?

**Aufgabe 3.** *(leicht bis mittel)* Nennen Sie je zwei Dokumentarten, die in ein Wiki, in eine Dokumentbibliothek, in ein DMS und in ein Repository gehören, und begründen Sie die Wahl.

**Aufgabe 4.** *(mittel)* Entwerfen Sie für eine Dokumentbibliothek „Richtlinien“ ein Metadatenmodell (Spalten, Pflicht oder freiwillig, erlaubte Werte) und ein Namensschema.

**Aufgabe 5.** *(mittel)* Entwerfen Sie ein Label-Vokabular mit zwölf Labels für einen Confluence-Bereich Betrieb und legen Sie Regeln für neue Labels fest.

**Aufgabe 6.** *(mittel, praktisch)* Erweitern Sie das Bibliotheksprüfskript um eine Regel, die Dokumente mit Status „freigegeben“ meldet, deren Aufbewahrung leer ist, mit einer eigenen, schärferen Meldung.

**Aufgabe 7.** *(anspruchsvoll, praktisch)* Erweitern Sie das Suchskript um eine Ausgabe der Anfragen ohne Treffer in eine Datei `nulltreffer.txt`, einmal je Anfrage mit Anzahl, und lesen Sie das Ergebnis nach drei zusätzlichen Testanfragen aus.

**Aufgabe 8.** *(anspruchsvoll, Transfer)* Ein Bereich meldet: „Unsere Dokumentation ist ein Chaos, wir wollen Confluence durch SharePoint ersetzen.“ Prüfen Sie die Aussage mit der Methode aus dem Abschnitt Tool-Troubleshooting und formulieren Sie eine Empfehlung.

## Lösungen und Erläuterungen

**Lösung zu Aufgabe 1.** Das maßgebliche System ist der Ort, an dem die gültige Fassung einer Dokumentart liegt; alle anderen Fundstellen sind Kopien oder Verweise. Ohne diese Festlegung weiß niemand, welche Fassung gilt, wenn sich zwei unterscheiden, und es gibt keinen Ort, an dem Berechtigungen, Aufbewahrung und Freigabe verbindlich geregelt sind. Governance besteht zu einem großen Teil darin, diese Zuordnung festzulegen, zu dokumentieren und durchzusetzen.

**Lösung zu Aufgabe 2.** Nach der abgerufenen Herstellerdokumentation gilt eine Richtlinie breit für ganze Websites oder Orte, ein Label je Datei und kann Inhalte als Aufzeichnung einstufen, mit stärkeren Einschränkungen. Bei der Richtlinie wird beim Bearbeiten und Löschen eine Kopie gesichert; bei einem einfachen Label nur beim Löschen. Eine Richtlinie eignet sich, wenn ein ganzer Bereich einheitlich behandelt werden soll; ein Label, wenn einzelne Dokumente unterschiedliche Fristen oder einen besonderen Schutz brauchen, etwa Verträge als Aufzeichnung. Prüfen Sie das Verhalten in Ihrer Umgebung, denn es kann sich ändern.

**Lösung zu Aufgabe 3.** Wiki: Runbooks und interne Anleitungen, weil viele sie ergänzen und sie sich oft ändern. Dokumentbibliothek: Richtlinien und Protokolle, weil sie Metadaten, Versionen und Berechtigungen brauchen und überwiegend als Datei existieren. DMS: Verträge und Prüfberichte, weil sie fertig, aufbewahrungspflichtig und nachweisbar sein müssen. Repository: API-Beschreibung und Installationshinweise, weil sie mit dem Code zusammen geändert werden. Andere Zuordnungen sind möglich, wenn sie begründet sind.

**Lösung zu Aufgabe 4.** Ein möglicher Entwurf. Pflichtspalten: Dokumentart (Auswahl: Richtlinie, Standard, Verfahren), Owner (Person), Status (Entwurf, in Prüfung, freigegeben, archiviert), gültig ab (Datum), nächste Prüfung (Datum), Aufbewahrung (Auswahl nach Aufbewahrungsplan). Freiwillig: Bezug (Verweis auf Ticket oder übergeordnete Richtlinie), Schlagwörter. Namensschema: Kürzel-Jahr-Nummer Titel, zum Beispiel „RL-2026-001 Passwortrichtlinie“, wie im Skript. Die Auswahllisten verhindern Schreibvarianten; Pflichtspalten verhindern leere Metadaten.

**Lösung zu Aufgabe 5.** Ein möglicher Entwurf: runbook, anleitung, richtlinie, notfallplan, schnittstelle, störung, wartung, shop, backup, datenbank, netzwerk, sicherheit. Regeln: Labels klein, ohne Leerzeichen und in der Einzahl; neue Labels nur über den Space Owner; Synonyme werden in einer Tabelle gepflegt und auf ein Label abgebildet; je Seite mindestens ein Dokumentart-Label und ein Systemlabel; Labels, die nur eine Seite tragen, werden im Pflegelauf geprüft.

**Lösung zu Aufgabe 6.** Eine mögliche Ergänzung in der Schleife, vor der Ausgabe:

```text
    if z["Status"] == "freigegeben" and not z["Aufbewahrung"].strip():
        probleme.append("KRITISCH: freigegeben ohne Aufbewahrung")
```

Mit den Beispieldaten trifft die Regel den Vertrag aus der Beispielliste. Er hat bereits die Meldung zur fehlenden Aufbewahrung; die neue Meldung ist schärfer formuliert und lässt sich in einer Bereinigungsliste nach oben sortieren. Eine freigegebene Datei ohne Aufbewahrung ist problematischer als ein Entwurf ohne, weil sie in Kraft ist und trotzdem ungeregelt bleibt.

**Lösung zu Aufgabe 7.** Eine mögliche Ergänzung: Vor der Schleife legt man einen Zähler an (Counter aus dem Modul collections). In der Schleife über die Testanfragen wird die Suche genau einmal aufgerufen und das Ergebnis gespeichert; ist es leer, zählt man die Anfrage hoch. Nach der Schleife schreibt man die Anfragen mit ihrer Anzahl, die häufigsten zuerst, zeilenweise in die Datei. Das Ergebnis ist eine Liste, die zeigt, wonach Leser suchen, ohne etwas zu finden. Sie ist der Ausgangspunkt für neue Inhalte oder Synonyme. Beachten Sie, dass bei drei zusätzlichen Testanfragen die Anzahl je Anfrage zunächst immer eins ist; erst im echten Betrieb mit protokollierten Anfragen entstehen aussagekräftige Häufigkeiten.

**Lösung zu Aufgabe 8.** Prüfen Sie die zehn Kriterien für den Bereich. Wahrscheinlich ergeben sich Lücken bei Zielklarheit, Umfang, Owner und Metadaten, also Voraussetzungen, die in jedem Werkzeug fehlen würden. Empfehlung: Zuerst den Umfang klären (welche Dokumentarten gehören zu diesem Bereich), Owner benennen, ein Metadatenmodell und ein Label-Vokabular festlegen, veraltete Seiten archivieren (Modul 14) und die Suche testen. Danach neu bewerten. Spricht dann noch etwas für einen Wechsel, etwa der Bedarf an Aufbewahrungsfunktionen, die Confluence nicht bietet, oder die Plattformstrategie des Unternehmens (siehe die Hinweise zum Ende von Data Center), sollte der Wechsel als Migration nach Modul 17 geplant werden. Ein Wechsel ohne Klärung der Ursachen übernimmt das Chaos in das neue System.
