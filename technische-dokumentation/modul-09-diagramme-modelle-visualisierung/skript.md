# Modul 09 - Diagramme, Modelle und Visualisierung

> **Hinweis zu diesem Kapitel:** Das ist das Kapitel des Skripts „Technische Dokumentation und Dokumentations-Governance“, aus der LaTeX-Quelle in Markdown umgewandelt (Text und Listings unverändert, farbige Boxen als Zitatblöcke mit fettem Titel, Tabellen als Markdown-Tabellen, Übungsaufgaben und Lösungen als Absätze). Die Lerneinheiten sind wie in der Quelle nach Modul nummeriert (9.1 bis 9.8), danach folgen „Übungsaufgaben“ (8 Aufgaben) und „Lösungen und Erläuterungen“. Die Sprachangabe der Codeblöcke ist in der Quelle nur für Python und Bash gesetzt; die übrigen Blöcke sind hier nach ihrem Inhalt als `python`, `yaml`, `markdown`, `bash` oder `text` ausgezeichnet, der Inhalt selbst ist unverändert. **Prüfstand der Beispiele für dieses Repository:** Die Python-Beispiele wurden auf Syntax geprüft; welche Beispiele ausgeführt wurden und welche zusätzlich PyYAML brauchen, steht in der [README des Repositories](../README.md). Übersicht zum Modul: [README](README.md).

**Dauer:** 8 Stunden | **Priorität:** 1 | **Lerneinheiten:** 8

| **Nr.** | **Lerneinheit**          | **Dauer (h)** | **Prio** |
|--------:|:-------------------------|--------------:|---------:|
|       1 | Architekturdiagramme     |             1 |        1 |
|       2 | Netzwerkpläne            |             1 |        1 |
|       3 | Datenflussdiagramme      |             1 |        1 |
|       4 | UML Grundlagen           |             1 |        1 |
|       5 | BPMN Bezug               |             1 |        1 |
|       6 | Legenden und Notation    |             1 |        2 |
|       7 | Versionierte Diagramme   |             1 |        2 |
|       8 | Diagramm-Troubleshooting |             1 |        2 |
|         | **Summe**                |         **8** |          |

## 9.1 Architekturdiagramme

Ein Architekturdiagramm zeigt, aus welchen Bausteinen ein IT-System besteht und wie diese zusammenwirken. Es ersetzt viele Seiten Text, denn Beziehungen, die in Prosa umständlich zu beschreiben sind, erfasst das Auge in Sekunden. Zugleich ist es die Diagrammart, die am häufigsten misslingt: Zu viele Kästchen, unklare Pfeile und fehlende Legende machen aus einem Hilfsmittel ein Rätsel. Dieses Modul zeigt, wie Diagramme zuverlässig verständlich werden.

Die zentrale Idee ist die *Abstraktionsebene*. Ein Diagramm beantwortet eine Frage auf einer Detailstufe, nicht alle Fragen auf allen Stufen. Das C4-Modell, das in Modul 05 im Zusammenhang mit der Systemdokumentation eingeführt wurde, macht das explizit: Auf der ersten Ebene (Kontext) steht das System als eine Box mit seinen Nutzern und Nachbarsystemen, auf der zweiten (Container) die ausführbaren Bausteine wie Webanwendung, Datenbank und Dienste, darauf folgen Komponenten und Code. Wer die Ebenen mischt, erzeugt Diagramme, in denen eine Datenbank neben einer Java-Klasse steht. Die vollständige Erklärung des C4-Modells steht in Modul 05; hier geht es um die zeichnerische Umsetzung und Pflege.

Für die Pflege empfiehlt sich *Diagramm als Text*: Das Diagramm wird als Quelltext geschrieben und von einem Werkzeug gezeichnet. Das hat drei Vorteile. Der Quelltext lässt sich in der Versionsverwaltung ablegen und vergleichen, er lässt sich im Review prüfen, und er lässt sich teilweise automatisch aus Daten erzeugen. Ein verbreitetes Werkzeug dafür ist Mermaid.

> **Ergänzung aus der Nachrecherche**
>
> Mermaid: Laut der abgerufenen Einführung ist Mermaid ein JavaScript-basiertes Werkzeug, das Diagramme aus Text erzeugt, mit dem Ziel, Dokumentation aktuell zu halten. Unterstützt werden unter anderem Flussdiagramme, Sequenzdiagramme, Klassendiagramme, Gantt-Diagramme, Git-Graphen und Entity-Relationship-Diagramme (letztere als experimentell gekennzeichnet). Die Syntax ist von Markdown inspiriert, Diagramme stehen in Codeblöcken mit der Kennzeichnung `mermaid`. Ob ein bestimmtes Dokumentationswerkzeug Mermaid direkt darstellt, hängt vom Werkzeug ab und ist dort zu prüfen. (Abruf 28.10.2026, siehe Quellenverzeichnis.)

Das folgende Beispiel zeigt ein Container-Diagramm für einen fiktiven Webshop in Mermaid. Es enthält Personen, Anwendungsbausteine und Außensysteme, jede Verbindung ist beschriftet, und eine Legende erklärt die Farben.

```text
flowchart LR
  kunde([Kunde])
  subgraph shop["Webshop"]
    web["Webanwendung"]
    api["Shop-API"]
    db[("Datenbank")]
  end
  zahlung["Zahlungsdienst (extern)"]

  kunde -->|HTTPS| web
  web -->|REST/JSON| api
  api -->|SQL| db
  api -->|HTTPS| zahlung

  classDef extern fill:#eee,stroke:#999,stroke-dasharray: 4 4
  class zahlung extern
```

Die erste Zeile legt die Zeichenrichtung fest, `LR` bedeutet von links nach rechts. Runde Klammern in eckigen Klammern oder doppelte runde Klammern erzeugen andere Formen: Das Stadion `([...])` steht hier für eine Person, der Zylinder `[(...)]` für eine Datenbank. Der Block `subgraph` zeichnet einen Rahmen um die Bausteine des Webshops und macht die Systemgrenze sichtbar. Jede Verbindung hat nach dem Pfeil eine Beschriftung zwischen senkrechten Strichen, hier das Protokoll. Mit `classDef` wird eine Formatierung definiert (gestrichelter Rahmen für externe Systeme) und mit `class` zugewiesen.

Typische Fehler: Alles in ein Diagramm packen; Pfeile ohne Beschriftung, sodass offen bleibt, ob sie Datenfluss, Aufruf oder Abhängigkeit bedeuten; Produktnamen und Technologien vermischen; fehlende Systemgrenze.

| **Falsch**                                                  | **Richtig**                                                                                                                |
|:------------------------------------------------------------|:---------------------------------------------------------------------------------------------------------------------------|
| Zwölf Kästchen mit Pfeilen ohne Beschriftung, ohne Legende. | Neun Elemente, jede Beziehung mit Protokoll beschriftet, Systemgrenze als Rahmen, eigene Formatierung für externe Systeme. |

Im Projekt hat sich die Regel „ein Diagramm, eine Frage“ bewährt. Beginnen Sie mit dem Satz, den das Diagramm beantworten soll, etwa „Welche Systeme kommunizieren mit der Shop-API?“, und lassen Sie alles weg, was dazu nichts beiträgt.

## 9.2 Netzwerkpläne

Ein Netzwerkplan dokumentiert die Struktur eines Netzwerks: Standorte, Netzsegmente (Subnetze), Geräte, Verbindungen und Adressen. Er dient der Fehlersuche (Wo läuft der Verkehr entlang?), der Planung (Ist noch Adressraum frei?), der Sicherheit (Welche Zonen sind getrennt?) und dem Audit (Wo sitzen schützenswerte Systeme?). Wie jede Dokumentation ist er nur nützlich, wenn er stimmt, und Netzwerke ändern sich ständig.

Man unterscheidet den *physischen Plan* (Geräte, Kabel, Ports, Standorte) vom *logischen Plan* (Subnetze, VLANs, Routing, Firewallzonen). Für die Betriebsdokumentation ist meist der logische Plan wichtiger, ergänzt um einen Adressplan. Ein *Subnetz* ist ein zusammenhängender Adressbereich, der in der Schreibweise CIDR als Adresse mit Präfixlänge notiert wird, zum Beispiel `10.0.1.0/24`. Das bedeutet, dass die ersten 24 Bit das Netz kennzeichnen und die restlichen 8 Bit Geräteadressen sind, also 256 Adressen, von denen zwei (Netz- und Broadcastadresse) nicht für Geräte nutzbar sind.

Ein Teil der Dokumentation lässt sich als Daten führen und automatisch prüfen. Das folgende Beispiel hält Subnetze und Geräte in einer YAML-Datei fest. Das Skript prüft mit dem Python-Modul `ipaddress`, ob sich Subnetze überlappen, ob jedes Gerät in seinem Subnetz liegt und ob IP-Adressen doppelt vergeben sind. Alle Adressen stammen aus dem privaten Bereich und sind erfunden.

```yaml
subnetze:
  - {name: Server, cidr: 10.0.1.0/24}
  - {name: Clients, cidr: 10.0.2.0/24}
  - {name: DMZ, cidr: 10.0.3.0/25}
geraete:
  - {name: web01, subnetz: DMZ, ip: 10.0.3.10}
  - {name: db01, subnetz: Server, ip: 10.0.1.20}
  - {name: app01, subnetz: Server, ip: 10.0.1.20}
  - {name: pc17, subnetz: Clients, ip: 10.0.3.55}
```

```python
import ipaddress, itertools, sys, yaml

d = yaml.safe_load(open(sys.argv[1], encoding="utf-8"))
netze = {s["name"]: ipaddress.ip_network(s["cidr"]) for s in d["subnetze"]}

for (a, na), (b, nb) in itertools.combinations(netze.items(), 2):
    if na.overlaps(nb):
        print(f"Überlappung: {a} ({na}) und {b} ({nb})")

gesehen = {}
for g in d["geraete"]:
    ip = ipaddress.ip_address(g["ip"])
    if ip not in netze[g["subnetz"]]:
        print(f"{g['name']}: {ip} liegt nicht in {g['subnetz']} ({netze[g['subnetz']]})")
    if ip in gesehen:
        print(f"Doppelte Adresse {ip}: {gesehen[ip]} und {g['name']}")
    gesehen[ip] = g["name"]

for name, netz in netze.items():
    belegt = sum(1 for g in d["geraete"] if g["subnetz"] == name)
    print(f"{name}: {belegt} von {netz.num_addresses - 2} Adressen belegt")
```

Das Skript baut aus den Subnetzen Netzobjekte, vergleicht alle Paare (Funktion `combinations` aus `itertools`) auf Überlappung und prüft dann jedes Gerät. Der Operator `in` entscheidet, ob eine Adresse in einem Netz liegt. Am Ende berechnet es die Auslastung, wobei zwei Adressen für Netz- und Broadcastadresse abgezogen werden (bei sehr kleinen Netzen gilt diese Regel nicht uneingeschränkt). Im Beispiel meldet es, dass `pc17` nicht im Clients-Netz liegt und die Adresse 10.0.1.20 doppelt vergeben ist. Aus denselben Daten ließe sich auch ein Diagramm erzeugen, sodass Tabelle und Zeichnung nie auseinanderlaufen.

Typische Fehler: Es gibt nur ein Bild und keine Adresstabelle; der Plan zeigt den Soll-Zustand von vor drei Jahren; Subnetze überlappen, weil Adressräume nach Gefühl vergeben wurden; vertrauliche Details (Zugangsdaten, interne Namen) stehen im Plan, der breit verteilt wird (siehe Modul 13).

| **Falsch**                                                                       | **Richtig**                                                                                                |
|:---------------------------------------------------------------------------------|:-----------------------------------------------------------------------------------------------------------|
| Screenshot eines Netzwerkplans aus einem Präsentationsprogramm, Stand unbekannt. | Adress- und Gerätedaten als Datei im Repository, daraus erzeugtes Diagramm mit Versionsstand und Stichtag. |

Im Projekt ist der Abgleich des Plans mit der Wirklichkeit (zum Beispiel mit der Inventarliste oder einem Netzwerkscan, siehe Modul 05) die wichtigste Pflegeaufgabe.

## 9.3 Datenflussdiagramme

Ein Datenflussdiagramm (DFD) zeigt, wie Daten durch ein System fließen: woher sie kommen, welche Verarbeitungsschritte sie durchlaufen, wo sie gespeichert werden und wohin sie gehen. Es beschreibt nicht den Ablauf von Schritten in der Zeit, sondern den *Weg der Daten*. Das ist besonders wertvoll für Datenschutz und Sicherheit, weil man auf einen Blick sieht, wo personenbezogene Daten entstehen, gespeichert und weitergegeben werden (Modul 13).

Ein DFD kennt vier Elemente. Ein *externer Akteur* (Entity) liefert Daten oder empfängt sie und liegt außerhalb des Systems. Ein *Prozess* wandelt Daten um. Ein *Datenspeicher* hält Daten dauerhaft. Ein *Datenfluss* verbindet die anderen Elemente und trägt eine Beschriftung, die sagt, welche Daten fließen. Daraus folgen Regeln, die sich prüfen lassen: Ein Datenfluss verbindet nie zwei Akteure, zwei Speicher oder einen Akteur und einen Speicher direkt, sondern immer über einen Prozess. Jeder Prozess hat mindestens einen eingehenden und einen ausgehenden Fluss; ein Prozess ohne Eingang wäre ein „Wunder“, ein Prozess ohne Ausgang ein „schwarzes Loch“.

Das folgende Beispiel hält ein DFD als Daten fest und prüft diese Regeln. Es modelliert ein kleines Bestellsystem.

```yaml
elemente:
  Kunde: akteur
  Bestellung erfassen: prozess
  Rechnung erstellen: prozess
  Bestelldaten: speicher
  Buchhaltung: akteur
fluesse:
  - {von: Kunde, nach: Bestellung erfassen, daten: Bestellung}
  - {von: Bestellung erfassen, nach: Bestelldaten, daten: Bestellsatz}
  - {von: Bestelldaten, nach: Rechnung erstellen, daten: Bestellsatz}
  - {von: Rechnung erstellen, nach: Kunde, daten: Rechnung}
  - {von: Kunde, nach: Bestelldaten, daten: Zahlungsdaten}
  - {von: Rechnung erstellen, nach: Buchhaltung, daten: ""}
```

```python
import sys, yaml

d = yaml.safe_load(open(sys.argv[1], encoding="utf-8"))
typ = d["elemente"]
fehler = []

for f in d["fluesse"]:
    t1, t2 = typ[f["von"]], typ[f["nach"]]
    if "prozess" not in (t1, t2):
        fehler.append(f"{f['von']} -> {f['nach']}: Fluss ohne Prozess ({t1} -> {t2})")
    if not f["daten"]:
        fehler.append(f"{f['von']} -> {f['nach']}: Fluss ohne Beschriftung")

for name, art in typ.items():
    if art == "prozess":
        rein = any(f["nach"] == name for f in d["fluesse"])
        raus = any(f["von"] == name for f in d["fluesse"])
        if not rein:
            fehler.append(f"{name}: Prozess ohne Eingang (Wunder)")
        if not raus:
            fehler.append(f"{name}: Prozess ohne Ausgang (schwarzes Loch)")

print("\n".join(fehler) or "DFD regelkonform")
```

Die Datei ordnet jedem Element einen Typ zu und listet die Flüsse mit Beschriftung. Das Skript prüft pro Fluss, ob mindestens ein Ende ein Prozess ist, und ob eine Beschriftung vorhanden ist, danach pro Prozess, ob Ein- und Ausgang existieren. Mit den Beispieldaten meldet es zwei Fehler: Der Fluss von „Kunde“ direkt in den Speicher „Bestelldaten“ umgeht einen Prozess (wer prüft die Zahlungsdaten?), und der Fluss an die Buchhaltung ist unbeschriftet. Beides sind Befunde mit Nutzen: Der erste weist auf eine fehlende Verarbeitung hin, der zweite auf eine unklare Schnittstelle.

Typische Fehler: Ablaufschritte und Datenflüsse werden vermischt (ein Pfeil bedeutet einmal „danach“, einmal „Daten“); Flüsse tragen Verben statt Daten („senden“ statt „Rechnung“); Speicher werden vergessen, sodass Datenhaltung unsichtbar bleibt.

| **Falsch**                                     | **Richtig**                                                                                           |
|:-----------------------------------------------|:------------------------------------------------------------------------------------------------------|
| Pfeil „Kunde -\> Datenbank“ ohne Beschriftung. | Pfeil „Kunde -\> Bestellung erfassen“ mit Beschriftung „Bestelldaten“, dahinter Prozess und Speicher. |

Im Projekt hilft das DFD bei der Frage „Wohin gehen die Personendaten?“, die in Datenschutzfolgenabschätzungen und Verarbeitungsverzeichnissen gestellt wird.

## 9.4 UML Grundlagen

UML (*Unified Modeling Language*) ist eine genormte grafische Sprache zur Beschreibung von Software und Systemen. Sie umfasst viele Diagrammarten, von denen im Dokumentationsalltag nur wenige regelmäßig gebraucht werden. Der Zweck ist Verständigung: Wer ein UML-Diagramm liest, soll dieselbe Vorstellung vom System bekommen wie der Zeichner. Dazu braucht es eine gemeinsame Notation, aber keine Vollständigkeit; UML ist kein Selbstzweck.

Es lohnt sich, vier Diagrammarten zu kennen. Das *Klassendiagramm* zeigt Klassen mit Attributen und Methoden und ihre Beziehungen (Vererbung, Assoziation, Aggregation). Das *Sequenzdiagramm* zeigt, in welcher zeitlichen Reihenfolge Beteiligte Nachrichten austauschen, ideal für Schnittstellen und Abläufe zwischen Diensten. Das *Zustandsdiagramm* zeigt die Zustände eines Objekts und die Übergänge, etwa den Dokumentstatus aus Modul 10. Das *Anwendungsfalldiagramm* zeigt, welche Akteure welche Funktionen nutzen. Aktivitätsdiagramme ähneln Flussdiagrammen und überschneiden sich mit BPMN (nächster Abschnitt).

Mermaid unterstützt Klassen- und Sequenzdiagramme, sodass sie als Text gepflegt werden können. Das folgende Beispiel zeigt ein Sequenzdiagramm für den Abruf eines Benutzers. Es ist kurz und enthält die wesentlichen Elemente: Beteiligte, Nachrichten, Antworten und eine Fallunterscheidung.

```text
sequenceDiagram
  participant C as Client
  participant A as API
  participant D as Datenbank
  C->>A: GET /benutzer/42
  A->>D: SELECT benutzer
  D-->>A: Datensatz
  alt Benutzer vorhanden
    A-->>C: 200 Benutzer
  else nicht gefunden
    A-->>C: 404 Fehler
  end
```

Die Beteiligten werden mit `participant` deklariert, wobei `as` einen Anzeigenamen vergibt. Der Pfeil mit zwei Spitzen (`->>`) steht für eine Anfrage, die gestrichelte Variante (`-->>`) für eine Antwort. Der Block `alt ... else ... end` stellt eine Alternative dar. Die Zeit läuft von oben nach unten, und die Reihenfolge der Zeilen ist die Reihenfolge der Nachrichten.

Aus Code lässt sich ein Klassendiagramm automatisch erzeugen. Das folgende Skript liest mit dem Python-Modul `inspect` eine Klassenhierarchie und gibt sie als Mermaid-Klassendiagramm aus. Damit bleibt das Diagramm im Einklang mit dem Code.

```python
import inspect

class Dokument:
    titel: str
    version: str
    def freigeben(self): ...

class Runbook(Dokument):
    schritte: list
    def ausfuehren(self): ...

def mermaid(*klassen):
    zeilen = ["classDiagram"]
    for k in klassen:
        for basis in k.__bases__:
            if basis is not object:
                zeilen.append(f"  {basis.__name__} <|-- {k.__name__}")
        zeilen.append(f"  class {k.__name__} {{")
        for name in k.__annotations__:
            zeilen.append(f"    +{name}")
        for name, f in inspect.getmembers(k, inspect.isfunction):
            if f.__qualname__.startswith(k.__name__ + "."):
                zeilen.append(f"    +{name}()")
        zeilen.append("  }")
    return "\n".join(zeilen)

print(mermaid(Dokument, Runbook))
```

Das Skript definiert zwei Klassen und erzeugt für jede einen Block mit Attributen (aus den Typannotationen) und Methoden (über `inspect.getmembers`). Die Bedingung mit `__qualname__` filtert geerbte Methoden heraus, damit jede Methode nur in der Klasse erscheint, die sie definiert. Die Vererbungsbeziehung wird mit dem Pfeil `<|--` notiert. Die Ausgabe ist gültiger Mermaid-Code, der sich in ein Dokument einfügen lässt.

Typische Fehler: Diagramme sind so detailliert, dass sie den Quelltext verdoppeln und sofort veralten; falsche Pfeilarten (Vererbung und Assoziation verwechselt); UML wird als Pflichtübung produziert, ohne dass jemand die Diagramme liest.

| **Falsch**                                                         | **Richtig**                                                                                                                               |
|:-------------------------------------------------------------------|:------------------------------------------------------------------------------------------------------------------------------------------|
| Klassendiagramm mit allen 140 Klassen und jedem privaten Attribut. | Klassendiagramm der zehn zentralen Klassen mit den öffentlichen Attributen und Methoden, ergänzt um ein Sequenzdiagramm der Hauptabläufe. |

Im Projekt gilt: Zeichnen Sie das, was der Leser nicht schnell aus dem Code lesen kann, nämlich Zusammenhänge und Abläufe, nicht den Code selbst.

## 9.5 BPMN Bezug

BPMN (*Business Process Model and Notation*) ist eine genormte Notation zur Darstellung von Geschäftsprozessen. Sie ergänzt die Prozessdokumentation aus Modul 06: Dort wurde beschrieben, wie man Prozesse in Worten und Tabellen festhält und in einer Prozesslandkarte überblickt; BPMN stellt die einzelnen Abläufe grafisch dar.

> **Ergänzung aus der Nachrecherche**
>
> BPMN laut Quelle: Die abgerufene Seite der Object Management Group (OMG), die BPMN pflegt, bezeichnet BPMN als de-facto-Standard für Prozessdiagramme mit flussdiagrammähnlicher Notation, die unabhängig von einer Umsetzungsumgebung ist. Sie richte sich an Personen, die Prozesse entwerfen, steuern und umsetzen, und sei genau genug, um Diagramme in Software-Prozesskomponenten zu übersetzen. Die Seite behandelt Version 2.0 (Dezember 2010) und vermerkt, dass diese durch 2.0.1 abgelöst wurde. Eine Normnummer nennt die Seite nicht; in einem Suchergebnis wurde ISO/IEC 19510 als zugehörige Norm genannt, die Seite dazu wurde nicht abgerufen. (Abruf 28.10.2026, siehe Quellenverzeichnis.)

Die wichtigsten BPMN-Elemente lassen sich an einer Hand abzählen. *Ereignisse* (Kreise) markieren Start, Ende oder Zwischenereignisse wie den Eingang einer Nachricht. *Aufgaben* (abgerundete Rechtecke) sind Arbeitsschritte. *Gateways* (Rauten) verzweigen oder vereinen den Ablauf, etwa als exklusive Entscheidung. *Sequenzflüsse* (Pfeile) legen die Reihenfolge fest. *Pools und Lanes* gliedern nach Beteiligten und Rollen. Für die Dokumentations-Governance sind Lanes besonders nützlich, weil sie sichtbar machen, welche Rolle (Autor, Reviewer, Approver) welchen Schritt ausführt.

BPMN-Diagramme werden meist in speziellen Werkzeugen gezeichnet und im XML-Format gespeichert. Das folgende Beispiel zeigt den Freigabeprozess aus Modul 06 als minimales BPMN-XML und ein Skript, das die Struktur prüft: ein Startereignis, mindestens ein Endereignis, alle Verweise gültig, und kein Element ohne Verbindung. So lässt sich auch ein gezeichnetes Modell automatisch auf grobe Fehler testen. Der Namensraum entspricht der BPMN-2.0-Spezifikation.

```text
<definitions xmlns="http://www.omg.org/spec/BPMN/20100524/MODEL">
  <process id="freigabe" name="Dokument freigeben">
    <startEvent id="s"/>
    <task id="t1" name="Dokument pruefen"/>
    <exclusiveGateway id="g" name="Mangel?"/>
    <task id="t2" name="Dokument freigeben"/>
    <task id="t3" name="Dokument ueberarbeiten"/>
    <endEvent id="e"/>
    <sequenceFlow id="f1" sourceRef="s" targetRef="t1"/>
    <sequenceFlow id="f2" sourceRef="t1" targetRef="g"/>
    <sequenceFlow id="f3" sourceRef="g" targetRef="t2" name="nein"/>
    <sequenceFlow id="f4" sourceRef="g" targetRef="t3" name="ja"/>
    <sequenceFlow id="f5" sourceRef="t3" targetRef="t1"/>
    <sequenceFlow id="f6" sourceRef="t2" targetRef="e"/>
  </process>
</definitions>
```

```python
import sys
import xml.etree.ElementTree as ET

NS = "{http://www.omg.org/spec/BPMN/20100524/MODEL}"
wurzel = ET.parse(sys.argv[1]).getroot()
prozess = wurzel.find(NS + "process")

knoten = {e.get("id"): e.tag.replace(NS, "") for e in prozess
          if e.tag != NS + "sequenceFlow"}
fluesse = [(f.get("sourceRef"), f.get("targetRef")) for f in prozess.findall(NS + "sequenceFlow")]
fehler = []

if list(knoten.values()).count("startEvent") != 1:
    fehler.append("Genau ein Startereignis erwartet")
if "endEvent" not in knoten.values():
    fehler.append("Kein Endereignis")
for a, b in fluesse:
    for k in (a, b):
        if k not in knoten:
            fehler.append(f"Fluss verweist auf unbekanntes Element {k}")
for k, art in knoten.items():
    if art != "startEvent" and not any(b == k for _, b in fluesse):
        fehler.append(f"{k} hat keinen Eingang")
    if art != "endEvent" and not any(a == k for a, _ in fluesse):
        fehler.append(f"{k} hat keinen Ausgang")
print("\n".join(fehler) or "BPMN-Struktur in Ordnung")
```

Das Modell im Beispiel beschreibt eine Schleife: Nach der Prüfung entscheidet ein Gateway, ob ein Mangel vorliegt. Bei „ja“ wird überarbeitet und erneut geprüft, bei „nein“ freigegeben. Das Skript liest alle Elemente außer den Flüssen als Knoten, sammelt die Flüsse als Paare und prüft die genannten Bedingungen. Es kennt weder Lanes noch Bedingungsausdrücke und ersetzt keinen Modellierungs-Validator; es zeigt, wie man ein Diagramm als Daten behandeln kann. Die Namen im Beispiel sind ohne Umlaute geschrieben, damit die Datei unabhängig von der Zeichenkodierung bleibt.

Typische Fehler: BPMN wird verwendet, wo ein einfaches Flussdiagramm genügt, und Diagramme sind so groß, dass niemand sie liest; Gateways haben keine beschrifteten Ausgänge; Rollen sind nicht als Lanes erkennbar; oder es wird Notation ohne Kenntnis der Bedeutung gemischt.

| **Falsch**                                                                             | **Richtig**                                                                                                  |
|:---------------------------------------------------------------------------------------|:-------------------------------------------------------------------------------------------------------------|
| Raute mit drei unbeschrifteten Ausgängen und einem Pfeil, der zurück zum Anfang führt. | Exklusives Gateway mit Frage „Mangel?“ und zwei beschrifteten Ausgängen „ja“ und „nein“, Schleife erkennbar. |

Im Projekt lohnt BPMN, wenn Prozesse an mehreren Stellen mit mehreren Rollen ablaufen oder automatisiert werden sollen. Für kleine Abläufe reichen nummerierte Schritte (Modul 04 und 06).

## 9.6 Legenden und Notation

Ein Diagramm ist eine Sprache, und wie jede Sprache braucht sie vereinbarte Bedeutungen. Die *Notation* legt fest, welche Form, Farbe und Linienart was bedeutet. Die *Legende* erklärt diese Zeichen dem Leser. Ohne Legende muss man raten: Bedeutet gestrichelt „optional“, „extern“ oder „geplant“? Wer das Diagramm nicht selbst gezeichnet hat, kann es nicht wissen.

Für die Notation gelten drei Grundregeln. Erstens: *Eine Bedeutung, ein Zeichen.* Dieselbe Form steht immer für dasselbe, und dasselbe Konzept wird immer gleich dargestellt. Zweitens: *Farbe nie als einziges Unterscheidungsmerkmal*, denn farbenfehlsichtige Menschen und Schwarz-Weiß-Ausdrucke verlieren sie. Kombinieren Sie Farbe mit Form, Linienart oder Beschriftung. Auch die Barrierefreiheit verlangt, dass Informationen nicht allein durch Farbe vermittelt werden (Modul 11 und 13). Drittens: *Wenn eine anerkannte Notation existiert, nutzen Sie sie* (UML, BPMN, C4), und wenn Sie von ihr abweichen, vermerken Sie es in der Legende.

Eine Legende gehört in das Diagramm oder unmittelbar daneben, enthält jedes verwendete Zeichen genau einmal und keines, das nicht vorkommt. Das folgende Beispiel zeigt einen Mermaid-Quelltext mit Formatklassen und einer Legende, sowie ein Skript, das prüft, ob jede verwendete Klasse definiert ist und in der Legende vorkommt.

```text
flowchart LR
  a[Webanwendung]:::intern
  b[Zahlungsdienst]:::extern
  c[Altsystem]:::geplantAus
  a --> b
  a --> c
  subgraph legende["Legende"]
    l1[intern]:::intern
    l2[extern]:::extern
  end
  classDef intern fill:#dbeafe,stroke:#1d4ed8
  classDef extern fill:#eee,stroke:#666,stroke-dasharray: 4 4
```

```python
import re, sys

text = open(sys.argv[1], encoding="utf-8").read()
definiert = set(re.findall(r"classDef (\w+)", text))
verwendet = set(re.findall(r":::(\w+)", text))

legende = re.search(r'subgraph legende.*?\n  end', text, re.S)
in_legende = set(re.findall(r":::(\w+)", legende.group(0))) if legende else set()

for k in sorted(verwendet - definiert):
    print(f"Klasse '{k}' wird verwendet, aber nicht definiert")
for k in sorted(verwendet - in_legende):
    print(f"Klasse '{k}' fehlt in der Legende")
for k in sorted(in_legende - verwendet - definiert):
    print(f"Legende enthält unbekannte Klasse '{k}'")
```

Das Diagramm verwendet drei Formatklassen. Die Klasse `geplantAus` wird verwendet, aber nie definiert und fehlt in der Legende. Das Skript sucht mit regulären Ausdrücken alle Definitionen (`classDef`), alle Verwendungen (`:::name`) und den Legendenblock, und vergleicht die Mengen. Mit dem Beispiel meldet es für `geplantAus` sowohl die fehlende Definition als auch die fehlende Legende. Die Mengenoperationen `-` bilden Differenzen und machen den Vergleich knapp und lesbar.

Typische Fehler: Legende fehlt oder gilt für ein anderes Diagramm; unterschiedliche Diagramme einer Dokumentation verwenden verschiedene Zeichen für dasselbe; Farben haben zu wenig Kontrast oder sind das einzige Unterscheidungsmerkmal.

| **Falsch**                                                                        | **Richtig**                                                                                                      |
|:----------------------------------------------------------------------------------|:-----------------------------------------------------------------------------------------------------------------|
| Rot und Grün unterscheiden „Fehler“ und „in Ordnung“, ohne weitere Kennzeichnung. | Rot mit Symbol „!“ und Beschriftung „Fehler“, Grün mit Haken und Beschriftung „in Ordnung“, Legende im Diagramm. |

Im Projekt ist ein gemeinsames *Diagramm-Styleguide-Blatt* (Formen, Farben, Linien, Schriftgröße) der einfachste Weg zu Konsistenz. Es ist Teil des Styleguides aus Modul 07.

## 9.7 Versionierte Diagramme

Diagramme veralten wie Texte, aber sie werden seltener geprüft, weil man ihnen ihr Alter nicht ansieht. Versionierung macht den Stand eines Diagramms erkennbar und seine Änderungen nachvollziehbar. Die Grundlagen der Versionsverwaltung stehen in Modul 10; hier geht es um die Besonderheiten bei Diagrammen.

Entscheidend ist die Wahl des Quellformats. Diagramme als *Bilddateien* (PNG, JPG) lassen sich in der Versionsverwaltung nur als Ganzes ersetzen; ein Vergleich zweier Stände ist nicht möglich, und die Quelle zum Bearbeiten fehlt oft. Diagramme als *Text* (Mermaid, PlantUML, Graphviz) oder als *XML* (BPMN, manche Zeichenprogramme) lassen sich zeilenweise vergleichen und im Review prüfen. Wo ein Zeichenprogramm unvermeidlich ist, gehören die Quelldatei *und* die exportierte Grafik ins Repository, und der Export wird automatisch erzeugt, nicht von Hand ersetzt.

Jedes Diagramm sollte seinen Stand zeigen: Version, Datum und Verantwortlichen in einer Fußzeile oder Beschriftung, und im Repository eine Zuordnung zur Systemversion, die es abbildet. Das folgende Beispiel zeigt ein einfaches Verfahren: Ein Manifest hält für jede Diagrammdatei Version und Prüfsumme fest, und ein Skript meldet Diagramme, die sich geändert haben, ohne dass die Version erhöht wurde. Eine *Prüfsumme* (Hash) ist ein Fingerabdruck der Datei; ändert sich auch nur ein Zeichen, ändert sich der Wert.

```text
datei;version;sha256
architektur.mmd;1.2;PLATZHALTER
netz.mmd;1.0;PLATZHALTER
```

```python
import csv, hashlib, sys
from pathlib import Path

zeilen = list(csv.DictReader(open("manifest.csv", encoding="utf-8"), delimiter=";"))
aktualisieren = "--aktualisieren" in sys.argv

for z in zeilen:
    summe = hashlib.sha256(Path(z["datei"]).read_bytes()).hexdigest()
    if z["sha256"] == "PLATZHALTER" or aktualisieren:
        z["sha256"] = summe
        print(f"{z['datei']}: Prüfsumme eingetragen")
    elif z["sha256"] != summe:
        print(f"{z['datei']}: GEÄNDERT, aber Version noch {z['version']}")
    else:
        print(f"{z['datei']}: unverändert (Version {z['version']})")

with open("manifest.csv", "w", encoding="utf-8", newline="") as f:
    w = csv.DictWriter(f, fieldnames=["datei", "version", "sha256"], delimiter=";")
    w.writeheader()
    w.writerows(zeilen)
```

Das Manifest beginnt mit einem Platzhalter; beim ersten Lauf trägt das Skript die Prüfsummen ein. Bei späteren Läufen vergleicht es die aktuelle Prüfsumme mit der gespeicherten und meldet Dateien, die sich verändert haben. Wer die Änderung bewusst gemacht hat, erhöht die Version im Manifest und führt das Skript mit dem Schalter `--aktualisieren` aus, um die neue Prüfsumme zu übernehmen. Das ist ein einfacher Mechanismus, kein Ersatz für eine Versionsverwaltung, aber er zeigt das Prinzip: Änderungen am Diagramm müssen bewusst und sichtbar sein.

Typische Fehler: Nur das exportierte Bild liegt im Repository und die Quelle auf dem Laptop eines Kollegen; Diagramme tragen kein Datum; mehrere Varianten kursieren in Präsentationen; und die Zuordnung zur Systemversion fehlt.

| **Falsch**                                          | **Richtig**                                                                                                  |
|:----------------------------------------------------|:-------------------------------------------------------------------------------------------------------------|
| Datei „architektur_final_v3_neu.png“ im Mailanhang. | Datei `architektur.mmd` im Repository mit Versionsangabe im Manifest, Export als Bild automatisch bei jeder Änderung. |

Im Projekt ist die schönste Lösung, Diagramme direkt in die Dokumentation einzubetten, sodass es keine getrennte Datei gibt, die vergessen werden könnte.

## 9.8 Diagramm-Troubleshooting

Dieser Abschnitt zeigt, wie man typische Fehlerbilder bei Diagrammen anhand von Struktur, Aktualität, Zielgruppenfeedback und Review-Kommentaren eingrenzt und daraus Runbook-Schritte für Redaktion, Fachbereich und Betrieb ableitet.

Die häufigsten Beschwerden sind schnell benannt. „Das versteht keiner“ deutet auf zu hohe Komplexität, fehlende Legende oder gemischte Abstraktionsebenen. „Das stimmt nicht mehr“ deutet auf fehlende Pflege, fehlende Version oder handgezeichnete Bilder ohne Quelle. „Das Diagramm ist unleserlich“ deutet auf zu viele Elemente, zu kleine Schrift oder Kreuzungen. „Es widerspricht dem Text“ deutet auf getrennte Pflege von Bild und Beschreibung. Die einfachste Gegenprobe ist ein Lesetest: Eine Person, die das Diagramm nicht kennt, erklärt in eigenen Worten, was sie sieht.

Ein Teil der Probleme ist maschinell erkennbar. Das folgende Skript prüft einen Mermaid-Flussdiagramm-Quelltext auf drei typische Mängel: zu viele Elemente, unbeschriftete Verbindungen und Elemente ohne Verbindung (verwaiste Knoten).

```text
flowchart LR
  a[Web] --> b[API]
  b -->|SQL| c[(DB)]
  d[Cache]
  b --> e[Mail]
```

```python
import re, sys

MAX_KNOTEN = 15
text = open(sys.argv[1], encoding="utf-8").read()

knoten = set(re.findall(r"\b(\w+)(?=[\[\(])", text))
form = r"(?:\[[^\]]*\]|\([^)]*\))?"
kanten = re.findall(rf"(\w+){form}\s*(-->(?:\|[^|]*\|)?)\s*(\w+)", text)

if len(knoten) > MAX_KNOTEN:
    print(f"Zu viele Elemente: {len(knoten)} (Maximum {MAX_KNOTEN})")
for a, pfeil, b in kanten:
    if "|" not in pfeil:
        print(f"Unbeschriftete Verbindung: {a} -> {b}")
verbunden = {a for a, _, _ in kanten} | {b for _, _, b in kanten}
for k in sorted(knoten - verbunden):
    print(f"Verwaister Knoten: {k}")
```

Das Skript sammelt Knoten als Kennungen, auf die eine öffnende Klammer folgt (eine Vorausschau, die die Klammer nicht verbraucht), und Kanten als Pfeile mit optionaler Beschriftung zwischen zwei Kennungen, wobei hinter einer Kennung eine Formangabe stehen darf. Es meldet im Beispiel zwei unbeschriftete Verbindungen (Web zu API sowie API zu Mail) und den verwaisten Knoten `d`. Die Schwelle von 15 Elementen ist ein Richtwert, den Sie an Ihr Umfeld anpassen sollten. Die Erkennung ist bewusst einfach: Knoten, die nur innerhalb einer Kante definiert werden, erfasst sie nicht. Für den Alltag genügt sie als Hinweisgeber.

Als Runbook ergibt sich: Beschwerde aufnehmen, Fehlerklasse bestimmen (Verständlichkeit, Aktualität, Lesbarkeit, Widerspruch), Lesetest durchführen, Diagramm aufteilen oder ergänzen, Legende und Stand ergänzen, den Fachbereich den Inhalt bestätigen lassen und die Prüfung in die Pipeline aufnehmen (Modul 10).

Typische Fehler: Man verkleinert die Schrift, statt das Diagramm aufzuteilen; man ergänzt Erklärtext im Bild, statt die Struktur zu vereinfachen; man korrigiert das Diagramm, aber nicht den begleitenden Text.

| **Falsch**                                                                      | **Richtig**                                                                                                    |
|:--------------------------------------------------------------------------------|:---------------------------------------------------------------------------------------------------------------|
| Diagramm mit 40 Elementen, Schriftgröße 6 Punkt, damit es auf eine Seite passt. | Drei Diagramme mit je acht bis zwölf Elementen, eine Übersicht und zwei Detailansichten, lesbare Schriftgröße. |

Im Projekt ist die wirksamste Maßnahme, Diagramme im Review wie Text zu behandeln: mit Checkliste, Owner und Prüftermin.

## Übungsaufgaben

Die Aufgaben steigen von Verständnisfragen (1 bis 3) über Anwendungsaufgaben (4 bis 5) bis zu Programmier- und Transferaufgaben (6 bis 8) an.

**Aufgabe 1.** *(leicht)* Erklären Sie, warum ein Architekturdiagramm nur eine Abstraktionsebene zeigen sollte. Nennen Sie die vier Ebenen des C4-Modells.

**Aufgabe 2.** *(leicht)* Welche Regeln gelten für Datenflüsse in einem DFD? Was bedeuten die Begriffe „Wunder“ und „schwarzes Loch“?

**Aufgabe 3.** *(leicht bis mittel)* Warum darf Farbe nicht das einzige Unterscheidungsmerkmal in einem Diagramm sein? Nennen Sie zwei Alternativen.

**Aufgabe 4.** *(mittel)* Zeichnen Sie (als Mermaid-Text) ein Sequenzdiagramm für das Anlegen eines Tickets durch einen Client über eine API in eine Datenbank, mit Fehlerfall bei fehlendem Titel.

**Aufgabe 5.** *(mittel)* Berechnen Sie für das Subnetz `192.168.10.0/26` die Zahl der nutzbaren Geräteadressen und den ersten und letzten nutzbaren Host.

**Aufgabe 6.** *(mittel, praktisch)* Erweitern Sie das Netzwerkskript so, dass es zusätzlich Subnetze meldet, die zu mehr als 80 Prozent belegt sind.

**Aufgabe 7.** *(anspruchsvoll, praktisch)* Schreiben Sie ein Skript, das aus der DFD-Datei dieses Moduls ein Mermaid-Flussdiagramm erzeugt (Akteure als Stadion, Prozesse als Rechteck, Speicher als Zylinder, Kanten mit Beschriftung).

**Aufgabe 8.** *(anspruchsvoll, Transfer)* In einem Team kursieren fünf Versionen derselben Architekturgrafik als Bilddateien, keiner weiß, welche stimmt. Entwerfen Sie ein Verfahren, das dieses Problem dauerhaft löst (Format, Ablage, Pflege, Prüfung).

## Lösungen und Erläuterungen

**Lösung zu Aufgabe 1.** Ein Diagramm beantwortet eine Frage; mischt man Ebenen, stehen Dinge unterschiedlicher Größenordnung nebeneinander (eine Datenbank neben einer Klasse), und der Leser kann den Maßstab nicht erkennen. Die vier Ebenen des C4-Modells sind Kontext (System, Nutzer, Nachbarsysteme), Container (ausführbare Bausteine), Komponenten (Bausteine innerhalb eines Containers) und Code. Je nach Leser genügt die obere Ebene oder die detaillierte.

**Lösung zu Aufgabe 2.** Ein Datenfluss muss mindestens einen Prozess berühren; Akteur zu Akteur, Speicher zu Speicher oder Akteur zu Speicher direkt sind nicht erlaubt. Jeder Fluss trägt eine Beschriftung mit den fließenden Daten. Ein Prozess ohne Eingang erzeugt Daten aus dem Nichts („Wunder“), ein Prozess ohne Ausgang verbraucht sie, ohne dass etwas herauskommt („schwarzes Loch“). Beides weist auf ein unvollständiges Modell hin.

**Lösung zu Aufgabe 3.** Farbenfehlsichtige Menschen unterscheiden Farben schlechter, Schwarz-Weiß-Ausdrucke und Beamer verlieren sie, und Screenreader vermitteln sie nicht. Alternativen: unterschiedliche Formen (Rechteck gegen Raute), Linienarten (durchgezogen gegen gestrichelt), Symbole (Haken, Ausrufezeichen) oder Beschriftungen im Element.

**Lösung zu Aufgabe 4.** Eine mögliche Lösung:

```text
sequenceDiagram
  participant C as Client
  participant A as API
  participant D as Datenbank
  C->>A: POST /tickets
  alt Titel vorhanden
    A->>D: INSERT ticket
    D-->>A: Ticket-ID
    A-->>C: 201 Ticket angelegt
  else Titel fehlt
    A-->>C: 400 Titel fehlt
  end
```

Der Fehlerfall wird vor dem Zugriff auf die Datenbank abgefangen; im Diagramm erscheint die Datenbank deshalb nur im Erfolgsfall. Das ist die Art Information, die ein Sequenzdiagramm besser als Text zeigt.

**Lösung zu Aufgabe 5.** Ein /26-Netz hat 64 Adressen (2 hoch 6). Davon sind Netz- und Broadcastadresse nicht nutzbar, also 62 nutzbare Geräteadressen. Erster Host: 192.168.10.1, letzter Host: 192.168.10.62, Broadcast: 192.168.10.63. Sie können es mit dem Skript prüfen: `list(ipaddress.ip_network("192.168.10.0/26").hosts())` liefert genau diese 62 Adressen.

**Lösung zu Aufgabe 6.** Eine mögliche Ergänzung am Ende des Skripts:

```text
    if belegt / (netz.num_addresses - 2) > 0.8:
        print(f"{name}: Auslastung über 80 Prozent")
```

Die Zeilen stehen innerhalb der letzten Schleife (nach der Ausgabe der Belegung). Wichtig ist die Division durch die nutzbaren Adressen, nicht durch alle Adressen des Netzes. Bei sehr kleinen Netzen (/31, /32) wäre die Rechnung anzupassen, weil dort keine Netz- und Broadcastadresse abgezogen wird.

**Lösung zu Aufgabe 7.** Eine mögliche Lösung:

```python
import re, sys, yaml

d = yaml.safe_load(open(sys.argv[1], encoding="utf-8"))
ids = {n: f"n{i}" for i, n in enumerate(d["elemente"])}
form = {"akteur": '(["{}"])', "prozess": '["{}"]', "speicher": '[("{}")]'}

print("flowchart LR")
for name, art in d["elemente"].items():
    print(f"  {ids[name]}{form[art].format(name)}")
for f in d["fluesse"]:
    beschriftung = f'|{f["daten"]}|' if f["daten"] else ""
    print(f'  {ids[f["von"]]} -->{beschriftung} {ids[f["nach"]]}')
```

Weil Mermaid-Kennungen keine Leerzeichen enthalten dürfen, vergibt das Skript Kurzkennungen (`n0`, `n1`, …) und zeigt den Klartextnamen als Beschriftung der Form. Die Formen kommen aus einem Wörterbuch, sodass sich die Notation an einer Stelle ändern lässt. Ein unbeschrifteter Fluss wird ohne Beschriftung ausgegeben; die Prüfung aus dem Abschnitt zum DFD würde ihn vorher melden.

**Lösung zu Aufgabe 8.** Ursache: Diagramme liegen als Bilddateien ohne Quelle und ohne Besitzer vor. Verfahren: (1) Die Diagramme werden als Text (Mermaid oder ähnlich) im Repository neben der Dokumentation abgelegt; die Bilder werden bei jeder Änderung automatisch exportiert und nie von Hand abgelegt. (2) Jedes Diagramm hat einen Owner und eine Version im Manifest oder Dateikopf. (3) Änderungen laufen über Änderungsanträge mit Review (mit Checkliste: Legende, Beschriftung, Abstraktionsebene, Stand). (4) Die Pipeline prüft Syntax und einfache Regeln (Elementanzahl, verwaiste Knoten). (5) Alte Bilder werden gelöscht oder archiviert, es gibt eine einzige maßgebliche Quelle, auf die in der Dokumentation verwiesen wird. Erfolgskriterium: Bei der nächsten Systemänderung wird das Diagramm im selben Änderungsantrag angepasst, und niemand fragt mehr, welche Version gilt.
