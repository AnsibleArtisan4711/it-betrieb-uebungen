# Modul 03 - Geschäftsmodell, Pricing und Go-to-Market

> **Hinweis zu diesem Kapitel:** Das ist das Kapitel des Skripts „Unternehmensgründung“, aus der LaTeX-Quelle in Markdown umgewandelt (Text und Codeblöcke unverändert, farbige Boxen als Zitatblöcke mit fettem Titel, Tabellen als Markdown-Tabellen). Die Lerneinheiten sind wie in der Quelle nach Modul nummeriert (3.1 bis 3.9), danach folgen „Übungsaufgaben zu Modul 03“ (8 Aufgaben, mit Schwierigkeitsangabe) und „Lösungen zu den Übungsaufgaben Modul 03“. Rechtliche und steuerliche Aussagen sind keine Rechtsberatung. Was ich an den Beispielen geprüft habe, steht in der [README des Repositories](../README.md). Übersicht zum Modul: [README](README.md).

**Dauer:** 10 h laut Modulübersicht (Summe der Einzelwerte: 9 × 1,1 h = 9,9 h, gerundet)

**Priorität:** 1 (höchste)

| **Nr.** | **Lerneinheit**              | **Dauer (h)** |
|--------:|:-----------------------------|--------------:|
|     3.1 | Value Proposition            |           1,1 |
|     3.2 | Business Model Canvas        |           1,1 |
|     3.3 | Pricing Strategie            |           1,1 |
|     3.4 | Unit Economics               |           1,1 |
|     3.5 | Go-to-Market Motion          |           1,1 |
|     3.6 | Partner und Channels         |           1,1 |
|     3.7 | Positionierung und Messaging |           1,1 |
|     3.8 | Sales Material Grundlagen    |           1,1 |
|     3.9 | GTM Experimente              |           1,1 |
|         | **Summe**                    |       **9,9** |

Ein Problem, das gelöst werden kann (Modul 01), und eine Firma, die existiert (Modul 02), machen noch kein Geschäft. Dieses Modul beantwortet drei Fragen: Was genau bekommt der Kunde, und warum ist das für ihn mehr wert, als es kostet (Value Proposition und Geschäftsmodell)? Wie viel verlangen wir, und trägt sich das wirtschaftlich (Pricing und Unit Economics)? Und wie kommt das Produkt zum Kunden (Go-to-Market)? Alle Rechenbeispiele sind kleine Python-Programme ohne Zusatzpakete; die Zahlen sind erfundene Beispielwerte.

## 3.1 Value Proposition

Die *Value Proposition* (Nutzenversprechen) beantwortet aus Kundensicht die Frage: „Warum sollte ich ausgerechnet das kaufen?“ Sie ist kein Slogan, sondern eine belegbare Aussage über den Nutzen: Für wen löst das Produkt welches Problem, womit, und was ist besser als bei den Alternativen? Ein bewährtes Satzmuster lautet: „Für \[Zielgruppe\], die \[Problem\] haben, ist \[Produkt\] ein \[Kategorie\], das \[Hauptnutzen\] bietet. Anders als \[Alternative\] \[Unterschied\].“ Das Muster zwingt dazu, Zielgruppe, Nutzen und Unterschied in einem Atemzug zu benennen.

Nutzen entsteht aus Sicht des Kunden an drei Stellen. Das Produkt kann einen *Schmerz lindern* (Zeitverlust, Fehler, Kosten, Risiken), einen *Gewinn schaffen* (mehr Umsatz, bessere Qualität, mehr Kundenzufriedenheit) oder eine *Aufgabe erledigen* (englisch *Job to be done*), die der Kunde sonst selbst hätte. Der Kern des Beweises sind Zahlen und Zitate aus Kundengesprächen (Modul 01): „Spart pro Angebot 20 Minuten“ ist belegbar, „revolutionär einfach“ nicht. Wichtig ist auch die Unterscheidung von *Merkmal* (Feature: „Vorlagenbibliothek“), *Vorteil* (was es tut: „Angebote entstehen aus Vorlagen“) und *Nutzen* (was es bringt: „Sie sparen pro Woche 5 Stunden“). Überzeugt wird mit dem Nutzen.

Das folgende Programm hält ein Nutzenversprechen als Datenstruktur fest und prüft, ob jede Aussage einen Beleg hat. Es kennzeichnet unbelegte Behauptungen als Annahme und zählt den Anteil der belegten Aussagen.

```python
vp = {
    "zielgruppe": "Elektro- und Sanitaerbetriebe mit 3-15 Beschaeftigten",
    "problem": "Angebote kosten 5 Stunden pro Woche",
    "aussagen": [
        {"text": "Angebot in 10 statt 30 Minuten", "beleg": "Prototyp-Test mit 6 Betrieben"},
        {"text": "Weniger Fehler bei Material",    "beleg": ""},
        {"text": "Rechnung direkt aus Angebot",    "beleg": "Interviews: 9 von 15 wuenschen das"},
    ],
}
belegt = [a for a in vp["aussagen"] if a["beleg"]]
print(f"Belegt: {len(belegt)} von {len(vp['aussagen'])}")
for a in vp["aussagen"]:
    marke = "BELEGT " if a["beleg"] else "ANNAHME"
    print(marke, "-", a["text"])
```

Die Datenstruktur trennt Zielgruppe, Problem und eine Liste von Aussagen mit Beleg. Die Listenbildung `belegt` filtert alle Aussagen mit nichtleerem Beleg (ein leerer Text gilt in Python als „falsch“). Die Ausgabe zeigt „Belegt: 2 von 3“ und markiert die zweite Aussage als Annahme. Das hat eine praktische Folge: Im Marketingtext darf die unbelegte Behauptung erst stehen, wenn ein Test sie stützt.

Typische Fehler: Eigenschaften statt Nutzen verkaufen, Superlative ohne Beleg („die beste Lösung“) und ein Versprechen für alle. Falsch: „Unsere KI-gestützte Plattform optimiert Prozesse.“ Richtig: „Handwerksbetriebe erstellen Angebote in 10 statt 30 Minuten, ohne neue Software zu lernen.“ Ein weiterer Fehler ist, sich nur auf technische Überlegenheit zu verlassen. Kunden kaufen Ergebnisse, nicht Architekturen.

> **Merke**
>
> Eine Value Proposition benennt Zielgruppe, Problem, Nutzen und Unterschied und ist belegbar. Merkmal, Vorteil und Nutzen sind drei verschiedene Dinge; verkauft wird der Nutzen. Unbelegte Aussagen sind Annahmen, die getestet werden müssen.

> **Praxisbeispiel**
>
> Das Nutzenversprechen steht an Landing Page, Pitch Deck, Verkaufsgespräch und Förderantrag in jeweils gleicher Substanz, aber anderen Worten. Teams testen Varianten mit Kunden („Welche Formulierung beschreibt Ihr Problem am besten?“).

## 3.2 Business Model Canvas

Ein *Geschäftsmodell* beschreibt, wie ein Unternehmen Wert schafft, liefert und davon lebt. Der *Business Model Canvas* (nach Alexander Osterwalder) bringt das auf einer Seite in neun Bausteinen unter: *Kundensegmente*, *Wertangebot*, *Kanäle*, *Kundenbeziehungen*, *Einnahmeströme*, *Schlüsselressourcen*, *Schlüsselaktivitäten*, *Schlüsselpartner* und *Kostenstruktur*. Die rechte Seite (Kunde, Wert, Kanäle, Beziehung, Einnahmen) beschreibt, was der Markt sieht; die linke Seite (Ressourcen, Aktivitäten, Partner, Kosten) die interne Machbarkeit. Das Entscheidende ist der Zusammenhang: Jeder Baustein muss zu den anderen passen. Wer ein Premium-Wertangebot für Großkunden verspricht, aber nur Selbstbedienung als Kanal plant, hat einen Widerspruch im Modell.

Der Canvas ist ein Werkzeug, um *kritische Annahmen sichtbar zu machen* (Modul 01): Jeder Baustein enthält Vermutungen, zum Beispiel „Kunden finden uns über Suchmaschinen“ oder „Der Cloud-Anbieter bleibt günstig“. Üblich ist, Annahmen auf Haftnotizen zu schreiben und nach Risiko zu markieren. Typische Erlösmodelle in Tech sind *Abonnement* (wiederkehrende Gebühr), *nutzungsabhängige Abrechnung*, *Transaktionsgebühren*, *Lizenz*, *Werbung* und *Dienstleistung* (einmalig oder projektbasiert). Sie unterscheiden sich stark in Planbarkeit und Skalierbarkeit.

Das Beispiel legt einen Canvas als Datenstruktur an und liefert zwei Auswertungen: Es zeigt, welche Bausteine noch leer sind, und es listet alle Annahmen mit hohem Risiko.

```python
canvas = {
    "Kundensegmente":    [("Elektro/Sanitaer 3-15 MA", "niedrig")],
    "Wertangebot":       [("Angebot in 10 Min", "mittel")],
    "Kanaele":           [("Suchmaschine + Verband", "hoch")],
    "Kundenbeziehungen": [],
    "Einnahmestroeme":   [("Abo 49 EUR/Monat", "hoch")],
    "Schluesselressourcen": [("Material-Datenbank", "mittel")],
    "Schluesselaktivitaeten": [("Produktentwicklung", "niedrig")],
    "Schluesselpartner": [("Grosshaendler-Schnittstelle", "hoch")],
    "Kostenstruktur":    [("Cloud + 2 Entwickler", "niedrig")],
}
leer = [b for b, inhalt in canvas.items() if not inhalt]
print("Leere Bausteine:", leer)
for baustein, annahmen in canvas.items():
    for text, risiko in annahmen:
        if risiko == "hoch":
            print(f"Hohes Risiko in {baustein}: {text}")
```

Das Wörterbuch bildet jeden Baustein auf eine Liste von Annahmen mit Risikostufe ab. Die erste Auswertung findet leere Bausteine; hier fehlen die Kundenbeziehungen. Die zweite durchläuft alle Annahmen und gibt die mit hohem Risiko aus: Kanäle, Einnahmeströme und die Schnittstelle des Großhändlers. Damit weiß das Team, wo es zuerst testen muss. Auffällig ist, dass genau die Ertragsseite die riskantesten Annahmen enthält, was bei jungen Firmen typisch ist.

Typische Fehler: Den Canvas einmal ausfüllen und ablegen, ihn mit einer Beschreibung statt Hypothesen füllen und mehrere Kundensegmente vermischen. Falsch: ein einziger Canvas für „alle Kunden“. Richtig: für jedes Segment ein eigener Canvas, weil Wertangebot, Kanäle und Preis sich unterscheiden. Ein weiterer Fehler ist, die Kostenstruktur zu optimistisch zu schätzen; Support, Compliance und Vertrieb werden oft vergessen.

> **Merke**
>
> Der Canvas zeigt in neun Bausteinen, wie Wert geschaffen und verdient wird. Er ist eine Sammlung testbarer Annahmen, kein fertiger Plan. Pro Kundensegment gibt es ein eigenes Modell.

> **Praxisbeispiel**
>
> Im Pitch Deck und im Fördertext taucht der Canvas in Form von Geschäftsmodell-, Markt- und Kostenfolien wieder auf. Er wird bei jedem größeren Strategiewechsel neu geprüft, nicht nur zu Beginn.

## 3.3 Pricing Strategie

Der Preis ist der stärkste Hebel auf den Gewinn und die am häufigsten falsch gesetzte Größe junger Firmen. Drei Grundansätze sind zu unterscheiden. Beim *Cost-plus-Pricing* werden die Kosten ermittelt und ein Aufschlag addiert; das ist einfach, ignoriert aber, was der Kunde bereit ist zu zahlen. Beim *Value-based Pricing* orientiert sich der Preis am Wert, den der Kunde erhält: Spart ein Produkt 10.000 EUR im Jahr, ist ein Preis von 1.000 EUR plausibel, auch wenn die Kosten bei 50 EUR liegen. Beim *Usage-based Pricing* hängt der Preis von der Nutzung ab (pro Nutzer, pro Rechnung, pro Datenmenge); das ist fair und skalierbar, macht aber Einnahmen schwerer planbar.

Die Zahlungsbereitschaft (englisch *Willingness to Pay*, WTP) wird nicht erfragt, indem man „Was würden Sie zahlen?“ stellt, sondern durch Experimente mit realem Verhalten: Preisvergleiche in Interviews, Vorbestellungen zu verschiedenen Preisen, Landing Pages mit unterschiedlichen Preisen. Ein einfaches Modell ist die *Nachfragekurve*: Für jeden Preis zählt man, wie viele Interessenten mindestens so viel zahlen würden, und multipliziert mit dem Preis. Das Maximum ist der umsatzoptimale Preis; der gewinnoptimale Preis berücksichtigt außerdem die Kosten.

> **Ergänzung aus der Nachrecherche**
>
> Preismodelle für Cloud-Software stehen im EU-Raum unter neuem Rechtsrahmen: Der *Data Act* (Verordnung über harmonisierte Vorschriften für den fairen Datenzugang) ist teilweise seit 12. September 2025 anwendbar. Anbieter von SaaS, PaaS und IaaS müssen Kunden einen Anbieterwechsel ermöglichen. Die Kündigungsfrist für den Wechsel darf höchstens zwei Monate betragen, und spätestens ab 12. Jänner 2027 dürfen Wechselentgelte nicht mehr verlangt werden. Vertragsstrafen bei vorzeitiger Kündigung können unter Bedingungen zulässig bleiben und hängen vom nationalen Recht ab (Quelle Q5; keine Rechtsberatung). Für das Pricing heißt das: Lock-in durch Ausstiegsgebühren ist kein tragfähiger Burggraben mehr.

Das Beispiel wertet eine Zahlungsbereitschaftsumfrage mit zwölf Antworten aus. Das Programm berechnet für jeden Preis den Umsatz und nennt den besten. Anschließend rechnet es mit Kosten pro Kunde den Gewinn je Preis.

```python
wtp = [19, 29, 29, 39, 39, 49, 49, 49, 59, 79, 79, 99]   # EUR pro Monat
kosten_pro_kunde = 12                                      # variable Kosten pro Monat

ergebnis = []
for preis in sorted(set(wtp)):
    kunden = sum(1 for w in wtp if w >= preis)
    umsatz = preis * kunden
    gewinn = (preis - kosten_pro_kunde) * kunden
    ergebnis.append((preis, kunden, umsatz, gewinn))
    print(f"Preis {preis:3d}: {kunden:2d} Kunden, Umsatz {umsatz:4d}, Gewinn {gewinn:4d}")

print("Umsatzoptimal:", max(ergebnis, key=lambda r: r[2])[0])
print("Gewinnoptimal:", max(ergebnis, key=lambda r: r[3])[0])
```

Für jeden vorkommenden Preis zählt die Summe, wie viele Befragte mindestens so viel zahlen würden. Der Umsatz ist Preis mal Kunden, der Gewinn zieht die variablen Kosten ab. Das Maximum wird mit `max` und einem Schlüssel gefunden. Die Ausgabe zeigt: Umsatzoptimal wäre 39 EUR (351), gewinnoptimal 49 EUR (259 gegenüber 243 bei 39 EUR). Der Unterschied entsteht, weil bei höheren Preisen weniger Kunden bedient werden müssen, was die variablen Kosten senkt. Das Beispiel hat allerdings nur zwölf Antworten und eine Selbstauskunft; als Entscheidung taugt es erst nach einem Test mit echten Vorbestellungen.

Typische Fehler: Preise zu niedrig ansetzen, um Kunden zu gewinnen (und später nicht mehr erhöhen können), Rabatte ohne Regeln, alle Kunden zum gleichen Preis und zu viele Tarife zu Beginn. Falsch: „Wir sind neu, also verlangen wir 9 EUR.“ Richtig: Mit zwei bis drei Paketen starten, den höchsten Preis testen und Rabatte nur gegen Gegenleistung (längere Laufzeit, Referenz) gewähren. Auch wichtig: Preis ist ein Signal. Ein zu niedriger Preis kann Qualität in Frage stellen.

> **Merke**
>
> Preis folgt dem Kundenwert, nicht nur den Kosten. Zahlungsbereitschaft wird über Verhalten getestet, nicht über Meinungen. Cost-plus ist die Untergrenze, Value-based der Maßstab, Usage-based eine Option für nutzungsabhängige Produkte.

> **Praxisbeispiel**
>
> Typische Tarifstufen im B2B-SaaS sind drei Pakete (Starter, Professional, Enterprise) mit Preisanker. Preisseiten werden regelmäßig getestet, und Bestandskunden bekommen Preisänderungen langfristig angekündigt (siehe Modul 09, Pricing und Packaging im Markt).

## 3.4 Unit Economics

*Unit Economics* untersuchen, ob sich ein einzelner Kunde (die „Einheit“) wirtschaftlich lohnt. Ohne positive Unit Economics führt Wachstum zu größeren Verlusten, nicht zu Gewinn. Die Kernbegriffe: Die *Kundenakquisitionskosten* (englisch *Customer Acquisition Cost*, CAC) sind alle Vertriebs- und Marketingkosten, geteilt durch die Zahl der gewonnenen Neukunden in einem Zeitraum. Der *durchschnittliche Umsatz pro Kunde* (*ARPA*) ist der monatliche Umsatz je Kunde. Die *Bruttomarge* (englisch *Gross Margin*) ist der Anteil vom Umsatz, der nach den direkten Kosten (Hosting, Support, Zahlungsgebühren) übrig bleibt. Der *Churn* ist der Anteil der Kunden, die pro Monat kündigen. Der *Customer Lifetime Value* (LTV) ist der gesamte Bruttogewinn, den ein Kunde über seine Lebensdauer bringt.

Aus diesen Größen folgen die entscheidenden Kennzahlen. Die erwartete Lebensdauer beträgt 1/Churn Monate; bei 3 % Churn sind es rund 33 Monate. Der LTV ist ARPA mal Bruttomarge mal Lebensdauer. Der *Payback* ist die Zeit, nach der der Bruttogewinn eines Kunden die Akquisitionskosten gedeckt hat: CAC geteilt durch (ARPA mal Bruttomarge). Als Faustregel gilt im SaaS ein Verhältnis LTV/CAC von mindestens 3 und ein Payback unter 12 Monaten; das sind Richtwerte, keine Naturgesetze, und sie hängen stark von Branche und Finanzierung ab.

```python
def unit_economics(arpa, bruttomarge, churn, cac):
    lebensdauer = 1 / churn
    ltv = arpa * bruttomarge * lebensdauer
    payback = cac / (arpa * bruttomarge)
    return {"Lebensdauer (Monate)": round(lebensdauer, 1),
            "LTV": round(ltv, 2),
            "LTV/CAC": round(ltv / cac, 2),
            "Payback (Monate)": round(payback, 1)}

basis = unit_economics(arpa=49, bruttomarge=0.80, churn=0.03, cac=400)
print(basis)
print(unit_economics(49, 0.80, 0.06, 400))     # doppelter Churn
print(unit_economics(49, 0.80, 0.03, 800))     # doppelter CAC
```

Die Funktion berechnet aus vier Eingaben die abgeleiteten Kennzahlen und gibt sie als Wörterbuch zurück. Im Basisfall lauten die Ergebnisse: Lebensdauer 33,3 Monate, LTV 1306,67, LTV/CAC 3,27 und Payback 10,2 Monate. Der doppelte Churn halbiert die Lebensdauer und senkt LTV/CAC auf 1,63, ein kritischer Wert; der doppelte CAC bewirkt dasselbe Verhältnis und verlängert den Payback auf 20,4 Monate. Man erkennt, dass Churn und CAC gleich stark wirken. Deshalb ist Kundenbindung (Modul 09) genauso wichtig wie Neukundengewinnung.

Typische Fehler: Den CAC ohne Gehälter des Vertriebs rechnen, Churn aus zu wenig Daten schätzen, den LTV mit Umsatz statt Bruttomarge berechnen und Gratiskunden mitzählen. Falsch: „Ein Kunde bringt 49 EUR pro Monat, und wir zahlen 400 EUR, also nach 8 Monaten im Plus.“ Richtig: Mit Bruttomarge gerechnet beträgt der Payback 10,2 Monate; Support, Zahlungsgebühren und Hosting sind darin schon abgezogen. Auch gefährlich ist die Mittelwertfalle: Wenige große Kunden können das Bild verzerren.

> **Merke**
>
> Unit Economics prüfen, ob ein einzelner Kunde Gewinn bringt. Wichtige Größen sind CAC, ARPA, Bruttomarge, Churn, LTV und Payback. Richtwerte wie LTV/CAC über 3 sind Orientierung, keine Garantie.

> **Praxisbeispiel**
>
> Investoren fragen früh nach CAC, Payback und Churn. Ein Team, das diese Zahlen pro Kanal und pro Segment kennt, kann Budget gezielt verschieben, zum Beispiel von einem teuren Kanal in einen mit kurzem Payback. Vertiefung bei SaaS-Kennzahlen in Modul 07.

## 3.5 Go-to-Market Motion

Die *Go-to-Market-Strategie* (GTM) beschreibt, wie ein Produkt zu seinen Kunden kommt: wer angesprochen wird, über welche Kanäle, mit welcher Botschaft und welchem Preis. Eine *Motion* ist das wiederholbare Grundmuster, mit dem Kunden gewonnen werden. Drei Haupttypen sind verbreitet. Bei der *Product-led Motion* überzeugt das Produkt selbst: Nutzer probieren es kostenlos oder günstig aus und zahlen, wenn sie Nutzen erleben (Selbstbedienung, Freemium, Testversion). Bei der *Sales-led Motion* gewinnen Verkaufsmitarbeitende die Kunden in Gesprächen, Demos und Verhandlungen. Bei der *Partner-led Motion* verkaufen Dritte (Integratoren, Reseller, Marktplätze) das Produkt weiter.

Welche Motion passt, hängt vor allem vom *Jahreswert pro Kunde* (englisch *Annual Contract Value*, ACV) und von der Komplexität der Kaufentscheidung ab. Bei niedrigem ACV lohnt sich kein persönlicher Vertrieb, weil die Personalkosten höher wären als der Umsatz. Bei hohem ACV mit mehreren Entscheidern ist Selbstbedienung unrealistisch. Oft kombiniert man: Das Produkt gewinnt kleine Kunden von selbst, und der Vertrieb übernimmt Kunden, die wachsen (*Product-led Sales*). Entscheidend ist, die Motion zum ICP aus Modul 01 passend zu wählen.

Das Beispiel ordnet über einen Entscheidungsansatz eine Motion zu. Die Schwellenwerte sind Annahmen, die in der Praxis variieren.

```python
def motion(acv, entscheider, self_service_moeglich):
    if acv < 1500 and self_service_moeglich and entscheider <= 1:
        return "product-led (Selbstbedienung)"
    if acv < 15000:
        return "inside sales + Produkt-Testphase"
    if acv < 100000:
        return "sales-led (Demo, Angebot, Pilot)"
    return "enterprise sales + Partner/Integrator"

for acv, ent, ss in [(588, 1, True), (4800, 2, True), (36000, 4, False), (250000, 8, False)]:
    print(f"ACV {acv:7d}, Entscheider {ent}: {motion(acv, ent, ss)}")

cac_pro_kunde = 3000      # angenommene Vertriebskosten pro Abschluss
for acv in (588, 4800, 36000):
    print(f"ACV {acv}: CAC/ACV = {cac_pro_kunde/acv:.2f}")
```

Die Funktion prüft Schwellen nacheinander; die erste zutreffende Bedingung entscheidet. Der zweite Teil setzt einen angenommenen CAC von 3.000 EUR ins Verhältnis zum Jahresumsatz. Bei 588 EUR ACV ist das Verhältnis 5,10, also würde ein persönlicher Verkauf mehr kosten, als der Kunde in einem Jahr zahlt; bei 36.000 EUR ist es 0,08, ein sehr guter Wert. Die Rechnung begründet, warum ein 49-EUR-Abo nicht per Telefonvertrieb verkauft wird und ein 36.000-EUR-Vertrag nicht über eine reine Selbstbedienungsseite.

Typische Fehler: Eine Motion wählen, die zum Preis nicht passt; mehrere Motions gleichzeitig starten und keine richtig machen; Kanäle ohne Bezug zur Zielgruppe. Falsch: „Wir stellen drei Verkäufer ein und verkaufen das Abo für 9 EUR.“ Richtig: Zuerst eine Motion zum Laufen bringen (wiederholbar, messbar), dann die zweite ergänzen. Wiederholbarkeit heißt: Ein neuer Verkäufer kann nach einer Einarbeitung ähnliche Ergebnisse erzielen.

> **Merke**
>
> Product-led, sales-led und partner-led sind Grundmuster. Die Wahl richtet sich nach ACV, Zahl der Entscheider und Komplexität. Erst eine Motion wiederholbar machen, dann ergänzen.

> **Praxisbeispiel**
>
> Viele B2B-Teams beginnen mit persönlichen Gesprächen der Gründenden (founder-led sales), um Einwände zu lernen, und bauen erst danach Selbstbedienung oder einen Vertrieb auf. Das hilft, Preis, ICP und Botschaft zu klären.

## 3.6 Partner und Channels

Ein *Channel* (Vertriebskanal) ist der Weg, über den ein Produkt zum Kunden gelangt. Partner-Channels sind Reseller (verkaufen unter eigenem Vertrag und mit Marge), Systemintegratoren (setzen Lösungen beim Kunden um und empfehlen Produkte), Technologiepartner (verbinden Produkte per Schnittstelle), Marktplätze von Cloud-Anbietern oder Branchenplattformen und Empfehlungsprogramme (Provision für Vermittlung). Partner bringen Zugang, Vertrauen und Skalierung, kosten aber Marge und Kontrolle. Sie lohnen sich dort, wo der Partner bereits die Beziehung zum Kunden hat und das Produkt in sein Angebot passt.

Die Zusammenarbeit braucht klare Regeln. Wer hat die Kundenbeziehung? Wer leistet Support? Wie wird die Marge geteilt? Wie verhindert man *Channel-Konflikte*, also Streit, wenn der Hersteller selbst und der Partner um denselben Kunden werben? Üblich sind Deal Registration (der Partner meldet einen Interessenten an und erhält Schutz für eine bestimmte Zeit), klare Gebietszuordnungen und ein einheitlicher Preislistenrahmen, damit Partner nicht unterboten werden.

Das Beispiel vergleicht den direkten Verkauf mit dem Verkauf über einen Reseller anhand der Gewinnbeiträge je Deal. Beim Reseller sinkt der Preis um die Marge, dafür entfallen die eigenen Akquisitionskosten. Alle Zahlen sind Annahmen.

```python
def deal(listenpreis, marge_partner, cac, kosten_leistung):
    erloes = listenpreis * (1 - marge_partner)
    return round(erloes - cac - kosten_leistung, 2)

direkt  = deal(listenpreis=6000, marge_partner=0.00, cac=2400, kosten_leistung=900)
reseller = deal(listenpreis=6000, marge_partner=0.25, cac=300,  kosten_leistung=900)
print("Gewinn direkt  :", direkt)
print("Gewinn Reseller:", reseller)

# Wie viele Deals braucht ein Verkaeufer fuer 100000 EUR Gewinn?
for name, g in (("direkt", direkt), ("Reseller", reseller)):
    print(name, "->", round(100000 / g, 1), "Deals")
```

Die Funktion `deal` berechnet den Erlös nach Abzug der Partnermarge und zieht Akquisitionskosten und Leistungskosten ab. Direkt bleiben 2.700 EUR pro Deal, über den Reseller 3.300 EUR: höhere Marge für den Partner, aber deutlich geringere eigene Verkaufskosten. Der Unterschied ist die Hebelwirkung; ein Reseller kann außerdem Kunden erreichen, die der Hersteller selbst nie sprechen würde. Zugleich zeigt der Vergleich eine Grenze: Steigt die Marge auf 40 %, sinkt der Gewinn je Deal auf 2.400 EUR, weniger als im Direktverkauf (2.700 EUR).

Typische Fehler: Einen Partner suchen, bevor das Produkt in direkten Verkäufen funktioniert; Partnern kein Material und keine Schulung geben; die Marge zu niedrig ansetzen, sodass es sich für den Partner nicht lohnt. Falsch: „Reseller verkaufen es schon irgendwie.“ Richtig: Partner-Enablement (Schulung, Demo-Umgebung, Verkaufsargumente, Ansprechperson) und klare Ziele pro Partner. Partner stellen sich außerdem auf Abhängigkeiten ein: Ein einzelner Partner mit 60 % Umsatzanteil ist ein Risiko.

> **Merke**
>
> Partner erhöhen Reichweite und Vertrauen, kosten aber Marge und Kontrolle. Regeln für Kundenbeziehung, Support, Marge und Konflikte werden vorab schriftlich festgelegt. Erst das Produkt im Direktverkauf validieren, dann Partner einbinden.

> **Praxisbeispiel**
>
> In Europa sind Cloud-Marktplätze, Branchenverbände und lokale Systemhäuser häufige Partner. Verträge enthalten Regeln zu Datenschutz (Auftragsverarbeitung, Modul 11) und zu Provisionen. Vertiefung in Modul 09 (Partnervertrieb) und Modul 12 (strategische Partnerschaften).

## 3.7 Positionierung und Messaging

*Positionierung* bestimmt, welchen Platz das Produkt im Kopf der Zielgruppe einnimmt: in welcher *Kategorie* (Schublade) es steht, wofür es steht und wogegen es sich abgrenzt. Eine gute Positionierung ist so klar, dass Kunden das Produkt in einem Satz weitererzählen können. Die Wahl der Kategorie ist dabei strategisch: Wer sich in eine bekannte Kategorie stellt („Angebotssoftware für das Handwerk“), erklärt wenig und konkurriert direkt. Wer eine neue Kategorie schafft, muss das Problem erst bekannt machen, was Geld und Zeit kostet.

*Messaging* ist die Übersetzung der Positionierung in konkrete Aussagen: Claim (Leitsatz), Nutzenargumente und Beweise. Der wichtigste Schritt ist, *technische Features in Business Value zu übersetzen*. Der Kunde interessiert sich nicht für „Microservices“ oder „Vektordatenbank“, sondern dafür, was daraus für ihn folgt: Schnelligkeit, Sicherheit, Kosteneinsparung, weniger Aufwand. Ein Test dafür ist die „Na und?“-Frage: Auf jedes Merkmal fragt man „Na und?“, bis eine Aussage übrig bleibt, die der Kunde als Vorteil empfindet.

Das folgende Programm unterstützt diese Übersetzung. Es prüft Texte auf Fachjargon, der für Entscheider schlecht verständlich ist, und listet Alternativvorschläge. Die Wortliste ist ein kleines Beispiel und lässt sich anpassen.

```python
jargon = {
    "skalierbar": "waechst mit Ihrem Betrieb, ohne dass Sie etwas umstellen",
    "ki-gestuetzt": "erledigt Routinearbeiten automatisch",
    "cloud-native": "laeuft im Browser, nichts zu installieren",
    "end-to-end": "vom ersten Angebot bis zur bezahlten Rechnung",
}
texte = [
    "Unsere skalierbare, KI-gestuetzte Plattform ist cloud-native.",
    "Vom Angebot zur bezahlten Rechnung in einem Programm, im Browser.",
]
for t in texte:
    treffer = [w for w in jargon if w in t.lower()]
    print("JARGON" if treffer else "OK    ", "-", t)
    for w in treffer:
        print("    ersetze", w, "durch:", jargon[w])
```

Die Schleife prüft für jeden Text, ob eines der Schlagworte darin vorkommt (nach Umwandlung in Kleinbuchstaben). Treffer werden als Jargon markiert, und für jedes Wort steht eine kundennahe Formulierung bereit. Der erste Text liefert drei Treffer, der zweite keinen. Das Programm ersetzt keine Textarbeit, hilft aber, Muster in eigenen Texten zu erkennen. Wichtig ist, dass die Ersatzformulierungen aus der Sprache der Kunden stammen, also aus den Interviews (Modul 01).

Typische Fehler: Eine Botschaft, die für alle gleich klingt („einfach, schnell, sicher“), Behauptungen ohne Beweis und Insider-Sprache. Falsch: „Die intelligente Plattform für moderne Unternehmen.“ Richtig: „Angebote für Elektrobetriebe in 10 Minuten statt 30, mit Materialpreisen aus dem Großhandel.“ Weitere Stolperfalle: Unterschiedliche Botschaften auf Website, Pitch und Vertrieb verwirren. Ein gemeinsames Messaging-Dokument mit Claim, drei Nutzenargumenten und Beweisen verhindert das.

> **Merke**
>
> Positionierung wählt Kategorie und Abgrenzung, Messaging übersetzt sie in Aussagen. Features werden mit der „Na und?“-Frage in Business Value verwandelt. Eine Botschaft, ein Satz, ein Beweis pro Argument.

> **Praxisbeispiel**
>
> Das Messaging erscheint auf Website, E-Mail-Vorlagen, Verkaufsfolien, Messeständen und in Presseinformationen. Für technische Produkte gibt es oft zwei Fassungen: eine für Entscheider (Nutzen, Risiko, Kosten) und eine für Fachleute (Architektur, Sicherheit).

## 3.8 Sales Material Grundlagen

Gutes Verkaufsmaterial erspart Erklärungen und beschleunigt Entscheidungen. Drei Bausteine genügen am Anfang. Das *One-Pager* ist ein einseitiges Dokument mit Zielgruppe, Problem, Lösung, drei Nutzenargumenten, einem Beleg (Zahl oder Zitat) und einem klaren nächsten Schritt. Das *Demo-Skript* ist der Ablauf einer Produktvorführung: Es beginnt nicht mit dem Funktionsumfang, sondern mit dem Problem des Kunden und zeigt den kürzesten Weg zum Ergebnis („Sie haben mir vorhin erzählt, dass …“). Die *ROI-Argumentation* (ROI = Return on Investment) rechnet vor, was die Investition einbringt. Entscheider müssen intern rechtfertigen, warum sie Geld ausgeben; eine nachvollziehbare Rechnung hilft ihnen dabei.

Zum Verkaufsmaterial gehört die Dokumentation von *Einwänden*: Preis, Wechselaufwand, Datenschutz, fehlende Funktionen, „wir brauchen das nicht“. Jeder Einwand wird mit der besten Antwort, einem Beleg und gegebenenfalls einer Vorlage (zum Beispiel Datenschutzinformation) hinterlegt. Das Team lernt dadurch voneinander, und neue Mitarbeitende werden schneller produktiv.

Das Beispiel rechnet einen ROI-Fall vorsichtig durch. Es nimmt nur einen Teil der möglichen Zeitersparnis an (Realisierungsgrad), damit die Argumentation glaubwürdig bleibt.

```python
def roi(stunden_pro_woche, stundensatz, realisierung, preis_pro_monat):
    nutzen_jahr = stunden_pro_woche * stundensatz * 52 * realisierung
    kosten_jahr = preis_pro_monat * 12
    return {
        "Nutzen/Jahr": round(nutzen_jahr),
        "Kosten/Jahr": kosten_jahr,
        "ROI %": round(100 * (nutzen_jahr - kosten_jahr) / kosten_jahr),
        "Payback (Wochen)": round(kosten_jahr / (nutzen_jahr / 52), 1),
    }

print(roi(stunden_pro_woche=5, stundensatz=45, realisierung=0.5, preis_pro_monat=49))
print(roi(stunden_pro_woche=1, stundensatz=45, realisierung=0.5, preis_pro_monat=49))
```

Die Funktion multipliziert Zeitersparnis, Stundensatz, 52 Wochen und den Realisierungsgrad zum jährlichen Nutzen, stellt ihn den Jahreskosten gegenüber und berechnet ROI in Prozent sowie den Payback in Wochen. Im ersten Fall ergeben sich ein Nutzen von 5.850 EUR bei 588 EUR Kosten, ein ROI von 895 Prozent und ein Payback von 5,2 Wochen. Der zweite Fall mit nur einer Stunde pro Woche zeigt die Grenze: Nutzen 1.170 EUR, ROI 99 Prozent, Payback 26,1 Wochen; das Produkt lohnt sich also noch, aber nicht mehr beeindruckend. Eine solche Sensitivitätsrechnung gehört in jedes Gespräch, weil Kunden eigene Zahlen einsetzen wollen.

Typische Fehler: Zu viel Text, interne Fachsprache, übertriebene ROI-Versprechen (Realisierung 100 %) und Material, das nach dem Produkt-Update veraltet ist. Falsch: Ein 30-seitiges Produkthandbuch als Verkaufsunterlage. Richtig: Ein One-Pager, ein Kundenzitat und ein Rechenblatt. Zu den Einwänden: Nie streiten, sondern verstehen. Hinter „zu teuer“ steht oft „Ich sehe den Nutzen nicht“.

> **Merke**
>
> One-Pager, Demo-Skript und ROI-Rechnung genügen zu Beginn. Demos beginnen mit dem Problem des Kunden, ROI-Rechnungen sind vorsichtig und nachvollziehbar, Einwände werden gesammelt und beantwortet.

> **Praxisbeispiel**
>
> Verkaufsmaterial entsteht aus echten Gesprächen. Nach jeder Demo notiert das Team Einwände und Fragen; nach zehn Gesprächen ist daraus eine Einwandliste mit bewährten Antworten entstanden. Spätere Vertriebsprozesse (Modul 09) bauen darauf auf.

## 3.9 GTM Experimente

Ein Go-to-Market-Plan ist zuerst eine Menge von Hypothesen. Welcher Kanal bringt die günstigsten Kunden? Welche Botschaft führt zu mehr Anmeldungen? Welche Demo-Form überzeugt? Diese Fragen beantwortet man mit *Experimenten*: Kampagnen, Landing Pages und Demos, die als Tests dienen. Jedes Experiment hat eine Hypothese, eine Kennzahl, eine Stichprobengröße und ein Erfolgskriterium (siehe Validierungs-Roadmap in Modul 01). Wichtig ist, nur eine Variable gleichzeitig zu ändern. Wer Botschaft, Bild und Preis auf einmal wechselt, weiß hinterher nicht, was gewirkt hat.

Ob ein beobachteter Unterschied ein echter Effekt oder Zufall ist, entscheidet die Statistik. Bei Anmeldequoten verwendet man häufig den Zwei-Stichproben-Test für Anteile (z-Test). Er berechnet aus den Anteilen und Fallzahlen, wie wahrscheinlich ein solcher Unterschied bei reinem Zufall wäre (der *p-Wert*). Ein kleiner p-Wert (üblich unter 0,05) spricht gegen den Zufall. Wichtig: Der Test darf nicht laufend zwischendurch „angeschaut“ werden, bis ein gewünschtes Ergebnis erscheint; die Stichprobengröße wird vorher festgelegt.

```python
from math import sqrt, erf

def z_test(erfolge_a, n_a, erfolge_b, n_b):
    p_a, p_b = erfolge_a / n_a, erfolge_b / n_b
    p = (erfolge_a + erfolge_b) / (n_a + n_b)
    se = sqrt(p * (1 - p) * (1 / n_a + 1 / n_b))
    z = (p_b - p_a) / se
    phi = lambda x: 0.5 * (1 + erf(x / sqrt(2)))
    p_wert = 2 * (1 - phi(abs(z)))
    return round(p_a, 4), round(p_b, 4), round(z, 2), round(p_wert, 4)

print("A=30/1000 vs B=48/1000:", z_test(30, 1000, 48, 1000))
print("A=3/100   vs B=5/100  :", z_test(3, 100, 5, 100))
```

Die Funktion berechnet die beiden Anteile, den gemeinsamen Anteil unter der Annahme „kein Unterschied“, den Standardfehler und daraus die Teststatistik z. Die Normalverteilungsfunktion wird mit der Fehlerfunktion `erf` nachgebaut, sodass keine Zusatzpakete nötig sind. Das erste Experiment (3,0 % gegen 4,8 %, je 1.000 Besucher) liefert z ≈ 2,08 und einen p-Wert von etwa 0,038: ein Hinweis auf einen echten Effekt. Das zweite Experiment hat denselben Unterschied in der Tendenz (3 % gegen 5 %), aber nur je 100 Besucher; der p-Wert liegt weit über 0,05, man kann nichts sagen. Die Lehre: Kleine Stichproben erzeugen scheinbare Gewinner.

Typische Fehler: Zu früh abbrechen, zu viele Varianten, kein Erfolgskriterium vorab und Kanäle mit zu wenig Volumen testen. Falsch: „Variante B hatte nach zwei Tagen 5 statt 3 Anmeldungen, wir nehmen B.“ Richtig: Mindeststichprobe vorab festlegen (zum Beispiel über eine Stichprobengrößen-Rechnung), Test laufen lassen, dann entscheiden. Bei sehr kleinen Märkten, wie sie im B2B üblich sind, reichen oft qualitative Tests: 20 Gespräche mit klarer Auswertung sagen mehr als ein statistisch leeres A/B-Experiment.

> **Merke**
>
> GTM-Experimente prüfen Hypothesen über Kanal, Botschaft und Angebot. Ein Experiment hat Kennzahl, Stichprobe und Erfolgskriterium vorab. Unterschiede in kleinen Stichproben sind oft Zufall.

> **Praxisbeispiel**
>
> Teams führen ein Experimentprotokoll mit Datum, Hypothese, Ergebnis und Entscheidung. Es wird in Investor-Updates verwendet und verhindert, dass dieselben Tests zweimal laufen. Im B2B kombiniert man Zahlen mit Kundenfeedback.

## Übungsaufgaben zu Modul 03

1.  **(leicht)** Erkläre den Unterschied zwischen Merkmal, Vorteil und Nutzen am Beispiel einer Buchhaltungssoftware.

2.  **(leicht)** Nenne die neun Bausteine des Business Model Canvas und ordne sie der „Kundenseite“ oder der „internen Seite“ zu.

3.  **(leicht)** Wann ist Usage-based Pricing sinnvoll, wann problematisch?

4.  **(mittel)** Ein SaaS hat ARPA 80 EUR, Bruttomarge 75 %, Churn 2 % pro Monat und CAC 900 EUR. Berechne LTV, LTV/CAC und Payback.

5.  **(mittel)** Begründe, warum ein Produkt mit ACV von 500 EUR nicht über Außendienstverkauf vertrieben werden sollte.

6.  **(praktisch)** Erweitere das Programm aus 3.3 um eine dritte Auswertung: den Preis, bei dem mindestens die Hälfte der Befragten kauft.

7.  **(praktisch)** Schreibe eine Funktion, die für das Reseller-Modell aus 3.6 die Marge berechnet, ab der der Direktverkauf besser ist.

8.  **(schwer/praktisch)** Erweitere `z_test` um eine Funktion, die berechnet, wie viele Besucher pro Variante mindestens nötig sind, um einen Anstieg von 3 % auf 4 % bei 80 % Power und 5 % Signifikanzniveau zu erkennen (Näherungsformel).

## Lösungen zu den Übungsaufgaben Modul 03

**1.** Merkmal: „Automatischer Bankabgleich“. Vorteil: „Buchungen werden Kontoauszügen automatisch zugeordnet“. Nutzen: „Die monatliche Buchhaltung dauert 2 statt 6 Stunden.“ Nur der Nutzen überzeugt Entscheider.

**2.** Kundenseite: Kundensegmente, Wertangebot, Kanäle, Kundenbeziehungen, Einnahmeströme. Interne Seite: Schlüsselressourcen, Schlüsselaktivitäten, Schlüsselpartner, Kostenstruktur. (Das Wertangebot verbindet beide Seiten.)

**3.** Sinnvoll, wenn der Nutzen mit der Menge wächst (zum Beispiel pro Rechnung oder pro Datenmenge) und Kunden niedrig einsteigen sollen. Problematisch, wenn Kunden Planungssicherheit brauchen oder die Rechnung schwer vorhersagbar ist; dann sind gedeckelte Pakete oder Mischmodelle (Grundgebühr plus Nutzung) besser.

**4.** Lebensdauer 1/0,02 = 50 Monate. LTV = 80 · 0,75 · 50 = 3000 EUR. LTV/CAC = 3000/900 = 3,33. Payback = 900/(80 · 0,75) = 15 Monate. Das Verhältnis ist gut, der Payback mit 15 Monaten aber länger als die Faustregel von 12; Finanzierung und Liquidität müssen das tragen.

**5.** Bei 500 EUR Jahresumsatz übersteigen die Kosten eines persönlichen Verkaufs (Gehalt, Reisen, Zeit) den Umsatz, selbst bei kurzem Verkaufszyklus. Selbstbedienung, Onboarding im Produkt und Partner sind wirtschaftlicher.

**6.** Ergänzung:

```python
mehrheit = sorted(wtp)[len(wtp) // 2]
print("Median-WTP:", mehrheit)
print("Hoechster Preis mit >= 50 % Kaeufern:",
      max(p for p, k, u, g in ergebnis if k >= len(wtp) / 2))
```

Die Liste `ergebnis` enthält Tupel aus Preis, Kunden, Umsatz und Gewinn. Bei zwölf Antworten kaufen bei 49 EUR sieben Befragte (58 %), bei 59 EUR nur vier (33 %); der höchste Preis mit mindestens der Hälfte der Käufer ist also 49 EUR.

**7.** Der Direktgewinn beträgt 2.700 EUR. Gesucht ist die Marge m, bei der 6000(1-m) - 300 - 900 = 2700 gilt, also 1-m = 3900/6000 = 0,65 und m = 0,35. Als Code:

```python
def break_even_marge(listenpreis, cac_partner, kosten, gewinn_direkt):
    return 1 - (gewinn_direkt + cac_partner + kosten) / listenpreis

print(break_even_marge(6000, 300, 900, direkt))   # 0.35
```

Bis zu 35 % Partnermarge ist der Reseller-Deal also profitabler als der Direktverkauf.

**8.** Näherungsformel für zwei Anteile: $n \approx \frac{(z_{\alpha/2} + z_\beta)^2  (p_1(1-p_1) + p_2(1-p_2))}{(p_2 - p_1)^2}$ mit $z_{\alpha/2} = 1{,}96$ und $z_\beta = 0{,}84$.

```python
def stichprobe(p1, p2, z_alpha=1.96, z_beta=0.84):
    var = p1 * (1 - p1) + p2 * (1 - p2)
    return round((z_alpha + z_beta) ** 2 * var / (p2 - p1) ** 2)

print(stichprobe(0.03, 0.04))
```

Das Ergebnis liegt bei rund 5.300 Besuchern pro Variante. Das zeigt, wie viel Traffic kleine Effekte brauchen; für junge B2B-Firmen sind solche Tests oft nicht machbar, und qualitative Methoden sind die bessere Wahl.
