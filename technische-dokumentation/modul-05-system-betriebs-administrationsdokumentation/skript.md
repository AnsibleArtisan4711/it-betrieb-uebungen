# Modul 05 - System-, Betriebs- und Administrationsdokumentation

> **Hinweis zu diesem Kapitel:** Das ist das Kapitel des Skripts „Technische Dokumentation und Dokumentations-Governance“, aus der LaTeX-Quelle in Markdown umgewandelt (Text und Listings unverändert, farbige Boxen als Zitatblöcke mit fettem Titel, Tabellen als Markdown-Tabellen, Übungsaufgaben und Lösungen als Absätze). Die Lerneinheiten sind wie in der Quelle nach Modul nummeriert (5.1 bis 5.8), danach folgen „Übungsaufgaben“ (8 Aufgaben) und „Lösungen und Erläuterungen“. Die Sprachangabe der Codeblöcke ist in der Quelle nur für Python und Bash gesetzt; die übrigen Blöcke sind hier nach ihrem Inhalt als `python`, `yaml`, `markdown`, `bash` oder `text` ausgezeichnet, der Inhalt selbst ist unverändert. **Prüfstand der Beispiele für dieses Repository:** Die Python-Beispiele wurden auf Syntax geprüft; welche Beispiele ausgeführt wurden und welche zusätzlich PyYAML brauchen, steht in der [README des Repositories](../README.md). Übersicht zum Modul: [README](README.md).

**Dauer:** 8,75 Stunden | **Priorität:** 1 | **Lerneinheiten:** 8

| **Nr.** | **Lerneinheit**              | **Dauer (h)** | **Prio** |
|--------:|:-----------------------------|--------------:|---------:|
|       1 | Systemuebersicht             |          1,25 |        1 |
|       2 | Architekturdokumentation     |          1,25 |        1 |
|       3 | Konfigurationsdokumentation  |             1 |        1 |
|       4 | Betriebshandbuch             |             1 |        1 |
|       5 | Runbooks                     |             1 |        1 |
|       6 | Abhängigkeiten               |             1 |        2 |
|       7 | Inventar und CMDB Bezug      |             1 |        2 |
|       8 | Betriebsdoku-Troubleshooting |          1,25 |        2 |
|         | **Summe**                    |      **8,75** |          |

## 5.1 Systemübersicht

Die Systemübersicht ist das Eingangstor in die Dokumentation eines IT-Systems. Sie beantwortet in zwei bis drei Minuten Lesezeit die Fragen, die jeder Neuling und jeder Bereitschaftsdienst zuerst stellt: Was ist das für ein System? Wozu dient es und für wen? Wie wichtig ist es? Wer ist verantwortlich? Wo liegt die weitere Dokumentation? Eine Systemübersicht ist bewusst kurz. Sie ersetzt weder Architekturdokumentation noch Betriebshandbuch, sondern verweist auf sie. Man kann sie mit dem Deckblatt einer Akte vergleichen: Sie enthält nicht alles, aber sie sagt, was in der Akte steht und wo man es findet.

Eine praxistaugliche Systemübersicht besteht aus acht Bestandteilen. Der *Name* und die *Kurzbeschreibung* (ein bis zwei Sätze) identifizieren das System. Der *Zweck* nennt den fachlichen Nutzen: Welchen Geschäftsprozess unterstützt es? Die *Kritikalität* gibt an, wie schwer ein Ausfall wiegt, und leitet daraus Wiederanlaufzeit und Dokumentationsstufe ab (siehe Modul 02, Abschnitt Scope und Abgrenzung). Die *Verantwortlichen* (Service Owner, technischer Ansprechpartner, Bereitschaft) nennen Rollen und Kontaktwege. Die *Umgebungen* (Produktion, Test, Entwicklung) mit Kennungen zeigen, wo das System läuft. Die *Schnittstellen und Abhängigkeiten* geben einen Überblick über wichtige Nachbarsysteme. Die *Betriebsdaten* nennen Betriebszeiten und Wartungsfenster. Die *Verweise* führen zu Architektur, Konfiguration, Runbooks und Notfallplänen.

Weil diese Angaben strukturiert und überschaubar sind, eignen sie sich dafür, in einer maschinenlesbaren Form gepflegt zu werden, aus der man das lesbare Dokument erzeugt. Das hat den Vorteil, dass sich dieselben Daten für mehrere Zwecke nutzen lassen (Übersichtsseite, Inventar, Bereitschaftsliste) und nur an einer Stelle gepflegt werden, ganz im Sinne der Single Source of Truth. Das folgende Beispiel zeigt eine Datei `system.yml` für einen Webshop sowie ein Skript, das daraus eine Markdown-Seite erzeugt.

```yaml
name: Webshop
kurz: Online-Shop für Endkunden inklusive Warenkorb und Bezahlung
zweck: Verkauf von Produkten über das Internet
kritikalitaet: hoch
owner: Team Plattform
bereitschaft: bereitschaft-shop@example.org
umgebungen: [prod, test]
betriebszeit: rund um die Uhr
wartungsfenster: Dienstag 02:00 bis 04:00 Uhr
abhaengig_von: [Datenbank, Zahlungsdienst, Mailversand]
doku:
  architektur: architektur.md
  runbooks: runbooks/
```

```python
import sys, yaml

d = yaml.safe_load(open(sys.argv[1], encoding="utf-8"))
print(f"# Systemübersicht {d['name']}\n")
print(f"**Zweck:** Dieses Dokument ermöglicht den Überblick über {d['name']}.\n")
print(d["kurz"] + "\n")
print("| Merkmal | Wert |\n|---|---|")
for schluessel in ("zweck", "kritikalitaet", "owner", "bereitschaft",
                   "betriebszeit", "wartungsfenster"):
    print(f"| {schluessel} | {d[schluessel]} |")
print("\n## Abhängigkeiten")
for a in d["abhaengig_von"]:
    print("- " + a)
print("\n## Weiterführende Dokumentation")
for name, pfad in d["doku"].items():
    print(f"- {name}: {pfad}")
```

Die Datei beschreibt das System in überschaubaren Feldern. Das Skript benötigt die Bibliothek PyYAML (`pip install pyyaml`) und liest die Datei mit `yaml.safe_load`, einer sicheren Variante, die keinen beliebigen Code ausführt. Es gibt anschließend eine Markdown-Seite aus: Überschrift, Zweckstempel, eine Tabelle der Merkmale, die Abhängigkeiten und die Verweise. Die Reihenfolge der Merkmale ist im Skript festgelegt, sodass alle Systemübersichten gleich aufgebaut sind. Damit wird Gleichförmigkeit (Modul 03) nicht erbeten, sondern erzeugt.

Typische Fehler: Die Übersicht wächst zu einem Mini-Handbuch, weil jeder seine Lieblingsinformation ergänzt. Sie nennt keinen Verantwortlichen oder nur eine Person statt einer Rolle, sodass sie bei Urlaub oder Weggang wertlos ist. Oder sie ist einmalig entstanden und nie überprüft worden, sodass Angaben wie die Bereitschaftsadresse veraltet sind.

| **Falsch**                                                          | **Richtig**                                                                                                                                                          |
|:--------------------------------------------------------------------|:---------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| „Der Shop läuft auf mehreren Servern. Ansprechpartner: Herr Maier.“ | „Webshop, Kritikalität hoch, Owner: Team Plattform (bereitschaft-shop@example.org), Wartungsfenster Dienstag 02:00 bis 04:00 Uhr, Architektur siehe architektur.md.“ |

Im Projekt ist die Systemübersicht das erste Dokument, das bei einer Übergabe verlangt wird. Wer sie nicht in einer halben Stunde ausfüllen kann, kennt sein System nicht gut genug, um es zu übergeben.

## 5.2 Architekturdokumentation

Die Architekturdokumentation beschreibt, aus welchen Bausteinen ein System besteht, wie diese zusammenwirken und warum es so gebaut wurde. Sie ist das Dokument, das später über Änderbarkeit entscheidet: Wer ein System weiterentwickeln soll, muss verstehen, welche Entscheidungen es prägen. Zwei Fehlentwicklungen sind typisch. Entweder gibt es gar keine Architekturdokumentation, sodass sie im Kopf des ursprünglichen Architekten liegt, oder sie ist ein hundertseitiges Werk, das niemand aktuell hält und deshalb niemand liest.

Ein bewährtes Mittel gegen beides ist ein vorgegebenes Gerüst. Das verbreitete Template arc42 gliedert Architekturdokumentation in zwölf Abschnitte.

> **Ergänzung aus der Nachrecherche**
>
> arc42: Laut der abgerufenen Referenzseite von arc42 besteht das Template aus zwölf Abschnitten: Einführung und Ziele, Randbedingungen, Kontext und Umfang, Lösungsstrategie, Bausteinsicht, Laufzeitsicht, Verteilungssicht, querschnittliche Konzepte, Architekturentscheidungen, Qualitätsanforderungen, Risiken und technische Schulden sowie Glossar (die Seite führt die englischen Namen; die deutschen sind hier übersetzt). Die Seite nennt außerdem 145 praktische Tipps und 35 Praxisbeispiele, geordnet nach den Abschnitten. (Abruf 28.10.2026, siehe Quellenverzeichnis.)

Das Besondere an dieser Gliederung ist, dass sie nach Fragen und Sichten organisiert ist: Die *Kontextabgrenzung* zeigt das System als Black Box mit seinen Nachbarn, die *Bausteinsicht* zerlegt es in Teile, die *Laufzeitsicht* zeigt, wie Bausteine in wichtigen Szenarien zusammenarbeiten, und die *Verteilungssicht* zeigt, auf welcher Infrastruktur das System läuft. Dazu kommen *Entscheidungen* und *Qualitätsanforderungen*. Man muss nicht alle zwölf Abschnitte ausfüllen; für kleine Systeme genügt eine Auswahl. Entscheidend ist, dass überhaupt eine Struktur vorliegt, die Leser wiedererkennen.

Zur Darstellung auf verschiedenen Detailstufen wird häufig das C4-Modell genutzt. Nach der abgerufenen Beschreibung kennt es vier Ebenen: Kontext, Container, Komponenten und Code. Die Kontextebene zeigt das System mit seinen Nutzern und externen Systemen und richtet sich an alle Beteiligten, die Containerebene zeigt die wesentlichen Anwendungen und Dienste, etwa Webserver und Datenbanken, und ihre Interaktionen. Die tieferen Ebenen sind den Entwicklern vorbehalten. In der Praxis genügen für die Betriebsdokumentation meist die ersten beiden Ebenen. Vertiefende Hinweise zu Diagrammen folgen in Modul 09.

Ein besonders wertvoller Teil sind Architekturentscheidungen, kurz ADRs (Architecture Decision Records). Eine ADR ist eine kurze Notiz, die eine Entscheidung mit Kontext, Alternativen und Folgen festhält. Das nachstehende Beispiel zeigt eine ADR sowie ein einfaches Mermaid-Diagramm der Containerebene. Mermaid ist eine textbasierte Diagrammsprache, die viele Wikis und Dokumentationswerkzeuge direkt darstellen.

```markdown
# ADR-007: PostgreSQL als zentrale Datenbank

**Status:** akzeptiert  **Datum:** 2026-03-12

## Kontext
Der Shop benötigt transaktionssichere Speicherung von Bestellungen.

## Entscheidung
Wir verwenden PostgreSQL 16 als einzige Datenbank.

## Alternativen
- MySQL: gleichwertig, aber im Team weniger Erfahrung
- Dokumentendatenbank: schwächere Transaktionen

## Folgen
Betrieb und Backup werden vereinheitlicht. Reporting-Abfragen
laufen auf einem Replikat.
```

```text
flowchart LR
    Kunde([Kunde]) --> Web[Webserver]
    Web --> App[Shop-Anwendung]
    App --> DB[(PostgreSQL)]
    App --> Pay[Zahlungsdienst]
```

Die ADR hält fest, *was* entschieden wurde, *warum* und *mit welchen Folgen*. Gerade die Alternativen und ihre Abwägung werden später am häufigsten vermisst, denn das Ergebnis lässt sich im System erkennen, die Begründung nicht. Das Diagramm zeigt vier Elemente und ihre Beziehungen in einer Zeile pro Verbindung. Der Vorteil dieser textbasierten Form liegt darin, dass sie sich versionieren und im Review vergleichen lässt wie Code. Das Skript, das die Vollständigkeit einer arc42-Dokumentation prüft, ist unten dargestellt.

```python
import re, sys

ABSCHNITTE = ["Einführung und Ziele", "Randbedingungen", "Kontext und Umfang",
              "Lösungsstrategie", "Bausteinsicht", "Laufzeitsicht",
              "Verteilungssicht", "Querschnittliche Konzepte",
              "Architekturentscheidungen", "Qualitätsanforderungen",
              "Risiken und technische Schulden", "Glossar"]

text = open(sys.argv[1], encoding="utf-8").read()
titel = {t.strip().lower() for t in re.findall(r"^#{1,3} (?:\d+\.? )?(.+)$", text, re.M)}
fehlt = [a for a in ABSCHNITTE if a.lower() not in titel]
print(f"{len(ABSCHNITTE) - len(fehlt)} von {len(ABSCHNITTE)} Abschnitten vorhanden")
for a in fehlt:
    print("  fehlt:", a)
```

Das Skript sammelt alle Überschriften (optional mit vorangestellter Nummer wie „5.“) und vergleicht sie ohne Beachtung der Groß- und Kleinschreibung mit der Liste der zwölf Abschnitte. Es meldet, wie viele vorhanden sind und welche fehlen. Wichtig: Das Skript prüft nur Vorhandensein, nicht Qualität. Ein leerer Abschnitt „Risiken“ besteht die Prüfung. Das Skript ist ein Gerüstwächter, kein Gutachter.

Typische Fehler: Die Dokumentation beschreibt nur Bausteine, aber nicht Zusammenhänge und Entscheidungen. Diagramme zeigen alles in einem Bild, das niemand lesen kann. Architekturdokumentation wird einmal beim Projektende erstellt und bei Änderungen nicht mehr berücksichtigt, sodass sie nach einem Jahr eine Beschreibung eines Systems ist, das nicht mehr existiert.

| **Falsch**                                                                | **Richtig**                                                                                                                                                     |
|:--------------------------------------------------------------------------|:----------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Ein Diagramm mit 60 Kästchen, ohne Legende und ohne Erklärung der Linien. | Ein Kontextdiagramm mit dem System und seinen fünf wichtigsten Nachbarn, ein Containerdiagramm mit den Hauptbausteinen und eine ADR pro wichtiger Entscheidung. |

Im Projekt hilft Architekturdokumentation vor allem bei Personalwechseln und bei Änderungen mit größerer Tragweite: Wer eine Datenbank ersetzen will, findet in der ADR, was damals gegen die Alternative sprach.

## 5.3 Konfigurationsdokumentation

Konfigurationsdokumentation beschreibt, wie ein System eingestellt ist und welche Einstellungen es gibt. Sie umfasst zwei verwandte, aber verschiedene Dinge: die *Konfigurationsreferenz*, die alle möglichen Parameter mit Bedeutung, erlaubten Werten und Standardwert beschreibt, und die *Konfigurationsdokumentation einer konkreten Installation*, die festhält, welche Werte tatsächlich gesetzt sind und warum. Beides folgt dem Prinzip, dass Konfigurationen nachvollziehbar sein müssen: Wer einen Wert ändert, soll wissen, welche Wirkung das hat und warum der aktuelle Wert gewählt wurde.

Der größte Feind der Konfigurationsdokumentation ist die Abweichung zwischen dem, was dokumentiert ist, und dem, was im System tatsächlich steht (englisch *Configuration Drift*). Sie entsteht, wenn jemand einen Wert im laufenden System ändert und die Dokumentation vergisst. Die beste Gegenmaßnahme ist, die Konfiguration selbst zur Quelle zu machen: Wenn Einstellungen in Dateien liegen (Infrastructure as Code, Konfigurationsmanagement), die versioniert werden, ist die Datei zugleich die genaueste Dokumentation, und die Beschreibung muss nur das *Warum* ergänzen. Je mehr sich die Referenz aus der Konfiguration oder dem Code ableiten lässt, desto weniger kann sie veralten.

Als Mindestumfang für jeden Parameter in einer Referenz gelten Name, Bedeutung, Typ und erlaubte Werte, Standardwert, Wirkung einer Änderung und gegebenenfalls Neustartbedarf. Das nachfolgende Beispiel verwendet eine Parameterliste als CSV und erzeugt daraus eine Markdown-Tabelle. Danach prüft ein zweites Skript, ob alle Parameter der echten Konfigurationsdatei in der Referenz beschrieben sind.

```text
parameter;bedeutung;standard;neustart
max_connections;Maximale gleichzeitige Verbindungen;100;ja
timeout_seconds;Abbruch nach Sekunden ohne Antwort;30;nein
log_level;Detailgrad des Logs (info, debug);info;nein
```

```python
import csv, sys

zeilen = list(csv.DictReader(open("parameter.csv", encoding="utf-8"), delimiter=";"))
dokumentiert = {z["parameter"] for z in zeilen}

# Referenz als Markdown-Tabelle ausgeben
print("| Parameter | Bedeutung | Standard | Neustart |\n|---|---|---|---|")
for z in zeilen:
    print(f"| `{z['parameter']}` | {z['bedeutung']} | {z['standard']} | {z['neustart']} |")

# Abgleich mit der echten Konfigurationsdatei (Zeilen der Form schluessel = wert)
echt = set()
for zeile in open(sys.argv[1], encoding="utf-8"):
    zeile = zeile.split("#", 1)[0].strip()
    if "=" in zeile:
        echt.add(zeile.split("=", 1)[0].strip())

print()
for p in sorted(echt - dokumentiert):
    print("UNDOKUMENTIERT:", p)
for p in sorted(dokumentiert - echt):
    print("NICHT MEHR VORHANDEN:", p)
```

Das Skript hat zwei Aufgaben. Erstens erzeugt es aus der CSV die Referenztabelle, sodass die Tabelle nie von Hand formatiert werden muss. Zweitens liest es eine echte Konfigurationsdatei (Zeilen `schluessel = wert`, Kommentare hinter `#` werden ignoriert) und vergleicht die Parameternamen mit der Referenz. Mengendifferenzen mit `-` liefern zwei Listen: Parameter, die konfiguriert, aber nicht dokumentiert sind, und Parameter, die dokumentiert, aber in der Konfiguration nicht mehr vorhanden sind. Beide Listen sind Hinweise auf Drift. Die Abfrage lässt sich in eine Pipeline einbauen, sodass sie bei jeder Änderung läuft.

Typische Fehler: Konfigurationswerte werden ohne Begründung dokumentiert („max_connections = 250“ ohne Hinweis, warum), geheime Werte wie Passwörter stehen in der Dokumentation (siehe Modul 13), und Konfigurationsdokumentation entsteht als Kopie des Systemzustands in einem Textdokument, das sofort veraltet. Wo Werte aus Sicherheitsgründen nicht genannt werden dürfen, nennt man ihren Ablageort: „Passwort im Passwortmanager unter Plattform/DB“.

| **Falsch**                                                 | **Richtig**                                                                                                                                         |
|:-----------------------------------------------------------|:----------------------------------------------------------------------------------------------------------------------------------------------------|
| „max_connections: 250“ (ohne Begründung, Stand unbekannt). | „max_connections: 250 (Standard: 100). Erhöht am 2026-09-10 wegen Lastspitzen im Weihnachtsgeschäft, siehe Ticket OPS-1234. Neustart erforderlich.“ |

Im Projekt ist der Verweis auf das Ticket die einfachste Form, das *Warum* festzuhalten: Er kostet fünf Sekunden und spart später Stunden.

## 5.4 Betriebshandbuch

Das Betriebshandbuch (englisch auch *Operations Manual*) bündelt alles, was der Betrieb braucht, um ein System im Alltag zu führen. Es richtet sich an Administratoren und Bereitschaftsdienste, nicht an Entwickler oder Endnutzer. Anders als die Architekturdokumentation, die das Warum erklärt, beantwortet das Betriebshandbuch die Frage: *Was tue ich, damit das System läuft, und was tue ich, wenn es nicht läuft?* Es ist daher überwiegend aus Anleitungen (How-to) und Referenzen aufgebaut, mit wenig erklärender Prosa.

Der übliche Aufbau umfasst sieben Kapitel. Die *Übersicht* verweist auf die Systemübersicht und listet Verantwortliche und Erreichbarkeit. Die *Regelbetrieb-Aufgaben* beschreiben wiederkehrende Tätigkeiten (Start und Stopp, Überwachung, Datensicherung, Zertifikate, Updates). Die *Überwachung* nennt, welche Kennzahlen und Alarme es gibt und was sie bedeuten. Die *Störungsbehebung* enthält Runbooks für bekannte Fehlerbilder. Die *Notfall- und Wiederherstellungsverfahren* beschreiben das Vorgehen bei schweren Ausfällen. Die *Änderungsverfahren* regeln, wie Änderungen geplant und freigegeben werden. Der *Anhang* enthält Referenzen, Kontakte und Glossar. Dieses Gerüst muss pro System nicht neu erfunden werden, es genügt, es als Vorlage zu halten (siehe Modul 07).

Wichtig ist die Zugänglichkeit. Ein Betriebshandbuch, das nur im Wiki liegt, ist nutzlos, wenn das Wiki wegen desselben Vorfalls nicht erreichbar ist. Deshalb gehört zum Betriebsmodell eine *Offline-Kopie* der kritischen Teile: ein PDF auf den Notebooks der Bereitschaft, ein Ausdruck im Rechenzentrum oder eine Kopie auf einem unabhängigen System. Das folgende Beispiel zeigt eine Inhaltsvorlage als Markdown und ein Skript, das für alle Systeme prüft, ob die Kapitel des Betriebshandbuchs vorhanden sind.

```markdown
# Betriebshandbuch <Systemname>

## 1 Übersicht
## 2 Regelbetrieb
## 3 Überwachung
## 4 Störungsbehebung
## 5 Notfall und Wiederherstellung
## 6 Änderungsverfahren
## 7 Anhang
```

```python
import pathlib, re, sys

KAPITEL = ["Übersicht", "Regelbetrieb", "Überwachung", "Störungsbehebung",
           "Notfall und Wiederherstellung", "Änderungsverfahren", "Anhang"]

for datei in sorted(pathlib.Path(sys.argv[1]).glob("*/betriebshandbuch.md")):
    text = datei.read_text(encoding="utf-8")
    titel = [t.strip() for t in re.findall(r"^## (?:\d+ )?(.+)$", text, re.M)]
    fehlt = [k for k in KAPITEL if k not in titel]
    status = "vollständig" if not fehlt else "fehlt: " + ", ".join(fehlt)
    print(f"{datei.parent.name:15s} {status}")
```

Die Vorlage gibt allen Systemen dieselbe Kapitelstruktur. Das Skript geht durch alle Systemordner des angegebenen Verzeichnisses, öffnet jeweils `betriebshandbuch.md` und vergleicht die Kapitelüberschriften mit der Soll-Liste. Die Ausgabe zeigt pro System den Status. Dasselbe Prinzip lässt sich für andere Dokumentenarten verwenden: Eine Pflichtliste, ein Vergleich, eine Übersicht.

Typische Fehler: Das Betriebshandbuch ist ein Sammelsurium von Einzeldokumenten ohne Gliederung, es verschweigt, was nicht funktioniert, oder es beschreibt den Soll-Betrieb, der längst nicht mehr dem Ist entspricht. Ebenso verbreitet ist die Annahme, es müsse in einem Dokument stehen: Besser ist eine schlanke Haupt-Seite, die auf Runbooks und Referenzen verlinkt.

| **Falsch**                                                                                    | **Richtig**                                                                                                                               |
|:----------------------------------------------------------------------------------------------|:------------------------------------------------------------------------------------------------------------------------------------------|
| Ein 80-seitiges PDF „Betrieb Shop Version final“, das seit zwei Jahren nicht angefasst wurde. | Ein kurzes Betriebshandbuch im Wiki mit sieben Kapiteln, verlinkten Runbooks, Prüfdatum und einer Offline-Kopie der kritischen Verfahren. |

Im Projekt ist die Abnahme des Betriebshandbuchs ein Meilenstein der Übergabe an den Betrieb: Ohne dieses Dokument ist ein System nicht betriebsbereit.

## 5.5 Runbooks

Ein Runbook ist eine Anleitung für eine wiederkehrende oder erwartbare betriebliche Aufgabe, die so geschrieben ist, dass sie auch unter Zeitdruck von einer fachkundigen, aber nicht systemkundigen Person abgearbeitet werden kann. Die sprachlichen Grundlagen (Handlungsanweisungen, Warnhinweise, Schritt-für-Schritt-Aufbau) haben Sie in Modul 04 gelernt. Hier geht es um die Rolle des Runbooks im Betrieb und um seine besonderen Anforderungen.

Es gibt mehrere Arten. *Routine-Runbooks* beschreiben geplante Aufgaben (Zertifikat erneuern, Update einspielen). *Störungs-Runbooks* (oft auch Playbooks genannt) reagieren auf einen Alarm oder ein Fehlerbild: Sie beginnen mit dem Symptom, führen durch Diagnose und enden mit Behebung oder Eskalation. *Notfall-Runbooks* beschreiben das Vorgehen bei schweren Ausfällen, etwa die vollständige Wiederherstellung. Alle drei Arten teilen Anforderungen, die über normale Anleitungen hinausgehen. Sie müssen *auffindbar* sein, idealerweise direkt aus dem Alarm heraus verlinkt, *aktuell* (mit Prüfdatum und Owner), *getestet* (sie wurden mindestens einmal tatsächlich ausgeführt) und *vollständig im Abbruchfall*: Jeder riskante Schritt hat einen Rückweg.

Ein wirksames Runbook beginnt mit dem Anlass und der Frage „Bin ich hier richtig?“: Welcher Alarm, welches Symptom, welche Auswirkung? Es nennt die Voraussetzungen (Zugänge, Werkzeuge), führt dann Schritt für Schritt durch Diagnose und Behebung und schließt mit einer Prüfung, einer Kommunikation (wer wird informiert?) und einer Nachbereitung (Ticket, Eintrag in das Betriebstagebuch). Fortgeschrittene Teams automatisieren schrittweise: Ein Runbook wird erst als Text geführt, dann mit kopierbaren Befehlen, dann als Skript, das ein Mensch startet und überwacht. Das nachstehende Beispiel zeigt ein solches Skript für den Neustart eines Dienstes, mit Prüfungen vor und nach der Aktion sowie einem Probelauf-Modus.

```bash
#!/usr/bin/env bash
# Runbook: Dienst neu starten (Beispiel)
# Aufruf: ./neustart.sh <dienst> [--dry-run]
set -euo pipefail

dienst="${1:?Dienstname fehlt}"
probelauf="${2:-}"

echo "1. Status vor dem Neustart:"
systemctl is-active "$dienst" || echo "   (Dienst ist nicht aktiv)"

if [ "$probelauf" = "--dry-run" ]; then
  echo "2. [Probelauf] würde ausführen: systemctl restart $dienst"
  exit 0
fi

echo "2. Neustart ..."
systemctl restart "$dienst"

echo "3. Prüfung:"
if systemctl is-active --quiet "$dienst"; then
  echo "   OK: $dienst läuft."
else
  echo "   FEHLER: $dienst läuft nicht. Siehe Eskalation im Runbook." >&2
  exit 1
fi
```

Das Skript trägt die Struktur des Runbooks in sich: nummerierte Schritte, eine Prüfung vor der Aktion, einen Probelauf, eine Prüfung danach. Die Zeile `set -euo pipefail` lässt das Skript bei Fehlern abbrechen und nicht still weiterlaufen. Der Ausdruck `${1:?Dienstname fehlt}` erzwingt den Parameter und bricht mit einer Fehlermeldung ab, wenn er fehlt. Der Probelauf zeigt, was geschehen würde, ohne es auszuführen: Das ist die einfachste Form, ein Runbook gefahrlos zu testen. Bei einem Fehler wird mit Rückgabewert 1 beendet, damit aufrufende Werkzeuge den Fehler erkennen.

Typische Fehler: Runbooks werden nie ausgeführt und enthalten Befehle, die nicht funktionieren. Sie setzen Zugänge voraus, die die Bereitschaft nicht hat. Es fehlt die Entscheidungshilfe, wann man abbrechen und eskalieren soll, sodass Bereitschaftsdienste endlos weiterprobieren. Und sie liegen an einem Ort, der im Störungsfall nicht erreichbar ist.

| **Falsch**                                         | **Richtig**                                                                                                                                   |
|:---------------------------------------------------|:----------------------------------------------------------------------------------------------------------------------------------------------|
| „Dienst neu starten und dann schauen, ob es geht.“ | „1. Status prüfen. 2. Neustart. 3. Prüfen mit systemctl is-active. Wenn nicht aktiv: Eskalation an Bereitschaft Stufe 2 (Telefon im Anhang).“ |

Im Projekt ist die wirksamste Qualitätsmaßnahme für Runbooks die regelmäßige Übung: Ein Runbook, das nie getestet wurde, ist nur eine Hoffnung.

## 5.6 Abhängigkeiten

Kein System läuft für sich allein. Es braucht eine Datenbank, einen Zahlungsdienst, einen Verzeichnisdienst, ein Netzwerk, Stromversorgung. Die Dokumentation dieser *Abhängigkeiten* beantwortet zwei Fragen, die im Betrieb ständig auftauchen: „Wovon hängt dieses System ab?“ und umgekehrt „Was fällt aus, wenn dieses System ausfällt?“ Die erste Frage hilft bei der Ursachensuche (ein Dienst ist langsam: liegt es an der Datenbank?), die zweite bei der Auswirkungsanalyse (die Datenbank soll gewartet werden: wer ist betroffen?).

Man unterscheidet *harte* und *weiche* Abhängigkeiten. Bei einer harten Abhängigkeit funktioniert das System ohne den Partner überhaupt nicht (Webshop ohne Datenbank). Bei einer weichen Abhängigkeit ist es eingeschränkt nutzbar (Webshop ohne Mailversand: Bestellungen gehen ein, Bestätigungen verzögern sich). Weiter unterscheidet man *direkte* und *transitive* Abhängigkeiten: Wenn A von B und B von C abhängt, hängt A transitiv von C ab. Genau diese indirekten Beziehungen übersieht man bei Wartungsarbeiten am häufigsten.

Weil Abhängigkeiten ein Netz bilden, lassen sie sich nur in strukturierter Form sinnvoll pflegen. Das folgende Beispiel zeigt eine Abhängigkeitsdatei und ein Skript, das daraus die Auswirkungsanalyse berechnet: Es findet alle Systeme, die direkt oder indirekt von einem ausgefallenen System abhängen. Dieselbe Logik prüft auch auf Zyklen, also auf Systeme, die sich gegenseitig voraussetzen, was beim Wiederanlauf zu einer Sackgasse führt.

```yaml
webshop: [datenbank, zahlungsdienst, mailversand]
mailversand: [smtp-relay]
reporting: [datenbank]
datenbank: [storage, netzwerk]
zahlungsdienst: [netzwerk]
```

```python
import sys

abh = {}
for zeile in open(sys.argv[1], encoding="utf-8"):
    if ":" in zeile:
        system, rest = zeile.split(":", 1)
        abh[system.strip()] = [x.strip() for x in rest.strip(" []\n").split(",") if x.strip()]

def betroffen(ausfall):
    """Alle Systeme, die direkt oder indirekt vom Ausfall abhängen."""
    ergebnis, neu = set(), {ausfall}
    while neu:
        naechste = {s for s, ziele in abh.items()
                    if any(z in neu for z in ziele) and s not in ergebnis}
        ergebnis |= naechste
        neu = naechste
    return ergebnis

print("Ausfall von datenbank betrifft:", sorted(betroffen("datenbank")))
print("Ausfall von netzwerk betrifft: ", sorted(betroffen("netzwerk")))
```

Die Datei beschreibt für jedes System seine Voraussetzungen. Das Skript baut daraus ein Wörterbuch. Die Funktion `betroffen` arbeitet in Wellen: Zuerst werden alle Systeme gesucht, die direkt vom Ausfall abhängen, dann alle, die von diesen abhängen, und so weiter, bis keine neuen mehr hinzukommen. Mit den Beispieldaten ergibt sich: Fällt die Datenbank aus, sind Webshop und Reporting betroffen. Fällt das Netzwerk aus, sind Datenbank, Zahlungsdienst, Webshop und Reporting betroffen, weil die Wirkung sich über die Datenbank fortsetzt. Genau das macht die transitive Analyse so wertvoll.

Typische Fehler: Abhängigkeiten stehen nur im Kopf des Architekten oder in einem Diagramm, das sich nicht auswerten lässt. Es werden nur technische Abhängigkeiten erfasst, nicht organisatorische (der Zahlungsdienst gehört einem externen Anbieter mit eigenen Wartungsfenstern). Und die Dokumentation unterscheidet nicht zwischen hart und weich, sodass jede Wartung wie ein Großereignis behandelt wird.

| **Falsch**                                       | **Richtig**                                                                                                 |
|:-------------------------------------------------|:------------------------------------------------------------------------------------------------------------|
| „Der Shop braucht noch ein paar andere Systeme.“ | Abhängigkeitsliste mit Typ: „webshop braucht datenbank (hart), mailversand (weich), zahlungsdienst (hart)“. |

Im Projekt ist die Auswirkungsanalyse bei jeder Wartung ein Pflichtschritt: Wer sie aus der Dokumentation in Sekunden erzeugen kann, vermeidet unangenehme Überraschungen.

## 5.7 Inventar und CMDB-Bezug

Ein Inventar listet die Dinge auf, die eine Organisation betreibt: Server, Anwendungen, Datenbanken, Netzwerkgeräte, Zertifikate, Lizenzen. Eine *CMDB* (Configuration Management Database) geht darüber hinaus: Sie verwaltet diese Dinge als sogenannte *Configuration Items* (CIs) samt Attributen und *Beziehungen* untereinander, also auch die Abhängigkeiten aus dem vorigen Abschnitt. In der IT-Service-Management-Praxis (ITIL) dient die CMDB als gemeinsame Wahrheit über die IT-Landschaft für Störungsmanagement, Änderungsmanagement und Auswertungen.

Das Verhältnis von Dokumentation zur CMDB wird oft missverstanden. Die CMDB ist *keine* Dokumentation im Sinne von Erklärungen, sie ist ein strukturierter Datenbestand. Dokumentation ist *kein* Ersatz für die CMDB, sie ergänzt sie um Wissen: Warum, wie, wann. Die Verbindung zwischen beiden schafft man über stabile Kennungen: Jedes CI hat eine eindeutige ID, und die Dokumentation verweist darauf. Umgekehrt trägt das CI einen Link zur Dokumentation. So gilt für jede Information, wer sie führt: Fakten über das Objekt (Standort, Version, Besitzer) stehen in der CMDB, Wissen darüber (Betriebshandbuch, Architektur) steht in der Dokumentation.

Das Hauptproblem ist, wie bei der Konfiguration, die Abweichung zwischen den Beständen. Das folgende Beispiel zeigt einen Abgleich zwischen einem Export der CMDB und der dokumentierten Systemliste. Er findet Systeme, die in der CMDB geführt werden, aber keine Dokumentation haben (Lücke), und Dokumentationen zu Systemen, die es nicht mehr gibt (Altlast).

```text
ci_id;name;umgebung;owner
CI-001;webshop;prod;Team Plattform
CI-002;datenbank;prod;Team Plattform
CI-003;mailversand;prod;Team Betrieb
CI-004;altsystem;prod;unbekannt
```

```python
import csv, pathlib, sys

cmdb = {z["name"]: z for z in csv.DictReader(open(sys.argv[1], encoding="utf-8"), delimiter=";")}
doku = {p.name for p in pathlib.Path(sys.argv[2]).iterdir() if p.is_dir()}

print("In der CMDB, aber ohne Dokumentation:")
for name in sorted(set(cmdb) - doku):
    print("  ", name, "-", cmdb[name]["owner"])

print("Dokumentation ohne CMDB-Eintrag:")
for name in sorted(doku - set(cmdb)):
    print("  ", name)

print("CIs ohne Owner:", [n for n, z in cmdb.items() if z["owner"] in ("", "unbekannt")])
```

Das Skript liest den CMDB-Export als Wörterbuch (Name auf Zeile) und die Ordnernamen im Dokumentationsverzeichnis als Menge. Mengendifferenzen in beide Richtungen liefern die beiden Abweichungslisten, die dritte Zeile findet CIs ohne verantwortliche Stelle. Auffällig im Beispiel: `altsystem` hat den Owner „unbekannt“ und fehlt zugleich in der Dokumentation, sodass es in der ersten Liste und in der Owner-Auswertung erscheint; `mailversand` ist ein weiterer Fall der ersten Liste, und der Ordner `alt` im Dokumentationsverzeichnis wäre ein Fall der zweiten. Solche Funde sind keine Fehler des Skripts, sondern genau der Erkenntnisgewinn: Systeme ohne Owner sind ein Governance-Problem, das man sichtbar machen muss.

Typische Fehler: Zwei getrennte Inventare mit unterschiedlichen Namen für dasselbe System (CMDB: „WEB-PROD-01“, Dokumentation: „Shop-Server“); keine gemeinsame Kennung; Inventare, die einmal im Jahr bereinigt werden und dazwischen ein Eigenleben führen. Besonders verbreitet ist der Versuch, Erklärungstexte in die CMDB zu schreiben, wofür sie nicht gebaut ist.

| **Falsch**                                                           | **Richtig**                                                                   |
|:---------------------------------------------------------------------|:------------------------------------------------------------------------------|
| Dokumentation: „Shop-Server“; CMDB: „WEB-PROD-01“; keine Verbindung. | Dokumentation führt `ci_id: CI-001` im Kopf; die CMDB verlinkt zum Betriebshandbuch. |

Im Projekt ist die gemeinsame Kennung der Schlüssel: Sie macht aus zwei Listen ein Netz, in dem man von jedem Objekt zu seiner Dokumentation und von jeder Dokumentation zu ihrem Objekt springen kann.

## 5.8 Betriebsdoku-Troubleshooting

Betriebsdokumentation wird im Ernstfall gebraucht, und genau dann zeigen sich ihre Schwächen. Dieser Abschnitt zeigt, wie man typische Fehlerbilder anhand von Struktur, Aktualität, Zielgruppenfeedback und Review-Kommentaren eingrenzt und daraus Runbook-Schritte für Redaktion, Fachbereich und Betrieb ableitet. Das Vorgehen entspricht der Methode aus Modul 01: Symptom erfassen, Ursachenfeld bestimmen, Gegenprobe, Maßnahme.

Typische Symptome und Ursachenfelder: „Das Runbook funktioniert nicht“ deutet auf fehlende Tests oder Drift (die Umgebung hat sich geändert). „Ich habe das Dokument nicht gefunden“ deutet auf Auffindbarkeit und fehlende Verlinkung aus dem Alarm. „Die Dokumentation sagt etwas anderes als das System“ deutet auf Drift zwischen Konfiguration, CMDB und Dokumentation. „Ich hatte keine Berechtigung für den Schritt“ deutet auf ein Zusammenspiel von Zugriffsrechten und Dokumentation (Voraussetzungen fehlen). „Niemand wusste, wer zuständig ist“ deutet auf fehlende oder veraltete Owner und Kontaktdaten.

Ein Teil dieser Diagnose lässt sich automatisieren. Das folgende Skript prüft für eine Liste von Runbooks drei objektive Merkmale: Wurde es kürzlich geprüft? Wurde es kürzlich praktisch getestet? Wurde das System nach der letzten Prüfung geändert? Der letzte Punkt ist der wichtigste: Eine Änderung am System macht jedes Runbook verdächtig, das vor der Änderung geprüft wurde.

```text
runbook;system;geprueft;getestet
neustart-shop;webshop;2026-09-01;2026-06-15
restore-db;datenbank;2025-11-20;2025-11-20
zertifikat;webshop;2026-02-01;
```

```text
system;letzte_aenderung
webshop;2026-09-20
datenbank;2026-01-10
```

```python
import csv
from datetime import date, timedelta

heute = date(2026, 10, 28)   # fester Stichtag fuer ein reproduzierbares Beispiel
aenderung = {z["system"]: date.fromisoformat(z["letzte_aenderung"])
             for z in csv.DictReader(open("aenderungen.csv"), delimiter=";")}

for z in csv.DictReader(open("runbooks.csv"), delimiter=";"):
    probleme = []
    geprueft = date.fromisoformat(z["geprueft"])
    if geprueft < heute - timedelta(days=180):
        probleme.append("Prüfung älter als 180 Tage")
    if not z["getestet"]:
        probleme.append("nie praktisch getestet")
    elif date.fromisoformat(z["getestet"]) < heute - timedelta(days=365):
        probleme.append("Test älter als 365 Tage")
    if aenderung.get(z["system"], date.min) > geprueft:
        probleme.append("System nach der Prüfung geändert")
    print(z["runbook"], "->", "; ".join(probleme) or "ok")
```

Die erste Datei listet die Runbooks mit Prüf- und Testdatum, die zweite die letzte Änderung pro System. Das Skript verwendet einen festen Stichtag, damit das Ergebnis des Beispiels reproduzierbar ist (im Betrieb würde man `date.today()` nehmen). Pro Runbook sammelt es Auffälligkeiten: zu alte Prüfung, nie oder zu lange nicht getestet, Systemänderung nach der Prüfung. Mit den Beispieldaten sind alle drei Runbooks auffällig: `neustart-shop` wurde vor der Systemänderung vom 2026-09-20 geprüft, `restore-db` hat eine Prüfung, die älter als 180 Tage ist, und wurde ebenfalls vor einer Systemänderung geprüft, und `zertifikat` wurde außerdem nie praktisch getestet. Die Ausgabe ist eine direkte Arbeitsliste für den Betrieb.

Als Runbook für die Redaktion ergibt sich: Auswertung wöchentlich erzeugen, auffällige Runbooks dem Owner mit Frist zuweisen, den Test in einer Testumgebung durchführen lassen, Ergebnis im Dokumentkopf eintragen, Wirkung in der nächsten Auswertung prüfen. Bei Störungen gilt zusätzlich: Wenn ein Runbook im Ernstfall versagt hat, wird dies als Nacharbeit im Ticket erfasst und innerhalb einer festen Frist korrigiert.

Typische Fehler: Man repariert das Runbook, ohne die Ursache zu klären (Drift wird nicht bekämpft), man verwechselt Prüfung mit Test (ein Mensch hat gelesen, niemand hat ausgeführt), und man schiebt Korrekturen, weil der Vorfall vorbei ist. Das größte Versäumnis ist, nach einem Ausfall nicht nachzuschauen, ob die Dokumentation geholfen hat.

| **Falsch**                                                                             | **Richtig**                                                                                                                                                                |
|:---------------------------------------------------------------------------------------|:---------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| „Beim Ausfall hat das Runbook nicht gepasst, wir haben es dann irgendwie hinbekommen.“ | „Beim Ausfall war Schritt 4 veraltet. Im Nachbereitungsticket OPS-2201 ist die Korrektur mit Frist und Verantwortlichem erfasst; das Runbook wird danach erneut getestet.“ |

Im Projekt gehört die Frage „Hat die Dokumentation geholfen?“ in jede Nachbesprechung eines Vorfalls. Sie ist die ehrlichste Qualitätsmessung, die es gibt.

## Übungsaufgaben

Die Aufgaben steigen von Verständnisfragen (1 bis 3) über Anwendungsaufgaben (4 bis 6) bis zu Programmier- und Transferaufgaben (7 und 8) an.

**Aufgabe 1.** *(leicht)* Nennen Sie die acht Bestandteile einer Systemübersicht und erklären Sie, warum sie bewusst kurz gehalten wird.

**Aufgabe 2.** *(leicht)* Erklären Sie den Unterschied zwischen einer Konfigurationsreferenz und der Konfigurationsdokumentation einer konkreten Installation. Was ist Configuration Drift?

**Aufgabe 3.** *(leicht bis mittel)* Welche Aussagen gehören in eine ADR und welche in die Bausteinsicht? (a) „Wir nutzen PostgreSQL, weil die Transaktionssicherheit wichtiger ist als die Skalierbarkeit.“ (b) „Die Shop-Anwendung greift über Port 5432 auf die Datenbank zu.“ (c) „Alternativen waren MySQL und eine Dokumentendatenbank.“

**Aufgabe 4.** *(mittel)* Erstellen Sie für ein System Ihrer Wahl eine Datei `system.yml` im Format des Abschnitts Systemübersicht und listen Sie fünf Systeme, die davon abhängen oder von denen es abhängt, mit Typ (hart oder weich).

**Aufgabe 5.** *(mittel)* Entwerfen Sie ein Störungs-Runbook für den Alarm „Webserver antwortet nicht“ mit Voraussetzungen, mindestens fünf Schritten (Diagnose, Behebung), Prüfung, Eskalation und Rückweg.

**Aufgabe 6.** *(mittel, praktisch)* Schreiben Sie ein Skript, das eine Abhängigkeitsdatei im Format des Abschnitts Abhängigkeiten einliest und alle Systeme ausgibt, von denen *kein anderes* System abhängt (Endpunkte der Kette).

**Aufgabe 7.** *(anspruchsvoll, praktisch)* Erweitern Sie das Abhängigkeits-Skript um eine Zykluserkennung und testen Sie es mit einer Datei, in der `a` von `b` und `b` von `a` abhängt.

**Aufgabe 8.** *(anspruchsvoll, Transfer)* Bei einem Ausfall der Datenbank war das Runbook veraltet, die CMDB nannte einen Owner, der die Firma verlassen hat, und das Wiki war nicht erreichbar. Analysieren Sie die drei Ursachenfelder und entwerfen Sie je eine Maßnahme mit Verantwortlichem, Frist und Erfolgskriterium.

## Lösungen und Erläuterungen

**Lösung zu Aufgabe 1.** Bestandteile: Name und Kurzbeschreibung, Zweck, Kritikalität, Verantwortliche, Umgebungen, Schnittstellen und Abhängigkeiten, Betriebsdaten, Verweise. Die Übersicht ist kurz, weil sie das Eingangstor ist: Sie soll in wenigen Minuten orientieren und auf Vertiefungen verweisen. Wird sie lang, verliert sie diese Funktion und konkurriert mit Architektur und Betriebshandbuch, wodurch Doppelungen und Widersprüche entstehen.

**Lösung zu Aufgabe 2.** Die Referenz beschreibt alle möglichen Parameter (Bedeutung, Typ, erlaubte Werte, Standardwert), unabhängig von einer Installation. Die Dokumentation einer Installation hält fest, welche Werte tatsächlich gesetzt sind und warum sie so gesetzt sind. Configuration Drift ist die Abweichung zwischen dokumentierter und tatsächlicher Konfiguration, die entsteht, wenn Werte direkt am System geändert werden, ohne die Dokumentation oder die Konfigurationsdatei im Repository anzupassen.

**Lösung zu Aufgabe 3.** (a) ADR, weil sie die Begründung einer Entscheidung enthält. (b) Bausteinsicht oder Schnittstellenbeschreibung, weil es um den Aufbau und die Verbindung der Bausteine geht. (c) ADR, Abschnitt Alternativen. Merkregel: Die ADR erklärt, *warum*, die Bausteinsicht beschreibt, *was* da ist.

**Lösung zu Aufgabe 4.** Eine mögliche Lösung (Auszug) für das System „Kundenportal“:

```yaml
name: Kundenportal
kurz: Portal zur Selbstverwaltung von Verträgen
zweck: Kunden verwalten Verträge ohne Anruf
kritikalitaet: mittel
owner: Team Anwendungen
bereitschaft: bereitschaft-portal@example.org
umgebungen: [prod, test]
betriebszeit: Mo-Fr 06:00-22:00 Uhr
wartungsfenster: Sonntag 03:00-05:00 Uhr
abhaengig_von: [datenbank (hart), identitaetsdienst (hart), mailversand (weich),
                dokumentenablage (weich), netzwerk (hart)]
```

Wichtig ist die Unterscheidung nach Typ: Ohne Datenbank, Identitätsdienst und Netz ist das Portal unbenutzbar, ohne Mailversand und Dokumentenablage eingeschränkt. Die Zeitangaben und Namen sind frei gewählte Beispielwerte.

**Lösung zu Aufgabe 5.** Ein möglicher Entwurf (Auszug): Anlass: Alarm „Webserver antwortet nicht“, Auswirkung: Kunden sehen Fehlerseite. Voraussetzungen: SSH-Zugang, Rolle Betrieb. Schritte: (1) Prüfen Sie den Dienststatus mit `systemctl status nginx`. (2) Wenn der Status „failed“ lautet, lesen Sie die letzten 50 Logzeilen mit `journalctl -u nginx -n 50`. (3) Prüfen Sie die Konfiguration mit `nginx -t`. (4) Wenn die Prüfung fehlerfrei ist, starten Sie den Dienst mit `systemctl restart nginx`. (5) Prüfen Sie den Aufruf der Startseite mit `curl -I https://<Servername>`; erwartet wird der Code 200. Rückweg: Wenn Schritt 3 einen Fehler meldet, stellen Sie die letzte funktionierende Konfiguration aus der Versionsverwaltung wieder her. Eskalation: Wenn der Dienst nach zwei Versuchen nicht läuft oder die Prüfung scheitert, rufen Sie die Bereitschaft Stufe 2 an. Wichtig sind die Verzweigungen und die Abbruchkriterien.

**Lösung zu Aufgabe 6.** Eine mögliche Lösung:

```python
import sys

abh = {}
for zeile in open(sys.argv[1], encoding="utf-8"):
    if ":" in zeile:
        s, rest = zeile.split(":", 1)
        abh[s.strip()] = [x.strip() for x in rest.strip(" []\n").split(",") if x.strip()]

alle = set(abh) | {z for ziele in abh.values() for z in ziele}
benutzt = {z for ziele in abh.values() for z in ziele}
for s in sorted(alle - benutzt):
    print(s)
```

Die Menge `alle` umfasst alle Systeme, auch solche, die nur als Voraussetzung vorkommen. `benutzt` sind diejenigen, von denen mindestens ein System abhängt. Die Differenz sind die Endpunkte: Mit den Beispieldaten des Abschnitts ergibt das `reporting` und `webshop`, also die Systeme, die nirgends Voraussetzung sind. Solche Systeme sind meist die für Nutzer sichtbaren Anwendungen.

**Lösung zu Aufgabe 7.** Eine mögliche Lösung für die Zykluserkennung:

```python
def hat_zyklus(abh):
    zustand = {}          # 1 = in Bearbeitung, 2 = fertig
    def besuche(s):
        if zustand.get(s) == 1:
            return True
        if zustand.get(s) == 2:
            return False
        zustand[s] = 1
        for z in abh.get(s, []):
            if besuche(z):
                return True
        zustand[s] = 2
        return False
    return any(besuche(s) for s in list(abh))

print(hat_zyklus({"a": ["b"], "b": ["a"]}))     # True
print(hat_zyklus({"a": ["b"], "b": ["c"]}))     # False
```

Das Verfahren ist eine Tiefensuche. Ein System ist während seiner Bearbeitung „in Bearbeitung“; trifft die Suche auf dem Weg erneut auf ein solches System, liegt ein Zyklus vor. Fertige Systeme werden nicht erneut untersucht. Im Betrieb bedeutet ein Zyklus ein Wiederanlaufproblem: Beide Systeme warten aufeinander. Der Befund gehört in die Dokumentation und führt zu einer Entscheidung, welches System zuerst manuell gestartet werden darf.

**Lösung zu Aufgabe 8.** Ursachenfeld 1, veraltetes Runbook: Ursache ist fehlende Kopplung an Änderungen und fehlende Tests. Maßnahme: Auswertung wie im Abschnitt Betriebsdoku-Troubleshooting wöchentlich erzeugen, Runbooks der Stufe A nach jeder Änderung neu prüfen und halbjährlich praktisch testen; Verantwortlich: Service Owner; Frist: Ersteinführung in sechs Wochen; Erfolgskriterium: kein Runbook der Stufe A ist älter als 180 Tage geprüft. Ursachenfeld 2, veralteter Owner in der CMDB: Ursache fehlender Abgleich mit dem Personalprozess. Maßnahme: Owner als Rollenpostfach führen und bei Austritten automatische Prüfung der CMDB-Einträge anstoßen; Verantwortlich: CMDB-Verantwortlicher; Frist: vier Wochen; Erfolgskriterium: keine CIs ohne gültigen Owner. Ursachenfeld 3, Wiki nicht erreichbar: Ursache ist ein Ablageort, der von denselben Ausfällen betroffen ist, gegen die er helfen soll. Maßnahme: Offline-Kopie aller kritischen Runbooks (PDF auf Bereitschaftsnotebooks, Ausdruck im Rechenzentrum), automatisch nach jeder Freigabe erzeugt; Verantwortlich: Redaktion; Frist: acht Wochen; Erfolgskriterium: Test im Wartungsfenster, bei dem das Wiki bewusst abgeschaltet wird und die Bereitschaft das Runbook trotzdem findet.
