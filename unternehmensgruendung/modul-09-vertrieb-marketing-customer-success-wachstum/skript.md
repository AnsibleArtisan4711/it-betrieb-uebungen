# Modul 09 - Vertrieb, Marketing, Customer Success und Wachstum

> **Hinweis zu diesem Kapitel:** Das ist das Kapitel des Skripts „Unternehmensgründung“, aus der LaTeX-Quelle in Markdown umgewandelt (Text und Codeblöcke unverändert, farbige Boxen als Zitatblöcke mit fettem Titel, Tabellen als Markdown-Tabellen). Die Lerneinheiten sind wie in der Quelle nach Modul nummeriert (9.1 bis 9.9), danach folgen „Übungsaufgaben zu Modul 09“ (8 Aufgaben, mit Schwierigkeitsangabe) und „Lösungen zu den Übungsaufgaben Modul 09“. Rechtliche und steuerliche Aussagen sind keine Rechtsberatung. Was ich an den Beispielen geprüft habe, steht in der [README des Repositories](../README.md). Übersicht zum Modul: [README](README.md).

**Dauer:** 10 h laut Modulübersicht (Summe der Einzelwerte: 9 × 1,1 h = 9,9 h, gerundet)

**Priorität:** 2

| **Nr.** | **Lerneinheit**                | **Dauer (h)** |
|--------:|:-------------------------------|--------------:|
|     9.1 | Brand und Positionierung       |           1,1 |
|     9.2 | Demand Generation              |           1,1 |
|     9.3 | Sales Funnel                   |           1,1 |
|     9.4 | CRM Betrieb                    |           1,1 |
|     9.5 | Demo und Pre-Sales             |           1,1 |
|     9.6 | Customer Success               |           1,1 |
|     9.7 | Pricing und Packaging im Markt |           1,1 |
|     9.8 | Partnervertrieb                |           1,1 |
|     9.9 | Growth Experimente             |           1,1 |
|         | **Summe**                      |       **9,9** |

Ein gutes Produkt verkauft sich nicht von selbst. Dieses Modul zeigt, wie ein Technikunternehmen Aufmerksamkeit erzeugt, daraus Kunden macht, diese Kunden hält und mit ihnen wächst. Das Thema hängt eng mit den Modulen davor zusammen: Wer die Kunden und das Wertversprechen nicht kennt (Modul 01 und 03), kann auch keine gute Botschaft formulieren, und ohne saubere Kennzahlen (Modul 07) lässt sich nicht beurteilen, welcher Kanal sich lohnt. Die Programme laufen mit Python 3 ohne Zusatzpakete. Alle Zahlen sind erfundene Beispiele. Rechtliche Aussagen sind allgemeine Information und **keine Rechtsberatung**.

## 9.1 Brand und Positionierung

Die *Marke* (englisch *Brand*) ist die Gesamtheit dessen, was Menschen mit einem Unternehmen verbinden: Name, Auftritt, Versprechen und vor allem Erfahrungen. Für ein junges Technikunternehmen erfüllt sie drei Aufgaben. Sie schafft *Vertrauen*, weil ein Kunde, der das Unternehmen nicht kennt, ein Risiko eingeht und Anzeichen für Seriosität sucht. Sie ordnet das Angebot in eine *Kategorie* ein, damit man schnell versteht, womit man es zu tun hat. Und sie sorgt für *Wiedererkennung*, damit sich Menschen nach dem ersten Kontakt erinnern. Die *Positionierung* (Grundlagen in Modul 01 und 03) legt fest, für wen das Produkt gedacht ist, welches Problem es löst und warum es besser ist als die Alternativen; sie ist die Entscheidung, die der Marke ihren Inhalt gibt.

Bei technischen Produkten liegt die Schwierigkeit darin, *technische Differenzierung verständlich zu kommunizieren*. Entwicklerinnen und Entwickler freuen sich über eine elegante Architektur, Einkäufer und Fachabteilungen interessiert dagegen, was sich für sie ändert. Der Weg führt vom Merkmal über den Nutzen zum Beleg: „Wir verwenden ein neuartiges Verfahren“ ist ein Merkmal, „Ihr Support-Team beantwortet 40 Prozent mehr Tickets pro Tag“ ist ein Nutzen mit Zahl. Bewährt hat sich ein Positionierungssatz nach dem Muster „Für \[Zielgruppe\], die \[Problem\] haben, ist \[Produkt\] eine \[Kategorie\], die \[Hauptnutzen\] bietet, im Gegensatz zu \[Alternative\], weil \[Beleg\].“ Unbelegte Superlative („die beste Lösung“) und Modewörter („ganzheitlich“, „innovativ“) schaden mehr, als sie nützen, weil sie austauschbar sind und Misstrauen wecken.

Das folgende Programm prüft einen Werbetext satzweise: Es zählt die Wörter, sucht Modewörter und unbelegte Superlative und prüft, ob eine Zahl als Beleg vorkommt.

```python
import re
JARGON = ("synergie", "disruptiv", "ganzheitlich", "revolution", "innovativ", "next-generation")
UNBELEGT = ("beste", "fuehrend", "einzigartig", "perfekt")
text = ("Unsere innovative Plattform ermoeglicht ganzheitliche Synergien. "
        "Ihr Support-Team beantwortet 40 Prozent mehr Tickets pro Tag, weil die Software Antworten vorschlaegt. "
        "Wir sind die beste Loesung am Markt.")
saetze = [s.strip() for s in re.split(r"[.!?]", text) if s.strip()]
for s in saetze:
    woerter = re.findall(r"[\w-]+", s.lower())
    jargon = [w for w in woerter if w.startswith(JARGON)]
    behauptung = [w for w in woerter if w in UNBELEGT]
    hat_zahl = any(ch.isdigit() for ch in s)
    print(f"{len(woerter):2d} Woerter | Jargon: {jargon or '-'} | Superlativ: {behauptung or '-'} | Zahl: {'ja' if hat_zahl else 'nein'}")
    if (jargon or behauptung) and not hat_zahl:
        print("   -> Aussage ohne Beleg, umformulieren")
```

Der Text wird mit einem regulären Ausdruck in Sätze zerlegt. Für jeden Satz werden die Wörter in Kleinbuchstaben ermittelt; `startswith` mit einem Tupel prüft, ob ein Wort mit einem der Stichwörter beginnt, wodurch auch Beugungen wie „innovative“ oder „Synergien“ erfasst werden. Der erste Satz hat sechs Wörter und enthält drei Modewörter (innovative, ganzheitliche, Synergien) ohne Zahl; das Programm schlägt vor, ihn umzuformulieren. Der zweite Satz mit 14 Wörtern nennt 40 Prozent und gilt damit als belegt. Der dritte Satz mit sieben Wörtern behauptet „die beste Lösung“ ohne Beleg und wird ebenfalls markiert. Das ist natürlich nur eine grobe Hilfe, ersetzt aber nicht das Urteil eines Menschen. Sie zeigt aber, wie sich Botschaftsprüfung zu einer festen Gewohnheit machen lässt.

Typische Fehler sind ein Auftritt, der für alle etwas sein will, Botschaften aus Sicht der Technik statt des Kunden und ein Name oder eine Domain, die später rechtliche Probleme bereitet (Modul 11, IP-Strategie). Falsch: „Wir bieten eine KI-basierte, skalierbare Cloud-Plattform.“ Richtig: „Wir verkürzen die Bearbeitungszeit von Support-Tickets im Mittelstand um 40 Prozent.“ Eine Marke wächst durch Konsistenz: gleiche Aussagen auf Website, Verkaufsunterlagen und in der Demo.

> **Merke**
>
> Marke schafft Vertrauen, Kategorie und Wiedererkennung. Technische Differenzierung wird über Nutzen und Beleg erklärt, nicht über Merkmale. Modewörter und unbelegte Superlative sind zu vermeiden.

> **Praxisbeispiel**
>
> Ein kurzer Positionierungssatz, den das ganze Team auswendig kennt, ist wertvoller als ein langes Markenhandbuch. Er dient als Maßstab für Website, Anzeigen, Pitch Deck (Modul 08) und Verkaufsgespräche.

## 9.2 Demand Generation

*Demand Generation* bezeichnet alle Maßnahmen, die Nachfrage nach dem Produkt erzeugen und in Kontakte, sogenannte *Leads*, verwandeln. Die wichtigsten Kanäle sind *Content* (Artikel, Leitfäden, Webinare), *SEO* (Suchmaschinenoptimierung, damit man bei relevanten Suchanfragen gefunden wird), *Events* (Messen, eigene Veranstaltungen), *Paid* (bezahlte Anzeigen) und *Community* (Entwicklerforen, Nutzergruppen, Partner). Jeder Kanal hat ein eigenes Tempo: Bezahlte Anzeigen liefern schnell Kontakte, solange man zahlt; Content und SEO brauchen Monate, wirken dann aber dauerhaft; Events und Community bauen persönliche Beziehungen auf.

Wichtig ist, die Wirkung eines Kanals *an der Pipeline zu messen* und nicht an Klicks oder Followern. Die *Pipeline* ist der Gesamtwert der offenen Verkaufschancen. Der *CPL* (Cost per Lead) sagt, was ein Kontakt kostet, aber ein billiger Kontakt, der nie kauft, ist teuer. Aussagekräftiger sind die Kosten je Verkaufschance und je Kunde (CAC, vergleiche Modul 07) sowie die Pipeline, die pro ausgegebenem Euro entsteht.

> **Ergänzung aus der Nachrecherche**
>
> Für Werbe-E-Mails gilt in Österreich laut einer WKO-Übersicht: Für Massen-E-Mails (mehr als 50 Empfänger) und für Werbe-E-Mails ist grundsätzlich eine vorherige Einwilligung nötig, die jederzeit widerrufbar ist. Ausnahme für Bestandskunden: Ohne Einwilligung ist Werbung für eigene, ähnliche Produkte zulässig, wenn die Adresse beim Verkauf erhoben wurde, der Kunde bei der Erhebung und bei jeder Zusendung kostenfrei ablehnen konnte und er nicht in der ECG-Liste (Robinsonliste) steht. Jede Zusendung braucht eine einfache Abmeldemöglichkeit, Werbung ist in der Betreffzeile zu kennzeichnen. Die Seite nennt als Strafrahmen bis 37 000 Euro nach dem Telekommunikationsgesetz sowie bis 3 000 Euro bei fehlender Werbekennzeichnung nach dem E-Commerce-Gesetz, daneben Unterlassungs- und Schadenersatzklagen nach dem UWG (Quelle Q18; keine Rechtsberatung). Für Cookies und Tracking auf der Website sowie für die Datenschutz-Seite der Einwilligung gelten zusätzlich die Regeln aus Modul 06.

Das Programm vergleicht vier Kanäle anhand erfundener Quartalszahlen.

```python
kanaele = {
    #            Ausgaben, Leads, Termine, Opportunities, Kunden, Pipeline-Wert
    "Content/SEO": (6_000, 400, 60, 24, 6, 72_000),
    "Events":      (15_000, 120, 45, 20, 5, 90_000),
    "Paid Search": (12_000, 300, 36, 12, 2, 30_000),
    "Community":   (3_000, 80, 20, 10, 3, 36_000),
}
print(f"{'Kanal':12s} {'CPL':>6s} {'Kosten/Opp':>11s} {'CAC':>7s} {'Pipeline je EUR':>16s}")
for name, (kosten, leads, termine, opps, kunden, pipeline) in kanaele.items():
    print(f"{name:12s} {kosten/leads:6.1f} {kosten/opps:11.0f} {kosten/kunden:7.0f} {pipeline/kosten:16.1f}")
beste = max(kanaele, key=lambda k: kanaele[k][5] / kanaele[k][0])
print("Hoechste Pipeline je ausgegebenem Euro:", beste)
```

Für jeden Kanal stehen Ausgaben, Leads, Termine, Verkaufschancen, gewonnene Kunden und der Pipeline-Wert in einem Tupel. Die Schleife berechnet vier Kennzahlen. Content/SEO kostet 15 Euro pro Lead, 250 Euro pro Verkaufschance und 1 000 Euro pro Kunde und erzeugt 12 Euro Pipeline je ausgegebenem Euro. Events liefern zwar mit 90 000 Euro die größte absolute Pipeline, kosten aber 125 Euro je Lead, 3 000 Euro je Kunde und erzielen nur 6 Euro Pipeline je Euro. Paid Search ist mit 6 000 Euro je Kunde und 2,5 Euro Pipeline je Euro am schwächsten. Community erreicht wie Content/SEO 12 Euro je Euro bei nur 3 000 Euro Budget. Das Programm nennt Content/SEO als Gewinner, weil `max` bei Gleichstand den ersten Eintrag liefert; ein Mensch sollte hier den Gleichstand erkennen. Bei kleinen Zahlen (6 oder 5 Kunden je Kanal) sagen solche Quoten außerdem nur wenig über die Zukunft aus.

Typische Fehler: Kanäle nach Bauchgefühl bewerten, zu viele Kanäle gleichzeitig bespielen, Leads zählen statt Pipeline, den Zeitversatz (Content wirkt erst nach Monaten) ignorieren. Falsch: „Paid bringt die meisten Leads, also machen wir mehr davon.“ Richtig: Nach Qualität bewerten (welche Leads werden Kunden?) und einen Kanal erst ausbauen, wenn er in kleinem Maßstab belegbar funktioniert.

> **Merke**
>
> Demand Generation wird an der Pipeline und am CAC gemessen, nicht an Klicks. Jeder Kanal hat ein eigenes Tempo. Für E-Mail-Werbung braucht es in der Regel eine Einwilligung; Ausnahmen sind eng gefasst.

> **Praxisbeispiel**
>
> Fachinhalte, die ein echtes Problem lösen (Vergleichstabellen, Berechnungsvorlagen, Integrationsanleitungen), ziehen im B2B-Umfeld meist besser als Imagekampagnen. Bei kleinem Budget beginnt man mit einem oder zwei Kanälen, die zum Kaufverhalten der Zielgruppe passen.

## 9.3 Sales Funnel

Der *Sales Funnel* (Verkaufstrichter) beschreibt den Weg vom ersten Kontakt bis zum Abschluss als Folge von Stufen. Typische Stufen sind: *Lead* (ein Kontakt zeigt Interesse), *MQL* (Marketing Qualified Lead: nach Kriterien des Marketings für den Vertrieb interessant), *SQL* (Sales Qualified Lead: der Vertrieb hat Bedarf, Budget und Entscheider bestätigt), *Demo*, *Angebot* und *Abschluss*. Die Stufen und die Kriterien für den Übergang müssen schriftlich definiert sein, sonst bewertet jede Person anders. Die *Conversion Rate* einer Stufe ist der Anteil, der es in die nächste Stufe schafft.

Der Zweck der Kennzahlen ist, *Engpässe zu erkennen*. Wenn aus 1 000 Leads nur 12 Kunden werden, hilft die Gesamtquote wenig; interessant ist, wo der größte Verlust entsteht und ob er zu beheben ist. Dazu kommt die *Pipeline Velocity*: Anzahl Verkaufschancen mal Gewinnrate mal durchschnittlicher Auftragswert, geteilt durch die Länge des Verkaufszyklus. Sie sagt, wie viel Umsatz die Pipeline pro Tag erzeugt, und zeigt vier Hebel: mehr Chancen, höhere Gewinnrate, größere Aufträge, kürzere Zyklen.

```python
stufen = [("Lead", 1000), ("MQL", 400), ("SQL", 160), ("Demo", 96), ("Angebot", 48), ("Abschluss", 12)]
engpass = None
for (name, n), (naechste, m) in zip(stufen, stufen[1:]):
    rate = m / n
    print(f"{name:9s} -> {naechste:9s} {rate:6.1%}")
    if engpass is None or rate < engpass[1]:
        engpass = (f"{name} -> {naechste}", rate)
print("Gesamtconversion:", f"{stufen[-1][1] / stufen[0][1]:.1%}")
print("Niedrigste Stufenrate:", engpass[0], f"({engpass[1]:.1%})")

# Verkaufsgeschwindigkeit
opps, win, acv, zyklus_tage = 48, 0.25, 12_000, 90
print("Pipeline-Velocity pro Tag:", round(opps * win * acv / zyklus_tage))
```

Die Liste enthält je Stufe die Zahl der Kontakte. Die Schleife nutzt `zip(stufen, stufen[1:])`, um jede Stufe mit der nächsten zu paaren, und rechnet die Quote aus: 40 Prozent der Leads werden MQL, 40 Prozent der MQL werden SQL, 60 Prozent der SQL erhalten eine Demo, 50 Prozent der Demos führen zu einem Angebot, und 25 Prozent der Angebote werden zu Kunden. Insgesamt werden aus 1 000 Leads 12 Kunden, das sind 1,2 Prozent. Die niedrigste Stufenquote hat der Schritt vom Angebot zum Abschluss; sie wird als erster Engpass ausgegeben, wobei ein Vergleich mit Branchenwerten nötig wäre, um zu beurteilen, ob 25 Prozent schlecht sind. Die Velocity beträgt 48 Chancen mal 25 Prozent mal 12 000 Euro geteilt durch 90 Tage, also 1 600 Euro Umsatz pro Tag.

Typische Fehler: Stufen ohne klare Kriterien, Kontakte, die ewig in einer Stufe hängen, und Gesamtquoten ohne Stufenanalyse. Falsch: „Wir brauchen mehr Leads.“ Richtig: Zuerst prüfen, ob die Qualität stimmt, denn doppelt so viele schlechte Leads füllen den Funnel, aber nicht die Kasse. Eine feste Regel für die Zeit, die ein Kontakt in einer Stufe verbringen darf, hilft, tote Chancen auszusortieren.

> **Merke**
>
> Der Funnel besteht aus definierten Stufen mit klaren Übergangskriterien. Stufenquoten zeigen Engpässe, die Pipeline Velocity zeigt die vier Hebel für mehr Umsatz pro Tag. Qualität vor Menge.

> **Praxisbeispiel**
>
> Eine Funnel-Auswertung gehört in die wöchentliche Vertriebsrunde und in das Investor Reporting (Modul 07). Sie macht Gespräche konkret: Nicht „der Vertrieb ist zu langsam“, sondern „zwischen Demo und Angebot verlieren wir die Hälfte“.

## 9.4 CRM Betrieb

Ein *CRM-System* (Customer Relationship Management) speichert Kontakte, Unternehmen, Verkaufschancen und Aktivitäten an einem Ort. Es ist die Datenbasis für Vertrieb, Marketing und Customer Success. Sein Wert hängt allein von der *Datenqualität* ab: Ein CRM, in dem Felder leer oder veraltet sind, liefert falsche Prognosen und verleitet zu falschen Entscheidungen. Deshalb gehört zum Betrieb ein festgelegtes *Datenmodell*: Welche Objekte gibt es (Kontakt, Firma, Opportunity), wie hängen sie zusammen, welche Felder sind *Pflichtfelder* und welche Werte sind erlaubt (Auswahllisten statt Freitext)?

Die *Forecast-Logik* legt fest, wie aus den Opportunities eine Umsatzprognose wird. Im einfachsten Fall hat jede Phase eine Abschlusswahrscheinlichkeit, und die Prognose ist die Summe aus Wert mal Wahrscheinlichkeit. Das setzt voraus, dass Phase, Abschlussdatum, Wert und Verantwortliche stimmen. Als Datenschutz-Aspekt gilt: Im CRM stehen personenbezogene Daten, es braucht daher Rechtsgrundlage, Zugriffsrechte, Löschfristen und eine Auftragsverarbeitung mit dem Anbieter (Modul 06 und 11).

```python
from datetime import date
heute = date(2026, 11, 2)
deals = [
    {"name": "Alpha GmbH", "wert": 24_000, "phase": "Angebot", "abschluss": date(2026, 12, 15), "owner": "ben", "naechster_schritt": "Preisgespraech"},
    {"name": "Beta AG",    "wert": 60_000, "phase": "Demo",    "abschluss": date(2026, 10, 20), "owner": "",    "naechster_schritt": ""},
    {"name": "Gamma KG",   "wert": 12_000, "phase": "Verhandlung", "abschluss": date(2027, 1, 31), "owner": "anna", "naechster_schritt": "Vertrag senden"},
    {"name": "Delta SE",   "wert": 36_000, "phase": "Qualifiziert", "abschluss": date(2027, 3, 31), "owner": "ben", "naechster_schritt": ""},
]
WAHRSCHEINLICHKEIT = {"Qualifiziert": 0.10, "Demo": 0.25, "Angebot": 0.50, "Verhandlung": 0.75}
for d in deals:
    fehler = []
    if not d["owner"]: fehler.append("kein Owner")
    if not d["naechster_schritt"]: fehler.append("kein naechster Schritt")
    if d["abschluss"] < heute: fehler.append("Abschlussdatum in der Vergangenheit")
    print(f"{d['name']:11s}", "OK" if not fehler else "; ".join(fehler))
sauber = [d for d in deals if d["owner"] and d["naechster_schritt"] and d["abschluss"] >= heute]
print("Gewichteter Forecast (nur saubere Deals):", sum(d["wert"] * WAHRSCHEINLICHKEIT[d["phase"]] for d in sauber))
print("Gewichteter Forecast (alle Deals):       ", sum(d["wert"] * WAHRSCHEINLICHKEIT[d["phase"]] for d in deals))
```

Das Programm prüft vier Opportunities auf die Mindestangaben Verantwortlicher, nächster Schritt und ein Abschlussdatum, das nicht in der Vergangenheit liegt. Alpha und Gamma sind in Ordnung. Beta ist ein Beispiel für typische Datenfäule: kein Verantwortlicher, kein nächster Schritt und ein Abschlussdatum, das schon vorbei ist; bei Delta fehlt der nächste Schritt. Danach werden zwei Prognosen berechnet: Mit allen Deals ergeben sich 39 600 Euro, mit den sauberen nur 21 000 Euro (Alpha 12 000 und Gamma 9 000). Der Unterschied von 18 600 Euro besteht fast nur aus dem Deal Beta (15 000 Euro), dessen Zustand offen ist. Die Daten zu bereinigen kann also die Prognose um fast die Hälfte verändern.

Typische Fehler: Zu viele Pflichtfelder, die niemand pflegt, oder zu wenige, sodass das CRM leer bleibt; Freitext statt Auswahllisten; Eintragen „nach Gefühl“ am Quartalsende. Falsch: Die Geschäftsführung fragt jedes Quartal nach einer Prognose und bekommt eine Excel-Datei. Richtig: Die Prognose entsteht aus dem CRM, und der Vertrieb wird daran gemessen, dass Daten aktuell sind. Wichtig sind außerdem Regeln für Dubletten und ein Verantwortlicher für das Datenmodell.

> **Merke**
>
> Ein CRM ist nur so gut wie seine Daten. Das Datenmodell mit Pflichtfeldern und Auswahllisten ist die Grundlage, die Forecast-Logik rechnet aus Phase, Wert und Wahrscheinlichkeit. Datenschutz und Löschfristen gelten auch hier.

> **Praxisbeispiel**
>
> Einmal pro Woche eine Viertelstunde „Pipeline-Hygiene“: Deals ohne nächsten Schritt oder mit altem Datum werden entweder aktualisiert oder geschlossen. Das kostet wenig und verbessert die Prognose spürbar.

## 9.5 Demo und Pre-Sales

Eine *Demo* ist die Vorführung des Produkts vor einem Interessenten. Sie ist der Moment, in dem aus einer Behauptung ein Erlebnis wird, aber auch der Moment, in dem viele Chancen verloren gehen, weil die Demo eine Funktionsshow statt einer Antwort auf das Problem des Kunden ist. Gute Demos beginnen mit einem Gespräch (Discovery): Welches Problem hat der Kunde, wie wird es heute gelöst, was kostet es ihn, wer entscheidet? Erst danach zeigt man die Teile des Produkts, die dieses Problem lösen, in der Reihenfolge des Kundenschmerzes. Alles andere bleibt weg, selbst wenn es technisch beeindruckend ist.

*Pre-Sales* (auch Sales Engineering) bezeichnet die technische Unterstützung des Vertriebs: Demos, Beantwortung technischer Fragen, Proof of Concept und Sicherheitsfragebögen. Dazu gehört der strukturierte Umgang mit *Einwänden*. Man sammelt sie, kategorisiert sie und bereitet für die häufigsten Antworten mit Belegen vor (Sicherheitsnachweis, Referenz, Integrationsdokumentation). Die Auswertung zeigt zugleich, was im Produkt oder in der Positionierung fehlt.

```python
probleme = {
    "Support-Tickets dauern zu lange": 5,
    "Berichte sind unuebersichtlich": 3,
    "Integration mit dem Ticketsystem fehlt": 4,
}
funktionen = {
    "KI-Antwortvorschlaege": ["Support-Tickets dauern zu lange"],
    "Dashboard": ["Berichte sind unuebersichtlich"],
    "Ticketsystem-Connector": ["Integration mit dem Ticketsystem fehlt", "Support-Tickets dauern zu lange"],
    "Dunkelmodus": [],
}
bewertung = {f: sum(probleme[p] for p in ps) for f, ps in funktionen.items()}
agenda = [f for f, punkte in sorted(bewertung.items(), key=lambda x: -x[1]) if punkte > 0]
print("Demo-Agenda:", agenda)
print("Nicht zeigen:", [f for f, p in bewertung.items() if p == 0])

einwaende = ["Sicherheit", "Preis", "Sicherheit", "Integration", "Sicherheit", "Preis"]
zaehler = {}
for e in einwaende:
    zaehler[e] = zaehler.get(e, 0) + 1
for e, n in sorted(zaehler.items(), key=lambda x: -x[1]):
    print(f"{e:12s} {n}x  ({n / len(einwaende):.0%})")
```

Im ersten Teil sind drei Kundenprobleme mit einer Gewichtung von 1 bis 5 und vier Funktionen mit den Problemen, die sie lösen, hinterlegt. Die Bewertung einer Funktion ist die Summe der Gewichte der gelösten Probleme. Der Ticketsystem-Connector erreicht 9 (er löst die Integrationslücke mit 4 und die langen Ticketzeiten mit 5), die KI-Antwortvorschläge 5, das Dashboard 3; der Dunkelmodus löst kein genanntes Problem und kommt nicht in die Demo. Im zweiten Teil werden Einwände gezählt: Sicherheit wurde dreimal genannt (50 Prozent), Preis zweimal (33 Prozent), Integration einmal (17 Prozent). Daraus folgt, dass ein Sicherheitsdossier (siehe Modul 06) mehr bringt als weitere Demo-Folien.

Typische Fehler: Alle Funktionen zeigen, auf Einwände defensiv reagieren, Demo-Umgebungen, die wackeln, und Versprechen, die das Produkt nicht hält. Falsch: „Das bauen wir gerne für Sie, kein Problem.“ Richtig: Ehrlich sagen, was heute möglich ist, was auf der Roadmap steht und was nicht, und Zusagen nur mit klarem Termin machen. Eine stabile Demo-Umgebung mit realistischen Beispieldaten (ohne echte Kundendaten) ist ein Teil der Produktarbeit.

> **Merke**
>
> Eine Demo beantwortet das Problem des Kunden, nicht den Funktionsumfang. Einwände werden gesammelt, kategorisiert und mit Belegen beantwortet; die Häufung zeigt, wo Produkt oder Botschaft nachgebessert werden müssen.

> **Praxisbeispiel**
>
> Nach jedem Termin schreibt der Vertrieb die drei wichtigsten Schmerzpunkte und Einwände ins CRM. Nach einem Quartal ist das eine wertvolle Datenbasis für Produktentscheidungen (Modul 04) und Marketing.

## 9.6 Customer Success

*Customer Success* ist die Aufgabe, dafür zu sorgen, dass Kunden mit dem Produkt ihre Ziele erreichen. Bei Abonnement-Geschäften ist das wirtschaftlich entscheidend, weil sich die Akquisitionskosten (Modul 07) erst über Monate oder Jahre amortisieren und Kündigungen die Rechnung zerstören. Customer Success umfasst das *Onboarding* (die ersten Wochen: Einrichtung, Schulung, erster Erfolg), die *Adoption* (breite und tiefe Nutzung) und die Pflege der Beziehung bis zur Verlängerung.

Ein praktisches Werkzeug ist der *Health Score*, eine Kennzahl, die aus mehreren Signalen eine Gesundheit des Kundenkontos berechnet: Nutzung (Logins, aktive Nutzer), Breite (wie viele Module genutzt werden), Support-Lage (offene Tickets), Zufriedenheit (NPS, Net Promoter Score) und Vertragsdaten. Er dient dazu, *Churn-Risiken früh zu erkennen*, damit man handeln kann, solange Zeit bleibt. Wichtig ist, dass man den Score regelmäßig mit der Realität abgleicht: Hat er die Kunden, die gekündigt haben, vorher als gefährdet gezeigt?

```python
kunden = [
    {"name": "Alpha", "logins_30d": 42, "genutzte_module": 4, "module_gesamt": 5, "tickets_offen": 0, "nps": 9, "tage_bis_verlaengerung": 200},
    {"name": "Beta",  "logins_30d": 6,  "genutzte_module": 1, "module_gesamt": 5, "tickets_offen": 3, "nps": 4, "tage_bis_verlaengerung": 45},
    {"name": "Gamma", "logins_30d": 20, "genutzte_module": 2, "module_gesamt": 5, "tickets_offen": 1, "nps": 7, "tage_bis_verlaengerung": 80},
]
def health(k):
    nutzung = min(k["logins_30d"] / 30, 1) * 40            # bis 40 Punkte
    breite  = k["genutzte_module"] / k["module_gesamt"] * 30  # bis 30 Punkte
    support = max(0, 15 - 5 * k["tickets_offen"])          # bis 15 Punkte
    nps     = k["nps"] / 10 * 15                           # bis 15 Punkte
    return round(nutzung + breite + support + nps)
for k in kunden:
    h = health(k)
    ampel = "gruen" if h >= 70 else "gelb" if h >= 50 else "rot"
    dringend = " <- Eingriff vor Verlaengerung" if ampel != "gruen" and k["tage_bis_verlaengerung"] <= 90 else ""
    print(f"{k['name']:6s} Score {h:3d} ({ampel}){dringend}")
```

Die Funktion `health` vergibt bis zu 40 Punkte für Logins (30 Logins im Monat gelten als volle Nutzung, `min` kappt den Wert), bis zu 30 Punkte für die Breite der Modulnutzung, bis zu 15 Punkte für wenig offene Tickets und bis zu 15 Punkte aus dem NPS. Alpha erreicht 92 Punkte (grün), Beta nur 20 (rot), Gamma 59 (gelb). Die Ampel ergibt sich aus Schwellen bei 70 und 50. Beta und Gamma werden zusätzlich markiert, weil die Verlängerung in 45 beziehungsweise 80 Tagen ansteht, das Zeitfenster zum Eingreifen also knapp ist. Gewichtung und Schwellen sind Annahmen und gehören an echten Kündigungen kalibriert.

Typische Fehler: Customer Success erst nach der Kündigung aktiv werden lassen, Health Scores, die niemand prüft, und zu viele Signale ohne Aussagekraft. Falsch: Man schickt allen Kunden dieselbe Newsletter-Serie. Richtig: Bei roten Konten greift eine Person ein (Gespräch, Schulung, Prozessänderung), bei grünen sucht man Expansionsmöglichkeiten (zusätzliche Nutzer oder Module), was den Umsatz je Kunde steigert (Net Revenue Retention, Modul 07).

> **Merke**
>
> Customer Success sichert Onboarding, Adoption und Verlängerung. Ein Health Score fasst Nutzung, Breite, Support und Zufriedenheit zusammen und macht Churn-Risiken früh sichtbar. Er muss an echten Kündigungen überprüft werden.

> **Praxisbeispiel**
>
> Früh lohnt sich ein einfacher Onboarding-Plan mit festen Meilensteinen (zum Beispiel erste Integration in Woche 1, erster Bericht in Woche 2). Kunden, die in den ersten 30 Tagen keinen Erfolg erleben, kündigen oft später.

## 9.7 Pricing und Packaging im Markt

Die Grundlagen des Preismodells liegen in Modul 03; hier geht es darum, wie man Preise und Pakete *im Markt prüft und steuert*. *Packaging* heißt, das Angebot in Pakete (zum Beispiel Starter, Team, Business) und optionale *Add-ons* zu gliedern. Eine gute Staffelung folgt dem Nutzen für unterschiedliche Kundengruppen, nicht der internen Technik. Der *Preismaßstab* (englisch *value metric*) bestimmt, woran der Preis wächst: Nutzer, Datenmenge, Anfragen, Standorte. Er sollte mit dem Nutzen des Kunden wachsen und leicht erklärbar sein.

Ob die Pakete funktionieren, zeigt die *Nutzung*: Welches Paket wählen Kunden, welche Funktionen nutzen sie, wann stoßen sie an Grenzen und wechseln in ein höheres Paket? Dazu kommt die Disziplin beim *Discounting*. Rabatte sind legitim (Mengen, Mehrjahresverträge), aber unkontrolliert zerstören sie den Preis und schaffen Ungleichbehandlung. Deshalb gibt es Rabattgrenzen je Rolle mit Freigabe nach oben.

```python
pakete = {"Starter": 49, "Team": 149, "Business": 399}
nutzer = {"Starter": 120, "Team": 80, "Business": 15}
umsatz = {p: pakete[p] * nutzer[p] for p in pakete}
gesamt = sum(umsatz.values())
for p, u in umsatz.items():
    print(f"{p:9s} {nutzer[p]:4d} Kunden  {u:7d} EUR  {u / gesamt:5.1%}")
print("Gesamt MRR:", gesamt)

rabatt_grenzen = {"vertrieb": 0.10, "teamleitung": 0.20, "geschaeftsfuehrung": 0.35}
angebote = [("Team", 0.08, "vertrieb"), ("Business", 0.18, "vertrieb"), ("Business", 0.30, "teamleitung"), ("Team", 0.40, "geschaeftsfuehrung")]
for paket, rabatt, freigeber in angebote:
    grenze = rabatt_grenzen[freigeber]
    status = "OK" if rabatt <= grenze else f"Freigabe zu niedrig ({freigeber} darf max. {grenze:.0%})"
    netto = pakete[paket] * (1 - rabatt)
    print(f"{paket:9s} {rabatt:4.0%} -> {netto:7.2f} EUR/Monat  {status}")
```

Der erste Teil berechnet aus Preis und Kundenzahl pro Paket den MRR: Starter 5 880 Euro (24,7 Prozent), Team 11 920 Euro (50,1 Prozent) und Business 5 985 Euro (25,2 Prozent), zusammen 23 785 Euro. Die Verteilung zeigt, dass das mittlere Paket die Hälfte des Umsatzes trägt; ein Test mit einem Zwischenpaket oder Add-on könnte sich lohnen. Der zweite Teil prüft vier Angebote gegen Rabattgrenzen (Vertrieb bis 10 Prozent, Teamleitung bis 20, Geschäftsführung bis 35). Das Team-Angebot mit 8 Prozent ist in Ordnung und kostet 137,08 Euro im Monat. Business mit 18 Prozent liegt über der Grenze des Vertriebs, Business mit 30 Prozent über der Grenze der Teamleitung, und 40 Prozent Rabatt auf Team überschreitet sogar die Grenze der Geschäftsführung von 35 Prozent und ist nicht freigebbar.

Typische Fehler: Preise aus Konkurrenzpreisen ableiten statt aus dem Kundennutzen, zu viele Pakete, Rabatte als Standardantwort auf Einwände, Preisänderungen ohne Test. Falsch: Man gibt 30 Prozent Rabatt, weil der Kunde „ein wichtiger Name“ ist. Richtig: Rabatte gegen eine Gegenleistung vergeben (Laufzeit, Referenz, Vorauszahlung) und dokumentieren. Preisänderungen testet man an neuen Kunden oder Segmenten, bevor man den Bestand anfasst, und prüft die Auswirkung auf Gewinnrate und Churn.

> **Merke**
>
> Pakete folgen dem Kundennutzen, der Preismaßstab wächst mit dem Wert. Nutzungsdaten zeigen, ob Pakete passen. Rabatte werden an Gegenleistungen gebunden und mit Freigabestufen begrenzt.

> **Praxisbeispiel**
>
> Alle Rabatte im CRM zu erfassen (Höhe, Grund, Freigeber), kostet fast nichts und liefert nach einem Quartal klare Erkenntnisse: Wo wird Preis verhandelt, und welche Argumente fehlen dem Vertrieb?

## 9.8 Partnervertrieb

Beim *Partnervertrieb* verkaufen oder empfehlen Dritte das Produkt. Dazu zählen *Systemintegratoren* (Beratungshäuser, die Software einführen), *Marktplätze* (Plattformen großer Cloud-Anbieter, über die Kunden Software direkt beziehen und mit vorhandenem Budget bezahlen) und *Technologiepartner* (Anbieter, deren Produkt sich mit dem eigenen verbindet). Partner geben Zugang zu Kunden und Vertrauen, die man allein nur langsam aufbaut. Dafür kostet es Marge und Aufmerksamkeit, und man macht sich von ihnen abhängig (strategische Aspekte in Modul 12).

Damit Partner verkaufen, braucht es *Enablement* (Schulung, Unterlagen, Demo-Zugänge, technische Unterstützung) und *Incentives*: Provisionen, gestaffelte Margen, gemeinsame Marketingbudgets, bevorzugte Leads. Wichtig ist Klarheit über den Kanalkonflikt: Wer bekommt welchen Kunden, wer ist Ansprechpartner, wie werden Doppelbearbeitungen verhindert? Verträge regeln Provision, Laufzeit und Kundenschutz (Modul 11).

```python
partner = {
    "Integrator A":  {"umsatz": 120_000, "provision": 0.20, "enablement_kosten": 8_000, "deals": 6},
    "Marktplatz B":  {"umsatz": 60_000,  "provision": 0.15, "enablement_kosten": 2_000, "deals": 12},
    "Technologie C": {"umsatz": 15_000,  "provision": 0.10, "enablement_kosten": 5_000, "deals": 2},
}
print(f"{'Partner':14s} {'Provision':>9s} {'Kosten':>8s} {'Netto':>8s} {'ROI':>6s} {'je Deal':>8s}")
for name, p in partner.items():
    prov = p["umsatz"] * p["provision"]
    kosten = prov + p["enablement_kosten"]
    netto = p["umsatz"] - kosten
    print(f"{name:14s} {prov:9.0f} {kosten:8.0f} {netto:8.0f} {netto / kosten:6.1f} {p['umsatz'] / p['deals']:8.0f}")
```

Für drei Partner stehen vermittelter Umsatz, Provisionssatz, Enablement-Kosten und Zahl der Deals fest. Die Provision ist Umsatz mal Satz, die Kosten sind Provision plus Enablement, der Nettobeitrag ist Umsatz minus Kosten, der ROI der Nettobeitrag geteilt durch die Kosten. Integrator A bringt 120 000 Euro bei 24 000 Euro Provision und 8 000 Euro Enablement, Kosten 32 000 Euro, ROI 2,8, im Mittel 20 000 Euro je Deal. Marktplatz B liefert 60 000 Euro bei nur 11 000 Euro Kosten (ROI 4,5) mit 5 000 Euro je Deal; viele kleine Abschlüsse. Technologiepartner C erreicht nur 15 000 Euro bei 6 500 Euro Kosten, ROI 1,3. Die Zahlen zeigen, dass der Aufwand je Partner sehr unterschiedlich ist; ein Partner mit kleinem Umsatz kann trotzdem strategisch wertvoll sein (Referenz, Integration), das erfasst die Rechnung nicht.

Typische Fehler: zu viele Partner gleichzeitig ohne Betreuung, Provision ohne Leistung, Partner ohne eigenes Interesse am Produkt. Falsch: Man unterschreibt zehn Partnerverträge und wartet. Richtig: Wenige Partner wählen, die denselben Kunden bedienen, mit Enablement und einem gemeinsamen Ziel (Pipeline je Quartal) beginnen und Ergebnisse regelmäßig besprechen.

> **Merke**
>
> Partner geben Reichweite und Vertrauen, kosten aber Marge und Aufmerksamkeit. Enablement und klare Incentives entscheiden über den Erfolg. Der Beitrag je Partner wird laufend gemessen; strategischer Wert kommt dazu.

> **Praxisbeispiel**
>
> Marktplätze von Cloud-Anbietern erleichtern Einkauf und Abrechnung und erleichtern Großkunden die Beschaffung. Die Anforderungen für die Listung (technische Prüfung, Verträge) erfordern Vorlaufzeit.

## 9.9 Growth Experimente

*Growth Experimente* sind kleine, schnelle Tests, mit denen ein Team herausfindet, was Wachstum treibt. Der Ablauf folgt dem Lernzyklus: eine *Hypothese* formulieren („Wenn wir die Registrierung von fünf auf drei Felder kürzen, steigt die Abschlussrate um 20 Prozent“), eine *Zielmetrik* festlegen, den Test mit einer Kontrollgruppe durchführen, das Ergebnis auswerten und daraus lernen. Entscheidend ist die Disziplin: Vorab festlegen, was als Erfolg zählt und wie lange der Test läuft, damit man nicht nachträglich das Ergebnis passend deutet.

Ein Ergebnis ist erst belastbar, wenn es sich vom Zufall unterscheidet. Die Statistik dazu heißt *Signifikanztest*: Man berechnet, wie wahrscheinlich ein mindestens so großer Unterschied wäre, wenn in Wahrheit kein Unterschied bestünde (der *p-Wert*). Liegt er unter einer vorher festgelegten Schwelle (üblich 5 Prozent), spricht man von statistischer Signifikanz. Mit kleinen Stichproben sind Tests wenig aussagekräftig. Ebenso wichtig ist die Unterscheidung *skalierbarer Kanal oder Einmaleffekt*: Ein Experiment, das nur wegen eines Sonderumstands (Aktion, Sondermeldung in der Presse) funktioniert, lässt sich nicht wiederholen.

```python
import math
def ztest(n_a, k_a, n_b, k_b):
    p_a, p_b = k_a / n_a, k_b / n_b
    p = (k_a + k_b) / (n_a + n_b)
    se = math.sqrt(p * (1 - p) * (1 / n_a + 1 / n_b))
    z = (p_b - p_a) / se
    pwert = 2 * (1 - 0.5 * (1 + math.erf(abs(z) / math.sqrt(2))))
    return p_a, p_b, z, pwert
for titel, args in (("Test 1", (1000, 50, 1000, 70)), ("Test 2", (200, 10, 200, 14))):
    pa, pb, z, pw = ztest(*args)
    print(f"{titel}: A {pa:.1%}  B {pb:.1%}  z={z:.2f}  p={pw:.3f}  ->", "signifikant" if pw < 0.05 else "nicht belegt")

def stichprobe_je_gruppe(p0, aufschlag_rel, z_alpha=1.96, z_beta=0.84):
    p1 = p0 * (1 + aufschlag_rel)
    var = p0 * (1 - p0) + p1 * (1 - p1)
    return math.ceil((z_alpha + z_beta) ** 2 * var / (p1 - p0) ** 2)
print("Noetig je Gruppe fuer 5% -> +20% relativ:", stichprobe_je_gruppe(0.05, 0.20))
```

Die Funktion `ztest` vergleicht zwei Anteile (Gruppe A und B): Sie berechnet beide Raten, die gemeinsame Rate, den Standardfehler und daraus die Prüfgröße z; der p-Wert folgt aus der Normalverteilung (`math.erf`). Im ersten Test steigt die Conversion von 5,0 auf 7,0 Prozent bei je 1 000 Besuchern (z = 1,88, p = 0,060); das reicht knapp nicht für Signifikanz bei der 5-Prozent-Schwelle. Im zweiten Test mit denselben Raten, aber nur 200 Besuchern je Gruppe, ist p = 0,400, der Unterschied ist also nicht von Zufall zu trennen. Die Funktion `stichprobe_je_gruppe` zeigt, wie viele Besucher man benötigt, um bei einer Ausgangsrate von 5 Prozent eine relative Steigerung von 20 Prozent (auf 6 Prozent) sicher zu erkennen: 8 146 je Gruppe. Das ist für ein junges Produkt mit wenig Verkehr viel, daher sollte man bei kleinem Traffic Hypothesen mit großen Effekten testen oder qualitative Methoden (Interviews, Nutzertests) nutzen.

Typische Fehler: zu früh abbrechen, wenn die Zahl gut aussieht („Peeking“), viele Varianten gleichzeitig testen und die besten herauspicken, Ergebnisse ohne Hypothese interpretieren, mehrere Änderungen auf einmal. Falsch: „Variante B liegt nach zwei Tagen bei 7 Prozent, wir rollen sie aus.“ Richtig: Vorab Stichprobe und Dauer festlegen und erst danach entscheiden. Außerdem schützt eine dokumentierte Experiment-Liste vor Wiederholungen und bewahrt Erkenntnisse im Team.

> **Merke**
>
> Wachstumsexperimente folgen Hypothese, Zielmetrik, Kontrollgruppe und Auswertung. Ein Unterschied muss sich vom Zufall abheben; dafür braucht es genügend Daten. Skalierbare Kanäle sind von Einmaleffekten zu trennen.

> **Praxisbeispiel**
>
> Ein Experiment-Backlog (Idee, erwarteter Effekt, Aufwand, Ergebnis) mit einer Priorisierung nach Wirkung pro Aufwand hilft kleinen Teams, sich auf wenige gute Tests zu konzentrieren und das Gelernte nicht zu vergessen.

## Übungsaufgaben zu Modul 09

1.  **(leicht)** Erkläre den Unterschied zwischen Lead, MQL und SQL und warum die Übergangskriterien schriftlich definiert sein müssen.

2.  **(leicht)** Ein Kanal kostet 6 000 Euro und liefert 400 Leads, davon werden 6 Kunden. Berechne CPL und CAC.

3.  **(leicht)** Nenne drei Signale, die in einen Health Score einfließen können, und begründe eines davon.

4.  **(mittel)** Berechne die Pipeline Velocity für 30 Verkaufschancen, eine Gewinnrate von 20 Prozent, einen durchschnittlichen Auftragswert von 15 000 Euro und einen Zyklus von 60 Tagen. Welche Hebel gibt es?

5.  **(mittel)** Ein Experiment zeigt 5 Prozent gegen 6 Prozent Conversion bei je 300 Besuchern. Darf man daraus schließen, dass Variante B besser ist? Begründe.

6.  **(praktisch)** Schreibe ein Programm, das für die Stufen Lead 500, MQL 200, SQL 80, Abschluss 20 die Stufenquoten und die Gesamtquote ausgibt.

7.  **(praktisch)** Schreibe eine Funktion, die für einen Rabattsatz die niedrigste freigabeberechtigte Rolle zurückgibt (Vertrieb bis 10 Prozent, Teamleitung bis 20, Geschäftsführung bis 35) und bei höheren Werten `None`.

8.  **(schwer/praktisch)** Ein Partner erhält 20 Prozent Provision auf Umsätze bis 50 000 Euro und 25 Prozent auf den darüber liegenden Teil. Schreibe eine Funktion, die die Provision berechnet, und prüfe sie für 30 000, 50 000 und 120 000 Euro.

## Lösungen zu den Übungsaufgaben Modul 09

**1.** Ein Lead ist ein Kontakt mit Interesse. Ein MQL erfüllt Kriterien, nach denen das Marketing ihn als reif für den Vertrieb einstuft (zum Beispiel Zielbranche, Verhalten). Ein SQL hat der Vertrieb geprüft und auf Bedarf, Budget, Entscheider und Zeitplan bestätigt. Ohne schriftliche Kriterien bewerten Marketing und Vertrieb unterschiedlich, Zahlen sind nicht vergleichbar, und es entstehen Streit und Fehlprognosen.

**2.** CPL = 6 000 geteilt durch 400 = 15 Euro. CAC = 6 000 geteilt durch 6 = 1 000 Euro. Der Lead kostet wenig, der Kunde dagegen viel, weil nur 1,5 Prozent der Leads zahlen.

**3.** Mögliche Signale: Logins pro Monat, Zahl genutzter Module, offene Tickets, NPS, Zahl aktiver Nutzer, Zahlungsverzug. Beispiel Logins: Wer das Produkt nicht nutzt, sieht keinen Wert und kündigt mit hoher Wahrscheinlichkeit bei der nächsten Verlängerung.

**4.** 30 mal 0,20 mal 15 000 geteilt durch 60 = 1 500 Euro pro Tag. Hebel: mehr Chancen, höhere Gewinnrate, höherer Auftragswert, kürzerer Zyklus.

**5.** Nein. Mit je 300 Besuchern entspricht das 15 gegen 18 Abschlüssen; der Unterschied ist so klein, dass er leicht zufällig sein kann (der z-Test ergibt einen p-Wert deutlich über 0,05). Für eine Aussage braucht man mehr Daten, oder der Effekt müsste größer sein.

**6.** Mögliche Lösung:

```python
stufen = [("Lead", 500), ("MQL", 200), ("SQL", 80), ("Abschluss", 20)]
for (n1, a), (n2, b) in zip(stufen, stufen[1:]):
    print(f"{n1} -> {n2}: {b / a:.0%}")
print("Gesamt:", f"{stufen[-1][1] / stufen[0][1]:.0%}")
```

Die Ausgabe zeigt 40 Prozent von Lead zu MQL, 40 Prozent von MQL zu SQL und 25 Prozent von SQL zu Abschluss; insgesamt 4 Prozent (20 von 500).

**7.** Mögliche Lösung:

```python
GRENZEN = {"vertrieb": 0.10, "teamleitung": 0.20, "geschaeftsfuehrung": 0.35}
def freigabe_noetig(rabatt):
    for rolle, grenze in GRENZEN.items():
        if rabatt <= grenze:
            return rolle
    return None
for r in (0.05, 0.12, 0.35, 0.40):
    print(f"{r:.0%}:", freigabe_noetig(r) or "nicht zulaessig")
```

Das Wörterbuch bleibt in der Reihenfolge von klein nach groß; die erste passende Grenze bestimmt die Rolle. 5 Prozent darf der Vertrieb, 12 Prozent die Teamleitung, 35 Prozent die Geschäftsführung, 40 Prozent ist nicht zulässig.

**8.** Mögliche Lösung:

```python
def provision(umsatz, grenze=50_000, satz_unten=0.20, satz_oben=0.25):
    unten = min(umsatz, grenze) * satz_unten
    oben = max(umsatz - grenze, 0) * satz_oben
    return unten + oben
for u in (30_000, 50_000, 120_000):
    print(u, provision(u))
```

Bis 50 000 Euro gelten 20 Prozent (6 000 und 10 000 Euro). Bei 120 000 Euro sind es 10 000 Euro für den ersten Teil plus 25 Prozent von 70 000 Euro, also 17 500 Euro, zusammen 27 500 Euro. Solche gestaffelten Modelle belohnen höhere Umsätze, sollten aber so gebaut sein, dass keine Anreize für unerwünschtes Verhalten entstehen (zum Beispiel Verschieben von Abschlüssen).
