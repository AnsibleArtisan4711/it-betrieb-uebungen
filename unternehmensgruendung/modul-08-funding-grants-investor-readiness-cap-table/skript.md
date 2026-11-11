# Modul 08 - Funding, Grants, Investor Readiness und Cap Table

> **Hinweis zu diesem Kapitel:** Das ist das Kapitel des Skripts „Unternehmensgründung“, aus der LaTeX-Quelle in Markdown umgewandelt (Text und Codeblöcke unverändert, farbige Boxen als Zitatblöcke mit fettem Titel, Tabellen als Markdown-Tabellen). Die Lerneinheiten sind wie in der Quelle nach Modul nummeriert (8.1 bis 8.9), danach folgen „Übungsaufgaben zu Modul 08“ (8 Aufgaben, mit Schwierigkeitsangabe) und „Lösungen zu den Übungsaufgaben Modul 08“. Rechtliche und steuerliche Aussagen sind keine Rechtsberatung. Was ich an den Beispielen geprüft habe, steht in der [README des Repositories](../README.md). Übersicht zum Modul: [README](README.md).

**Dauer:** 10 h laut Modulübersicht (Summe der Einzelwerte: 9 × 1,1 h = 9,9 h, gerundet)

**Priorität:** 1 (höchste)

| **Nr.** | **Lerneinheit**                      | **Dauer (h)** |
|--------:|:-------------------------------------|--------------:|
|     8.1 | Bootstrapping und Umsatzfinanzierung |           1,1 |
|     8.2 | Förderprogramme und Grants           |           1,1 |
|     8.3 | Accelerators und Incubators          |           1,1 |
|     8.4 | Venture Capital Grundlagen           |           1,1 |
|     8.5 | Pitch Deck                           |           1,1 |
|     8.6 | Cap Table und Verwässerung           |           1,1 |
|     8.7 | Due Diligence Vorbereitung           |           1,1 |
|     8.8 | Term Sheet Grundlagen                |           1,1 |
|     8.9 | Funding Roadmap                      |           1,1 |
|         | **Summe**                            |       **9,9** |

Geld ist für ein Technikunternehmen kein Selbstzweck, sondern der Treibstoff, der Entwicklung, Vertrieb und Betrieb finanziert, bis das Geschäft sich selbst trägt. Wer Geld braucht, hat mehrere Quellen zur Auswahl: eigene Einnahmen (Bootstrapping), öffentliche Förderungen, Programme mit Beteiligung, Risikokapital. Jede Quelle hat ihren Preis, nicht nur in Euro, sondern in Kontrolle, Tempo und Verpflichtungen. Dieses Modul erklärt die Quellen, die Rechenlogik dahinter (Bewertung, Verwässerung, Vorzugsrechte) und die Vorbereitung auf ein Gespräch mit Geldgebern. **Alle rechtlichen und steuerlichen Aussagen sind allgemeine Information und keine Rechtsberatung.** Beteiligungsverträge sind komplex; ein auf Gesellschaftsrecht spezialisierter Anwalt gehört bei jeder echten Finanzierung dazu. Die Programme laufen mit Python 3 ohne Zusatzpakete; alle Zahlen sind erfundene Beispiele, soweit nicht ausdrücklich eine Quelle genannt wird.

## 8.1 Bootstrapping und Umsatzfinanzierung

*Bootstrapping* heißt, ein Unternehmen aus eigenen Mitteln und laufenden Einnahmen aufzubauen, ohne externes Beteiligungskapital. Der Vorteil liegt auf der Hand: Man behält Kontrolle und Anteile, entscheidet allein über Tempo und Richtung und zahlt keine Rendite an Dritte. Der Preis ist die Geschwindigkeit. Wachstum ist auf das beschränkt, was das Unternehmen selbst verdient oder vorfinanzieren kann, und in Märkten, in denen der Schnellste gewinnt, kann das ein Nachteil sein. Die Entscheidung zwischen Bootstrapping und externem Kapital ist daher eine Abwägung zwischen Kontrolle und Wachstumsgeschwindigkeit, keine Frage von richtig oder falsch.

Umsatzfinanzierung bedeutet, die frühen Einnahmen gezielt zur Finanzierung zu nutzen. Dazu gehören *Kundenfinanzierung* (Pilotkunden zahlen für Entwicklung, die sie selbst brauchen), *Dienstleistungen* (Beratung oder Einführung als Brücke, während das Produkt reift), *Vorauszahlungen* (Jahresverträge im Voraus statt monatlicher Raten) und *Kundenanzahlungen* bei Projekten. Die größte Gefahr des Servicegeschäfts ist, dass es das Produkt verdrängt: Wer vom Einzelprojekt lebt, baut oft Sonderlösungen statt eines wiederholbaren Produkts. Eine nützliche Regel ist, den Anteil der Dienstleistungen am Umsatz im Auge zu behalten und für Kundenaufträge nur zu Funktionen zuzusagen, die ins Produkt gehören.

Das Programm vergleicht, wie sich die Kasse entwickelt, wenn Kunden monatlich zahlen oder ein Jahr im Voraus mit zwei Gratismonaten.

```python
kunden_neu_pro_monat = 20
monatspreis = 49.0
jahrespreis = 490.0        # Jahresvorauszahlung mit zwei Gratismonaten
fixkosten = 18_000.0

def kasse_nach(monate, vorauszahlung):
    kasse = 0.0
    kunden = 0
    for m in range(1, monate + 1):
        kunden += kunden_neu_pro_monat
        if vorauszahlung:
            kasse += kunden_neu_pro_monat * jahrespreis          # Neukunden zahlen sofort ein Jahr
        else:
            kasse += kunden * monatspreis                          # Bestand zahlt jeden Monat
        kasse -= fixkosten
    return round(kasse)

for monate in (3, 6, 12):
    print(f"Nach {monate:2d} Monaten: monatlich {kasse_nach(monate, False):9d}   Jahresvorauszahlung {kasse_nach(monate, True):9d}")
```

Pro Monat kommen 20 neue Kunden. Im ersten Modell zahlt der gesamte Bestand jeden Monat 49 Euro, im zweiten zahlt jeder Neukunde sofort 490 Euro für ein Jahr. Fixkosten von 18 000 Euro fallen in beiden Fällen an. Nach drei Monaten liegt die Kasse im Monatsmodell bei −48 120 Euro, im Vorauszahlungsmodell bei −24 600 Euro; nach sechs Monaten sind es −87 420 gegen −49 200 Euro und nach zwölf Monaten −139 560 gegen −98 400 Euro. Die Vorauszahlung halbiert in der Anfangsphase etwa die Lücke, weil das Geld früher eintrifft, obwohl der Jahrespreis mit 490 Euro sogar unter zwölf Monatsraten (588 Euro) liegt. Das Modell vereinfacht stark: Verlängerungen nach zwölf Monaten fehlen, und die Leistung muss über das Jahr erbracht werden (die Vorauszahlung ist buchhalterisch zunächst eine Verbindlichkeit und kein Ertrag, siehe Modul 07). Außerdem können Kunden bei Kündigung Rückerstattungen verlangen.

Typische Fehler: den Vorteil des Bootstrappings überschätzen („dann brauchen wir nie jemanden“), Services nicht zu bepreisen oder Pilotkunden Dauerrabatte zu geben, die später nicht mehr zu korrigieren sind. Falsch: „Der erste Kunde zahlt uns nur die Hälfte, aber dafür baut er alles mit.“ Richtig: Pilotkunden zahlen einen echten, wenn auch reduzierten Preis, und die Zusammenarbeit ist vertraglich so geregelt, dass die Entwicklungen im Produkt bleiben (Modul 11, Vertragsgrundlagen).

> **Merke**
>
> Bootstrapping erhält Kontrolle und Anteile, begrenzt aber das Wachstumstempo. Kundenfinanzierung, Services und Vorauszahlungen verbessern die Liquidität. Servicegeschäft darf das Produkt nicht verdrängen.

> **Praxisbeispiel**
>
> Auch Unternehmen, die später Risikokapital aufnehmen, profitieren von frühem Umsatz: Echte zahlende Kunden sind das stärkste Argument in jedem Finanzierungsgespräch und stärken die Verhandlungsposition bei der Bewertung.

## 8.2 Förderprogramme und Grants

*Förderungen* sind öffentliche Mittel, die Unternehmen für bestimmte Vorhaben erhalten. Sie stehen in Österreich auf mehreren Ebenen zur Verfügung: europäisch (zum Beispiel Programme der EU-Kommission), national (etwa über die Förderbanken und Agenturen des Bundes) und regional (Länder, Städte). Man unterscheidet *Zuschüsse* (nicht zurückzuzahlen), *zinsgünstige Kredite*, *Haftungen und Garantien* sowie *Beteiligungen*. Jede Förderung folgt einer eigenen Logik, die man verstehen muss, bevor man sie plant: Welches Vorhaben ist förderfähig, welche Kosten werden anerkannt, wie hoch ist die Förderquote, wie viel Eigenmittel müssen aufgebracht werden, wann wird ausgezahlt und was muss nachgewiesen werden.

Der häufigste Denkfehler ist, einen Zuschuss als „Geld, das man bekommt“ zu sehen. In der Regel ist er eine Erstattung: Das Unternehmen führt das Projekt aus, zahlt die Kosten zunächst selbst, legt Nachweise vor (Rechnungen, Zahlungsbelege, Zeitaufzeichnungen) und erhält dann einen Teil zurück. Die Folge ist ein *Vorfinanzierungsbedarf*. Zusätzlich ist der Antrag meist vor Projektbeginn zu stellen; wer vorher loslegt, verliert häufig die Förderfähigkeit der bereits angefallenen Kosten. Die Antragstellung ist selbst Arbeit, die Wochen bis Monate dauern kann.

Das folgende Programm rechnet ein Förderprojekt mit 50 Prozent Förderquote und einem Deckel von 75 000 Euro durch und zeigt, wie viel Geld das Unternehmen zwischenzeitlich vorfinanzieren muss, wenn der Zuschuss jeweils ein Quartal nach den Kosten ausgezahlt wird.

```python
projektkosten_quartal = [50_000, 60_000, 50_000, 40_000]    # 4 Quartale
quote, deckel = 0.50, 75_000
auszahlung_nach_quartalen = 1                                # Zuschuss kommt ein Quartal nach Nachweis

gesamt = sum(projektkosten_quartal)
zuschuss = min(quote * gesamt, deckel)
print(f"Projektkosten {gesamt}, Foerderquote {quote:.0%}, Deckel {deckel} -> Zuschuss {zuschuss:.0f}, Eigenmittel {gesamt - zuschuss:.0f}")

anteil = zuschuss / gesamt
eigenes_geld, hoechster_bedarf = 0.0, 0.0
for q, kosten in enumerate(projektkosten_quartal, 1):
    eigenes_geld += kosten                                   # Kosten zahlt man zuerst selbst
    if q > auszahlung_nach_quartalen:
        eigenes_geld -= projektkosten_quartal[q - 1 - auszahlung_nach_quartalen] * anteil
    hoechster_bedarf = max(hoechster_bedarf, eigenes_geld)
    print(f"Ende Quartal {q}: vorfinanziert {eigenes_geld:9.0f}")
print("Hoechster Vorfinanzierungsbedarf:", round(hoechster_bedarf))
```

Die Projektkosten betragen 200 000 Euro. Die Quote würde 100 000 Euro ergeben, der Deckel begrenzt den Zuschuss aber auf 75 000 Euro; die Eigenmittel sind also 125 000 Euro. Der Zuschuss entspricht 37,5 Prozent der Kosten. Die Schleife führt eine laufende Summe des vorfinanzierten Betrags: Jedes Quartal kommen die Kosten hinzu, und ab dem zweiten Quartal wird die Erstattung für die Kosten des Vorquartals abgezogen. Am Ende von Quartal 1 sind 50 000 Euro vorfinanziert, nach Quartal 2 sind es 91 250, nach Quartal 3 118 750 und nach Quartal 4 140 000 Euro. Das ist der höchste Vorfinanzierungsbedarf, 15 000 Euro über den späteren Eigenmitteln, weil die Erstattung des letzten Quartals erst danach kommt. Wer nur die Eigenmittel von 125 000 Euro plant, steht also zwischendurch ohne Geld da.

> **Ergänzung aus der Nachrecherche**
>
> **EIC Accelerator.** Das EU-Programm (Horizon Europe) richtet sich an Start-ups und KMU mit innovativen Technologien auf einem Reifegrad von TRL 6 bis 8. Laut der Programmseite bietet es einen Zuschuss unter 2,5 Mio. Euro für Innovationsaktivitäten, die innerhalb von 24 Monaten abzuschließen sind, und/oder Eigenkapital beziehungsweise eigenkapitalähnliche Mittel von 1 bis 10 Mio. Euro. Der Ablauf umfasst einen Kurzantrag (Formular, Pitch-Deck und Video), einen Vollantrag, ein Jury-Interview und die Umsetzung; bei Eigenkapital folgt eine Due Diligence von zwei bis sechs Monaten. Anträge mit mindestens 13 von 15 Punkten ohne Einladung zum Interview erhalten ein „Seal of Excellence“. Das Budget für 2026 beträgt 220 Mio. Euro für die Accelerator Challenges und 414 Mio. Euro für die Accelerator Open (Quelle Q9). Das Programm ist hoch kompetitiv; ob es für ein konkretes Vorhaben passt, ist anhand der aktuellen Ausschreibung zu prüfen.
>
> **Österreichische Förderungen (Stand 2022).** Eine Übersicht des Magazins trend nennt unter anderem Programme der aws (Austria Wirtschaftsservice), der FFG und regionaler Agenturen, darunter ein Gründerstipendium der Wirtschaftsagentur Wien mit 1 300 Euro monatlich pro Person (höchstens 25 000 Euro), eine Steiermark-Förderung *Start!Klar* (80 Prozent der Kosten, höchstens 100 000 Euro) und die aws Start-up-Garantie. Die Seite ist vom 24. Jänner 2022; Beträge, Bedingungen und sogar Programme können sich geändert haben, weshalb sie nur als Orientierung dienen. Vor jeder Antragstellung sind die aktuellen Richtlinien auf der Seite des Fördergebers zu prüfen (Quelle Q12; keine Rechtsberatung).

Typische Fehler: vor der Antragstellung mit dem Projekt zu beginnen, Nachweise nicht von Anfang an zu sammeln, den Vorfinanzierungsbedarf zu vergessen und Förderungen als Ersatz für ein tragfähiges Geschäftsmodell zu sehen. Falsch: Man plant ein Projekt rund um das, was gefördert wird, statt rund um das, was Kunden brauchen. Richtig: Man wählt Förderungen, die zu einem Vorhaben passen, das man ohnehin umsetzen würde. Hilfreich sind Beratungsstellen, die Förderungen kennen und bei Anträgen unterstützen.

> **Merke**
>
> Förderungen sind meist Erstattungen mit Antrag vor Projektbeginn, Förderquote, Deckel, Eigenmitteln und Nachweispflichten. Der Vorfinanzierungsbedarf liegt über den späteren Eigenmitteln. Aktuelle Richtlinien sind vor jedem Antrag zu prüfen.

> **Praxisbeispiel**
>
> Förderstellen und Investoren schätzen es, wenn die Förderung Teil einer Gesamtfinanzierung ist. Zuschüsse verbessern die Eigenkapitalquote und können bei Beteiligungsrunden die Verwässerung verringern. Die Kombination und ihre Reihenfolge gehören in die Funding Roadmap (Lerneinheit 8.9).

## 8.3 Accelerators und Incubators

*Accelerators* sind zeitlich befristete Programme (meist drei bis sechs Monate), in denen ausgewählte Start-ups Mentoring, Netzwerk, Büroinfrastruktur und oft ein Startkapital erhalten, meist gegen eine Beteiligung. Am Ende steht typischerweise ein Demo Day, an dem die Teams vor Investoren auftreten. *Incubators* begleiten dagegen in einer früheren Phase über längere Zeit, oft an Hochschulen oder von Wirtschaftsagenturen getragen, und verlangen häufiger keine oder geringe Beteiligungen. Die Grenzen sind fließend, weshalb man jedes Programm einzeln prüft.

Wesentliche Bewertungsmaßstäbe sind das *Netzwerk* (Zugang zu Kunden, Investoren, Experten), die *Qualität des Mentorings*, das *Kapital* und die *Kosten*. Die Kosten sind meist die Anteile: Wer 100 000 Euro für 7 Prozent erhält, gibt implizit eine Bewertung vor, nämlich 100 000 geteilt durch 0,07, also rund 1,43 Mio. Euro. Zusätzlich können Pflichten bestehen: Präsenz vor Ort, Berichte, Verzicht auf andere Programme, Vorkaufsrechte oder Optionen auf Folgeinvestitionen. Diese Bedingungen sind vor Annahme zu lesen und gegebenenfalls juristisch prüfen zu lassen.

```python
programme = {
    "Programm A": {"kapital": 100_000, "anteil": 0.07, "netzwerk": 4, "mentoring": 5, "pflichten": 3},
    "Programm B": {"kapital": 0,       "anteil": 0.00, "netzwerk": 3, "mentoring": 4, "pflichten": 1},
    "Programm C": {"kapital": 250_000, "anteil": 0.10, "netzwerk": 5, "mentoring": 3, "pflichten": 4},
}
for name, p in programme.items():
    bewertung = p["kapital"] / p["anteil"] if p["anteil"] else None
    nutzen = p["netzwerk"] + p["mentoring"] - p["pflichten"]
    text = f"implizite Bewertung {bewertung:,.0f} EUR" if bewertung else "keine Anteile"
    print(f"{name}: {text}, Nutzenwert {nutzen}")
```

Das Programm rechnet für drei erfundene Programme die implizite Bewertung aus Kapital und Anteil und einen einfachen Nutzenwert aus Netzwerk plus Mentoring minus Pflichten (Skala jeweils 1 bis 5, vom Team selbst geschätzt). Programm A bietet 100 000 Euro für 7 Prozent, entspricht einer Bewertung von 1 428 571 Euro und hat den Nutzenwert 6. Programm B nimmt keine Anteile und hat ebenfalls den Wert 6. Programm C zahlt 250 000 Euro für 10 Prozent (Bewertung 2,5 Mio. Euro), hat aber viele Pflichten und kommt auf 4. Die Zahl ist keine Wahrheit, sondern ein Hilfsmittel, um Annahmen offenzulegen und zu vergleichen; wichtiger ist die Frage, ob die implizite Bewertung zum Stand des Unternehmens passt und der Nutzen den Anteilspreis rechtfertigt.

Typische Fehler: sich vom Namen des Programms beeindrucken lassen, ohne die Konditionen zu lesen; mehrere Programme anzunehmen, die einander ausschließen; die Zeit zu unterschätzen, die das Programm im Tagesgeschäft bindet. Falsch: „Hauptsache dabei, die Anteile sind egal.“ Richtig: Eine frühe Abgabe von Anteilen wirkt über alle künftigen Runden weiter, denn spätere Investoren sehen die Cap Table (Lerneinheit 8.6). Vor einer Zusage hilft ein Gespräch mit früheren Teilnehmern.

> **Merke**
>
> Accelerators und Incubators bieten Netzwerk, Mentoring und teils Kapital, meist gegen Anteile. Die implizite Bewertung und die Pflichten sind zu prüfen. Entscheidend ist der echte Nutzen für die nächsten Meilensteine.

> **Praxisbeispiel**
>
> Typischer Ablauf: Bewerbung mit Kurz-Pitch, Auswahlgespräch, Programm mit Mentoring-Terminen und Demo Day. Rechnen Sie den Zeitaufwand ein; ein Programm kann das Team zu Lasten der Produktentwicklung stark binden.

## 8.4 Venture Capital Grundlagen

*Venture Capital* (VC, Risikokapital) ist Beteiligungskapital, das Fonds in junge Unternehmen mit hohem Wachstumspotenzial investieren. Die Fonds sammeln Geld von Anlegern (institutionelle Investoren, Family Offices) und investieren es in viele Start-ups, von denen die meisten scheitern oder bescheiden bleiben. Nur wenige wachsen so stark, dass sie die Verluste der anderen mehr als ausgleichen. Daraus folgt die *Investorenlogik*: Ein VC sucht nicht ein solides Geschäft, sondern ein Unternehmen, das groß genug werden kann, um den ganzen Fonds zu bewegen. Geschäfte, die stabil, aber begrenzt wachsen, sind als Unternehmen gut, als VC-Investment aber ungeeignet. Das ist keine Wertung, sondern eine Passungsfrage.

Die Finanzierungsphasen heißen grob *Pre-Seed* (Idee und erste Tests, kleine Beträge von Business Angels, Förderungen oder Accelerators), *Seed* (erste Produkt-Markt-Belege), *Series A* (belegte Wachstumsmaschine, Skalierung) und danach Series B und weitere. Die Beträge und Reifekriterien unterscheiden sich nach Markt und Zeit, weshalb man sie aktuell recherchiert. Zentral sind die Begriffe *Pre-Money-Bewertung* (Wert des Unternehmens vor der Investition) und *Post-Money-Bewertung* (Wert danach, also Pre-Money plus Investition). Der Anteil des Investors ergibt sich als Investitionssumme geteilt durch die Post-Money-Bewertung.

Das Programm rechnet eine Runde durch und beantwortet die Frage, welchen Exit ein Investor braucht, damit sich seine Renditeerwartung erfüllt.

```python
investition = 2_000_000
anteil_heute = 0.20
post_money = investition / anteil_heute
pre_money = post_money - investition
print(f"Post-Money {post_money:,.0f}  Pre-Money {pre_money:,.0f}")

verwaesserung = [0.80, 0.85]          # spaetere Runden: Investor behaelt 80 % bzw. 85 % seiner Quote
anteil_exit = anteil_heute
for faktor in verwaesserung:
    anteil_exit *= faktor
print(f"Anteil beim Exit: {anteil_exit:.3f}")

ziel_multiple = 10
noetiger_exit = ziel_multiple * investition / anteil_exit
print(f"Fuer {ziel_multiple}x braucht der Investor einen Exit von {noetiger_exit:,.0f} EUR")

fonds, ruecklauf = 100_000_000, 3
print("Fonds braucht Rueckfluss von", fonds * ruecklauf)
```

Ein Investor legt 2 Mio. Euro an und erhält dafür 20 Prozent; die Post-Money-Bewertung ist 2 Mio. geteilt durch 0,2, also 10 Mio. Euro, und die Pre-Money-Bewertung 8 Mio. Euro. In späteren Runden wird der Anteil verwässert: Die Zeilen mit `verwaesserung` bedeuten, dass der Investor nach der ersten Folgerunde noch 80 Prozent und nach der zweiten noch 85 Prozent seines Anteils hält. Aus den 20 Prozent werden so 13,6 Prozent beim Exit. Will der Investor das Zehnfache zurück (10x), braucht er einen Exit-Wert von 10 mal 2 Mio. geteilt durch 0,136, also rund 147 Mio. Euro. Das zeigt den Skalierungsdruck: Das Unternehmen muss in wenigen Jahren hundertfach größer werden als zum Zeitpunkt der Investition. Zum Vergleich benötigt ein Fonds von 100 Mio. Euro, der das Dreifache zurückzahlen soll, Rückflüsse von 300 Mio. Euro, was nur durch einzelne sehr große Treffer erreichbar ist. Die Ziele (10x, 3x) sind hier erfundene Beispielwerte.

Typische Fehler: Annehmen, VC sei der einzige Weg („Fundraising als Erfolg“), eine Bewertung so hoch zu verhandeln, dass die nächste Runde nur als Abschlag möglich ist (*Down Round*), und Investoren nach Rendite statt nach Passung auszuwählen. Falsch: „Wir nehmen das Angebot mit der höchsten Bewertung.“ Richtig: Neben der Bewertung zählen Konditionen (Lerneinheit 8.8), Erfahrung im Markt, Unterstützung bei Folgerunden und das Verhältnis zu den Gründern.

> **Merke**
>
> VC investiert in Unternehmen, die sehr groß werden können; der Fondslogik entspricht ein hoher Skalierungsdruck. Pre- und Post-Money bestimmen den Anteil; spätere Runden verwässern. VC ist nur dann passend, wenn Geschäftsmodell und Ambition zusammenpassen.

> **Praxisbeispiel**
>
> Investoren lernt man über Netzwerke, Warm-Introductions und Veranstaltungen kennen. Ein strukturierter Prozess (Liste passender Fonds, Reihenfolge, Zeitplan) verkürzt das Fundraising, das meist mehrere Monate dauert.

## 8.5 Pitch Deck

Das *Pitch Deck* ist die Präsentation, mit der man Investoren, Förderstellen oder Partner in zehn bis zwanzig Folien überzeugt. Es soll ein Gespräch auslösen, kein Dokument ersetzen. Die klassische Gliederung beantwortet nacheinander die Fragen, die jeder Geldgeber hat: Welches *Problem* gibt es und für wen? Welche *Lösung* bieten Sie, und warum jetzt? Wie groß ist der *Markt*? Welche *Traction* (messbarer Fortschritt) haben Sie bereits? Wie verdienen Sie Geld (Geschäftsmodell)? Wer ist die *Konkurrenz* und was ist Ihr Vorteil? Wer ist das *Team*? Wie sehen die *Finanzen* aus, wie viel Geld wird gesucht (*Ask*) und wofür (*Mittelverwendung*)?

Die Marktgröße wird meist in drei Stufen genannt: *TAM* (Total Addressable Market, gesamter Markt), *SAM* (Serviceable Addressable Market, der Teil, den Sie mit Ihrem Produkt und Ihren Kanälen erreichen können) und *SOM* (Serviceable Obtainable Market, der Teil, den Sie realistisch gewinnen). Investoren misstrauen Behauptungen wie „Wenn wir nur ein Prozent des Weltmarkts erobern“, weil sie keine Strategie enthalten. Eine nachvollziehbare Herleitung von unten (Zahl erreichbarer Kunden mal Preis) überzeugt mehr als eine große Studie.

Eine wichtige Eigenschaft eines guten Decks ist Konsistenz: Die Zahlen auf den Folien müssen zueinander und zur Buchhaltung passen. Das Programm prüft einige solche Konsistenzen automatisch.

```python
deck = {
    "arr": 620_000, "arr_buchhaltung": 624_000,
    "tam": 12_000_000_000, "sam": 900_000_000, "som": 18_000_000,
    "ask": 1_500_000, "burn": 85_000,
    "mittelverwendung": {"Produkt": 0.45, "Vertrieb": 0.35, "Betrieb": 0.15, "Reserve": 0.05},
}
if abs(deck["arr"] - deck["arr_buchhaltung"]) / deck["arr_buchhaltung"] > 0.01:
    print("ARR im Deck weicht um mehr als 1 % von der Buchhaltung ab")
summe = sum(deck["mittelverwendung"].values())
print("Mittelverwendung gesamt:", round(summe * 100), "%")
print("Reihenfolge Markt:", deck["tam"] > deck["sam"] > deck["som"])
runway = deck["ask"] / deck["burn"]
print(f"Runway aus der Runde: {runway:.1f} Monate")
if runway < 18:
    print("Hinweis: unter 18 Monaten, Begruendung noetig oder Betrag erhoehen")
```

Das Programm vergleicht den ARR im Deck (620 000 Euro) mit dem ARR aus der Buchhaltung (624 000 Euro); die Abweichung beträgt etwa 0,6 Prozent und liegt unter der Schwelle von 1 Prozent, weshalb keine Meldung erscheint. Die Mittelverwendung wird aufsummiert (100 Prozent) und die Marktgrößen werden auf die Reihenfolge TAM, SAM und SOM geprüft. Zuletzt rechnet es aus dem gesuchten Betrag (1,5 Mio. Euro) und dem monatlichen Burn (85 000 Euro) die Runway der Runde: 17,6 Monate. Weil das unter den üblichen 18 Monaten liegt, gibt das Programm einen Hinweis aus: Entweder ist eine Begründung nötig, oder der Betrag sollte höher sein. Der Wert von 18 Monaten ist hier eine Faustregel, die man vor dem Gespräch mit dem eigenen Plan abgleicht.

Typische Fehler: zu viele Folien und zu viel Text, ein überdimensionierter Markt ohne Herleitung, fehlende Traction-Belege und ein unklarer Ask. Falsch: Eine Folie „Wettbewerb“ mit der Aussage „Wir haben keine Konkurrenz“. Richtig: Auch „Nichtstun“, Excel oder interne Eigenlösungen sind Konkurrenz. Das Deck braucht eine Storyline, die sich an der Entscheidung des Investors orientiert, und zwei Versionen: eine kurze zum Versenden und eine ausführlichere zum Vortragen mit Anhang.

> **Merke**
>
> Ein Pitch Deck beantwortet in klarer Reihenfolge die Fragen von Investoren: Problem, Lösung, Markt, Traction, Geschäftsmodell, Konkurrenz, Team, Finanzen und Ask. Zahlen müssen konsistent und belegbar sein, die Marktgröße wird von unten hergeleitet.

> **Praxisbeispiel**
>
> Die Zahlen aus dem Deck werden später in der Due Diligence nachgeprüft (Lerneinheit 8.7). Jede Abweichung zwischen Deck, Datenraum und Buchhaltung kostet Vertrauen; deshalb pflegt man eine einzige Quelle für Kennzahlen (Modul 07).

## 8.6 Cap Table und Verwässerung

Die *Cap Table* (Kapitalisierungstabelle) listet, wem welche Anteile an einem Unternehmen gehören, einschließlich Optionen, Wandeldarlehen und anderer künftiger Ansprüche. Sie ist das zentrale Dokument jeder Finanzierung, weil sie zeigt, wer wie viel von welcher Wertsteigerung erhält und wer in welchem Umfang mitbestimmt. Eine saubere, aktuelle Cap Table ist Voraussetzung dafür, überhaupt ernsthaft mit Investoren zu sprechen.

Der zentrale Mechanismus ist die *Verwässerung* (Dilution): Wenn das Unternehmen neue Anteile ausgibt, sinkt der prozentuale Anteil aller bisherigen Gesellschafter, auch wenn die Zahl ihrer Anteile gleich bleibt. Verwässerung ist nicht schlecht, wenn der Wert des Unternehmens durch das neue Geld stärker wächst als der Anteil sinkt: Ein kleinerer Anteil an einer größeren Firma kann mehr wert sein. Sie wird erst schädlich, wenn Gründer zu früh zu viele Anteile abgeben. Zu Verwässerung führt auch der *Mitarbeiter-Optionspool*, ein reservierter Anteil, mit dem Mitarbeitende künftig beteiligt werden.

Daneben gibt es Instrumente, die Anteile erst später entstehen lassen. Ein *Wandeldarlehen* (Convertible Note) ist ein Darlehen, das später in Anteile umgewandelt wird, meist bei der nächsten Finanzierungsrunde, mit einem *Abschlag* auf den Preis der Runde und/oder einem *Bewertungsdeckel* (Cap). Ein *SAFE* (Simple Agreement for Future Equity) ist ein ähnliches Instrument aus der US-Praxis, das keine Zinsen und keine Rückzahlung vorsieht; die rechtliche Einordnung in Österreich und Deutschland ist komplex und im Einzelfall zu klären. Das Programm modelliert eine Runde und eine Wandlung.

```python
anteile = {"Gruendung A": 4_500_000, "Gruendung B": 4_500_000, "Mitarbeiterpool": 1_000_000}
def zeige(titel):
    gesamt = sum(anteile.values())
    print(titel, f"(gesamt {gesamt:,})")
    for name, n in anteile.items():
        print(f"  {name:18s} {n:10,d} {n / gesamt:7.2%}")

zeige("Start")
pre_money, investition = 4_000_000, 1_000_000
gesamt = sum(anteile.values())
preis = pre_money / gesamt
neue = round(investition / preis)
anteile["Seed-Investor"] = neue
print(f"Preis je Anteil {preis:.4f}, neue Anteile {neue:,}")
zeige("Nach Seed")

# Wandeldarlehen: 300.000 EUR, Bewertungsdeckel 3 Mio. EUR, 20 % Abschlag, naechste Runde zu 8 Mio. Pre-Money
darlehen, deckel, abschlag = 300_000, 3_000_000, 0.20
gesamt = sum(anteile.values())
preis_runde = 8_000_000 / gesamt
preis_deckel = deckel / gesamt
preis_abschlag = preis_runde * (1 - abschlag)
umwandlung = min(preis_deckel, preis_abschlag)
print(f"Preise: Runde {preis_runde:.4f}, Deckel {preis_deckel:.4f}, Abschlag {preis_abschlag:.4f} -> Umwandlung zu {umwandlung:.4f}")
anteile["Wandeldarlehen"] = round(darlehen / umwandlung)
zeige("Nach Umwandlung")
```

Zu Beginn halten zwei Gründer je 4,5 Millionen Anteile (45 Prozent) und ein Mitarbeiterpool 1 Million (10 Prozent). In der Seed-Runde investiert ein Investor 1 Mio. Euro bei einer Pre-Money-Bewertung von 4 Mio. Euro. Der Preis je Anteil ergibt sich als Pre-Money geteilt durch die vorhandenen Anteile: 0,40 Euro. Der Investor erhält daher 2,5 Millionen neue Anteile, das sind 20 Prozent der nunmehr 12,5 Millionen. Die Gründer fallen von je 45 auf je 36 Prozent, der Pool von 10 auf 8 Prozent. Im zweiten Teil wird ein Wandeldarlehen über 300 000 Euro mit einem Bewertungsdeckel von 3 Mio. Euro und 20 Prozent Abschlag bei einer Folgerunde mit 8 Mio. Euro Pre-Money umgewandelt. Der Preis der Runde wäre 0,64 Euro je Anteil; mit Abschlag 0,512 Euro; mit Deckel 0,24 Euro. Für den Darlehensgeber gilt der niedrigere Preis, also 0,24 Euro, und er erhält 1,25 Millionen Anteile (9,09 Prozent), was die Gründer auf je 32,73 Prozent verwässert. Das Beispiel ist bewusst vereinfacht; in der Praxis regeln die Verträge, ob Pool und Darlehen in die Pre-Money-Bewertung eingerechnet werden, was das Ergebnis verändert.

> **Ergänzung aus der Nachrecherche**
>
> Zu Mitarbeiterbeteiligungen nennt ein Bericht von Trending Topics (Stand 20. Jänner 2026) die Verlängerung einer österreichischen Übergangsregelung für Phantom Shares: Startups sollen bestehende virtuelle Beteiligungen bis Ende 2026 in echte Mitarbeiterbeteiligungen umwandeln können, ohne dass bei der Umwandlung sofort Steuer anfällt; besteuert wird erst, wenn ein Erlös realisiert wird. Als Bedingungen des bestehenden Rahmens (seit Jänner 2024) nennt der Artikel unter anderem höchstens 100 Beschäftigte, höchstens 40 Mio. Euro Umsatz und eine Beteiligung innerhalb von zehn Jahren nach Gründung. Der Artikel beschreibt den Beschluss des Finanzausschusses; die endgültige Abstimmung im Nationalrat war zum Zeitpunkt des Artikels erst vorgesehen, der endgültige Stand ist daher zu prüfen (Quelle Q10; keine Rechtsberatung oder Steuerberatung).

Typische Fehler: Handschriftliche Tabellen ohne Versionierung, Zusagen an Berater oder Mitarbeitende ohne Dokumentation („du bekommst ein Prozent“), zu kleiner Optionspool für künftige Einstellungen und Instrumente, deren Wirkung niemand durchgerechnet hat. Falsch: Man vereinbart ein Wandeldarlehen ohne Deckel und ohne zu prüfen, wie viele Anteile bei einer hohen Bewertung entstehen. Richtig: Vor jeder Unterschrift die Cap Table nach der Runde („pro forma“) berechnen. Zu den Aufgaben der Cap Table gehört auch, Gründer-Kontrolle zu planen: Wer mehr als 50 Prozent der Stimmen hält, entscheidet in vielen Angelegenheiten allein, Sperrminoritäten und Vetorechte können aber auch kleine Gesellschafter erhalten.

> **Merke**
>
> Die Cap Table zeigt Anteile, Optionen und Wandelinstrumente. Neue Anteile verwässern alle bisherigen Gesellschafter; entscheidend ist, ob der Wert stärker steigt als der Anteil sinkt. Wandeldarlehen und SAFEs werden mit Deckel und Abschlag zum niedrigeren Preis umgewandelt.

> **Praxisbeispiel**
>
> Es gibt Software für Cap-Table-Verwaltung, aber ein gut gepflegtes Tabellenblatt mit Versionsstand genügt in frühen Phasen. Wichtig sind Unterschriften, Vertragsstände und die Übereinstimmung mit dem Firmenbuch beziehungsweise Gesellschafterliste.

## 8.7 Due Diligence Vorbereitung

Die *Due Diligence* (DD, „gebotene Sorgfalt“) ist die Prüfung eines Unternehmens durch einen Investor oder Käufer vor der Entscheidung. Sie umfasst mehrere Bereiche: *Legal* (Gesellschaftsvertrag, Verträge, Rechte an geistigem Eigentum, Streitigkeiten), *Finance* (Jahresabschlüsse, Planung, Kennzahlen, Steuern), *Tech* (Architektur, Codequalität, Lizenzen, Betrieb), *Security* (Datenschutz, Sicherheitskonzept, Vorfälle; Modul 06) und *Commercial* (Kunden, Verträge, Markt, Pipeline). Die Unterlagen werden meist in einem *Datenraum* (virtuellen Ordner mit Zugriffsrechten) bereitgestellt.

Gute Vorbereitung bedeutet, dass die Unterlagen existieren, geordnet und aktuell sind, bevor ein Investor danach fragt. Das beschleunigt den Prozess, signalisiert Professionalität und verhindert Verhandlungsnachteile, die entstehen, wenn Mängel erst spät auffallen. Besonders wichtig ist die *Red-Flag-Analyse*: Man sucht vorab selbst nach Punkten, die ein Investor problematisch finden könnte, und behebt oder erklärt sie. Typische Red Flags sind fehlende Rechte am Quellcode (etwa weil Freelancer oder Gründer keine Abtretungsvereinbarungen unterschrieben haben), eine unklare Cap Table, unvollständige Kundenverträge, offene Rechtsstreitigkeiten, Datenschutzmängel oder fehlende Nachweise für Kennzahlen.

```python
checkliste = {
    "Recht":    {"Gesellschaftsvertrag": True, "Cap Table aktuell": True, "Vertraege mit Kunden": False, "IP-Abtretungen": False},
    "Finanzen": {"Jahresabschluss": True, "Monatsabschluss": True, "Planung": True},
    "Technik":  {"Architekturdokumentation": True, "Lizenzliste": False},
    "Sicherheit": {"Datenschutz-Verzeichnis": True, "Penetrationstest": False},
}
KRITISCH = {"IP-Abtretungen", "Cap Table aktuell"}
gesamt = erledigt = 0
for bereich, punkte in checkliste.items():
    ok = sum(punkte.values())
    gesamt += len(punkte)
    erledigt += ok
    print(f"{bereich:10s} {ok}/{len(punkte)}")
print(f"Bereit: {erledigt}/{gesamt} = {erledigt * 100 // gesamt} %")
for bereich, punkte in checkliste.items():
    for name, vorhanden in punkte.items():
        if not vorhanden:
            stufe = "KRITISCH" if name in KRITISCH else "offen"
            print(f"  [{stufe}] {bereich}: {name}")
```

Das Programm führt eine Checkliste nach Bereichen und zählt die vorhandenen Unterlagen. Das Ergebnis lautet 7 von 11 Punkten, also 63 Prozent. Danach werden die fehlenden Punkte aufgelistet; solche, die in der Menge `KRITISCH` stehen, werden hervorgehoben. Hier sind das die IP-Abtretungen (Übertragung der Rechte am Code durch Mitarbeitende und Dienstleister), ein Punkt, den Investoren sehr ernst nehmen. Die anderen Lücken (Kundenverträge, Lizenzliste, Penetrationstest) sind offen, aber weniger gravierend. Eine solche Liste, die vor dem Fundraising entsteht und pro Bereich eine verantwortliche Person hat, ist ein einfaches und wirksames Steuerungsinstrument.

Typische Fehler: Unterlagen erst nach Anfrage zusammensuchen, widersprüchliche Versionen im Datenraum, zu viel Vertrauliches zu früh offenlegen. Falsch: Alle Dokumente sofort für alle Interessenten freigeben. Richtig: Stufenweise Freigabe, nach unterzeichneter Vertraulichkeitsvereinbarung und je nach Fortschritt der Gespräche; sensible Teile (zum Beispiel Quellcode) werden nur an Gewinner der engeren Auswahl und in kontrollierter Form gezeigt. Ein Verzeichnis, wer wann welche Unterlagen gesehen hat, gehört dazu.

> **Merke**
>
> Due Diligence prüft Legal, Finance, Tech, Security und Commercial. Wer Unterlagen vorab ordnet und Red Flags selbst beseitigt, verhandelt aus der Stärke. Datenräume werden gestuft und mit Vertraulichkeitsvereinbarung geöffnet.

> **Praxisbeispiel**
>
> Planen Sie für die Vorbereitung ein bis zwei Wochen ein, bevor das Fundraising beginnt. Die Arbeit lohnt sich mehrfach: auch für Förderanträge, Großkunden-Audits (Modul 06) und spätere Verkaufsprozesse.

## 8.8 Term Sheet Grundlagen

Ein *Term Sheet* ist eine Absichtserklärung, in der ein Investor die wesentlichen Bedingungen einer Beteiligung festhält, bevor der ausführliche Vertrag geschrieben wird. Es ist meist nicht rechtlich verbindlich, mit Ausnahme einzelner Teile wie Vertraulichkeit oder Exklusivität, legt aber den Rahmen fest, an den sich die späteren Verträge halten. Deshalb ist es der Moment, in dem verhandelt wird. Die wichtigsten Punkte sind: die *Bewertung* und der Investitionsbetrag, die Art der Anteile, die *Liquidationspräferenz*, das *Vesting* der Gründeranteile, Mitbestimmungsrechte (Beirat, Zustimmungsvorbehalte), Verwässerungsschutz, Vorkaufs- und Mitverkaufsrechte und die Regelungen zum Mitarbeiter-Optionspool.

Die *Liquidationspräferenz* bestimmt, wer im Verkaufs- oder Liquidationsfall zuerst und wie viel erhält. Bei einer „1x nicht teilnehmenden“ Präferenz bekommt der Investor entweder sein eingesetztes Geld zurück oder seinen Anteil am Erlös, je nachdem, was höher ist. Bei einer „teilnehmenden“ Präferenz erhält er zuerst sein Geld zurück und danach zusätzlich seinen Anteil am Rest. Das ist für Gründer deutlich teurer. Das *Vesting* verteilt die Gründeranteile über einen Zeitraum (zum Beispiel vier Jahre) mit einer anfänglichen Sperre, dem *Cliff* (zum Beispiel ein Jahr); verlässt ein Gründer das Unternehmen früh, verfällt der noch nicht erdiente Teil.

```python
def auszahlung(exit_wert, investiert=2_000_000, anteil=0.20, art="1x nicht teilnehmend"):
    if art == "1x nicht teilnehmend":
        investor = max(min(investiert, exit_wert), anteil * exit_wert)
    elif art == "1x teilnehmend":
        pref = min(investiert, exit_wert)
        investor = pref + anteil * (exit_wert - pref)
    else:
        investor = anteil * exit_wert                  # keine Praeferenz
    return investor, exit_wert - investor

for exit_wert in (1_500_000, 5_000_000, 20_000_000):
    print(f"Exit {exit_wert:>10,}")
    for art in ("keine", "1x nicht teilnehmend", "1x teilnehmend"):
        inv, rest = auszahlung(exit_wert, art=art)
        print(f"   {art:22s} Investor {inv:11,.0f}  Uebrige {rest:11,.0f}")

def vested(monate, gesamt=4800, cliff=12, laufzeit=48):
    if monate < cliff:
        return 0
    return min(gesamt, gesamt * monate // laufzeit)
print([ (m, vested(m)) for m in (6, 11, 12, 24, 48) ])
```

Die Funktion `auszahlung` berechnet, was der Investor bei verschiedenen Arten erhält. Der Investor hat 2 Mio. Euro investiert und hält 20 Prozent. Bei einem Exit von 1,5 Mio. Euro (unter dem investierten Betrag) bekommt er mit Präferenz alles, 1,5 Mio., ohne Präferenz nur 300 000 Euro. Bei einem Exit von 5 Mio. Euro erhält er mit nicht teilnehmender Präferenz 2 Mio. (die Rückzahlung ist höher als 20 Prozent von 5 Mio. = 1 Mio.), mit teilnehmender Präferenz 2 Mio. plus 20 Prozent von 3 Mio. = 2,6 Mio. Euro. Bei einem Exit von 20 Mio. Euro ergibt der Anteil von 20 Prozent 4 Mio. Euro und ist höher als die Rückzahlung, daher stellt sich die nicht teilnehmende Variante gleich wie die ohne Präferenz; mit Teilnahme sind es 5,6 Mio. Euro. Der letzte Teil rechnet das Vesting von 4 800 Anteilen über 48 Monate mit 12 Monaten Cliff: Vor dem zwölften Monat sind es null, im zwölften Monat 1 200 (ein Viertel), nach 24 Monaten 2 400 und nach 48 Monaten alle 4 800.

Typische Fehler: nur auf die Bewertung zu schauen und die übrigen Bedingungen zu übersehen; sich mit Begriffen zu begnügen, die man nicht rechnen kann; ohne Berater zu unterschreiben. Falsch: „Die Bewertung ist hoch, der Rest ist Standard.“ Richtig: Verhandlungspunkte nach Wirkung priorisieren: Kontrolle (Beirat, Vetorechte), wirtschaftliche Bedingungen (Präferenz, Verwässerungsschutz), Vesting und Pool. Eine Bewertung kann durch strenge Präferenzen teuer erkauft sein. Das Term Sheet ist nicht das Ende, aber nach Unterzeichnung bleibt oft nur wenig Spielraum.

> **Merke**
>
> Das Term Sheet legt Bewertung, Anteilsart, Liquidationspräferenz, Vesting und Kontrollrechte fest. Teilnehmende Präferenzen sind für Gründer teurer als nicht teilnehmende. Verhandlungspunkte werden nach Wirkung priorisiert, und ein Fachanwalt prüft die Verträge.

> **Praxisbeispiel**
>
> Lassen Sie sich Beispielrechnungen erstellen (Waterfall) für mehrere Exit-Werte. Wer die Auszahlung bei einem Exit von 5, 20 und 100 Mio. Euro je Variante sieht, versteht die Wirkung der Klauseln sofort.

## 8.9 Funding Roadmap

Die *Funding Roadmap* verknüpft den Kapitalbedarf mit den Meilensteinen des Unternehmens und legt fest, wann welche Finanzierung gesucht wird. Der Kerngedanke: Geld wird nicht „auf Vorrat“ gesucht, sondern für ein Ziel, das den Wert des Unternehmens messbar steigert. Typische Meilensteine sind Pilotkunden, die ersten 100 zahlenden Kunden, ein erreichter Jahresumsatz oder eine wiederholbare Vertriebsstruktur. Die Roadmap beantwortet drei Fragen: Wie viel Geld brauchen wir bis zum nächsten Meilenstein, wann geht uns das Geld aus, und wann müssen wir mit dem Fundraising beginnen?

Der Zeitplan ist die häufigste Schwachstelle. Ein Fundraising dauert nach verbreiteter Erfahrung oft sechs Monate oder länger, von den ersten Gesprächen bis zur Überweisung, und die Verhandlungsposition ist am besten, solange noch Geld da ist. Wer erst bei drei Monaten Runway beginnt, verhandelt unter Druck. Daher rechnet man rückwärts: Kasse leer minus Dauer des Fundraisings minus Puffer ergibt den spätesten Starttermin.

```python
from datetime import date

def monat_plus(d, n):
    m = d.month - 1 + n
    return date(d.year + m // 12, m % 12 + 1, 1)

heute = date(2026, 11, 1)
kasse, burn = 600_000, 50_000
meilensteine = [
    # (Name, Zieldatum, zusaetzliche Investitionen bis dahin)
    ("Pilotkunden gewonnen",          date(2027, 3, 1), 0),
    ("100 zahlende Kunden",           date(2027, 9, 1), 40_000),
    ("Skalierbarer Vertrieb",         date(2028, 6, 1), 150_000),
]
runway = kasse // burn
kasse_leer = monat_plus(heute, runway)
print(f"Kasse reicht bis {kasse_leer:%m/%Y} ({runway} Monate)")
fundraising_dauer, puffer = 6, 3
start = monat_plus(kasse_leer, -(fundraising_dauer + puffer))
print(f"Fundraising spaetestens starten: {start:%m/%Y}")
for name, wann, zusatz in meilensteine:
    monate = (wann.year - heute.year) * 12 + wann.month - heute.month
    bedarf = monate * burn + zusatz
    luecke = max(0, bedarf - kasse)
    status = "durch Kasse gedeckt" if luecke == 0 else f"Luecke {luecke:,} EUR"
    print(f"{name:24s} {wann:%m/%Y} ({monate:2d} Monate)  Bedarf {bedarf:>9,}  {status}")
```

Mit 600 000 Euro Kasse und 50 000 Euro Burn beträgt die Runway 12 Monate; ab November 2026 reicht das Geld also bis November 2027. Für das Fundraising werden sechs Monate und drei Monate Puffer angesetzt, der späteste Start ist daher Februar 2027. Die Schleife prüft pro Meilenstein den Bedarf aus Monaten mal Burn plus zusätzlichen Investitionen. Pilotkunden (März 2027, 4 Monate) brauchen 200 000 Euro, 100 zahlende Kunden (September 2027, 10 Monate) 540 000 Euro; beides deckt die Kasse. Der skalierbare Vertrieb (Juni 2028, 19 Monate) braucht 1,1 Mio. Euro, es entsteht eine Lücke von 500 000 Euro. Sie bestimmt die Größe der nächsten Runde. Die Rechnung nimmt einen konstanten Burn an und ignoriert Einnahmen; mit wachsendem Umsatz fällt der Bedarf geringer aus, mit Neueinstellungen höher. Deshalb rechnet man Szenarien (Modul 07).

Typische Fehler: Fundraising zu spät beginnen, den Betrag nach „was Investoren üblicherweise geben“ statt nach Bedarf zu wählen, Meilensteine ohne messbare Kriterien zu definieren. Falsch: „Wir suchen eine Million.“ Richtig: „Wir suchen 1,5 Mio. Euro für 18 Monate Runway, bis wir 100 zahlende Kunden und 600 000 Euro ARR erreichen.“ Eine gute Roadmap kombiniert mehrere Quellen (Umsatz, Förderungen, Wandeldarlehen, Seed-Runde) und legt eine Reihenfolge fest, die Verwässerung begrenzt.

> **Merke**
>
> Die Funding Roadmap koppelt Kapitalbedarf an Meilensteine und rechnet den spätesten Fundraising-Start rückwärts aus der Runway. Betrag, Zweck und Zeitplan müssen zusammenpassen. Mehrere Finanzierungsquellen werden in sinnvoller Reihenfolge kombiniert.

> **Praxisbeispiel**
>
> Aktualisieren Sie die Roadmap mindestens vierteljährlich zusammen mit Forecast und Investor Reporting (Modul 07). Ändern sich Annahmen, ändert sich der spätestens nötige Starttermin, und das Team sollte das rechtzeitig sehen.

## Übungsaufgaben zu Modul 08

1.  **(leicht)** Nenne zwei Vorteile und zwei Nachteile von Bootstrapping gegenüber Risikokapital.

2.  **(leicht)** Ein Investor zahlt 500 000 Euro für 10 Prozent der Anteile. Wie hoch sind Post-Money- und Pre-Money-Bewertung?

3.  **(leicht)** Ein Gründer hat 4 800 Anteile mit vier Jahren Vesting und einem Jahr Cliff. Wie viele Anteile sind nach 18 Monaten erdient?

4.  **(mittel)** Ein Förderprojekt kostet 120 000 Euro, die Förderquote beträgt 40 Prozent bei einem Deckel von 60 000 Euro. Wie hoch sind Zuschuss und Eigenmittel?

5.  **(mittel)** Ein Gründer hält 60 Prozent. In der Seed-Runde werden 20 Prozent neue Anteile ausgegeben, in der Series A weitere 25 Prozent (jeweils bezogen auf die Anteile nach der Runde). Wie viel hält der Gründer danach?

6.  **(praktisch)** Schreibe ein Programm, das für eine Cap Table mit den Anteilen A = 6 000 000, B = 3 000 000 und Pool = 1 000 000 eine Runde mit 9 Mio. Euro Pre-Money und 3 Mio. Euro Investition rechnet und die Prozentanteile nach der Runde ausgibt.

7.  **(praktisch)** Schreibe eine Funktion, die den Erlös eines Investors mit 1x nicht teilnehmender Präferenz berechnet (investiert 1 Mio. Euro, Anteil 15 Prozent) und gib sie für Exit-Werte von 500 000, 3 Mio. und 10 Mio. Euro aus.

8.  **(schwer/praktisch)** Passe die Funding-Roadmap aus 8.9 an: Der Burn steigt auf 60 000 Euro. Wann reicht die Kasse bis, und wann muss das Fundraising spätestens starten?

## Lösungen zu den Übungsaufgaben Modul 08

**1.** Vorteile: Kontrolle und Anteile bleiben bei den Gründern; keine Renditeerwartung Dritter und kein Zwang zum schnellen Wachstum. Nachteile: Wachstum ist auf Einnahmen und eigene Mittel begrenzt; in schnellen Märkten kann das Tempo zu niedrig sein, und es fehlen Netzwerk und Erfahrung eines Investors.

**2.** Post-Money = 500 000 geteilt durch 0,10 = 5 000 000 Euro. Pre-Money = Post-Money minus Investition = 4 500 000 Euro.

**3.** Mit Cliff nach 12 Monaten und linearem Vesting über 48 Monate sind nach 18 Monaten 4 800 mal 18 geteilt durch 48 = 1 800 Anteile erdient.

**4.** Die Quote ergibt 0,40 mal 120 000 = 48 000 Euro, das liegt unter dem Deckel von 60 000 Euro, daher ist der Zuschuss 48 000 Euro. Die Eigenmittel betragen 72 000 Euro (zuzüglich Vorfinanzierung bis zur Auszahlung, vgl. 8.2).

**5.** Nach der Seed-Runde bleiben dem Gründer 0,60 mal 0,80 = 48 Prozent, nach der Series A 0,48 mal 0,75 = 36 Prozent.

**6.** Mögliche Lösung:

```python
anteile = {"A": 6_000_000, "B": 3_000_000, "Pool": 1_000_000}
pre_money, investition = 9_000_000, 3_000_000
preis = pre_money / sum(anteile.values())
anteile["Investor"] = round(investition / preis)
gesamt = sum(anteile.values())
for name, n in anteile.items():
    print(f"{name:9s} {n:11,d} {n / gesamt:7.2%}")
```

Der Preis je Anteil ist 9 Mio. geteilt durch 10 Mio. Anteile = 0,90 Euro; 3 Mio. Euro ergeben 3 333 333 neue Anteile. Nach der Runde halten A 45 Prozent, B 22,5 Prozent, der Pool 7,5 Prozent und der Investor 25 Prozent (3 Mio. geteilt durch 12 Mio. Post-Money).

**7.** Mögliche Lösung:

```python
def investor_erloes(exit_wert, investiert=1_000_000, anteil=0.15):
    return max(min(investiert, exit_wert), anteil * exit_wert)

for exit_wert in (500_000, 3_000_000, 10_000_000):
    print(f"Exit {exit_wert:>10,}: Investor {investor_erloes(exit_wert):>10,.0f}")
```

Bei 500 000 Euro Exit erhält der Investor alles, weil der Erlös unter der Investition liegt. Bei 3 Mio. Euro bekommt er seine 1 Mio. zurück (15 Prozent wären nur 450 000 Euro), bei 10 Mio. Euro sind 15 Prozent mit 1,5 Mio. Euro höher als die Rückzahlung.

**8.** Mögliche Lösung:

```python
from datetime import date

def monat_plus(d, n):
    m = d.month - 1 + n
    return date(d.year + m // 12, m % 12 + 1, 1)

heute = date(2026, 11, 1)
kasse, burn = 600_000, 60_000
runway = kasse // burn
leer = monat_plus(heute, runway)
start = monat_plus(leer, -(6 + 3))
print(f"Runway {runway} Monate, Kasse leer {leer:%m/%Y}, Fundraising-Start {start:%m/%Y}")
```

Bei 60 000 Euro Burn beträgt die Runway 10 Monate, das Geld ist im September 2027 aufgebraucht, und das Fundraising muss mit neun Monaten Vorlauf (sechs Monate Dauer plus drei Monate Puffer) im Dezember 2026 beginnen, also schon im nächsten Monat. Ein höherer Burn verkürzt die Runway nicht nur, er zieht den Fundraising-Start unmittelbar vor.
