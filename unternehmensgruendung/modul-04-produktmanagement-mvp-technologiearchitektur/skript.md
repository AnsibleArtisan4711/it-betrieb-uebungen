# Modul 04 - Produktmanagement, MVP und Technologiearchitektur

> **Hinweis zu diesem Kapitel:** Das ist das Kapitel des Skripts „Unternehmensgründung“, aus der LaTeX-Quelle in Markdown umgewandelt (Text und Codeblöcke unverändert, farbige Boxen als Zitatblöcke mit fettem Titel, Tabellen als Markdown-Tabellen). Die Lerneinheiten sind wie in der Quelle nach Modul nummeriert (4.1 bis 4.9), danach folgen „Übungsaufgaben zu Modul 04“ (8 Aufgaben, mit Schwierigkeitsangabe) und „Lösungen zu den Übungsaufgaben Modul 04“. Rechtliche und steuerliche Aussagen sind keine Rechtsberatung. Was ich an den Beispielen geprüft habe, steht in der [README des Repositories](../README.md). Übersicht zum Modul: [README](README.md).

**Dauer:** 10 h laut Modulübersicht (Summe der Einzelwerte: 9 × 1,1 h = 9,9 h, gerundet)

**Priorität:** 1 (höchste)

| **Nr.** | **Lerneinheit**           | **Dauer (h)** |
|--------:|:--------------------------|--------------:|
|     4.1 | Product Discovery         |           1,1 |
|     4.2 | MVP Scope                 |           1,1 |
|     4.3 | Requirements Engineering  |           1,1 |
|     4.4 | UX und Prototyping        |           1,1 |
|     4.5 | Cloud-Architektur         |           1,1 |
|     4.6 | Build-vs-Buy              |           1,1 |
|     4.7 | Datenmodell und APIs      |           1,1 |
|     4.8 | Technical Debt Management |           1,1 |
|     4.9 | Product Roadmap           |           1,1 |
|         | **Summe**                 |       **9,9** |

Nachdem Problem, Markt und Geschäftsmodell geklärt sind, geht es um das Produkt selbst. Produktmanagement beantwortet die Fragen: Was bauen wir zuerst, was lassen wir weg, wie legen wir fest, was „fertig“ bedeutet, und wie sieht die technische Grundlage aus, die uns weder blockiert noch ruiniert? Das Modul verbindet Produktdenken mit technischen Entscheidungen, weil beide in jungen Firmen von denselben Personen getroffen werden. Die Codebeispiele sind lauffähige Python-Programme ohne Zusatzpakete; Zahlen sind Beispielwerte. Den Betrieb (CI/CD, Monitoring, Incident Response) behandelt Modul 05, Sicherheit und Datenschutz Modul 06.

## 4.1 Product Discovery

*Product Discovery* ist die Phase, in der man herausfindet, *was* gebaut werden soll, bevor man festlegt, *wie*. Der Gegenpol ist die *Delivery*, also die Umsetzung. Gute Teams betreiben beides parallel: Während eine Funktion gebaut wird, klärt ein anderer Teil des Teams bereits die nächste. Discovery stützt sich auf die Methoden aus Modul 01 (Interviews, Beobachtung), richtet sie aber auf das Produkt: Wie sieht der Arbeitsablauf der Nutzer aus, wo bricht er, was tun sie als Behelf?

Ein hilfreiches Konzept ist das der *Jobs to be done* (JTBD, „zu erledigende Aufgaben“). Es besagt, dass Menschen Produkte „anheuern“, um einen Fortschritt in einer Situation zu erzielen. Niemand will einen Bohrer; er will ein Loch, genauer: ein Regal, das hält. Ein Job wird als Satz beschrieben: „Wenn \[Situation\], will ich \[Motivation\], damit ich \[Ergebnis\].“ Beispiel: „Wenn ich nach einem Kundentermin im Auto sitze, will ich das Angebot sofort versenden, damit ich den Auftrag nicht an einen schnelleren Mitbewerber verliere.“ Jobs bestehen aus funktionalen, emotionalen und sozialen Teilen. Der Handwerker will nicht nur das Angebot schicken, sondern auch professionell wirken.

Um Chancen zu priorisieren, kann man Nutzer bitten, jeden Job nach Wichtigkeit und Zufriedenheit mit den bestehenden Lösungen zu bewerten (Skala 1 bis 10). Ein Job ist besonders interessant, wenn er wichtig und schlecht gelöst ist. Eine in der Literatur zu „Outcome-Driven Innovation“ verbreitete Formel lautet: Chancenwert gleich Wichtigkeit plus Differenz aus Wichtigkeit und Zufriedenheit (aber nie negativ).

```python
jobs = [
    ("Angebot schnell erstellen",        9.0, 3.5),
    ("Materialpreise aktuell halten",    8.0, 4.0),
    ("Rechnung aus Angebot erzeugen",    7.5, 6.0),
    ("Fotos der Baustelle ablegen",      5.0, 5.5),
]
def chance(wichtig, zufrieden):
    return round(wichtig + max(wichtig - zufrieden, 0), 1)

for text, w, z in sorted(jobs, key=lambda j: chance(j[1], j[2]), reverse=True):
    print(f"{chance(w, z):5.1f}  {text}  (wichtig {w}, zufrieden {z})")
```

Die Funktion `chance` addiert zur Wichtigkeit die Lücke zur Zufriedenheit; `max(..., 0)` verhindert, dass überversorgte Jobs abgewertet werden. Die Schleife sortiert die Jobs absteigend. Ergebnis: „Angebot schnell erstellen“ erreicht 14,5, Materialpreise 12,0, Rechnung 9,0 und Fotos 5,0. Das Ergebnis begründet, womit das Produkt beginnt: dem Angebot. Dass Fotos weit hinten liegen, ist keine Aussage, dass sie unwichtig seien, sondern dass andere Jobs mehr Unzufriedenheit tragen.

Typische Fehler: Lösungen mit Problemen verwechseln („Wir brauchen ein Dashboard“), ausschließlich Zahlen bewerten und keine Beobachtung durchführen sowie die lautesten Kunden mit allen Kunden gleichsetzen. Falsch: Die Forderung eines einzelnen Großkunden sofort in die Produktplanung übernehmen. Richtig: Nach dem dahinterliegenden Job fragen („Was wollen Sie damit erreichen?“) und prüfen, ob andere Kunden denselben Job haben. Wichtig ist auch, Discovery nicht als einmalige Phase zu verstehen: Sie läuft während der gesamten Produktlebenszeit weiter, in Form von wöchentlichen Kundengesprächen.

> **Merke**
>
> Discovery klärt, was gebaut werden soll, Delivery, wie es gebaut wird. Jobs to be done beschreiben den Fortschritt, den Nutzer erzielen wollen. Chancen sind Jobs, die wichtig und schlecht gelöst sind.

> **Praxisbeispiel**
>
> Produktteams planen jede Woche feste Zeit für Kundengespräche ein (häufig mindestens ein Gespräch pro Woche) und halten Erkenntnisse in einem gemeinsamen Dokument fest. Aus dem JTBD-Satz entstehen User Stories (Lerneinheit 4.3) und Roadmap-Einträge (Lerneinheit 4.9).

## 4.2 MVP Scope

Das *Minimum Viable Product* (MVP) ist die kleinste Version eines Produkts, mit der man das größte Maß an validiertem Lernen bei den ersten echten Kunden erreicht. Zwei Missverständnisse sind verbreitet. Ein MVP ist nicht „ein schlechtes Produkt“: Es muss das Kernproblem wirklich lösen, nur eben für wenige Fälle. Und ein MVP ist nicht „das erste Release“, sondern ein Experiment mit einer Hypothese: „Wenn wir ... liefern, dann zahlen ... Kunden dafür.“ Je nach Hypothese kann ein MVP eine Landingpage, eine Handarbeit hinter einer einfachen Oberfläche („Concierge-MVP“) oder eine schmale Software sein.

Die Festlegung des Umfangs (*Scope*) ist die schwerste Disziplin, denn jede Funktion ist für irgendjemand wichtig. Hilfreich ist die *MoSCoW-Methode*: *Must have* (ohne geht es nicht), *Should have* (wichtig, aber Umgehung möglich), *Could have* (nice to have) und *Won’t have this time* (bewusst ausgeschlossen). Entscheidend ist der letzte Punkt: Das Streichen wird schriftlich festgehalten, damit es später nicht wie ein Versäumnis wirkt. Dazu kommt die Kapazität: Der Umfang muss in die verfügbare Zeit passen, nicht umgekehrt.

Das folgende Programm wählt aus einer Merkmalsliste zuerst alle Pflichtfunktionen und füllt die restliche Kapazität mit den Funktionen, die das beste Verhältnis aus Nutzen zu Aufwand haben. Es gibt auch aus, was bewusst nicht im MVP landet.

```python
features = [
    # (Name, Nutzen 1-10, Aufwand in Personentagen, muss_sein)
    ("Angebot aus Vorlage",      10, 12, True),
    ("PDF-Export",                8,  4, True),
    ("Materialdatenbank",         9, 15, True),
    ("Rechnung aus Angebot",      7,  6, False),
    ("Mobile App nativ",          6, 30, False),
    ("Statistik-Dashboard",       4, 10, False),
    ("Mehrsprachigkeit",          3,  8, False),
]
kapazitaet = 40
gewaehlt, rest = [], kapazitaet
for name, nutzen, aufwand, muss in features:
    if muss:
        gewaehlt.append(name); rest -= aufwand
print("Pflicht:", gewaehlt, "Rest:", rest)
kandidaten = sorted((f for f in features if not f[3]), key=lambda f: f[1] / f[2], reverse=True)
for name, nutzen, aufwand, _ in kandidaten:
    if aufwand <= rest:
        gewaehlt.append(name); rest -= aufwand
print("MVP:", gewaehlt, "Rest:", rest)
print("Nicht im MVP:", [f[0] for f in features if f[0] not in gewaehlt])
```

Die ersten Zeilen definieren Funktionen mit Nutzen, Aufwand und Kennzeichen „muss sein“. Die erste Schleife zieht den Aufwand der Pflichtfunktionen von der Kapazität ab (31 von 40 Tagen), es bleiben 9 Tage. Die zweite Sortierung ordnet die übrigen nach dem Verhältnis von Nutzen zu Aufwand; die Rechnung aus dem Angebot (6 Tage) passt noch hinein. Alles andere, darunter die native Mobile-App, bleibt draußen. Die Ausgabe der letzten Zeile ist der wichtigste Teil, weil sie eine Entscheidung dokumentiert. Gleichzeitig zeigt das Beispiel eine Grenze: Ein greedy-Verfahren (jeweils das Beste zuerst) liefert nicht in jedem Fall das mathematisch beste Ergebnis, ist aber für diesen Zweck ein verständlicher Ausgangspunkt.

Typische Fehler: Der MVP wächst mit jeder Besprechung („Nur noch dieses eine Feature“), wird mit einem Prototyp ohne Nutzerkontakt verwechselt oder wird nicht an Lernziele gekoppelt. Falsch: „Der MVP ist fertig, wenn alle Funktionen aus der Liste umgesetzt sind.“ Richtig: „Der MVP ist erfolgreich, wenn fünf Pilotbetriebe in vier Wochen mindestens je zehn Angebote damit erstellen.“ Ein weiterer Fehler ist das Weglassen des Betriebs: Wer Hosting, Datensicherung und Support vergisst, hat nach der Veröffentlichung keine Zeit mehr für die Funktionen.

> **Merke**
>
> Ein MVP ist ein Lernexperiment mit minimalem Umfang, das das Kernproblem wirklich löst. Der Umfang folgt der Kapazität; Gestrichenes wird schriftlich festgehalten. Erfolg wird an Lernzielen gemessen, nicht an der Zahl der Funktionen.

> **Praxisbeispiel**
>
> Pilotkunden bekommen den MVP oft zu Sonderkonditionen und liefern dafür regelmäßig Rückmeldungen. Verträge mit ihnen regeln Laufzeit, Datenschutz und Referenzrecht. Die Ergebnisse speisen die Validierungs-Roadmap (Modul 01) und das Pitch Deck (Modul 08).

## 4.3 Requirements Engineering

*Requirements Engineering* (Anforderungsmanagement) bedeutet, Anforderungen an ein Produkt systematisch zu ermitteln, zu beschreiben, zu priorisieren und zu prüfen. Es soll verhindern, dass das Team etwas baut, das niemand wollte, oder dass jeder unter „fertig“ etwas anderes versteht. In agilen Teams sind *User Stories* das Standardformat: „Als \[Rolle\] möchte ich \[Funktion\], damit \[Nutzen\].“ Beispiel: „Als Betriebsinhaberin möchte ich ein Angebot aus einer Vorlage erzeugen, damit ich es im Auto fertigstellen kann.“ Eine Story ist absichtlich kurz; sie ist ein Anlass für ein Gespräch, kein Vertrag.

Zu jeder Story gehören *Akzeptanzkriterien*, also überprüfbare Bedingungen, unter denen sie als erfüllt gilt. Sie lassen sich im Muster „Gegeben ... Wenn ... Dann ...“ (englisch Given/When/Then) schreiben. Diese Form ist so präzise, dass man sie direkt in einen automatischen Test übersetzen kann. Die *Definition of Done* (DoD) legt zusätzlich teamweit fest, was für jede Story gilt, etwa „Code geprüft, Tests grün, Dokumentation ergänzt“. Die DoD ist also die Qualitätsregel für alles, die Akzeptanzkriterien die Regeln für eine bestimmte Funktion.

Ferner unterscheidet man *funktionale Anforderungen* (was das System tut) von *nicht-funktionalen* (wie gut: Antwortzeit, Verfügbarkeit, Sicherheit, Barrierefreiheit). Letztere werden oft vergessen und sind später teuer nachzurüsten. Fachliche Risiken (Wollen Nutzer das?) und technische Risiken (Können wir das?) trennt man, weil sie unterschiedliche Tests brauchen.

Das nächste Beispiel setzt ein Akzeptanzkriterium als automatischen Test um. Die Funktion berechnet die Angebotssumme mit Rabatt und Umsatzsteuer; zwei Tests prüfen sie. Das Programm nutzt das in Python enthaltene Modul `unittest`.

```python
import unittest

def angebotssumme(positionen, rabatt_prozent=0.0, ust_satz=0.20):
    if not positionen:
        raise ValueError("Ein Angebot braucht mindestens eine Position")
    netto = sum(menge * preis for menge, preis in positionen)
    netto *= 1 - rabatt_prozent / 100
    return round(netto, 2), round(netto * (1 + ust_satz), 2)

class Akzeptanz(unittest.TestCase):
    def test_summe_mit_rabatt(self):
        # Gegeben 2 Stueck zu 100 und 1 Stueck zu 50, Wenn 10 Prozent Rabatt, Dann netto 225
        netto, brutto = angebotssumme([(2, 100.0), (1, 50.0)], rabatt_prozent=10)
        self.assertEqual(netto, 225.0)
        self.assertEqual(brutto, 270.0)

    def test_leeres_angebot_wird_abgelehnt(self):
        with self.assertRaises(ValueError):
            angebotssumme([])

unittest.main(argv=["x"], exit=False, verbosity=2)
```

Die Funktion `angebotssumme` erhält Positionen als Paare aus Menge und Einzelpreis, summiert sie, zieht den Rabatt ab und rechnet die Umsatzsteuer dazu. Ein leeres Angebot löst absichtlich einen Fehler aus (`raise ValueError`), weil das Akzeptanzkriterium es so verlangt. Die Testklasse enthält zwei Methoden, deren Namen mit `test_` beginnen; `unittest` findet und führt sie aus. Die Prüfung `assertEqual` vergleicht Soll und Ist, `assertRaises` prüft, dass der erwartete Fehler auftritt. Beide Tests laufen durch („OK“). Ändert später jemand die Rabattlogik fehlerhaft, schlägt der Test sofort an.

Typische Fehler: Stories ohne Nutzen („Als Nutzer möchte ich ein Feld“), unklare Kriterien („muss schnell sein“) und nicht-funktionale Anforderungen vergessen. Falsch: „Die Suche soll schnell sein.“ Richtig: „Die Suche liefert bei 10.000 Materialien in 95 % der Fälle ein Ergebnis in unter 300 Millisekunden.“ Zu vermeiden ist auch die Detailplanung für ein halbes Jahr: Anforderungen ändern sich, wenn Nutzer das Produkt sehen; man plant detailliert nur den nächsten Zyklus.

> **Merke**
>
> User Stories beschreiben Rolle, Funktion und Nutzen; Akzeptanzkriterien machen sie prüfbar, die Definition of Done sichert die Qualität. Nicht-funktionale Anforderungen werden messbar formuliert. Given/When/Then lässt sich direkt als Test umsetzen.

> **Praxisbeispiel**
>
> Im Backlog (der priorisierten Aufgabenliste) stehen Stories mit Kriterien. In der Sprintplanung klärt das Team Fragen, bevor die Arbeit beginnt. Förder- und Pflichtenhefte verlangen oft genau diese Struktur als Nachweis.

## 4.4 UX und Prototyping

*UX* (User Experience, Nutzererlebnis) umfasst alles, was Menschen beim Benutzen eines Produkts erleben: Verständlichkeit, Geschwindigkeit, Fehlerfreiheit, Freude. *Usability* (Gebrauchstauglichkeit) ist der messbare Teil davon: Können die vorgesehenen Nutzer ihre Aufgaben wirksam, effizient und zufriedenstellend erledigen? Gute UX entsteht nicht durch Geschmack, sondern durch Beobachtung echter Nutzer bei echten Aufgaben.

Ein *Prototyp* ist eine vorläufige, absichtlich unvollständige Version, mit der man Ideen früh testet, bevor teurer Code entsteht. Die Reife steigt in Stufen: Papierskizzen, *Wireframes* (schematische Seitenentwürfe ohne Gestaltung), *klickbare Prototypen* (verknüpfte Bildschirme, die sich wie eine App anfühlen) und schließlich lauffähige Teilversionen. Je früher der Test, desto billiger die Korrektur. Bei einem Test bekommen fünf bis acht Personen realistische Aufgaben („Erstellen Sie ein Angebot für ein Bad“), und das Team beobachtet, ohne zu helfen. Schon wenige Tests decken viele Hauptprobleme auf.

Die Ergebnisse lassen sich quantifizieren. Zwei einfache Maße sind die *Aufgabenerfolgsquote* (wie viele Testpersonen haben die Aufgabe geschafft) und die *System Usability Scale* (SUS), ein standardisierter Fragebogen mit zehn Aussagen auf einer Skala von 1 bis 5. Ungerade Aussagen sind positiv, gerade negativ formuliert. Für die Auswertung zieht man bei positiven Aussagen 1 vom Wert ab, bei negativen den Wert von 5 und multipliziert die Summe mit 2,5; das ergibt 0 bis 100.

```python
def sus_score(antworten):
    assert len(antworten) == 10
    summe = 0
    for i, a in enumerate(antworten, 1):
        summe += (a - 1) if i % 2 == 1 else (5 - a)
    return summe * 2.5

testpersonen = [
    [4, 2, 4, 1, 5, 2, 4, 2, 4, 2],
    [3, 3, 4, 2, 4, 3, 3, 2, 4, 3],
    [5, 1, 5, 1, 4, 1, 5, 1, 5, 1],
    [2, 4, 3, 3, 3, 4, 2, 4, 3, 4],
    [4, 2, 5, 2, 4, 2, 4, 1, 4, 2],
]
scores = [sus_score(t) for t in testpersonen]
print("SUS je Person:", scores)
print("Mittelwert:", round(sum(scores) / len(scores), 1))

aufgabe = {"Angebot anlegen": (5, 5), "Material suchen": (3, 5), "PDF senden": (4, 5)}
for name, (geschafft, gesamt) in aufgabe.items():
    print(f"{name:16s} Erfolgsquote {100*geschafft/gesamt:.0f} %")
```

Die Funktion `sus_score` geht die zehn Antworten durch. `enumerate(antworten, 1)` zählt ab 1, sodass `i % 2 == 1` die positiv formulierten (ungeraden) Aussagen erkennt. Die Summe liegt zwischen 0 und 40; mal 2,5 ergibt den Score. Die fünf Testpersonen erreichen 80, 62,5, 97,5, 35 und 80 Punkte, der Mittelwert beträgt 71,0. Als grober Richtwert wird in der Literatur häufig ein Durchschnitt um 68 genannt; darüber gilt die Bedienbarkeit als überdurchschnittlich. Wichtiger als der Mittelwert ist hier die Streuung: Eine Person mit 35 Punkten hat offenbar ein ernstes Problem, das zu klären ist. Die Aufgabenquoten zeigen konkret: Die Materialsuche gelang nur drei von fünf Personen und ist die erste Baustelle.

Typische Fehler: Prototypen testen, die zu polieren sind, so dass Rückmeldungen auf Farben statt auf Abläufe kommen; Teilnehmende anleiten oder beeinflussen; nur Mitarbeitende testen lassen. Falsch: „Probieren Sie den Button rechts oben aus, der ist neu.“ Richtig: Aufgabe stellen („Senden Sie das Angebot an den Kunden“) und schweigend beobachten, wo die Person zögert. Barrierefreiheit (Kontrast, Tastaturbedienung, Screenreader) gehört von Beginn an dazu; sie ist für öffentliche Auftraggeber und in der EU zunehmend rechtlich relevant (Modul 06 und 09).

> **Merke**
>
> UX entsteht durch Beobachtung echter Nutzer bei echten Aufgaben. Prototypen von der Skizze bis zum klickbaren Entwurf sind die billigste Form des Testens. Messgrößen wie Aufgabenerfolg und SUS machen Ergebnisse vergleichbar.

> **Praxisbeispiel**
>
> Werkzeuge für Wireframes und Klickprototypen gibt es viele; wichtiger als das Werkzeug ist der Rhythmus: eine Testrunde mit fünf Personen alle zwei bis drei Wochen. Ergebnisse fließen ins Backlog (Lerneinheit 4.3) und in die Roadmap (Lerneinheit 4.9).

## 4.5 Cloud-Architektur

Die meisten neuen Softwareprodukte laufen in der *Cloud*, also auf Rechenzentren von Anbietern, deren Ressourcen man mietet. Die drei Servicestufen unterscheiden sich darin, wie viel der Anbieter übernimmt. Bei *IaaS* (Infrastructure as a Service) mietet man virtuelle Maschinen, Netzwerke und Speicher und kümmert sich selbst um Betriebssystem und Software. Bei *PaaS* (Platform as a Service) stellt der Anbieter eine Laufzeitumgebung, Datenbanken oder Container-Plattformen bereit; man liefert nur den Code. Bei *SaaS* (Software as a Service) kauft man fertige Anwendungen. Ein junges Team wählt in der Regel möglichst viel PaaS oder verwaltete Dienste, um wenig Betrieb selbst leisten zu müssen.

Für Software, die mehrere Kunden bedient, ist die *Mandantenfähigkeit* (englisch *multi-tenancy*) eine Kernfrage. Ein Mandant (*Tenant*) ist ein Kunde mit eigenen Daten. Bei einer gemeinsamen Datenbank mit Mandantenkennung (`mandant`-Spalte) teilen sich alle Kunden dieselben Tabellen; das ist günstig und einfach zu verwalten, verlangt aber, dass jede Abfrage nach dem Mandanten filtert. Alternativen sind ein eigenes Schema oder eine eigene Datenbank je Mandant: teurer, dafür mit stärkerer Trennung, etwa für Großkunden mit strengen Anforderungen. Die Entscheidung beeinflusst Kosten, Sicherheit, Backup und Skalierung.

> **Ergänzung aus der Nachrecherche**
>
> Der *EU Data Act* gilt teilweise seit 12. September 2025 und verlangt von Anbietern von Cloud- und SaaS-Diensten, dass Kunden zu einem anderen Anbieter oder in eine eigene Umgebung wechseln und ihre exportierbaren Daten und digitalen Vermögenswerte mitnehmen können. Die Kündigungsfrist für den Wechsel darf höchstens zwei Monate betragen; für SaaS-Anbieter dürfen spätestens ab 12. Jänner 2027 keine Wechselentgelte mehr erhoben werden (Quelle Q5; keine Rechtsberatung). Architektonisch heißt das: Export- und Schnittstellenfunktionen für Kundendaten sind keine Zusatzfunktion, sondern Bestandteil des Produkts, und Mandantentrennung erleichtert den vollständigen Export einzelner Kunden.

Das Beispiel zeigt den häufigsten Fehler bei gemeinsamer Datenbank und seine Korrektur. Zwei Mandanten haben Angebote in derselben Tabelle. Die Funktion `liste_falsch` vergisst den Filter und liefert dadurch fremde Daten; die Funktion `liste_richtig` filtert über einen Parameter.

```python
import sqlite3
db = sqlite3.connect(":memory:")
db.executescript("""
CREATE TABLE angebot (id INTEGER PRIMARY KEY, mandant TEXT NOT NULL, titel TEXT, summe REAL);
INSERT INTO angebot (mandant, titel, summe) VALUES
 ('meier', 'Badsanierung', 8400), ('meier', 'Elektro Neubau', 12000),
 ('huber', 'Dachfenster', 3100);
""")

def liste_falsch(mandant):
    # FEHLER: Mandant wird nicht fuer den Filter benutzt
    return db.execute("SELECT titel FROM angebot").fetchall()

def liste_richtig(mandant):
    return db.execute("SELECT titel FROM angebot WHERE mandant = ?", (mandant,)).fetchall()

print("falsch (huber):", liste_falsch("huber"))
print("richtig (huber):", liste_richtig("huber"))
```

Das Skript legt eine In-Memory-Datenbank an und füllt sie mit drei Zeilen. Die falsche Funktion liefert alle drei Titel zurück, also auch die der Firma Meier, ein klassischer Datenleck-Fehler mit schweren Folgen für Datenschutz und Vertrauen (Modul 06). Die richtige Variante ergänzt `WHERE mandant = ?` und gibt nur „Dachfenster“ zurück. Der Platzhalter sorgt zugleich dafür, dass Eingaben nicht als SQL-Code interpretiert werden. In echten Systemen erzwingt man die Trennung zusätzlich zentral, zum Beispiel über eine Zugriffsschicht oder datenbankseitige Zeilenrichtlinien, damit ein vergessener Filter nicht reicht.

Weitere Architekturgrundsätze für junge Teams: Mit einem *modularen Monolithen* (eine Anwendung, intern klar getrennte Module) beginnen und erst bei echtem Bedarf in Dienste aufteilen; auf verwaltete Datenbanken setzen; Konfiguration und Zugangsdaten nie im Code speichern; Betriebskosten von Anfang an beobachten, denn Cloud-Rechnungen wachsen leise. Typische Fehler sind die frühe Verteilung in viele Microservices ohne Bedarf, Vergessen von Backups und der Wechsel zwischen Anbietern ohne Exit-Plan. Falsch: „Wir bauen von Anfang an wie ein Konzern, mit zwölf Diensten.“ Richtig: ein Monolith mit sauberer Modulgrenze, der bei Last oder Teamwachstum zerlegt werden kann.

> **Merke**
>
> IaaS, PaaS und SaaS unterscheiden sich im Umfang der Anbieterleistung. Für mehrere Kunden braucht es Mandantentrennung, die in jeder Abfrage durchgesetzt wird. Junge Teams starten einfach: modularer Monolith, verwaltete Dienste, Exportfunktion von Anfang an.

> **Praxisbeispiel**
>
> Großkunden fragen in Beschaffungsprozessen nach Hosting-Standort, Mandantentrennung, Backups und Exit-Regelung (Modul 12, Enterprise Readiness). Wer diese Fragen mit einer Architekturskizze beantworten kann, verkürzt Verkaufszyklen.

## 4.6 Build-vs-Buy

Bei jeder Komponente stellt sich die Frage, ob man sie selbst entwickelt (*Build*), als Open-Source-Software selbst betreibt oder als Dienst eines Drittanbieters zukauft (*Buy*). Die Grundregel lautet: Selbst baut man, was das Alleinstellungsmerkmal ausmacht; alles andere kauft man, solange es gut genug ist. Anmeldung, Zahlungsabwicklung, E-Mail-Versand und Monitoring sind selten die Stärke eines jungen Teams, und eigene Lösungen kosten Entwicklungszeit, die im Kernprodukt fehlt.

Die Entscheidung stützt sich auf die *Gesamtkosten über die Nutzungsdauer* (englisch *Total Cost of Ownership*, TCO). Sie umfassen einmalige Kosten (Entwicklung, Einrichtung), laufende Gebühren und den Personalaufwand für Betrieb, Updates und Sicherheit. Hinzu kommen Risiken: *Abhängigkeit* vom Anbieter (Preiserhöhung, Einstellung, Ausfall), *Lizenzrisiken* bei Open Source (Copyleft-Lizenzen können Pflichten zur Offenlegung auslösen; Modul 11) sowie Datenschutz und Datenstandort. Das Wechselrecht aus dem Data Act (siehe Lerneinheit 4.5) senkt für Cloud-Dienste das Lock-in-Risiko, ersetzt aber keine Exit-Planung.

Das Beispiel rechnet drei Varianten für eine Anmeldefunktion über drei Jahre. Die Risikozuschläge sind Aufschläge für Unsicherheit: Eigenentwicklungen überschreiten ihr Budget erfahrungsgemäß öfter als gekaufte Dienste.

```python
def tco(einmalig, monatlich, jahre=3, personal_monatlich=0, risiko_zuschlag=0.0):
    gesamt = einmalig + (monatlich + personal_monatlich) * 12 * jahre
    return round(gesamt * (1 + risiko_zuschlag))

optionen = {
    "Build (eigene Auth)":       tco(24000, 100, personal_monatlich=1500, risiko_zuschlag=0.20),
    "Buy (Auth-Dienst)":         tco(2000,  350, personal_monatlich=150,  risiko_zuschlag=0.10),
    "Open Source selbst hosten": tco(6000,  120, personal_monatlich=600,  risiko_zuschlag=0.15),
}
for name, wert in sorted(optionen.items(), key=lambda x: x[1]):
    print(f"{wert:7d} EUR  {name}")
```

Die Funktion addiert einmalige Kosten und drei Jahre monatliche Gebühren samt Personalaufwand und multipliziert mit dem Risikoaufschlag. Die Eigenentwicklung kommt auf 97.920 EUR, der gekaufte Dienst auf 22.000 EUR und die selbst betriebene Open-Source-Lösung auf 36.708 EUR. Der Unterschied entsteht vor allem durch den Personalaufwand für Wartung und Sicherheit, der in der Planung gern vergessen wird. Die Zahlen sind Annahmen, aber die Aussage ist belastbar: Was nicht Kern ist, kauft man.

Typische Fehler: Aus Technikfreude alles selbst bauen („Not invented here“), den Wartungsaufwand ignorieren, Lizenzen nicht prüfen und Anbieter ohne Exit-Strategie wählen. Falsch: „Open Source ist kostenlos.“ Richtig: Die Lizenz ist kostenlos, Betrieb, Updates, Sicherheitsfixes und Support kosten Personal. Ein weiterer Fehler ist das Gegenteil: den Kern auszulagern, sodass das Unternehmen austauschbar wird. Sinnvoll ist ein *Architekturentscheidungsprotokoll* (ADR), das kurz festhält, was entschieden wurde, welche Alternativen es gab und warum.

> **Merke**
>
> Selbst bauen, was einzigartig ist; zukaufen, was Standard ist. Entscheidungsgrundlage ist die Gesamtkostenrechnung mit Personal und Risikoaufschlag, nicht der Listenpreis. Abhängigkeiten und Lizenzen werden vorab bewertet und dokumentiert.

> **Praxisbeispiel**
>
> Investoren und Kunden fragen in der Due Diligence nach Drittkomponenten und Lizenzen (Modul 08 und 11). Eine gepflegte Liste aller Abhängigkeiten mit Version, Lizenz und Zweck erspart Wochen an Rückfragen.

## 4.7 Datenmodell und APIs

Das *Datenmodell* beschreibt, welche Dinge ein System kennt (die *Entitäten*, zum Beispiel Kunde, Angebot, Position) und wie sie zusammenhängen. In einer relationalen Datenbank wird jede Entität zu einer Tabelle, jede Eigenschaft zu einer Spalte, und Beziehungen werden über *Fremdschlüssel* abgebildet: Ein Angebot verweist auf den Kunden, dem es gehört. Ein gutes Modell bildet die Fachsprache ab und lässt sich erweitern, ohne alles umzubauen. Es lohnt sich, die Kernobjekte früh zu skizzieren, weil spätere Änderungen an gespeicherten Daten schwierig sind.

Eine *API* (Application Programming Interface, Programmierschnittstelle) ist die definierte Möglichkeit, wie andere Programme mit dem System sprechen. Im Web hat sich der Stil *REST* durchgesetzt: Ressourcen haben eine Adresse (zum Beispiel `/angebote/1`), und das HTTP-Verb bestimmt die Aktion (GET lesen, POST anlegen, PUT oder PATCH ändern, DELETE löschen). Antworten kommen meist als *JSON*, einem leichten Textformat für strukturierte Daten. Statuscodes teilen das Ergebnis mit: 200 für Erfolg, 404 für „nicht gefunden“, 400 für fehlerhafte Anfragen. Gute APIs sind stabil und versioniert, denn Kunden bauen Integrationen darauf (Erweiterbarkeit für Integrationen).

Das folgende Beispiel baut beides in einem Programm: ein kleines relationales Modell mit Fremdschlüssel und einen minimalen HTTP-Server, der Angebote als JSON ausliefert. Das Skript startet den Server auf einem freien Port auf dem eigenen Rechner, ruft ihn auf und beendet ihn wieder.

```python
import json, sqlite3, threading, urllib.request, urllib.error
from http.server import BaseHTTPRequestHandler, HTTPServer

db = sqlite3.connect(":memory:", check_same_thread=False)
db.executescript("""
CREATE TABLE kunde (id INTEGER PRIMARY KEY, name TEXT NOT NULL);
CREATE TABLE angebot (id INTEGER PRIMARY KEY, kunde_id INTEGER NOT NULL REFERENCES kunde(id),
                      titel TEXT NOT NULL, summe REAL NOT NULL);
INSERT INTO kunde VALUES (1, 'Familie Berger');
INSERT INTO angebot VALUES (1, 1, 'Badsanierung', 8400.0);
""")

class Api(BaseHTTPRequestHandler):
    def do_GET(self):
        teile = self.path.strip("/").split("/")
        if len(teile) == 2 and teile[0] == "angebote" and teile[1].isdigit():
            zeile = db.execute("SELECT a.id, a.titel, a.summe, k.name FROM angebot a "
                               "JOIN kunde k ON k.id = a.kunde_id WHERE a.id = ?",
                               (int(teile[1]),)).fetchone()
            if zeile:
                body = json.dumps({"id": zeile[0], "titel": zeile[1],
                                   "summe": zeile[2], "kunde": zeile[3]})
                self.send_response(200)
            else:
                body = json.dumps({"fehler": "nicht gefunden"})
                self.send_response(404)
        else:
            body = json.dumps({"fehler": "ungueltiger Pfad"})
            self.send_response(400)
        self.send_header("Content-Type", "application/json")
        self.end_headers()
        self.wfile.write(body.encode())
    def log_message(self, *args):
        pass

server = HTTPServer(("127.0.0.1", 0), Api)
threading.Thread(target=server.serve_forever, daemon=True).start()
basis = f"http://127.0.0.1:{server.server_port}"

print(json.loads(urllib.request.urlopen(basis + "/angebote/1").read()))
try:
    urllib.request.urlopen(basis + "/angebote/99")
except urllib.error.HTTPError as e:
    print("Status", e.code, json.loads(e.read()))
server.shutdown()
```

Die beiden `CREATE TABLE`-Anweisungen bilden das Modell; die Klausel `REFERENCES kunde(id)` deklariert den Fremdschlüssel. Die Klasse `Api` bearbeitet GET-Anfragen: Sie zerlegt den Pfad, prüft das Muster `/angebote/<Zahl>`, fragt die Datenbank mit einem JOIN (einer Verknüpfung beider Tabellen) ab und antwortet mit JSON und Statuscode. Die Port-Nummer 0 lässt das Betriebssystem einen freien Port wählen; der Server läuft in einem Hintergrund-Thread. Die Ausgabe zeigt zuerst das Angebot als JSON-Objekt, dann den Status 404 mit der Fehlermeldung. Das Programm demonstriert auch, dass Eingaben validiert werden: Pfade, die nicht dem Muster entsprechen, liefern 400, statt Fehler im System auszulösen.

Typische Fehler: Datenbankstrukturen ohne Schlüssel und Beziehungen, Felder, die mehrere Werte in einem Text sammeln, eine API ohne Versionierung („/v1/“), unklare Fehlermeldungen und Antworten, die interne Strukturen offenlegen. Falsch: Ein Feld `kunde` mit Text „Berger, Wien, 0664...“. Richtig: Eigene Entität Kunde mit getrennten Feldern und Fremdschlüssel. Auch wichtig: Authentifizierung und Berechtigungen gehören an jede Schnittstelle (Modul 06). Das Beispiel oben lässt sie aus Gründen der Kürze weg und wäre so nicht produktionsreif.

> **Merke**
>
> Das Datenmodell bildet die Fachwelt in Entitäten und Beziehungen ab; Fremdschlüssel sichern die Verbindungen. APIs sind stabile, versionierte Verträge mit Statuscodes und JSON. Zugriffsschutz und Validierung sind Pflicht.

> **Praxisbeispiel**
>
> Kunden mit eigener IT möchten Daten aus dem Produkt ziehen und in andere Systeme (Buchhaltung, ERP) schieben. Eine dokumentierte API ist daher oft ein Verkaufsargument. Die API-Dokumentation entsteht heute meist automatisch aus einer maschinenlesbaren Beschreibung (OpenAPI).

## 4.8 Technical Debt Management

*Technische Schulden* (englisch *Technical Debt*) sind Abkürzungen in Architektur und Code, die kurzfristig Zeit sparen und langfristig Mehrkosten verursachen. Die Metapher stammt aus dem Finanzwesen: Man nimmt einen Kredit auf, um schneller zu liefern, und zahlt später Zinsen in Form von langsamerer Entwicklung, mehr Fehlern und höherem Risiko. Wie im echten Leben sind Schulden nicht grundsätzlich schlecht. Ein Startup, das ohne eine perfekte Architektur den Markt testen kann, nutzt sie sinnvoll. Schlecht sind *unbewusste* und *unverwaltete* Schulden.

Man unterscheidet bewusste von unbewussten Schulden (aus Unwissen) und kurzfristig tragbare von gefährlichen. Das Management besteht aus vier Schritten. Erstens *sichtbar machen*: Schulden kommen mit Beschreibung, Ort und Folgen in eine Liste. Zweitens *bewerten*: Wie viel Zeit verlieren wir pro Sprint (der „Zins“), und wie groß ist der Aufwand zur Behebung (die „Tilgung“)? Drittens *entscheiden*: Was wird jetzt getilgt, was später, was bewusst akzeptiert? Viertens *einplanen*: Ein fester Anteil jedes Sprints (häufig 10 bis 20 %) fließt in Tilgung, damit die Last nicht anwächst.

```python
schulden = [
    # (Beschreibung, Stunden Verlust pro Sprint, Aufwand zur Behebung in Stunden, Risiko 1-5)
    ("Keine Tests im Abrechnungsmodul", 6, 40, 5),
    ("Dupliziertes Rabatt-Code",         3, 12, 2),
    ("Veraltete Bibliothek",             1, 16, 4),
    ("Unklare Namensgebung",             2, 30, 1),
]
sprints_horizont = 8
for text, zins, aufwand, risiko in sorted(schulden, key=lambda s: s[2] / s[1]):
    payback = aufwand / zins
    entscheidung = "JETZT" if payback <= sprints_horizont or risiko >= 4 else "spaeter"
    print(f"{entscheidung:8s} Payback {payback:5.1f} Sprints, Risiko {risiko}: {text}")
```

Jeder Eintrag enthält den „Zins“ (verlorene Stunden pro Sprint), den Aufwand zur Behebung und ein Risiko. Der Payback in Sprints ist Aufwand geteilt durch Zins, also die Zeit, nach der sich die Behebung amortisiert hat. Die Entscheidungsregel lautet: tilgen, wenn sich die Behebung innerhalb von acht Sprints rechnet oder das Risiko hoch ist (4 oder 5). Das Ergebnis: Das duplizierte Rabatt-Code (Payback 4,0) und die fehlenden Tests im Abrechnungsmodul (6,7 Sprints und Risiko 5) sind sofort dran, die veraltete Bibliothek trotz Payback von 16 Sprints wegen des Risikos ebenfalls, die Namensgebung später. Die Regel zeigt, dass Risiko die reine Zeitrechnung übersteuern darf.

Typische Fehler: Schulden nicht dokumentieren, keine Zeit für Tilgung einplanen und die Schuldenlast dem Management nicht vermitteln. Falsch: „Wir räumen irgendwann auf.“ Richtig: Einen festen Anteil jedes Sprints reservieren und die Schulden mit Zins und Risiko in Zahlen ausdrücken. Ein Totalumbau („Rewrite“) ist selten die richtige Antwort, weil er lange dauert, in der Zeit keinen Kundennutzen liefert und neue Fehler erzeugt. Besser ist, in kleinen Schritten zu verbessern (Refactoring) und beim Anfassen von altem Code Tests nachzuziehen.

> **Merke**
>
> Technische Schulden sind Kredite mit Zinsen. Bewusst aufgenommene Schulden sind legitim, wenn sie dokumentiert, bewertet und eingeplant sind. Ein fester Tilgungsanteil pro Sprint ist besser als ein späterer Großumbau.

> **Praxisbeispiel**
>
> In der Due Diligence prüfen technische Gutachter Testabdeckung, veraltete Abhängigkeiten und Dokumentation. Ein geführtes Schuldenregister zeigt, dass das Team seine Risiken kennt. Es verbindet sich mit der Sicherheit (Modul 06, Schwachstellen) und dem Betrieb (Modul 05).

## 4.9 Product Roadmap

Die *Product Roadmap* zeigt, in welche Richtung sich das Produkt entwickeln soll und warum. Eine gute Roadmap ist *outcome-basiert*: Sie nennt nicht Funktionen mit Terminen („Im März kommt Funktion X“), sondern Ziele und gewünschte Wirkungen („Neue Betriebe erstellen ihr erstes Angebot in unter 15 Minuten“). Funktionen sind Wege dorthin und können sich ändern, wenn Tests zeigen, dass ein anderer Weg besser ist. Die Roadmap ist damit ein Kommunikationsmittel für Team, Kunden und Geldgeber und kein Versprechen. Üblich ist eine Einteilung in „Jetzt“, „Als Nächstes“ und „Später“ mit abnehmender Genauigkeit.

Die Reihenfolge ergibt sich aus Kundenfeedback, Umsatz und Risiko. Zur Priorisierung eignet sich das *RICE-Modell*: *Reach* (Reichweite: wie viele Kunden pro Zeitraum sind betroffen?), *Impact* (Wirkung pro Kunde), *Confidence* (Sicherheit der Schätzung, 0 bis 1) und *Effort* (Aufwand in Personenmonaten). Der Wert ist Reichweite mal Wirkung mal Sicherheit geteilt durch Aufwand. Das Modell zwingt, Annahmen zu benennen und Unsicherheit auszudrücken. Es ersetzt kein Urteil, sondern strukturiert die Diskussion.

```python
initiativen = [
    # (Name, Reichweite Kunden/Quartal, Wirkung 0.25-3, Sicherheit 0-1, Aufwand Personenmonate)
    ("Rechnung aus Angebot",  120, 2.0, 0.8, 2.0),
    ("Mehrsprachigkeit",       40, 1.0, 0.5, 3.0),
    ("Materialpreis-Import",  150, 3.0, 0.6, 4.0),
    ("Statistik-Dashboard",    60, 0.5, 0.9, 2.5),
]
def rice(r, w, s, a):
    return r * w * s / a
for name, r, w, s, a in sorted(initiativen, key=lambda i: rice(*i[1:]), reverse=True):
    print(f"RICE {rice(r, w, s, a):6.1f}  {name}")
```

Die Funktion `rice` folgt der Formel; `rice(*i[1:])` übergibt die vier Zahlen eines Eintrags ohne den Namen. Das Ergebnis: Die Rechnung aus dem Angebot erreicht 96,0, der Materialpreis-Import 67,5, das Dashboard 10,8 und die Mehrsprachigkeit 6,7. Die Diskussion beginnt dort, wo die Zahlen überraschen: Der Import hätte die größte Wirkung, aber der hohe Aufwand und die niedrigere Sicherheit drücken ihn auf Platz 2. Das Team kann nun entscheiden, die Unsicherheit durch einen kleinen Test zu senken, bevor es investiert.

Typische Fehler: Roadmaps als Terminversprechen, Funktionslisten ohne Ziel, kein Abgleich mit Strategie und Finanzen und das Erfüllen jedes Kundenwunsches. Falsch: Eine auf zwölf Monate genaue Funktionsplanung, die nach einem Quartal wertlos ist. Richtig: Konkrete Planung für das laufende Quartal, Ziele für das nächste, Themen für später. Ebenso falsch ist es, die Zahlen zu glauben: RICE-Werte hängen an geschätzten Eingaben und gehören mit Erkenntnissen nachgeschärft.

> **Merke**
>
> Eine Roadmap nennt Ziele und erwartete Wirkungen, nicht nur Funktionen und Termine. Priorisiert wird mit transparenten Kriterien wie RICE; Annahmen und Unsicherheiten gehören offen auf den Tisch. Sie wird regelmäßig überprüft.

> **Praxisbeispiel**
>
> Für Investoren wird die Roadmap mit Finanzierungsmeilensteinen verknüpft (Modul 08, Funding Roadmap); für Kunden gibt es eine öffentliche Fassung ohne Terminzusagen. Intern verbindet sie Discovery (4.1), MVP (4.2) und Schuldenabbau (4.8).

## Übungsaufgaben zu Modul 04

1.  **(leicht)** Erkläre den Unterschied zwischen einem MVP und einem Prototyp. Wann ist ein Concierge-MVP sinnvoll?

2.  **(leicht)** Formuliere zu der Story „Als Betriebsinhaberin möchte ich ein Angebot als PDF versenden, damit der Kunde es prüfen kann“ drei Akzeptanzkriterien im Muster Gegeben/Wenn/Dann.

3.  **(leicht)** Warum reicht in einer gemeinsamen Datenbank für mehrere Kunden eine Filterspalte nicht aus, wenn sie nur in der Anwendung gesetzt wird? Nenne zwei Alternativen zur Trennung.

4.  **(mittel)** Erkläre die Unterschiede zwischen IaaS, PaaS und SaaS an je einem Beispiel und nenne, welche Stufe ein Zwei-Personen-Team vorzugsweise wählt.

5.  **(mittel)** Ein Team besitzt eine Technical-Debt-Position mit 4 Stunden Zins pro Sprint und 60 Stunden Behebungsaufwand. Berechne den Payback. Würdest du sie tilgen? Begründe.

6.  **(praktisch)** Passe das Programm aus 4.2 auf eine Kapazität von 25 Personentagen an. Was ändert sich, und wie sollte das Programm reagieren?

7.  **(praktisch)** Erweitere das RICE-Programm aus 4.9 so, dass Initiativen mit Sicherheit unter 0,6 als „erst validieren“ gekennzeichnet werden.

8.  **(schwer/praktisch)** Schreibe zwei `unittest`-Tests für `sus_score` (bestmögliche und schlechtestmögliche Antworten) und einen Test, der sicherstellt, dass `liste_richtig` aus 4.5 nur Angebote des angefragten Mandanten liefert.

## Lösungen zu den Übungsaufgaben Modul 04

**1.** Ein Prototyp dient dem Test von Bedienung und Idee, oft ohne echte Funktion. Ein MVP ist ein einsetzbares Produkt in kleinstem Umfang, mit dem echte Kunden echten Nutzen erleben und das echte Zahlungsbereitschaft zeigt. Ein Concierge-MVP erbringt die Leistung zunächst von Hand hinter einer einfachen Oberfläche; er ist sinnvoll, wenn unklar ist, ob das Ergebnis gewünscht wird, und die Automatisierung teuer wäre.

**2.** Beispiele: (a) Gegeben ein vollständiges Angebot, wenn die Nutzerin „Als PDF senden“ wählt, dann erhält der Kunde eine E-Mail mit PDF-Anhang. (b) Gegeben ein Angebot ohne Kundenadresse, wenn sie senden will, dann erscheint ein Hinweis auf das fehlende Feld und es wird nichts versendet. (c) Gegeben ein versendetes Angebot, wenn sie die Liste öffnet, dann steht der Status „versendet“ mit Datum dort.

**3.** Ein einzelner vergessener Filter genügt für ein Datenleck; die Trennung muss zentral erzwungen werden (zum Beispiel in einer Zugriffsschicht oder durch Zeilenrichtlinien der Datenbank). Alternativen: eigenes Schema oder eigene Datenbank pro Mandant, im Extremfall getrennte Umgebungen für Großkunden.

**4.** IaaS: virtuelle Maschine bei einem Cloud-Anbieter, man verwaltet Betriebssystem und Software selbst. PaaS: verwaltete Plattform oder Datenbank, man liefert Code und Konfiguration. SaaS: fertige Anwendung wie ein E-Mail- oder Buchhaltungsdienst. Ein kleines Team wählt bevorzugt PaaS und SaaS, weil der Betriebsaufwand klein bleibt.

**5.** Payback = 60/4 = 15 Sprints. Nach der Regel mit Horizont acht Sprints würde man sie nicht allein wegen der Zeit tilgen, wohl aber, wenn das Risiko hoch ist (zum Beispiel bei sicherheitsrelevantem Code) oder wenn der Zins mit wachsendem Team steigt. Die Entscheidung hängt also vom Risiko und vom erwarteten Wachstum ab.

**6.** Mit `kapazitaet = 25` sind die Pflichtfunktionen (31 Tage) größer als die Kapazität; der Rest wird −6. Das Programm sollte das erkennen und melden, statt stillschweigend weiterzurechnen:

```python
kapazitaet = 25
pflicht = sum(f[2] for f in features if f[3])
if pflicht > kapazitaet:
    print(f"Pflichtumfang {pflicht} Tage uebersteigt Kapazitaet {kapazitaet}:")
    print("Scope schneiden, Kapazitaet erhoehen oder Pflicht neu bewerten")
```

Die Ausgabe weist auf einen Konflikt hin, den das Team lösen muss, zum Beispiel indem es das Materialdatenbank-Feature (15 Tage) auf eine kleine Startliste reduziert.

**7.** Ergänzung der Schleife:

```python
for name, r, w, s, a in sorted(initiativen, key=lambda i: rice(*i[1:]), reverse=True):
    hinweis = "  <- erst validieren" if s < 0.6 else ""
    print(f"RICE {rice(r, w, s, a):6.1f}  {name}{hinweis}")
```

Die Mehrsprachigkeit (Sicherheit 0,5) erhält den Hinweis; der Materialpreis-Import mit Sicherheit 0,6 gerade nicht, da die Bedingung „kleiner als 0,6“ lautet.

**8.** Eine mögliche Lösung (mit den Funktionen und Daten aus 4.4 und 4.5 im selben Programm):

```python
import unittest

class Pruefung(unittest.TestCase):
    def test_sus_bestwert(self):
        self.assertEqual(sus_score([5, 1] * 5), 100.0)

    def test_sus_schlechtester_wert(self):
        self.assertEqual(sus_score([1, 5] * 5), 0.0)

    def test_mandantentrennung(self):
        titel = [z[0] for z in liste_richtig("huber")]
        self.assertEqual(titel, ["Dachfenster"])

unittest.main(argv=["x"], exit=False, verbosity=2)
```

Die Tests zeigen auch, wie Fachregeln (Skala 0 bis 100) und Sicherheitsregeln (Mandantentrennung) als ausführbare Prüfungen festgehalten werden.
