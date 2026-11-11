# Modul 08 - API-, Software- und Entwicklerdokumentation

> **Hinweis zu diesem Kapitel:** Das ist das Kapitel des Skripts „Technische Dokumentation und Dokumentations-Governance“, aus der LaTeX-Quelle in Markdown umgewandelt (Text und Listings unverändert, farbige Boxen als Zitatblöcke mit fettem Titel, Tabellen als Markdown-Tabellen, Übungsaufgaben und Lösungen als Absätze). Die Lerneinheiten sind wie in der Quelle nach Modul nummeriert (8.1 bis 8.8), danach folgen „Übungsaufgaben“ (8 Aufgaben) und „Lösungen und Erläuterungen“. Die Sprachangabe der Codeblöcke ist in der Quelle nur für Python und Bash gesetzt; die übrigen Blöcke sind hier nach ihrem Inhalt als `python`, `yaml`, `markdown`, `bash` oder `text` ausgezeichnet, der Inhalt selbst ist unverändert. **Prüfstand der Beispiele für dieses Repository:** Die Python-Beispiele wurden auf Syntax geprüft; welche Beispiele ausgeführt wurden und welche zusätzlich PyYAML brauchen, steht in der [README des Repositories](../README.md). Übersicht zum Modul: [README](README.md).

**Dauer:** 8,75 Stunden | **Priorität:** 1 | **Lerneinheiten:** 8

| **Nr.** | **Lerneinheit**              | **Dauer (h)** | **Prio** |
|--------:|:-----------------------------|--------------:|---------:|
|       1 | API-Dokumentation            |          1,25 |        1 |
|       2 | OpenAPI Bezug                |          1,25 |        1 |
|       3 | Code-Kommentare              |             1 |        1 |
|       4 | README Standards             |             1 |        1 |
|       5 | Installationsanleitungen     |             1 |        1 |
|       6 | Release Notes                |             1 |        2 |
|       7 | Changelogs                   |             1 |        2 |
|       8 | Softwaredoku-Troubleshooting |          1,25 |        2 |
|         | **Summe**                    |      **8,75** |          |

## 8.1 API-Dokumentation

Eine API (*Application Programming Interface*, Programmierschnittstelle) ist der definierte Weg, auf dem ein Programm die Funktionen oder Daten eines anderen nutzt. Bei Web-APIs geschieht das meist über HTTP: Ein Client sendet eine Anfrage an eine Adresse und erhält eine Antwort, üblicherweise im Format JSON. Die API-Dokumentation beschreibt diese Schnittstelle für diejenigen, die sie benutzen wollen: Welche Adressen gibt es, welche Parameter erwartet jede, was liefert sie zurück, wie authentifiziere ich mich und was geschieht im Fehlerfall? Ohne diese Beschreibung bleibt den Entwicklerinnen und Entwicklern nur Ausprobieren oder das Lesen des Quelltextes.

Gute API-Dokumentation hat zwei Teile, die sich ergänzen. Die *Referenz* listet jede Ressource und Operation vollständig und systematisch auf: Pfad, Methode, Parameter, Anfragekörper, Antworten mit Statuscodes, Fehlerformate. Sie ist zum Nachschlagen gedacht. Die *Anleitungen* (Guides) erklären Zusammenhänge und typische Aufgaben: Wie melde ich mich an? Wie lege ich einen Datensatz an und rufe ihn wieder ab? Wie gehe ich mit Paginierung um? In der Terminologie von Modul 01 entspricht das der Trennung von Nachschlagewerk und Anleitung. Ein dritter, oft vergessener Teil sind lauffähige *Beispiele* mit Anfrage und Antwort, am besten als kopierbarer Befehl.

Zu den Pflichtinhalten zählen die *Authentifizierung* (Verfahren, Beschaffung und Übergabe von Zugangsdaten, Ablauf von Token), die *Basisadresse* und Umgebungen (Test, Produktion), die *Fehlerbehandlung* (Statuscodes, Fehlerformat, Wiederholungsstrategie), *Begrenzungen* (Ratenlimits, Größen), *Versionierung* und *Änderungsverlauf*. Alle diese Punkte sind Stellen, an denen Nutzer ohne Dokumentation scheitern.

Das folgende Beispiel zeigt ein kleines, aber vollständiges Gerüst einer Referenzseite für eine Operation in Markdown, wie es in Entwicklerportalen üblich ist, und ein Skript, das aus einer strukturierten Beschreibung diese Seite erzeugt. Die API ist frei erfunden.

```yaml
operation: Benutzer abrufen
methode: GET
pfad: /benutzer/{id}
beschreibung: Liefert einen Benutzer anhand seiner Kennung.
parameter:
  - {name: id, ort: Pfad, typ: Zahl, pflicht: ja, text: Kennung des Benutzers}
antworten:
  - {code: 200, text: Benutzer gefunden}
  - {code: 404, text: Kein Benutzer mit dieser Kennung}
beispiel: 'curl -H "Authorization: Bearer TOKEN" https://api.example.org/benutzer/42'
```

```python
import sys, yaml

d = yaml.safe_load(open(sys.argv[1], encoding="utf-8"))
print(f"## {d['operation']}\n")
print(f"`{d['methode']} {d['pfad']}`\n")
print(d["beschreibung"], "\n")
print("| Parameter | Ort | Typ | Pflicht | Beschreibung |")
print("|---|---|---|---|---|")
for p in d["parameter"]:
    print(f"| {p['name']} | {p['ort']} | {p['typ']} | {p['pflicht']} | {p['text']} |")
print("\n**Antworten**\n")
for a in d["antworten"]:
    print(f"- {a['code']}: {a['text']}")
print(f"\n**Beispiel**\n\n    {d['beispiel']}")
```

Die strukturierte Beschreibung trennt Inhalt und Darstellung. Das Skript erzeugt daraus eine Seite mit Überschrift, Aufruf in Codeformat, Parametertabelle, Antwortliste und Beispiel. Dass die Parameter in einer Tabelle stehen, ist kein Zufall: Sie sind gleichförmige Daten, die man vergleicht. Im Alltag erzeugt man solche Seiten nicht selbst, sondern aus einer Schnittstellenbeschreibung (nächster Abschnitt), aber das Prinzip ist dasselbe: Eine Quelle, viele Ausgaben.

Typische Fehler: Die Referenz ist veraltet, weil sie von Hand gepflegt wird; Beispiele funktionieren nicht; Fehlerfälle fehlen; die Authentifizierung wird nur nebenbei erwähnt; es fehlt ein Einstieg, der in fünf Minuten zum ersten erfolgreichen Aufruf führt.

| **Falsch**                               | **Richtig**                                                                                                                            |
|:-----------------------------------------|:---------------------------------------------------------------------------------------------------------------------------------------|
| „GET /benutzer/id liefert den Benutzer.“ | Pfad, Parametertabelle, mögliche Statuscodes (200, 404), Fehlerformat, kopierbares Beispiel mit Authentifizierung und Beispielantwort. |

Im Projekt bewährt sich ein *Time to first call*-Test: Eine Person, die die API nicht kennt, soll allein mit der Dokumentation den ersten erfolgreichen Aufruf schaffen. Wo sie hängt, fehlt etwas.

## 8.2 OpenAPI Bezug

Die OpenAPI-Spezifikation (OAS) ist ein Standard, um HTTP-APIs maschinenlesbar zu beschreiben. Sie ist sprachunabhängig und erlaubt es Menschen und Werkzeugen, die Fähigkeiten eines Dienstes zu erkennen, ohne Quelltext oder Netzwerkverkehr zu untersuchen. Aus einer solchen Beschreibung lassen sich Referenzseiten, Clientbibliotheken, Testwerkzeuge und Mock-Server erzeugen. Das löst das Hauptproblem handgepflegter Dokumentation, nämlich dass sie vom Verhalten abweicht.

> **Ergänzung aus der Nachrecherche**
>
> OpenAPI laut Spezifikation 3.1.1: Die abgerufene Spezifikation beschreibt das Format als sprachunabhängige Beschreibung von HTTP-APIs; ein OpenAPI-Dokument ist JSON oder YAML (empfohlen wird YAML 1.2) und heißt üblicherweise `openapi.json` oder `openapi.yaml`. Auf oberster Ebene sind das Feld `openapi` (Versionsangabe) und das Objekt `info` Pflicht, dazu mindestens eines von `paths`, `components` oder `webhooks`. Das Feld `info.version` bezeichnet die Version des *Beschreibungsdokuments*, nicht der Spezifikation. Das Schema-Objekt zur Beschreibung von Datenstrukturen basiert auf JSON Schema (Fassung 2020-12). Prüfen Sie bei Einsatz die jeweils aktuelle Fassung der Spezifikation. (Abruf 28.10.2026, siehe Quellenverzeichnis.)

Der Aufbau eines OpenAPI-Dokuments folgt einer klaren Logik. Unter `info` stehen Titel und Version, unter `servers` die Basisadressen, unter `paths` die Pfade mit ihren Operationen (get, post, put, delete), und unter `components` wiederverwendbare Bausteine wie Datenschemata oder Sicherheitsverfahren. Jede Operation beschreibt Parameter, Anfragekörper und mögliche Antworten. Die Beschreibungstexte (`summary`, `description`) sind der Ort, an dem Menschen lesbare Dokumentation schreiben; die Struktur selbst liefert die Maschinenlesbarkeit.

Das folgende Beispiel zeigt ein vollständiges, kleines OpenAPI-Dokument für die Operation aus dem vorigen Abschnitt und ein Skript, das es auf einige Mindestanforderungen prüft und die Operationen auflistet. Eine vollständige Validierung leisten spezialisierte Werkzeuge; das Skript soll das Gerüst verständlich machen.

```yaml
openapi: 3.1.0
info:
  title: Benutzerverwaltung
  version: 1.0.0
servers:
  - url: https://api.example.org
paths:
  /benutzer/{id}:
    get:
      summary: Benutzer abrufen
      description: Liefert einen Benutzer anhand seiner Kennung.
      parameters:
        - name: id
          in: path
          required: true
          schema: {type: integer}
      responses:
        "200":
          description: Benutzer gefunden
        "404":
          description: Kein Benutzer mit dieser Kennung
```

```python
import sys, yaml

d = yaml.safe_load(open(sys.argv[1], encoding="utf-8"))
fehler = []
for pflicht in ("openapi", "info"):
    if pflicht not in d:
        fehler.append(f"Pflichtfeld fehlt: {pflicht}")
if not any(k in d for k in ("paths", "components", "webhooks")):
    fehler.append("paths, components oder webhooks erforderlich")
for feld in ("title", "version"):
    if feld not in d.get("info", {}):
        fehler.append(f"info.{feld} fehlt")

for pfad, ops in d.get("paths", {}).items():
    for methode, op in ops.items():
        if "responses" not in op:
            fehler.append(f"{methode.upper()} {pfad}: keine responses")
        if not op.get("summary"):
            fehler.append(f"{methode.upper()} {pfad}: kein summary")
        print(f"{methode.upper():6} {pfad}  ({op.get('summary', '-')})")

print("\n".join(fehler) or "Gerüst in Ordnung")
```

Das Dokument beschreibt eine Operation mit Pfadparameter und zwei Antworten. Beachten Sie, dass die Statuscodes in Anführungszeichen stehen: In YAML wären sie sonst Zahlen, in OpenAPI sind sie Schlüssel, die als Text behandelt werden. Das Skript prüft die Pflichtfelder der obersten Ebene sowie je Operation das Vorhandensein von `responses` und `summary` und listet die Operationen auf. Für das Beispiel gibt es die Zeile `GET /benutzer/{id}` und die Meldung „Gerüst in Ordnung“.

Die Beziehung zwischen Handarbeit und Erzeugung ist die zentrale Entscheidung. Beim *Design-first*-Ansatz schreibt man die Beschreibung zuerst, stimmt sie mit den Nutzern ab und baut danach. Beim *Code-first*-Ansatz wird sie aus dem Code erzeugt. Beide Wege führen zu einer Beschreibung; wichtig ist, dass sie im Versionsstand des Projekts liegt und automatisch geprüft wird (Modul 10).

Typische Fehler: Die Beschreibung enthält nur Struktur und keine Texte, sodass die erzeugte Referenz leer wirkt; Beispiele fehlen; die Beschreibung und die Realität laufen auseinander, weil niemand sie prüft; sehr große Dateien werden in einem Stück gepflegt, statt sie aufzuteilen.

| **Falsch**                                                              | **Richtig**                                                                                                                       |
|:------------------------------------------------------------------------|:----------------------------------------------------------------------------------------------------------------------------------|
| Operation ohne `summary`, ohne Beschreibung der Antworten, mit `description: TODO`. | Operation mit klarem Summary, beschriebenen Statuscodes, Beispielen und einer Prüfung in der Pipeline, die fehlende Texte meldet. |

Im Projekt ist die OpenAPI-Datei der *Vertrag* zwischen Anbietern und Nutzern. Sie ist deshalb ein Review-Gegenstand wie Quelltext.

## 8.3 Code-Kommentare

Code-Kommentare sind Erläuterungen im Quelltext, die für Menschen bestimmt sind und vom Compiler oder Interpreter ignoriert werden. Sie sind die Dokumentation, die am nächsten am Code steht, und deshalb besonders leicht aktuell zu halten, aber auch besonders leicht falsch zu verwenden. Die wichtigste Regel lautet: Ein Kommentar erklärt das *Warum*, nicht das *Was*. Dass die Zeile `zaehler += 1` den Zähler erhöht, sieht man; warum an dieser Stelle erhöht wird und nicht früher, sieht man nicht.

Man unterscheidet zwei Arten. *Erläuternde Kommentare* stehen im Funktionskörper und begründen schwer verständliche Stellen, Annahmen und Umgehungslösungen („Workaround für Fehler X im Dienst Y“). *Dokumentationskommentare* stehen direkt an Modulen, Klassen und Funktionen und beschreiben deren Zweck, Parameter, Rückgabewerte und Ausnahmen. In Python heißen sie Docstrings und sind Zeichenketten in dreifachen Anführungszeichen direkt nach der Kopfzeile; Werkzeuge können sie auslesen und daraus Referenzseiten erzeugen. In Java gibt es Javadoc, in anderen Sprachen Entsprechungen.

Das folgende Beispiel zeigt eine Funktion mit Docstring im verbreiteten Google-Stil und ein Skript, das mit dem Modul `ast` aus Python-Dateien alle Funktionen ohne Docstring herausfiltert. Das ist die Grundlage vieler Dokumentationsprüfungen in Projekten.

```python
def netto(brutto: float, satz: float = 0.2) -> float:
    """Berechnet den Nettobetrag aus einem Bruttobetrag.

    Args:
        brutto: Betrag inklusive Steuer.
        satz: Steuersatz als Dezimalzahl, Standard 0.2.

    Returns:
        Der Betrag ohne Steuer, auf zwei Stellen gerundet.

    Raises:
        ValueError: Wenn brutto negativ ist.
    """
    if brutto < 0:
        raise ValueError("brutto darf nicht negativ sein")
    # Rundung erst am Ende, um Rundungsfehler nicht zu summieren
    return round(brutto / (1 + satz), 2)


def hilfsfunktion(x):
    return x * 2
```

```python
import ast, sys

quelltext = open(sys.argv[1], encoding="utf-8").read()
baum = ast.parse(quelltext)
for knoten in ast.walk(baum):
    if isinstance(knoten, (ast.FunctionDef, ast.ClassDef)):
        if not ast.get_docstring(knoten):
            print(f"Zeile {knoten.lineno}: {knoten.name} hat keinen Docstring")
```

Die erste Datei zeigt zwei Funktionen: `netto` ist vollständig dokumentiert, mit Kurzbeschreibung, Parametern, Rückgabe und Ausnahme. Der Kommentar im Funktionskörper erklärt das Warum der Rundung am Ende. `hilfsfunktion` hat gar keine Dokumentation. Das Skript parst den Quelltext in einen Syntaxbaum (`ast.parse`), durchläuft alle Knoten (`ast.walk`) und meldet Funktionen und Klassen ohne Docstring. Das Parsen ist robuster als eine Textsuche, weil es die Struktur der Sprache kennt.

Typische Fehler: Kommentare wiederholen den Code (`i += 1  # i um eins erhöhen`), sie veralten, weil der Code geändert wurde, der Kommentar aber nicht, auskommentierter Code bleibt jahrelang stehen, oder Kommentare dienen dazu, schlechten Code zu entschuldigen, statt ihn zu verbessern. Ein falscher Kommentar ist schlimmer als keiner.

| **Falsch** | **Richtig** |
|:-----------|:------------|
| `x = x * 1.19  # x mal 1,19`   | `preis = preis * 1.19  # Steuersatz DE, bis Preisliste 2027 festgeschrieben`    |

Im Projekt hilft die Regel: Wenn Sie das Bedürfnis haben, einen Block zu kommentieren, prüfen Sie zuerst, ob eine gut benannte Funktion den Kommentar überflüssig macht.

## 8.4 README Standards

Die README ist die Eingangstür eines Projekts: die erste Datei, die man liest, wenn man ein Repository öffnet. Sie beantwortet in wenigen Absätzen, was das Projekt ist, wozu es dient, wie man es startet und wo man mehr erfährt. Auf Plattformen wie GitHub wird sie automatisch auf der Startseite des Repositorys angezeigt, in der Regel als Markdown-Datei mit dem Namen `README.md`. Eine gute README erspart Rückfragen und senkt die Einstiegshürde für neue Mitarbeiter und externe Beitragende.

Als Standardinhalt hat sich folgende Reihenfolge bewährt. Zuerst der *Titel mit einem Satz*, der das Projekt beschreibt. Dann die *Motivation*: welches Problem es löst und für wen. Es folgt der *schnelle Einstieg* (Quick Start) mit Installation und einem ersten lauffähigen Beispiel. Danach die *Verwendung* mit den wichtigsten Anwendungsfällen, die *Konfiguration*, Hinweise zum *Mitwirken* (Verweis auf eine Datei `CONTRIBUTING.md`), die *Lizenz* und die *Ansprechpartner*. Tiefergehende Dokumentation verlinkt man, statt sie in die README zu packen.

Eine README lässt sich wie jede andere Dokumentation prüfen. Das folgende Beispiel zeigt eine kurze README und ein Skript, das die Standardabschnitte kontrolliert und prüft, ob der Quick Start mindestens einen Codeblock enthält. Ein Quick Start ohne Befehl ist keiner.

```markdown
# Berichtswerkzeug

Erzeugt aus Tickets monatliche Berichte als PDF.

## Motivation
Manuelle Berichte kosten uns jeden Monat einen halben Tag.

## Schnellstart
    pip install berichtswerkzeug
    bericht --monat 2026-10

## Verwendung
Siehe docs/verwendung.md.

## Mitwirken
Siehe CONTRIBUTING.md.

## Lizenz
MIT
```

````python
import re, sys

STANDARD = ["Motivation", "Schnellstart", "Verwendung", "Mitwirken", "Lizenz"]
text = open(sys.argv[1], encoding="utf-8").read()
titel = re.findall(r"^## (.+)$", text, re.M)

fehler = [f"Abschnitt fehlt: {a}" for a in STANDARD if a not in titel]
if not re.match(r"# .+\n\n.+", text):
    fehler.append("Titel mit einleitendem Satz fehlt")
quick = re.search(r"## Schnellstart\n(.*?)(?=\n## |\Z)", text, re.S)
if quick and not re.search(r"^(    |```)", quick.group(1), re.M):
    fehler.append("Schnellstart enthält keinen Codeblock")
print("\n".join(fehler) or "README entspricht dem Standard")
````

Die README im Beispiel folgt dem Standardaufbau; der Codeblock im Schnellstart ist durch vier Leerzeichen eingerückt, was in Markdown einen Codeblock bedeutet. Das Skript sucht die Abschnittsüberschriften, prüft den Titel mit Einleitungssatz und schneidet den Schnellstart-Abschnitt mit einem Ausdruck heraus, der bis zur nächsten Überschrift oder zum Dateiende reicht (`(?=\n## |\Z)` ist eine Vorausschau, die die Grenze markiert, ohne sie zu verbrauchen). Dann prüft es, ob darin ein Codeblock vorkommt, entweder eingerückt oder mit Dreifach-Backticks umzäunt.

Typische Fehler: Die README erklärt nur die Architektur und nicht, wie man startet; der Schnellstart funktioniert nicht, weil Voraussetzungen fehlen; sie ist so lang, dass der Einstieg untergeht; oder sie wird nie aktualisiert und beschreibt eine alte Version.

| **Falsch**                                               | **Richtig**                                                                                                          |
|:---------------------------------------------------------|:---------------------------------------------------------------------------------------------------------------------|
| README mit dem Inhalt „Tool zur Auswertung. Siehe Wiki.“ | README mit Zweck, Voraussetzungen, Schnellstart mit zwei Befehlen, Link auf weiterführende Dokumentation und Lizenz. |

Im Projekt ist der beste Test ein Kollege, der das Projekt nicht kennt: Er soll allein mit der README das Programm zum Laufen bringen.

## 8.5 Installationsanleitungen

Eine Installationsanleitung führt eine Person von einem Ausgangszustand (leeres System) zu einem lauffähigen Zustand (Software installiert und geprüft). Sie ist eine Sonderform der Anleitung aus Modul 04, hat aber eigene Anforderungen, weil Fehler hier teuer sind: Eine fehlgeschlagene Installation bedeutet, dass das Produkt gar nicht erst genutzt wird. Der Leser kann außerdem selten nachfragen, und seine Umgebung weicht fast immer von der des Autors ab.

Eine vollständige Installationsanleitung enthält folgende Teile in dieser Reihenfolge. Zuerst die *Systemvoraussetzungen*: unterstützte Betriebssysteme und Versionen, erforderliche Software, Hardware, Rechte, Netzwerkzugang. Dann die *Vorbereitung*, etwa Sicherung bestehender Daten. Es folgen die *Installationsschritte*, nach Betriebssystem oder Verfahren getrennt, jeweils mit kopierbaren Befehlen. Dann die *Überprüfung*: Woran erkennt man, dass es geklappt hat? Hier ist ein Befehl mit erwarteter Ausgabe ideal. Danach die *Konfiguration* für den ersten Start, die *Deinstallation und Aktualisierung* und ein Abschnitt zu *häufigen Problemen*.

Besonders wertvoll ist die Überprüfung, weil sie die Anleitung selbst testbar macht. Das folgende Beispiel zeigt ein Installations-Bash-Skript in der Form, wie man es mit einer Anleitung ausliefert: Es prüft die Voraussetzungen, bevor es etwas ändert, und bestätigt am Ende den Erfolg. Das Skript legt nur ein Verzeichnis in einem frei wählbaren Ziel an, damit es gefahrlos ausprobiert werden kann.

```bash
#!/usr/bin/env bash
set -euo pipefail

ZIEL="${1:-./demo-install}"

# 1. Voraussetzungen pruefen
for werkzeug in python3 tar; do
    command -v "$werkzeug" >/dev/null || { echo "Fehlt: $werkzeug" >&2; exit 1; }
done
python3 - <<'PY' || { echo "Python 3.8 oder neuer erforderlich" >&2; exit 1; }
import sys
sys.exit(0 if sys.version_info >= (3, 8) else 1)
PY

# 2. Installieren
mkdir -p "$ZIEL/bin"
printf '#!/bin/sh\necho "Werkzeug 1.0"\n' > "$ZIEL/bin/werkzeug"
chmod +x "$ZIEL/bin/werkzeug"

# 3. Ergebnis pruefen
"$ZIEL/bin/werkzeug" | grep -q "Werkzeug 1.0" && echo "Installation erfolgreich: $ZIEL"
```

Die Zeile `set -euo pipefail` lässt das Skript bei Fehlern, nicht gesetzten Variablen und Fehlern in Pipelines abbrechen, damit keine halbe Installation zurückbleibt. Der erste Block prüft mit `command -v`, ob Werkzeuge vorhanden sind, und die Python-Version über einen kleinen eingebetteten Test. Der zweite Block erledigt die eigentliche Installation, hier stellvertretend ein kleines Programm. Der dritte Block ruft es auf und vergleicht die Ausgabe mit dem Erwartungswert; erst dann meldet das Skript den Erfolg. Dass jeder Schritt der Anleitung eine solche Prüfung hat, ist der Kern guter Installationsdokumentation.

Typische Fehler: Voraussetzungen werden verschwiegen („Python ist ja überall“), Befehle sind nur für das System des Autors geschrieben, Schritte fehlen, weil der Autor sie längst automatisch erledigt, und die Anleitung ist nie auf einem frischen System getestet worden. Auch häufig: Befehle mit Administratorrechten ohne Hinweis.

| **Falsch**                                                          | **Richtig**                                                                                                                                                 |
|:--------------------------------------------------------------------|:------------------------------------------------------------------------------------------------------------------------------------------------------------|
| „Installieren Sie die Abhängigkeiten und starten Sie das Programm.“ | „1. Prüfen Sie die Version mit `python3 --version` (Erwartung: 3.8 oder höher). 2. Installieren Sie mit `pip install berichtswerkzeug`. 3. Prüfen Sie mit `bericht --version`; erwartete Ausgabe: 1.0.“ |

Im Projekt ist der Test auf einem frisch aufgesetzten System (Container oder virtuelle Maschine) unverzichtbar. Er deckt Annahmen auf, die der Autor selbst nicht mehr bemerkt.

## 8.6 Release Notes

Release Notes (Versionshinweise) informieren die Nutzer einer Software darüber, was sich mit einer neuen Version geändert hat und was sie dafür tun müssen. Sie richten sich an Anwender und Administratoren, nicht an Entwickler, und sind deshalb aus Sicht des Nutzens geschrieben: nicht „Refactoring der Exportklasse“, sondern „Der Export großer Berichte ist deutlich schneller“. Sie sind damit etwas anderes als das Änderungsprotokoll (nächster Abschnitt), das alle Änderungen vollständig und technisch auflistet.

Gute Release Notes enthalten folgende Teile: Versionsnummer und Veröffentlichungsdatum; eine kurze Zusammenfassung der wichtigsten Neuerungen; neue Funktionen, Verbesserungen und behobene Fehler, jeweils in Nutzersprache; *Hinweise zum Umstieg*, besonders bei Änderungen, die bestehende Nutzung betreffen; bekannte Probleme; Hinweise zu veralteten und entfernten Funktionen; sowie die Systemvoraussetzungen, falls sie sich geändert haben. Der wichtigste Abschnitt sind die Umstiegshinweise, denn dort entscheidet sich, ob ein Update reibungslos verläuft.

Release Notes entstehen am zuverlässigsten, wenn sie nicht am Ende aus dem Gedächtnis geschrieben, sondern laufend aus dem Änderungsprotokoll abgeleitet werden. Das folgende Beispiel liest ein Änderungsprotokoll im Format der nächsten Lerneinheit ein und erzeugt daraus den Entwurf von Release Notes für eine Version. Die Redaktion überarbeitet den Entwurf in Nutzersprache; das Skript sammelt nur.

```markdown
## [1.2.0] - 2026-10-15
### Added
- Export als PDF
### Changed
- Berichte laden schneller
### Fixed
- Absturz bei leerem Zeitraum
```

```python
import re, sys

text = open(sys.argv[1], encoding="utf-8").read()
version = sys.argv[2]
m = re.search(rf"## \[{re.escape(version)}\] - (\S+)\n(.*?)(?=\n## \[|\Z)", text, re.S)
if not m:
    sys.exit(f"Version {version} nicht gefunden")

titel = {"Added": "Neu", "Changed": "Geändert", "Fixed": "Behoben",
         "Deprecated": "Veraltet", "Removed": "Entfernt", "Security": "Sicherheit"}
print(f"# Release Notes {version} ({m.group(1)})\n")
for kategorie, inhalt in re.findall(r"### (\w+)\n(.*?)(?=\n### |\Z)", m.group(2), re.S):
    print(f"## {titel.get(kategorie, kategorie)}")
    print(inhalt.strip(), "\n")
```

Das Skript sucht den Abschnitt der gewünschten Version bis zum nächsten Versionskopf. Der Ausdruck `(?=\n## \[|\Z)` ist wieder eine Vorausschau, die an der Grenze stoppt. Innerhalb der Version zerlegt es die Kategorien (die englischen Namen des gängigen Formats) und gibt sie mit deutschen Überschriften aus. So ist der Entwurf nach Kategorien geordnet, muss aber noch sprachlich auf die Zielgruppe zugeschnitten werden. Beachten Sie die Trennung der Verantwortung: Das Skript sammelt vollständig, die Redaktion entscheidet, was für Nutzer relevant ist.

Typische Fehler: Release Notes enthalten Entwicklerjargon und Ticketnummern ohne Erklärung; Umstiegshinweise fehlen, obwohl sich Konfigurationen ändern; kritische Änderungen sind zwischen Kleinigkeiten versteckt; und bekannte Probleme werden verschwiegen.

| **Falsch**                     | **Richtig**                                                                                                                                                                                          |
|:-------------------------------|:-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| „Bugfixes und Verbesserungen.“ | „Behoben: Das Programm stürzte ab, wenn ein Bericht für einen leeren Zeitraum erzeugt wurde. Ändern: Der Parameter `--von` heißt ab dieser Version `--start`; alte Aufrufe müssen angepasst werden.“ |

Im Projekt lohnt es sich, *Breaking Changes* immer an den Anfang zu stellen. Wer nur einen Satz liest, soll wissen, ob sein Update gefahrlos ist.

## 8.7 Changelogs

Das Änderungsprotokoll (Changelog) ist die vollständige, chronologische Liste aller nennenswerten Änderungen eines Projekts, nach Versionen geordnet. Es richtet sich an Menschen, die wissen wollen, was zwischen zwei Versionen passiert ist, und ist technischer und lückenloser als Release Notes. Die verbreitete Konvention *Keep a Changelog* legt dafür ein einfaches Format fest.

> **Ergänzung aus der Nachrecherche**
>
> Keep a Changelog: Laut dem abgerufenen Beitrag zur Konvention (die Konvention stammt von Olivier Lacan, 2014) gelten folgende Grundsätze: Changelogs sind für Menschen gemacht, nicht für Maschinen; jede Version hat einen Eintrag; Versionen stehen mit Datum im ISO-8601-Format (JJJJ-MM-TT), die neueste zuerst; es gibt einen Abschnitt `Unreleased` für noch nicht veröffentlichte Änderungen. Änderungen werden in sechs Kategorien gruppiert: `Added`, `Changed`, `Deprecated`, `Removed`, `Fixed`, `Security`. Mindestens Veraltungen, Entfernungen und Breaking Changes sollen vermerkt werden. Der Beitrag nennt eine Version 2.0.0 der Konvention von Juni 2026; die Originalseite selbst war nicht abrufbar, prüfen Sie dort den aktuellen Stand. (Abruf 28.10.2026, siehe Quellenverzeichnis.)

Eng mit dem Changelog verbunden ist die *Semantische Versionierung* (SemVer). Eine Versionsnummer hat die Form `MAJOR.MINOR.PATCH`. Nach der abgerufenen Spezifikation wird MAJOR erhöht bei inkompatiblen Änderungen der öffentlichen Schnittstelle, MINOR bei neuen, rückwärtskompatiblen Funktionen und PATCH bei rückwärtskompatiblen Fehlerbehebungen. Versionen vor 1.0.0 (`0.y.z`) gelten als Entwicklungsphase, in der alles jederzeit ändern kann. Eine Vorabversion wie `1.0.0-alpha` hat Vorrang *vor* der Version 1.0.0, ist also kleiner. Einmal veröffentlichte Versionen dürfen nicht geändert werden; Korrekturen erscheinen als neue Version. Das Zusammenspiel liegt auf der Hand: Der Changelog dokumentiert, welche Kategorie von Änderungen eine Version enthält, und daraus folgt, welche Nummer sie bekommt.

Das folgende Beispiel zeigt diesen Zusammenhang als Skript. Es liest den Abschnitt `Unreleased` eines Changelogs und schlägt anhand der Kategorien die nächste Versionsnummer vor, wenn die letzte veröffentlichte Version bekannt ist. Dabei gilt vereinfacht: `Removed` oder ein Eintrag mit dem Wort „BREAKING“ führt zu einer neuen Hauptversion, `Added` zu einer neuen Nebenversion, alles andere zu einer Patch-Version.

```markdown
## [Unreleased]
### Added
- Export als PDF
### Fixed
- Absturz bei leerem Zeitraum

## [1.2.0] - 2026-10-15
### Added
- Filter nach Team
```

```python
import re, sys

text = open(sys.argv[1], encoding="utf-8").read()
unreleased = re.search(r"## \[Unreleased\]\n(.*?)(?=\n## \[|\Z)", text, re.S).group(1)
letzte = re.search(r"## \[(\d+)\.(\d+)\.(\d+)\]", text)
major, minor, patch = map(int, letzte.groups())

kategorien = set(re.findall(r"### (\w+)", unreleased))
if "Removed" in kategorien or "BREAKING" in unreleased:
    neu = f"{major + 1}.0.0"
elif "Added" in kategorien:
    neu = f"{major}.{minor + 1}.0"
elif kategorien:
    neu = f"{major}.{minor}.{patch + 1}"
else:
    sys.exit("Keine Änderungen vorgemerkt")
print(f"Letzte Version {major}.{minor}.{patch}, Vorschlag: {neu}")
```

Das Skript schneidet den Unreleased-Abschnitt aus, liest die letzte veröffentlichte Versionsnummer als drei Zahlen und prüft, welche Kategorien vorkommen. Mit den Beispieldaten kommt `Added` vor, also lautet der Vorschlag 1.3.0. Die Regel ist bewusst vereinfacht: Ob eine Änderung wirklich rückwärtskompatibel ist, muss ein Mensch beurteilen, und eine neue Funktion kann trotzdem eine inkompatible Änderung enthalten. Der Vorschlag ist ein Hilfsmittel, keine Entscheidung.

Typische Fehler: Der Changelog ist ein Auszug der Commit-Meldungen (Rauschen statt Information), er wird nur beim Release rekonstruiert, Einträge sind unverständlich („Fix“), Datumsformate schwanken, oder Breaking Changes sind nicht als solche gekennzeichnet. Auch problematisch: ein Changelog, der nur die Spitzen listet und die Zwischenversionen auslässt.

| **Falsch**                  | **Richtig**                                                                       |
|:----------------------------|:----------------------------------------------------------------------------------|
| „1.2.1: diverse Änderungen“ | „1.2.1 - 2026-10-20: Fixed: Absturz bei leerem Zeitraum behoben (Ticket SW-418).“ |

Im Projekt ist die Gewohnheit entscheidend: Wer eine Änderung einreicht, ergänzt in derselben Einreichung den Changelog. Dann stimmt er, ohne dass jemand ihn am Ende rekonstruieren muss.

## 8.8 Softwaredoku-Troubleshooting

Dieser Abschnitt zeigt, wie man typische Fehlerbilder bei Softwaredokumentation anhand von Struktur, Aktualität, Zielgruppenfeedback und Review-Kommentaren eingrenzt und daraus Runbook-Schritte für Redaktion, Fachbereich und Betrieb ableitet. Gemeint sind Fälle, in denen Entwickler und Nutzer die Dokumentation haben, aber nicht mit ihr arbeiten können.

Die häufigsten Symptome und ihre wahrscheinlichen Ursachen: „Beispiele funktionieren nicht“ deutet auf Dokumentation hin, die nach einer Änderung nicht getestet wurde. „Die Referenz passt nicht zur API“ deutet auf handgepflegte Beschreibungen ohne Prüfung gegen den Code. „Neue Kollegen schaffen die Installation nicht“ deutet auf verschwiegene Voraussetzungen oder veraltete Anleitung. „Niemand liest die Release Notes“ deutet auf falsche Zielgruppe oder fehlende Umstiegshinweise. „Der Changelog ist unbrauchbar“ deutet auf automatisch kopierte Commit-Meldungen.

Der wirksamste Ansatz ist es, Dokumentation wie Software zu testen. Das folgende Skript prüft die Codebeispiele einer Markdown-Datei: Es führt alle mit `python` gekennzeichneten Codeblöcke aus und meldet Fehler. Damit fällt auf, wenn ein Beispiel nach einer Änderung nicht mehr funktioniert. Der Ansatz ist als *Doctest-Prinzip* bekannt.

````markdown
# Anleitung

Beispiel 1:

```python
print(sum([1, 2, 3]))
```

Beispiel 2:

```python
print(summe([1, 2, 3]))
```
````

````python
import re, subprocess, sys

text = open(sys.argv[1], encoding="utf-8").read()
bloecke = re.findall(r"```python\n(.*?)```", text, re.S)
for nr, code in enumerate(bloecke, 1):
    r = subprocess.run([sys.executable, "-c", code],
                       capture_output=True, text=True, timeout=10)
    if r.returncode == 0:
        print(f"Beispiel {nr}: ok ({r.stdout.strip()})")
    else:
        letzte = r.stderr.strip().splitlines()[-1]
        print(f"Beispiel {nr}: FEHLER - {letzte}")
````

Das Skript extrahiert alle Python-Codeblöcke, führt jeden in einem eigenen Prozess aus (Modul `subprocess`) und wertet den Rückgabewert aus. Der Zeitlimit-Parameter `timeout` verhindert hängende Beispiele. Mit der Beispieldatei ist das erste Beispiel in Ordnung (Ausgabe 6), das zweite schlägt fehl, weil die Funktion `summe` nicht existiert. Wichtig ist der Sicherheitshinweis: Führen Sie so nur Code aus vertrauenswürdigen Quellen aus, am besten in einem abgeschotteten Container.

Als Runbook für die Redaktion ergibt sich: Fehlerbild sammeln, Ursachenklasse bestimmen (Beispiel defekt, Referenz veraltet, Voraussetzung fehlt), den Autor oder Owner benennen, Korrektur durch einen Änderungsantrag umsetzen, die automatische Prüfung erweitern, damit derselbe Fehler nicht wiederkehrt, und im Changelog der Dokumentation vermerken. Die Prüfung in der Pipeline ist die nachhaltigste Lösung (Modul 10).

Typische Fehler: Man repariert das einzelne Beispiel, ohne die Ursache zu beheben; man ergänzt Warnhinweise, statt die Anleitung zu korrigieren; man testet nur auf dem Rechner des Autors. Außerdem werden Rückmeldungen der Nutzer nicht systematisch erfasst, sodass dieselben Probleme immer wieder auftreten.

| **Falsch**                                                                               | **Richtig**                                                                                                          |
|:-----------------------------------------------------------------------------------------|:---------------------------------------------------------------------------------------------------------------------|
| Hinweis in der Anleitung: „Falls das nicht funktioniert, bitte einen Entwickler fragen.“ | Beispiel korrigiert, Test in der Pipeline ergänzt, damit ein defektes Beispiel künftig den Build fehlschlagen lässt. |

Im Projekt ist die Rückmeldemöglichkeit direkt an der Seite („War diese Seite hilfreich?“ oder ein Link zum Fehlerticket) die einfachste Quelle für Hinweise, die man sonst nie erhält.

## Übungsaufgaben

Die Aufgaben steigen von Verständnisfragen (1 bis 3) über Anwendungsaufgaben (4 bis 5) bis zu Programmier- und Transferaufgaben (6 bis 8) an.

**Aufgabe 1.** *(leicht)* Worin unterscheiden sich Referenz, Anleitung und Beispiel in der API-Dokumentation? Wozu dient jeder Teil?

**Aufgabe 2.** *(leicht)* Warum soll ein Code-Kommentar das „Warum“ und nicht das „Was“ erklären? Geben Sie ein Beispiel für einen schlechten und einen guten Kommentar.

**Aufgabe 3.** *(leicht bis mittel)* Welche Versionsnummer folgt auf 2.4.1 bei (a) einer Fehlerbehebung, (b) einer neuen, kompatiblen Funktion, (c) einer inkompatiblen Änderung?

**Aufgabe 4.** *(mittel)* Schreiben Sie ein OpenAPI-Dokument für eine Operation POST auf `/tickets`, die ein Ticket mit Titel anlegt und bei Erfolg 201, bei fehlendem Titel 400 liefert.

**Aufgabe 5.** *(mittel)* Entwerfen Sie die Gliederung einer README für ein internes Kommandozeilenwerkzeug und begründen Sie die Reihenfolge.

**Aufgabe 6.** *(mittel, praktisch)* Schreiben Sie ein Skript, das ein Changelog im Keep-a-Changelog-Format einliest und prüft, ob die Versionen absteigend geordnet sind und jede ein Datum im Format JJJJ-MM-TT hat.

**Aufgabe 7.** *(anspruchsvoll, praktisch)* Erweitern Sie das Docstring-Skript so, dass es zusätzlich Funktionen meldet, deren Docstring nicht jeden Parameter der Funktion erwähnt.

**Aufgabe 8.** *(anspruchsvoll, Transfer)* Ein Team pflegt die API-Dokumentation in einem Wiki, die Entwickler ändern die API ohne Rücksprache. Nutzer beschweren sich über falsche Angaben. Analysieren Sie die Ursachen und entwerfen Sie einen Ablauf, der die Dokumentation zuverlässig aktuell hält.

## Lösungen und Erläuterungen

**Lösung zu Aufgabe 1.** Die Referenz listet alle Operationen vollständig und systematisch auf und dient zum Nachschlagen. Die Anleitung erklärt Zusammenhänge und typische Aufgaben (Anmeldung, erster Datensatz) und führt Schritt für Schritt zum Ziel. Das Beispiel zeigt einen konkreten, kopierbaren Aufruf mit Antwort und macht beides greifbar. Ein Teil allein genügt nicht: Eine Referenz ohne Anleitung überfordert Einsteiger, eine Anleitung ohne Referenz lässt Fortgeschrittene im Stich.

**Lösung zu Aufgabe 2.** Das „Was“ steht im Code selbst und lässt sich lesen; was nicht im Code steht, ist die Absicht dahinter. Schlecht: `timeout = 30  # Timeout auf 30 setzen`. Gut: `timeout = 30  # Der Dienst antwortet bei Last bis zu 25 Sekunden`. Der gute Kommentar liefert eine Information, die man nicht aus dem Code gewinnt, und erlaubt es, den Wert später begründet zu ändern.

**Lösung zu Aufgabe 3.** (a) 2.4.2, weil eine rückwärtskompatible Fehlerbehebung die Patch-Nummer erhöht. (b) 2.5.0, weil eine neue kompatible Funktion die Minor-Nummer erhöht und Patch auf 0 zurückgesetzt wird. (c) 3.0.0, weil eine inkompatible Änderung die Major-Nummer erhöht und die anderen zurückgesetzt werden.

**Lösung zu Aufgabe 4.** Eine mögliche Lösung:

```yaml
openapi: 3.1.0
info:
  title: Ticketverwaltung
  version: 1.0.0
paths:
  /tickets:
    post:
      summary: Ticket anlegen
      description: Legt ein neues Ticket mit einem Titel an.
      requestBody:
        required: true
        content:
          application/json:
            schema:
              type: object
              required: [titel]
              properties:
                titel: {type: string}
      responses:
        "201":
          description: Ticket angelegt
        "400":
          description: Titel fehlt oder ist leer
```

Wichtig sind der Anfragekörper mit dem Pflichtfeld `titel` und die beiden beschriebenen Antworten. Das Dokument besteht die Prüfung des Skripts aus dieser Lerneinheit (Pflichtfelder, `responses` und `summary` vorhanden).

**Lösung zu Aufgabe 5.** Gliederung: Titel mit einem Satz; Motivation (wozu gibt es das Werkzeug); Schnellstart mit Installation und erstem Aufruf; Verwendung mit den drei häufigsten Aufgaben; Konfiguration; Hilfe und Ansprechpartner; Mitwirken; Lizenz. Die Reihenfolge folgt dem Weg der Leserin: erst verstehen, ob das Werkzeug relevant ist, dann schnell starten, dann vertiefen, zuletzt organisatorische Angaben. Wer nur den Schnellstart liest, soll bereits einen Erfolg haben.

**Lösung zu Aufgabe 6.** Eine mögliche Lösung:

```python
import re, sys
from datetime import date

text = open(sys.argv[1], encoding="utf-8").read()
fehler = []
vorige = None
for version, datum in re.findall(r"^## \[(\d+\.\d+\.\d+)\] - (\S+)$", text, re.M):
    try:
        tag = date.fromisoformat(datum)
    except ValueError:
        fehler.append(f"{version}: ungültiges Datum '{datum}'")
        continue
    if vorige and tag > vorige:
        fehler.append(f"{version}: Datum {tag} neuer als die darüberstehende Version")
    vorige = tag
print("\n".join(fehler) or "Changelog in Ordnung")
```

Der Ausdruck erfasst alle Versionsköpfe mit Datum. Der Abschnitt `Unreleased` hat kein Datum und wird dadurch automatisch übersprungen. `date.fromisoformat` prüft zugleich Format und Gültigkeit des Datums. Die Reihenfolge wird über die Datumswerte geprüft: Weil die neueste Version zuerst steht, darf kein späterer Eintrag ein neueres Datum haben als sein Vorgänger. Die Prüfung der Versionsnummern selbst (absteigend im SemVer-Sinn) wäre eine Erweiterung.

**Lösung zu Aufgabe 7.** Eine mögliche Erweiterung innerhalb der Schleife des Docstring-Skripts:

```text
        if isinstance(knoten, ast.FunctionDef):
            doc = ast.get_docstring(knoten) or ""
            for arg in knoten.args.args:
                if arg.arg not in ("self", "cls") and arg.arg not in doc:
                    print(f"Zeile {knoten.lineno}: {knoten.name}: "
                          f"Parameter '{arg.arg}' nicht dokumentiert")
```

Die Liste `knoten.args.args` enthält die regulären Parameter der Funktion. Das Skript prüft, ob der Name im Docstring vorkommt. Das ist eine einfache Näherung: Ein Parameter namens `x` würde schon durch ein beliebiges Wort mit „x“ als dokumentiert gelten. Eine genauere Prüfung würde den Docstring-Abschnitt `Args:` parsen. Ausgeschlossen werden `self` und `cls`, weil sie bei Methoden üblicherweise nicht dokumentiert werden.

**Lösung zu Aufgabe 8.** Ursachen: Die Dokumentation liegt getrennt vom Code in einem Wiki und ist nicht an den Änderungsprozess gekoppelt; es gibt keine Prüfung, ob Beschreibung und API übereinstimmen; Verantwortlichkeit für die Doku ist ungeklärt. Ablauf: (1) Die API-Beschreibung (OpenAPI) liegt im selben Repository wie der Code und wird mit ihm versioniert. (2) Eine Änderung an der API ist nur zusammen mit einer Änderung der Beschreibung freigabefähig (Checkliste im Änderungsantrag, Review durch eine zweite Person). (3) In der Pipeline vergleicht ein automatischer Test die laufende API mit der Beschreibung und lässt bei Abweichungen den Build fehlschlagen. (4) Die Referenz im Wiki wird aus der Beschreibung erzeugt und nicht mehr von Hand gepflegt. (5) Änderungen werden im Changelog festgehalten, inkompatible Änderungen zusätzlich in den Release Notes angekündigt. Erfolgskriterium: Keine gemeldeten Abweichungen zwischen Dokumentation und API im folgenden Quartal. Das Beispiel zeigt auch, dass die Lösung organisatorisch (Verantwortung) und technisch (Prüfung) zugleich sein muss.
