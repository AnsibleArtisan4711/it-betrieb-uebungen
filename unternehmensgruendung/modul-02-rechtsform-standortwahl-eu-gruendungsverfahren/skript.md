# Modul 02 - Rechtsform, Standortwahl und EU-Gründungsverfahren

> **Hinweis zu diesem Kapitel:** Das ist das Kapitel des Skripts „Unternehmensgründung“, aus der LaTeX-Quelle in Markdown umgewandelt (Text und Codeblöcke unverändert, farbige Boxen als Zitatblöcke mit fettem Titel, Tabellen als Markdown-Tabellen). Die Lerneinheiten sind wie in der Quelle nach Modul nummeriert (2.1 bis 2.9), danach folgen „Übungsaufgaben zu Modul 02“ (8 Aufgaben, mit Schwierigkeitsangabe) und „Lösungen zu den Übungsaufgaben Modul 02“. Rechtliche und steuerliche Aussagen sind keine Rechtsberatung. Was ich an den Beispielen geprüft habe, steht in der [README des Repositories](../README.md). Übersicht zum Modul: [README](README.md).

**Dauer:** 8 h laut Modulübersicht (Summe der Einzelwerte: 9 × 0,9 h = 8,1 h, gerundet)

**Priorität:** 1 (höchste)

| **Nr.** | **Lerneinheit**                 | **Dauer (h)** |
|--------:|:--------------------------------|--------------:|
|     2.1 | Rechtsformauswahl               |           0,9 |
|     2.2 | Standort- und Jurisdiktionswahl |           0,9 |
|     2.3 | Gründungsprozess und Register   |           0,9 |
|     2.4 | Genehmigungen und Lizenzen      |           0,9 |
|     2.5 | Banking und Zahlungsverkehr     |           0,9 |
|     2.6 | VAT und Steuernummern           |           0,9 |
|     2.7 | Gesellschafterstruktur          |           0,9 |
|     2.8 | Administrative Basisprozesse    |           0,9 |
|     2.9 | Gründungs-Checkliste            |           0,9 |
|         | **Summe**                       |       **8,1** |

Dieses Modul führt durch die formale Geburt eines Unternehmens: Welche Rechtsform passt, in welchem Land wird gegründet, wie läuft das Verfahren, welche Genehmigungen, Konten und Steuerregistrierungen sind nötig, und wie wird das Eigentum unter den Gründenden geregelt? Weil das Recht je Land verschieden ist, nimmt das Skript Österreich als durchgehendes Beispiel und vergleicht mit Deutschland und der EU-Ebene. **Alle rechtlichen und steuerlichen Aussagen sind allgemeine Information und keine Rechtsberatung.** Vor einer Entscheidung sind Notariat, Rechtsanwältin oder Steuerberater einzubinden; Gesetze und Schwellenwerte ändern sich. Stand der Nachrecherche ist der 1. November 2026; die Quellen stehen im Quellenverzeichnis.

## 2.1 Rechtsformauswahl

Die *Rechtsform* bestimmt, wer für Schulden haftet, wie viel Kapital man braucht, wer das Unternehmen vertritt, wie Gewinne besteuert werden und ob Investoren einsteigen können. Man unterscheidet grob zwei Familien. Bei *Personenunternehmen*, zum Beispiel dem Einzelunternehmen, haftet die Person mit ihrem gesamten Privatvermögen. Das ist einfach und billig, aber riskant, sobald Verträge, Mitarbeitende oder Produkte Schäden verursachen können. Bei *Kapitalgesellschaften*, in Österreich vor allem der GmbH (Gesellschaft mit beschränkter Haftung) und der Aktiengesellschaft, ist die Gesellschaft eine eigene juristische Person. Die Gesellschafter haften grundsätzlich nur mit ihrer Einlage, also dem Kapital, das sie versprochen haben einzuzahlen. Diese *Haftungsbeschränkung* und die Möglichkeit, Anteile zu verkaufen, machen Kapitalgesellschaften für Startups mit Investoren zum Standard.

Wichtig sind vier Vergleichskriterien. Erstens die *Haftung*: beschränkt oder unbeschränkt. Zweitens der *Kapitalbedarf*: Das *Stammkapital* ist die Summe der Einlagen der Gesellschafter. Drittens der *Verwaltungsaufwand*: Kapitalgesellschaften müssen bilanzieren, ein Register führen und Beschlüsse formal dokumentieren. Viertens die *Investorenfähigkeit*: Können Anteile geteilt, verkauft und für Mitarbeiterbeteiligung genutzt werden, ohne dass jede Änderung großen Formaufwand erzeugt?

> **Ergänzung aus der Nachrecherche**
>
> **GmbH in Österreich.** Seit 1. Jänner 2024 beträgt das Mindeststammkapital der GmbH 10.000 EUR, davon müssen mindestens 5.000 EUR in bar eingezahlt werden. Die frühere Gründungsprivilegierung ist dadurch für Neugründungen nicht mehr nötig; die Mindest-Körperschaftsteuer sank auf 500 EUR pro Jahr (Quelle Q3).
>
> **FlexCo.** Die Flexible Kapitalgesellschaft (FlexCo) gibt es seit 1. Jänner 2024. Sie bietet unter anderem Unternehmenswert-Anteile für die Mitarbeiterbeteiligung, vereinfachte Anteilsübertragung und Online-Gründung. Nach einem Praxisrückblick (Mai 2026) wird sie seltener genutzt als erwartet, weil die GmbH-Senkung des Mindeststammkapitals einen Kostenvorteil beseitigte; Investoren und Banken bevorzugen teils weiterhin die GmbH, und die Rechtsprechung ist noch dünn (Quelle Q2).
>
> **EU Inc.** Die Europäische Kommission legte am 18. März 2026 einen Verordnungsvorschlag für eine neue europäische Gesellschaftsform („28. Regime“, EU Inc.) vor: kein Mindestkapital, Gründung online innerhalb von 48 Stunden, Kosten von 100 EUR für die Standardgründung. Der Vorschlag steht am Anfang des Gesetzgebungsverfahrens, der Endtext kann abweichen (Quelle Q1). Für die Planung heute gilt daher das nationale Recht.

Das Beispiel ist ein kleiner Entscheidungshelfer. Er ersetzt keine Beratung, macht aber die Logik sichtbar: Er stellt Fragen als Parameter und gibt Hinweise zurück. Das Skript prüft zum Beispiel, ob das Startkapital für die Barzahlung von 5.000 EUR genügt, und ob Investorenpläne gegen ein Einzelunternehmen sprechen.

```python
def hinweise(p: dict) -> list[str]:
    h = []
    if p["haftung_beschraenkt"]:
        h.append("Kapitalgesellschaft (GmbH/FlexCo) pruefen, nicht Einzelunternehmen")
    if p["investoren_geplant"] and not p["haftung_beschraenkt"]:
        h.append("Widerspruch: Investoren steigen kaum in Einzelunternehmen ein")
    if p["haftung_beschraenkt"]:
        if p["startkapital_eur"] < 5000:
            h.append("Barmittel unter 5000 EUR: GmbH-Gruendung nicht moeglich")
        elif p["startkapital_eur"] < 10000:
            h.append("5000 EUR bar genuegen, Rest als Sacheinlage oder spaeter")
    if p["mitarbeiterbeteiligung"]:
        h.append("FlexCo (Unternehmenswert-Anteile) mit Berater vergleichen")
    return h

profil = {"haftung_beschraenkt": True, "investoren_geplant": True,
          "mitarbeiterbeteiligung": True, "startkapital_eur": 7500}
for zeile in hinweise(profil):
    print("-", zeile)
```

Die Funktion erhält ein Wörterbuch mit dem Profil der Gründenden und sammelt in der Liste `h` Hinweise. Die Bedingung `startkapital_eur < 5000` bildet die Mindest-Barzahlung von 5.000 EUR ab; die zweite Bedingung erkennt, dass 7.500 EUR bar zwar für die Bareinzahlung reichen, das Stammkapital von 10.000 EUR aber noch nicht vollständig gedeckt wäre. Dann bleibt zu klären, ob der Rest bar später oder als Sacheinlage (zum Beispiel Computer oder Software) erbracht wird. Die Ausgabe nennt drei Hinweise. Als Entscheidungshilfe taugt das Ergebnis nur als Ausgangspunkt für das Gespräch mit Beratern.

Typische Fehler: Wer als Einzelunternehmen startet und später Investoren sucht, muss umgründen, was Steuern, Verträge und Zeit kostet. Falsch ist, „die billigste Form“ zu wählen, ohne Haftungsrisiko und Investorenpläne zu bedenken. Richtig ist, die Form danach zu wählen, was in den nächsten drei Jahren geplant ist: Beschäftigte, Kundenverträge mit Haftungsklauseln, Investoren. Ein zweiter Fehler ist, auf ein Gesetz zu bauen, das es noch nicht gibt: Die EU Inc. ist ein Vorschlag, keine Rechtsform, die man heute eintragen kann.

> **Merke**
>
> Die Rechtsform steuert Haftung, Kapitalbedarf, Verwaltungsaufwand und Investorenfähigkeit. Für wachstumsorientierte Tech-Startups sind in Österreich GmbH und FlexCo die üblichen Kandidaten; maßgeblich ist das geltende Recht, nicht Gesetzesvorschläge. Rechtsberatung ist unverzichtbar.

> **Praxisbeispiel**
>
> Der Gesellschaftsvertrag oder die Satzung wird bei der Gründung festgelegt und später nur mit Aufwand geändert. Teams, die früh Beteiligungsprogramme für Mitarbeitende planen, besprechen die Wahl zwischen GmbH und FlexCo daher vor dem Notartermin und nicht danach.

## 2.2 Standort- und Jurisdiktionswahl

Die *Jurisdiktion* ist das Rechtsgebiet, dessen Gesetze für die Firma gelten, in der Regel das Land, in dem sie eingetragen ist. Der *Sitz* ist der Ort, der im Register steht. Davon zu unterscheiden ist der Ort der tatsächlichen Geschäftsleitung, an dem die wesentlichen Entscheidungen fallen. Steuerbehörden schauen auf die Realität: Wer in Österreich lebt und arbeitet, aber eine Gesellschaft im Ausland gründet, wird dadurch nicht automatisch im Ausland besteuert. Die Konstruktion kann sogar zusätzliche Meldepflichten und doppelten Aufwand auslösen. Die Entscheidung für einen Standort ist deshalb keine Frage von Marketingbildern („Estland ist digital“), sondern von Steuer, Talent, Förderung, Banking und Zielmarkt.

Die fünf Bewertungsfelder verhalten sich so. Bei der *Steuer* zählen Körperschaftsteuersatz, Besteuerung von Ausschüttungen, Regeln zu Mitarbeiterbeteiligung und Doppelbesteuerungsabkommen. Beim *Talent* geht es darum, wo qualifizierte Beschäftigte leben und welche Lohnnebenkosten anfallen. Die *Förderung* umfasst nationale und regionale Programme, die oft einen Sitz im Land verlangen. Beim *Banking* ist entscheidend, wie leicht ein Geschäftskonto zu eröffnen ist. Und der *Zielmarkt* bestimmt, ob Kunden eine Firma im eigenen Land erwarten.

Die Entscheidung lässt sich mit einer gewichteten Bewertung vorbereiten, die so aufgebaut ist wie in Modul 01. Das Beispiel vergleicht drei fiktive Standorte und zeigt, wie sich das Ergebnis ändert, wenn man die Gewichte verschiebt. Noten sind Beispielwerte.

```python
standorte = {
    "Oesterreich": {"steuer": 3, "talent": 4, "foerderung": 5, "banking": 4, "markt": 5},
    "Deutschland": {"steuer": 3, "talent": 5, "foerderung": 4, "banking": 4, "markt": 5},
    "Land X":      {"steuer": 5, "talent": 3, "foerderung": 2, "banking": 2, "markt": 2},
}
def bewerte(gewichte):
    assert abs(sum(gewichte.values()) - 1) < 1e-9
    return {name: round(sum(gewichte[k] * n[k] for k in gewichte), 2)
            for name, n in standorte.items()}

print("Standard:", bewerte({"steuer": .2, "talent": .2, "foerderung": .2, "banking": .2, "markt": .2}))
print("Steuer wichtig:", bewerte({"steuer": .6, "talent": .1, "foerderung": .1, "banking": .1, "markt": .1}))
```

Die Funktion `bewerte` nimmt die Gewichte als Parameter, prüft mit `assert`, dass sie 100 % ergeben, und berechnet für jeden Standort die gewichtete Summe. Die Wörterbuch-Schreibweise in der `return`-Zeile baut direkt das Ergebnis. Bei gleichen Gewichten liegen Österreich und Deutschland mit je 4,2 vorn, „Land X“ mit 2,8 hinten; legt man 60 % auf die Steuer, rutschen Österreich und Deutschland auf je 3,6, während Land X auf 3,9 steigt und an die Spitze springt. Die Lehre: Wer eine Entscheidung für einen steuergünstigen Standort trifft, muss sich bewusst machen, dass Banking, Markt und Förderung dabei verlieren.

Typische Fehler sind eine Briefkastenfirma ohne Substanz, die Gründung im Ausland ohne Rücksicht auf die Wohnsitz- und Geschäftsleitungsregeln und das Ignorieren von Bankproblemen. Falsch: „Wir gründen in Land X, weil dort die Steuern niedrig sind, und leben und arbeiten weiter in Wien.“ Richtig: Die Konsequenzen für Geschäftsleitung, Betriebsstätte und Steuerpflicht schriftlich mit einer Steuerberaterin klären, bevor der Gründungsort feststeht. Auch Förderprogramme sind oft an den Sitz gebunden und gehen verloren.

> **Merke**
>
> Standortwahl heißt abwägen: Steuer, Talent, Förderung, Banking und Zielmarkt. Sitz im Register ist nicht gleich Ort der Geschäftsleitung. Die operative Realität (wo arbeiten wir, wo sind die Kunden) schlägt das Marketingbild eines Landes.

> **Praxisbeispiel**
>
> Viele Teams gründen am Wohnort der Gründenden, weil Förderungen, Konto und Beratung dort einfach sind, und gründen später eine Tochtergesellschaft im Zielmarkt, sobald Umsatz und Mitarbeiter dort anfallen (Modul 12). Kommt ein Investor aus dem Ausland, kann er eine Holding-Struktur verlangen; auch das gehört in die Planung.

## 2.3 Gründungsprozess und Register

Eine Kapitalgesellschaft entsteht rechtlich mit ihrer *Eintragung im Register*. In Österreich ist das das *Firmenbuch*, in Deutschland das *Handelsregister*. Das Register ist öffentlich einsehbar und enthält Firma, Sitz, Gesellschafter oder Geschäftsführer sowie Angaben zum Kapital. Es schafft Vertrauen im Rechtsverkehr: Wer mit einer GmbH einen Vertrag schließt, kann dort prüfen, wer sie vertreten darf. Vor der Eintragung kann eine *Vorgesellschaft* existieren, für deren Handeln die Handelnden unter Umständen persönlich haften; Verträge sollten daher möglichst erst nach der Eintragung oder mit klarer Regelung unterschrieben werden.

Der Ablauf besteht typischerweise aus folgenden Schritten: Firmenwortlaut prüfen (darf er verwendet werden, ist er unterscheidbar?), Gesellschaftsvertrag oder Satzung aufsetzen, in vorgeschriebener Form beurkunden (oft vor einem Notar, bei einfachen Ein-Personen-Gründungen in Österreich auch elektronisch über ein Online-Verfahren), Stammkapital auf ein Konto einzahlen und per Bankbestätigung nachweisen, den Antrag auf Eintragung ins Firmenbuch stellen und nach der Eintragung Steuernummer, Sozialversicherung und gegebenenfalls Gewerbeberechtigung anmelden. Ein eindeutiger Zeitplan ist wichtig, weil die einzelnen Schritte aufeinander warten.

Das folgende Beispiel berechnet die Gesamtdauer aus Einzelschritten und Abhängigkeiten, also den *kritischen Pfad*. Die Dauern sind angenommene Arbeitstage und keine behördlichen Zusagen.

```python
schritte = {
    # name: (Dauer in Tagen, Voraussetzungen)
    "Firmenwortlaut pruefen": (2, []),
    "Gesellschaftsvertrag":   (5, ["Firmenwortlaut pruefen"]),
    "Beurkundung":            (2, ["Gesellschaftsvertrag"]),
    "Konto fuer Einzahlung":  (7, []),
    "Einzahlung + Bestaetigung": (2, ["Konto fuer Einzahlung", "Beurkundung"]),
    "Firmenbuchantrag":       (10, ["Einzahlung + Bestaetigung"]),
    "Steuer/SV-Anmeldung":    (5, ["Firmenbuchantrag"]),
}
ende = {}
def fertig(name):
    if name not in ende:
        dauer, vor = schritte[name]
        start = max((fertig(v) for v in vor), default=0)
        ende[name] = start + dauer
    return ende[name]

gesamt = max(fertig(n) for n in schritte)
print("Gesamtdauer (Tage):", gesamt)
for n, t in sorted(ende.items(), key=lambda x: x[1]):
    print(f"{t:3d}  {n}")
```

Das Wörterbuch `schritte` beschreibt für jeden Schritt Dauer und Voraussetzungen. Die Funktion `fertig` berechnet rekursiv, wann ein Schritt endet: Er beginnt, wenn alle Voraussetzungen fertig sind (`max` über deren Ende, ohne Voraussetzung 0), und endet nach seiner Dauer. Das Zwischenergebnis wird in `ende` gespeichert, damit nichts doppelt gerechnet wird. Die Gesamtdauer beträgt 26 Tage. Die Rechnung zeigt, dass die Kontoeröffnung (7 Tage) parallel zum Vertrag laufen kann und der Firmenbuchantrag der längste Einzelschritt ist. Wer das Konto erst nach der Beurkundung beantragt, verlängert den Prozess unnötig.

Typische Fehler: Verträge vor der Eintragung unterschreiben, Kapital nicht rechtzeitig einzahlen, Firmenwortlaut vorher nicht prüfen und Unterlagen unvollständig einreichen. Falsch: „Wir mieten schon das Büro, den Vertrag unterschreibt Anna im Namen der GmbH i. G.“ Richtig: den Vertrag erst abschließen, wenn die Eintragung vorliegt, oder die Übernahme durch die Gesellschaft ausdrücklich regeln und das Haftungsrisiko kennen. Fehler bei der Beurkundung führen zu Rückfragen des Gerichts und verzögern die Eintragung.

> **Merke**
>
> Die Gesellschaft entsteht mit der Eintragung im Firmenbuch beziehungsweise Handelsregister. Der Prozess besteht aus mehreren abhängigen Schritten; ein sauberer Plan mit kritischem Pfad verhindert Leerlauf. Vor der Eintragung ist Vorsicht bei Verträgen geboten.

> **Praxisbeispiel**
>
> Banken verlangen für das Konto oft Gesellschaftsvertrag und Gründungsunterlagen, das Gericht verlangt die Bankbestätigung. Wer das früh mit der Bank abstimmt, spart Wochen. Kostenrahmen und Gebühren gehören vor Beginn in eine Liste (Notar, Gericht, Beratung).

## 2.4 Genehmigungen und Lizenzen

Nicht jede Tätigkeit darf einfach begonnen werden. Manche Branchen unterliegen *Genehmigungs-* oder *Lizenzpflichten*, andere nur einer Anzeigepflicht. In Österreich ist ein großer Teil der Tätigkeiten ein *Gewerbe* im Sinn der Gewerbeordnung, das bei der Gewerbebehörde angemeldet werden muss; bei *reglementierten Gewerben* ist zusätzlich ein Befähigungsnachweis nötig. Daneben gibt es freie Berufe und Tätigkeiten, die eigene Gesetze regeln, etwa im Finanzbereich, im Gesundheitsbereich oder im Bildungsbereich. Wer Software entwickelt, braucht oft keine besondere Lizenz, wer aber Zahlungen abwickelt, mit Gesundheitsdaten arbeitet oder Finanzprodukte vermittelt, wird sehr schnell mit Aufsichtsrecht konfrontiert.

Die Prüfung beginnt mit der Frage, welche Tätigkeit konkret geplant ist, nicht welche Branche das Unternehmen hat. Eine Plattform, die Zahlungen zwischen zwei Parteien weiterleitet, kann eine regulierte Zahlungsdienstleistung betreiben. Eine App, die Gesundheitsdaten auswertet, kann als Medizinprodukt gelten. Solche Fragen entscheiden manchmal über das gesamte Geschäftsmodell. Daher gehört eine Genehmigungs-Landkarte früh in die Planung, mit Zuständigkeit, Frist und Verantwortlichem.

Das Beispiel führt eine solche Landkarte als Liste und meldet, welche Nachweise bald fällig oder bereits überfällig sind. Es arbeitet mit dem Datumsmodul von Python. Die Einträge sind erfundene Beispiele.

```python
from datetime import date

heute = date(2026, 11, 1)
pflichten = [
    {"was": "Gewerbeanmeldung",         "frist": date(2026, 11, 30), "owner": "CEO",  "erledigt": False},
    {"was": "Datenschutzerklaerung",    "frist": date(2026, 10, 15), "owner": "CTO",  "erledigt": False},
    {"was": "Versicherungsnachweis",    "frist": date(2027, 1, 31),  "owner": "COO",  "erledigt": False},
    {"was": "Firmenbuch-Eintragung",    "frist": date(2026, 10, 1),  "owner": "CEO",  "erledigt": True},
]
for p in sorted(pflichten, key=lambda x: x["frist"]):
    if p["erledigt"]:
        status = "ok"
    else:
        tage = (p["frist"] - heute).days
        status = "UEBERFAELLIG" if tage < 0 else f"in {tage} Tagen"
    print(f"{p['was']:26s} {p['owner']:4s} {status}")
```

Die Differenz zweier `date`-Objekte ergibt ein Zeitintervall, dessen Eigenschaft `days` die Tage liefert. Ist sie negativ, ist die Frist verstrichen. Die Schleife läuft nach Frist sortiert; erledigte Pflichten erscheinen als „ok“. Ausgegeben wird, dass die Datenschutzerklärung überfällig ist, die Gewerbeanmeldung in 29 Tagen und der Versicherungsnachweis in 91 Tagen fällig sind. Wichtiger als die Technik ist die Disziplin dahinter: Jede Pflicht hat einen Verantwortlichen, eine Frist und einen Status.

Typische Fehler: Die Genehmigungspflicht erst nach dem Produktstart bemerken, Branchenregeln anderer Länder vergessen (Verkauf in Deutschland bedeutet deutsches Recht für bestimmte Bereiche) und Nachweise nicht archivieren. Falsch: „Wir sind nur eine Softwarefirma.“ Richtig: „Unsere Software verarbeitet Zahlungsdaten und ermöglicht Auszahlungen; wir klären vorab mit Rechtsberatung, ob wir Zahlungsdienste erbringen oder einen regulierten Partner nutzen.“ Wer sich auf einen Partner stützt, sollte dessen Lizenz prüfen.

> **Merke**
>
> Zuerst die konkrete Tätigkeit klären, dann die zuständige Behörde und die Anforderungen. Eine Genehmigungs-Landkarte mit Verantwortlichem, Frist und Nachweis gehört in jede Gründungsplanung. Aufsichtsrecht kann ein Geschäftsmodell verändern.

> **Praxisbeispiel**
>
> Die Wirtschaftskammern und Behörden-Seiten der Länder bieten Informationen zu Gewerbeberechtigungen. In vielen Fällen lohnt ein kurzes Vorgespräch mit der Behörde oder Kammer, das schriftlich bestätigt wird. Bei regulierten Branchen planen Teams Monate für Verfahren ein.

## 2.5 Banking und Zahlungsverkehr

Ohne Geschäftskonto kein Unternehmen: Das Stammkapital wird auf ein Konto eingezahlt, Kunden zahlen darauf, Gehälter und Lieferanten werden davon bezahlt. Die Eröffnung ist heute komplizierter, als viele erwarten, weil Banken gesetzlich zur Geldwäscheprävention verpflichtet sind. Dahinter steht das Prinzip *KYC* (*Know Your Customer*): Die Bank muss wissen, wer ihr Kunde ist, wer wirtschaftlich dahintersteht (der *wirtschaftliche Eigentümer*, englisch *Ultimate Beneficial Owner*, UBO) und woher das Geld kommt. Für Startups heißt das: Gesellschaftsvertrag, Firmenbuchauszug, Ausweise der Vertretungsberechtigten, Nachweis über die Eigentümerstruktur, Beschreibung des Geschäftsmodells und gelegentlich Businessplan oder Kundenverträge.

Für den Zahlungsverkehr gibt es neben klassischen Banken *Zahlungsdienstleister* (englisch *Payment Service Provider*, PSP), die Kartenzahlungen, Lastschriften oder Wallets abwickeln. Sie verlangen ebenfalls KYC und halten teilweise Auszahlungen zurück, bis die Prüfung abgeschlossen ist. Bei grenzüberschreitenden Konstruktionen (Firma in einem Land, Gründer in einem anderen, Kunden in einem dritten, Server in einem vierten) steigen Prüfaufwand und Ablehnungsrisiko. Banken lehnen Konten manchmal ab, wenn sie Geschäftsmodell oder Struktur nicht verstehen. Ein klarer Einseiter zur Erklärung hilft.

Das nächste Beispiel automatisiert die Dokumentenprüfung für KYC: Es vergleicht eine Liste benötigter Unterlagen mit den vorhandenen und zeigt, was fehlt. Außerdem rechnet es die Eigentümerstruktur durch und markiert wirtschaftliche Eigentümer ab 25 % Anteil, eine in der Praxis häufig genutzte Schwelle (der genaue Wert ist im jeweiligen Gesetz zu prüfen).

```python
benoetigt = {"Gesellschaftsvertrag", "Firmenbuchauszug", "Ausweis Geschaeftsfuehrer",
             "UBO-Erklaerung", "Geschaeftsbeschreibung"}
vorhanden = {"Gesellschaftsvertrag", "Ausweis Geschaeftsfuehrer"}
print("Fehlt:", sorted(benoetigt - vorhanden))

anteile = {"Anna": 40.0, "Ben": 35.0, "Cleo": 20.0, "Pool": 5.0}
assert abs(sum(anteile.values()) - 100) < 1e-9
ubo = [n for n, a in anteile.items() if a >= 25]
print("Wirtschaftliche Eigentuemer (>= 25 %):", ubo)
```

Die Mengenoperation `benoetigt - vorhanden` liefert alle Elemente, die in der ersten, aber nicht in der zweiten Menge sind. `sorted` macht daraus eine geordnete Liste. Danach prüft `assert`, dass die Anteile genau 100 % ergeben, und die Listenbildung wählt alle mit mindestens 25 %. Die Ausgabe nennt drei fehlende Unterlagen und Anna und Ben als Eigentümer. Das zeigt zugleich eine praktische Folge: Auch Personen unter der Schwelle können im Einzelfall relevant sein, zum Beispiel wenn sie gemeinsam handeln. Die Bank entscheidet nach ihrer Risikoeinschätzung.

Typische Fehler: Konto erst beantragen, wenn es dringend wird; Zahlungen über private Konten abwickeln, was Buchhaltung und Haftung vermischt; zu viele Überweisungen mit unklarem Verwendungszweck; Kartenlimits und Auszahlungsfristen der PSP nicht kennen. Falsch: „Wir nehmen erst mal Kundenzahlungen auf das Privatkonto.“ Richtig: Ein Geschäftskonto bereits während der Gründung vorbereiten (Vorab-Termin mit der Bank) und Zahlungsflüsse trennen. Zahlungsdienstleister sollte man mit Konditionen, Rückbuchungsregeln und Auszahlungsrhythmus vergleichen.

> **Merke**
>
> Banken und PSP prüfen nach KYC-Regeln, wer hinter einer Firma steht und was sie tut. Wer die Unterlagen und die Eigentümerstruktur sauber vorbereitet, spart Wochen. Privates und Geschäftliches wird strikt getrennt.

> **Praxisbeispiel**
>
> Ablehnungen kommen vor, besonders bei neuen Firmen mit internationalen Strukturen. Teams halten deshalb zwei Kontoanbieter bereit und führen eine Liste der Unterlagen, die jeder Anbieter verlangt. Für Modul 07 (Finanzen) ist die Kontostruktur die Grundlage der Buchhaltung.

## 2.6 VAT und Steuernummern

*VAT* (Value Added Tax) heißt auf Deutsch *Umsatzsteuer* (USt, in Österreich auch MwSt). Sie wird auf Lieferungen und Leistungen erhoben, der Unternehmer rechnet sie in Rechnungen ab und führt sie an das Finanzamt ab; im Gegenzug darf er die Umsatzsteuer aus Eingangsrechnungen als *Vorsteuer* abziehen. Die Steuer belastet wirtschaftlich den Endverbraucher, nicht das Unternehmen. Damit sie funktioniert, braucht das Unternehmen eine Steuernummer und, für grenzüberschreitende Geschäfte in der EU, eine *UID-Nummer* (Umsatzsteuer-Identifikationsnummer). Sie beginnt mit dem Ländercode, in Österreich „ATU“ und acht Ziffern.

Entscheidend ist die Frage nach dem *Ort der Leistung*, denn dort wird die Steuer geschuldet. Für Leistungen an Unternehmen in anderen EU-Staaten (B2B) gilt bei Dienstleistungen grundsätzlich der Ort des Empfängers. Folge: Der Lieferant stellt eine Rechnung *ohne* Umsatzsteuer aus und vermerkt „Reverse Charge“, also Übergang der Steuerschuld auf den Leistungsempfänger, der die Steuer in seinem Land selbst anmeldet. Für Leistungen an Privatpersonen (B2C) gelten besondere Regeln, besonders für elektronisch erbrachte Leistungen wie Software und Apps.

> **Ergänzung aus der Nachrecherche**
>
> Für grenzüberschreitende B2C-Umsätze mit digitalen Leistungen und für Fernverkäufe von Waren gibt es den EU-weiten Schwellenwert von 10.000 EUR (Quelle Q4). Darunter dürfen bestimmte Umsätze noch im Heimatstaat besteuert werden. Wer die Schwelle überschreitet, besteuert im Land des Verbrauchers. Mit dem *One-Stop-Shop* (OSS) kann man sich in einem EU-Staat registrieren und dort die Umsatzsteuer für alle EU-Länder erklären und zahlen, statt sich in jedem Land einzeln zu registrieren. Fristen, Formulare und Details sind den offiziellen Leitfäden zu entnehmen (keine Rechtsberatung).

Das folgende Beispiel bildet die Entscheidungslogik stark vereinfacht ab. Es bestimmt anhand von Kundentyp, Land und UID, welche Umsatzsteuerbehandlung eine Rechnung eines österreichischen Softwareanbieters bekommt. Es dient dem Verständnis, nicht der Rechnungsstellung: Der Steuersatz im Inland ist 20 %; Ausnahmen, Schwellenwerte und Sonderfälle fehlen.

```python
def ust_behandlung(kunde_typ, land, hat_uid, netto):
    if land == "AT":
        ust = round(netto * 0.20, 2)
        return f"Inland: 20 % USt = {ust:.2f}, brutto {netto + ust:.2f}"
    if kunde_typ == "B2B" and hat_uid:
        return f"EU-B2B: ohne USt, Hinweis Reverse Charge, UID des Kunden angeben, brutto {netto:.2f}"
    if kunde_typ == "B2C":
        return "EU-B2C: Ort der Leistung pruefen (Schwelle 10000 EUR, OSS)"
    return "Unklar: UID des Kunden pruefen lassen"

faelle = [("B2B", "AT", False, 1000), ("B2B", "DE", True, 1000),
          ("B2C", "FR", False, 100), ("B2B", "DE", False, 500)]
for f in faelle:
    print(f, "->", ust_behandlung(*f))
```

Die Funktion prüft nacheinander die Fälle. Im Inland werden 20 % aufgeschlagen; die Rundung auf zwei Nachkommastellen gleicht Cent-Fragen aus. Bei Kunden mit UID in anderen EU-Staaten lautet die Behandlung Reverse Charge. Bei Privatkunden verweist sie auf die Prüfung von Schwelle und OSS. Der letzte Fall (B2B ohne UID) landet bewusst im Zweifel, weil ohne gültige UID das Risiko steigt, dass die Behandlung falsch ist. Der Stern in `ust_behandlung(*f)` entpackt das Tupel in die vier Argumente. Die Ausgabe der vier Fälle zeigt die vier Zweige.

Typische Fehler: UID des Kunden nicht prüfen, Rechnungen ohne die vorgeschriebenen Angaben, die Registrierung vergessen, wenn Schwellen überschritten werden. Falsch: „Wir verkaufen an Kunden in der ganzen EU, also rechnen wir überall ohne Steuer ab.“ Richtig: Zwischen B2B mit gültiger UID und B2C unterscheiden und Rechnungen nach dem jeweiligen Fall ausstellen. Aufzeichnungspflichten (Belege aufbewahren, Konten führen) gelten in der Regel mehrere Jahre; die genaue Dauer ist im Landesrecht zu prüfen.

> **Merke**
>
> Umsatzsteuer hängt vom Ort der Leistung, vom Kundentyp und von der UID ab. B2B-Leistungen in der EU laufen meist über Reverse Charge, B2C-Digitalleistungen über Schwelle und OSS. Prüfe UID und Rechnungsangaben systematisch und lass die Einordnung vom Steuerberater bestätigen.

> **Praxisbeispiel**
>
> Rechnungssoftware und Zahlungsdienste automatisieren viele Fälle. Trotzdem muss das Team verstehen, welche Regeln dahinterstehen, damit Einstellungen stimmen. In Modul 07 wird die laufende Umsatzsteuer-Praxis (Voranmeldungen, Reverse Charge) vertieft.

## 2.7 Gesellschafterstruktur

Die *Gesellschafterstruktur* regelt, wem wie viel vom Unternehmen gehört und wer was entscheiden darf. Sie wird im Gesellschaftsvertrag und oft in einer zusätzlichen *Gesellschaftervereinbarung* festgehalten. Wichtige Begriffe: Der *Anteil* gibt die Beteiligung am Vermögen und am Gewinn an. Das *Stimmrecht* bestimmt die Macht bei Beschlüssen und kann vom Anteil abweichen. Eine *Sperrminorität* ist ein Anteil, mit dem man bestimmte Beschlüsse blockieren kann, die eine qualifizierte Mehrheit brauchen (in einer GmbH häufig 75 %). Mit *Vesting* verdienen sich Gründende ihre Anteile über die Zeit: Verlässt jemand das Team nach sechs Monaten, behält er nicht automatisch 40 % der Firma.

Beim Vesting gibt es zwei Standardbausteine. Die *Cliff* ist eine Wartezeit, vor deren Ende gar nichts „verdient“ ist, üblich ist ein Jahr. Danach verteilt sich der Rest über die *Vesting-Periode*, üblicherweise vier Jahre, monatlich. Leaver-Klauseln regeln, was bei Austritt geschieht: Ein *Good Leaver* (zum Beispiel wegen Krankheit) behält mehr als ein *Bad Leaver* (zum Beispiel wegen grober Pflichtverletzung); nicht verdiente Anteile fallen an die Gesellschaft oder die anderen Gesellschafter zurück, meist gegen einen niedrigen Preis. Solche Regeln müssen rechtlich sauber formuliert sein, damit sie wirksam sind.

Das Beispiel rechnet das Vesting für drei Gründende durch. Es nutzt eine Cliff von 12 Monaten und eine Periode von 48 Monaten und gibt für verschiedene Austrittszeitpunkte die verdienten Anteile aus. Die Formel ist ein Modell, kein Vertragstext.

```python
def verdient(anteil_prozent, monate, cliff=12, periode=48):
    if monate < cliff:
        return 0.0
    return round(anteil_prozent * min(monate, periode) / periode, 2)

gruender = {"Anna": 40.0, "Ben": 35.0, "Cleo": 25.0}
for austritt in (6, 12, 30, 60):
    zeile = {n: verdient(a, austritt) for n, a in gruender.items()}
    print(f"Austritt nach {austritt:2d} Monaten:", zeile)
```

Die Funktion gibt 0 zurück, solange die Cliff nicht erreicht ist; danach rechnet sie anteilig: Anteil mal verdiente Monate geteilt durch 48, gedeckelt bei der Periode (`min`). Nach 12 Monaten hat Anna 10 Prozentpunkte verdient (40 mal 12 durch 48), nach 30 Monaten 25, nach 60 Monaten die vollen 40. Wichtig ist das Verhalten bei Monat 11 und 12: Es gibt einen Sprung von 0 auf einen Viertel-Anteil. Genau dieser Sprung ist das Merkmal der Cliff. Das Skript zeigt außerdem, wie viel Anteil bei frühem Ausscheiden „frei“ wird und für Ersatzpersonen oder den Mitarbeiterpool zur Verfügung steht.

Typische Fehler: Anteile nach Gefühl und gleichmäßig verteilen („wir sind zu dritt, also je ein Drittel“), ohne Beitrag, Risiko und Vollzeit-Einsatz zu bewerten; Verträge ohne Vesting, sodass ausgeschiedene Gründende unverändert Anteile halten; ungeklärte Stimmrechte. Falsch: „Wir einigen uns schon, wenn es soweit ist.“ Richtig: Im Vorfeld festlegen, wie Entscheidungen fallen, wie Gründende ausscheiden und wie bewertet wird. Konfliktfälle (Patt, Ausstieg, Streit um Geistiges Eigentum) gehören ausdrücklich in den Vertrag, solange noch Frieden herrscht.

> **Merke**
>
> Anteile, Stimmrechte und Vesting werden früh und schriftlich geregelt. Cliff und Vesting-Periode schützen die Verbleibenden vor frühen Austritten, Leaver-Klauseln regeln das Ende, und Konfliktklauseln verhindern Blockaden. Investoren fragen im Rahmen der Due Diligence genau danach (Modul 08).

> **Praxisbeispiel**
>
> Investoren verlangen oft, dass Gründende Vesting akzeptieren, selbst wenn sie schon Jahre dabei sind (teilweise mit Anrechnung der bisherigen Zeit). Wer das vorher regelt, wirkt reif und beschleunigt Verhandlungen.

## 2.8 Administrative Basisprozesse

Nach der Gründung beginnt der Alltag: Post kommt an, Behörden setzen Fristen, Belege fallen an, Verträge laufen aus. Aus der Sicht eines Startups wirken diese Aufgaben lästig, aber Fehler hier kosten schnell Geld: Säumniszuschläge, verpasste Fristen, verlorene Förderungen. Deshalb braucht jedes Unternehmen ein Minimum an Struktur. Es besteht aus vier Teilen. Erstens ein *Postweg*: Wo kommt physische und digitale Post an, und wer öffnet sie täglich? Zweitens eine *Dokumentenablage* mit festen Ordnern und Namenskonventionen, damit Verträge, Rechnungen und Beschlüsse auffindbar sind. Drittens die *Buchhaltungsroutine*: Belege werden laufend gesammelt (Details in Modul 07). Viertens ein *Compliance-Kalender*, der alle wiederkehrenden Fristen enthält.

Typische Fristen sind die monatliche oder quartalsweise Umsatzsteuer-Voranmeldung, Lohnabgaben, die Offenlegung des Jahresabschlusses im Firmenbuch und die Steuererklärungen. Die genauen Fristen sind landesrechtlich geregelt und ändern sich; das Beispiel nimmt als Annahme an, dass die Umsatzsteuer-Voranmeldung bis zum 15. des zweitfolgenden Monats zu erfolgen hat (für Österreich üblich; vor der Verwendung mit dem Steuerberater bestätigen). Es erzeugt daraus eine Terminliste für ein Jahr.

```python
from datetime import date

def monat_plus(jahr, monat, n):
    m = monat - 1 + n
    return jahr + m // 12, m % 12 + 1

termine = []
for monat in range(1, 13):
    j, m = monat_plus(2027, monat, 2)
    termine.append((date(j, m, 15), f"UVA fuer {monat:02d}/2027"))

for d, text in sorted(termine)[:4]:
    print(d.isoformat(), text)
print("Anzahl Termine:", len(termine))
```

Die Hilfsfunktion `monat_plus` addiert Monate und gleicht Jahreswechsel aus: `m // 12` liefert die Jahresüberträge, `m % 12 + 1` den neuen Monat. Für jeden Monat 2027 wird daraus der Termin im zweitfolgenden Monat berechnet; für Jänner 2027 ergibt sich der 15. März 2027, für November 2027 der 15. Jänner 2028. Die Liste wird sortiert, die ersten vier Einträge werden ausgegeben. In echten Projekten exportiert man solche Termine in einen Kalender mit Erinnerungen an die verantwortliche Person.

Fehler: Die Frist erst am Tag selbst bemerken; Belege lose in Chats und E-Mails verstreut ablegen; keine Vertretung bei Urlaub oder Krankheit; Fristen durch Feiertage und Wochenenden falsch berechnen. Falsch: „Die Buchhaltung kümmert sich schon.“ Richtig: Der Compliance-Kalender nennt pro Frist den Verantwortlichen, die Vertretung und die Erinnerung vor Ablauf. Dokumente, die gesetzlich aufzubewahren sind, werden nach einer Namensregel abgelegt, zum Beispiel `JJJJ-MM-TT_Typ_Partner`.

> **Merke**
>
> Administration ist ein Prozess, kein Zufall. Postweg, Ablage, Buchhaltungsroutine und Compliance-Kalender verhindern teure Versäumnisse. Jede Frist hat Verantwortliche und Vertretung.

> **Praxisbeispiel**
>
> Viele Startups lagern Lohnverrechnung und Buchhaltung an eine Kanzlei aus. Das ersetzt nicht die Verantwortung: Das Team muss Belege liefern und Termine kennen. Die Struktur aus dieser Lerneinheit wird später auch bei Audits und Due Diligence vorgezeigt.

## 2.9 Gründungs-Checkliste

Die *Gründungs-Checkliste* fasst alles Bisherige zusammen: Dokumente, Verantwortliche, Fristen und offene Risiken. Eine Checkliste ist mehr als eine Aufzählung. Sie macht den Stand sichtbar (Was ist erledigt, was blockiert?), verteilt Verantwortung (Wer erledigt es bis wann?) und erzwingt Entscheidungen (Was passiert, wenn es nicht rechtzeitig fertig wird?). Besonders wichtig sind *Abhängigkeiten*: Das Konto braucht den Vertrag, der Firmenbuchantrag braucht die Bestätigung der Bank, die Umsatzsteuer-Registrierung braucht die Eintragung. Offene Risiken wie ein nicht geprüfter Firmenwortlaut, ein ungeklärter Gesellschafterstreit oder ein fehlendes Geschäftsmodell-Papier für die Bank sollten vor der Eintragung geklärt sein, weil Änderungen danach teuer sind.

Das Beispiel verwaltet eine Checkliste als Datenstruktur und berechnet den Reifegrad. Es listet außerdem offene Aufgaben nach Frist auf und markiert blockierte Punkte, deren Voraussetzungen nicht erledigt sind.

```python
aufgaben = [
    {"id": 1, "text": "Firmenwortlaut geprueft",   "owner": "Anna", "frist": "2026-11-05", "done": True,  "braucht": []},
    {"id": 2, "text": "Gesellschaftsvertrag fertig","owner": "Ben",  "frist": "2026-11-12", "done": False, "braucht": [1]},
    {"id": 3, "text": "Notartermin",               "owner": "Anna", "frist": "2026-11-15", "done": False, "braucht": [2]},
    {"id": 4, "text": "Konto-Vorgespraech Bank",   "owner": "Cleo", "frist": "2026-11-10", "done": False, "braucht": []},
    {"id": 5, "text": "Firmenbuchantrag",          "owner": "Ben",  "frist": "2026-11-30", "done": False, "braucht": [3, 4]},
]
erledigt = {a["id"] for a in aufgaben if a["done"]}
print(f"Reifegrad: {len(erledigt)}/{len(aufgaben)} = {100*len(erledigt)//len(aufgaben)} %")
for a in sorted(aufgaben, key=lambda x: x["frist"]):
    if a["done"]:
        continue
    offen = [i for i in a["braucht"] if i not in erledigt]
    zusatz = f" BLOCKIERT durch {offen}" if offen else ""
    print(a["frist"], a["owner"], a["text"], zusatz)
```

Die Mengenbildung `erledigt` sammelt die IDs erledigter Aufgaben. Aus ihr folgt der Reifegrad mit ganzzahliger Division (`//`), hier 1 von 5 gleich 20 Prozent. In der Schleife wird für jede offene Aufgabe geprüft, welche Voraussetzungen noch fehlen. Die Ausgabe zeigt, dass „Notartermin“ durch Aufgabe 2 blockiert ist und der Firmenbuchantrag durch die Aufgaben 3 und 4. Genau diese Sicht entscheidet, was als Nächstes angepackt wird: Aufgabe 4 hat keine Voraussetzung und kann sofort beginnen.

Typische Fehler: Eine Checkliste ohne Verantwortliche, ohne Fristen oder mit versteckten Abhängigkeiten, die erst am Notartermin auffallen. Falsch: „Cleo kümmert sich ums Konto“ ohne Datum. Richtig: „Cleo führt bis 10. 11. das Vorgespräch mit der Bank und liefert die Unterlagenliste.“ Ein weiterer Fehler ist, Risiken nur im Kopf zu führen. Offene Risiken gehören mit Auswirkung, Wahrscheinlichkeit und Gegenmaßnahme in eine Liste (vertieft in Modul 11, Risikoregister).

> **Merke**
>
> Eine Checkliste ist nur so gut wie ihre Verantwortlichen, Fristen und Abhängigkeiten. Offene Risiken werden vor der Eintragung entschieden, nicht danach. Der Reifegrad zeigt, ob der Antrag eingereicht werden kann.

> **Praxisbeispiel**
>
> Gründerberatungen und Notariate verwenden eigene Checklisten. Teams, die ihre eigene führen, sparen Rückfragen und gewinnen einen Überblick über Kosten und Zeit. Dieselbe Liste dient später als Nachweis in der Due Diligence.

## Übungsaufgaben zu Modul 02

1.  **(leicht)** Erkläre den Unterschied zwischen unbeschränkter und beschränkter Haftung und nenne je eine passende Rechtsform.

2.  **(leicht)** Was bedeutet „Reverse Charge“, und in welchem Fall wird es bei Dienstleistungen an EU-Kunden angewendet?

3.  **(leicht)** Welcher Unterschied besteht zwischen dem Sitz im Register und dem Ort der tatsächlichen Geschäftsleitung?

4.  **(mittel)** Zwei Gründer planen eine GmbH in Österreich und haben 8.000 EUR. Welche Mindestbareinzahlung gilt laut Nachrecherche, und wie könnte das Stammkapital aufgebracht werden?

5.  **(mittel)** Ein Gründerteam teilt Anteile 33/33/34 ohne Vesting. Nach 4 Monaten verlässt eine Person das Team. Beschreibe die Folgen und formuliere eine Verbesserung.

6.  **(praktisch)** Erweitere die Funktion `verdient` aus 2.7 um einen Parameter `good_leaver`: Ist er wahr, wird ein Mindestanteil von 25 % der bisher verdienten Anteile zusätzlich gewährt. Gib die Werte für Austritt nach 6, 18 und 36 Monaten aus.

7.  **(praktisch)** Schreibe ein Skript, das aus der Liste in 2.4 alle Aufgaben mit einer Frist in den nächsten 30 Tagen ausgibt.

8.  **(schwer/praktisch)** Erweitere das Programm aus 2.3 so, dass es zusätzlich den kritischen Pfad (die Schrittfolge, die die Gesamtdauer bestimmt) ausgibt.

## Lösungen zu den Übungsaufgaben Modul 02

**1.** Bei unbeschränkter Haftung (Einzelunternehmen) haftet die Person mit dem gesamten Privatvermögen, bei beschränkter Haftung (GmbH) grundsätzlich nur die Gesellschaft mit ihrem Vermögen und die Gesellschafter höchstens mit ihrer Einlage. Wichtig: Persönliche Haftung kann trotzdem entstehen, zum Beispiel durch Bürgschaften oder grobe Pflichtverletzungen.

**2.** Reverse Charge heißt, dass die Steuerschuld auf den Leistungsempfänger übergeht. Bei Dienstleistungen an Unternehmen in einem anderen EU-Staat (B2B) mit gültiger UID stellt der Anbieter die Rechnung ohne Umsatzsteuer aus und weist auf den Übergang der Steuerschuld hin. Der Kunde meldet die Steuer in seinem Land an.

**3.** Der Sitz ist der im Register eingetragene Ort, die tatsächliche Geschäftsleitung der Ort, an dem die wesentlichen Entscheidungen getroffen werden. Steuerrechtlich zählt oft die tatsächliche Leitung; ein Auslandssitz allein ändert die Besteuerung der Person im Inland nicht automatisch.

**4.** Laut Nachrecherche gilt seit 2024 ein Mindeststammkapital von 10.000 EUR, davon mindestens 5.000 EUR bar. Mit 8.000 EUR sind die 5.000 bar abgedeckt, für das Stammkapital fehlen 2.000 EUR. Möglichkeiten: weitere Bareinlage, Sacheinlage (zum Beispiel Ausrüstung, mit nachvollziehbarer Bewertung) oder die Gründung mit einem Teil der Stammeinlage erst später fällig zu stellen, soweit nach geltendem Recht zulässig. Die Details sind mit Notar oder Beratung zu klären.

**5.** Ohne Vesting behält die Person 33 % (oder 34 %) der Firma, obwohl sie kaum beigetragen hat; die Verbleibenden tragen die Arbeit, haben aber nur noch zwei Drittel der Anteile und sind in Verhandlungen mit Investoren benachteiligt. Verbesserung: Vesting über vier Jahre mit einem Jahr Cliff, Rückkaufsrecht zu einem niedrigen Preis für nicht verdiente Anteile und Good-/Bad-Leaver-Klauseln.

**6.** Eine mögliche Lösung:

```python
def verdient(anteil, monate, cliff=12, periode=48, good_leaver=False):
    if monate < cliff:
        basis = 0.0
    else:
        basis = anteil * min(monate, periode) / periode
    bonus = 0.25 * basis if good_leaver else 0.0
    return round(basis + bonus, 2)

for m in (6, 18, 36):
    print(m, verdient(40.0, m), verdient(40.0, m, good_leaver=True))
```

Die Ausgabe lautet für 40 Prozent Anteil: 6 Monate: 0,0 und 0,0 (die Cliff greift, der Bonus wirkt nur auf Verdientes); 18 Monate: 15,0 und 18,75; 36 Monate: 30,0 und 37,5. Das Beispiel zeigt eine mögliche Vertragsgestaltung; die Höhe des Bonus ist reine Verhandlungssache.

**7.** Mit dem Datumsmodul:

```python
from datetime import date, timedelta
heute = date(2026, 11, 1)
for p in pflichten:
    if not p["erledigt"] and heute <= p["frist"] <= heute + timedelta(days=30):
        print(p["was"], p["frist"])
```

Ergebnis: Nur die Gewerbeanmeldung (30. 11. 2026) liegt im Fenster; die Datenschutzerklärung ist bereits überfällig, der Versicherungsnachweis noch zu weit weg.

**8.** Man merkt sich für jeden Schritt den Vorgänger, der das späteste Ende hat, und geht vom letzten Schritt zurück:

```python
vorgaenger = {}
def fertig(name):
    if name not in ende:
        dauer, vor = schritte[name]
        start, v_best = 0, None
        for v in vor:
            if fertig(v) > start:
                start, v_best = fertig(v), v
        ende[name] = start + dauer
        vorgaenger[name] = v_best
    return ende[name]

gesamt = max(fertig(n) for n in schritte)
aktuell = max(ende, key=ende.get)
pfad = []
while aktuell:
    pfad.append(aktuell)
    aktuell = vorgaenger[aktuell]
print(" -> ".join(reversed(pfad)))
```

Der kritische Pfad lautet: Firmenwortlaut prüfen, Gesellschaftsvertrag, Beurkundung, Einzahlung und Bestätigung, Firmenbuchantrag, Steuer/SV-Anmeldung (26 Tage). Das Konto (7 Tage) läuft parallel und liegt nicht auf dem kritischen Pfad, verzögert die Einzahlung aber nur, wenn es länger als 9 Tage dauert.
