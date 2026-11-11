# Modul 16 - Kennzahlen, Audits und kontinuierliche Verbesserung

> **Hinweis zu diesem Kapitel:** Das ist das Kapitel des Skripts „Technische Dokumentation und Dokumentations-Governance“, aus der LaTeX-Quelle in Markdown umgewandelt (Text und Listings unverändert, farbige Boxen als Zitatblöcke mit fettem Titel, Tabellen als Markdown-Tabellen, Übungsaufgaben und Lösungen als Absätze). Die Lerneinheiten sind wie in der Quelle nach Modul nummeriert (16.1 bis 16.8), danach folgen „Übungsaufgaben“ (8 Aufgaben) und „Lösungen und Erläuterungen“. Die Sprachangabe der Codeblöcke ist in der Quelle nur für Python und Bash gesetzt; die übrigen Blöcke sind hier nach ihrem Inhalt als `python`, `yaml`, `markdown`, `bash` oder `text` ausgezeichnet, der Inhalt selbst ist unverändert. **Prüfstand der Beispiele für dieses Repository:** Die Python-Beispiele wurden auf Syntax geprüft; welche Beispiele ausgeführt wurden und welche zusätzlich PyYAML brauchen, steht in der [README des Repositories](../README.md). Übersicht zum Modul: [README](README.md).

**Dauer:** 8,75 Stunden | **Priorität:** 2 | **Lerneinheiten:** 8

| **Nr.** | **Lerneinheit**      | **Dauer (h)** | **Prio** |
|--------:|:---------------------|--------------:|---------:|
|       1 | Dokumentations KPIs  |          1,25 |        1 |
|       2 | Coverage Rate        |          1,25 |        1 |
|       3 | Aktualitätsquote     |             1 |        1 |
|       4 | Review Compliance    |             1 |        1 |
|       5 | Audit Vorbereitung   |             1 |        1 |
|       6 | Reifegradmodell      |             1 |        2 |
|       7 | Verbesserungsbacklog |             1 |        2 |
|       8 | KPI-Troubleshooting  |          1,25 |        2 |
|         | **Summe**            |      **8,75** |          |

## 16.1 Dokumentations KPIs

Kennzahlen (englisch Key Performance Indicators, KPIs) machen Dokumentationsqualität messbar. Ohne Zahlen bleibt jede Diskussion über „gute“ oder „schlechte“ Dokumentation eine Frage der Meinung; mit Zahlen kann man Entwicklungen verfolgen, Prioritäten begründen und Erfolge zeigen. Zugleich sind Kennzahlen gefährlich, weil sie Verhalten steuern: Was gemessen wird, wird optimiert, nicht immer im Sinne dessen, was man erreichen wollte. Dieses Modul behandelt deshalb beides, die wichtigsten Kennzahlen und die Regeln, mit denen man sie ehrlich hält.

Eine gute Kennzahl beantwortet eine *Frage*, die jemand tatsächlich stellt. „Wie viele Dokumente haben wir?“ ist selten eine solche Frage, „Können Betriebsmitarbeiter bei einer Störung die richtige Anleitung finden und sich darauf verlassen?“ dagegen schon. Daraus folgen Kennzahlen wie die Top-3-Quote der Suche (Modul 15), die Aktualitätsquote und die Coverage Rate (die folgenden Abschnitte). Jede Kennzahl braucht eine eindeutige *Definition* (Formel, Datenquelle, Zeitraum), einen *Owner*, der sie erhebt und erklärt, einen *Zielwert* oder Zielbereich und eine *Gegenkennzahl*, die verhindert, dass man die erste auf Kosten einer anderen verbessert. Wer zum Beispiel die Aktualitätsquote erhöhen will, kann Dokumente archivieren, statt sie zu prüfen; die Gegenkennzahl (Archivierungsquote oder die Zahl aktiver Dokumente) macht das sichtbar.

> **Ergänzung aus der Nachrecherche**
>
> Zur Warnung vor falsch verstandenen Kennzahlen: Ein abgerufener Beitrag von Thoughtworks über fragwürdige Qualitätsmetriken in der Softwareentwicklung nennt als Beispiel die Code-Abdeckung durch Tests. Sie sei nützlich, um Risikobereiche zu finden, aber riskant als Qualitätsmaß, weil Teams sie mit überflüssigen Tests oder Tests ohne Prüfung ausreizen können; der Beitrag verweist dazu auf das Goodhart’sche Gesetz, nach dem eine Messgröße, die zum Ziel wird, ihre Aussagekraft verliert. Die Übertragung auf Dokumentation liegt nahe: Eine Quote, die man erreichen *muss*, wird auch ohne die gewünschte Wirkung erreicht. Das ist die Begründung für Gegenkennzahlen und Stichproben. (Abruf 28.10.2026, siehe Quellenverzeichnis; der Beitrag betrifft Software-Tests, die Übertragung ist eine Schlussfolgerung.)

Das folgende Beispiel hält einen Kennzahlenkatalog in einer YAML-Datei fest und prüft ihn auf Vollständigkeit. Ein Katalog ist selbst ein Dokument, das gepflegt werden muss: Er legt fest, was jede Kennzahl bedeutet, und verhindert, dass zwei Abteilungen unter demselben Namen Verschiedenes messen.

```text
- name: Aktualitätsquote
  frage: Sind aktive Dokumente innerhalb ihres Zeitfensters geprüft?
  formel: geprüfte aktive Dokumente / aktive Dokumente
  quelle: Dokumentinventar
  owner: Redaktion
  ziel: 0.85
  gegenkennzahl: Archivierungsquote
- name: Coverage Rate
  frage: Gibt es zu jedem kritischen System die Pflichtdokumente?
  formel: vorhandene Pflichtdokumente / geforderte Pflichtdokumente
  quelle: Systemliste, Inventar
  owner: Betrieb
  ziel: 0.95
- name: Top-3-Quote
  frage: Wird das erwartete Dokument gefunden?
  formel: Fragen mit Treffer in Top 3 / Testfragen
  quelle: Testfragenliste
  owner:
  ziel: 0.70
  gegenkennzahl: Nulltreffer-Quote
```

```python
import yaml

PFLICHT = ["name", "frage", "formel", "quelle", "owner", "ziel"]
for k in yaml.safe_load(open("kpis.yaml", encoding="utf-8")):
    fehlt = [f for f in PFLICHT if not k.get(f)]
    hinweise = []
    if fehlt:
        hinweise.append("Pflichtangaben fehlen: " + ", ".join(fehlt))
    if not k.get("gegenkennzahl"):
        hinweise.append("keine Gegenkennzahl (Manipulationsrisiko)")
    print(f"{k['name']}: " + ("; ".join(hinweise) or "vollständig"))
```

Das Skript prüft je Kennzahl, ob die sechs Pflichtangaben vorhanden sind und ob eine Gegenkennzahl benannt ist. Für den Beispielkatalog gibt es drei Ergebnisse: Die Aktualitätsquote ist vollständig; die Coverage Rate hat keine Gegenkennzahl; bei der Top-3-Quote fehlt der Owner (der Wert ist leer), eine Gegenkennzahl ist vorhanden. Die Zielwerte sind Beispielwerte; sie müssen zur Organisation passen und sind kein Standard. Ein Zielwert von 100 Prozent ist selten sinnvoll, weil er Anreize zum Tricksen setzt und den Aufwand für die letzten Prozent unverhältnismäßig macht.

Typische Fehler: Man misst, was leicht zu messen ist, statt was wichtig ist; Kennzahlen haben keine Definition und werden je nach Bericht anders berechnet; es gibt zu viele Kennzahlen, und niemand schaut hin; Kennzahlen werden gegen Personen gewendet; es gibt keine Gegenkennzahl.

| **Falsch**                                                               | **Richtig**                                                                                                          |
|:-------------------------------------------------------------------------|:---------------------------------------------------------------------------------------------------------------------|
| Kennzahl „Anzahl Seiten im Wiki“ wächst jeden Monat und gilt als Erfolg. | Wenige Kennzahlen (fünf bis acht) mit Frage, Formel, Owner, Zielbereich und Gegenkennzahl, quartalsweise besprochen. |

Im Projekt beginnt man mit drei bis fünf Kennzahlen, die die dringendsten Fragen beantworten, und erweitert den Katalog erst, wenn die ersten verlässlich erhoben werden.

## 16.2 Coverage Rate

Die Coverage Rate (Abdeckungsquote) misst, wie vollständig die Dokumentation den *Bedarf* abdeckt: Zu wie vielen der Dinge, die dokumentiert sein sollten, gibt es tatsächlich ein Dokument? Sie beantwortet die Frage nach Lücken, während die Aktualitätsquote die Frage beantwortet, ob Vorhandenes noch stimmt. Beides zusammen ergibt ein Bild: ein vollständiger, aber veralteter Bestand ist ebenso schlecht wie ein aktueller, aber lückenhafter.

Die Berechnung braucht zwei Dinge. Erstens eine Liste dessen, was dokumentiert sein *soll*: Systeme, Dienste, Prozesse oder Schnittstellen aus einer verlässlichen Quelle, etwa einer Konfigurationsdatenbank (CMDB) oder einer Systemliste. Zweitens eine Regel, welche Dokumente je Objekt gefordert sind. Sinnvoll ist, diese Regel von der *Kritikalität* abhängig zu machen: Für ein kritisches System verlangt man Betriebsanleitung, Architekturbeschreibung und Notfallplan, für ein mittleres nur eine Betriebsanleitung, für ein unkritisches nichts. So bleibt der Aufwand verhältnismäßig, und die Quote misst, was wirklich zählt.

Das folgende Skript berechnet die Coverage Rate je Kritikalitätsstufe und nennt die fehlenden Dokumente. Es liest eine Systemliste und eine Liste der vorhandenen Dokumente je System.

```text
system;kritikalitaet
shop;hoch
crm;mittel
druckserver;niedrig
db-cluster;hoch
```

```text
system;dokumentart
shop;runbook
shop;architektur
shop;notfallplan
crm;runbook
db-cluster;runbook
```

```python
import csv
from collections import defaultdict

PFLICHT = {"hoch": {"runbook", "architektur", "notfallplan"},
           "mittel": {"runbook"},
           "niedrig": set()}
vorhanden = defaultdict(set)
for z in csv.DictReader(open("dokus.csv", encoding="utf-8"), delimiter=";"):
    vorhanden[z["system"]].add(z["dokumentart"])

summe = defaultdict(lambda: [0, 0])      # kritikalität -> [vorhanden, gefordert]
for z in csv.DictReader(open("systeme.csv", encoding="utf-8"), delimiter=";"):
    soll = PFLICHT[z["kritikalitaet"]]
    fehlt = soll - vorhanden[z["system"]]
    summe[z["kritikalitaet"]][0] += len(soll) - len(fehlt)
    summe[z["kritikalitaet"]][1] += len(soll)
    if fehlt:
        print(f"{z['system']} ({z['kritikalitaet']}): fehlt {', '.join(sorted(fehlt))}")
for stufe, (ist, soll) in summe.items():
    if soll:
        print(f"Coverage {stufe}: {ist}/{soll} = {100 * ist / soll:.0f} Prozent")
```

Die Datei `dokus.csv` hat zwei Spalten, Semikolon als Trenner; sie listet Shop mit Betriebsanleitung, Architektur und Notfallplan, CRM mit Betriebsanleitung und das Datenbank-Cluster mit Betriebsanleitung. Das Skript nutzt eine Mengenoperation: Die Differenz aus geforderten und vorhandenen Dokumentarten ergibt die fehlenden. Das Ergebnis: Beim Datenbank-Cluster (hohe Kritikalität) fehlen Architekturbeschreibung und Notfallplan; die Coverage Rate der hohen Stufe beträgt vier von sechs, also 67 Prozent (der Shop ist vollständig, das Cluster hat nur eines von drei Dokumenten); die mittlere Stufe ist mit einem von einem gefordert vollständig, und für die niedrige Stufe wird nichts gefordert, sodass sie nicht ausgegeben wird. Der Bericht liefert zugleich die Arbeitsliste: Zuerst Architektur und Notfallplan des Datenbank-Clusters schreiben.

Beachten Sie die Grenzen. Die Quote misst das *Vorhandensein* eines Dokuments, nicht dessen Qualität; ein leeres Dokument zählt als vorhanden. Sie ist nur so gut wie die Systemliste: Fehlt ein System in der Liste, fehlt es auch in der Quote, sodass die Liste selbst vollständig sein muss. Und sie lädt zum Tricksen ein, etwa durch Platzhalterdokumente. Gegenmittel sind Qualitätsstichproben (Abschnitt Audit Vorbereitung) und die Kopplung an die Aktualitätsquote.

Typische Fehler: Man misst die Abdeckung gegen eine unvollständige Liste; man fordert für alles dasselbe, sodass die Quote niemals steigt; man zählt Platzhalter; man verwechselt Abdeckung mit Qualität.

| **Falsch**                                                                   | **Richtig**                                                                                                          |
|:-----------------------------------------------------------------------------|:---------------------------------------------------------------------------------------------------------------------|
| Coverage 100 Prozent, weil für jedes System eine leere Seite angelegt wurde. | Coverage zählt nur Dokumente, die mindestens den Mindestinhalt der Vorlage (Modul 07) erfüllen und freigegeben sind. |

Im Projekt koppelt man die Coverage Rate an die Einführung neuer Systeme: Ein System geht erst in den Betrieb, wenn seine Pflichtdokumente vorliegen (Definition of Done, siehe Modul 12, Ticket Verknüpfung).

## 16.3 Aktualitätsquote

Die Aktualitätsquote misst den Anteil der aktiven Dokumente, die innerhalb ihres vorgesehenen Zeitfensters geprüft wurden. Die Berechnung für einen Stichtag haben Sie in Modul 14 (Lifecycle-Troubleshooting) kennengelernt. Dieser Abschnitt betrachtet die Quote als *Verlaufsgröße*: Wie entwickelt sie sich im Lauf der Zeit, und was sagt der Verlauf über die Wirksamkeit der Maßnahmen?

Eine abgerufene Quelle (Metabase) definiert die Aktualitätsquote als Anteil der aktiven Inhalte, die innerhalb ihres Zeitfensters geprüft wurden, nennt kein allgemeingültiges Ziel und betont, dass bei Änderungen, die ohne menschliche Prüfung erfolgen, die Aktualität nicht belegt ist. Das verlangt zwei Entscheidungen. Erstens braucht jede Dokumentart ein eigenes Zeitfenster, denn ein Notfallplan altert schneller als ein Grundlagentext. Zweitens muss festgelegt sein, was als „geprüft“ zählt: ein dokumentiertes Review, nicht jede Änderung des Dokuments.

Ein Stichtagswert ist eine Momentaufnahme; erst der Verlauf zeigt, ob eine Verbesserung greift oder die Quote nach einer Aufräumaktion wieder abfällt. Aus den Prüfereignissen lässt sich die Quote für jeden vergangenen Stichtag nachträglich berechnen: Man nimmt für jedes Dokument das letzte Review vor dem Stichtag. Das folgende Skript tut das für drei Stichtage.

```text
titel;art;datum
Notfallplan Shop;notfallplan;2025-12-01
Notfallplan Shop;notfallplan;2026-04-01
Runbook Neustart;runbook;2025-12-01
Runbook Backup;runbook;2025-08-15
Runbook Backup;runbook;2026-09-10
Betriebshandbuch DB;runbook;2025-07-01
Betriebshandbuch DB;runbook;2026-08-20
Grundlagen;grundlagen;2024-09-01
```

```python
import csv
from datetime import date

FENSTER = {"notfallplan": 180, "runbook": 365, "grundlagen": 730}
ereignisse = sorted(csv.DictReader(open("pruefungen.csv", encoding="utf-8"), delimiter=";"),
                    key=lambda z: z["datum"])
dokumente = {z["titel"]: z["art"] for z in ereignisse}

for stichtag in [date(2026, 6, 30), date(2026, 8, 31), date(2026, 10, 28)]:
    letzte = {}
    for z in ereignisse:
        if date.fromisoformat(z["datum"]) <= stichtag:
            letzte[z["titel"]] = date.fromisoformat(z["datum"])
    ok = [t for t, a in dokumente.items()
          if t in letzte and (stichtag - letzte[t]).days <= FENSTER[a]]
    print(f"{stichtag}: {len(ok)}/{len(dokumente)} im Zeitfenster ({100 * len(ok) // len(dokumente)} Prozent)")
```

Die Prüfereignisse sind nach Datum sortiert; für jeden Stichtag gilt pro Dokument das jüngste Ereignis bis zu diesem Tag, spätere Prüfungen werden ignoriert (ein Fehler, den ich in einer ersten Fassung des Skripts gemacht hatte: Ohne diese Einschränkung zählten künftige Prüfungen in der Vergangenheit mit und ergaben fälschlich 100 Prozent). Das Ergebnis: Zum 30. Juni 2026 sind alle fünf Dokumente im Fenster (100 Prozent); zum 31. August sind es vier (80 Prozent), denn das Runbook Backup ist 381 Tage ungeprüft und liegt über dem Fenster von 365 Tagen; zum 28. Oktober sind es nur drei (60 Prozent): Der Notfallplan ist nach 210 Tagen über sein Fenster von 180 Tagen hinaus, die Grundlagen nach 787 Tagen über ihre 730, während das Runbook Backup durch die Prüfung vom 10. September wieder im Fenster liegt. Der Verlauf zeigt also einen Abwärtstrend trotz einzelner Prüfungen. Das ist die Information, die ein Stichtagswert nicht liefert: Es wird geprüft, aber nicht schnell genug.

Typische Fehler: Man misst die Quote nur zum Stichtag; man zählt automatische Änderungen als Prüfung; man verwendet dasselbe Fenster für alles; man erhöht die Quote, indem man Fenster verlängert oder Dokumente aus der Zählung nimmt; man vergleicht Quoten verschiedener Bereiche, ohne dass die Fenster gleich sind.

| **Falsch**                                                                                     | **Richtig**                                                                                                                |
|:-----------------------------------------------------------------------------------------------|:---------------------------------------------------------------------------------------------------------------------------|
| Quote steigt von 55 auf 90 Prozent, weil das Zeitfenster von 6 auf 18 Monate verlängert wurde. | Fenster bleiben stabil und sind in der Kennzahlendefinition festgeschrieben; Änderungen der Definition werden ausgewiesen. |

Im Projekt hält man die Verlaufsgrafik für Leitung und Owner bereit; ein monatlicher Wert genügt. Wichtig ist, die Definition festzuhalten, damit die Reihe vergleichbar bleibt.

## 16.4 Review Compliance

Review Compliance hat in der Dokumentations-Governance zwei Bedeutungen, die man auseinanderhalten sollte. Die eine ist die *Einhaltung des Review-Prozesses*: Werden Reviews zum geplanten Zeitpunkt und mit dem vorgesehenen Ergebnis durchgeführt? Die andere ist die *Einhaltung von Compliance-Vorgaben in der Dokumentation*: Sind Klassifizierung, Berechtigungen, Aufbewahrung und Löschfristen so gesetzt, wie Datenschutz und Informationssicherheit es verlangen? Der Lehrplan verknüpft beide: Die Reviews sollen auch prüfen, ob die Dokumentation Datenschutz und Informationssicherheit einhält. Die inhaltlichen Anforderungen (DSGVO-Bezug, Klassifizierung, Berechtigungskonzept, Aufbewahrung und Löschung) wurden in Modul 13 erklärt; hier steht ihre *regelmäßige Überprüfung* im Mittelpunkt.

Ein Compliance-Review prüft für jedes Dokument eine kurze Liste von Fragen. Ist es klassifiziert? Passen die Leseberechtigungen zur Klasse? Enthält es personenbezogene Daten, und wenn ja, gibt es eine Löschfrist? Ist das nächste Review eingetragen und nicht überfällig? Solche formalen Fragen lassen sich weitgehend automatisch beantworten; die inhaltliche Beurteilung bleibt Aufgabe von Menschen. Das folgende Skript führt vier solche Prüfungen für eine Inventarliste durch.

```text
titel;klasse;lesegruppe;personenbezug;loeschfrist;naechste_pruefung
Notfallplan Shop;intern;alle;nein;;2027-03-01
Mitarbeiterliste;vertraulich;alle;ja;;2026-09-01
Lohnabrechnung 2025;streng;hr;ja;2035-12-31;2027-01-01
Passwortrichtlinie;;alle;nein;;2027-05-01
```

```python
import csv
from datetime import date

HEUTE = date(2026, 10, 28)
for z in csv.DictReader(open("compl.csv", encoding="utf-8"), delimiter=";"):
    v = []
    if not z["klasse"]:
        v.append("keine Klassifizierung")
    if z["klasse"] in ("vertraulich", "streng") and z["lesegruppe"] == "alle":
        v.append("vertraulich, aber für alle lesbar")
    if z["personenbezug"] == "ja" and not z["loeschfrist"]:
        v.append("personenbezogen ohne Löschfrist")
    if date.fromisoformat(z["naechste_pruefung"]) < HEUTE:
        v.append("Prüfung überfällig")
    print(f"{z['titel']}: " + ("; ".join(v) or "ohne Beanstandung"))
```

Die vier Beispieldokumente zeigen die Spannweite: Der Notfallplan und die Lohnabrechnung sind ohne Beanstandung. Die Mitarbeiterliste hat gleich drei Verstöße: Sie ist vertraulich, aber für alle lesbar, enthält personenbezogene Daten ohne Löschfrist und hat eine überfällige Prüfung. Bei der Passwortrichtlinie fehlt die Klassifizierung. Daraus ergibt sich eine Reihenfolge der Maßnahmen: Die Mitarbeiterliste sofort einschränken (Vertraulichkeit), dann Löschfrist und Prüfung klären, dann die Klassifizierung der Richtlinie nachholen. Der Bericht ist eine Prüfhilfe, keine rechtliche Beurteilung: Ob eine Löschfrist richtig ist, entscheiden die Vorgaben der Organisation und das geltende Recht (keine Rechtsberatung, siehe Modul 13).

Die Review Compliance *im Prozesssinn* ist die Quote der fristgerecht durchgeführten Reviews. Sie lässt sich wie die Aktualitätsquote berechnen, bezieht sich aber auf die *Termine*: Von allen Reviews, die im Zeitraum fällig waren, wie viele wurden rechtzeitig abgeschlossen? Zusätzlich lohnt der Blick auf die *Wirkung*: Wie viele Reviews haben Änderungen ergeben? Eine Quote von 100 Prozent bestandenen Reviews ohne eine einzige Änderung ist verdächtig und deutet auf Abnick-Reviews hin (Modul 14).

Typische Fehler: Compliance wird als einmalige Aufgabe beim Audit behandelt; Klassifizierung ist nur im Dokument vermerkt, aber nicht in den Berechtigungen umgesetzt; Reviews prüfen nur Inhalte, nicht Schutz und Aufbewahrung; Ergebnisse der Prüfungen werden nicht festgehalten.

| **Falsch**                                                                                 | **Richtig**                                                                                                                |
|:-------------------------------------------------------------------------------------------|:---------------------------------------------------------------------------------------------------------------------------|
| Dokument trägt den Vermerk „vertraulich“, liegt aber auf einem für alle lesbaren Laufwerk. | Klassifizierung und Berechtigung sind verknüpft, und der Review prüft beides; Abweichungen werden als Befund festgehalten. |

Im Projekt integriert man die formalen Prüfungen in die Pipeline oder in den Pflegelauf (Modul 14), sodass der menschliche Review sich auf das konzentrieren kann, was nur Menschen beurteilen.

## 16.5 Audit Vorbereitung

Ein Audit ist eine systematische, unabhängige Prüfung, ob etwas den festgelegten Anforderungen entspricht. Für die Dokumentation kann das ein internes Audit der Dokumentationsprozesse sein, das Audit eines Managementsystems (etwa zur Informationssicherheit), bei dem Dokumentation Nachweis ist, oder eine Prüfung durch Kunden oder Aufsicht. Auditvorbereitung heißt, *vorab* dafür zu sorgen, dass die Prüfung bestanden werden kann, und zwar nicht durch Kosmetik kurz vorher, sondern durch Praxis, die ohnehin gelebt wird.

Zur Einordnung hilft die internationale Leitlinie ISO 19011 zur Auditierung von Managementsystemen. Nach einer abgerufenen Darstellung (Process Street, eine Drittquelle) ist sie ein Leitfaden und enthält keine Anforderungen, weshalb sich Organisationen nicht nach ISO 19011 zertifizieren lassen. Sie nennt sieben Prinzipien (Integrität, sachliche Darstellung, berufliche Sorgfalt, Vertraulichkeit, Unabhängigkeit, Evidenzbasierung und Risikoorientierung), beschreibt ein Auditprogramm, das Planung, Umfang, Ziele und Kriterien regelt, und legt den Ablauf fest: Kontaktaufnahme, Eröffnungsgespräch, Sammeln von Nachweisen, Bewertung gegen Kriterien, Bericht und Abschlussgespräch. Nachweise stammen wegen begrenzter Zeit aus Stichproben, und Feststellungen müssen sich ausschließlich auf Auditnachweise stützen. Für Dokumentation bedeutet das: Es genügt nicht, dass etwas stimmt, man muss es *belegen* können.

> **Ergänzung aus der Nachrecherche**
>
> Die Angaben zu ISO 19011 stammen aus einer abgerufenen Drittquelle (Process Street). Den Normtext habe ich nicht eingesehen; für verbindliche Aussagen ist die Norm selbst maßgeblich. Ob und welche Audits in Ihrer Organisation gelten (etwa nach ISO 9001 oder ISO 27001), richtet sich nach deren Managementsystemen; diese Frage kann dieses Modul nicht beantworten. (Abruf 28.10.2026, siehe Quellenverzeichnis.)

Die praktische Vorbereitung besteht aus drei Dingen. Erstens eine *Audit-Checkliste*: je Anforderung eine Kontrolle und der Nachweis, der sie belegt. Zweitens eine *Nachweisablage*: Die Nachweise (Freigabeprotokolle, Review-Berichte, Listen, Löschprotokolle) liegen an festgelegter Stelle und sind dem Prüfzeitraum zuordenbar. Drittens *Stichproben*: Man prüft vorab selbst, ob eine zufällig gezogene Auswahl von Dokumenten die Anforderungen erfüllt, so wie es später die Auditoren tun. Das folgende Skript prüft für eine Liste von Kontrollen, ob der jeweilige Nachweis in der Ablage vorhanden ist, und zieht eine reproduzierbare Stichprobe aus dem Bestand.

```text
kontrolle;nachweis;zeitraum_von;zeitraum_bis
Jedes Dokument hat einen Owner;owner_liste.csv;2026-01-01;2026-12-31
Reviews finden planmäßig statt;review_2026-09.pdf;2026-01-01;2026-12-31
Richtlinien sind freigegeben;freigabe_richtlinie.pdf;2026-01-01;2026-12-31
Löschungen werden protokolliert;loeschprotokoll.pdf;2026-01-01;2026-12-31
```

```python
import csv, random
from pathlib import Path

for z in csv.DictReader(open("kontrollen.csv", encoding="utf-8"), delimiter=";"):
    datei = Path("nachweise") / z["nachweis"]
    status = "Nachweis vorhanden" if datei.exists() else "NACHWEIS FEHLT"
    print(f"{z['kontrolle']}: {status} ({z['nachweis']})")

bestand = [f"Dokument {n:02d}" for n in range(1, 41)]
stichprobe = random.Random(2026).sample(bestand, 5)
print("Stichprobe (reproduzierbar):", sorted(stichprobe))
```

Im Testordner `nachweise` lagen zwei der vier Nachweise, nämlich der Review-Bericht und die Richtlinienfreigabe. Das Skript meldet: Für die Kontrollen „Jedes Dokument hat einen Owner“ und „Löschungen werden protokolliert“ fehlt der Nachweis, für die beiden anderen ist er vorhanden. Die Stichprobe zieht fünf von vierzig Dokumenten mit festem Startwert: Dokument 07, 08, 15, 21 und 33. Der feste Startwert macht die Auswahl wiederholbar, was für ein Prüfprotokoll nützlich ist; allerdings kann das Ergebnis je nach Python-Version abweichen, weshalb man bei einer echten Prüfung die gezogene Liste selbst im Protokoll festhält und nicht nur den Startwert. Die Existenz einer Datei ist natürlich nur ein formaler Test; ob der Nachweis den Zeitraum abdeckt und die Kontrolle belegt, prüft ein Mensch.

Typische Fehler: Die Vorbereitung beginnt eine Woche vor dem Audit; Nachweise werden nachträglich erzeugt; man stellt Dokumente zusammen, die gut aussehen, aber nicht der gelebten Praxis entsprechen; Feststellungen werden als Angriff verstanden statt als Hinweise; die Maßnahmen aus dem letzten Audit sind nicht umgesetzt.

| **Falsch**                                                                                    | **Richtig**                                                                                                                                              |
|:----------------------------------------------------------------------------------------------|:---------------------------------------------------------------------------------------------------------------------------------------------------------|
| Eine Woche vor dem Audit werden Review-Protokolle für das ganze Jahr nachträglich ausgefüllt. | Review-Protokolle entstehen im laufenden Betrieb; vor dem Audit prüft man nur, ob sie vollständig abgelegt sind, und schließt Lücken offen, mit Vermerk. |

Im Projekt macht man ein internes *Probe-Audit* ein bis zwei Monate vor dem echten, mit Stichprobe und Befundliste. Aus den Befunden entstehen Aufgaben im Verbesserungsbacklog (Abschnitt Verbesserungsbacklog).

## 16.6 Reifegradmodell

Ein Reifegradmodell beschreibt in aufeinander aufbauenden Stufen, wie weit entwickelt eine Fähigkeit in einer Organisation ist, hier die Dokumentations-Governance. Es beantwortet nicht, ob die Dokumentation gut ist, sondern *wie systematisch* sie betrieben wird: zufällig, gesteuert, standardisiert, gemessen oder laufend optimiert. Das Modell hilft bei der Standortbestimmung (Wo stehen wir?), der Zielsetzung (Wohin wollen wir?) und der Reihenfolge der Maßnahmen (Was ist der nächste Schritt?).

Das bekannteste Vorbild ist das Capability Maturity Model Integration (CMMI) mit fünf Stufen. Nach einer abgerufenen Darstellung (Visure Solutions, eine Drittquelle) sind es: Stufe 1 „Initial“ (unvorhersehbare, reaktive Prozesse, Ergebnisse hängen von Einzelnen ab), Stufe 2 „Managed“ (grundlegende Managementpraktiken), Stufe 3 „Defined“ (standardisierte, dokumentierte, organisationsweit abgestimmte Prozesse), Stufe 4 „Quantitatively Managed“ (Entscheidungen auf Basis von Kennzahlen) und Stufe 5 „Optimizing“ (laufende Verbesserung und Innovation). Das Modell stammt aus der Softwareentwicklung und der Prozessverbesserung; für die Dokumentation übertragen wir die Grundidee, nicht die Details.

> **Ergänzung aus der Nachrecherche**
>
> Das hier verwendete Dokumentations-Reifegradmodell lehnt sich an die fünf Stufen von CMMI an, ist aber eine eigene, vereinfachte Übertragung für dieses Skript und kein genormtes Modell: Stufe 1 Initial (Ablage vorhanden, sonst Zufall), Stufe 2 Gesteuert (Owner und Review-Termine), Stufe 3 Definiert (Standards, Vorlagen, Pflichtmetadaten, Freigabeprozess), Stufe 4 Gemessen (Kennzahlen erhoben, Audits durchgeführt), Stufe 5 Optimierend (Verbesserungsbacklog und kontinuierliche Verbesserung). Die Kriterien je Stufe sind Beispiele und sollten an die Organisation angepasst werden. (Quelle der CMMI-Stufen: Visure Solutions, Abruf 28.10.2026, siehe Quellenverzeichnis.)

Der Kern eines solchen Modells ist die *Stufenlogik*: Eine Stufe gilt erst als erreicht, wenn *alle* ihre Kriterien und die aller niedrigeren Stufen erfüllt sind. Man kann nicht auf Stufe vier sein, wenn Stufe drei Lücken hat, auch wenn schon Kennzahlen erhoben werden: Die Kennzahlen hätten kein stabiles Fundament. Das folgende Skript bewertet eine Selbsteinschätzung nach dieser Logik. Die Kriterien stehen in einer YAML-Datei, jeweils mit ja oder nein.

```yaml
stufen:
  1: {name: Initial, kriterien: {ablage_vorhanden: ja}}
  2: {name: Gesteuert, kriterien: {owner_je_dokument: ja, review_termine: ja}}
  3: {name: Definiert, kriterien: {standards_vorlagen: ja, metadaten_pflicht: ja, freigabeprozess: ja}}
  4: {name: Gemessen, kriterien: {kpis_erhoben: ja, audits_durchgefuehrt: nein}}
  5: {name: Optimierend, kriterien: {verbesserungsbacklog: nein}}
```

```python
import yaml

stufen = yaml.safe_load(open("reife.yaml", encoding="utf-8"))["stufen"]
erreicht = 0
for nr in sorted(stufen):
    offen = [k for k, v in stufen[nr]["kriterien"].items() if v != "ja"]
    if offen:
        print(f"Stufe {nr} ({stufen[nr]['name']}) nicht erreicht, offen: {', '.join(offen)}")
        break
    erreicht = nr
print(f"Erreichte Reifegradstufe: {erreicht} ({stufen[erreicht]['name'] if erreicht else '-'})")
```

Das Skript geht die Stufen der Reihe nach durch und bricht bei der ersten Stufe ab, die ein offenes Kriterium hat. Mit den Beispieldaten sind die Stufen eins bis drei vollständig erfüllt; bei Stufe vier fehlt das Kriterium „audits_durchgefuehrt“, deshalb meldet das Skript: Stufe 4 nicht erreicht, erreichte Stufe 3 (Definiert). Dass Stufe 5 ebenfalls offen ist, wird nicht mehr gemeldet, weil es für die Aussage nicht zählt. Der Wert des Modells liegt im Gespräch über den nächsten Schritt: Hier ist es offensichtlich das Durchführen von Audits.

Typische Fehler: Man strebt Stufe fünf an, obwohl Stufe drei genügen würde; die Einschätzung erfolgt als reine Selbstbeurteilung, ohne Stichprobe; man betrachtet den Reifegrad als Ziel an sich und vergisst den Nutzen; Kriterien sind so formuliert, dass sie immer „ja“ ergeben; man überspringt Stufen.

| **Falsch**                                                                             | **Richtig**                                                                                                    |
|:---------------------------------------------------------------------------------------|:---------------------------------------------------------------------------------------------------------------|
| „Wir haben Kennzahlen, also sind wir auf Stufe 4.“ (Owner und Freigabeprozess fehlen.) | Stufe ergibt sich aus der lückenlosen Erfüllung aller Kriterien bis zu dieser Stufe, belegt durch Stichproben. |

Im Projekt legt man ein *Zielniveau* je Bereich fest: Für Betriebsdokumentation mit hohem Risiko Stufe vier, für Hilfsdokumente Stufe zwei. Nicht alles muss gleich reif sein.

## 16.7 Verbesserungsbacklog

Ein Verbesserungsbacklog ist die geordnete Liste aller Verbesserungen an der Dokumentation, die man vornehmen möchte: Ergebnisse aus Audits, Rückmeldungen von Lesern, Befunde aus Kennzahlen, Ideen aus dem Team. Er sorgt dafür, dass Erkenntnisse nicht verloren gehen, und ermöglicht, bewusst zu entscheiden, was als Nächstes getan wird. Der Begriff stammt aus der agilen Softwareentwicklung, das Prinzip ist allgemein: eine einzige, sichtbare, priorisierte Liste, aus der man in festen Abständen den nächsten Abschnitt der Arbeit auswählt. Das ist der Kern der kontinuierlichen Verbesserung (Modul 17).

Jeder Eintrag braucht wenigstens einen Titel, eine Beschreibung, eine Schätzung des Nutzens, des Aufwands und ein Risiko, damit man vergleichen kann. Die Priorisierung nach *Nutzen im Verhältnis zum Aufwand* ist eine einfache, bewährte Regel: Kleine Maßnahmen mit großer Wirkung zuerst. Ein Risikoaufschlag berücksichtigt, dass manche Maßnahmen dringlicher sind, weil ihr Unterlassen Schaden anrichtet, etwa verwaiste Betriebsanleitungen. Die Kapazität begrenzt, wie viel in einem Quartal passieren kann; Ehrlichkeit über die Kapazität ist wichtiger als ein ehrgeiziger Plan.

Das folgende Skript berechnet für jeden Eintrag den Wert je Stunde (Nutzen mal Risikofaktor durch Aufwand), sortiert absteigend und füllt die Quartalskapazität von 30 Stunden der Reihe nach auf. Einträge, die nicht mehr hineinpassen, werden zurückgestellt. Die Skalen (Nutzen von eins bis zehn, Risikofaktoren 1,0, 1,2 und 1,5) sind für dieses Beispiel gewählt; jede Organisation legt ihre eigenen fest.

```text
id;titel;nutzen;aufwand_h;risiko
B1;Owner für 12 verwaiste Runbooks zuordnen;8;6;hoch
B2;Synonymliste Suche anlegen;5;4;niedrig
B3;Wiki-Struktur neu ordnen;7;40;mittel
B4;Pflegetag einführen;6;2;niedrig
B5;Altes Wiki archivieren;6;16;mittel
```

```python
import csv

KAPAZITAET = 30   # Stunden im Quartal
RISIKO = {"niedrig": 1.0, "mittel": 1.2, "hoch": 1.5}   # Risikoaufschlag auf den Nutzen
punkte = []
for z in csv.DictReader(open("backlog.csv", encoding="utf-8"), delimiter=";"):
    wert = int(z["nutzen"]) * RISIKO[z["risiko"]] / int(z["aufwand_h"])
    punkte.append((wert, z["id"], z["titel"], int(z["aufwand_h"])))

rest = KAPAZITAET
for wert, id_, titel, h in sorted(punkte, reverse=True):
    if h <= rest:
        rest -= h
        print(f"{id_} {titel}: Wert/Aufwand {wert:.2f}, {h} h -> im Quartal")
    else:
        print(f"{id_} {titel}: Wert/Aufwand {wert:.2f}, {h} h -> zurückgestellt (Rest {rest} h)")
```

Das Ergebnis: Der Pflegetag (Wert 3,00 bei zwei Stunden), die Zuordnung der Owner (2,00 bei sechs Stunden), die Synonymliste (1,25 bei vier Stunden) und die Archivierung des alten Wikis (0,45 bei 16 Stunden) passen in die 30 Stunden; zusammen sind das 28 Stunden. Die Neuordnung der Wiki-Struktur (0,21 bei 40 Stunden) wird zurückgestellt, bei zwei verbleibenden Stunden. Man sieht, wie die Regel kleine Maßnahmen mit hoher Wirkung belohnt, und zugleich ihre Schwäche: Große, wichtige, aber teure Vorhaben fallen durch, obwohl sie strategisch nötig sein könnten. Solche Vorhaben muss man bewusst in Teile zerlegen oder als eigenes Projekt führen. Die Zahl ist eine Entscheidungshilfe, nicht die Entscheidung.

Typische Fehler: Der Backlog ist eine Wunschliste ohne Priorisierung; er wächst, ohne dass abgearbeitet wird; Einträge haben keinen Owner; er ist in privaten Notizen statt sichtbar; Maßnahmen aus Audits und Feedback landen nicht darin; große Vorhaben bleiben als ein riesiger Eintrag liegen.

| **Falsch**                                                                        | **Richtig**                                                                                                                                         |
|:----------------------------------------------------------------------------------|:----------------------------------------------------------------------------------------------------------------------------------------------------|
| Eine Mail-Folge mit 60 Verbesserungsideen, niemand weiß, welche umgesetzt wurden. | Ein Backlog mit Nutzen, Aufwand, Risiko, Owner, Status; vierteljährlich auf Basis der Kapazität ausgewählt; Abgeschlossenes wird sichtbar abgehakt. |

Im Projekt hat sich ein fester Rhythmus bewährt: Quartalsplanung, in der der Backlog gesichtet und die Kapazität verteilt wird, und ein kurzer Rückblick, in dem man prüft, ob die abgeschlossenen Maßnahmen die gewünschte Kennzahl bewegt haben.

## 16.8 KPI-Troubleshooting

Dieser Abschnitt zeigt, wie man typische Fehlerbilder bei Kennzahlen und Audits anhand von Struktur, Aktualität, Zielgruppenfeedback und Review-Kommentaren eingrenzt und daraus Handlungsschritte für Redaktion, Fachbereich und Betrieb ableitet. Das Besondere an diesem Troubleshooting ist, dass nicht das Dokument, sondern die *Messung* der Verdächtige ist: Stimmt die Zahl, und sagt sie, was wir glauben?

Typische Symptome: „Die Quote ist grün, aber die Leser beschweren sich“ deutet auf eine Kennzahl, die das Falsche misst oder ausgereizt wird. „Die Quote springt plötzlich“ deutet auf eine geänderte Definition, einen anderen Nenner oder einen Datenfehler. „Niemand traut den Zahlen“ deutet auf fehlende Definition oder ungeklärte Datenherkunft. „Die Kennzahlen verbessern sich, aber die Audit-Befunde bleiben“ deutet auf eine Messung, die an der gelebten Praxis vorbeigeht. Gemeinsam ist, dass eine *unabhängige Stichprobe* die Frage klären kann: Man prüft von Hand eine kleine Zahl von Dokumenten und vergleicht das Ergebnis mit der gemeldeten Kennzahl.

Das folgende Skript führt diesen Vergleich vor. Es liest monatliche Werte (aktive Dokumente, als geprüft gemeldete Dokumente, Ergebnis einer manuellen Stichprobe von zehn Dokumenten) und meldet zwei Auffälligkeiten: eine steigende Quote bei schrumpfendem Nenner und eine Abweichung zwischen Quote und Stichprobe von mehr als 25 Prozentpunkten.

```text
monat;aktive;geprueft;stichprobe_ok;stichprobe_n
2026-07;200;110;8;10
2026-08;200;120;7;10
2026-09;150;115;5;10
2026-10;120;110;4;10
```

```python
import csv

vorher = None
for z in csv.DictReader(open("monate.csv", encoding="utf-8"), delimiter=";"):
    aktive, geprueft = int(z["aktive"]), int(z["geprueft"])
    quote = geprueft / aktive
    stich = int(z["stichprobe_ok"]) / int(z["stichprobe_n"])
    hinweise = []
    if vorher and quote > vorher[0] and aktive < vorher[1]:
        hinweise.append("Quote steigt, weil der Nenner schrumpft")
    if quote - stich > 0.25:
        hinweise.append("Meldung weicht von der Stichprobe ab")
    print(f"{z['monat']}: Quote {100 * quote:.0f} Prozent, Stichprobe in Ordnung {100 * stich:.0f} Prozent"
          + ("  <- " + "; ".join(hinweise) if hinweise else ""))
    vorher = (quote, aktive)
```

Die Ausgabe: Im Juli liegt die Quote bei 55 Prozent und die Stichprobe bei 80 Prozent; im August bei 60 und 70 Prozent; im September steigt die Quote auf 77 Prozent, während die Stichprobe auf 50 Prozent fällt, und die Zahl der aktiven Dokumente sank von 200 auf 150; im Oktober steigt die Quote auf 92 Prozent, die Stichprobe fällt auf 40 Prozent, die aktiven Dokumente sind auf 120 gesunken. Beide Hinweise erscheinen im September und Oktober. Das Bild ist typisch: Die Quote sieht immer besser aus, weil statt zu prüfen Dokumente aus der Zählung genommen wurden (der Nenner schrumpft), und die manuelle Stichprobe zeigt, dass die Qualität dabei eher sinkt. Die Daten sind ein konstruiertes Beispiel; in der Praxis ist die Ursache nicht immer Absicht, sie kann auch auf eine legitime Bereinigung zurückgehen. Das Skript liefert deshalb Verdachtsmomente, keine Anklage: Der nächste Schritt ist ein Gespräch und ein Blick in die ausgeschiedenen Dokumente.

Als Runbook ergibt sich: Eine auffällige Kennzahl nicht sofort umsetzen, sondern ihre Definition, Datenquelle und Berechnung prüfen; den Nenner und seine Veränderung betrachten; eine unabhängige Stichprobe ziehen; Abweichungen klären; bei Bedarf die Kennzahl ergänzen (Gegenkennzahl) oder neu definieren; die Änderung der Definition dokumentieren und die Reihe entsprechend kennzeichnen. Zusätzlich hilft ein Gespräch mit den Beteiligten: Wer eine Kennzahl liefert, kennt meist ihre Schwächen.

Typische Fehler: Man reagiert auf Zahlenschwankungen, ohne die Ursache zu klären; man bestraft schlechte Zahlen und erzeugt damit Anreiz zum Schönen; man ändert Definitionen, ohne es zu vermerken; man verlässt sich auf eine einzige Kennzahl; man misst nur das, was automatisch verfügbar ist.

| **Falsch**                                                           | **Richtig**                                                                                          |
|:---------------------------------------------------------------------|:-----------------------------------------------------------------------------------------------------|
| Die Quote steigt von 60 auf 92 Prozent und wird als Erfolg gefeiert. | Vor der Feier: Nenner, Definition und eine Stichprobe prüfen; erst bei bestätigter Ursache bewerten. |

Im Projekt hat sich eine kleine Routine bewährt: Jeder Kennzahlenbericht enthält die Definition, die Veränderung des Nenners und das Ergebnis einer kleinen Stichprobe. Damit wird die Zahl erklärbar und vertrauenswürdig.

## Übungsaufgaben

Die Aufgaben steigen von Verständnisfragen (1 bis 3) über Anwendungsaufgaben (4 bis 5) bis zu Programmier- und Transferaufgaben (6 bis 8) an.

**Aufgabe 1.** *(leicht)* Nennen Sie die fünf Bestandteile, die eine Kennzahl im Katalog haben sollte, und erklären Sie, wozu eine Gegenkennzahl dient.

**Aufgabe 2.** *(leicht)* Worin unterscheiden sich Coverage Rate und Aktualitätsquote? Was misst die eine, was die andere?

**Aufgabe 3.** *(leicht bis mittel)* Erklären Sie die Stufenlogik eines Reifegradmodells und warum man Stufen nicht überspringen kann.

**Aufgabe 4.** *(mittel)* Definieren Sie für Ihre Organisation die Kennzahl „Review-Termintreue“ vollständig (Frage, Formel, Quelle, Owner, Zielbereich, Gegenkennzahl).

**Aufgabe 5.** *(mittel)* Legen Sie für drei Systemklassen (kritisch, mittel, unkritisch) fest, welche Pflichtdokumente gefordert sind, und berechnen Sie die Coverage Rate für eine Beispielliste mit sechs Systemen.

**Aufgabe 6.** *(mittel, praktisch)* Erweitern Sie das Coverage-Skript so, dass es zusätzlich die Gesamtquote über alle Stufen ausgibt.

**Aufgabe 7.** *(anspruchsvoll, praktisch)* Erweitern Sie das Compliance-Skript um eine Regel, die Dokumente mit Klasse „streng“ meldet, deren Prüfintervall länger als ein Jahr ist (Datei um die Spalte `letzte_pruefung` erweitern).

**Aufgabe 8.** *(anspruchsvoll, Transfer)* Planen Sie ein Probe-Audit für Ihre Dokumentation: Kontrollen, Nachweise, Stichprobenumfang, Zeitplan, Befundliste und Überführung in den Verbesserungsbacklog.

## Lösungen und Erläuterungen

**Lösung zu Aufgabe 1.** Eine Kennzahl im Katalog braucht eine Definition der Frage, die sie beantwortet, eine Formel, eine Datenquelle, einen Owner und einen Zielwert oder Zielbereich; die Gegenkennzahl kommt als sechste Angabe hinzu. Sie verhindert, dass die Hauptkennzahl auf Kosten einer anderen Größe verbessert wird. Beispiel: Wer die Aktualitätsquote erhöht, indem er Dokumente aus dem Bestand nimmt, zeigt das in der Gegenkennzahl (Zahl der aktiven Dokumente oder Archivierungsquote).

**Lösung zu Aufgabe 2.** Die Coverage Rate misst die Vollständigkeit: Gibt es zu allem, was dokumentiert sein soll, ein Dokument? Die Aktualitätsquote misst, ob die vorhandenen Dokumente innerhalb ihres Zeitfensters geprüft sind. Ein Bestand kann vollständig, aber veraltet sein (hohe Coverage, niedrige Aktualität) oder aktuell, aber lückenhaft (umgekehrt). Man braucht beide, um ein Bild zu erhalten.

**Lösung zu Aufgabe 3.** Eine Stufe ist erreicht, wenn alle Kriterien dieser Stufe und aller niedrigeren erfüllt sind. Das hat sachliche Gründe: Kennzahlen (Stufe vier) sind nur aussagekräftig, wenn Verantwortlichkeiten und Standards (Stufe zwei und drei) bestehen, sonst messen sie Zufall. Das Überspringen führt dazu, dass Maßnahmen ohne Fundament bleiben und beim nächsten Personalwechsel zerfallen. Das Skript bildet das ab, indem es bei der ersten offenen Stufe abbricht.

**Lösung zu Aufgabe 4.** Ein möglicher Entwurf. Frage: Werden Reviews zum geplanten Termin durchgeführt? Formel: Reviews, die bis zum Fälligkeitstag abgeschlossen wurden, geteilt durch alle im Zeitraum fälligen Reviews. Quelle: Review-Protokolle im Inventar. Owner: Redaktion. Zielbereich: zum Beispiel 80 bis 95 Prozent (kein Wert von 100, um Tricksen nicht zu provozieren). Gegenkennzahl: Anteil der Reviews mit mindestens einer Änderung, damit Abnick-Reviews auffallen. Wichtig ist, dass „abgeschlossen“ definiert ist, nämlich mit dokumentiertem Ergebnis.

**Lösung zu Aufgabe 5.** Ein möglicher Entwurf. Kritisch: Betriebsanleitung, Architekturbeschreibung, Notfallplan. Mittel: Betriebsanleitung. Unkritisch: keine Pflicht. Beispiel mit sechs Systemen, zwei kritisch (A mit drei, B mit einem Dokument), zwei mittel (je mit Betriebsanleitung, eines ohne) und zwei unkritisch: Kritische Stufe 4 von 6 (67 Prozent), mittlere Stufe 1 von 2 (50 Prozent), unkritische Stufe nicht berücksichtigt. Die Gesamtquote über beide Stufen beträgt 5 von 8, also rund 63 Prozent. Prüfen Sie die Rechnung am eigenen Beispiel; die Zahlen hier sind illustrativ.

**Lösung zu Aufgabe 6.** Eine mögliche Ergänzung nach der letzten Schleife:

```text
gesamt_ist = sum(ist for ist, soll in summe.values())
gesamt_soll = sum(soll for ist, soll in summe.values())
print(f"Coverage gesamt: {gesamt_ist}/{gesamt_soll} = {100 * gesamt_ist / gesamt_soll:.0f} Prozent")
```

Mit den Beispieldaten ergibt sich fünf von sieben, also 71 Prozent (vier von sechs bei hoch plus eines von eins bei mittel). Beachten Sie, dass die Gesamtquote die hohe Stufe nur mit ihrem Gewicht an Dokumenten zählt; wer kritische Systeme stärker gewichten will, muss gewichten oder die Stufen getrennt berichten.

**Lösung zu Aufgabe 7.** Die Datei erhält die Spalte `letzte_pruefung`; danach kommt die Regel in die Schleife:

```text
    if z["klasse"] == "streng":
        tage = (HEUTE - date.fromisoformat(z["letzte_pruefung"])).days
        if tage > 365:
            v.append(f"streng, aber seit {tage} Tagen ungeprüft")
```

Die Regel berechnet das Alter der letzten Prüfung und meldet streng klassifizierte Dokumente, die über ein Jahr ungeprüft sind. Das Intervall von 365 Tagen ist ein Beispiel; Ihre Informationssicherheitsregeln können einen anderen Wert vorgeben. Testen Sie mit einem Dokument, das gerade über und eines, das gerade unter der Grenze liegt.

**Lösung zu Aufgabe 8.** Ein möglicher Plan. Kontrollen: aus Ihrer Checkliste die zehn wichtigsten Anforderungen (Owner, Reviews, Freigaben, Klassifizierung, Aufbewahrung, Löschprotokolle). Nachweise: je Kontrolle der benannte Nachweis und sein Ablageort. Stichprobe: zum Beispiel fünf bis zehn Prozent des Bestands, mindestens zehn Dokumente, mit festgehaltener Ziehungsliste, aufgeteilt nach Kritikalität. Zeitplan: Vorbereitung vier Wochen, Durchführung eine Woche, Befundliste und Abschlussgespräch eine Woche, danach Überführung der Befunde in den Backlog. Befundliste: je Befund Kontrolle, Nachweis, Beschreibung, Einstufung (kritisch, wesentlich, Hinweis), Owner, Frist. Überführung: jeder Befund wird ein Backlog-Eintrag mit Nutzen, Aufwand und Risiko, und die Wirksamkeit wird im nächsten Probe-Audit überprüft. Nach der Systematik der ISO 19011 (Drittquelle) wären Unabhängigkeit der Prüfenden und evidenzbasierte Feststellungen die wichtigsten Grundsätze.
