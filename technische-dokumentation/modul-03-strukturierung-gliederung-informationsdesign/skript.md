# Modul 03 - Strukturierung, Gliederung und Informationsdesign

> **Hinweis zu diesem Kapitel:** Das ist das Kapitel des Skripts „Technische Dokumentation und Dokumentations-Governance“, aus der LaTeX-Quelle in Markdown umgewandelt (Text und Listings unverändert, farbige Boxen als Zitatblöcke mit fettem Titel, Tabellen als Markdown-Tabellen, Übungsaufgaben und Lösungen als Absätze). Die Lerneinheiten sind wie in der Quelle nach Modul nummeriert (3.1 bis 3.15), danach folgen „Übungsaufgaben“ (8 Aufgaben) und „Lösungen und Erläuterungen“. Die Sprachangabe der Codeblöcke ist in der Quelle nur für Python und Bash gesetzt; die übrigen Blöcke sind hier nach ihrem Inhalt als `python`, `yaml`, `markdown`, `bash` oder `text` ausgezeichnet, der Inhalt selbst ist unverändert. **Prüfstand der Beispiele für dieses Repository:** Die Python-Beispiele wurden auf Syntax geprüft; welche Beispiele ausgeführt wurden und welche zusätzlich PyYAML brauchen, steht in der [README des Repositories](../README.md). Übersicht zum Modul: [README](README.md).

**Dauer:** 15,5 Stunden | **Priorität:** 1 | **Lerneinheiten:** 15

| **Nr.** | **Lerneinheit**               | **Dauer (h)** | **Prio** |
|--------:|:------------------------------|--------------:|---------:|
|       1 | Strukturprinzipien            |             1 |        1 |
|       2 | Modulare Dokumentation        |             1 |        1 |
|       3 | Topic-based Writing           |             1 |        1 |
|       4 | Gliederung und Navigation     |             1 |        1 |
|       5 | Textverstaendlichkeit         |             1 |        1 |
|       6 | Abbildungen und Tabellen      |             1 |        2 |
|       7 | Wiederverwendung von Inhalten |             1 |        2 |
|       8 | Struktur-Troubleshooting      |             1 |        2 |
|       9 | Dokumentenarten               |          1,25 |        1 |
|      10 | Informationsarchitektur       |          1,25 |        1 |
|      11 | Taxonomie                     |             1 |        1 |
|      12 | Metadatenmodell               |             1 |        1 |
|      13 | Ablagestruktur                |             1 |        1 |
|      14 | Namenskonventionen            |             1 |        2 |
|      15 | Klassifikation                |             1 |        2 |
|         | **Summe**                     |      **15,5** |          |

## 3.1 Strukturprinzipien

Struktur ist der sichtbare Teil von Verständlichkeit. Ein technischer Text mit guter Struktur lässt sich überfliegen, gezielt durchsuchen und Stück für Stück erarbeiten; ein Text mit schlechter Struktur zwingt zum Lesen von vorn bis hinten. Dieses Kapitel beginnt mit den Grundprinzipien, nach denen einzelne Dokumente aufgebaut werden. Auf der Ebene darüber (Dokumentenbestand, Ablage, Taxonomie) folgen später die Abschnitte zur Informationsarchitektur.

Das wichtigste Prinzip ist die *Pyramidenstruktur* (auch „umgekehrte Pyramide“ genannt): Das Wichtigste steht zuerst, Details folgen. Ein Leser, der nach dem ersten Absatz aufhört, hat dann bereits das Wesentliche. In technischen Dokumenten bedeutet das: Zweck und Ergebnis vorn, Voraussetzungen vor den Schritten, Hintergrund und Sonderfälle am Ende. Das zweite Prinzip ist die *Hierarchie*: Überschriften bilden eine Ebenenstruktur, in der jede Ebene die darüberliegende konkretisiert. Das dritte ist die *Gleichförmigkeit*: Gleichartige Dokumente haben gleichartige Gliederungen, sodass Leser wissen, wo sie suchen müssen. Das vierte ist das *Prinzip der einen Funktion*: Jeder Abschnitt hat genau eine Aufgabe (erklären, anleiten oder nachschlagen). Das fünfte ist die *Chunking-Regel*: Informationen werden in überschaubare Einheiten zerlegt, die ohne Scrollen als Ganzes erfassbar sind.

Aus diesen Prinzipien folgt eine Mindeststruktur für nahezu jedes technische Dokument: Titel, Zweck und Zielgruppe, Voraussetzungen, Hauptteil, Ergebnis oder Prüfung, Verweise. Das folgende Beispiel zeigt diese Struktur als Markdown-Vorlage. Markdown ist eine einfache Auszeichnungssprache, in der Überschriften mit `#`-Zeichen gebildet werden.

```markdown
# Zertifikat des Webservers erneuern

**Zweck:** Dieses Dokument ermöglicht Administratoren, das TLS-Zertifikat
vor Ablauf zu erneuern.
**Owner:** Team Betrieb  **Stand:** 2026-10-28

## Voraussetzungen
- Zugriff auf den Server per SSH
- Neues Zertifikat liegt vor

## Schritte
1. Zertifikat nach /etc/ssl/certs/ kopieren.
2. Webserver neu laden: `systemctl reload nginx`.

## Prüfung
Aufruf der Seite im Browser; das Ablaufdatum zeigt das neue Datum.

## Siehe auch
- Runbook Rückfall auf altes Zertifikat
```

Die Vorlage folgt der Pyramide: Der Zweck steht direkt unter dem Titel, Voraussetzungen kommen vor den Schritten, und am Ende steht eine überprüfbare Erfolgskontrolle. Jede `##`-Überschrift trägt eine einzige Funktion. Auffällig ist das Fehlen von Fließtext zwischen den Abschnitten: In Anleitungen ist das richtig, in erklärenden Dokumenten würde man längere Absätze erwarten.

Ob eine Struktur tatsächlich sauber ist, lässt sich teilweise automatisch prüfen. Das nachstehende Skript meldet Überschriftenhierarchien, in denen Ebenen übersprungen werden (etwa von `#` direkt auf `###`), denn solche Sprünge verwirren Navigation und Screenreader.

```python
import re, sys

letzte = 0
ok = True
for nr, zeile in enumerate(open(sys.argv[1], encoding="utf-8"), 1):
    m = re.match(r"^(#{1,6}) ", zeile)
    if not m:
        continue
    ebene = len(m.group(1))
    if ebene > letzte + 1:
        print(f"Zeile {nr}: Sprung von Ebene {letzte} auf {ebene}")
        ok = False
    letzte = ebene
sys.exit(0 if ok else 1)
```

Das Skript merkt sich die Ebene der letzten Überschrift und vergleicht sie mit der aktuellen. Springt es um mehr als eine Ebene nach unten, wird die Zeile gemeldet. Der Ausdruck `#{1,6}` erfasst ein bis sechs Rautenzeichen und die Länge der Fundstelle entspricht der Ebene. Nach oben dürfen beliebige Sprünge erfolgen (von Ebene 4 zurück auf 2), nur nach unten muss jede Ebene vorkommen.

Typische Fehler: Überschriften werden aus optischen Gründen gewählt („die Schrift ist größer“) statt aus strukturellen; Ebenen werden übersprungen; Abschnitte vermischen Anleitung, Hintergrund und Referenz. Ein zweites Muster ist die „Mauer aus Text“: lange Absätze ohne Zwischenüberschrift, in denen Schritte untergehen.

| **Falsch**                                                                                                              | **Richtig**                                                                                             |
|:------------------------------------------------------------------------------------------------------------------------|:--------------------------------------------------------------------------------------------------------|
| „Konfiguration“ als Überschrift, darunter Hintergrund, 14 Schritte, Parametertabelle und Fehlerhinweise in einem Block. | Getrennte Abschnitte „Hintergrund“, „Schritte“, „Parameter“ und „Fehlerbehebung“ mit je einer Funktion. |

Im Projekt begegnet Struktur beim Review: Wenn Reviewer sagen „ich finde mich nicht zurecht“, liegt es fast immer an Hierarchie und Gleichförmigkeit, nicht an der Sprache.

## 3.2 Modulare Dokumentation

Klassische Dokumentation wird als Dokument geschrieben: ein Handbuch von Seite eins bis zum Ende, vielleicht mit hundert Seiten. Modulare Dokumentation dreht das um. Sie zerlegt Inhalte in kleine, in sich abgeschlossene *Module*, die für sich stehen und zu verschiedenen Dokumenten zusammengesetzt werden können. Der Vorteil ist, dass man jeden Baustein nur einmal schreibt und pflegt, aber in mehreren Zusammenhängen nutzt.

Ein Modul erfüllt drei Bedingungen. Es ist *in sich verständlich*: Es braucht keinen vorherigen Abschnitt, um gelesen zu werden, und verweist bei Bedarf per Link. Es ist *einfunktional*: Es erklärt, leitet an oder referenziert, aber nicht alles zugleich. Und es ist *kontextarm formuliert*: Es verwendet keine Formulierungen wie „wie oben beschrieben“ oder „im nächsten Kapitel“, denn die Reihenfolge kann sich je nach Zusammenstellung ändern. Mit anderen Worten: Ein Modul funktioniert, wenn man es mitten in einer Suche öffnet.

Die Zusammenstellung geschieht über eine *Kompositionsebene*, etwa eine Inhaltsliste (Map), die festlegt, welche Module in welcher Reihenfolge ein Dokument bilden. Dasselbe Modul „Zertifikat erneuern“ kann so im Betriebshandbuch, im Onboarding-Paket und im Notfallhandbuch auftauchen. Das folgende Beispiel zeigt einen sehr einfachen Mechanismus: Ein Skript fügt anhand von Platzhaltern der Form `@include dateiname` Module zu einem Gesamtdokument zusammen.

```markdown
# Betriebshandbuch Shop

@include module/zertifikat-erneuern.md
@include module/dienst-neustart.md
@include module/backup-pruefen.md
```

```python
import pathlib, re, sys

def baue(datei, tiefe=0):
    if tiefe > 5:
        raise RuntimeError("Zu tiefe Verschachtelung: " + datei)
    text = pathlib.Path(datei).read_text(encoding="utf-8")
    def ersetze(m):
        return baue(m.group(1), tiefe + 1)
    return re.sub(r"^@include (\S+)$", ersetze, text, flags=re.M)

print(baue(sys.argv[1]))
```

Das Skript liest die Hauptdatei und ersetzt jede Zeile, die mit `@include` beginnt, durch den Inhalt der genannten Datei. Weil die Funktion sich selbst aufruft (Rekursion), können Module wiederum andere Module einbinden. Die Tiefenbegrenzung schützt vor Endlosschleifen, falls zwei Dateien einander einbinden. Der Parameter `flags=re.M` bewirkt, dass `^` und `$` für jede Zeile gelten. In der Praxis nutzen Werkzeuge wie MkDocs, Sphinx oder AsciiDoc ähnliche, nur ausgereiftere Mechanismen.

Typische Fehler: Module sind zu klein (eine Zeile pro Datei, sodass der Zusammenhang verloren geht) oder zu groß (halbe Kapitel, die sich nicht mehr wiederverwenden lassen). Zudem enthalten sie versteckte Abhängigkeiten, etwa Bezüge auf frühere Schritte. Auch beliebt: Kopien statt Einbindungen, wodurch die Vorteile verloren gehen.

| **Falsch**                                                                   | **Richtig**                                                                                        |
|:-----------------------------------------------------------------------------|:---------------------------------------------------------------------------------------------------|
| Modul beginnt mit „Wie in Kapitel 3 beschrieben, nun der nächste Schritt...“ | Modul beginnt mit „Voraussetzung: Das Zertifikat liegt vor (siehe Modul *Zertifikat beantragen*).“ |

Im Projekt hilft Modularisierung vor allem dort, wo Teile für verschiedene Zielgruppen gebraucht werden: Handbuch für Betreiber, Kurzanleitung für Anwender, Audit-Auszug für Prüfer, alle aus denselben Modulen.

## 3.3 Topic-based Writing

Topic-based Writing ist die konsequente Umsetzung der Modulidee: Statt Kapitel und Fließtext zu schreiben, verfasst man *Topics*, abgeschlossene Informationseinheiten, die jeweils eine Frage des Lesers beantworten. Das Verfahren stammt aus der technischen Redaktion und ist in Standards wie DITA (Darwin Information Typing Architecture) formalisiert. Der Kerngedanke: Leser lesen nicht von vorn nach hinten, sondern gehen mit einer Frage in die Dokumentation, nehmen die passende Antwort und verlassen sie wieder.

Ein Topic hat einen *Informationstyp*. In DITA gibt es die Grundtypen Concept, Task und Reference. Ein *Concept* erklärt, was etwas ist und warum (Hintergrund). Ein *Task* beschreibt, wie man etwas tut (Schrittfolge). Eine *Reference* listet nachschlagbare Fakten (Tabellen, Parameter). Das entspricht in etwa den Diátaxis-Typen Erklärung, How-to und Referenz aus Modul 01; der Typ Tutorial hat in DITA keine eigene Entsprechung. Wichtig ist, dass jedes Topic nur einen Typ trägt, weil der Typ die Struktur bestimmt: Ein Task besteht aus Voraussetzungen, nummerierten Schritten und Ergebnis, eine Reference aus Tabellen, ein Concept aus erklärender Prosa mit Beispiel.

> **Ergänzung aus der Nachrecherche**
>
> DITA-Informationstypen (OASIS): Laut der abgerufenen OASIS-Architekturspezifikation nennt DITA als Basis-Topic-Typen ein generisches Topic sowie Concept, Task und Reference. Als Beispiele für typgerechte Strukturen werden einfache Schrittfolgen für Tasks und abrufoptimierte Strukturen wie Tabellen für Reference-Informationen genannt. Die Basistypen lassen sich zu neuen Typen spezialisieren. Die Seite stammt aus der Spezifikation 1.0; Details späterer Versionen können abweichen. (Abruf 28.10.2026, siehe Quellenverzeichnis.)

Das Schreiben in Topics folgt vier Regeln. Der *Titel* nennt die Frage oder das Ziel (bei Tasks mit einem Verb: „Zertifikat erneuern“, bei Concepts mit einem Substantiv: „Zertifikatsverwaltung“). Das Topic ist *eigenständig* und verweist über Links, nicht über Reihenfolge. Es *beginnt mit einem Kurzabsatz*, der Zweck und Ergebnis nennt. Und es *enthält nur seinen Typ*: Kein Task erklärt ausführlich den Hintergrund, er verlinkt auf das Concept. Das folgende Beispiel zeigt drei zusammengehörige Topics im Markdown-Format, wobei der Typ im Metadatenblock steht.

```markdown
---
typ: concept
titel: Zertifikatsverwaltung
---
TLS-Zertifikate belegen die Identität eines Servers und haben ein
Ablaufdatum. Läuft ein Zertifikat ab, melden Browser einen Fehler.
Siehe: Zertifikat erneuern, Zertifikatsparameter.

---
typ: task
titel: Zertifikat erneuern
---
Erneuern Sie das Zertifikat mindestens 14 Tage vor Ablauf.
1. Neues Zertifikat bereitstellen.
2. Webserver neu laden.
3. Ablaufdatum im Browser prüfen.

---
typ: reference
titel: Zertifikatsparameter
---
| Parameter | Wert    | Hinweis             |
|-----------|---------|---------------------|
| Laufzeit  | 90 Tage | automatisch erneuern |
| Schlüssel | RSA 4096 | oder ECDSA P-256   |
```

Die drei Topics zeigen den Aufbau: Das Concept erklärt kurz und verlinkt, der Task ist eine Folge nummerierter Schritte mit klarem Anlass in der ersten Zeile, die Reference ist eine Tabelle. Die Parameterwerte sind nur Beispielwerte. Obwohl die Topics zusammengehören, kann jedes einzeln gefunden und gelesen werden, und genau das ist der Zweck der Methode.

Typische Fehler: Topics, die mehrere Typen mischen, Titel ohne Handlungsbezug („Zertifikate“ statt „Zertifikat erneuern“) und Topics, die nur im Zusammenhang eines Kapitels verständlich sind. Besonders verbreitet ist, Tasks mit langen Erklärabsätzen zu überfrachten, sodass die Schritte im Text verschwinden.

| **Falsch**                                                                         | **Richtig**                                                                                                    |
|:-----------------------------------------------------------------------------------|:---------------------------------------------------------------------------------------------------------------|
| Task „Zertifikate“ mit drei Absätzen Geschichte der Verschlüsselung vor Schritt 1. | Task „Zertifikat erneuern“ mit Link auf das Concept „Zertifikatsverwaltung“ und sofort nummerierten Schritten. |

Im Projekt eignet sich Topic-based Writing besonders für Wissensdatenbanken und Betriebsdokumentation, weil Nutzer dort mit konkreten Fragen kommen. Es ist weniger geeignet für durchgängig zu lesende Texte wie Einführungen oder Konzeptpapiere.

## 3.4 Gliederung und Navigation

Gliederung und Navigation sind zwei Seiten einer Medaille. Die Gliederung legt fest, wie Inhalte *angeordnet* sind, die Navigation macht diese Anordnung für Leser *benutzbar*. Gute Navigation beantwortet drei Fragen: Wo bin ich? Was gibt es sonst noch? Wie komme ich dorthin? Dafür stehen verschiedene Mittel zur Verfügung.

Die *Gesamtnavigation* (Menü oder Seitenleiste) zeigt die oberste Gliederung. Das *Inhaltsverzeichnis* innerhalb eines Dokuments gibt einen Überblick über die Abschnitte. Die *Brotkrumennavigation* (Breadcrumbs) zeigt den Pfad vom Anfang zum aktuellen Dokument, zum Beispiel „Systeme \> Shop \> Runbooks \> Neustart“. *Querverweise* verbinden verwandte Inhalte, *Vor/Zurück-Links* führen durch Abläufe, und die *Suche* ergänzt alles, was die Struktur nicht abdeckt. Ein häufiger Irrtum ist die sogenannte „Drei-Klick-Regel“, nach der jede Information in drei Klicks erreichbar sein soll. Sie gilt als umstritten; entscheidend ist, dass jeder Klick erkennbar zum Ziel führt.

Die Tiefe der Gliederung soll sich an den Inhalten orientieren. Zu flache Gliederungen mit sechzig Einträgen auf einer Ebene überfordern, zu tiefe mit sieben Ebenen verstecken Inhalte. Als Faustregel gelten höchstens sieben bis neun Einträge pro Ebene und höchstens drei bis vier Ebenen; es sind Orientierungswerte, keine Gesetze. Das folgende Beispiel zeigt die Navigation einer Dokumentation in MkDocs, einem verbreiteten Generator für Dokumentationsseiten. Die Struktur steht in einer einzigen Datei, der Konfiguration.

```yaml
site_name: Betriebsdokumentation
nav:
  - Start: index.md
  - Systeme:
      - Shop:
          - Architektur: systeme/shop/architektur.md
          - Runbook Neustart: systeme/shop/runbook-neustart.md
      - Datenbank:
          - Wiederherstellung: systeme/db/restore.md
  - Prozesse:
      - Freigabe: prozesse/freigabe.md
```

Jeder Eintrag verbindet einen sichtbaren Namen mit einer Datei. Die Einrückung bildet die Hierarchie ab, und genau diese Hierarchie erscheint später als Seitenmenü und Brotkrumenpfad. Da die Struktur zentral an einer Stelle liegt, lässt sie sich leicht prüfen und überarbeiten. Das folgende Skript erzeugt aus den Überschriften eines Markdown-Dokuments ein Inhaltsverzeichnis, wie es viele Werkzeuge automatisch am Seitenrand anzeigen.

```python
import re, sys

for zeile in open(sys.argv[1], encoding="utf-8"):
    m = re.match(r"^(#{2,4}) (.+)", zeile)
    if m:
        einzug = "  " * (len(m.group(1)) - 2)
        print(f"{einzug}- {m.group(2).strip()}")
```

Das Skript liest die Überschriften der Ebenen zwei bis vier und rückt sie je nach Ebene ein. Ebene eins (der Titel) wird ausgelassen, da er das Dokument selbst bezeichnet. So entsteht ein Inhaltsverzeichnis, das automatisch aktuell bleibt, weil es aus dem Dokument selbst abgeleitet ist. Handgepflegte Verzeichnisse veralten dagegen unvermeidlich.

Typische Fehler: Navigation, die die Organisationsstruktur spiegelt, statt die Fragen der Leser; Verlinkungen, die ins Leere führen (tote Links); und Seiten, die von nirgends erreichbar sind (verwaiste Seiten). Auch tiefgeschachtelte Menüs mit missverständlichen Bezeichnungen („Allgemeines“, „Sonstiges“) führen in die Irre.

| **Falsch**                                       | **Richtig**                                                    |
|:-------------------------------------------------|:---------------------------------------------------------------|
| Menü: „Abteilung A“, „Abteilung B“, „Sonstiges“. | Menü: „Erste Schritte“, „Systeme“, „Prozesse“, „Nachschlagen“. |

Im Projekt lohnt sich ein Navigationstest: Man gibt Testpersonen eine Aufgabe („Finden Sie, wie man den Shop neu startet“) und beobachtet, wo sie zögern. Zögern ist der Messwert.

## 3.5 Textverständlichkeit

Verständlichkeit entsteht nicht aus Fachwissen, sondern aus Rücksicht auf den Leser. Technische Texte sind oft schwer verständlich, weil Experten über Dinge schreiben, die sie so gut kennen, dass sie nicht mehr merken, was erklärungsbedürftig ist. Dieses Phänomen heißt *Fluch des Wissens*. Textverständlichkeit bedeutet, diese Distanz bewusst zu überbrücken.

Die Verständlichkeitsforschung unterscheidet vier Dimensionen, die zum sogenannten Hamburger Verständlichkeitsmodell gehören: *Einfachheit* (kurze Sätze, vertraute Wörter), *Gliederung und Ordnung* (erkennbarer roter Faden), *Kürze und Prägnanz* (angemessene Länge) und *anregende Zusätze* (Beispiele, Bilder). Hinzu kommen Faustregeln für technische Texte: kurze Sätze (häufig werden etwa 15 bis 20 Wörter als Richtwert genannt), aktive statt passive Formulierungen, Verben statt Substantivierungen („prüfen“ statt „die Durchführung einer Prüfung“), eindeutige Bezüge („der Server“ statt „dieser“), und eine Information pro Satz. Die technische Schreibweise im engeren Sinn (Stilregeln, Handlungsanweisungen, Terminologie) wird in Modul 04 vertieft.

Verständlichkeit lässt sich zu einem Teil messen. Bekannt sind Lesbarkeitsindizes wie der Flesch-Index, der aus Satz- und Wortlängen einen Wert berechnet. Solche Indizes sind grobe Näherungen und sagen nichts über Inhalt oder Struktur aus, taugen aber als Frühwarnung. Das folgende Skript berechnet die mittlere Satzlänge und markiert Sätze, die länger als 25 Wörter sind.

```python
import re, sys

text = open(sys.argv[1], encoding="utf-8").read()
saetze = [s.strip() for s in re.split(r"(?<=[.!?])\s+", text) if s.strip()]
laengen = [len(s.split()) for s in saetze]

print(f"Sätze: {len(saetze)}, mittlere Länge: {sum(laengen)/len(laengen):.1f} Wörter")
for s, n in zip(saetze, laengen):
    if n > 25:
        print(f"LANG ({n}): {s[:60]}...")
```

Das Skript zerlegt den Text mit einem regulären Ausdruck an Satzzeichen, die von Leerraum gefolgt werden. Es zählt die Wörter pro Satz und gibt den Mittelwert aus. Sätze mit mehr als 25 Wörtern werden mit ihren ersten 60 Zeichen aufgelistet, sodass der Autor sie gezielt überarbeiten kann. Die Zerlegung ist einfach gehalten und erkennt beispielsweise Abkürzungen mit Punkt („z. B.“) falsch; in der Praxis lässt man solche Fälle bewusst zu oder pflegt eine Ausnahmeliste.

Typische Fehler: Schachtelsätze, Substantivketten („Systemzugriffsberechtigungsprüfung“), unklare Pronomen und unerklärte Abkürzungen. Ein verwandter Fehler ist das Gegenteil, nämlich Telegrammstil, der so verkürzt, dass wichtige Zusammenhänge fehlen.

| **Falsch**                                                                                                          | **Richtig**                                                      |
|:--------------------------------------------------------------------------------------------------------------------|:-----------------------------------------------------------------|
| „Die Durchführung der Überprüfung der Funktionsfähigkeit der Sicherung ist nach erfolgter Änderung zu veranlassen.“ | „Prüfen Sie nach jeder Änderung, ob die Sicherung funktioniert.“ |

Im Projekt zeigt sich Verständlichkeit an Rückfragen: Jede Frage, die ein Dokument auslöst, ist ein Hinweis auf eine Stelle, die der Autor überarbeiten sollte.

## 3.6 Abbildungen und Tabellen

Abbildungen und Tabellen sind Werkzeuge, mit denen sich Zusammenhänge verdichten lassen. Richtig eingesetzt, ersetzen sie Absätze; falsch eingesetzt, verwirren sie. Ihre Wahl folgt der Art der Information. Für *Strukturen und Beziehungen* (Architektur, Netz, Abläufe) eignen sich Diagramme (Details in Modul 09). Für *Vergleiche und Nachschlagewerte* (Parameter, Optionen) eignen sich Tabellen. Für *Bedienabläufe* können Bildschirmfotos helfen, sie veralten allerdings schnell, weshalb man sie sparsam einsetzen sollte. Für *Zahlenverläufe* eignen sich Diagramme mit Achsenbeschriftung.

Jede Abbildung und Tabelle braucht drei Dinge: eine *Beschriftung* (Titel, damit man im Text darauf verweisen kann), einen *Verweis* aus dem Text („siehe Abbildung 3“) und eine *Textalternative* für Menschen, die das Bild nicht sehen. Letztere ist keine Kür: Ein Screenreader liest nur Text vor, und ein Bild ohne Beschreibung wird für diese Nutzer unsichtbar.

> **Ergänzung aus der Nachrecherche**
>
> Textalternativen nach WCAG: Die Web Content Accessibility Guidelines verlangen im Erfolgskriterium 1.1.1 (Level A), dass Nicht-Text-Inhalte eine Textalternative erhalten, die denselben Zweck erfüllt; Ausnahmen gelten unter anderem für rein dekorative Inhalte. Laut der W3C-Erläuterung wird bei Diagrammen empfohlen, eine kurze Alternative mit einer langen Beschreibung zu kombinieren, die Diagrammtyp und Datenzusammenfassung nennt, und die Daten wo möglich zusätzlich als Tabelle bereitzustellen. Die Seite bezieht sich auf WCAG-Verständnisdokumente; die Anwendbarkeit auf interne Dokumentation hängt von Rechtslage und Auftrag ab (keine Rechtsberatung). (Abruf 28.10.2026, siehe Quellenverzeichnis.)

Das folgende Beispiel zeigt in Markdown eine Abbildung mit Alternativtext, Beschriftung und Textbeschreibung sowie eine Tabelle mit Überschriftenzeile. Darunter steht ein Skript, das Bilder ohne Alternativtext findet.

```text
![Architektur des Shops: Browser, Load Balancer, zwei Webserver,
eine Datenbank](bilder/architektur-shop.png)

*Abbildung 3: Architektur des Shops.* Der Load Balancer verteilt
Anfragen auf zwei Webserver, die dieselbe Datenbank nutzen.

| Parameter | Beschreibung      | Standardwert |
|-----------|-------------------|--------------|
| timeout   | Zeit bis Abbruch  | 30 Sekunden  |
```

```python
import pathlib, re, sys

for datei in pathlib.Path(sys.argv[1]).rglob("*.md"):
    for nr, zeile in enumerate(datei.read_text(encoding="utf-8").splitlines(), 1):
        for m in re.finditer(r"!\[(.*?)\]\(", zeile):
            if not m.group(1).strip():
                print(f"{datei}:{nr}: Bild ohne Alternativtext")
```

Die Markdown-Syntax für Bilder lautet `![Alternativtext](Pfad)`. Der Text in eckigen Klammern ist der Alternativtext, den Screenreader vorlesen. Im Beispiel beschreibt er, was das Bild zeigt, und die Beschriftung darunter ergänzt, was der Leser daraus ableiten soll. Das Skript sucht in allen Markdown-Dateien Bilder, deren eckige Klammern leer sind, und gibt Datei und Zeile aus. So lässt sich die Barrierefreiheit zumindest in diesem Punkt automatisch absichern.

Typische Fehler: Bilder ohne Beschriftung und ohne Bezug im Text, Alternativtexte wie „Bild1“ oder „Screenshot“, Tabellen ohne Kopfzeile und Bildschirmfotos mit nicht lesbarer Schrift. Auch das Einbetten von Text als Bild ist problematisch, weil der Text weder durchsuchbar noch vorlesbar ist.

| **Falsch** | **Richtig** |
|:-----------|:------------|
| `![Bild1](a.png)`   | `![Ablauf der Freigabe: Entwurf, Prüfung, Freigabe](freigabe.png)`    |

Im Projekt trägt diese Sorgfalt unmittelbar zur Auffindbarkeit bei: Ein beschriebenes Bild ist über die Suche auffindbar, ein unbeschriebenes nicht.

## 3.7 Wiederverwendung von Inhalten

Wiederverwendung (Content Reuse) heißt, denselben Inhalt in mehreren Dokumenten zu verwenden, ohne ihn zu kopieren. Sie ist die praktische Konsequenz aus dem Prinzip der einen Quelle der Wahrheit und eine Voraussetzung für Konsistenz: Sobald derselbe Warnhinweis oder dieselbe Parameterliste an zehn Stellen im Wortlaut steht, ist es nur eine Frage der Zeit, bis eine Stelle abweicht.

Es gibt mehrere Stufen der Wiederverwendung. Auf der untersten Stufe stehen *Variablen*: Einzelwerte wie Produktname, Versionsnummer oder Support-Adresse werden an einer Stelle definiert und überall eingesetzt. Darüber stehen *Textbausteine* (Snippets): Kurze, wiederkehrende Abschnitte wie Sicherheitshinweise oder Voraussetzungen. Die nächste Stufe bilden *Module oder Topics*, die ganze Abschnitte oder Seiten umfassen (siehe Abschnitte zur modularen Dokumentation und zu Topic-based Writing). Auf der obersten Stufe steht die *bedingte Ausgabe*: Derselbe Quelltext erzeugt je nach Zielgruppe oder Produktvariante unterschiedliche Ausgaben, indem Abschnitte ein- oder ausgeblendet werden.

Wiederverwendung hat Risiken. Zu viel davon erzeugt Dokumente, die in jeder Situation ein bisschen unpassend sind, weil Bausteine nicht auf den Kontext zugeschnitten sind. Ein gutes Maß ist, nur Inhalte wiederzuverwenden, die tatsächlich identisch bleiben sollen. Das folgende Beispiel zeigt eine einfache Variablenersetzung: Eine Datei definiert Werte, ein Skript setzt sie in Texte ein.

```yaml
produkt: ShopPlus
version: "4.2"
support: support@example.org
```

```python
import re, sys

werte = {}
for zeile in open("variablen.yml", encoding="utf-8"):
    if ":" in zeile:
        k, v = zeile.split(":", 1)
        werte[k.strip()] = v.strip().strip('"')

text = open(sys.argv[1], encoding="utf-8").read()
def ersetze(m):
    return werte.get(m.group(1), "{{" + m.group(1) + "}}")
print(re.sub(r"\{\{(\w+)\}\}", ersetze, text))
```

Die Datei `variablen.yml` enthält die zentral gepflegten Werte. Das Skript liest sie in ein Wörterbuch ein und ersetzt in einem beliebigen Text jeden Platzhalter der Form `{{name}}` durch den zugehörigen Wert. Unbekannte Platzhalter bleiben unverändert stehen, sodass Fehler sichtbar werden. Ein Text wie „Installieren Sie {{produkt}} {{version}}“ wird so zu „Installieren Sie ShopPlus 4.2“. Bei einem Versionssprung genügt die Änderung an einer Stelle.

Typische Fehler: Kopieren und Einfügen statt Einbinden; Wiederverwendung ohne klare Verantwortung für die Quelle (wer pflegt den Baustein?); Bausteine, die so allgemein sind, dass sie im Einzelfall falsch werden. Und: Wiederverwendung ohne Prüfung der Auswirkungen, denn eine Änderung am Baustein wirkt überall.

| **Falsch**                                                                                           | **Richtig**                                                                                    |
|:-----------------------------------------------------------------------------------------------------|:-----------------------------------------------------------------------------------------------|
| Der Warnhinweis zur Datensicherung ist in 12 Dokumenten als Kopie enthalten, in vier davon veraltet. | Der Warnhinweis liegt als Baustein vor, wird in 12 Dokumenten eingebunden und hat einen Owner. |

Im Projekt zahlt sich Wiederverwendung bei Releases aus: Statt zwanzig Dokumente nach einer Versionsänderung zu durchsuchen, ändert man eine Variable.

## 3.8 Struktur-Troubleshooting

Auch gut gegliederte Dokumente entwickeln Strukturprobleme, sobald viele Autoren daran arbeiten. Dieser Abschnitt zeigt, wie man Fehlerbilder anhand der Struktur, der Aktualität, des Zielgruppenfeedbacks und der Review-Kommentare eingrenzt und daraus Runbook-Schritte für Redaktion, Fachbereich und Betrieb ableitet.

Typische Fehlerbilder und ihre Ursachenfelder: „Ich finde mich nicht zurecht“ deutet auf eine fehlende oder inkonsistente Gliederung hin. „Das Dokument ist zu lang“ deutet auf mangelnde Modularisierung oder auf mehrere Funktionen in einem Dokument. „Dasselbe steht an drei Stellen verschieden“ deutet auf fehlende Wiederverwendung. „Die Seiten sind nicht verlinkt“ deutet auf eine schwache Navigation. „Die Anleitung ist nicht zu befolgen“ deutet auf vermischte Informationstypen. Die Aufgabe des Troubleshootings ist, das Symptom auf eine dieser Ursachen zurückzuführen, bevor man Änderungen vornimmt.

Ein Teil der Diagnose lässt sich messen. Das folgende Skript analysiert Markdown-Dokumente nach einigen strukturellen Auffälligkeiten: Länge, Anzahl Überschriften, längster Abschnitt ohne Zwischenüberschrift. Mit einer Auswertung dieser Art lassen sich Kandidaten für Überarbeitung gezielt auswählen.

```python
import pathlib, re, sys

for datei in sorted(pathlib.Path(sys.argv[1]).rglob("*.md")):
    zeilen = datei.read_text(encoding="utf-8").splitlines()
    ueberschriften = [i for i, z in enumerate(zeilen) if re.match(r"#{1,6} ", z)]
    grenzen = [0] + ueberschriften + [len(zeilen)]
    laengster = max(b - a for a, b in zip(grenzen, grenzen[1:]))
    hinweise = []
    if len(zeilen) > 300:
        hinweise.append("lang")
    if not ueberschriften:
        hinweise.append("keine Überschriften")
    if laengster > 60:
        hinweise.append(f"Abschnitt mit {laengster} Zeilen")
    if hinweise:
        print(datei, "->", ", ".join(hinweise))
```

Das Skript bestimmt die Zeilen, in denen Überschriften stehen, und berechnet daraus die Abstände zwischen aufeinanderfolgenden Überschriften. Der größte Abstand ist der längste Abschnitt ohne Gliederung. Die Schwellen (300 Zeilen, 60 Zeilen) sind Richtwerte, die man anpasst. Entscheidend ist die Folge: Die Ausgabe ist keine Bewertung, sondern eine Liste von Stellen, an denen man sich das Dokument ansehen sollte. Die Gegenprobe (zwei Nutzer fragen, wo sie hängen geblieben sind) bleibt unverzichtbar.

Als Runbook-Schritte für die Redaktion ergeben sich: Auffälligkeitsliste erzeugen (monatlich), Kandidaten mit Fachbereich besprechen, passende Maßnahme wählen (teilen, Überschriften ergänzen, Typen trennen, Bausteine auslagern), Änderung per Review freigeben und in der nächsten Auswertung prüfen, ob die Auffälligkeit verschwunden ist.

Typische Fehler beim Troubleshooting: Symptome mit Werkzeugen „beheben“, ohne die Ursache zu kennen (etwa ein neues Wiki einführen, um Strukturprobleme zu lösen, die aus fehlenden Regeln stammen), und das Ignorieren der Nutzer. Ebenso verbreitet ist das Überoptimieren, bei dem Dokumente, die niemand liest, aufwändig umgebaut werden.

| **Falsch**                                                    | **Richtig**                                                                                                                               |
|:--------------------------------------------------------------|:------------------------------------------------------------------------------------------------------------------------------------------|
| „Die Seite ist zu lang, wir kürzen sie auf eine halbe Seite.“ | „Die Seite enthält Hintergrund, Schritte und Parameter. Wir trennen sie in ein Concept, einen Task und eine Reference und verlinken sie.“ |

Im Projekt macht eine feste, kurze Strukturprüfung vor jeder Freigabe die meisten dieser Probleme sichtbar, bevor Leser davon betroffen sind.

## 3.9 Dokumentenarten

Nachdem Sie in Modul 01 die Leseabsichten (Tutorial, How-to, Referenz, Erklärung) kennengelernt haben, betrachten wir hier die *Dokumentenarten* als konkrete Bestandteile eines Dokumentenbestands. Eine Dokumentenart ist eine Kategorie von Dokumenten mit gleichem Zweck, gleichem Aufbau und gleichen Regeln für Prüfung und Pflege. Der Katalog der Dokumentenarten ist ein zentraler Baustein der Informationsarchitektur, denn er bestimmt, welche Vorlagen, Metadaten und Prüffristen gelten.

Ein praxistauglicher Katalog für IT-Organisationen enthält typischerweise folgende Arten. Das *Konzeptdokument* beschreibt Ziele, Lösungsansatz und Begründung einer Lösung. Die *Architekturdokumentation* zeigt Aufbau, Komponenten und Schnittstellen eines Systems. Die *Konfigurationsreferenz* listet Parameter und Einstellungen. Das *Runbook* beschreibt eine betriebliche Aufgabe in Schritten. Die *SOP* (Standard Operating Procedure) beschreibt einen standardisierten Arbeitsablauf verbindlich. Die *Richtlinie* legt verbindliche Regeln fest. Die *Architekturentscheidung* (ADR, Architecture Decision Record) hält fest, welche Entscheidung warum getroffen wurde. Das *Protokoll* dokumentiert Ereignisse, Tests oder Besprechungen. Die *Anleitung für Anwender* erklärt die Bedienung. Jede Art unterscheidet sich in Zielgruppe, Lebensdauer und Prüfintensität.

Um Konsistenz zu erreichen, braucht jede Art einen *Mindestinhalt* (Pflichtabschnitte). Das folgende Beispiel hält den Katalog als YAML fest und enthält ein Skript, das prüft, ob ein Dokument seiner Art entspricht. Die Pflichtabschnitte sind Beispiele, die jede Organisation selbst festlegt (Modul 07 vertieft dies).

```yaml
arten:
  runbook:
    pflicht: [Zweck, Voraussetzungen, Schritte, Prüfung, Eskalation]
    pruefung_monate: 6
  adr:
    pflicht: [Kontext, Entscheidung, Alternativen, Folgen]
    pruefung_monate: 24
  richtlinie:
    pflicht: [Zweck, Geltungsbereich, Regeln, Verantwortlichkeiten]
    pruefung_monate: 12
```

```python
import re, sys

PFLICHT = {
    "runbook": ["Zweck", "Voraussetzungen", "Schritte", "Prüfung", "Eskalation"],
    "adr": ["Kontext", "Entscheidung", "Alternativen", "Folgen"],
}

art, datei = sys.argv[1], sys.argv[2]
text = open(datei, encoding="utf-8").read()
vorhanden = set(re.findall(r"^## (.+)$", text, re.M))
fehlt = [p for p in PFLICHT[art] if p not in vorhanden]
print("Vollständig" if not fehlt else "Es fehlt: " + ", ".join(fehlt))
sys.exit(1 if fehlt else 0)
```

Der Katalog beschreibt für jede Art die Pflichtabschnitte und die Prüffrist. Das Skript liest alle Überschriften der Ebene zwei aus dem Dokument und vergleicht sie mit der Pflichtliste der angegebenen Art. Es wird mit der Art und dem Dateinamen aufgerufen, beispielsweise für ein Runbook. Damit ist die Art keine bloße Etikette, sondern hat prüfbare Folgen.

Typische Fehler: Es gibt zu viele Arten (30 Arten für 100 Dokumente), sodass niemand sie auseinanderhält, oder zu wenige, sodass alles „Konzept“ heißt. Ebenso schwierig sind Arten ohne klare Abgrenzung, etwa „Anleitung“, „Handbuch“ und „Dokumentation“ nebeneinander.

| **Falsch**                                     | **Richtig**                                                                            |
|:-----------------------------------------------|:---------------------------------------------------------------------------------------|
| Eine Dokumentenart „Allgemeine Dokumentation“. | Dokumentenarten mit eigener Vorlage: Runbook, ADR, Richtlinie, Konfigurationsreferenz. |

Im Projekt sollte jede neue Dokumentenart eine Begründung haben: Wozu braucht man sie, und warum passt keine bestehende? So bleibt der Katalog überschaubar.

## 3.10 Informationsarchitektur

Der Begriff wurde in Modul 01 eingeführt. Hier betrachten wir ihn methodisch. Die Informationsarchitektur (IA) strukturiert nicht ein einzelnes Dokument, sondern den *gesamten Bestand*: Welche Inhalte gibt es, wie werden sie gruppiert, wie benannt, wie verbunden und wie gefunden? Eine häufig zitierte Gliederung unterscheidet vier Komponenten: *Organisationssysteme* (wie Inhalte gruppiert werden), *Beschriftungssysteme* (wie Gruppen und Inhalte heißen), *Navigationssysteme* (wie man durch die Inhalte gelangt) und *Suchsysteme* (wie man gezielt sucht). Die Unterabschnitte dieses Moduls (Taxonomie, Metadaten, Ablage, Namenskonventionen, Klassifikation) sind jeweils ein Teil davon.

Für die Organisation gibt es mehrere bewährte Schemata. Nach *Thema* (alles zum Shop zusammen), nach *Aufgabe* (alles zum Neustart), nach *Zielgruppe* (alles für Administratoren), nach *Dokumentenart* (alle Runbooks) oder nach *Lebenszyklusphase* (Entwurf, Gültig, Archiv). Die Praxis zeigt, dass kein Schema allein genügt. Deshalb nutzt man *facettierte Klassifikation*: Jedes Dokument trägt mehrere unabhängige Merkmale (Facetten), etwa System, Dokumentenart, Zielgruppe und Status, und kann nach jedem davon gefiltert werden. Die physische Ablage folgt dann einem Hauptmerkmal, die anderen Merkmale stehen als Metadaten.

Wie prüft man, ob eine Informationsarchitektur funktioniert? Zwei Methoden sind verbreitet. Beim *Card Sorting* bekommen Testpersonen Karten mit Inhaltstiteln und sollen sie so gruppieren, wie es für sie sinnvoll ist; die Gruppierungen zeigen, wie Nutzer denken. Beim *Tree Testing* bekommen sie die geplante Struktur als Text-Baum und sollen darin Aufgaben lösen; so zeigt sich, ob die Struktur ohne Gestaltung funktioniert. Beide Verfahren sind einfach, günstig und liefern belastbarere Erkenntnisse als Meinungen.

Das folgende Skript wertet ein kleines Card-Sorting-Ergebnis aus: Mehrere Testpersonen haben Karten gruppiert, und das Skript zählt, wie oft zwei Karten gemeinsam einer Gruppe zugeordnet wurden. Hohe Werte zeigen Inhalte, die Nutzer zusammengehörig finden.

```python
from itertools import combinations
from collections import Counter

sortierungen = [
    [["Neustart", "Backup", "Monitoring"], ["Freigabe", "Review"]],
    [["Neustart", "Monitoring"], ["Backup", "Freigabe", "Review"]],
    [["Neustart", "Backup", "Monitoring"], ["Freigabe"], ["Review"]],
]

paare = Counter()
for person in sortierungen:
    for gruppe in person:
        for a, b in combinations(sorted(gruppe), 2):
            paare[(a, b)] += 1

for (a, b), n in paare.most_common():
    print(f"{a} + {b}: {n} von {len(sortierungen)}")
```

Jede Sortierung besteht aus Gruppen von Karten. Das Skript bildet innerhalb jeder Gruppe alle Paare (`combinations`) und zählt, wie oft jedes Paar vorkommt. Die Ausgabe zeigt, dass „Monitoring“ und „Neustart“ in allen drei Sortierungen zusammenstanden, während „Backup“ mal bei ihnen, mal bei der Freigabe landete. Solche Uneinigkeit ist ein Hinweis auf Begriffe, die Nutzer unterschiedlich verstehen und die man besonders eindeutig benennen sollte.

Typische Fehler: Die Struktur wird aus der Sicht der Ersteller entworfen, nicht der Leser; sie wird nie getestet; und sie wird nach der Einführung nicht mehr angepasst, obwohl sich Systeme, Teams und Begriffe ändern. Auch typisch: eine einzelne Hierarchie für alles, die zu Dopplungen führt.

| **Falsch**                                                                                     | **Richtig**                                                                                |
|:-----------------------------------------------------------------------------------------------|:-------------------------------------------------------------------------------------------|
| Gliederung nach Abteilungen: „IT“, „Entwicklung“, „Support“, in jeder eigene Backup-Anleitung. | Gliederung nach Gegenstand (System, Prozess) mit Filter nach Zielgruppe und Dokumentenart. |

Im Projekt ist die IA besonders bei Migrationen kritisch: Wer ein altes Wiki unverändert in ein neues Werkzeug überträgt, überträgt die alten Strukturprobleme gleich mit.

## 3.11 Taxonomie

Eine *Taxonomie* ist ein kontrolliertes, hierarchisches Begriffssystem, das beschreibt, welche Begriffe zur Beschreibung von Inhalten zulässig sind und wie sie zueinander stehen. Sie ist das Vokabular der Informationsarchitektur. Ohne Taxonomie vergibt jeder Autor Schlagworte nach eigenem Gutdünken: Der eine schreibt „Backup“, die andere „Datensicherung“, ein Dritter „Sicherung“. Die Suche liefert dann nur einen Teil der Treffer.

Eine gute Taxonomie hat vier Eigenschaften. Sie ist *kontrolliert*: Nur festgelegte Begriffe sind erlaubt. Sie ist *hierarchisch*: Begriffe haben Ober- und Unterbegriffe (etwa „Infrastruktur“ mit „Netzwerk“ und „Server“). Sie kennt *Synonyme*: Alternative Bezeichnungen verweisen auf den bevorzugten Begriff. Und sie ist *gepflegt*: Es gibt einen Verantwortlichen und ein Verfahren, um neue Begriffe aufzunehmen. Davon zu unterscheiden ist die *Folksonomie*, bei der Nutzer frei Tags vergeben. Sie ist flexibel und spiegelt den Sprachgebrauch, liefert aber uneinheitliche Ergebnisse. Viele Organisationen kombinieren beides: eine kontrollierte Taxonomie für Kernbegriffe und freie Tags für Ergänzungen.

Das folgende Beispiel zeigt eine Taxonomie als YAML mit Oberbegriffen, Unterbegriffen und Synonymen. Daneben steht ein Skript, das Schlagworte eines Dokuments gegen die Taxonomie prüft und Synonyme automatisch auf den bevorzugten Begriff abbildet.

```yaml
begriffe:
  datensicherung:
    label: Datensicherung
    synonyme: [Backup, Sicherung]
    unterbegriffe: [wiederherstellung]
  wiederherstellung:
    label: Wiederherstellung
    synonyme: [Restore, Recovery]
  netzwerk:
    label: Netzwerk
    synonyme: [Network, LAN]
```

```python
import sys

TAX = {
    "datensicherung": ["Backup", "Sicherung"],
    "wiederherstellung": ["Restore", "Recovery"],
    "netzwerk": ["Network", "LAN"],
}
index = {}
for schluessel, syn in TAX.items():
    index[schluessel] = schluessel
    for s in syn:
        index[s.lower()] = schluessel

for tag in sys.argv[1:]:
    treffer = index.get(tag.lower())
    if treffer:
        print(f"{tag} -> {treffer}")
    else:
        print(f"{tag} -> UNBEKANNT (Aufnahme beantragen)")
```

Das Skript baut aus der Taxonomie ein Suchverzeichnis, in dem jedes Synonym (kleingeschrieben) auf den bevorzugten Begriff verweist. Beim Aufruf mit Schlagworten werden diese auf den Schlüssel abgebildet oder als unbekannt gemeldet. Das entspricht dem Prinzip einer Autovervollständigung im Wiki: Nutzer geben „Backup“ ein und landen auf „Datensicherung“. Die Meldung „Aufnahme beantragen“ verweist auf das nötige Pflegeverfahren.

Typische Fehler: Zu tiefe Hierarchien, die niemand überblickt; Begriffe, die zu allgemein sind („Sonstiges“); und fehlende Pflege, sodass die Taxonomie mit der Fachsprache nicht mehr übereinstimmt. Auch problematisch: Eine Taxonomie, die in einem Workshop entworfen und nie angewendet wird.

| **Falsch**                                                              | **Richtig**                                                                          |
|:------------------------------------------------------------------------|:-------------------------------------------------------------------------------------|
| Tags im Wiki: „backup“, „Backup“, „Datensicherung“, „sicherung“, „bkp“. | Ein bevorzugter Begriff „Datensicherung“ mit den Synonymen „Backup“ und „Sicherung“. |

Im Projekt ist ein kleiner Kern (zwanzig bis fünfzig Begriffe) meist besser als ein großes Begriffsgebäude. Die Taxonomie wächst mit dem Bedarf.

## 3.12 Metadatenmodell

Metadaten sind Daten über Dokumente: Wer ist der Owner, welchen Status hat das Dokument, zu welchem System gehört es? Das *Metadatenmodell* legt fest, welche Metadatenfelder es gibt, welche davon Pflicht sind, welche Werte zulässig sind und wo sie gespeichert werden. Es verbindet Informationsarchitektur und Governance, denn viele Regeln (Prüffristen, Zugriffsrechte, Archivierung) wirken über Metadaten.

Man unterscheidet *beschreibende Metadaten* (Titel, Schlagworte, Zusammenfassung), *administrative Metadaten* (Owner, Status, Version, Prüfdatum), *strukturelle Metadaten* (Beziehung zu anderen Dokumenten, Reihenfolge) und *Schutz-Metadaten* (Vertraulichkeitsstufe, Aufbewahrungsfrist). Die Faustregel für den Umfang lautet: so wenig wie möglich, so viel wie nötig. Jedes Pflichtfeld verursacht Aufwand beim Schreiben und fehlerhafte Eingaben, wenn es nicht sinnvoll ist. Ein bewährter Kern sind fünf bis acht Pflichtfelder.

Metadaten müssen *validierbar* sein. Dazu legt man für jedes Feld Typ, Pflicht und zulässige Werte fest. Das folgende Beispiel zeigt ein solches Modell als JSON-Schema-ähnliche Beschreibung und ein Skript, das einen Metadatenblock dagegen prüft.

```text
felder = {
  titel:        Text, Pflicht
  art:          runbook | adr | richtlinie | konzept, Pflicht
  system:       Text, Pflicht
  owner:        Text, Pflicht
  status:       entwurf | in_pruefung | freigegeben | archiviert, Pflicht
  stand:        Datum JJJJ-MM-TT, Pflicht
  vertraulich:  oeffentlich | intern | vertraulich, Pflicht
  tags:         Liste aus Taxonomie, optional
}
```

```python
import re
from datetime import date

MODELL = {
    "art": {"runbook", "adr", "richtlinie", "konzept"},
    "status": {"entwurf", "in_pruefung", "freigegeben", "archiviert"},
    "vertraulich": {"oeffentlich", "intern", "vertraulich"},
}
PFLICHT = ["titel", "art", "system", "owner", "status", "stand", "vertraulich"]

def validiere(meta):
    fehler = [f"{p} fehlt" for p in PFLICHT if not meta.get(p)]
    for feld, erlaubt in MODELL.items():
        if meta.get(feld) and meta[feld] not in erlaubt:
            fehler.append(f"{feld}: '{meta[feld]}' nicht erlaubt")
    if meta.get("stand"):
        try:
            date.fromisoformat(meta["stand"])
        except ValueError:
            fehler.append("stand: kein gültiges Datum")
    return fehler

print(validiere({"titel": "Neustart", "art": "runbook", "system": "shop",
                 "owner": "Team A", "status": "fertig", "stand": "2026-13-01"}))
```

Das Modell hält in einer Beschreibung fest, welche Felder es gibt und welche Werte zulässig sind. Das Skript prüft drei Dinge: ob jedes Pflichtfeld belegt ist, ob Felder mit festen Wertelisten nur erlaubte Werte enthalten, und ob das Datum ein echtes Kalenderdatum ist. Der Beispielaufruf am Ende meldet, dass der Vertraulichkeitswert fehlt, dass der Status „fertig“ nicht erlaubt ist und dass „2026-13-01“ kein gültiges Datum ist. Entscheidend ist, dass die Regeln zentral formuliert sind und sich damit auch maschinell durchsetzen lassen.

Typische Fehler: zu viele Pflichtfelder, sodass Autoren sinnlose Werte eintragen („n/a“), Metadaten, die nur im Dokument stehen und nicht durchsuchbar sind, und Freitextfelder dort, wo Werte aus einer Liste stehen sollten. Wichtig ist auch, dass Metadaten gepflegt werden: Ein falscher Owner ist schlimmer als gar keiner.

| **Falsch**                                                                  | **Richtig**                                                                |
|:----------------------------------------------------------------------------|:---------------------------------------------------------------------------|
| Metadaten: „Status: fast fertig; Ansprechpartner: der Chef; Datum: neulich“ | Metadaten: „status: in_pruefung; owner: Team Plattform; stand: 2026-10-28“ |

Im Projekt entscheidet das Metadatenmodell, welche Auswertungen später möglich sind: Wer keinen Owner erfasst, kann nie sagen, wie viele Dokumente ohne Verantwortlichen existieren.

## 3.13 Ablagestruktur

Die *Ablagestruktur* beschreibt, wo Dokumente physisch liegen: Ordner, Bereiche, Repositories, Wikis. Sie ist der sichtbarste Teil der Informationsarchitektur und der, der am schnellsten außer Kontrolle gerät. Eine tragfähige Ablagestruktur folgt wenigen Grundsätzen. Sie orientiert sich am *Gegenstand* (System, Prozess), nicht an der Organisation. Sie hat *wenige Ebenen* (drei bis vier). Sie wiederholt dasselbe Muster, damit gleiche Dinge gleich liegen. Und sie hat klare *Grenzen für Berechtigungen*, denn Zugriffsrechte werden meist an Ordnern oder Bereichen vergeben.

Neben der Struktur muss festgelegt sein, *welcher Ablageort wofür* gilt. Typisch ist eine Aufteilung nach Werkzeug: Technische Dokumentation nah am Code im Git-Repository, Prozessdokumentation im Wiki oder Dokumentenmanagementsystem, Verträge und freigegebene Nachweise im DMS, Entwürfe und Arbeitsmaterial in Teamablagen. Die Verteilung auf mehrere Orte ist vertretbar, solange die Regel eindeutig ist. Gefährlich ist die Doppelablage, also dasselbe Dokument an zwei Orten. Plattformen im Einzelnen behandelt Modul 12.

Zur Anlage einer wiederholbaren Struktur eignet sich ein Skript, das Ordner für ein neues System erzeugt und dabei die Ablagestruktur durchsetzt. So sehen alle Systeme gleich aus.

```python
import pathlib, sys

system = sys.argv[1]
basis = pathlib.Path("doku/10-systeme") / system
VORLAGEN = {
    "architektur.md": "# Architektur " + system + "\n",
    "konfiguration-referenz.md": "# Konfiguration " + system + "\n",
    "runbook-neustart.md": "# Runbook Neustart " + system + "\n",
}

basis.mkdir(parents=True, exist_ok=True)
for name, inhalt in VORLAGEN.items():
    ziel = basis / name
    if ziel.exists():
        print("Vorhanden:", ziel)
    else:
        ziel.write_text(inhalt, encoding="utf-8")
        print("Angelegt: ", ziel)
```

Das Skript nimmt den Systemnamen als Parameter, bildet den Pfad `doku/10-systeme/<System>` und legt dort drei Dateien an. Mit `mkdir(parents=True, exist_ok=True)` werden fehlende Zwischenordner erzeugt, und bereits vorhandene Ordner führen nicht zu Fehlern. Bereits vorhandene Dateien werden nicht überschrieben, sondern nur gemeldet. Das Skript zeigt, wie sich eine Ablageregel (jedes System hat dieselben drei Dokumente) in ein Werkzeug gießen lässt.

Typische Fehler: Strukturen, die die Organisation abbilden und mit jeder Umorganisation veralten; zu tiefe Verschachtelung; „Sonstiges“ und „Neu“ als Dauerordner; Archive, die nicht vom aktiven Bestand getrennt sind; Berechtigungen, die Ordner für alle öffnen „damit es einfacher ist“.

| **Falsch** | **Richtig** |
|:-----------|:------------|
| `Dokumente/Abteilung IT/Team Süd/2024/Projekte/Neu/Altes/Doku.docx`   | `doku/10-systeme/shop/runbook-neustart.md`    |

Im Projekt zeigt sich die Qualität der Ablage am Onboarding: Wenn neue Mitarbeitende nach einer Stunde wissen, wo was liegt, funktioniert sie.

## 3.14 Namenskonventionen

Namenskonventionen legen fest, wie Dateien, Ordner und Dokumente benannt werden. Das wirkt banal, ist aber ein starker Hebel: Gute Namen machen Inhalte auffindbar, sortierbar und maschinell verarbeitbar, schlechte Namen erzeugen Chaos („final_neu_2_korrigiert.docx“). Eine Namenskonvention ist eine kleine, gemeinsame Regel, an die sich alle halten.

Gute Konventionen erfüllen fünf Kriterien. Sie sind *sprechend*: Der Name verrät Art und Inhalt. Sie sind *einheitlich*: Gleiche Dinge werden gleich benannt. Sie sind *sortierbar*: Die wichtigste Information steht vorn, Daten im Format JJJJ-MM-TT (ISO 8601), damit alphabetische Sortierung der zeitlichen Reihenfolge entspricht. Sie sind *technisch robust*: keine Leerzeichen und Sonderzeichen, die Skripte, Webadressen oder Betriebssysteme stören (Umlaute, Doppelpunkte, Schrägstriche). Und sie sind *kurz genug*, dass Pfade die Längenbeschränkungen einhalten. Ein Beispiel für eine Regel: `<art>-<system>-<thema>.md`, alles klein, Wörter mit Bindestrich, Version nicht im Namen, sondern in der Versionskontrolle. Die Version gehört nicht in den Dateinamen, wenn eine Versionsverwaltung existiert; sonst entstehen Kopien.

Eine Konvention nützt nur, wenn sie überprüft wird. Das folgende Skript validiert Dateinamen mit einem regulären Ausdruck, der die Regel abbildet.

```python
import pathlib, re, sys

ARTEN = "runbook|adr|richtlinie|konzept|referenz"
MUSTER = re.compile(rf"^({ARTEN})-[a-z0-9]+(-[a-z0-9]+)*\.md$")

fehler = 0
for datei in pathlib.Path(sys.argv[1]).rglob("*.md"):
    if datei.name in ("README.md", "index.md"):
        continue
    if not MUSTER.match(datei.name):
        print("Verstößt gegen Konvention:", datei.name)
        fehler += 1
print(fehler, "Verstoß/Verstöße")
sys.exit(1 if fehler else 0)
```

Der Ausdruck verlangt, dass der Name mit einer zulässigen Art beginnt, gefolgt von einem Bindestrich und beliebig vielen Wortteilen aus Kleinbuchstaben und Ziffern, getrennt durch Bindestriche, und dass er auf `.md` endet. Dadurch fallen Namen wie `Anleitung Neu (2).md` sofort durch. Bestimmte Dateien (`README.md`, `index.md`) sind ausdrücklich ausgenommen, weil Werkzeuge sie erwarten. Das Prinzip: Jede Namensregel wird so formuliert, dass sie sich maschinell prüfen lässt.

Typische Fehler: Zu strenge Regeln, die niemand befolgt; zu lockere, die nichts bewirken; Versionsnummern und Statuswörter im Namen („final“, „v3“); sowie Dateinamen, die nur mit der Ordnerstruktur verständlich sind („Anleitung.docx“). Die Namensregel sollte als Beispiel mit richtigen und falschen Namen in der Governance-Kurzfassung stehen.

| **Falsch** | **Richtig**                                                        |
|:-----------|:-------------------------------------------------------------------|
| `Anleitung neu final v3 (korrigiert).docx`   | `runbook-shop-neustart.md` (Version und Status stehen in Metadaten und Git-Historie) |

Im Projekt lohnt es sich, die Konvention gemeinsam mit den Autoren zu entwerfen. Eine Regel, die Autoren verstehen und für sinnvoll halten, wird auch befolgt.

## 3.15 Klassifikation

Mit Klassifikation ordnet man Dokumente anhand festgelegter Merkmale in Klassen ein. In der Informationsarchitektur dient sie dazu, Dokumente systematisch zu beschreiben und zu verwalten. Im Alltag begegnen Ihnen vor allem zwei Klassifikationsachsen. Die erste ist die *inhaltliche Klassifikation*: Zu welcher Dokumentenart, zu welchem System, zu welchem Thema gehört das Dokument? Sie wurde in den Abschnitten zu Dokumentenarten und Taxonomie behandelt. Die zweite ist die *Schutzklassifikation*: Wie schutzbedürftig sind die Informationen darin? Sie bestimmt Zugriffsrechte, Weitergabe und Aufbewahrung.

Die Schutzklassifikation arbeitet meist mit wenigen Stufen, häufig drei bis vier: etwa *öffentlich*, *intern*, *vertraulich* und *streng vertraulich*. Jede Stufe ist mit Regeln verknüpft: Wer darf lesen, darf das Dokument das Unternehmen verlassen, muss es verschlüsselt abgelegt werden? Die Einstufung nimmt in der Regel der Owner vor, die Regeln legt die Informationssicherheit fest. Die inhaltliche Vertiefung zu Informationsklassifizierung, Geheimnissen und Datenschutz folgt in Modul 13; hier geht es um die Rolle der Klassifikation in der Informationsarchitektur.

Wichtig ist, dass Klassifikation das Ablageverhalten steuert: Ein vertrauliches Dokument darf nicht in einem offenen Bereich liegen. Das folgende Beispiel zeigt eine Regeltabelle und ein Skript, das prüft, ob die Vertraulichkeitsstufe eines Dokuments zum Ablageort passt. Die Abbildung von Stufen auf Orte ist ein Beispiel und von der Organisation festzulegen.

```yaml
bereiche:
  doku/public:    [oeffentlich]
  doku/intern:    [oeffentlich, intern]
  doku/vertraulich: [oeffentlich, intern, vertraulich]
```

```python
import re, sys

ERLAUBT = {
    "doku/public": {"oeffentlich"},
    "doku/intern": {"oeffentlich", "intern"},
    "doku/vertraulich": {"oeffentlich", "intern", "vertraulich"},
}

pfad = sys.argv[1]
text = open(pfad, encoding="utf-8").read()
m = re.search(r"^vertraulich: (\w+)", text, re.M)
stufe = m.group(1) if m else None

bereich = next((b for b in ERLAUBT if pfad.startswith(b)), None)
if stufe is None:
    print("Keine Vertraulichkeitsstufe angegeben")
    sys.exit(1)
if bereich and stufe not in ERLAUBT[bereich]:
    print(f"'{stufe}' darf nicht in {bereich} liegen")
    sys.exit(1)
print("Einstufung passt zum Ablageort")
```

Die Tabelle legt fest, welche Stufen in welchem Bereich liegen dürfen, wobei ein höher geschützter Bereich auch niedrigere Stufen aufnehmen darf. Das Skript liest die Stufe aus dem Metadatenfeld `vertraulich` und bestimmt, in welchem Bereich das Dokument liegt. Es meldet, wenn die Stufe fehlt oder zum Ablageort nicht passt. Damit wird die Klassifikation nicht nur dokumentiert, sondern kontrolliert.

Typische Fehler: Zu viele Stufen, bei denen niemand mehr weiß, welche gilt; fehlende Einstufung (alles „intern“ aus Bequemlichkeit); und Einstufungen, die nicht zu den tatsächlichen Zugriffsrechten passen. Auch verbreitet: Einmal eingestufte Dokumente werden nie neu bewertet, obwohl sich der Inhalt ändert.

| **Falsch**                                                                               | **Richtig**                                                                                                                        |
|:-----------------------------------------------------------------------------------------|:-----------------------------------------------------------------------------------------------------------------------------------|
| Dokument mit Kundendaten liegt ohne Einstufung im Teamlaufwerk, das für alle lesbar ist. | Dokument ist als „vertraulich“ eingestuft und liegt im Bereich mit eingeschränktem Zugriff, Klassifikation steht in den Metadaten. |

Im Projekt macht eine saubere Klassifikation spätere Audits einfacher: Prüfer erwarten, dass erkennbar ist, welche Dokumente wie geschützt sind und warum.

## Übungsaufgaben

Die Aufgaben steigen von Verständnisfragen (1 bis 3) über Anwendungsaufgaben (4 bis 6) bis zu Entwurfs- und Programmieraufgaben (7 und 8) an. Lösen Sie sie zuerst ohne die Lösungen.

**Aufgabe 1.** *(leicht)* Nennen Sie die fünf Strukturprinzipien und erklären Sie das Prinzip der umgekehrten Pyramide an einem Beispiel aus der Betriebsdokumentation.

**Aufgabe 2.** *(leicht)* Woran erkennt man, dass ein Modul wirklich eigenständig ist? Nennen Sie drei Prüffragen und eine Formulierung, die ein Modul unbrauchbar für die Wiederverwendung macht.

**Aufgabe 3.** *(leicht bis mittel)* Ordnen Sie die folgenden Topic-Titel dem Typ Concept, Task oder Reference zu und verbessern Sie die Titel, die schlecht gewählt sind: (a) „Backups“, (b) „Backup einrichten“, (c) „Konfigurationsparameter der Sicherung“, (d) „Warum wir inkrementell sichern“.

**Aufgabe 4.** *(mittel)* Schreiben Sie für zwei selbst gewählte Dokumente einen Alternativtext und eine Bildbeschriftung für ein Architekturdiagramm und für ein Balkendiagramm mit Störungszahlen pro Quartal. Orientieren Sie sich an den Hinweisen aus der Nachrecherche.

**Aufgabe 5.** *(mittel)* Entwerfen Sie eine Ablagestruktur (Verzeichnisbaum, maximal 3 Ebenen) für ein Team mit drei Systemen und zwei Prozessen. Begründen Sie die Wahl des ersten Ordnungsmerkmals.

**Aufgabe 6.** *(mittel, praktisch)* Schreiben Sie ein Skript, das alle Markdown-Dateien eines Verzeichnisses findet, deren Name nicht der Konvention `art-system-thema.md` folgt (Kleinbuchstaben, Bindestriche) und die Zahl der Verstöße ausgibt.

**Aufgabe 7.** *(anspruchsvoll, praktisch)* Erweitern Sie das Metadaten-Validierungsskript um zwei Regeln: Das Feld `stand` darf nicht in der Zukunft liegen, und bei `status: freigegeben` muss ein Feld `reviewer` belegt sein.

**Aufgabe 8.** *(anspruchsvoll, Transfer)* Ein Wiki mit 400 Seiten soll neu strukturiert werden. Entwerfen Sie ein Vorgehen mit Bestandsaufnahme, Card Sorting, Taxonomie, Metadatenmodell und Migration. Nennen Sie je Schritt ein Ergebnis und ein Risiko.

## Lösungen und Erläuterungen

**Lösung zu Aufgabe 1.** Die Prinzipien sind Pyramidenstruktur, Hierarchie, Gleichförmigkeit, eine Funktion pro Abschnitt und Chunking. Beispiel zur Pyramide: Ein Runbook „Dienst neu starten“ beginnt mit dem Zweck und dem Ergebnis („Nach dem Neustart ist der Dienst erreichbar“), nennt dann die Voraussetzungen und die Schritte und erst am Ende Hintergrund und Sonderfälle. Wer nach dem ersten Absatz aufhört, weiß wenigstens, ob er im richtigen Dokument ist.

**Lösung zu Aufgabe 2.** Prüffragen: Ist das Modul ohne Kontext verständlich? Hat es genau eine Funktion? Ist es frei von Bezügen auf Reihenfolge oder andere Abschnitte? Unbrauchbar machen etwa Formulierungen wie „wie oben beschrieben“, „im nächsten Kapitel“ oder „nun der zweite Schritt“, weil die Reihenfolge in anderen Zusammenstellungen nicht stimmt. Die Alternative ist, Bezüge über Links auszudrücken, die auch in anderem Kontext gültig bleiben.

**Lösung zu Aufgabe 3.** (a) „Backups“ ist unklar; als Concept besser „Datensicherungskonzept“. (b) Task, Titel ist gut, da er mit einem Verb das Ziel nennt. (c) Reference, Titel gut. (d) Concept, Titel gut, weil er die Frage des Lesers benennt. Entscheidend ist, dass der Titel den Typ erkennen lässt: Verb bei Tasks, Substantiv oder Frage bei Concepts, „Parameter“ oder „Referenz“ bei References.

**Lösung zu Aufgabe 4.** Eine mögliche Lösung für das Architekturdiagramm: Alternativtext „Architektur des Shops: Browser greift über Load Balancer auf zwei Webserver zu, die dieselbe Datenbank nutzen“; Beschriftung „Abbildung 1: Architektur des Shops“ mit einem Satz im Text, der die Funktion des Load Balancers erklärt. Für das Balkendiagramm: Alternativtext „Balkendiagramm: Störungen pro Quartal, Tendenz fallend“ und eine längere Beschreibung mit Diagrammtyp und Datenzusammenfassung (etwa „Im ersten Quartal 14, im vierten Quartal 5 Störungen“ als frei erfundene Beispielzahlen), zusätzlich möglichst die Daten als Tabelle, wie es die W3C-Erläuterung zu WCAG 1.1.1 empfiehlt. Typischer Fehler: der Alternativtext wiederholt nur den Dateinamen oder beschreibt das Aussehen statt der Aussage.

**Lösung zu Aufgabe 5.** Eine mögliche Struktur:

```text
doku/
  00-uebersicht/
  10-systeme/
    shop/
    datenbank/
    monitoring/
  20-prozesse/
    freigabe/
    stoerungen/
  90-archiv/
```

Das erste Ordnungsmerkmal ist der Gegenstand (System oder Prozess), weil Leser meist wissen, *wozu* sie etwas brauchen, und weil sich Systeme seltener ändern als Organisationseinheiten. Die Nummernpräfixe sichern die Reihenfolge, das Archiv trennt Überholtes vom aktiven Bestand. Innerhalb jedes Systems würde dasselbe Muster wiederholt (architektur, referenz, runbooks).

**Lösung zu Aufgabe 6.** Eine mögliche Lösung:

```python
import pathlib, re, sys

MUSTER = re.compile(r"^[a-z0-9]+(-[a-z0-9]+){2,}\.md$")
zaehler = 0
for datei in pathlib.Path(sys.argv[1]).rglob("*.md"):
    if not MUSTER.match(datei.name):
        print("Verstoß:", datei)
        zaehler += 1
print(zaehler, "Verstöße")
```

Der Ausdruck verlangt mindestens drei durch Bindestrich getrennte Wortteile aus Kleinbuchstaben und Ziffern (Art, System, Thema), also `{2,}` weitere Teile nach dem ersten. Gegenprobe: `runbook-shop-neustart.md` passt, `Runbook Shop.md` und `runbook-shop.md` nicht. Eine Verfeinerung wäre, die erlaubten Arten ausdrücklich aufzuzählen wie im Beispiel des Abschnitts.

**Lösung zu Aufgabe 7.** Eine mögliche Erweiterung der Funktion `validiere`:

```text
    if meta.get("stand"):
        try:
            d = date.fromisoformat(meta["stand"])
            if d > date.today():
                fehler.append("stand liegt in der Zukunft")
        except ValueError:
            fehler.append("stand: kein gültiges Datum")
    if meta.get("status") == "freigegeben" and not meta.get("reviewer"):
        fehler.append("freigegeben ohne reviewer")
```

Der Vergleich mit `date.today()` fängt Tippfehler im Jahr ab (2062 statt 2026). Die Bedingung auf den Status setzt eine Regel zwischen zwei Feldern um: Es geht nicht mehr nur um einzelne Werte, sondern um Zusammenhänge. Das ist die Art Regeln, die man bei Freigabeprozessen braucht (Vier-Augen-Prinzip: ohne Reviewer keine Freigabe).

**Lösung zu Aufgabe 8.** Schritt 1, Bestandsaufnahme: Export aller Seiten mit Titel, Autor, letztem Änderungsdatum und Zugriffszahlen. Ergebnis: Inventarliste. Risiko: Zahlen täuschen, seltene, aber kritische Seiten (Notfall) haben wenig Zugriffe. Schritt 2, Card Sorting mit fünf bis acht Nutzern, danach Tree Testing. Ergebnis: Gliederungsvorschlag. Risiko: Nutzer repräsentieren nicht alle Zielgruppen. Schritt 3, Taxonomie: Kernbegriffe aus den Ergebnissen, Synonyme, Verantwortlicher. Ergebnis: Begriffsliste mit 20 bis 50 Einträgen. Risiko: Überdesign. Schritt 4, Metadatenmodell: fünf bis acht Pflichtfelder, Wertelisten. Ergebnis: Modell mit Validierung. Risiko: zu viele Pflichtfelder, schlechte Datenqualität. Schritt 5, Migration: erst die wichtigsten Seiten, Veraltetes archivieren statt migrieren, Weiterleitungen einrichten. Ergebnis: neue Struktur mit Prüfung der Verlinkung. Risiko: tote Links und Verlust von Verlinkungen aus anderen Systemen. Ein gutes Vorgehen schließt mit einer Abnahme durch Nutzer und einem Plan zur Pflege ab, damit die neue Struktur nicht erneut verfällt.
