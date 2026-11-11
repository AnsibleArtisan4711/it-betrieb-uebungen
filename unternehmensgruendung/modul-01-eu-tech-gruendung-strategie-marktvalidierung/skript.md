# Modul 01 - EU-Tech-Gründung, Strategie und Marktvalidierung

> **Hinweis zu diesem Kapitel:** Das ist das Kapitel des Skripts „Unternehmensgründung“, aus der LaTeX-Quelle in Markdown umgewandelt (Text und Codeblöcke unverändert, farbige Boxen als Zitatblöcke mit fettem Titel, Tabellen als Markdown-Tabellen). Die Lerneinheiten sind wie in der Quelle nach Modul nummeriert (1.1 bis 1.9), danach folgen „Übungsaufgaben zu Modul 01“ (8 Aufgaben, mit Schwierigkeitsangabe) und „Lösungen zu den Übungsaufgaben Modul 01“. Rechtliche und steuerliche Aussagen sind keine Rechtsberatung. Was ich an den Beispielen geprüft habe, steht in der [README des Repositories](../README.md). Übersicht zum Modul: [README](README.md).

**Dauer:** 8 h laut Modulübersicht (Summe der Einzelwerte: 9 × 0,9 h = 8,1 h, gerundet)

**Priorität:** 1 (höchste)

| **Nr.** | **Lerneinheit**                      | **Dauer (h)** |
|--------:|:-------------------------------------|--------------:|
|     1.1 | Founder Vision und Problemdefinition |           0,9 |
|     1.2 | EU-Tech-Marktverständnis             |           0,9 |
|     1.3 | Customer Discovery                   |           0,9 |
|     1.4 | Wettbewerbsanalyse                   |           0,9 |
|     1.5 | Problem-Solution-Fit                 |           0,9 |
|     1.6 | Segmentierung und ICP                |           0,9 |
|     1.7 | Startup-Metriken früh                |           0,9 |
|     1.8 | Stakeholder und Ökosystem            |           0,9 |
|     1.9 | Validierungs-Roadmap                 |           0,9 |
|         | **Summe**                            |       **8,1** |

Dieses Modul beantwortet eine einzige Frage: Lohnt es sich, dieses Unternehmen überhaupt zu bauen? Bevor Geld in eine Firma, in Software oder in Mitarbeitende fließt, muss belegt sein, dass ein echtes Problem existiert, dass es genug Menschen betrifft und dass sie bereit sind, für eine Lösung zu zahlen. Die neun Lerneinheiten führen vom ersten Gedanken (der Gründungsidee) über Markt, Kunden und Wettbewerb bis zu einem Plan, der Entscheidungen auf Evidenz stützt statt auf Hoffnung. Die Codebeispiele sind bewusst kleine Python-Skripte ohne Zusatzpakete. Sie machen Denkschritte nachvollziehbar und lassen sich in jeder Python-3-Umgebung ausführen. Alle Zahlen darin sind frei erfundene Beispielwerte.

## 1.1 Founder Vision und Problemdefinition

Am Anfang jeder Gründung steht eine Idee, aber Ideen sind billig. Wertvoll wird eine Idee erst, wenn sie als überprüfbare Aussage über die Welt formuliert ist. Genau das leistet die *Problemdefinition*: Sie beschreibt, wer (die *Zielkundengruppe*) unter welchem konkreten Schmerz (dem *Schmerzpunkt*, englisch *pain point*) leidet und welchen Nutzen eine Verbesserung bringen würde. Dieser erwartete Nutzen heißt *Nutzenhypothese*. Das Wort Hypothese ist wichtig: Zu Beginn ist alles eine Vermutung, und die Aufgabe der nächsten Wochen besteht darin, diese Vermutungen zu widerlegen oder zu bestätigen.

Die *Founder Vision* ist der größere Rahmen dahinter. Sie beschreibt, welche Veränderung in der Welt das Team erreichen will und warum gerade dieses Team dafür geeignet ist. Eine gute Vision ist weder ein Werbeslogan noch ein Produktbeschrieb. Sie ist eine Richtung, die über mehrere Jahre trägt, auch wenn sich das Produkt dreimal ändert. Investoren und Fördergeber fragen daher nicht nur „Was baut ihr?“, sondern auch „Warum ihr?“. Gemeint ist der sogenannte *Founder-Market-Fit*: Passen Erfahrung, Netzwerk und Motivation der Gründenden zum Problem?

Der entscheidende Schritt ist, aus der vagen Überzeugung eine *messbare Annahme* zu machen. „Kleine Handwerksbetriebe haben Probleme mit der Administration“ ist keine Annahme, sondern ein Gefühl. „Handwerksbetriebe mit 3 bis 15 Beschäftigten verlieren im Schnitt mindestens 5 Stunden pro Woche mit Angebots- und Rechnungserstellung, und mindestens 30 % würden dafür monatlich 49 EUR zahlen“ ist dagegen eine Annahme mit Zahlen, die man mit Interviews und Tests überprüfen kann. Der Satz enthält Zielgruppe, Schmerz, Größenordnung und Zahlungsbereitschaft; fehlt eines davon, lässt sich die Aussage nicht sauber prüfen.

Das folgende Beispiel hält so eine Hypothese als Datenstruktur fest und prüft automatisch, ob sie wirklich messbar formuliert ist. Das Programm definiert eine `Hypothese` mit Zielgruppe, Schmerz, Kennzahl, Schwellenwert und Quelle der Evidenz. Die Methode `pruefbar` liefert nur dann „wahr“, wenn eine Kennzahl und ein Schwellenwert vorhanden sind. So fällt sofort auf, wenn jemand nur ein Gefühl notiert hat.

```python
from dataclasses import dataclass

@dataclass
class Hypothese:
    zielgruppe: str
    schmerz: str
    kennzahl: str = ""
    schwelle: float = 0.0
    evidenz: str = "keine"

    def pruefbar(self) -> bool:
        return bool(self.kennzahl) and self.schwelle > 0

h1 = Hypothese("Handwerksbetriebe 3-15 Beschäftigte",
               "Angebote und Rechnungen kosten zu viel Zeit")
h2 = Hypothese("Handwerksbetriebe 3-15 Beschäftigte",
               "Angebote und Rechnungen kosten zu viel Zeit",
               kennzahl="Stunden pro Woche für Administration",
               schwelle=5.0, evidenz="Interviews (n=0)")

for h in (h1, h2):
    print(h.pruefbar(), "-", h.kennzahl or "KEINE KENNZAHL")
```

Die ersten Zeilen importieren `dataclass`, einen Python-Baustein, der aus einer Feldliste automatisch eine Klasse mit Konstruktor macht. Die Felder `kennzahl` und `schwelle` haben Standardwerte; wer sie nicht ausfüllt, erhält eine unfertige Hypothese. In der Schleife am Ende läuft die Prüfung für beide Objekte. Die Ausgabe lautet `False - KEINE KENNZAHL` für `h1` und `True - Stunden pro Woche für Administration` für `h2`. Das Beispiel ist klein, zeigt aber das Prinzip: Eine Annahme ist erst dann brauchbar, wenn man sie zahlenmäßig widerlegen könnte.

Typische Fehler beginnen bei der Zielgruppe. Falsch ist „alle kleinen Unternehmen“, weil darin Friseursalons, Softwarefirmen und Landwirte stecken, die nichts gemeinsam haben. Besser ist „Handwerksbetriebe mit 3 bis 15 Beschäftigten in Österreich, die Angebote noch in Word schreiben“. Ein zweiter Fehler ist, die Lösung in die Problembeschreibung zu schmuggeln („Die Kunden brauchen eine App für Rechnungen“). Dann ist das Problem nicht mehr das Problem, sondern die eigene Idee wird zur Tatsache erklärt. Richtig ist: „Kunden zahlen Rechnungen im Schnitt 41 Tage zu spät“; ob eine App, eine Schnittstelle oder ein Dienstleister die Antwort ist, bleibt offen. Der dritte Fehler ist *Confirmation Bias*, die Neigung, nur Belege zu sehen, die zur eigenen Idee passen. Dagegen hilft, die Widerlegungskriterien vorher schriftlich festzulegen.

> **Merke**
>
> Eine Problemdefinition besteht aus Zielgruppe, Schmerzpunkt, Nutzenhypothese und einer messbaren Schwelle. Sie beschreibt das Problem, nicht die eigene Lösung. Was nicht messbar formuliert ist, kann nicht widerlegt werden und ist deshalb noch keine Hypothese.

> **Praxisbeispiel**
>
> Fördergeber, Accelerators und Banken verlangen in ihren Anträgen fast immer eine Problembeschreibung mit Zielgruppe und Belegen. Wer sie schon in Form messbarer Annahmen vorbereitet hat, kann sie nach den ersten zehn Interviews mit realen Zahlen ersetzen. Das Team selbst nutzt dieselbe Liste später als Backlog der Lernziele: Welche Annahme prüfen wir als Nächstes?

## 1.2 EU-Tech-Marktverständnis

Wer in Europa gründet, bewegt sich in einem Markt mit rund 450 Millionen Menschen, aber ohne einheitliche Kundschaft. Der *Binnenmarkt* sorgt dafür, dass Waren, Dienstleistungen, Kapital und Personen weitgehend frei über Grenzen fließen. Ein österreichisches Softwareunternehmen darf seine Leistung also grundsätzlich in allen 27 Mitgliedstaaten anbieten, ohne dort eine eigene Zulassung zu brauchen. Das ist ein enormer Vorteil gegenüber vielen Regionen der Welt. Gleichzeitig bleibt Europa im Alltag fragmentiert: Sprache, Kaufverhalten, Zahlungsgewohnheiten, Vertragsrecht, Steuerdetails und Vertrauen in Anbieter unterscheiden sich von Land zu Land deutlich.

Für die Marktanalyse benutzt man üblicherweise drei verschachtelte Größen. Der *TAM* (Total Addressable Market) ist der Gesamtumsatz, der entstünde, wenn jeder potenzielle Kunde das Produkt kaufte. Der *SAM* (Serviceable Addressable Market) ist der Teil davon, den man mit Produkt, Sprache, Vertrieb und Regulierung tatsächlich bedienen kann. Der *SOM* (Serviceable Obtainable Market) ist der Anteil, den man in einem überschaubaren Zeitraum realistisch gewinnen kann. Investoren misstrauen reinen Top-down-Behauptungen wie „Der Markt ist 50 Milliarden groß, wir brauchen nur 1 %“. Überzeugender ist die *Bottom-up-Rechnung*: Anzahl erreichbarer Kunden mal Jahrespreis, gerechnet Land für Land mit nachvollziehbaren Quellen.

Das nächste Beispiel rechnet genau das. Es nimmt drei Länder an, jeweils mit der Zahl der Zielbetriebe, dem Anteil, der digital kauft, und einem Abschlag für Sprache beziehungsweise Lokalisierung. Daraus entstehen SAM und SOM. Die Länderdaten sind erfunden und dienen nur dem Rechenweg.

```python
laender = {
    # Land: (Zielbetriebe, Anteil digital kaufend, Erreichbarkeit mit Produkt)
    "AT": (60000, 0.55, 1.0),   # Heimatmarkt, Sprache vorhanden
    "DE": (500000, 0.50, 1.0),  # gleiche Sprache
    "FR": (400000, 0.45, 0.2),  # Produkt noch nicht lokalisiert
}
jahrespreis = 588          # 49 EUR pro Monat
marktanteil_3j = 0.02      # realistisches Ziel nach drei Jahren

tam = sam = 0
for land, (betriebe, digital, erreichbar) in laender.items():
    tam_land = betriebe * jahrespreis
    sam_land = betriebe * digital * erreichbar * jahrespreis
    tam += tam_land
    sam += sam_land
    print(f"{land}: TAM {tam_land/1e6:7.1f} Mio  SAM {sam_land/1e6:7.1f} Mio")

som = sam * marktanteil_3j
print(f"Summe TAM {tam/1e6:.1f} Mio, SAM {sam/1e6:.1f} Mio, SOM {som/1e6:.1f} Mio EUR")
```

Im Wörterbuch `laender` steht für jedes Land ein Tripel aus Betrieben, digitalem Kaufanteil und Erreichbarkeit. Die Erreichbarkeit 0,2 für Frankreich ist die ehrliche Antwort darauf, dass ein nicht übersetztes Produkt dort nur einen kleinen Teil der Betriebe anspricht. Die Schleife berechnet für jedes Land den theoretischen Markt (`tam_land`) und den bedienbaren Markt (`sam_land`), addiert beides und gibt es formatiert aus. Am Ende ergibt sich der SOM als Anteil des SAM. Die Ausgabe lautet: TAM gesamt 564,5 Mio, SAM 187,6 Mio, SOM 3,8 Mio EUR. Man sieht sofort, dass Deutschland den Löwenanteil liefert und dass die Übersetzung nach Frankreich eine echte Investitionsentscheidung ist, kein Nebenschauplatz.

Typische Fehler sind die Gleichsetzung von „EU-Markt“ und „ein Markt“, ein ungeprüftes Zahlenwerk aus einer einzigen Marktstudie und das Vergessen des Regulierungsfaktors. Ein Produkt, das Gesundheitsdaten verarbeitet, kann in jedem Land andere Anforderungen an Hosting oder Zertifizierung haben. Falsch ist „Wir verkaufen in der ganzen EU“; richtig ist „Wir starten in Österreich und Deutschland, prüfen Frankreich nach dem ersten Meilenstein und beschreiben die Voraussetzungen“. Ein weiterer Stolperstein: Zahlungsgewohnheiten. In Deutschland ist die Rechnung gegen Banküberweisung üblich, in anderen Ländern werden Karten oder lokale Verfahren erwartet.

> **Merke**
>
> Der Binnenmarkt erlaubt den grenzüberschreitenden Verkauf, ersetzt aber keine lokale Marktkenntnis. Eine glaubwürdige Marktgröße wird bottom-up gerechnet, getrennt nach Land und mit offen genannten Annahmen für Sprache, Regulierung und Kaufverhalten.

> **Praxisbeispiel**
>
> Ein österreichisches B2B-SaaS-Team startet in Österreich und Deutschland, weil Sprache, Vertrauen und Rechnungsstellung dort einfach sind. Nach den ersten 20 zahlenden Kunden entscheidet es mit einer Rechnung wie im Beispiel, ob sich der nächste Markt lohnt. Dieselbe Tabelle landet später im Pitch Deck (siehe Modul 08).

## 1.3 Customer Discovery

*Customer Discovery* bedeutet, systematisch mit potenziellen Kunden zu sprechen, bevor man das Produkt baut. Der Begriff stammt aus der Lean-Startup-Bewegung und beruht auf einer einfachen Beobachtung: Die meisten gescheiterten Produkte scheitern nicht an schlechter Technik, sondern daran, dass niemand das Problem dringend genug hatte. Ziel der Interviews ist deshalb nicht, die Idee zu verkaufen oder Lob einzusammeln, sondern Fakten über das echte Verhalten der Menschen zu sammeln. Aussagen wie „Das klingt toll“ sind wertlos. Wertvoll ist, was jemand *bisher getan hat*: welche Lösung er benutzt, wie viel Zeit oder Geld sie kostet, wann er sie zuletzt gewechselt hat.

Ein guter *Interviewleitfaden* fragt deshalb nach der Vergangenheit und nach konkreten Situationen, nicht nach Meinungen über die Zukunft. Statt „Würden Sie so ein Tool nutzen?“ lautet die Frage: „Erzählen Sie mir vom letzten Mal, als eine Rechnung zu spät bezahlt wurde. Was ist dann passiert?“ Fragen nach dem Hypothetischen laden zu höflichen Lügen ein, weil niemand das Gegenüber enttäuschen will. Ebenso wichtig ist die Reihenfolge: zuerst Kontext (Rolle, Alltag), dann Problem, dann bestehende Lösungen, dann Kosten und Prioritäten, erst ganz zum Schluss, falls überhaupt, eine Reaktion auf die Idee. Dazu kommt eine Frage nach der Zahlungsbereitschaft über Verhalten: „Was geben Sie heute dafür aus, auch an Arbeitszeit?“

Die Auswertung braucht ebenfalls Disziplin. Jedes Interview wird unmittelbar danach in einem festen Raster protokolliert, damit sich Ergebnisse vergleichen lassen. Im folgenden Beispiel werden zehn Interviews als Textblock in CSV-Form eingelesen und gezählt. Die Spalten sind Branche, der genannte Hauptschmerz, die Stunden pro Woche, die dafür aufgewendet werden, und die Angabe, ob schon eine Lösung gekauft wurde. Das Skript zählt Schmerzthemen und bildet den Mittelwert; außerdem berechnet es, wie viele Befragte bereits Geld ausgeben, was ein starkes Signal ist.

```python
import csv, io
from collections import Counter
from statistics import mean

daten = """branche,schmerz,stunden,kauft_loesung
Elektro,Angebote,6,nein
Elektro,Mahnwesen,4,ja
Sanitaer,Angebote,7,nein
Tischlerei,Angebote,5,nein
Tischlerei,Material,2,ja
Maler,Angebote,8,nein
Maler,Mahnwesen,3,nein
Elektro,Angebote,5,ja
Sanitaer,Mahnwesen,4,nein
Dachdecker,Angebote,6,ja
"""
zeilen = list(csv.DictReader(io.StringIO(daten)))

schmerz = Counter(z["schmerz"] for z in zeilen)
print("Schmerzthemen:", schmerz.most_common())
print("Mittelwert Stunden:", round(mean(int(z["stunden"]) for z in zeilen), 1))
zahler = sum(1 for z in zeilen if z["kauft_loesung"] == "ja")
print(f"{zahler} von {len(zeilen)} zahlen bereits fuer eine Loesung")
```

Mit `csv.DictReader` wird jede Zeile des Textblocks zu einem Wörterbuch, auf dessen Felder man über die Spaltennamen zugreift. `Counter` zählt, wie oft jedes Schmerzthema vorkommt; `most_common` sortiert absteigend. `mean` bildet den Durchschnitt der Wochenstunden. Das Ergebnis lautet: „Angebote“ wird sechsmal genannt, der Mittelwert liegt bei 5 Stunden, und 4 von 10 zahlen schon für eine Lösung. Das ist Evidenz: Sechs von zehn Befragten nennen die Angebotserstellung, und es gibt bereits Konkurrenz, die Geld bekommt. Bei nur zehn Gesprächen sind das Hinweise, keine Statistik, aber sie lenken die nächsten Experimente.

Zu den häufigsten Fehlern zählen Suggestivfragen („Stört es Sie nicht auch, dass …?“), das Interviewen von Freunden und Familie, die höflich antworten, und das Verkaufen der Lösung im Gespräch. Falsch: „Wir bauen ein Tool, das Angebote automatisch erstellt. Finden Sie das gut?“ Richtig: „Wie erstellen Sie ein Angebot, vom Anruf des Kunden bis zum Versand? Wo hakt es?“ Ein weiterer Fehler ist, nur die Schmerzäußerung zu notieren, aber nicht die Stärke: Wer das Problem hat, aber nie Zeit oder Geld investiert hat, löst es vermutlich nicht dringend.

> **Merke**
>
> Interviews prüfen Verhalten in der Vergangenheit, nicht Meinungen über die Zukunft. Notiere pro Gespräch Zitate, Zahlen und bisherige Lösungen im gleichen Raster, damit sich Muster zählen lassen. Zahlungsverhalten schlägt Zustimmung.

> **Praxisbeispiel**
>
> Typisch sind 15 bis 30 Gespräche vor der ersten Zeile Code. Die Teams bitten bei jedem Interview um zwei weitere Kontakte und bauen so ohne Werbebudget eine Liste möglicher erster Kunden auf. Wer Datenschutz ernst nimmt, holt sich für Aufzeichnungen eine Einwilligung (siehe Modul 06).

## 1.4 Wettbewerbsanalyse

Ein häufiger Irrglaube lautet: „Wir haben keinen Wettbewerb.“ Das stimmt praktisch nie. Wenn Kunden ein Problem haben, lösen sie es irgendwie, und diese Lösung ist Ihre Konkurrenz. Die Wettbewerbsanalyse unterscheidet deshalb drei Arten. *Direkte Wettbewerber* bieten ein sehr ähnliches Produkt für dieselbe Zielgruppe. *Indirekte Wettbewerber* lösen das Problem auf anderem Weg, etwa ein Branchenverband mit Vorlagen statt einer Software. *Substitute* sind Alternativen außerhalb der Produktkategorie, im Extremfall die Excel-Tabelle, der Steuerberater oder schlicht „nichts tun“. Gerade das Nichtstun und die Tabelle sind für junge Firmen oft der härteste Gegner, weil sie nichts kosten und alle sie kennen.

Auf dem Weg zur Differenzierung hilft ein Vergleich entlang weniger Kriterien, die für die Zielgruppe wirklich entscheidend sind, gewichtet nach Wichtigkeit. Die *Differenzierung* kann über das Produkt (eine Funktion, die kein anderer bietet), über Daten (exklusiver Zugang), über den Preis (ein deutlich anderes Modell) oder über den Vertrieb (ein Kanal, den die Konkurrenz nicht erreicht) entstehen. Wichtig ist, dass der Unterschied für den Kunden spürbar und für den Wettbewerb nicht in drei Monaten kopierbar ist. Positionierung bedeutet dann, diesen Unterschied in einem Satz zu benennen (vertieft in Modul 03).

Das folgende Skript baut eine gewichtete Bewertungsmatrix. Jedes Kriterium hat ein Gewicht, jeder Anbieter bekommt je Kriterium eine Note von 1 bis 5. Die Summe aus Gewicht mal Note ergibt den Gesamtwert. Gewichte und Noten sind Annahmen und gehören offen diskutiert.

```python
kriterien = {"Preis": 0.25, "Einfachheit": 0.30,
             "Branchenfunktionen": 0.30, "Support auf Deutsch": 0.15}
assert abs(sum(kriterien.values()) - 1.0) < 1e-9

anbieter = {
    "Wir (geplant)":    {"Preis": 4, "Einfachheit": 5, "Branchenfunktionen": 4, "Support auf Deutsch": 5},
    "Grosse Suite":     {"Preis": 2, "Einfachheit": 2, "Branchenfunktionen": 3, "Support auf Deutsch": 3},
    "Excel + Vorlagen": {"Preis": 5, "Einfachheit": 3, "Branchenfunktionen": 1, "Support auf Deutsch": 1},
}
for name, noten in anbieter.items():
    wert = sum(kriterien[k] * noten[k] for k in kriterien)
    print(f"{name:18s} {wert:.2f}")
```

Die Zeile mit `assert` bricht das Programm ab, falls die Gewichte nicht 100 % ergeben; so schleichen sich keine Rechenfehler ein. Die Schleife berechnet pro Anbieter mit einer Summe über alle Kriterien den gewichteten Wert. Das Ergebnis lautet 4,45 für das eigene Produkt, 2,45 für die große Suite und 2,60 für Excel. Wichtiger als die Zahl ist die Diskussion: Wenn das Team seine eigenen Noten schönredet, sollte es dieselbe Tabelle mit Kunden aus den Interviews nachbewerten.

Typische Fehler sind, nur die bekannten direkten Wettbewerber zu betrachten, die eigenen Stärken gegen die schwächsten Gegner zu messen und Features zu zählen statt Nutzen. Falsch: „Wir haben 40 Funktionen, der Wettbewerb nur 25.“ Richtig: „Für Betriebe unter 15 Beschäftigten sparen wir pro Angebot 20 Minuten, die große Suite braucht eine Einführung von zwei Wochen.“ Auch gefährlich ist der Glaube, ein großer Anbieter werde nie in die eigene Nische kommen. Er kann es jederzeit, und deshalb sollte man benennen, warum ein Kunde trotzdem bei einem bleibt: Geschwindigkeit, Spezialisierung, Daten, Beziehung.

> **Merke**
>
> Wettbewerb umfasst direkte, indirekte und Substitute, einschließlich „nichts tun“. Differenzierung muss für Kunden spürbar und schwer kopierbar sein. Bewertungen gehören mit Kunden validiert, nicht allein im Team erstellt.

> **Praxisbeispiel**
>
> Investoren erwarten im Pitch eine ehrliche Wettbewerbsfolie, auf der große Anbieter vorkommen und der Unterschied klar benannt ist. Im Alltag wird die Matrix quartalsweise aktualisiert, weil sich Preise und Funktionen ändern, und sie speist den Vertrieb mit Antworten auf die Frage „Warum nicht Anbieter X?“.

## 1.5 Problem-Solution-Fit

Der *Problem-Solution-Fit* beschreibt den Zustand, in dem belegt ist, dass die geplante Lösung ein bestätigtes Problem tatsächlich löst. Er liegt zeitlich vor dem *Product-Market-Fit*, bei dem Kunden das Produkt in nennenswertem Umfang nutzen und weiterempfehlen. Zuerst muss das Problem real sein (Customer Discovery), dann muss der Lösungsansatz dazu passen. Erst danach lohnt es sich, ein Produkt zu bauen, dessen Wachstum man messen kann.

Das zentrale Werkzeug ist die *Annahmenlandkarte*. Jede Geschäftsidee ruht auf Dutzenden Annahmen: Kunden haben das Problem, sie bemerken es, sie wollen es lösen, sie zahlen, wir erreichen sie, wir können die Lösung bauen, das Rechtliche ist machbar. Nicht alle Annahmen sind gleich gefährlich. Man bewertet jede nach zwei Achsen: Wie stark hängt das Geschäft von ihr ab (*Auswirkung*)? Wie wenig wissen wir darüber (*Unsicherheit*)? Das Produkt aus beiden ergibt eine Risikopriorität. Die Annahmen mit hoher Auswirkung und hoher Unsicherheit heißen *kritische Annahmen* (englisch *riskiest assumptions*); sie werden zuerst getestet, möglichst günstig. Typische billige Tests sind Interviews, eine Landing Page mit Warteliste, ein Papier-Prototyp oder ein „Wizard of Oz“-Test, bei dem Menschen die Lösung im Hintergrund von Hand erbringen, während der Kunde ein fertiges Produkt zu sehen glaubt.

Das Beispiel sortiert eine Liste von Annahmen nach Risikopriorität und schlägt den billigsten Test für die gefährlichste vor. Auswirkung und Unsicherheit werden mit 1 bis 5 bewertet.

```python
annahmen = [
    # (Annahme, Auswirkung 1-5, Unsicherheit 1-5, billigster Test)
    ("Betriebe zahlen 49 EUR pro Monat",           5, 5, "Preis-Interview + Vorbestellung"),
    ("Betriebe nutzen Smartphone auf der Baustelle", 4, 2, "Beobachtung in 5 Betrieben"),
    ("Wir koennen Buchhaltungs-Export bauen",        3, 3, "Technischer Spike (2 Tage)"),
    ("Kunden finden uns ueber Suchmaschine",         4, 4, "Landing Page + 200 EUR Anzeigen"),
]
rang = sorted(annahmen, key=lambda a: a[1] * a[2], reverse=True)
for i, (text, aus, uns, test) in enumerate(rang, 1):
    print(f"{i}. Risiko {aus*uns:2d}: {text} -> {test}")
```

Die Liste enthält Tupel mit vier Einträgen. `sorted` mit dem Schlüssel `a[1] * a[2]` ordnet nach dem Produkt aus Auswirkung und Unsicherheit, `reverse=True` stellt das größte Risiko an die Spitze. `enumerate(rang, 1)` nummeriert ab 1. Die Ausgabe führt die Zahlungsbereitschaft mit Risiko 25 an, gefolgt vom Marketingkanal mit 16 und der technischen Machbarkeit mit 9. Das ist ein typisches Ergebnis: Die technische Machbarkeit fühlt sich für Gründende mit Technikhintergrund beängstigend an, ist aber oft weniger riskant als die Frage, ob jemand zahlt.

Zu den Stolperfallen zählt, die bequemen Annahmen zuerst zu testen, weil sie schneller Erfolge liefern. Falsch ist ein dreimonatiger Prototyp, um herauszufinden, ob Nutzer die Oberfläche mögen, während niemand geprüft hat, ob sie zahlen. Richtig ist ein Test mit Vorbestellung oder einer schriftlichen Absichtserklärung (*Letter of Intent*) in der ersten Woche. Außerdem sollte man Tests mit Erfolgskriterium vorab definieren, etwa „Mindestens 5 von 20 Angesprochenen hinterlegen ihre Zahlungsdaten“. Ohne Kriterium wird jedes Ergebnis nachträglich schöngeredet.

> **Merke**
>
> Problem-Solution-Fit heißt: bestätigtes Problem plus passender Lösungsansatz, belegt durch Kundenverhalten. Teste zuerst die Annahmen mit hoher Auswirkung und hoher Unsicherheit, mit dem billigsten aussagekräftigen Test und mit einem vorher festgelegten Erfolgskriterium.

> **Praxisbeispiel**
>
> Viele Teams nutzen ein Board mit Spalten „Annahme – Test – Ergebnis – Entscheidung“. Beim wöchentlichen Treffen wird immer nur die oberste Zeile bearbeitet. Das Board dient später als Nachweis für Fördergeber, dass Entwicklungsmittel gezielt eingesetzt wurden.

## 1.6 Segmentierung und ICP

Kein Produkt ist für alle gedacht. *Segmentierung* teilt einen Markt in Gruppen mit ähnlichen Bedürfnissen und ähnlichem Kaufverhalten. Aus den Segmenten wird dasjenige gewählt, mit dem man startet. Das *Ideal Customer Profile* (ICP) beschreibt dann den Kunden, für den das Produkt den größten Nutzen bringt und der gleichzeitig profitabel zu gewinnen und zu halten ist. Bei Unternehmenskunden (B2B) beschreibt man das ICP mit Merkmalen wie Branche, Größe, Land, Technologie, Budget und *Auslöser*, also dem Ereignis, das den Kaufwunsch weckt: zum Beispiel eine neue gesetzliche Pflicht, ein Wachstumsschub oder ein Systemwechsel. Das ICP ist nicht dasselbe wie eine *Persona*; die Persona beschreibt eine Person mit Rolle und Motiven, das ICP die Organisation.

Zu Beginn ist ein enges ICP besser als ein breites. Wer mit einer kleinen, klar definierten Gruppe startet, kann Sprache, Argumente und Funktionen genau darauf abstimmen und lernt schneller. *Frühe Adopter* (*early adopters*) sind die Kunden, die das Problem akut spüren, bereits selbst nach Lösungen gesucht haben und bereit sind, ein unfertiges Produkt zu nutzen, wenn es ihnen Nutzen bringt. Man erkennt sie daran, dass sie von selbst Notlösungen gebaut haben, aktiv Geld ausgeben und schnell Feedback geben.

Das folgende Programm bewertet Interessenten anhand eines einfachen Punktesystems für das ICP. Es zeigt, wie man Kriterien explizit macht, statt sich auf Bauchgefühl zu verlassen.

```python
def icp_score(lead: dict) -> int:
    punkte = 0
    if lead["branche"] in {"Elektro", "Sanitaer", "Tischlerei"}:
        punkte += 30
    if 3 <= lead["mitarbeiter"] <= 15:
        punkte += 25
    if lead["land"] in {"AT", "DE"}:
        punkte += 15
    if lead["ausloeser"]:          # z. B. Wachstum, Wechsel
        punkte += 20
    if lead["hat_notloesung"]:     # baut sich Excel-Vorlagen selbst
        punkte += 10
    return punkte

leads = [
    {"name": "Meier GmbH", "branche": "Elektro", "mitarbeiter": 9,
     "land": "AT", "ausloeser": True, "hat_notloesung": True},
    {"name": "Konzern AG", "branche": "Bau", "mitarbeiter": 4000,
     "land": "DE", "ausloeser": False, "hat_notloesung": False},
]
for l in sorted(leads, key=icp_score, reverse=True):
    print(l["name"], icp_score(l))
```

Die Funktion `icp_score` vergibt Punkte für Branche, Betriebsgröße, Land, Auslöser und vorhandene Notlösung. Die Gewichte (30, 25, 15, 20, 10) summieren sich auf 100. Die Mengenschreibweise `{"AT", "DE"}` prüft schnell, ob ein Wert in einer Auswahl liegt. `sorted(..., key=icp_score)` sortiert die Interessenten nach der Punktzahl. Die Meier GmbH erreicht 100 Punkte, der Konzern 15. Die Zahl selbst ist weniger wichtig als der Nutzen im Alltag: Der Vertrieb weiß, wen er zuerst anruft, und das Team merkt, wenn die Verkäufe aus Segmenten kommen, die das Punkteschema gar nicht vorsieht. Dann stimmt das ICP nicht.

Typische Fehler: ein ICP aus Wunschdenken statt aus Daten, ein ICP mit zu vielen Branchen und das Verwechseln von Käufer und Nutzer. Falsch: „Mittelständische Unternehmen in Europa“. Richtig: „Elektro- und Sanitärbetriebe mit 3 bis 15 Beschäftigten in Österreich und Deutschland, die in den letzten 12 Monaten ein neues Fahrzeug oder einen neuen Mitarbeiter angeschafft haben“. Im B2B entscheidet oft nicht der Nutzer, sondern der Chef oder die Einkaufsabteilung; auch deren Motive gehören zum Profil.

> **Merke**
>
> Das ICP beschreibt die Organisation, die am meisten profitiert und am wirtschaftlichsten zu gewinnen ist. Früh gilt: lieber eng und konkret als breit und vage. Frühe Adopter erkennt man an akuten Schmerzen, Notlösungen und Zahlungsbereitschaft.

> **Praxisbeispiel**
>
> Das ICP landet im CRM als Filter (siehe Modul 09), steuert Werbeanzeigen, Messebesuche und die Ansprache von Partnern. Nach den ersten zehn Abschlüssen wird es mit den echten Käufern abgeglichen und angepasst.

## 1.7 Startup-Metriken früh

Kennzahlen sind der Kompass einer jungen Firma, aber nur die richtigen. *Vanity Metrics* (Eitelkeitskennzahlen) sehen gut aus, sagen aber nichts über den Geschäftserfolg: Seitenaufrufe, App-Downloads, Social-Media-Follower, Anzahl Registrierungen. Sie steigen oft auch dann, wenn niemand das Produkt wirklich nutzt. *Aktionsfähige Metriken* hingegen verändern Entscheidungen. In der Frühphase sind drei Gruppen besonders aufschlussreich.

Die *Activation* misst, wie viele neue Nutzer den ersten echten Nutzen erleben, etwa „ein Angebot erstellt und versendet“. Registrieren allein reicht nicht. Die *Retention* misst, wie viele Nutzer nach einer bestimmten Zeit noch aktiv sind, zum Beispiel nach 30 Tagen. Sie ist das stärkste Frühsignal für Product-Market-Fit, weil sie zeigt, ob das Produkt ein wiederkehrendes Problem löst. Die *Zahlungsbereitschaft* wird zuerst über Vorbestellungen, Pilotverträge und tatsächliche Zahlungen gemessen, nicht über Umfragen. Dazu kommt bei Abonnements später der *Churn*, also der Anteil der Kunden, die in einem Zeitraum kündigen (vertieft in Modul 07).

Das nächste Beispiel berechnet eine einfache Kohorten-Retention. Eine *Kohorte* ist eine Gruppe von Nutzern, die im selben Zeitraum gestartet ist. Die Tabelle zeigt, wie viele von ihnen in den Folgewochen noch aktiv waren.

```python
kohorten = {
    # Startwoche: [aktiv in Woche 0, 1, 2, 3, 4]
    "KW01": [40, 22, 16, 15, 14],
    "KW02": [55, 30, 20, 17, 16],
    "KW03": [50, 18, 9, 6, 4],
}
for name, werte in kohorten.items():
    start = werte[0]
    rate = [round(100 * w / start) for w in werte]
    print(name, rate, "% | Woche-4-Retention:", rate[-1], "%")
```

Jede Liste enthält die Zahl aktiver Nutzer pro Woche seit dem Start. Die Listenbildung `[round(100 * w / start) for w in werte]` rechnet jeden Wert in Prozent der Startgruppe um. Das Ergebnis: Die Kohorten KW01 und KW02 stabilisieren sich bei rund 35 beziehungsweise 29 Prozent, KW03 fällt auf 8 Prozent. Diese Abweichung ist ein Signal. Vielleicht wurde in dieser Woche über einen anderen Kanal geworben, oder eine Produktänderung hat die Aktivierung verschlechtert. Die Kohortensicht deckt das auf, während ein Gesamtdurchschnitt es verwischt.

Fehler: Gesamtzahlen statt Kohorten betrachten (die Gesamtzahl wächst bei Neukundenzustrom auch dann, wenn alte Kunden gehen), Kennzahlen ohne Definition (Was heißt „aktiv“?) und zu viele Metriken. Falsch: „Wir haben 5.000 Registrierungen.“ Richtig: „Von 5.000 Registrierungen haben 600 (12 %) innerhalb von 7 Tagen ein Angebot versendet; davon sind nach 30 Tagen 210 weiter aktiv.“ Die Definitionen gehören schriftlich festgehalten, damit Team, Investoren und Berichte dieselbe Sprache sprechen.

> **Merke**
>
> Messe, was Entscheidungen verändert: Activation, Retention und echte Zahlungsbereitschaft. Betrachte Kohorten statt Gesamtsummen, definiere jede Kennzahl schriftlich und meide Vanity Metrics.

> **Praxisbeispiel**
>
> Frühe Teams zeigen im Investor-Update drei bis fünf Kennzahlen, die immer gleich definiert sind (siehe Modul 07, Investor Reporting). Als Werkzeug reicht anfangs ein Tabellenblatt oder eine kleine Datenbankabfrage.

## 1.8 Stakeholder und Ökosystem

Ein Startup entsteht nicht im Vakuum. Zum *Ökosystem* gehören alle Organisationen und Personen, die Wissen, Geld, Kunden, Talente oder Legitimität beisteuern. In Europa sind das typischerweise *Accelerators* (befristete Programme, die gegen Beteiligung oder kostenlos Mentoring und Kontakte liefern), *Inkubatoren* (längerfristige Gründerzentren), Universitäten und Forschungseinrichtungen (Talente, Technologie, Transfer), Corporates (Pilotkunden, Partner, später Käufer), Förderagenturen, Kammern und Wirtschaftsverbände, Business Angels und Fonds sowie regionale *Cluster*, also Konzentrationen verwandter Unternehmen, die voneinander profitieren. Ein *Stakeholder* ist jede Partei mit Interesse am Unternehmen: Kunden, Mitarbeitende, Investoren, Behörden, Lieferanten.

Weil Zeit knapp ist, braucht es eine *Netzwerkstrategie*. Sie beantwortet: Welche Kontakte bringen in den nächsten sechs Monaten Pilotkunden, Wissen oder Zugang? Wer ist Brückenbauer zu Entscheidern? Ein Name allein genügt nicht; jeder Kontakt bekommt ein Ziel, einen nächsten Schritt und ein Datum. Gleichzeitig gilt Geben vor Nehmen: Wer Kontakte vermittelt oder Wissen teilt, wird eher unterstützt.

Das Beispiel führt ein kleines Kontaktregister in einer SQLite-Datenbank, die in Python bereits enthalten ist. Es speichert Typ, Ziel und Folgetermin und fragt ab, was überfällig ist. Damit wird aus Netzwerkpflege ein wiederholbarer Prozess.

```python
import sqlite3
db = sqlite3.connect(":memory:")
db.execute("""CREATE TABLE kontakt (
    name TEXT, typ TEXT, ziel TEXT, naechster_schritt TEXT, faellig TEXT)""")
db.executemany("INSERT INTO kontakt VALUES (?,?,?,?,?)", [
    ("Dr. Huber", "Universitaet", "Zugang zu Pilotbetrieben", "Intro-Mail", "2026-11-05"),
    ("Accelerator X", "Accelerator", "Bewerbung Batch Fruehjahr", "Unterlagen", "2026-11-20"),
    ("Fa. Bauer", "Kunde", "Pilotvertrag", "Demo-Termin", "2026-10-28"),
])
heute = "2026-11-01"
for row in db.execute(
    "SELECT name, naechster_schritt, faellig FROM kontakt "
    "WHERE faellig < ? ORDER BY faellig", (heute,)):
    print("UEBERFAELLIG:", row)
```

Die Tabelle `kontakt` wird mit `CREATE TABLE` im Arbeitsspeicher angelegt (`":memory:"`), die Zeilen werden per `executemany` eingefügt. Die Fragezeichen sind Platzhalter, die Werte getrennt übergeben; das schützt vor Fehlern und vor SQL-Injection. Die Abfrage vergleicht das Fälligkeitsdatum als Text im Format JJJJ-MM-TT, das sich korrekt sortieren lässt. Ausgegeben wird nur der Eintrag für Fa. Bauer, weil sein Termin vor dem 1. November liegt. In echten Projekten steckt dieselbe Idee in einem CRM (Modul 09).

Typische Fehler: Veranstaltungen sammeln, aber nie nachfassen; Programme nach Prestige wählen, nicht nach Bedarf; Beteiligungsforderungen von Accelerators nicht prüfen. Falsch: „Wir bewerben uns bei allem, was Startup heißt.“ Richtig: „Wir brauchen in den nächsten sechs Monaten drei Pilotkunden im Handwerk; deshalb ist ein Programm mit Branchenpartnern wichtiger als eines mit hohem Preisgeld.“ Zu prüfen sind immer Gegenleistung (Anteile?), Pflichten und tatsächlicher Zugang (siehe Modul 08).

> **Merke**
>
> Das Ökosystem liefert Kunden, Wissen, Talente und Geld. Jeder Kontakt braucht Ziel, nächsten Schritt und Termin. Programme werden nach Bedarf und Gegenleistung gewählt, nicht nach Namen.

> **Praxisbeispiel**
>
> In Österreich begegnen Gründende Kammern, Förderagenturen, Hochschul-Gründerzentren und regionalen Netzwerken. Fachleute sind meist hilfsbereit, wenn eine Anfrage konkret und kurz ist: ein Satz zum Vorhaben, ein Satz zur Frage, ein Terminvorschlag.

## 1.9 Validierungs-Roadmap

Die *Validierungs-Roadmap* fasst alle bisherigen Lerneinheiten zu einem Plan zusammen: In welcher Reihenfolge werden Annahmen mit welchen Experimenten und welchen Entscheidungskriterien geprüft? Ein *Experiment* ist hier ein zeitlich begrenzter Test mit einer Hypothese, einer Methode, einer Kennzahl und einem Erfolgskriterium. Ein *Entscheidungspunkt* (englisch *decision gate*) legt im Voraus fest, was nach dem Ergebnis geschieht. Die *Go/No-Go-Kriterien* sind die Schwellenwerte für Weitermachen, Anpassen (*Pivot*) oder Stoppen. Ein Pivot ist ein Kurswechsel in Zielgruppe, Problem oder Lösung, der aus den Daten folgt.

Der Wert der Dokumentation liegt darin, dass Entscheidungen später nachvollziehbar sind. Wer nach sechs Monaten nicht mehr weiß, warum ein Segment verworfen wurde, wiederholt Fehler. Außerdem verlangen Fördergeber und Investoren häufig einen Nachweis, wie Mittel zu Erkenntnissen geführt haben. Ein gutes Experiment kostet wenig, dauert Tage statt Monate und liefert eine Ja-Nein-Antwort.

Das Beispiel hält Experimente in einer Liste fest und entscheidet automatisch anhand der Kriterien. Jedes Experiment enthält Ziel- und Ist-Wert. Das Skript prüft, ob alle Kriterien einer Phase erfüllt sind, und empfiehlt Go, Pivot oder No-Go.

```python
experimente = [
    {"name": "Interviews",      "kriterium": "mind. 15 Gespraeche mit Problem", "soll": 15, "ist": 18},
    {"name": "Preistest",       "kriterium": "mind. 30 % nennen 49 EUR OK",     "soll": 30, "ist": 42},
    {"name": "Landing Page",    "kriterium": "mind. 5 % Anmeldequote",          "soll": 5,  "ist": 3.1},
    {"name": "Vorbestellungen", "kriterium": "mind. 5 zahlende Piloten",        "soll": 5,  "ist": 6},
]
erfuellt = [e for e in experimente if e["ist"] >= e["soll"]]
quote = len(erfuellt) / len(experimente)
for e in experimente:
    print("OK  " if e["ist"] >= e["soll"] else "FAIL", e["name"], e["ist"], "/", e["soll"])
if quote == 1:
    print("Entscheidung: GO")
elif quote >= 0.5:
    print("Entscheidung: PIVOT pruefen (Kanal oder Botschaft anpassen)")
else:
    print("Entscheidung: NO-GO")
```

Die Liste enthält vier Experimente mit Sollwert und Istwert. Die Listenbildung `erfuellt` sammelt alle, die ihr Kriterium erreichen. Die Quote ergibt 0,75: Interviews, Preistest und Vorbestellungen sind erfüllt, die Landing Page nicht. Das Programm empfiehlt deshalb „PIVOT prüfen“. Das ist sinnvoll, denn Nachfrage und Zahlungsbereitschaft sind da, nur der Kanal oder die Botschaft der Landing Page überzeugt nicht. Genau diese feine Unterscheidung verhindert, dass ein Team wegen eines einzigen schwachen Tests die ganze Idee verwirft.

Typische Fehler: Kriterien nach dem Test anpassen, endlose Experimentphasen ohne Entscheidung und zu große Experimente. Falsch: „Wir schauen einmal, wie es läuft.“ Richtig: „Wenn bis 30. 11. weniger als 5 zahlende Piloten vorliegen, stoppen wir die Entwicklung und prüfen Segment B.“ Ein zweiter Fehler ist emotionale Bindung an die erste Idee; Kriterien, die vorher mit Mentoren abgestimmt wurden, helfen, sich ehrlich zu entscheiden.

> **Merke**
>
> Eine Validierungs-Roadmap ordnet Experimente nach Risiko, legt Erfolgskriterien und Entscheidungspunkte vorab fest und dokumentiert Ergebnisse. Go, Pivot oder No-Go folgen aus Daten, nicht aus Stimmung.

> **Praxisbeispiel**
>
> Aus der Roadmap entsteht der Fördertext (Meilensteine), das Pitch Deck (Traction-Folie, Modul 08) und die Produkt-Roadmap (Modul 04). Sie ist die Brücke zwischen Idee und Unternehmen.

## Übungsaufgaben zu Modul 01

1.  **(leicht)** Erkläre in eigenen Worten den Unterschied zwischen Problem-Solution-Fit und Product-Market-Fit.

2.  **(leicht)** Formuliere die Aussage „Viele Cafés haben Probleme mit dem Einkauf“ zu einer messbaren Hypothese um (Zielgruppe, Schmerz, Kennzahl, Schwelle).

3.  **(leicht)** Nenne je ein Beispiel für direkte Wettbewerber, indirekte Wettbewerber und Substitute für ein Online-Buchhaltungstool.

4.  **(mittel)** Ein Team behauptet: „Unser Markt ist 40 Milliarden Euro, wir brauchen nur 0,5 %.“ Warum überzeugt das kaum, und wie sähe eine Bottom-up-Rechnung aus?

5.  **(mittel)** Schreibe fünf Interviewfragen zu einem Problem deiner Wahl, die sich auf vergangenes Verhalten beziehen, und nenne zwei Suggestivfragen, die du vermeidest.

6.  **(praktisch)** Erweitere das Programm aus Lerneinheit 1.2 um Spanien (200.000 Betriebe, 40 % digital, Erreichbarkeit 0,1). Wie ändern sich SAM und SOM?

7.  **(praktisch)** Ändere das Beispiel aus 1.6 so, dass Leads mit weniger als 50 Punkten als „kalt“ markiert werden, und gib eine Liste der kalten Leads aus.

8.  **(schwer/praktisch)** Schreibe ein Python-Skript, das aus der Kohortentabelle in 1.7 für jede Kohorte die Woche mit dem größten Absturz bestimmt und ausgibt.

## Lösungen zu den Übungsaufgaben Modul 01

**1.** Problem-Solution-Fit heißt, dass ein bestätigtes Problem durch einen passenden Lösungsansatz adressiert wird; belegt wird er mit Interviews und Tests. Product-Market-Fit kommt später: Das fertige Produkt wird von einem Markt in nennenswertem Umfang genutzt, gekauft und weiterempfohlen. Der erste Fit ist die Voraussetzung, der zweite die Folge.

**2.** Beispiel: „Cafés mit 5 bis 20 Beschäftigten in Wien verlieren mindestens 4 Stunden pro Woche mit Bestellungen bei Lieferanten (Kennzahl: Stunden pro Woche, Schwelle 4).“ Entscheidend ist, dass Zielgruppe, Schmerz, Kennzahl und Schwelle vorkommen.

**3.** Direkt: andere Online-Buchhaltungssoftware. Indirekt: ein Steuerberatungsbüro, das die Buchhaltung als Dienstleistung übernimmt. Substitut: Excel-Tabelle und Belegordner oder schlicht „Beleg-Stapel“ bis zum Jahresende.

**4.** Die Rechnung ist top-down und enthält keine Aussage darüber, wer tatsächlich kaufen kann oder will. Besser: Anzahl erreichbarer Kunden (je Land und Segment) mal Jahrespreis, mit Abschlägen für Sprache und Regulierung, zum Schluss ein realistischer Marktanteil nach drei Jahren. Die Annahmen sind dann einzeln diskutierbar.

**5.** Beispiele: „Erzählen Sie von Ihrer letzten Bestellung beim Lieferanten.“ „Wie lange hat sie gedauert?“ „Welche Hilfsmittel nutzen Sie dafür?“ „Was haben Sie in den letzten 12 Monaten unternommen, um das zu verbessern?“ „Was hat das gekostet?“ Zu vermeidende Suggestivfragen: „Stört es Sie nicht auch, dass Bestellungen so lange dauern?“ und „Würden Sie ein Tool nutzen, das das automatisch macht?“

**6.** Im Wörterbuch ergänzen: `"ES": (200000, 0.40, 0.1)`. TAM Spanien: 200 000 × 588 = 117,6 Mio. SAM: 200 000 × 0,4 × 0,1 × 588 = 4,7 Mio. Der SAM steigt gegenüber vorher nur um 4,7 Mio, der SOM bei 2 % um etwa 0,09 Mio. Das zeigt: Ohne Lokalisierung bringt ein neuer Markt kaum Nutzen.

**7.** Nach der Berechnung ergänzen:

```python
kalt = [l["name"] for l in leads if icp_score(l) < 50]
print("Kalte Leads:", kalt)
```

Die Listenbildung filtert alle Leads, deren Punktzahl unter 50 liegt; im Beispiel ist das der Konzern mit 15 Punkten.

**8.** Mögliche Lösung:

```python
for name, werte in kohorten.items():
    verluste = [(werte[i] - werte[i+1], i+1) for i in range(len(werte)-1)]
    groesster, woche = max(verluste)
    print(name, "groesster Verlust:", groesster, "Nutzer in Woche", woche)
```

Pro Kohorte wird die Differenz zwischen aufeinanderfolgenden Wochen gebildet; `max` liefert das größte Paar aus Verlust und Woche. Für KW01 ist es der Absturz von Woche 0 auf 1 (18 Nutzer), für KW02 ebenfalls (25) und für KW03 auch (32). Das passt zur Erfahrung: Die meisten Nutzer gehen in der ersten Woche verloren, deshalb ist die Aktivierung der wichtigste Hebel.
