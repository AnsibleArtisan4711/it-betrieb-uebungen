# Modul 04 - Technische Schreibweise und Stilregeln

> **Hinweis zu diesem Kapitel:** Das ist das Kapitel des Skripts „Technische Dokumentation und Dokumentations-Governance“, aus der LaTeX-Quelle in Markdown umgewandelt (Text und Listings unverändert, farbige Boxen als Zitatblöcke mit fettem Titel, Tabellen als Markdown-Tabellen, Übungsaufgaben und Lösungen als Absätze). Die Lerneinheiten sind wie in der Quelle nach Modul nummeriert (4.1 bis 4.8), danach folgen „Übungsaufgaben“ (8 Aufgaben) und „Lösungen und Erläuterungen“. Die Sprachangabe der Codeblöcke ist in der Quelle nur für Python und Bash gesetzt; die übrigen Blöcke sind hier nach ihrem Inhalt als `python`, `yaml`, `markdown`, `bash` oder `text` ausgezeichnet, der Inhalt selbst ist unverändert. **Prüfstand der Beispiele für dieses Repository:** Die Python-Beispiele wurden auf Syntax geprüft; welche Beispiele ausgeführt wurden und welche zusätzlich PyYAML brauchen, steht in der [README des Repositories](../README.md). Übersicht zum Modul: [README](README.md).

**Dauer:** 8 Stunden | **Priorität:** 1 | **Lerneinheiten:** 8

| **Nr.** | **Lerneinheit**                 | **Dauer (h)** | **Prio** |
|--------:|:--------------------------------|--------------:|---------:|
|       1 | Technischer Schreibstil         |             1 |        1 |
|       2 | Terminologiearbeit              |             1 |        1 |
|       3 | Konsistente Benennungen         |             1 |        1 |
|       4 | Handlungsanweisungen            |             1 |        1 |
|       5 | Warn- und Sicherheitshinweise   |             1 |        1 |
|       6 | Schritt-für-Schritt-Anleitungen |             1 |        2 |
|       7 | Prüfung auf Eindeutigkeit       |             1 |        2 |
|       8 | Stil-Troubleshooting            |             1 |        2 |
|         | **Summe**                       |         **8** |          |

## 4.1 Technischer Schreibstil

Technische Texte haben ein anderes Ziel als Romane oder Werbetexte. Sie wollen nicht unterhalten oder überzeugen, sondern eine Handlung oder ein Verständnis ermöglichen, und zwar zuverlässig, auch für Leser, die unter Zeitdruck stehen oder die Sprache nicht als Muttersprache sprechen. Daraus ergeben sich Stilmerkmale, die sich von literarischem Schreiben deutlich unterscheiden. Ein technischer Text ist *sachlich* (keine Wertungen und Übertreibungen), *präzise* (jede Aussage hat genau eine Bedeutung), *adressatengerecht* (Wortwahl und Detailtiefe passen zur Zielgruppe) und *ökonomisch* (nichts Überflüssiges, aber nichts Wesentliches ausgelassen).

Für den Alltag lassen sich diese Merkmale in konkrete Regeln übersetzen. Erstens: *kurze Sätze mit einer Aussage*. Zweitens: *Aktiv statt Passiv*, weil im Aktiv erkennbar bleibt, wer etwas tut („Der Administrator startet den Dienst“ statt „Der Dienst wird gestartet“). Drittens: *Verben statt Substantivierungen*, denn „prüfen“ ist klarer als „die Durchführung einer Prüfung“. Viertens: *Präsens* für Beschreibungen und *Imperativ* für Anweisungen. Fünftens: *keine Füllwörter und Abschwächungen* wie „eigentlich“, „irgendwie“, „gegebenenfalls“ ohne Bedingung. Sechstens: *konsequent eine Anredeform*, in deutschen IT-Dokumentationen meist „Sie“ oder die direkte Handlungsaufforderung ohne Anrede.

Diese Regeln sind kein deutsches Spezifikum. Ähnliche Empfehlungen finden sich in den großen Stilleitfäden der Softwareindustrie, wie die Nachrecherche zeigt.

> **Ergänzung aus der Nachrecherche**
>
> Stilleitfäden im Vergleich: Der Microsoft Writing Style Guide (deutsche Seite „Top 10 tips for style and voice“, abgerufen am 28.10.2026) nennt unter anderem: größere Ideen mit weniger Wörtern ausdrücken, schreiben wie man spricht, schnell zum Punkt kommen, überflüssige Wörter streichen, Satzgroßschreibung für Überschriften verwenden und schwache Konstruktionen wie „there is/there are“ vermeiden. Der Google Developer Documentation Style Guide empfiehlt laut den Highlights unter anderem die zweite Person, aktive Formulierungen, Bedingungen vor Anweisungen und aussagekräftigen Linktext. Beide Leitfäden sind für Englisch formuliert; ihre Grundgedanken (kurz, aktiv, direkt) lassen sich auf Deutsch übertragen, die einzelnen Regeln (etwa zu Kontraktionen) dagegen nicht.

Stilregeln lassen sich in Teilen automatisch prüfen. Dazu gibt es sogenannte Linter, Werkzeuge, die Texte nach festgelegten Mustern durchsuchen. Das folgende Skript ist ein einfacher Prototyp: Es markiert Füllwörter und häufige Nominalstil-Muster in einem Text. Die Wortlisten sind Beispiele, die jedes Team an den eigenen Styleguide anpasst.

```python
import re, sys

FUELLWOERTER = ["eigentlich", "irgendwie", "sozusagen", "quasi", "eventuell"]
NOMINAL = r"\b\w+ung\s+(?:von|der|des)\b"
PASSIV = r"\bwird\b.*\b(?:durchgeführt|vorgenommen|erledigt)\b"

for nr, zeile in enumerate(open(sys.argv[1], encoding="utf-8"), 1):
    for w in FUELLWOERTER:
        if re.search(r"\b" + w + r"\b", zeile, re.I):
            print(f"{nr}: Füllwort '{w}'")
    if re.search(NOMINAL, zeile):
        print(f"{nr}: Nominalstil? {zeile.strip()[:50]}")
    if re.search(PASSIV, zeile):
        print(f"{nr}: Passiv? {zeile.strip()[:50]}")
```

Das Skript liest einen Text zeilenweise. Für jede Zeile prüft es, ob ein Füllwort aus der Liste vorkommt, ob ein Muster wie „Durchführung der“ (ein Wort auf „-ung“ gefolgt von „von/der/des“) auftritt und ob eine Konstruktion „wird ... durchgeführt“ vorliegt. Die Ausgabe nennt jeweils die Zeilennummer. Wichtig ist, die Ergebnisse als *Hinweise* zu verstehen: Nicht jedes Passiv ist falsch, und nicht jedes Wort auf „-ung“ ist ein Nominalstil. Der Mensch entscheidet; das Werkzeug lenkt die Aufmerksamkeit.

Typische Fehler: Man schreibt „wissenschaftlich“ im Sinne von möglichst kompliziert, übernimmt Behördenstil in die Betriebsdokumentation oder wechselt mitten im Text zwischen „Sie“, „man“ und „wir“. Ebenso häufig ist das Gegenteil, ein zu lockerer Ton mit Umgangssprache, der in Audits oder bei internationalen Lesern Probleme macht.

| **Falsch**                                                                                              | **Richtig**                                                    |
|:--------------------------------------------------------------------------------------------------------|:---------------------------------------------------------------|
| „Nach erfolgter Durchführung der Sicherung wird eventuell eine Überprüfung der Konsistenz vorgenommen.“ | „Prüfen Sie nach der Sicherung, ob die Daten konsistent sind.“ |

Im Projekt hilft ein kurzer *Styleguide* von ein bis zwei Seiten, der genau diese Regeln mit Beispielen festhält. Er ersetzt endlose Stildiskussionen in Reviews, denn man verweist einfach auf die Regel.

## 4.2 Terminologiearbeit

Terminologie ist das Fachvokabular eines Gebiets. Terminologiearbeit sorgt dafür, dass jedes Konzept genau eine Benennung hat und jede Benennung genau ein Konzept. Sie beginnt mit einer Unterscheidung, die in der Praxis oft verwischt wird. Ein *Begriff* (Konzept) ist die gedankliche Einheit, etwa „die automatische Sicherung der Datenbank in einem festen Rhythmus“. Eine *Benennung* ist das Wort, das dafür steht, etwa „Datensicherung“. Eine *Definition* erklärt den Begriff. Probleme entstehen, wenn ein Begriff mehrere Benennungen hat (*Synonymie*: „Backup“, „Sicherung“, „Datensicherung“) oder eine Benennung mehrere Begriffe bezeichnet (*Homonymie*: „Server“ für Hardware und für Dienst).

In technischen Texten sind diese Probleme gefährlich, weil Leser aus unterschiedlichen Wörtern unterschiedliche Dinge schließen. Wenn ein Dokument „Sicherung“ und „Backup“ im Wechsel verwendet, fragt sich der aufmerksame Leser, ob es zwei Verfahren gibt. Deshalb gilt in der technischen Redaktion der Grundsatz: *Ein Begriff, eine Benennung, eine Definition.* Anders als in der Literatur, wo Abwechslung als Stilmittel gilt, ist Wiederholung hier erwünscht.

Das Werkzeug der Terminologiearbeit ist die *Terminologiedatenbank* (oder einfacher ein Glossar). Jeder Eintrag enthält die bevorzugte Benennung, die Definition, nicht zu verwendende Synonyme, die Quelle und einen Verantwortlichen. Auch Einführungsregeln gehören dazu: Abkürzungen werden beim ersten Auftreten ausgeschrieben, Fremdwörter nur verwendet, wenn sie in der Zielgruppe üblich sind. Eine radikale Form der Terminologiekontrolle ist das *Simplified Technical English*.

> **Ergänzung aus der Nachrecherche**
>
> ASD-STE100 (Simplified Technical English): Laut dem abgerufenen tcworld-Beitrag ist ASD-STE100 eine kontrollierte natürliche Sprache für technische Dokumentation, bestehend aus Schreibregeln und einem kontrollierten Wörterbuch. Sie wurde ursprünglich für Luft- und Raumfahrt sowie Verteidigung entwickelt und wird inzwischen auch im Bahn-, Medizin-, Automobil- und Energiesektor genutzt. Issue 9 erschien am 15. Januar 2025; laut Beitrag ist der Status vom Spezifikations- zum Standardstatus gewechselt, es gibt keine neuen Regeln, aber 31 der 53 bestehenden Regeln wurden präzisiert und 555 Wörterbucheinträge aktualisiert. STE gilt für Englisch; das Prinzip „ein Wort, eine Bedeutung“ lässt sich als Idee auf deutsche Terminologiearbeit übertragen. (Abruf 28.10.2026, siehe Quellenverzeichnis.)

Ein Glossar muss gepflegt und durchgesetzt werden, sonst nützt es nichts. Das folgende Beispiel zeigt einen Glossareintrag als YAML und ein Skript, das Texte nach nicht erlaubten Synonymen durchsucht und den bevorzugten Begriff vorschlägt.

```yaml
glossar:
  - benennung: Datensicherung
    definition: Automatisch erstellte Kopie der Daten zur Wiederherstellung.
    verboten: [Backup, Sicherung, Back-up]
    owner: Team Betrieb
  - benennung: Wiederherstellung
    definition: Rückführung der Daten aus der Datensicherung in den Betrieb.
    verboten: [Restore, Recovery]
    owner: Team Betrieb
```

```python
import re, sys

VERBOTEN = {
    "Backup": "Datensicherung", "Back-up": "Datensicherung",
    "Restore": "Wiederherstellung", "Recovery": "Wiederherstellung",
}

fund = 0
for nr, zeile in enumerate(open(sys.argv[1], encoding="utf-8"), 1):
    for falsch, richtig in VERBOTEN.items():
        if re.search(r"\b" + re.escape(falsch) + r"\b", zeile):
            print(f"{nr}: '{falsch}' -> besser '{richtig}'")
            fund += 1
sys.exit(1 if fund else 0)
```

Das Glossar hält zu jeder Benennung Definition, nicht erlaubte Alternativen und einen Verantwortlichen fest. Das Skript verwendet eine Abbildung von verbotenen auf bevorzugte Wörter und sucht sie als ganze Wörter (`\b` ist eine Wortgrenze). `re.escape` sorgt dafür, dass der Bindestrich in „Back-up“ nicht als Spezialzeichen gedeutet wird. Der Rückgabewert 1 bei Funden erlaubt den Einsatz in einer Prüfkette. Auffällig ist, dass das Wort „Sicherung“ nicht in der Prüfliste steht: Es ist Teil des bevorzugten Wortes und würde zu Fehlalarmen führen. Auch das zeigt, dass Terminologieprüfung Sorgfalt beim Entwurf der Regeln verlangt.

Typische Fehler: Das Glossar wird einmal angelegt und nie gepflegt; es gibt mehrere Glossare mit widersprüchlichen Einträgen; Begriffe werden definiert, ohne dass jemand sie verwendet. Ebenfalls häufig: Fachbegriffe werden für den Leser nicht erklärt, weil der Autor sie als selbstverständlich ansieht.

| **Falsch**                                                                   | **Richtig**                                                                                        |
|:-----------------------------------------------------------------------------|:---------------------------------------------------------------------------------------------------|
| Ein Dokument spricht abwechselnd von „Backup“, „Sicherung“ und „Datenkopie“. | Das Dokument verwendet durchgehend „Datensicherung“ und erklärt den Begriff beim ersten Auftreten. |

Im Projekt lohnt sich Terminologiearbeit besonders bei Übersetzungen und bei der Zusammenführung von Teams, die für dasselbe Ding verschiedene Wörter nutzen.

## 4.3 Konsistente Benennungen

Neben dem Fachvokabular (Terminologie) gibt es eine zweite Ebene der Konsistenz: die einheitliche Benennung und Formatierung konkreter Dinge, über die im Text gesprochen wird. Dazu zählen Produktnamen, Bedienelemente, Dateinamen, Befehle, Menüpfade, Zahlen und Datumsangaben. Konsistenz ist hier kein Schönheitsproblem, sondern eine Frage der Sicherheit: Wer in einer Anleitung „Einstellungen“ liest und in der Software „Optionen“ sieht, zögert, und wer sich im Zweifel für den falschen Menüpunkt entscheidet, macht einen Fehler.

Bewährte Regeln: *Bedienelemente* (Schaltflächen, Menüeinträge, Felder) werden exakt so geschrieben, wie sie in der Oberfläche erscheinen, und einheitlich hervorgehoben (üblich ist Fettdruck). *Code, Befehle, Dateinamen und Pfade* stehen in Code-Schrift (Festbreitenschrift), damit sie sich vom Text abheben und kopierbar sind. *Platzhalter* werden einheitlich gekennzeichnet (zum Beispiel in spitzen Klammern: `<Servername>`). *Produkt- und Eigennamen* werden immer in der offiziellen Schreibweise geschrieben. *Zahlen* erhalten Einheiten mit geschütztem Leerzeichen („30 Sekunden“), *Datumsangaben* folgen einem Format, bei technischen Dokumenten am besten dem internationalen JJJJ-MM-TT. Das ist nicht nur sortierbar, sondern auch eindeutig: Bei „03.04.2026“ ist international nicht klar, was Tag und was Monat ist. Der Google-Styleguide fordert ebenfalls eindeutige Datumsformate.

Das folgende Beispiel zeigt eine Konventionstabelle als Markdown und ein Skript, das zwei typische Verstöße findet: Datumsangaben im deutschen Format ohne ISO-Alternative und abweichende Schreibweisen eines Produktnamens.

```text
| Element         | Schreibweise                  | Beispiel               |
|-----------------|-------------------------------|------------------------|
| Bedienelement   | fett, Wortlaut der Oberfläche | Klicken Sie auf **Speichern**. |
| Befehl, Pfad    | Code-Schrift                  | `systemctl restart nginx` |
| Platzhalter     | in spitzen Klammern           | `<Servername>`         |
| Datum           | JJJJ-MM-TT                    | 2026-10-28             |
| Produktname     | wie auf der Herstellerseite   | PostgreSQL             |
```

```python
import re, sys

PRODUKTE = {"PostgreSQL": [r"\bPostgres\b", r"\bpostgresql\b", r"\bPostgre SQL\b"]}

for nr, zeile in enumerate(open(sys.argv[1], encoding="utf-8"), 1):
    for m in re.finditer(r"\b\d{1,2}\.\d{1,2}\.\d{4}\b", zeile):
        print(f"{nr}: Datum '{m.group()}' -> JJJJ-MM-TT verwenden")
    for korrekt, varianten in PRODUKTE.items():
        for v in varianten:
            if re.search(v, zeile):
                print(f"{nr}: Schreibweise von '{korrekt}' prüfen")
```

Die Tabelle fasst die Regeln so zusammen, dass man sie im Review nachschlagen kann. Das Skript sucht mit dem Ausdruck `\d{1,2}\.\d{1,2}\.\d{4}` nach Datumsangaben im deutschen Format (Tag, Monat, vierstelliges Jahr) und prüft die Schreibweisen eines Produkts anhand einer Variantenliste. Bei einem Treffer erscheint die Zeilennummer mit einem Verbesserungshinweis. Solche einfachen Prüfungen decken überraschend viele Inkonsistenzen auf.

Typische Fehler: Die Oberfläche ändert sich, die Dokumentation nicht (Menüpunkte heißen anders); verschiedene Autoren formatieren Befehle unterschiedlich; Platzhalter und echte Werte sind nicht unterscheidbar, sodass jemand „Servername“ wörtlich eintippt. Ein weiterer Klassiker: Befehle werden in Textverarbeitungen kopiert, die gerade Anführungszeichen automatisch durch typografische ersetzen, wodurch der Befehl beim Einfügen scheitert.

| **Falsch**                                                                | **Richtig**                                                                             |
|:--------------------------------------------------------------------------|:----------------------------------------------------------------------------------------|
| „Geben Sie nun den Server ein und drücken Sie auf den Knopf zum Sichern.“ | „Geben Sie im Feld **Server** den Namen `<Servername>` ein und klicken Sie auf **Speichern**.“ |

Im Projekt lohnt sich ein kurzer Konventionsabschnitt im Styleguide. Wo möglich, setzt man Prüfungen in die Pipeline, damit Konsistenz nicht von der Aufmerksamkeit einzelner Reviewer abhängt.

## 4.4 Handlungsanweisungen

Eine Handlungsanweisung fordert den Leser zu einer Handlung auf. Sie ist der wichtigste Satztyp in Betriebs- und Prozessdokumentation, und hier entscheidet sprachliche Präzision unmittelbar über den Erfolg: Eine unklare Anweisung führt zu einem Fehler im Betrieb. Ihr Aufbau folgt festen Regeln. Der *Imperativ* ist die klare Form („Starten Sie den Dienst“). Der *Infinitiv* („Dienst starten“) ist eine verbreitete Kurzform in Listen. Passive und unpersönliche Formulierungen („Der Dienst ist zu starten“, „man startet den Dienst“) verschleiern den Handelnden und wirken wie eine Beschreibung, nicht wie eine Aufforderung.

Dazu kommen vier Grundregeln. Erstens: *eine Handlung pro Anweisung*. Eine Anweisung, die zwei Handlungen enthält („Stoppen Sie den Dienst und löschen Sie die Logdateien“), verführt dazu, eine zu überspringen, und macht es schwer, bei einem Fehler die Stelle zu finden. Zweitens: *Bedingung vor Handlung*. Man schreibt „Wenn der Dienst nicht antwortet, starten Sie ihn neu“, nicht umgekehrt, denn der Leser muss die Bedingung kennen, bevor er handelt. Der Google-Styleguide nennt dasselbe Prinzip (Bedingungen vor Anweisungen). Drittens: *Ziel vor Mittel*, wenn der Zweck nicht offensichtlich ist („Um die Änderung wirksam zu machen, laden Sie die Konfiguration neu“). Viertens: *erwartetes Ergebnis benennen*, damit der Leser prüfen kann, ob der Schritt gelungen ist („Die Statusanzeige zeigt **Aktiv**.“).

Konkret sieht eine gut formulierte Anweisung so aus, wie das folgende Beispiel zeigt. Es stammt aus einem Runbook für den Neustart eines Dienstes. Danach folgt ein einfaches Prüfskript, das Anweisungen auf häufige Fehler hin untersucht: mehrere Handlungen in einem Schritt und unpersönliche Formulierungen.

```text
1. Prüfen Sie den Status des Dienstes:
   `systemctl status shop`
   Der Status zeigt **inactive** oder **failed**.
2. Wenn der Dienst nicht läuft, starten Sie ihn:
   `systemctl start shop`
3. Prüfen Sie, ob der Dienst läuft:
   `systemctl is-active shop`
   Die Ausgabe lautet `active`.
```

```python
import re, sys

for nr, zeile in enumerate(open(sys.argv[1], encoding="utf-8"), 1):
    m = re.match(r"^\s*\d+\.\s+(.*)", zeile)
    if not m:
        continue
    schritt = m.group(1)
    if re.search(r"\bund (?:dann|anschließend|danach)\b", schritt):
        print(f"{nr}: mehrere Handlungen in einem Schritt")
    if re.search(r"\b(?:man|ist zu|sind zu|muss .* werden)\b", schritt, re.I):
        print(f"{nr}: unpersönlich formuliert")
    if len(schritt.split()) > 25:
        print(f"{nr}: Schritt zu lang")
```

Die drei Schritte zeigen die Regeln: Jeder Schritt hat genau eine Handlung. In Schritt 2 steht die Bedingung vor der Handlung. Befehle stehen in Code-Schrift, Ergebnisse sind benannt („inactive“, „active“). Das Skript sucht zeilenweise nach nummerierten Schritten und prüft drei Muster: Verknüpfungen wie „und dann“, unpersönliche Wendungen und Länge über 25 Wörter. Die Muster sind absichtlich einfach gehalten und liefern Hinweise, keine Urteile.

Typische Fehler: Anweisungen enthalten die Handlung am Satzende („Nachdem Sie sich vergewissert haben, dass der Dienst gestoppt ist, kann ... neu gestartet werden“), nennen kein Ergebnis oder setzen Wissen voraus („Wie üblich konfigurieren“). Auch das Vermischen von Anweisung und Erklärung im selben Satz ist beliebt, obwohl die Erklärung in einen eigenen Satz oder ein anderes Dokument gehört.

| **Falsch**                                                                                                | **Richtig**                                                                                                                 |
|:----------------------------------------------------------------------------------------------------------|:----------------------------------------------------------------------------------------------------------------------------|
| „Der Dienst ist neu zu starten, nachdem man die Konfiguration geprüft und gegebenenfalls korrigiert hat.“ | „1. Prüfen Sie die Konfiguration. 2. Wenn die Prüfung Fehler meldet, korrigieren Sie diese. 3. Starten Sie den Dienst neu.“ |

Im Projekt ist die Handlungsanweisung die Einheit, an der die Qualität des Betriebs hängt. Wer Runbooks prüft, sollte sie wörtlich nachvollziehen, ohne Vorwissen zu ergänzen: Jede Stelle, an der man raten muss, ist ein Mangel.

## 4.5 Warn- und Sicherheitshinweise

Warnhinweise machen auf Gefahren aufmerksam, bevor sie eintreten. Ihre Wirkung beruht auf Seltenheit: Wer überall warnt, wird nicht mehr beachtet. Deshalb gilt der Grundsatz, Warnhinweise nur dort einzusetzen, wo eine tatsächliche Gefahr besteht, und sie dann unmissverständlich zu gestalten. Klassisch kommen Warnhinweise aus dem Produktsicherheitsrecht und dem Maschinenbau, wo es um Gesundheit und Leben geht. In der IT drohen eher Schäden an Daten, Systemen und Verfügbarkeit, aber dieselbe Logik gilt: Hinweise müssen verhindern, dass jemand mit einer Handlung etwas Unwiederbringliches tut.

Üblich ist eine Abstufung mit Signalwörtern, die den Risikograd anzeigen. Ein Beispiel aus der Dokumentation eines Automatisierungsherstellers: *GEFAHR* bezeichnet einen hohen Risikograd mit Tod oder schwerer Verletzung als Folge, *WARNUNG* einen mittleren Risikograd, bei dem Tod oder schwere Verletzung die Folge sein *kann*, *VORSICHT* einen geringen Risikograd mit möglicher leichter oder mittelschwerer Verletzung, und *Hinweis* eine Warnung vor Umwelt- oder Sachschäden, einschließlich Schäden an Geräten oder Daten.

> **Ergänzung aus der Nachrecherche**
>
> Signalwörter in der Praxis: Laut der abgerufenen Beckhoff-Informationsseite „Zu Ihrer Sicherheit“ (Beispiel eines Herstellers) gilt: GEFAHR = hoher Risikograd, Tod oder schwere Verletzung die Folge; WARNUNG = mittlerer Risikograd, Tod oder schwere Verletzung kann die Folge sein; VORSICHT = geringer Risikograd, mittelschwere oder leichte Verletzung kann die Folge sein; Hinweis = Warnung vor Umwelt- oder Sachschäden (Umwelt, Geräte, Daten). Daneben gibt es einen Infokasten, der kein Warnhinweis ist. Die Seite erläutert keine feste Gliederung der Hinweise. Die in Normen wie IEC/IEEE 82079-1 geregelte Gestaltung wurde nicht abgerufen; verbindlich ist sie nur dort, wo eine Norm oder ein Gesetz sie vorschreibt. (Abruf 28.10.2026, siehe Quellenverzeichnis.)

Ein guter Warnhinweis beantwortet vier Fragen in dieser Reihenfolge: Wie schwer ist die Gefahr (Signalwort)? Welche Gefahr droht und woher kommt sie (Art und Quelle)? Was passiert, wenn man nichts unternimmt (Folge)? Wie verhindert man es (Maßnahme)? Entscheidend ist außerdem die *Platzierung*: Der Hinweis steht *vor* der gefährlichen Handlung, nicht danach, und bezieht sich auf genau diese Handlung. Ein Warnhinweis auf Seite zwei, der die Handlung auf Seite fünf betrifft, wird nicht gelesen.

Das Beispiel zeigt einen Warnhinweis in Markdown mit allen vier Bestandteilen. Das Skript darunter prüft, ob jeder Warnhinweis in einem Dokument vollständig ist.

```text
> **WARNUNG: Datenverlust**
> Der Befehl löscht alle Daten der Datenbank unwiderruflich.
> Folge: Ohne Datensicherung sind die Daten verloren.
> Maßnahme: Prüfen Sie vorher, dass die aktuelle Datensicherung
> vorhanden ist (siehe Runbook Datensicherung prüfen).

4. Löschen Sie die Datenbank: `dropdb shop`
```

```python
import re, sys

text = open(sys.argv[1], encoding="utf-8").read()
bloecke = re.findall(r"(?:^> .*\n?)+", text, re.M)
fehler = 0
for b in bloecke:
    if not re.search(r"\*\*(?:GEFAHR|WARNUNG|VORSICHT|HINWEIS)", b):
        continue
    for teil in ("Folge:", "Maßnahme:"):
        if teil not in b:
            print(f"Warnhinweis ohne '{teil}':", b.splitlines()[0])
            fehler += 1
sys.exit(1 if fehler else 0)
```

Der Warnhinweis folgt dem Muster: Das Signalwort mit Gefahrenart steht in der Kopfzeile, der erste Satz nennt die Quelle (der Befehl löscht Daten), dann folgen Folge und Maßnahme, und erst danach kommt der Schritt. Das Skript sammelt zusammenhängende Blockzitate (Zeilen mit `>` am Anfang), erkennt darunter die Warnhinweise an ihrem Signalwort und meldet, wenn „Folge:“ oder „Maßnahme:“ fehlen. Der Prüfer erzwingt damit die Vollständigkeit, ohne den Wortlaut zu bewerten.

Typische Fehler: Warnhinweise, die nur „Vorsicht!“ sagen, ohne Gefahr und Maßnahme; Warnhinweise im Fließtext versteckt; und Dauerwarnungen, die jeden Schritt begleiten. Letztere führen zur sogenannten *Warnmüdigkeit*, bei der Leser auch die wichtigen Hinweise ignorieren. Zur sachlichen Einordnung gehört auch, Hinweise zu dosieren: Ein Warnhinweis für den Neustart eines Testsystems wäre übertrieben.

| **Falsch**                        | **Richtig**                                                                                                                                  |
|:----------------------------------|:---------------------------------------------------------------------------------------------------------------------------------------------|
| „Achtung! Vorsicht beim Löschen!“ | „WARNUNG: Datenverlust. Der Befehl löscht die Datenbank unwiderruflich. Prüfen Sie vorher, dass eine aktuelle Datensicherung vorhanden ist.“ |

Im Projekt gehören Warnhinweise besonders in Runbooks für riskante Tätigkeiten: Löschen, Migrieren, Zurücksetzen, Eingriffe in produktive Datenbanken. Fragen Sie bei jedem Schritt, ob ein Fehler hier nicht rückgängig zu machen ist. Wenn ja, braucht der Schritt einen Warnhinweis.

## 4.6 Schritt-für-Schritt-Anleitungen

Eine Schritt-für-Schritt-Anleitung führt einen Leser von einem Ausgangszustand zu einem Ziel. Sie ist die Verbindung der bisher behandelten Elemente: Zweck, Zielgruppe, Struktur, Handlungsanweisungen, Terminologie, Warnhinweise. Eine gute Anleitung lässt sich ohne Nachdenken Schritt für Schritt abarbeiten und enthält dennoch alle Informationen, die man braucht, wenn etwas nicht wie erwartet läuft.

Die Bestandteile sind: *Titel* mit Verb und Ziel („Zertifikat erneuern“), *Zweck und Ergebnis* in ein bis zwei Sätzen, *Voraussetzungen* (Berechtigungen, Zugänge, Material, Zeitbedarf), *Schritte* (nummeriert, jeweils eine Handlung, wo nötig mit Erwartung), *Prüfung* (woran erkennt man den Erfolg?), *Fehlerfall* (was tun, wenn ein Schritt nicht funktioniert, einschließlich des Rückwegs) und *Verweise*. Der Rückweg (Rollback) wird oft vergessen, ist aber bei riskanten Änderungen der wichtigste Teil, denn er entscheidet, ob ein Fehler zur Störung wird.

Weitere Regeln für die Gestaltung: Die Zahl der Schritte sollte überschaubar bleiben, Richtwert sind höchstens sieben bis zehn; bei längeren Abläufen gliedert man in Teilaufgaben mit eigenem Titel. Verzweigungen werden vermieden oder klar ausgewiesen („Wenn A: weiter mit Schritt 5. Wenn B: weiter mit Schritt 8.“). Bildschirmfotos zeigen schwer beschreibbare Stellen, keine einfachen Klicks. Jeder Schritt ist mit der Nummer eindeutig adressierbar, sodass bei Rückfragen über „Schritt 6“ gesprochen werden kann.

Als vollständiges Beispiel folgt eine Anleitung zum Erneuern eines Zertifikats mit allen Bestandteilen. Danach ein Skript, das prüft, ob die Nummerierung lückenlos ist und ob alle Pflichtabschnitte vorhanden sind.

```markdown
# Zertifikat des Webservers erneuern

**Zweck:** Dieses Dokument ermöglicht Administratoren, das TLS-Zertifikat
des Webservers vor Ablauf zu erneuern. Dauer: etwa 15 Minuten.

## Voraussetzungen
- SSH-Zugang zu `<Servername>` mit sudo-Recht
- Neues Zertifikat und Schlüssel liegen vor

## Schritte
1. Sichern Sie das alte Zertifikat:
   `sudo cp /etc/ssl/certs/shop.pem /etc/ssl/certs/shop.pem.bak`
2. Kopieren Sie das neue Zertifikat nach `/etc/ssl/certs/shop.pem`.
3. Prüfen Sie die Konfiguration: `sudo nginx -t`
   Die Ausgabe lautet **syntax is ok**.
4. Laden Sie den Webserver neu: `sudo systemctl reload nginx`

## Prüfung
Rufen Sie die Seite im Browser auf. Das Zertifikat zeigt das neue
Ablaufdatum.

## Fehlerfall
Wenn Schritt 3 einen Fehler meldet: Stellen Sie das alte Zertifikat
aus `shop.pem.bak` wieder her und laden Sie den Webserver nicht neu.
```

```python
import re, sys

text = open(sys.argv[1], encoding="utf-8").read()
fehler = []

nummern = [int(n) for n in re.findall(r"^(\d+)\. ", text, re.M)]
if nummern != list(range(1, len(nummern) + 1)):
    fehler.append(f"Nummerierung unvollständig: {nummern}")
if len(nummern) > 10:
    fehler.append("Mehr als 10 Schritte: in Teilaufgaben gliedern")

for abschnitt in ("Voraussetzungen", "Schritte", "Prüfung", "Fehlerfall"):
    if not re.search(rf"^## {abschnitt}\s*$", text, re.M):
        fehler.append(f"Abschnitt fehlt: {abschnitt}")

print("OK" if not fehler else "\n".join(fehler))
sys.exit(1 if fehler else 0)
```

Die Beispielanleitung hat einen Zweck mit Zielgruppe und Dauer, nennt Voraussetzungen, vier einzelne Schritte, Erwartungen an den Ausgaben, eine Prüfung und einen Rückweg. Die Dauerangabe ist ein Beispielwert. Besonders wichtig ist Schritt 1, der ein Backup *vor* der Änderung verlangt, und der Fehlerfall, der den Rückweg beschreibt. Das Skript sammelt die Nummern am Zeilenanfang und vergleicht sie mit einer lückenlosen Folge, begrenzt die Schrittzahl und verlangt die vier Pflichtabschnitte. In realen Dokumenten mit mehreren Listen müsste es die Nummerierung je Liste prüfen; hier genügt die Prüfung des Prinzips.

Typische Fehler: Es fehlt der Ausgangszustand (der Leser weiß nicht, ob er am richtigen Ort beginnt), die Schritte sind nicht nummeriert, nach Schritt 3 steht ein Fehler, dessen Behandlung nicht beschrieben wird, und es gibt keinen Rückweg. Auch beliebt: Anleitungen, die nie von einem Menschen ohne Vorwissen ausprobiert wurden.

| **Falsch**                                          | **Richtig**                                                                          |
|:----------------------------------------------------|:-------------------------------------------------------------------------------------|
| „Zertifikat tauschen, Webserver neu laden, testen.“ | Nummerierte Schritte mit Befehlen, erwarteter Ausgabe, Prüfung und Rückweg wie oben. |

Im Projekt sollte jede Anleitung vor der Freigabe von jemandem getestet werden, der sie nicht geschrieben hat: Schritt für Schritt, ohne Vorwissen, auf einem Testsystem. Alles, was dabei hakt, ist ein Fehler im Dokument.

## 4.7 Prüfung auf Eindeutigkeit

Eindeutigkeit bedeutet, dass ein Text genau eine Deutung zulässt. In technischer Dokumentation ist das nicht nur Stilfrage, sondern eine Sicherheitsanforderung: Wenn zwei Leser denselben Satz verschieden verstehen und beide danach handeln, führt eine Variante zu einem Fehler. Deshalb braucht es neben Schreibregeln ein Verfahren, das Mehrdeutigkeiten gezielt aufspürt.

Mehrdeutigkeit hat mehrere typische Quellen. *Lexikalische Mehrdeutigkeit*: Ein Wort hat mehrere Bedeutungen („Bank“, im IT-Kontext „Server“ oder „Instanz“). *Bezugsmehrdeutigkeit*: Ein Pronomen kann sich auf mehrere Dinge beziehen („Starten Sie den Dienst und den Server neu und prüfen Sie ihn“: Was ist „ihn“?). *Geltungsbereich*: „Alle Benutzer und Administratoren mit Zugriff“ (Haben alle Benutzer Zugriff oder nur Administratoren?). *Unscharfe Angaben*: „bald“, „regelmäßig“, „groß“, „ggf.“ ohne Bedingung. *Unvollständige Angaben*: Zahlen ohne Einheit, Zeitangaben ohne Zeitzone. *Verknüpfungen*: „und/oder“, „bzw.“ und „oder“ im Sinne von entweder-oder oder beides.

Die Prüfung kann auf drei Wegen erfolgen. Erstens durch *automatische Hinweise* auf typische Wörter und Muster, die den Blick lenken. Zweitens durch *Review mit Perspektivwechsel*: Der Prüfer liest absichtlich als jemand ohne Vorwissen und notiert jede Stelle, an der er raten musste. Drittens durch den *Praxistest*: Eine Person führt die Anleitung buchstäblich aus, und der Autor beobachtet. Der Praxistest ist aufwendig, deckt aber Fehler auf, die kein Review findet.

Das folgende Skript sucht in einem Text nach unscharfen Angaben und Verknüpfungen, die Mehrdeutigkeit auslösen können, und gibt jeweils den Kontext aus. Es zeigt zugleich, wie man eine Beobachtungsliste für den Review aufbaut.

```python
import re, sys

MUSTER = {
    "unscharfe Zeitangabe": r"\b(bald|regelmäßig|zeitnah|häufig|selten)\b",
    "offene Bedingung": r"\b(ggf\.|gegebenenfalls|falls nötig|bei Bedarf)\b",
    "unklare Verknüpfung": r"(und/oder|\bbzw\.)",
    "Zahl ohne Einheit": r"\b(?:Timeout|Laufzeit|Wartezeit)\D{0,15}\d+\b(?!\s*(?:s|min|h|Sekunden|Minuten|Stunden))",
}

for nr, zeile in enumerate(open(sys.argv[1], encoding="utf-8"), 1):
    for name, muster in MUSTER.items():
        m = re.search(muster, zeile, re.I)
        if m:
            print(f"{nr}: {name}: ...{zeile.strip()[:60]}")
```

Das Skript nutzt ein Wörterbuch von Mustern, das jedem Typ der Mehrdeutigkeit einen regulären Ausdruck zuordnet. Zeilenweise wird geprüft und bei Treffern der Typ mit einem Textausschnitt ausgegeben. Der letzte Ausdruck sucht beispielsweise Angaben wie „Timeout 30“ ohne nachfolgende Einheit, wobei der negative Lookahead `(?!...)` die Treffer ausschließt, bei denen eine Einheit folgt. Gerade solche Zahlen sind tückisch: 30 Sekunden oder 30 Minuten? Wie bei allen Mustersuchen gilt: Das Werkzeug liefert Kandidaten, die der Mensch beurteilt.

Typische Fehler: Man sucht Mehrdeutigkeit nur beim Schreiben, nicht beim Prüfen; man verlässt sich auf den Autor, der die gemeinte Bedeutung kennt und deshalb die Mehrdeutigkeit gar nicht sieht; oder man glaubt, ein eindeutiger Satz sei auch ein verständlicher. Eindeutigkeit und Verständlichkeit sind verwandt, aber nicht identisch: Ein Satz kann eindeutig und trotzdem unverständlich sein.

| **Falsch**                                               | **Richtig**                                                                               |
|:---------------------------------------------------------|:------------------------------------------------------------------------------------------|
| „Den Timeout bei Bedarf erhöhen, bzw. zeitnah anpassen.“ | „Wenn Anfragen nach 30 Sekunden abbrechen, erhöhen Sie den Wert `timeout` auf 60 Sekunden.“ |

Im Projekt eignet sich als Test der *Rückfragenzähler*: Jede Rückfrage zu einem Dokument wird als Mehrdeutigkeit gewertet und notiert. So entsteht ein Maß, das zeigt, welche Dokumente die meisten Probleme machen.

## 4.8 Stil-Troubleshooting

Auch wenn Stilregeln bekannt sind, treten im Alltag Probleme auf: Leser machen Fehler, Reviews erzeugen endlose Diskussionen, Dokumente von verschiedenen Autoren klingen unterschiedlich. Dieser Abschnitt zeigt, wie man solche Fehlerbilder anhand von Struktur, Aktualität, Zielgruppenfeedback und Review-Kommentaren eingrenzt und daraus Runbook-Schritte für Redaktion, Fachbereich und Betrieb ableitet.

Die Symptome lassen sich vier Ursachenfeldern zuordnen. „Leser machen Fehler bei der Ausführung“ deutet auf Handlungsanweisungen oder Eindeutigkeit (fehlende Ergebnisse, mehrere Handlungen pro Schritt, unscharfe Angaben). „Leser fragen nach Begriffen“ deutet auf Terminologie (uneinheitliche oder unerklärte Begriffe). „Texte klingen unterschiedlich“ deutet auf fehlende oder nicht befolgte Stilregeln. „Leser überspringen Warnungen“ deutet auf Warnmüdigkeit oder schlechte Platzierung. Die Gegenprobe besteht darin, drei betroffene Dokumente genau anzusehen und mit zwei Lesern zu sprechen, bevor man Maßnahmen beschließt.

Review-Kommentare sind eine hervorragende Datenquelle, wenn man sie systematisch auswertet. Das folgende Beispiel zeigt eine einfache Kommentarsammlung und ein Skript, das Kommentare nach Stilkategorien zählt. Die Kategorie mit den meisten Treffern ist der erste Kandidat für eine Maßnahme (Schulung, Template, Prüfregel).

```text
dokument;kategorie;kommentar
runbook-shop;Handlung;Zwei Befehle in einem Schritt
runbook-shop;Terminologie;Backup und Sicherung gemischt
runbook-db;Handlung;Kein erwartetes Ergebnis
runbook-db;Eindeutigkeit;bei Bedarf - wann genau?
konzept-netz;Terminologie;Server und Host synonym verwendet
runbook-db;Handlung;Passiv, wer handelt?
```

```python
import csv
from collections import Counter

with open("kommentare.csv", encoding="utf-8", newline="") as f:
    zeilen = list(csv.DictReader(f, delimiter=";"))

kategorien = Counter(z["kategorie"] for z in zeilen)
dokumente = Counter(z["dokument"] for z in zeilen)

print("Nach Kategorie:")
for k, n in kategorien.most_common():
    print(f"  {k:15s} {n}")
print("Dokument mit den meisten Kommentaren:", dokumente.most_common(1)[0])
```

Das Skript liest die Kommentare ein und zählt sie getrennt nach Kategorie und Dokument. In der Beispieldatei dominiert die Kategorie „Handlung“ mit drei Kommentaren vor „Terminologie“ mit zwei und „Eindeutigkeit“ mit einem, und das Dokument `runbook-db` fällt mit drei Kommentaren auf. Daraus lässt sich ein Maßnahmenplan ableiten: eine kurze Schulung zu Handlungsanweisungen für die Autoren, eine Vorlage mit festen Feldern für „erwartetes Ergebnis“ und die Überarbeitung von `runbook-db`.

Als Runbook für die Redaktion ergibt sich: Kommentare monatlich sammeln und kategorisieren, Kategorie mit den meisten Treffern auswählen, Ursache klären (Wissenslücke, fehlende Vorlage, fehlende Regel), Maßnahme festlegen, Wirkung im nächsten Monat prüfen. Der Kreis schließt sich, wenn die Kommentare dieser Kategorie zurückgehen.

Typische Fehler: Man ersetzt Ursachenanalyse durch Diskussion über Geschmack („mir gefällt der Satz nicht“); Maßnahmen wirken nur auf das einzelne Dokument und nicht auf die Autoren; Stilregeln werden eingeführt, aber nicht in Vorlagen und Prüfungen verankert. Wichtig ist auch der Ton in Reviews: Kommentare sollen den Text betreffen, nicht die Person, und eine konkrete Verbesserung vorschlagen.

| **Falsch**                                        | **Richtig**                                                                                                                           |
|:--------------------------------------------------|:--------------------------------------------------------------------------------------------------------------------------------------|
| Review-Kommentar: „Das ist schlecht geschrieben.“ | Review-Kommentar: „Schritt 3 enthält zwei Handlungen. Vorschlag: In die Schritte 3 und 4 teilen und das erwartete Ergebnis ergänzen.“ |

Im Projekt gehört die Auswertung solcher Kommentare zu den günstigsten Qualitätsmaßnahmen: Sie braucht nur eine Tabelle, zeigt aber genau, wo die Autoren Unterstützung brauchen.

## Übungsaufgaben

Die Aufgaben steigen von Verständnisfragen (1 bis 3) über Umformulierungen und Anwendungen (4 bis 6) bis zu praktischen Programmieraufgaben und Transfer (7 und 8) an.

**Aufgabe 1.** *(leicht)* Nennen Sie sechs Regeln des technischen Schreibstils und erklären Sie, warum Passiv und Nominalstil in Handlungsanweisungen problematisch sind.

**Aufgabe 2.** *(leicht)* Erklären Sie den Unterschied zwischen Begriff, Benennung und Definition am Beispiel „Server“. Was ist hier das Problem der Homonymie?

**Aufgabe 3.** *(leicht bis mittel)* Formulieren Sie die folgenden Sätze als klare Handlungsanweisungen um: (a) „Die Konfiguration ist zu überprüfen und der Dienst gegebenenfalls neu zu starten.“ (b) „Nach Durchführung der Installation erfolgt die Aktivierung der Lizenz.“

**Aufgabe 4.** *(mittel)* Verbessern Sie den folgenden Warnhinweis und ergänzen Sie fehlende Bestandteile: „Achtung! Beim Zurücksetzen alles weg.“ Wählen Sie ein passendes Signalwort und begründen Sie die Wahl.

**Aufgabe 5.** *(mittel)* Schreiben Sie eine Schritt-für-Schritt-Anleitung „Benutzer in der Verwaltung sperren“ mit Zweck, Voraussetzungen, mindestens vier Schritten, Prüfung und Fehlerfall. Die Oberfläche denken Sie sich aus.

**Aufgabe 6.** *(mittel, praktisch)* Schreiben Sie ein Python-Skript, das in einem Text prüft, ob das Wort „Sicherung“ alleinstehend (nicht in „Datensicherung“) vorkommt, und die Zeilen ausgibt.

**Aufgabe 7.** *(anspruchsvoll, praktisch)* Erweitern Sie das Mehrdeutigkeits-Skript um eine Regel, die Zahlen mit den Einheiten „MB“ und „GB“ im selben Dokument meldet (Hinweis auf mögliche Verwechslung), und erklären Sie, warum dies ein Qualitätsrisiko ist.

**Aufgabe 8.** *(anspruchsvoll, Transfer)* In Ihrem Team beschweren sich Betriebsmitarbeitende, dass Runbooks „nicht stimmen“. Ihre Auswertung der Review-Kommentare zeigt 40 Prozent „Handlung“, 30 Prozent „Terminologie“, 20 Prozent „Eindeutigkeit“, 10 Prozent „Stil“. Entwerfen Sie einen Maßnahmenplan mit drei Schritten und Erfolgskriterien.

## Lösungen und Erläuterungen

**Lösung zu Aufgabe 1.** Mögliche Regeln: kurze Sätze, Aktiv, Verben statt Substantivierungen, Präsens und Imperativ, keine Füllwörter, einheitliche Anrede. Passiv und Nominalstil verschleiern, *wer* etwas tun soll. Der Leser muss die Handlung aus dem Satz erst herauslesen, und bei Zeitdruck wird sie übersehen oder falsch verstanden. „Starten Sie den Dienst“ ist unmissverständlich, „Der Dienst ist zu starten“ lässt offen, wer es tut und ob es verpflichtend ist.

**Lösung zu Aufgabe 2.** Der Begriff ist die Idee (ein Rechner, auf dem Dienste laufen), die Benennung ist das Wort „Server“, die Definition erklärt, was gemeint ist. Homonymie liegt vor, weil „Server“ sowohl für die Hardware als auch für einen Dienst (etwa Webserver-Software) stehen kann. In einer Anleitung „Starten Sie den Server neu“ ist dann offen, ob der Rechner oder der Dienst gemeint ist. Lösung: zwei Benennungen festlegen (etwa „Server“ für den Rechner, „Dienst“ für die Software) und im Glossar definieren.

**Lösung zu Aufgabe 3.** (a) „1. Prüfen Sie die Konfiguration. 2. Wenn die Prüfung Fehler meldet, korrigieren Sie diese und starten Sie den Dienst neu.“ Besser noch mit Aufteilung des Neustarts in einen eigenen Schritt. Die Bedingung steht vor der Handlung, und das „gegebenenfalls“ wird zu einer prüfbaren Bedingung. (b) „1. Installieren Sie das Produkt. 2. Aktivieren Sie die Lizenz.“ Die Nominalisierungen „Durchführung der Installation“ und „Aktivierung der Lizenz“ werden zu Verben.

**Lösung zu Aufgabe 4.** Ein möglicher Hinweis: „WARNUNG: Datenverlust. Das Zurücksetzen löscht alle Benutzerdaten auf dem Gerät unwiderruflich. Folge: Nicht gesicherte Daten sind verloren. Maßnahme: Erstellen Sie vor dem Zurücksetzen eine Datensicherung und prüfen Sie, dass sie lesbar ist.“ Das Signalwort richtet sich nach der Schwere. Wenn nur Daten betroffen sind, entspricht das nach dem Muster aus der Nachrecherche dem Signalwort „Hinweis“ (Daten als Sachschaden); bei Gefahren für Leib und Leben wäre „WARNUNG“ oder „GEFAHR“ angemessen. Wichtig ist, dass die Wahl begründet und im Styleguide einheitlich geregelt ist. Der Hinweis gehört unmittelbar vor den Schritt.

**Lösung zu Aufgabe 5.** Eine mögliche Lösung (Auszug):

```markdown
# Benutzer in der Verwaltung sperren

**Zweck:** Dieses Dokument ermöglicht Administratoren, ein Benutzerkonto
zu sperren, ohne es zu löschen.

## Voraussetzungen
- Rolle Administrator in der Verwaltung
- Benutzername des Kontos

## Schritte
1. Öffnen Sie **Verwaltung > Benutzer**.
2. Suchen Sie das Konto über das Feld **Suche**.
3. Klicken Sie in der Zeile des Kontos auf **Sperren**.
4. Bestätigen Sie mit **Ja**.
   Der Status des Kontos zeigt **gesperrt**.

## Prüfung
Eine Anmeldung mit dem Konto schlägt mit der Meldung
"Konto gesperrt" fehl.

## Fehlerfall
Wenn **Sperren** nicht angezeigt wird: Prüfen Sie Ihre Rolle.
Entsperren Sie ein versehentlich gesperrtes Konto über **Entsperren**.
```

Die Lösung erfüllt die Kriterien: eine Handlung pro Schritt, Bedienelemente fett, erwartetes Ergebnis in Schritt 4, Prüfung, Fehlerfall mit Rückweg. Beachten Sie, dass die Schritte keine Erklärungen enthalten: Warum Sperren statt Löschen sinnvoll ist, gehörte in ein eigenes Concept.

**Lösung zu Aufgabe 6.** Eine mögliche Lösung:

```python
import re, sys

for nr, zeile in enumerate(open(sys.argv[1], encoding="utf-8"), 1):
    if re.search(r"(?<![A-Za-zäöüÄÖÜß-])Sicherung\b", zeile):
        print(nr, zeile.strip())
```

Der Ausdruck `(?<!...)` ist ein negativer Lookbehind: Er verlangt, dass vor dem Wort kein Buchstabe oder Bindestrich steht. Dadurch wird „Datensicherung“ nicht gemeldet, „die Sicherung“ schon. Das Beispiel zeigt, warum man Terminologiesuchen sorgfältig entwirft: Eine naive Suche nach dem Wort würde viele Fehlalarme liefern.

**Lösung zu Aufgabe 7.** Zusätzliche Regel im Wörterbuch `MUSTER`, etwa als eigene Prüfung:

```text
text = open(sys.argv[1], encoding="utf-8").read()
if re.search(r"\b\d+\s*MB\b", text) and re.search(r"\b\d+\s*GB\b", text):
    print("Hinweis: MB und GB im selben Dokument, Umrechnung prüfen")
```

Das Qualitätsrisiko: Wenn ein Dokument Größen in verschiedenen Einheiten nennt, werden sie leicht verwechselt oder falsch umgerechnet (außerdem gibt es die Unterscheidung zwischen Dezimal- und Binärpräfixen, etwa GB und GiB). Eine Regel „eine Einheit pro Größe“ im Styleguide ist die bessere Lösung. Die Skriptregel ist eine Beobachtungshilfe: Sie liefert Verdachtsfälle, aber keine Urteile.

**Lösung zu Aufgabe 8.** Die Auswertung zeigt, dass die Probleme überwiegend in Handlungsanweisungen und Terminologie liegen. Schritt 1 (Handlung, 40 Prozent): Eine Vorlage für Runbooks mit festen Feldern (Voraussetzung, Schritt, erwartetes Ergebnis, Fehlerfall) einführen und eine halbstündige Schulung für alle Autoren anbieten. Erfolgskriterium: Anteil der Kommentare der Kategorie „Handlung“ sinkt in drei Monaten um die Hälfte. Schritt 2 (Terminologie, 30 Prozent): Ein Glossar mit den 30 häufigsten Begriffen anlegen, Verantwortlichen benennen und eine automatische Prüfung auf verbotene Synonyme in die Review-Pipeline einbauen. Erfolgskriterium: Pipeline meldet keine verbotenen Begriffe in neu freigegebenen Dokumenten. Schritt 3 (Eindeutigkeit und Stil, 30 Prozent): Praxistest als Teil der Freigabe für alle Runbooks der Stufe A: Jemand außerhalb des Autorenteams führt die Anleitung auf einem Testsystem aus. Erfolgskriterium: Beschwerden der Betriebsmitarbeitenden gehen zurück, gemessen an einer kurzen Umfrage vor und nach der Maßnahme. Zusätzlich sollte begründet werden, warum man diese Reihenfolge wählt: Die größten Kategorien zuerst, weil dort die Wirkung am größten ist.
