# Modul 02 - Dokumentationsstrategie und Zielbild

> **Hinweis zu diesem Kapitel:** Das ist das Kapitel des Skripts „Technische Dokumentation und Dokumentations-Governance“, aus der LaTeX-Quelle in Markdown umgewandelt (Text und Listings unverändert, farbige Boxen als Zitatblöcke mit fettem Titel, Tabellen als Markdown-Tabellen, Übungsaufgaben und Lösungen als Absätze). Die Lerneinheiten sind wie in der Quelle nach Modul nummeriert (2.1 bis 2.8), danach folgen „Übungsaufgaben“ (8 Aufgaben) und „Lösungen und Erläuterungen“. Die Sprachangabe der Codeblöcke ist in der Quelle nur für Python und Bash gesetzt; die übrigen Blöcke sind hier nach ihrem Inhalt als `python`, `yaml`, `markdown`, `bash` oder `text` ausgezeichnet, der Inhalt selbst ist unverändert. **Prüfstand der Beispiele für dieses Repository:** Die Python-Beispiele wurden auf Syntax geprüft; welche Beispiele ausgeführt wurden und welche zusätzlich PyYAML brauchen, steht in der [README des Repositories](../README.md). Übersicht zum Modul: [README](README.md).

**Dauer:** 8,75 Stunden | **Priorität:** 1 | **Lerneinheiten:** 8

| **Nr.** | **Lerneinheit**           | **Dauer (h)** | **Prio** |
|--------:|:--------------------------|--------------:|---------:|
|       1 | Dokumentationsstrategie   |          1,25 |        1 |
|       2 | Zielgruppenanalyse        |          1,25 |        1 |
|       3 | Dokumentationszweck       |             1 |        1 |
|       4 | Scope und Abgrenzung      |             1 |        1 |
|       5 | Betriebsmodell            |             1 |        1 |
|       6 | Dokumentationsprinzipien  |             1 |        2 |
|       7 | Erfolgskriterien          |             1 |        2 |
|       8 | Strategie-Troubleshooting |          1,25 |        2 |
|         | **Summe**                 |      **8,75** |          |

## 2.1 Dokumentationsstrategie

Eine Dokumentationsstrategie beantwortet die Frage, *warum, für wen, in welchem Umfang und mit welchen Mitteln* eine Organisation dokumentiert. Sie ist der Plan, der verhindert, dass Dokumentation zufällig entsteht, nach Lust und Laune der Beteiligten. Ohne Strategie sammelt sich meist viel von dem an, was Autoren gern schreiben (Beschreibungen fertiger Funktionen), und wenig von dem, was Leser dringend brauchen (Wiederherstellung nach Ausfällen, Entscheidungsgründe, Übergaben).

Das Wort „Strategie“ klingt groß, doch eine brauchbare Dokumentationsstrategie passt zunächst auf zwei Seiten. Sie enthält sechs Bestandteile. Die *Vision* beschreibt in einem Satz den Soll-Zustand („Jedes produktive System kann von einem fachkundigen Kollegen ohne Rückfrage betrieben und wiederhergestellt werden“). Der *Zweck* begründet, welche Probleme gelöst werden. Die *Zielgruppen* legen fest, für wen geschrieben wird. Der *Scope* grenzt ab, was dokumentiert wird und was nicht. Das *Betriebsmodell* regelt Rollen, Prozesse und Werkzeuge. Die *Erfolgskriterien* machen den Fortschritt messbar. Jeder dieser Bestandteile wird in den folgenden Abschnitten dieses Moduls behandelt; hier geht es um das Zusammenspiel.

Der Weg zur Strategie verläuft in fünf Schritten. Zuerst wird die *Ausgangslage* erhoben: Welche Dokumente gibt es, wo liegen sie, wer nutzt sie, wo hakt es? Dann folgt die *Zielbildformulierung*, die den gewünschten Zustand beschreibt. Aus dem Abstand zwischen beiden ergibt sich die *Lückenanalyse*. Darauf baut die *Maßnahmenplanung* auf, die priorisierte Schritte mit Verantwortlichen festlegt. Schließlich werden *Review-Termine* gesetzt, an denen die Strategie überprüft und angepasst wird. Gerade der letzte Punkt wird gern vergessen, obwohl sich Systeme, Teams und Anforderungen verändern.

Als praktisches Hilfsmittel eignet sich ein *Strategie-Canvas*, eine einseitige Übersicht, die man im Team ausfüllt. Das Beispiel zeigt ihn als YAML-Datei. YAML ist hier sinnvoll, weil das Dokument versioniert werden kann und gleichzeitig maschinell auswertbar bleibt.

```yaml
strategie:
  version: 1.0
  stand: 2026-10-28
  vision: >
    Jedes produktive System kann von einer fachkundigen Person
    ohne Rückfrage betrieben und wiederhergestellt werden.
  probleme:
    - Wissen steckt in Köpfen einzelner Administratoren
    - Runbooks sind veraltet oder unauffindbar
    - Audits decken fehlende Nachweise auf
  zielgruppen: [betrieb, entwicklung, audit, management]
  scope:
    enthalten: [produktive Systeme, Prozesse mit Kundenbezug]
    ausgeschlossen: [private Notizen, Prototypen ohne Betrieb]
  betriebsmodell: hybrid   # zentrale Standards, dezentrale Pflege
  erfolgskriterien:
    - Alle kritischen Systeme haben ein geprüftes Runbook
    - Aktualitätsquote über 90 Prozent
  naechste_review: 2027-04-28
```

Das Feld `vision` ist als Fließtext mit `>` geschrieben, was in YAML mehrzeiligen Text zu einer Zeile zusammenfasst. Die Listen unter `probleme` erzwingen konkrete Beschreibung statt Allgemeinplätze. `scope` nennt ausdrücklich, was *nicht* dokumentiert wird, denn Abgrenzung ist eine Entscheidung und gehört in den Text. Das Feld `naechste_review` zeigt, dass die Strategie selbst einem Lebenszyklus unterliegt.

Typische Fehler: Strategien, die aus Wunschlisten bestehen und keine Entscheidungen enthalten. Strategien ohne Verantwortlichen, die im Ordner vergilben. Und Strategien, die zu groß ausfallen, sodass kein Team sie umsetzen kann. Das folgende Gegenüber verdeutlicht den Unterschied zwischen einer Wunschformulierung und einer entscheidungsfähigen Aussage.

| **Falsch**                                                     | **Richtig**                                                                                                                                                                   |
|:---------------------------------------------------------------|:------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| „Wir wollen alles gut dokumentieren und immer aktuell halten.“ | „Wir dokumentieren zuerst die zehn kritischsten Systeme, mit Runbook, Architekturübersicht und Konfigurationsreferenz, bis Ende Q2. Alle anderen Systeme folgen nach Risiko.“ |

Im Projektalltag begegnet Ihnen die Strategie als die Rückfrage „Warum machen wir das eigentlich?“, die in jedem Dokumentationsprojekt irgendwann gestellt wird. Wer eine schriftlich festgehaltene Antwort hat, spart sich lange Diskussionen.

> **Ergänzung aus der Nachrecherche**
>
> Docs as Code (Write the Docs): Laut der Seite von Write the Docs bedeutet der Ansatz, Dokumentation mit denselben Werkzeugen wie Code zu erstellen: Issue Tracker, Versionskontrolle (Git), Auszeichnungssprachen in Klartext wie Markdown, reStructuredText oder AsciiDoc, Code Reviews und automatisierte Tests. Dokumentationsarbeit wird dabei in das Produktteam integriert, und Schreibende und Entwickelnde teilen die Verantwortung. Als Vorteil wird unter anderem genannt, dass neue Features blockiert werden können, solange keine Dokumentation vorliegt. Für die Strategie heißt das: Die Entscheidung „Docs as Code ja oder nein“ ist eine strategische Weichenstellung. (Abruf 28.10.2026, siehe Quellenverzeichnis.)

## 2.2 Zielgruppenanalyse

In Modul 01 haben Sie die Zielgruppenanalyse als Grundidee kennengelernt. Hier vertiefen wir sie zu einer Methode, mit der sich Zielgruppen belastbar bestimmen und in Entscheidungen übersetzen lassen. Der Ausgangspunkt ist, dass Vermutungen über Leser erstaunlich oft danebenliegen. Autoren schließen von sich auf andere, und Fachbereiche formulieren ihre Wünsche anders, als sie später arbeiten. Eine gute Analyse stützt sich deshalb auf Beobachtung und Daten statt auf Bauchgefühl.

Fünf Quellen liefern Erkenntnisse. *Interviews* mit Vertretern jeder Gruppe klären Ziele, Vorwissen und Probleme. *Beobachtung* bei der Arbeit zeigt, was Menschen tatsächlich tun und wo sie Dokumentation suchen, öffnen oder umgehen. *Supporttickets und Rückfragen* dokumentieren, was heute fehlt: Jede wiederkehrende Frage ist ein Hinweis auf eine Lücke. *Nutzungsdaten* (Zugriffszahlen, Suchbegriffe ohne Treffer) zeigen objektiv, was gelesen wird und wonach vergeblich gesucht wird. *Umfragen* erreichen viele Personen schnell, liefern aber nur das, was Befragte formulieren können. Ein sinnvoller Mix kombiniert mindestens zwei dieser Quellen.

Aus den Ergebnissen entstehen *Personas* (siehe Modul 01) und eine *Informationsbedarfsmatrix*. Diese Matrix ordnet jeder Zielgruppe die Dokumentarten zu, die sie braucht, mit einer Priorität. Sie hat zwei Vorteile: Sie macht Lücken sichtbar (eine Zielgruppe ohne passendes Dokument) und Überangebote (Dokumente ohne Zielgruppe). Ein weiteres nützliches Konzept sind *Jobs to be done*: Statt zu fragen, wer jemand ist, fragt man, welche Aufgabe die Person gerade erledigen will. „Ich muss das Zertifikat erneuern“ beschreibt den Bedarf präziser als „Ich bin Administrator“.

Das folgende Skript wertet eine solche Informationsbedarfsmatrix aus und zeigt, welche Zielgruppen keine hoch priorisierte Dokumentation haben. Die Matrix liegt als CSV vor: Pro Zeile eine Zielgruppe, ein benötigtes Dokument, die Priorität (1 hoch bis 3 niedrig) und ob das Dokument existiert.

```text
zielgruppe;dokument;prioritaet;vorhanden
Betrieb;Runbook Neustart;1;ja
Betrieb;Notfallkontakte;1;nein
Entwicklung;Architekturübersicht;1;ja
Entwicklung;Setup-Anleitung;2;nein
Audit;Freigabenachweis;1;nein
Management;Quartalsbericht;3;ja
```

```python
import csv
from collections import defaultdict

luecken = defaultdict(list)
with open("bedarf.csv", encoding="utf-8", newline="") as f:
    for z in csv.DictReader(f, delimiter=";"):
        if z["prioritaet"] == "1" and z["vorhanden"] != "ja":
            luecken[z["zielgruppe"]].append(z["dokument"])

for gruppe, dokumente in sorted(luecken.items()):
    print(gruppe + ":", ", ".join(dokumente))
```

Das Skript liest die Matrix und sammelt in einem `defaultdict` (einem Wörterbuch, das für unbekannte Schlüssel automatisch eine leere Liste anlegt) alle Dokumente, die höchste Priorität haben, aber fehlen. Die Ausgabe ist die Arbeitsliste für die nächsten Wochen: Für den Betrieb fehlen die Notfallkontakte und für das Audit der Freigabenachweis. Genau diese Ausgabe ist der Gegenwert der Analyse: Sie begründet, was zuerst geschrieben wird.

Ein häufiger Fehler ist das Befragen nur der Vorgesetzten, die Dokumentation „bestellen“, aber nicht lesen. Ebenso verbreitet ist die Gleichsetzung von „Zielgruppe“ mit „Abteilung“: Innerhalb einer Abteilung können Einsteiger und erfahrene Spezialisten völlig verschiedene Bedürfnisse haben. Schließlich wird die Analyse oft einmalig durchgeführt, obwohl sich Zielgruppen ändern.

| **Falsch**                                                      | **Richtig**                                                                                                                       |
|:----------------------------------------------------------------|:----------------------------------------------------------------------------------------------------------------------------------|
| Umfrage an die Teamleiter: „Welche Dokumente braucht Ihr Team?“ | Zwei Mitarbeitende pro Gruppe bei einer typischen Aufgabe beobachten und die zehn häufigsten Suchbegriffe ohne Treffer auswerten. |

Im Projekt lohnt es sich, die Matrix als lebendes Dokument zu führen und bei jeder Review der Strategie zu aktualisieren. Sie dient zugleich als Argumentationshilfe gegenüber dem Management: Die fehlenden Dokumente sind keine Meinung, sondern eine Liste.

> **Praxisbeispiel**
>
> Zählen Sie in einem Monat die Fragen, die Ihr Betriebsteam im Chat stellt. Die fünf häufigsten sind meist die fünf wichtigsten fehlenden Dokumente.

## 2.3 Dokumentationszweck

Jedes Dokument braucht einen Zweck, und jede Dokumentation braucht einen Gesamtzweck. Wer den Zweck nicht benennen kann, schreibt in der Regel zu viel oder das Falsche. Der Zweck beantwortet die Frage: *Was soll nach der Lektüre möglich sein, was vorher nicht möglich war?* Er ist damit ein Handlungs- oder Verständnisziel des Lesers, nicht eine Beschreibung des Textes.

Man unterscheidet Zwecke auf drei Ebenen. Auf der *Organisationsebene* dient Dokumentation Betriebssicherheit, Nachweisfähigkeit, Wissenssicherung und Effizienz (siehe Modul 01). Auf der *Bestandsebene* erfüllt jede Dokumentenart eine Funktion; ein Runbook ermöglicht die Wiederherstellung, eine Architekturübersicht ermöglicht das Verständnis, ein Freigabenachweis ermöglicht die Prüfung. Auf der *Dokumentebene* hat jedes einzelne Dokument ein konkretes Leseziel. Je konkreter der Zweck, desto leichter lässt sich entscheiden, was hineingehört: Alles, was dem Zweck dient, bleibt, alles andere geht in ein anderes Dokument oder entfällt.

Ein bewährtes Werkzeug ist der *Zweckstempel*, ein Satz am Anfang des Dokuments nach dem Muster „Dieses Dokument ermöglicht \[Zielgruppe\], \[Tätigkeit\], wenn \[Anlass\]“. Ein Beispiel: „Dieses Dokument ermöglicht Bereitschaftsdiensten, den Shop-Dienst nach einem Ausfall wieder in Betrieb zu nehmen.“. Dieser eine Satz wirkt in beide Richtungen: Der Autor erkennt, was er schreiben muss, und der Leser erkennt in Sekunden, ob er richtig ist. Das folgende Skript prüft in einem Dokumentenverzeichnis, ob jeder Text einen solchen Zweckstempel enthält.

```python
import pathlib, re, sys

muster = re.compile(r"^\*\*Zweck:\*\* Dieses Dokument ermöglicht .+", re.M)
fehlend = []

for datei in pathlib.Path(sys.argv[1]).rglob("*.md"):
    if not muster.search(datei.read_text(encoding="utf-8")):
        fehlend.append(str(datei))

for f in fehlend:
    print("Kein Zweckstempel:", f)
print(len(fehlend), "Datei(en) ohne Zweck")
sys.exit(1 if fehlend else 0)
```

Der Ausdruck verlangt, dass der Text mit `**Zweck:**` beginnt und mit der Formulierung „Dieses Dokument ermöglicht“ fortfährt. Die Schleife durchsucht alle Markdown-Dateien. Dass der Zweck nach einem festen Satzmuster geschrieben wird, ist Absicht: Es zwingt zur Konkretion und verhindert Floskeln wie „Dieses Dokument beschreibt das System“, die zwar grammatisch einen Zweck vortäuschen, aber keine Handlung beschreiben.

Typische Fehler: Der Zweck wird als Inhaltsangabe formuliert („Dieses Dokument enthält Informationen zu...“), statt als Leseziel. Außerdem werden mehrere Zwecke vermischt, etwa die Beschreibung eines Systems und gleichzeitig die Betriebsanleitung. Und schließlich wird der Zweck beim Überarbeiten vergessen, sodass sich Dokumente im Laufe der Zeit vom ursprünglichen Ziel entfernen.

| **Falsch**                                             | **Richtig**                                                                                                               |
|:-------------------------------------------------------|:--------------------------------------------------------------------------------------------------------------------------|
| „Dieses Dokument enthält Informationen zur Datenbank.“ | „Dieses Dokument ermöglicht Administratoren, die Datenbank nach einem Datenverlust aus der Sicherung wiederherzustellen.“ |

Im Projekt zeigt sich der Wert des Zwecks bei Reviews: Wenn Reviewer über Inhalte streiten, hilft der Blick auf den Zweckstempel. Was ihm dient, bleibt; was ihn verwässert, wird ausgelagert.

## 2.4 Scope und Abgrenzung

Der *Scope* legt fest, welche Systeme, Prozesse, Organisationseinheiten und Dokumentarten von der Dokumentations-Governance erfasst werden und welche ausdrücklich nicht. Ohne diese Abgrenzung wird Dokumentation entweder uferlos (alles muss dokumentiert werden, also wird nichts fertig) oder beliebig (jeder entscheidet selbst, wann es sich lohnt). Ein klarer Scope ist deshalb eine Schutzmaßnahme für beide Seiten: Die Dokumentierenden wissen, wo ihre Pflicht endet, und die Nutzer wissen, wo sie sich auf Dokumentation verlassen dürfen.

Die Abgrenzung erfolgt in drei Dimensionen. Die *inhaltliche Dimension* bestimmt, welche Gegenstände dokumentiert werden (Systeme, Schnittstellen, Prozesse, Entscheidungen). Die *organisatorische Dimension* bestimmt, welche Bereiche und Teams einbezogen sind. Die *Tiefen-Dimension* bestimmt, wie ausführlich dokumentiert wird, und hier ist das Prinzip der *risikobasierten Abstufung* zentral. Ein System, dessen Ausfall das Unternehmen stillegt, braucht vollständige Dokumentation, ein Testsystem benötigt vielleicht nur eine Seite. Das spart Aufwand dort, wo er wenig bringt, und konzentriert ihn dort, wo er schützt.

Zur Einstufung eignet sich eine einfache Bewertung nach Kritikalität (wie schlimm ist der Ausfall?), Änderungshäufigkeit (wie oft ändert sich das System?) und Anzahl der betroffenen Personen. Das nachfolgende Skript berechnet aus drei Bewertungen von 1 bis 3 eine Dokumentationsstufe. Es ist ein Beispiel dafür, wie man eine Scope-Entscheidung transparent und nachvollziehbar macht.

```python
def stufe(kritikalitaet, aenderung, nutzer):
    punkte = 2 * kritikalitaet + aenderung + nutzer
    if punkte >= 9:
        return "A: vollständig (Runbook, Architektur, Konfiguration, Review)"
    if punkte >= 6:
        return "B: Standard (Runbook und Übersicht)"
    return "C: minimal (Kurzbeschreibung mit Owner)"

systeme = {
    "Shop-Backend":   (3, 3, 3),
    "Intranet-Wiki":  (2, 1, 3),
    "Testserver":     (1, 2, 1),
}
for name, werte in systeme.items():
    print(f"{name:15s} {stufe(*werte)}")
```

Die Funktion gewichtet die Kritikalität doppelt, weil sie das wichtigste Kriterium ist. Mit den Beispielwerten ergibt das Shop-Backend 12 Punkte (Stufe A), das Intranet-Wiki 8 Punkte (Stufe B) und der Testserver 5 Punkte (Stufe C). Die Schwellenwerte sind Beispielwerte und müssen organisationsspezifisch festgelegt werden. Wichtig ist die Logik: Der Scope ist keine pauschale Ja-Nein-Entscheidung, sondern eine Abstufung mit nachvollziehbarer Begründung.

Typische Fehler: Das Weglassen der Abgrenzung („alles“), die Abgrenzung nach Gefühl statt nach Risiko, und fehlende Dokumentation der Ausnahmen. Besonders heikel sind Systeme, die „nur kurz“ gebaut wurden und zehn Jahre laufen; sie rutschen durch jede Abgrenzung und werden zu Wissensinseln.

| **Falsch**                                                                      | **Richtig**                                                                                                                                                    |
|:--------------------------------------------------------------------------------|:---------------------------------------------------------------------------------------------------------------------------------------------------------------|
| „Alle Systeme werden dokumentiert.“ (ohne Priorität, ohne Ausnahme, ohne Tiefe) | „Systeme der Stufe A werden vollständig, Stufe B nach Standard, Stufe C minimal dokumentiert. Nicht erfasst sind private Notizen und Prototypen ohne Betrieb.“ |

Im Projekt tritt die Scope-Frage spätestens beim Budget auf: „Wie viel Dokumentation ist genug?“ Die Stufen liefern die Antwort in einer Form, die sich begründen und prüfen lässt.

## 2.5 Betriebsmodell

Das Betriebsmodell beschreibt, *wer* Dokumentation *wie* erstellt, pflegt und steuert, und mit welchen Werkzeugen. Es übersetzt die Strategie in Organisation. Drei Grundformen sind verbreitet. Im *zentralen Modell* schreibt und pflegt eine Redaktion die Dokumente. Der Vorteil ist Einheitlichkeit, der Nachteil ist die Entfernung vom Fachwissen und der Flaschenhals bei Änderungen. Im *dezentralen Modell* dokumentieren die Fachteams selbst. Das bringt Nähe zum Wissen und Geschwindigkeit, aber ohne Regeln entstehen uneinheitliche Ergebnisse. Im *hybriden Modell* setzt eine zentrale Stelle Standards, Vorlagen und Werkzeuge, während die Teams ihre Dokumente selbst pflegen. Für die meisten IT-Organisationen ist das hybride Modell der beste Kompromiss.

Neben der Aufbauorganisation gehört zum Betriebsmodell der *Prozess*: Wie wird Dokumentation angestoßen (durch Änderungen, Projekte, Störungen), wie läuft Review und Freigabe, wie werden Pflege und Archivierung gesteuert? Dazu kommen die *Werkzeuge*: Wiki, Dokumentenmanagementsystem, Git-Repository, Ticketsystem (Details in Modul 12). Ein häufig unterschätzter Teil ist das *Zeitbudget*. Dokumentation, für die keine Zeit eingeplant ist, wird nicht geschrieben. Das Betriebsmodell sollte daher benennen, wie viel Aufwand pro Aufgabe eingeplant wird; eine gängige Praxis ist, Dokumentation als Teil der *Definition of Done* zu verstehen, sodass eine Änderung erst als abgeschlossen gilt, wenn die zugehörige Dokumentation angepasst wurde.

Dass sich dies automatisieren lässt, zeigt die folgende Pipeline-Konfiguration. Sie ist als Beispiel für ein Docs-as-Code-Betriebsmodell gedacht und prüft bei jeder Änderung am Repository, ob alle Markdown-Dokumente einen Metadatenblock haben. Die Syntax entspricht GitHub Actions; ähnliche Konzepte bieten andere CI-Systeme.

```yaml
name: doku-pruefung
on:
  pull_request:
    paths: ["doku/**"]

jobs:
  pruefen:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Metadatenblock vorhanden?
        run: |
          fehlt=0
          for f in $(find doku -name "*.md"); do
            if ! head -1 "$f" | grep -q '^---$'; then
              echo "Metadaten fehlen: $f"
              fehlt=1
            fi
          done
          exit $fehlt
```

Die Konfiguration löst den Job nur aus, wenn sich Dateien unter `doku/` ändern (`paths`). Der Schritt `checkout` holt den Code, der folgende Schritt prüft mit einer Schleife jede Markdown-Datei: Beginnt die erste Zeile nicht mit `---`, wird die Datei gemeldet und der Job schlägt fehl. Damit wird eine Regel des Betriebsmodells („jedes Dokument hat Metadaten“) automatisch durchgesetzt, ohne dass jemand kontrollieren muss.

Typische Fehler: Ein Betriebsmodell, das nur auf Freiwilligkeit setzt („wer Zeit hat, dokumentiert“), ein zentrales Modell ohne Fachwissen und ein dezentrales Modell ohne Standards. Zu den häufigsten gehört auch, das Modell nicht an die Größe der Organisation anzupassen.

| **Falsch**                                                        | **Richtig**                                                                                                                                                                                                                        |
|:------------------------------------------------------------------|:-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| „Dokumentation machen wir nebenbei, wenn nichts anderes anliegt.“ | „Jede Änderung enthält die Anpassung der betroffenen Dokumente (Teil der Definition of Done). Für Dokumentationsaufgaben sind zehn Prozent der Teamkapazität eingeplant.“ (Zahl als Beispiel, organisationsspezifisch festzulegen) |

Im Projekt entscheidet das Betriebsmodell, ob die Strategie lebt. Die detaillierte Ausgestaltung der Rollen folgt in Modul 06.

## 2.6 Dokumentationsprinzipien

Prinzipien sind Leitlinien, die in Situationen helfen, die keine Regel vorhersieht. Sie sind kürzer und allgemeiner als Standards und ermöglichen es Teams, im Zweifel selbständig richtig zu entscheiden. Eine Organisation, die ihre Dokumentationsprinzipien kennt, braucht weniger Einzelanweisungen, weil Menschen aus dem Prinzip die Regel ableiten können.

Sieben Prinzipien haben sich bewährt. *Zielgruppenorientierung*: Jedes Dokument wird für eine benannte Zielgruppe geschrieben. *Eine Quelle der Wahrheit*: Informationen werden an genau einer Stelle gepflegt, sonst wird verlinkt. *So viel wie nötig, so wenig wie möglich*: Dokumentation muss ihren Zweck erfüllen und darüber hinaus keinen Ballast tragen. *Nähe zum Gegenstand*: Dokumentation liegt dort, wo sie gebraucht und gepflegt wird, etwa technische Beschreibung im Repository des Systems. *Nachvollziehbarkeit*: Jedes Dokument zeigt Owner, Stand, Version und Status. *Pflege vor Neuerstellung*: Bestehende Dokumente werden aktualisiert, bevor neue entstehen. *Sicherheit by Default*: Sensible Informationen werden gar nicht erst in offene Dokumente geschrieben.

Dazu passt ein ergänzender Blick auf die Struktur. Das Diátaxis-Modell (vorgestellt in einem Canonical-Beitrag von Daniele Procida) formuliert ein Prinzip, das für die Aufteilung von Inhalten hilft: Jeder Dokumenttyp hat genau einen Zweck und sollte von den anderen getrennt sein (siehe Modul 01). Auch der Google Developer Documentation Style Guide enthält Prinzipien, die sich übertragen lassen.

> **Ergänzung aus der Nachrecherche**
>
> Google Developer Documentation Style Guide, Highlights: Laut der abgerufenen Seite empfiehlt der Leitfaden unter anderem, in der zweiten Person zu schreiben („you“ statt „we“), aktiv zu formulieren, Bedingungen vor Anweisungen zu nennen, nummerierte Listen für Abläufe und Aufzählungslisten für die meisten übrigen Listen zu nutzen, Code-bezogenen Text in Code-Schrift und UI-Elemente fett zu setzen, eindeutige Datumsformate zu verwenden und Bilder mit Alternativtext zu versehen. Diese Punkte sind für englische Texte formuliert, zeigen aber auf, wie konkrete Prinzipien aussehen. (Abruf 28.10.2026, siehe Quellenverzeichnis.)

Damit Prinzipien nicht zu Sonntagsreden werden, sollten sie in Prüfpunkte übersetzt werden. Das folgende Beispiel zeigt eine Checkliste, die ein Reviewer in der Praxis durchgeht. Sie ist als Markdown-Aufgabenliste geschrieben und lässt sich unmittelbar in jedes Pull-Request-Template einfügen.

```markdown
## Review-Checkliste Dokumentationsprinzipien
- [ ] Zielgruppe und Zweck stehen am Anfang
- [ ] Keine Kopien: Fremde Inhalte sind verlinkt
- [ ] Nichts Überflüssiges: jeder Abschnitt dient dem Zweck
- [ ] Owner, Stand, Version und Status im Kopf
- [ ] Bestehendes Dokument aktualisiert statt neues angelegt
- [ ] Keine Zugangsdaten, keine privaten Daten
```

Jede Zeile entspricht einem Prinzip und ist als Ja-Nein-Frage formuliert, sodass sie sich schnell abhaken lässt. Der Mehrwert liegt darin, dass die Prinzipien im Alltag sichtbar werden: Wer jeden Review mit denselben sechs Fragen beginnt, verinnerlicht sie nach wenigen Wochen.

Typische Fehler: Prinzipien werden formuliert, aber nirgends angewendet, oder sie sind so allgemein („Dokumentation soll gut sein“), dass sie nichts entscheiden. Besser sind Prinzipien, die man im Streitfall zitieren kann und die eine Handlung nahelegen.

| **Falsch**                                       | **Richtig**                                                                                                          |
|:-------------------------------------------------|:---------------------------------------------------------------------------------------------------------------------|
| Prinzip: „Dokumentation soll verständlich sein.“ | Prinzip: „Jedes Dokument nennt am Anfang Zielgruppe und Zweck. Was dem nicht dient, gehört in ein anderes Dokument.“ |

Im Projekt helfen Prinzipien bei Neuerungen: Wenn ein neues Werkzeug eingeführt wird, fragt man, ob es „eine Quelle der Wahrheit“ fördert oder zusätzliche Kopien erzeugt.

## 2.7 Erfolgskriterien

Woran erkennt man, dass die Dokumentationsstrategie wirkt? Erfolgskriterien machen Fortschritt messbar und helfen, Ressourcen zu rechtfertigen. Sie gehören zu den Teilen der Strategie, die am häufigsten fehlen, weil Dokumentationsqualität als „nicht messbar“ gilt. Das stimmt nur halb: Qualität im Ganzen lässt sich schwer messen, aber viele ihrer Ausprägungen sehr wohl.

Man unterscheidet *Ergebnis-Kriterien* (was ist erreicht?) und *Wirkungs-Kriterien* (was bewirkt es?). Ergebnis-Kriterien sind etwa die Abdeckung (wie viele kritische Systeme haben ein Runbook?), die Aktualitätsquote (wie viele Dokumente wurden innerhalb der Prüffrist geprüft?) und die Review-Quote (wie viele Dokumente wurden vor Freigabe geprüft?). Wirkungs-Kriterien sind etwa die Zahl wiederkehrender Rückfragen, die Einarbeitungszeit neuer Mitarbeitender, die Dauer von Störungen oder das Ergebnis von Audits. Eine ausgewogene Strategie nutzt beide Arten. Ergebnis-Kriterien sind leicht zu erheben und zeigen den Fortschritt, Wirkungs-Kriterien zeigen, ob der Fortschritt etwas bringt.

Bei der Formulierung hilft das SMART-Schema: Ein Kriterium soll spezifisch, messbar, erreichbar, relevant und terminiert sein. „Bessere Dokumentation“ ist keines davon, „Bis Ende Q2 haben alle Systeme der Stufe A ein geprüftes Runbook“ erfüllt alle fünf. Das nachfolgende Skript wertet aus einer Bestandsdatei Abdeckung und Aktualitätsquote aus.

```text
system;stufe;runbook;geprueft_bis
shop;A;ja;2027-02-01
db;A;ja;2026-06-01
wiki;B;nein;
test;C;nein;
```

```python
import csv
from datetime import date

heute = date.today()
a_gesamt = a_mit = geprueft = 0

with open("bestand.csv", encoding="utf-8", newline="") as f:
    for z in csv.DictReader(f, delimiter=";"):
        if z["stufe"] != "A":
            continue
        a_gesamt += 1
        if z["runbook"] == "ja":
            a_mit += 1
            if z["geprueft_bis"] and date.fromisoformat(z["geprueft_bis"]) >= heute:
                geprueft += 1

print(f"Abdeckung Stufe A: {a_mit}/{a_gesamt}")
print(f"Aktuell geprüft:   {geprueft}/{a_gesamt}")
```

Das Skript betrachtet nur Systeme der Stufe A, weil dort die Zielvorgabe gilt. Es zählt, wie viele ein Runbook haben und bei wie vielen das Prüfdatum noch nicht überschritten ist. Mit der Beispieldatei und einem Ausführungsdatum im Oktober 2026 liefert es eine Abdeckung von 2 von 2 und einen aktuell geprüften Stand von 1 von 2, denn das Prüfdatum der Datenbank (Juni 2026) ist abgelaufen. Das Beispiel zeigt nebenbei, dass Abdeckung allein täuscht: Ein Runbook, das existiert, aber überfällig ist, zählt nur zur Hälfte.

Typische Fehler: Man misst, was leicht messbar ist (Seitenzahl, Anzahl Dokumente), statt was wichtig ist. Eine hohe Dokumentenzahl sagt nichts über Qualität. Ebenso verbreitet ist die Neigung, Kennzahlen als Kontrollinstrument gegen Einzelne zu nutzen, wodurch sie manipuliert werden. Sie sollten als Frühwarnsystem für das System gelten, nicht als Leistungsbewertung. Die ausführliche Behandlung folgt in Modul 16.

| **Falsch**                                    | **Richtig**                                                                                                                                                      |
|:----------------------------------------------|:-----------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Erfolg: „Wir haben 400 Seiten Dokumentation.“ | Erfolg: „90 Prozent der Stufe-A-Systeme haben ein innerhalb der letzten 12 Monate geprüftes Runbook, und wiederkehrende Rückfragen sind um die Hälfte gesunken.“ |

Im Projekt sind Erfolgskriterien das Gegenargument bei Budgetkürzungen: Wer zeigen kann, welche Wirkung die Dokumentation hat, verteidigt sie leichter.

## 2.8 Strategie-Troubleshooting

Auch eine gute Strategie läuft in Probleme. Dieser Abschnitt zeigt, wie man typische Fehlerbilder systematisch eingrenzt, indem man die Hinweise aus Zielklarheit, Dokumentationsumfang, Ownern, Rollen, Standards, Metadaten, Freigaben, Aktualität, Berechtigungen, Auffindbarkeit und Nutzung prüft. Das Vorgehen entspricht der Methode aus Modul 01: Symptom erfassen, Ursachenfeld bestimmen, Gegenprobe durchführen, Maßnahme festlegen.

Die zehn Prüffelder lassen sich als Diagnosekette lesen. Beginnen Sie bei der *Zielklarheit*: Kann jeder Beteiligte in einem Satz sagen, wozu die Dokumentation dient? Erst wenn das stimmt, ist es sinnvoll, den *Umfang* zu betrachten: Ist klar, was dokumentiert wird? Dann folgen *Owner und Rollen*: Hat jedes Dokument einen verantwortlichen Menschen? Danach *Standards und Metadaten*: Sind Vorlagen und Pflichtfelder im Einsatz? Dann *Freigaben und Aktualität*: Werden Dokumente geprüft und innerhalb der Fristen überarbeitet? Schließlich *Berechtigungen, Auffindbarkeit und Nutzung*: Dürfen die richtigen Personen zugreifen, finden sie das Dokument, und nutzen sie es? Die Reihenfolge ist deshalb sinnvoll, weil spätere Probleme oft Folgen früherer sind: Wo das Ziel unklar ist, helfen auch die besten Metadaten nicht.

Das nächste Beispiel automatisiert einen Teil der Diagnose. Das Skript liest eine Bestandsliste mit Metadaten und gibt für jedes Prüffeld die Zahl der Auffälligkeiten aus. So entsteht ein „Gesundheitscheck“ für die Strategie, an dem man ablesen kann, auf welcher Stufe das Problem liegt.

```text
titel;owner;status;geprueft;zugriff
Runbook Shop;Team A;freigegeben;2026-09-01;intern
Runbook DB;;freigegeben;2024-01-10;intern
Netzplan;Team B;entwurf;;offen
```

```python
import csv
from datetime import date, timedelta

grenze = date.today() - timedelta(days=365)
probleme = {"ohne Owner": 0, "nicht freigegeben": 0,
            "ohne Prüfdatum": 0, "überfällig": 0, "offener Zugriff": 0}

with open("bestand2.csv", encoding="utf-8", newline="") as f:
    for z in csv.DictReader(f, delimiter=";"):
        if not z["owner"]:
            probleme["ohne Owner"] += 1
        if z["status"] != "freigegeben":
            probleme["nicht freigegeben"] += 1
        if not z["geprueft"]:
            probleme["ohne Prüfdatum"] += 1
        elif date.fromisoformat(z["geprueft"]) < grenze:
            probleme["überfällig"] += 1
        if z["zugriff"] == "offen":
            probleme["offener Zugriff"] += 1

for name, anzahl in probleme.items():
    print(f"{name:20s} {anzahl}")
```

Das Skript legt für fünf Prüffelder Zähler an und durchläuft jede Zeile der Bestandsdatei. Ein fehlender Owner, ein Status außer „freigegeben“, ein fehlendes oder überfälliges Prüfdatum und ein offener Zugriff werden gezählt. Die Ausgabe ist die Grundlage für die Ursachenanalyse: Viele Dokumente ohne Owner deuten auf ein Rollenproblem, viele überfällige Dokumente auf ein Pflegeproblem. Wichtig ist die Gegenprobe: Zahlen zeigen, *dass* etwas nicht stimmt, nicht *warum*. Erst Gespräche mit den Beteiligten klären die Ursache.

Als Runbook für die Redaktion lässt sich das Ergebnis als Entscheidungshilfe ablegen. Bei fehlenden Ownern: Owner benennen, Vertretung festlegen, Eskalation an die Teamleitung. Bei überfälligen Dokumenten: Prüffrist und Erinnerung einführen, kritische Dokumente zuerst prüfen. Bei offenem Zugriff: Klassifizierung und Berechtigungen prüfen (siehe Modul 13). Bei Nichtnutzung: Auffindbarkeit und Zielgruppe prüfen (siehe Abschnitt Zielgruppenanalyse).

Typische Fehler: Man behandelt Symptome statt Ursachen, etwa durch „Aufräumaktionen“, und die Maßnahmen haben keine Verantwortlichen oder Termine. Außerdem wird die Strategie selbst selten hinterfragt: Wenn alle Maßnahmen scheitern, kann auch das Ziel unrealistisch sein.

| **Falsch**                                                               | **Richtig**                                                                                                                                                       |
|:-------------------------------------------------------------------------|:------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| „Die Doku ist veraltet, wir machen im Dezember einen Dokumentationstag.“ | „Die Auswertung zeigt 14 überfällige Dokumente ohne Owner. Owner werden bis Freitag benannt, dann erhält jeder Owner eine Frist von vier Wochen für die Prüfung.“ |

Im Projekt nutzen Sie diese Diagnose als regelmäßigen Check, beispielsweise vierteljährlich. So fallen Fehlentwicklungen früh auf, bevor sie im Audit sichtbar werden.

## Übungsaufgaben

Die Aufgaben steigen von Verständnisfragen über Anwendungsaufgaben bis zu Entwurfs- und Programmieraufgaben an. Lösen Sie zuerst selbständig, bevor Sie die Lösungen ansehen.

**Aufgabe 1.** *(leicht)* Nennen Sie die sechs Bestandteile einer Dokumentationsstrategie und erklären Sie in je einem Satz, welche Frage sie beantworten.

**Aufgabe 2.** *(leicht)* Ein Kollege sagt: „Unser Zweck ist, dass das Dokument alle Informationen zur Datenbank enthält.“ Warum ist das kein guter Zweck? Formulieren Sie ihn mit dem Zweckstempel neu.

**Aufgabe 3.** *(leicht bis mittel)* Ordnen Sie die Quellen Interview, Beobachtung, Supportticket-Analyse, Nutzungsdaten und Umfrage jeweils einer Stärke und einer Schwäche zu.

**Aufgabe 4.** *(mittel)* Erstellen Sie eine Informationsbedarfsmatrix (mindestens sechs Zeilen) für ein Team aus Betrieb, Entwicklung und Datenschutz und markieren Sie die Lücken.

**Aufgabe 5.** *(mittel, praktisch)* Erweitern Sie das Skript zur Dokumentationsstufe so, dass es zusätzlich eine vierte Bewertung (Schutzbedarf, 1 bis 3) mit doppeltem Gewicht berücksichtigt, und geben Sie die Stufen für drei selbst gewählte Systeme aus.

**Aufgabe 6.** *(mittel)* Vergleichen Sie zentrales, dezentrales und hybrides Betriebsmodell für ein Unternehmen mit 300 Beschäftigten und 12 Entwicklungsteams. Empfehlen Sie eines und begründen Sie die Empfehlung.

**Aufgabe 7.** *(anspruchsvoll, praktisch)* Schreiben Sie ein Skript, das aus der Bestandsdatei des Abschnitts Erfolgskriterien die Aktualitätsquote (Anteil geprüfter, nicht überfälliger Dokumente an allen Dokumenten mit Runbook) berechnet und als Prozentzahl ausgibt.

**Aufgabe 8.** *(anspruchsvoll, Transfer)* Ihre Auswertung zeigt: 60 Prozent der Dokumente haben keinen Owner, 40 Prozent sind überfällig und die Nutzung ist niedrig. Ermitteln Sie die wahrscheinlichste Ursachenkette und entwerfen Sie einen Maßnahmenplan mit Reihenfolge, Verantwortlichen und Erfolgskriterien.

## Lösungen und Erläuterungen

**Lösung zu Aufgabe 1.** Vision (Wie sieht der Soll-Zustand aus?), Zweck (Welche Probleme lösen wir?), Zielgruppen (Für wen schreiben wir?), Scope (Was dokumentieren wir und was nicht?), Betriebsmodell (Wer macht es wie, mit welchen Werkzeugen?) und Erfolgskriterien (Woran erkennen wir den Fortschritt?).

**Lösung zu Aufgabe 2.** Der Zweck ist eine Inhaltsangabe und kein Leseziel: Er nennt weder Leser noch Tätigkeit. Er führt zu uferlosen Dokumenten, weil jeder Zusatz „auch zur Datenbank gehört“. Neu formuliert: „Dieses Dokument ermöglicht Administratoren, Backups der Datenbank zu prüfen und bei Bedarf wiederherzustellen.“ Damit sind Zielgruppe, Tätigkeit und Anlass klar, und alles Weitere (etwa die Historie der Datenbank) gehört nicht hinein.

**Lösung zu Aufgabe 3.** Interview: Stärke ist die Tiefe (Motive, Probleme), Schwäche der Zeitaufwand und die Auswahlverzerrung. Beobachtung: Stärke ist, dass sie das tatsächliche Verhalten zeigt, Schwäche, dass sie nur wenige Fälle abdeckt und Beobachtete ihr Verhalten ändern können. Supportticket-Analyse: Stärke ist, dass sie reale Lücken belegt, Schwäche, dass sie nur zeigt, was gemeldet wird. Nutzungsdaten: Stärke ist die Objektivität und Menge, Schwäche, dass sie das Warum nicht erklären. Umfrage: Stärke ist die Reichweite, Schwäche, dass Antworten oberflächlich ausfallen und von der Fragestellung geprägt sind. Eine gute Analyse kombiniert deshalb quantitative Quellen (Nutzungsdaten, Tickets) mit qualitativen (Interview, Beobachtung).

**Lösung zu Aufgabe 4.** Eine mögliche Matrix:

```text
zielgruppe;dokument;prioritaet;vorhanden
Betrieb;Runbook Neustart;1;ja
Betrieb;Wiederherstellung Datenbank;1;nein
Entwicklung;Architekturübersicht;1;ja
Entwicklung;API-Referenz;2;ja
Datenschutz;Verzeichnis Verarbeitungstätigkeiten;1;nein
Datenschutz;Löschkonzept;2;nein
```

Lücken mit höchster Priorität: Wiederherstellung der Datenbank (Betrieb) und das Verzeichnis der Verarbeitungstätigkeiten (Datenschutz). Diese beiden sind zuerst zu schließen. Beachten Sie, dass die Matrix die Zielgruppe in den Mittelpunkt stellt: Ohne sie wäre die Entwicklung mit zwei Dokumenten gut versorgt, während der Datenschutz unbemerkt leer ausgeht.

**Lösung zu Aufgabe 5.** Eine mögliche Lösung:

```python
def stufe(krit, aenderung, nutzer, schutz):
    punkte = 2 * krit + aenderung + nutzer + 2 * schutz
    if punkte >= 12:
        return "A"
    if punkte >= 8:
        return "B"
    return "C"

systeme = {"Zahlungsdienst": (3, 2, 3, 3),
           "Kantine-App": (1, 2, 2, 1),
           "Personalakte": (2, 1, 1, 3)}
for name, w in systeme.items():
    print(name, stufe(*w))
```

Mit den Werten ergeben sich 17 Punkte (Zahlungsdienst, Stufe A), 8 Punkte (Kantine-App, Stufe B) und 12 Punkte (Personalakte, Stufe A). Da die Skala um eine zusätzliche, doppelt gewichtete Bewertung gewachsen ist, mussten die Schwellen angepasst werden: Beim alten Skript lag die Obergrenze bei 12 Punkten, jetzt bei 18. Die Schwellen sind Gestaltungsentscheidungen. Eine häufige Fehlerquelle ist, sie nicht mitzuziehen und dadurch alle Systeme in Stufe A zu rutschen.

**Lösung zu Aufgabe 6.** Das zentrale Modell würde bei zwölf Teams zum Flaschenhals und die Redaktion hätte nicht das Fachwissen. Das dezentrale Modell würde zu uneinheitlichen Ergebnissen und doppelten Quellen führen. Empfehlenswert ist das hybride Modell: Eine kleine zentrale Stelle (Redaktion oder Governance-Team) pflegt Standards, Templates, Werkzeuge und Berichte; die Teams schreiben und pflegen ihre Dokumente selbst als Teil der Definition of Done. Begründung: Nähe zum Wissen, Skalierbarkeit und gleichzeitig Konsistenz. Bonuspunkte für Hinweise auf Risiken (Überlastung der zentralen Stelle, fehlende Zeit in den Teams).

**Lösung zu Aufgabe 7.** Eine mögliche Lösung:

```python
import csv
from datetime import date

heute = date.today()
mit_runbook = aktuell = 0
with open("bestand.csv", encoding="utf-8", newline="") as f:
    for z in csv.DictReader(f, delimiter=";"):
        if z["runbook"] != "ja":
            continue
        mit_runbook += 1
        if z["geprueft_bis"] and date.fromisoformat(z["geprueft_bis"]) >= heute:
            aktuell += 1
quote = 100 * aktuell / mit_runbook if mit_runbook else 0
print(f"Aktualitätsquote: {quote:.0f} Prozent")
```

Das Skript zählt nur Systeme mit Runbook, weil nur für diese eine Aktualität definiert ist. Der Ausdruck `if mit_runbook else 0` verhindert eine Division durch null, falls kein Runbook existiert. Mit der Beispieldatei aus dem Abschnitt Erfolgskriterien (zwei Runbooks, davon eines aktuell) ergibt sich 50 Prozent.

**Lösung zu Aufgabe 8.** Die wahrscheinlichste Ursachenkette beginnt bei den Rollen: Ohne Owner gibt es niemanden, der Prüffristen einhält (Folge: Dokumente überfällig), und überholte Dokumente werden nicht genutzt, weil man ihnen nicht vertraut (Folge: niedrige Nutzung). Der Maßnahmenplan folgt der Kette von der Ursache zur Wirkung. Schritt 1: Owner und Vertretung für alle Dokumente der Stufe A bestimmen (Governance-Verantwortlicher, zwei Wochen). Schritt 2: Prüffrist und Erinnerung einführen (Service Owner, vier Wochen). Schritt 3: Überfällige Dokumente der Stufe A prüfen und archivieren oder aktualisieren (Owner, acht Wochen). Schritt 4: Nutzung nach drei Monaten erneut messen und Zielgruppen befragen. Erfolgskriterien: 100 Prozent der Stufe-A-Dokumente mit Owner, Aktualitätsquote über 90 Prozent, Nutzungszahlen steigen. Wichtig ist die Gegenprobe vor Schritt 3: Es muss geklärt werden, ob die niedrige Nutzung wirklich durch Veraltung verursacht ist oder durch schlechte Auffindbarkeit.
