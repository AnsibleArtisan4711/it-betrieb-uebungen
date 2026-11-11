# Modul 07 - Finanzen, Buchhaltung, Steuern und Controlling

> **Hinweis zu diesem Kapitel:** Das ist das Kapitel des Skripts „Unternehmensgründung“, aus der LaTeX-Quelle in Markdown umgewandelt (Text und Codeblöcke unverändert, farbige Boxen als Zitatblöcke mit fettem Titel, Tabellen als Markdown-Tabellen). Die Lerneinheiten sind wie in der Quelle nach Modul nummeriert (7.1 bis 7.9), danach folgen „Übungsaufgaben zu Modul 07“ (8 Aufgaben, mit Schwierigkeitsangabe) und „Lösungen zu den Übungsaufgaben Modul 07“. Rechtliche und steuerliche Aussagen sind keine Rechtsberatung. Was ich an den Beispielen geprüft habe, steht in der [README des Repositories](../README.md). Übersicht zum Modul: [README](README.md).

**Dauer:** 8 h laut Modulübersicht (Summe der Einzelwerte: 9 × 0,9 h = 8,1 h, gerundet)

**Priorität:** 1 (höchste)

| **Nr.** | **Lerneinheit**                  | **Dauer (h)** |
|--------:|:---------------------------------|--------------:|
|     7.1 | Finanzplanung                    |           0,9 |
|     7.2 | Buchhaltung Setup                |           0,9 |
|     7.3 | Umsatzsteuer und Rechnungen      |           0,9 |
|     7.4 | Payroll und Founder Compensation |           0,9 |
|     7.5 | Kostenstruktur                   |           0,9 |
|     7.6 | SaaS Kennzahlen                  |           0,9 |
|     7.7 | Budget und Forecast              |           0,9 |
|     7.8 | Finanzkontrollen                 |           0,9 |
|     7.9 | Investor Reporting               |           0,9 |
|         | **Summe**                        |       **8,1** |

Ein Technikunternehmen scheitert selten daran, dass die Software nicht funktioniert, sondern daran, dass das Geld ausgeht, bevor der Markt es belohnt. Dieses Modul vermittelt das finanzielle Handwerkszeug, das Gründerinnen und Gründer ohne kaufmännische Ausbildung brauchen: Sie lernen, wie man die Zahlungsfähigkeit plant, wie die Buchhaltung grundsätzlich aufgebaut ist, was bei Rechnungen und Umsatzsteuer zu beachten ist, was die Gründerin oder der Gründer selbst kostet, wie sich Kosten und Kennzahlen eines Software-Abos ergeben und wie man all das regelmäßig kontrolliert und an Geldgeber berichtet. **Alle steuerlichen und rechtlichen Aussagen sind allgemeine Information und keine Rechtsberatung oder Steuerberatung.** Ein Steuerberater oder eine Steuerberaterin ist in Österreich für Jahresabschluss und Steuererklärungen praktisch unverzichtbar; dieses Modul macht Sie zu einem guten Gesprächspartner dafür. Die Programme laufen mit Python 3 ohne Zusatzpakete. Alle Zahlen sind erfundene Beispiele; Steuersätze und Grenzen stammen aus den im Quellenverzeichnis genannten, am 1. November 2026 abgerufenen Seiten oder sind ausdrücklich als Annahme gekennzeichnet.

## 7.1 Finanzplanung

Die *Finanzplanung* beantwortet eine einfache Frage: Wie viel Geld wird in den kommenden Monaten ein- und ausgehen, und reicht der Kontostand? Dabei muss man zwei Größen strikt trennen. Der *Gewinn* ist die Differenz aus Erträgen und Aufwänden einer Periode nach den Regeln der Buchhaltung; der *Cashflow* ist die tatsächliche Veränderung des Kontostands. Beides weicht regelmäßig voneinander ab. Wer im Dezember eine Rechnung über 12 000 Euro schreibt, hat im Dezember Umsatz, aber erst im Februar Geld, wenn der Kunde 60 Tage Zahlungsziel hat. Eine Firma kann also profitabel sein und trotzdem zahlungsunfähig werden. Deshalb steuern junge Unternehmen vor allem über den Cashflow.

Zwei Begriffe aus der Start-up-Welt gehören dazu. Der *Burn Rate* (kurz Burn) ist der monatliche Geldabfluss, den das Unternehmen aufbraucht; gemeint ist meist der *Netto-Burn*, also Ausgaben minus Einnahmen. Die *Runway* ist die Anzahl Monate, die das vorhandene Geld bei gleichbleibendem Burn reicht: Kassenstand geteilt durch Netto-Burn. Eine Runway von 18 Monaten gilt in vielen Finanzierungsrunden als komfortabel, unter 9 bis 12 Monaten wird es eng, weil eine neue Finanzierung selbst Monate dauert (Modul 08). Das sind Faustregeln der Branche, keine Gesetze.

Eine brauchbare Planung ist eine Tabelle mit einer Zeile je Monat, die aus wenigen Annahmen berechnet wird: Startkapital, Umsatz im ersten Monat, monatliches Wachstum, Fixkosten (Gehälter, Miete, Werkzeuge) und variable Kosten als Anteil am Umsatz (Zahlungsgebühren, Hosting). Das folgende Programm rechnet diese Planung über zwei Jahre und hält an, sobald die Kasse negativ wird.

```python
start_kasse = 250_000
umsatz = 12_000          # Umsatz im Monat 1
wachstum = 0.08          # 8 % pro Monat
kosten_fix = 38_000      # Gehaelter, Miete, Werkzeuge
kosten_var_quote = 0.15  # Zahlungsgebuehren, Hosting je Umsatz-Euro

kasse = start_kasse
for monat in range(1, 25):
    var = umsatz * kosten_var_quote
    netto = umsatz - kosten_fix - var
    kasse += netto
    if monat in (1, 6, 12, 18) or kasse < 0:
        print(f"Monat {monat:2d}: Umsatz {umsatz:8.0f}  Cashflow {netto:9.0f}  Kasse {kasse:9.0f}")
    if kasse < 0:
        print(f"Kasse erstmals negativ in Monat {monat}")
        break
    umsatz *= 1 + wachstum

burn_heute = kosten_fix + 12_000 * kosten_var_quote - 12_000
print("Burn Monat 1:", round(burn_heute), "-> Runway ohne Wachstum:", round(start_kasse / burn_heute, 1), "Monate")
```

Die Schleife läuft Monat für Monat. In jeder Runde werden die variablen Kosten als 15 Prozent des Umsatzes berechnet, der Cashflow als Umsatz minus Fixkosten minus variable Kosten, und die Kasse wird um den Cashflow verändert. Am Ende der Runde wächst der Umsatz um 8 Prozent. Ausgegeben werden nur ausgewählte Monate, damit die Tabelle lesbar bleibt. Im ersten Monat fließen 27 800 Euro ab, die Kasse sinkt von 250 000 auf 222 200 Euro. Obwohl der Umsatz wächst, ist der Cashflow auch im sechsten Monat mit −23 013 Euro negativ; im zwölften Monat ist die Kasse mit −12 433 Euro erstmals unter null. Die einfache Runway-Rechnung am Ende (250 000 geteilt durch 27 800) ergibt 9,0 Monate und ist damit pessimistischer als die Planung mit Wachstum, die erst im zwölften Monat ins Minus rutscht. Der Unterschied zeigt, wie stark das Ergebnis an der Wachstumsannahme hängt, und deshalb rechnet man mindestens drei Szenarien: ein *Downside*-Szenario (kein oder geringes Wachstum, Zahlungsverzug), ein *Base*-Szenario (die erwartete Entwicklung) und ein *Upside*-Szenario (die Pläne gehen auf). Im Programm genügt es dafür, die Annahmen `wachstum` und `umsatz` zu ändern und den Lauf zu wiederholen.

Typische Fehler sind, Umsatz mit Geldeingang zu verwechseln, Zahlungsziele zu ignorieren, Steuerzahlungen und Einmalkosten (Jahresabos, Versicherungen, Umsatzsteuer-Zahllast) zu vergessen und mit einem einzigen optimistischen Szenario zu planen. Falsch ist: „Wir haben 250 000 Euro und geben 28 000 aus, also reicht es neun Monate, und dann kommt Umsatz“. Richtig ist: Annahmen offenlegen, Szenarien rechnen und festlegen, ab welcher Kassenhöhe man handelt (zum Beispiel Kosten senken oder Finanzierung starten, sobald die Runway unter 12 Monate fällt).

> **Merke**
>
> Cashflow ist nicht Gewinn. Burn und Runway sind die wichtigsten Steuergrößen eines jungen Unternehmens. Eine Finanzplanung beruht auf offenen Annahmen und rechnet mindestens drei Szenarien.

> **Praxisbeispiel**
>
> Investoren verlangen in der Regel einen Finanzplan über drei bis fünf Jahre, im Detail mindestens für die ersten 18 bis 24 Monate. Wer die Annahmen als Tabelle pflegt und den Plan monatlich mit den echten Zahlen vergleicht (Lerneinheit 7.7), wirkt glaubwürdig.

## 7.2 Buchhaltung Setup

Die *Buchhaltung* hält alle Geschäftsvorfälle fest, damit man Vermögen, Schulden und Erfolg jederzeit nachweisen kann. In Österreich sind Kapitalgesellschaften wie die GmbH zur doppelten Buchführung verpflichtet; für kleine Einzelunternehmen genügen vereinfachte Aufzeichnungen (Einnahmen-Ausgaben-Rechnung), die Einzelheiten hängen von Rechtsform und Umsatz ab und sind mit dem Steuerberater zu klären (allgemeines Fachwissen, keine Rechtsberatung). Hier steht die doppelte Buchführung im Vordergrund, weil sie die Grundlage für Bilanz und Gewinn-und-Verlust-Rechnung (GuV) bildet.

Das Prinzip: Jeder Vorgang wird auf mindestens zwei *Konten* gebucht, einmal im *Soll* und einmal im *Haben*, mit demselben Betrag. Ein Konto ist eine Liste von Buchungen zu einem Thema, etwa „Bank“, „Forderungen“, „Umsatzerlöse“ oder „Mietaufwand“. Die Wörter Soll und Haben sind einfach die linke und die rechte Seite; sie bedeuten nicht „schuldet“ oder „besitzt“. Bestandskonten (Bank, Forderungen, Ausstattung) zeigen Vermögen und Schulden, Erfolgskonten (Erlöse, Aufwände) zeigen den Erfolg. Weil jeder Vorgang beide Seiten berührt, muss die Summe aller Soll-Buchungen gleich der Summe aller Haben-Buchungen sein. Diese Selbstkontrolle ist der Kern des Systems. Die Konten ordnet ein *Kontenrahmen*, in Österreich orientiert man sich meist am Einheitskontenrahmen; die genaue Kontenliste legt der Steuerberater passend fest.

Beim Aufsetzen sind einige Entscheidungen zu treffen: Welche Software (Online-Buchhaltung oder Steuerberater-System), wer erfasst Belege, wie werden Bankkonten angebunden, wie lange werden Belege aufbewahrt (in Österreich im Regelfall sieben Jahre; im Einzelfall prüfen) und wie wird der Monatsabschluss organisiert. Belege werden zeitnah digital abgelegt und mit der Buchung verknüpft.

Das Programm bucht fünf typische Vorgänge einer jungen GmbH und bildet daraus die Salden, wie eine Buchhaltungssoftware es im Hintergrund tut.

```python
buchungen = [
    # (Nr, Beschreibung, Soll-Konto, Haben-Konto, Betrag)
    (1, "Einzahlung Stammkapital",    "Bank",              "Stammkapital",      35_000.00),
    (2, "Kauf Laptop",                "Betriebsausstattung", "Bank",            2_400.00),
    (3, "Ausgangsrechnung Kunde A",   "Forderungen",       "Umsatzerloese",     10_000.00),
    (4, "Zahlungseingang Kunde A",    "Bank",              "Forderungen",       10_000.00),
    (5, "Miete Buero",                "Mietaufwand",       "Bank",              1_500.00),
]
salden = {}
for nr, text, soll, haben, betrag in buchungen:
    salden[soll] = salden.get(soll, 0) + betrag
    salden[haben] = salden.get(haben, 0) - betrag

for konto, saldo in sorted(salden.items()):
    seite = "Soll" if saldo >= 0 else "Haben"
    print(f"{konto:22s} {abs(saldo):10.2f} {seite}")
print("Summe aller Salden:", round(sum(salden.values()), 2), "(muss 0 sein)")
gewinn = -(salden["Umsatzerloese"] + salden["Mietaufwand"])
print("Ergebnis bisher:", gewinn)
```

Jede Buchung nennt ein Soll-Konto und ein Haben-Konto. Im Wörterbuch `salden` werden Soll-Beträge addiert und Haben-Beträge abgezogen. Positive Salden stehen deshalb im Soll, negative im Haben. Das Ergebnis zeigt: Die Bank hat 41 100 Euro im Soll (35 000 Stammkapital − 2 400 Laptop + 10 000 Zahlungseingang − 1 500 Miete). Die Forderung aus Buchung 3 ist durch Buchung 4 wieder ausgeglichen und steht auf null. Das Stammkapital und die Umsatzerlöse stehen im Haben. Die Summe aller Salden ist null, womit die Kontrolle bestanden ist. Das bisherige Ergebnis ist Umsatz 10 000 minus Miete 1 500, also 8 500 Euro. Man beachte, dass der Laptop das Ergebnis nicht sofort belastet: Er wird als Anlagevermögen erfasst und über seine Nutzungsdauer abgeschrieben (Abschreibung).

Typische Fehler: Belege nicht zeitnah erfassen, private und betriebliche Ausgaben auf demselben Konto mischen, Bank und Buchhaltung nie abstimmen und den Steuerberater erst im Jahresabschluss einschalten. Falsch: „Ich sammle die Belege in einer Schuhschachtel und gebe sie im März ab.“ Richtig: monatliche Erfassung, Bankabgleich und eine feste Frist, bis zu der Belege im System sind. So bleiben die Zahlen aktuell und man kann die Planung aus Lerneinheit 7.1 mit der Realität vergleichen.

> **Merke**
>
> Doppelte Buchführung heißt: Jeder Vorgang wird im Soll und im Haben mit demselben Betrag gebucht, daher ist die Gesamtsumme der Salden immer null. Bestandskonten zeigen Vermögen und Schulden, Erfolgskonten Erträge und Aufwände. Belege werden zeitnah und digital abgelegt.

> **Praxisbeispiel**
>
> Banken, Förderstellen und Investoren verlangen aktuelle Zahlen, oft die betriebswirtschaftliche Auswertung (BWA) des Vormonats. Ein Unternehmen mit monatlichem Abschluss kann diese Anfragen in Stunden beantworten, eines mit jährlichem Abschluss braucht Wochen.

## 7.3 Umsatzsteuer und Rechnungen

Die *Umsatzsteuer* (USt) ist eine Steuer auf den Verbrauch, die Unternehmen für den Staat einsammeln. Sie belastet wirtschaftlich nur den Endverbraucher: Das Unternehmen weist auf der Ausgangsrechnung die Steuer aus, führt sie ab und darf die Umsatzsteuer aus Eingangsrechnungen als *Vorsteuer* abziehen. Die Differenz aus eingenommener USt und abziehbarer Vorsteuer ist die *Zahllast*, die an das Finanzamt geht (bei Vorsteuerüberhang gibt es ein Guthaben). In Österreich beträgt der Normalsatz 20 Prozent, daneben gibt es ermäßigte Sätze (zum Beispiel 10 Prozent) für bestimmte Leistungen; welcher Satz gilt, hängt von der Leistung ab.

Bei Leistungen an Unternehmen in anderen EU-Staaten gilt oft das *Reverse-Charge-Verfahren*: Der Leistungsempfänger schuldet die Steuer, und die Rechnung enthält keine Umsatzsteuer, sondern einen Hinweis darauf; die UID-Nummer (Umsatzsteuer-Identifikationsnummer) beider Seiten ist anzugeben. Bei Verkäufen an Privatpersonen in anderen EU-Ländern greifen besondere Regeln, die über das One-Stop-Shop-Verfahren abgewickelt werden können (siehe Modul 02). Eine *Rechnung* muss gesetzlich bestimmte Angaben enthalten, unter anderem Name und Anschrift von Leistendem und Empfänger, Art und Umfang der Leistung, Zeitpunkt der Leistung, Entgelt, Steuersatz und Steuerbetrag, Ausstellungsdatum und eine fortlaufende Nummer; für höhere Beträge kommt die UID des Empfängers hinzu. Welche Grenzen gelten, ist im aktuellen Gesetzestext oder mit dem Steuerberater zu klären.

> **Ergänzung aus der Nachrecherche**
>
> Die Kleinunternehmerregelung befreit Unternehmen mit geringem Umsatz von der Umsatzsteuer. Laut dem Unternehmensserviceportal (USP) gilt seit 1. Jänner 2025 eine Grenze von 55 000 Euro Nettoumsatz pro Kalenderjahr (davor 35 000 Euro). Eine Toleranzgrenze erlaubt im Jahr des Überschreitens bis zu 10 Prozent mehr (60 500 Euro), im Folgejahr gilt die Befreiung nicht mehr. Kleinunternehmer stellen keine Umsatzsteuer in Rechnung und haben keinen Vorsteuerabzug; wer die Steuer dennoch gesondert ausweist, schuldet sie dem Finanzamt. Ein schriftlicher Verzicht auf die Befreiung (Option zur Steuerpflicht) bindet fünf Jahre (Quelle Q13; keine Rechtsberatung, Einzelfall und Ausnahmen prüfen). Für Technikgründungen ist die Regel selten die beste Wahl, weil der Vorsteuerabzug bei hohen Anfangsinvestitionen meist mehr bringt.

Das Programm rechnet eine Rechnung mit und ohne Umsatzsteuer, prüft einen Rechnungsentwurf auf fehlende Pflichtfelder und bestimmt den Kleinunternehmer-Status.

```python
from datetime import date

def rechnung(netto, satz=0.20):
    ust = round(netto * satz, 2)
    return netto, ust, round(netto + ust, 2)

print("Normalfall      :", rechnung(1_250.00))
print("Reverse Charge  :", rechnung(1_250.00, 0.0), "(Hinweis auf Steuerschuld des Leistungsempfaengers)")

PFLICHT = ["lieferant", "empfaenger", "leistung", "leistungsdatum", "netto", "steuersatz", "datum", "nummer"]
entwurf = {"lieferant": "Muster GmbH", "empfaenger": "Beispiel AG", "leistung": "Beratung",
           "netto": 1250.0, "steuersatz": 0.20, "datum": date(2026, 11, 3), "nummer": "2026-0042"}
fehlt = [feld for feld in PFLICHT if feld not in entwurf]
print("Fehlende Pflichtangaben:", fehlt)

def klein_status(umsatz_jahr, grenze=55_000):
    if umsatz_jahr <= grenze:
        return "befreit"
    if umsatz_jahr <= grenze * 1.10:
        return "befreit bis Jahresende (Toleranzgrenze), im Folgejahr steuerpflichtig"
    return "steuerpflichtig ab dem Umsatz, der die Grenze ueberschreitet"
for u in (48_000, 58_000, 63_000):
    print(u, "->", klein_status(u))
print("Toleranzgrenze:", round(55_000 * 1.10))
```

Die Funktion `rechnung` liefert Nettobetrag, Umsatzsteuer und Bruttobetrag und rundet auf Cent. Im Normalfall werden aus 1 250 Euro netto 250 Euro Steuer und 1 500 Euro brutto; im Reverse-Charge-Fall bleibt es bei 1 250 Euro. Die Pflichtfeld-Prüfung geht die Liste durch und meldet, dass im Entwurf das Leistungsdatum fehlt. Die Funktion `klein_status` kennt drei Fälle: Bis 55 000 Euro bleibt die Befreiung, bei 58 000 Euro liegt der Umsatz innerhalb der Toleranz von 60 500 Euro (befreit bis Jahresende, im Folgejahr steuerpflichtig), und bei 63 000 Euro endet die Befreiung ab dem Umsatz, mit dem die Grenze überschritten wird. Die genaue Berechnung dieses Zeitpunkts nimmt der Steuerberater vor.

Typische Fehler: Umsatzsteuer bei Auslandsleistungen falsch ausweisen, Rechnungen ohne Pflichtangaben stellen (dann droht der Vorsteuerabzug des Kunden zu entfallen), Belege für Vorsteuer nicht aufbewahren und die Umsatzsteuer-Zahllast nicht in der Liquiditätsplanung berücksichtigen. Falsch: Man behandelt eingenommene Umsatzsteuer als eigenes Geld. Richtig: Sie ist ein durchlaufender Posten, der der Kasse nicht gehört, und gehört im Plan als Abfluss zum Fälligkeitstermin.

> **Merke**
>
> Umsatzsteuer ist ein durchlaufender Posten: ausgewiesene USt minus Vorsteuer ergibt die Zahllast. Rechnungen brauchen gesetzliche Pflichtangaben. Reverse Charge und Kleinunternehmerregelung ändern die Ausweispflicht; Grenzen und Sonderfälle sind zu prüfen.

> **Praxisbeispiel**
>
> Rechnungsprogramme prüfen Pflichtfelder und vergeben fortlaufende Nummern automatisch. Bei SaaS-Verkäufen in mehrere EU-Länder lohnt es früh, die Umsatzsteuerlogik (Land, Kundenart, UID) im Bezahlsystem sauber abzubilden, denn nachträgliche Korrekturen sind teuer.

## 7.4 Payroll und Founder Compensation

*Payroll* meint die Lohn- und Gehaltsverrechnung: Aus dem Bruttobezug werden Abzüge für Sozialversicherung und Lohnsteuer ermittelt, die Auszahlung und die Meldungen an die Behörden erfolgen. Für Arbeitgeber ist wichtig, dass das Gehalt, das auf der Gehaltsabrechnung steht, nur einen Teil der echten Kosten ausmacht. Hinzu kommen *Lohnnebenkosten*: Dienstgeberanteile zur Sozialversicherung sowie weitere Beiträge und Abgaben. Wer die Kosten eines Teammitglieds plant, sollte mit einem Faktor auf das Bruttogehalt rechnen, der je nach Konstellation (Sonderzahlungen, Bundesland, Branche) abweicht.

> **Ergänzung aus der Nachrecherche**
>
> Laut einer WKO-Seite zu Lohnnebenkosten 2026 betragen der Dienstgeberbeitrag zum Familienlastenausgleichsfonds 3,9 Prozent der Beitragsgrundlage, der Zuschlag dazu 0,32 bis 0,40 Prozent je nach Bundesland, und die Kommunalsteuer 3 Prozent (Quelle Q15). Für die Sozialversicherung gibt die Seite keinen Prozentsatz an; im Beispiel unten wird deshalb **als Annahme** ein Dienstgeberanteil von 21 Prozent verwendet, der nicht aus einer abgerufenen Quelle stammt. Weitere Posten (Beitrag zur Mitarbeitervorsorge, Sonderzahlungen, Urlaubsrückstellung) fehlen hier. Für verbindliche Zahlen ist der aktuelle Beitragsgruppenschein bzw. der Steuerberater maßgeblich.

Das *Founder Compensation* genannte Thema betrifft die Bezahlung der Gründerinnen und Gründer selbst. In einer GmbH gibt es im Wesentlichen zwei Wege, Geld an die Gesellschafter zu bringen. Erstens ein Gehalt (als Geschäftsführer-Bezug oder Dienstverhältnis), das beim Unternehmen als Aufwand den Gewinn senkt und Lohnnebenkosten auslöst. Zweitens eine *Ausschüttung* aus dem versteuerten Gewinn. Der Gewinn unterliegt der Körperschaftsteuer, bei Ausschüttung fällt zusätzlich Kapitalertragsteuer an.

> **Ergänzung aus der Nachrecherche**
>
> Die WKO nennt für die Körperschaftsteuer 23 Prozent auf den Gewinn (ab 2024) und für die Kapitalertragsteuer auf Ausschüttungen 27,5 Prozent. Die Mindestkörperschaftsteuer für GmbH und FlexKap beträgt seit 1. Jänner 2024 125 Euro je Quartal, also 500 Euro im Jahr, und fällt auch ohne Gewinn an (Quelle Q14). Eine frühere Staffel („Gründungsprivileg“) wird auf derselben Seite im Zusammenhang mit den alten Beträgen erwähnt; nach der in Modul 02 verwendeten Quelle Q3 ist die Gründungsprivilegierung für Neugründungen weggefallen. Die aktuelle Lage ist mit dem Steuerberater zu klären. Keine Steuerberatung.

Das Programm rechnet beides: die Gesamtkosten eines Gehalts von 4 000 Euro brutto mit den oben genannten Sätzen und die Netto-Auszahlung einer Gewinnausschüttung.

```python
brutto = 4_000.00
sv_dg = 0.21        # ANNAHME fuer die Rechnung, nicht abgerufen
db = 0.039          # Dienstgeberbeitrag (WKO)
dz = 0.0036         # Zuschlag, je Bundesland 0,32-0,40 %: Beispielwert
kommst = 0.03       # Kommunalsteuer (WKO)

nebenkosten = brutto * (sv_dg + db + dz + kommst)
gesamt = brutto + nebenkosten
print(f"Bruttogehalt {brutto:.2f}  Nebenkosten {nebenkosten:.2f}  Gesamtkosten {gesamt:.2f}  Faktor {gesamt/brutto:.4f}")

def ausschuettung_netto(gewinn, koest=0.23, kest=0.275):
    nach_koest = gewinn * (1 - koest)
    return round(nach_koest * (1 - kest), 2)
netto = ausschuettung_netto(100)
print("Von 100 EUR Gewinn bleiben nach KoeSt und KESt:", netto, "-> Gesamtbelastung", round(100 - netto, 2), "%")
print("Mindest-KoeSt GmbH (125 EUR je Quartal):", 4 * 125, "EUR im Jahr")
```

Die Nebenkosten sind die Summe der vier Prozentsätze (21 plus 3,9 plus 0,36 plus 3 Prozent), angewendet auf das Bruttogehalt. Bei 4 000 Euro brutto ergeben sich 1 130,40 Euro Nebenkosten und 5 130,40 Euro Gesamtkosten, also ein Faktor von etwa 1,28. Die Annahme der Sozialversicherung wirkt sich stark aus: Ändert sich der Satz um einen Prozentpunkt, ändert sich das Ergebnis um 40 Euro. Die Ausschüttung zeigt: Von 100 Euro Gewinn bleiben nach 23 Prozent Körperschaftsteuer 77 Euro, und nach 27,5 Prozent Kapitalertragsteuer 55,82 Euro, die Gesamtbelastung beträgt 44,18 Prozent. Die Mindest-Körperschaftsteuer beträgt vier Quartale zu je 125, also 500 Euro im Jahr.

Typische Fehler: Gründer-Gehälter zu hoch ansetzen (die Runway schrumpft), zu niedrig (sozialversicherungsrechtliche und steuerliche Folgen), Ausschüttungen ohne ausreichende Gewinne und Rücklagen, und Lohnnebenkosten in der Planung vergessen. Falsch: „Ich zahle mir 4 000 Euro, die Firma kostet das 4 000 Euro.“ Richtig: mit dem Faktor rechnen und die Bezüge mit Steuerberater festlegen. Mitarbeiterbeteiligungen (Optionen, Phantom Shares) sind ein eigenes Thema und werden in Modul 08 behandelt.

> **Merke**
>
> Die echten Kosten eines Gehalts liegen deutlich über dem Bruttobetrag. Gehalt und Ausschüttung werden steuerlich unterschiedlich behandelt; Körperschaftsteuer und Kapitalertragsteuer verteuern die Ausschüttung. Sätze und Annahmen sind offen zu legen und regelmäßig zu prüfen.

> **Praxisbeispiel**
>
> Bei Start-ups ohne Umsatz zahlen sich Gründerinnen und Gründer oft nur ein niedriges Gehalt, das ihren Lebensunterhalt knapp deckt. Investoren erwarten das, schauen aber darauf, dass die Vergütung angemessen und dokumentiert ist, und fragen später auch nach der Gehaltsstruktur des Teams.

## 7.5 Kostenstruktur

Die *Kostenstruktur* beschreibt, wie sich die Kosten eines Unternehmens zusammensetzen und wie sie auf Umsatzänderungen reagieren. *Fixkosten* fallen unabhängig von der Menge an (Gehälter, Miete, Basiswerkzeuge); *variable Kosten* wachsen mit Umsatz oder Nutzung (Zahlungsgebühren, Hosting pro Nutzer, Provisionen). Dazu kommen *Einmalkosten* (Gründung, Zertifizierungen) und *sprungfixe Kosten*, die ab einer bestimmten Menge sprunghaft wachsen, etwa ein zusätzlicher Support-Mitarbeiter ab 1 000 Kunden. Wer diese Struktur kennt, kann Fragen wie „Ab wann verdienen wir Geld?“ oder „Wie viel kostet uns ein weiterer Kunde?“ beantworten.

Zentral ist der *Deckungsbeitrag*: Preis minus variable Kosten pro Einheit. Er zeigt, wie viel jede verkaufte Einheit zur Deckung der Fixkosten beiträgt. Der *Break-even-Punkt* ist die Menge, bei der die Deckungsbeiträge die Fixkosten genau decken, also Fixkosten geteilt durch Deckungsbeitrag pro Einheit. Wichtig ist auch die *Bruttomarge*: Anteil des Umsatzes, der nach den direkten Kosten der Leistungserbringung übrig bleibt. Bei Software liegt sie oft hoch, aber nur, wenn Infrastruktur- und Supportkosten sauber zugeordnet sind.

```python
import math
preis = 49.0
variabel = 9.0
fix = 18_000.0
db_marge = preis - variabel
print("Deckungsbeitrag je Kunde und Monat:", db_marge, " Quote:", round(db_marge / preis, 3))
be = math.ceil(fix / db_marge)
print("Break-even-Kunden:", be, " Umsatz:", be * preis)
for kunden in (300, 450, 600):
    ergebnis = kunden * db_marge - fix
    print(f"{kunden} Kunden -> Ergebnis {ergebnis:8.0f}")
# Sicherheitsabstand
plan = 600
print("Sicherheitsabstand:", round((plan - be) / plan * 100, 1), "%")
```

Der Deckungsbeitrag je Kunde und Monat ist 49 minus 9, also 40 Euro, das sind 81,6 Prozent des Preises. Der Break-even liegt bei 18 000 geteilt durch 40, also 450 Kunden, mit einem Monatsumsatz von 22 050 Euro. Die Schleife zeigt es anschaulich: Bei 300 Kunden fehlen 6 000 Euro, bei 450 Kunden ist das Ergebnis null, bei 600 Kunden bleiben 6 000 Euro. Planen wir mit 600 Kunden, liegt der Break-even 25 Prozent darunter; dieser *Sicherheitsabstand* sagt, wie viel schlechter es laufen darf, bevor es Verluste gibt. Die Funktion `math.ceil` rundet auf, denn es gibt keine halben Kunden und man muss die Schwelle mindestens erreichen.

Typische Fehler: variable Kosten unterschätzen (Supportzeit, Zahlungsgebühren, Rabatte, Gratis-Nutzer), Fixkosten als „nicht änderbar“ behandeln und Skaleneffekte unkritisch annehmen. Falsch: „Pro Kunde kostet uns Hosting nur 2 Euro, also sind wir bei 90 Prozent Marge.“ Richtig: alle Kosten pro Kunde zusammenrechnen, einschließlich Supportzeit und Zahlungsgebühren. Preis und Kostenstruktur gehören zusammen (Modul 03, Pricing). Bei Cloud-Diensten ist der Verbrauch ein eigener variabler Kostenblock: Er wächst mit Nutzung und Datenmenge und sollte pro Kunde und pro Funktion ausgewertet werden (Modul 05, Cloud-Betrieb). Einsparungen ohne Produktverlust findet man typischerweise bei überdimensionierten Servern, ungenutzten Ressourcen und Lizenzen, vergessenen Testumgebungen und nicht verhandelten Verträgen, bevor man an Funktionen oder Support spart.

> **Merke**
>
> Fixkosten, variable Kosten und sprungfixe Kosten verhalten sich unterschiedlich. Der Deckungsbeitrag ist Preis minus variable Kosten, der Break-even ist Fixkosten geteilt durch Deckungsbeitrag. Ein Sicherheitsabstand zeigt, wie robust der Plan ist.

> **Praxisbeispiel**
>
> Bei Verhandlungen über Preise oder Rabatte hilft die Rechnung: Wie viele Kunden muss ein Rabatt von 20 Prozent zusätzlich bringen, damit der Deckungsbeitrag insgesamt gleich bleibt? Das Ergebnis überrascht oft.

## 7.6 SaaS Kennzahlen

Software-as-a-Service-Unternehmen (SaaS) leben von wiederkehrenden Einnahmen, und ihre Kennzahlen drehen sich darum. Der *MRR* (Monthly Recurring Revenue) ist der monatlich wiederkehrende Umsatz aus Abonnements, der *ARR* (Annual Recurring Revenue) der auf ein Jahr hochgerechnete Wert, also MRR mal 12. Der MRR verändert sich durch Neukunden (*New MRR*), Zusatzkäufe bestehender Kunden (*Expansion*) und Kündigungen oder Downgrades (*Churn*). Die *Churn Rate* misst, wie viel verloren geht, entweder nach Kunden oder nach Umsatz. Die *Net Revenue Retention* (NRR) gibt an, wie viel Umsatz vom Anfang des Zeitraums am Ende noch da ist, einschließlich Expansion und abzüglich Churn; Werte über 100 Prozent bedeuten, dass die Bestandskunden mehr zahlen als zuvor.

Dazu kommen Kennzahlen zur Wirtschaftlichkeit. Der *ARPA* (Average Revenue per Account) ist der durchschnittliche Umsatz je Kunde. Die *CAC* (Customer Acquisition Cost) sind die Kosten für die Gewinnung eines Neukunden (Marketing und Vertrieb geteilt durch neue Kunden). Der *LTV* (Lifetime Value) ist der Beitrag, den ein Kunde während seiner Laufzeit liefert, vereinfacht ARPA mal Bruttomarge geteilt durch die Churn Rate. Das Verhältnis LTV zu CAC gilt als Gesundheitsmaß; in der Branche werden Werte um oder über 3 als gut angesehen, das ist eine Faustregel und kein Gesetz. Die *Payback-Zeit* gibt an, nach wie vielen Monaten ein Neukunde seine Akquisitionskosten zurückgezahlt hat.

```python
mrr_start = 40_000.0
neu = 6_000.0
expansion = 1_500.0
churn = 1_600.0
mrr_ende = mrr_start + neu + expansion - churn
kunden_start, kunden_neu, kunden_verloren = 800, 120, 36
print("MRR Ende:", mrr_ende, " ARR:", mrr_ende * 12)
print("Kunden-Churn:", round(kunden_verloren / kunden_start * 100, 2), "%")
print("Umsatz-Churn:", round(churn / mrr_start * 100, 2), "%")
nrr = (mrr_start + expansion - churn) / mrr_start
print("NRR:", round(nrr * 100, 1), "%")
arpa = mrr_ende / (kunden_start + kunden_neu - kunden_verloren)
print("ARPA:", round(arpa, 2))
marge = 0.80
churn_rate = kunden_verloren / kunden_start
ltv = arpa * marge / churn_rate
cac = 21_600 / kunden_neu
print("LTV:", round(ltv), " CAC:", round(cac), " LTV/CAC:", round(ltv / cac, 1))
print("Payback in Monaten:", round(cac / (arpa * marge), 1))
```

Der MRR beginnt bei 40 000 Euro. Neukunden bringen 6 000, Expansion 1 500, Kündigungen kosten 1 600; der MRR am Ende ist 45 900 Euro, der ARR 550 800 Euro. Verloren wurden 36 von 800 Kunden, das sind 4,5 Prozent Kunden-Churn; im Umsatz sind es 1 600 von 40 000, also 4,0 Prozent. Dass beide Werte verschieden sind, ist normal, weil gekündigte Kunden meist kleiner sind als der Durchschnitt. Die NRR beträgt (40 000 plus 1 500 minus 1 600) geteilt durch 40 000, also 99,8 Prozent: Der Bestand schrumpft knapp. Der ARPA beträgt 51,92 Euro (45 900 geteilt durch 884 Kunden am Ende). Mit einer angenommenen Bruttomarge von 80 Prozent ergibt sich ein LTV von rund 923 Euro, bei einer CAC von 180 Euro (21 600 Euro Marketing und Vertrieb geteilt durch 120 Neukunden) ein Verhältnis von 5,1 und eine Payback-Zeit von 4,3 Monaten. Man beachte, dass der LTV hier mit dem monatlichen Churn des Zeitraums gerechnet wird; er reagiert sehr empfindlich auf diese Rate.

Typische Fehler: Kennzahlen uneinheitlich definieren (jedes Team rechnet MRR anders), Einmalumsätze in den MRR mischen, Churn nur nach Kunden betrachten und die CAC ohne Gehälter im Vertrieb berechnen. Falsch: „Unsere Churn liegt bei 4,5 Prozent, das ist okay.“ Richtig: den monatlichen Wert mit den Jahreswerten vergleichen (4,5 Prozent monatlich entspricht über 40 Prozent Verlust pro Jahr) und prüfen, ob Expansion den Verlust ausgleicht. Definitionen werden schriftlich festgehalten und bei Investorengesprächen gleich verwendet.

> **Merke**
>
> MRR und ARR sind die Basis, Churn und NRR zeigen die Qualität des Bestands, LTV zu CAC und Payback die Wirtschaftlichkeit des Wachstums. Definitionen müssen einheitlich und dokumentiert sein; Richtwerte sind Faustregeln.

> **Praxisbeispiel**
>
> In einer Finanzierungsrunde sind diese Kennzahlen das Gerüst jeder Datenraum-Präsentation (Modul 08). Ein sauberer Kennzahlenbericht aus dem Abrechnungssystem ist glaubwürdiger als eine Tabelle, die jemand nebenbei gepflegt hat.

## 7.7 Budget und Forecast

Ein *Budget* ist ein Plan in Zahlen, den man für einen festen Zeitraum, meist das Geschäftsjahr, beschließt; es legt fest, wie viel Geld für welche Zwecke vorgesehen ist. Ein *Forecast* (Prognose) ist die laufend aktualisierte Erwartung, wie das Jahr tatsächlich enden wird. Das Budget bleibt als Maßstab stehen, der Forecast wandert mit den Fakten. Beim *rollierenden Forecast* wird er jeden Monat oder jedes Quartal um den nächsten Zeitraum erweitert, sodass man immer zwölf Monate vorausschaut.

Die wichtigste Technik im *Controlling* (der laufenden Steuerung mit Zahlen) ist die *Abweichungsanalyse*: Man vergleicht Ist-Zahlen mit dem Budget je Kostenstelle, rechnet die Abweichung absolut und in Prozent und untersucht die großen. Wichtig ist, dass nicht nur Überschreitungen, sondern auch Unterschreitungen auffallen: Wenn das Marketing-Budget zu 69 Prozent genutzt wurde, kann das Sparsamkeit sein oder ein Zeichen, dass ein geplantes Wachstum nicht stattfindet. Die Schwelle für Rückfragen legt man vorab fest, etwa zehn Prozent.

```python
budget = {"Entwicklung": 120_000, "Marketing": 45_000, "Vertrieb": 60_000, "Verwaltung": 25_000}
ist    = {"Entwicklung": 126_500, "Marketing": 31_000, "Vertrieb": 66_300, "Verwaltung": 24_200}
for stelle in budget:
    abw = ist[stelle] - budget[stelle]
    proz = abw / budget[stelle] * 100
    flag = "  <-- pruefen" if abs(proz) >= 10 else ""
    print(f"{stelle:12s} Budget {budget[stelle]:8d}  Ist {ist[stelle]:8d}  Abw {abw:7d} ({proz:+5.1f} %){flag}")
print("Summe Abweichung:", sum(ist.values()) - sum(budget.values()))

# Forecast nach drei von zwoelf Monaten: Run-Rate fortschreiben
monate_vergangen = 3
hochrechnung = {k: v / monate_vergangen * 12 for k, v in ist.items()}
print("Jahresprognose gesamt:", round(sum(hochrechnung.values())), " Jahresbudget gesamt:", sum(budget.values()) * 4)
```

Die Wörterbücher `budget` und `ist` enthalten die Zahlen je Kostenstelle für das erste Quartal. Für jede Stelle wird die Abweichung berechnet und, wenn sie zehn Prozent erreicht, mit einem Hinweis markiert. Entwicklung liegt mit 6 500 Euro (5,4 Prozent) über Plan, im Rahmen. Marketing liegt mit −14 000 Euro (−31,1 Prozent) deutlich unter Plan, und Vertrieb mit 10,5 Prozent darüber; beides sollte hinterfragt werden. Die Summe der Abweichungen ist nur −2 000 Euro und verdeckt damit die großen Einzelabweichungen, ein klassischer Grund, auf Ebene der Kostenstellen zu schauen. Die einfache Jahresprognose schreibt die Quartalswerte mit dem Faktor vier fort: 992 000 Euro gegenüber dem hier angenommenen Jahresbudget von 1 000 000 Euro. Eine solche Hochrechnung ist nur ein Ausgangspunkt, denn Einmalkosten, Saisonalität und Wachstum werden ignoriert.

Typische Fehler: Budget einmal im Jahr schreiben und dann ignorieren, Abweichungen nur sammeln statt mit Verantwortlichen zu besprechen und den Forecast nicht an Entscheidungen koppeln. Falsch: Man ändert das Budget nachträglich, bis die Abweichung verschwindet. Richtig: Das Budget bleibt unverändert als Maßstab, der Forecast zeigt die neue Erwartung, und Abweichungen führen zu Entscheidungen (Kosten senken, Ziel anpassen, Mittel umschichten).

> **Merke**
>
> Budget ist der Plan, Forecast die aktuelle Erwartung. Abweichungsanalyse erfolgt je Kostenstelle, in Euro und Prozent, mit festen Schwellen. Der rollierende Forecast schaut immer zwölf Monate voraus.

> **Praxisbeispiel**
>
> Ein monatlicher Controlling-Termin von 45 bis 60 Minuten mit Geschäftsführung und Bereichsverantwortlichen, der Zahlen, Abweichungen und Maßnahmen bespricht, genügt für junge Unternehmen. Entscheidend ist, dass Entscheidungen protokolliert werden.

## 7.8 Finanzkontrollen

*Finanzkontrollen* sind Regeln und Abläufe, die verhindern, dass Geld durch Fehler oder Betrug verloren geht. Das Ziel ist nicht Misstrauen, sondern Schutz: Auch ehrliche Menschen machen Tippfehler, überweisen doppelt oder fallen auf Betrugsmails herein. Die klassischen Bausteine sind das *Vier-Augen-Prinzip* (kritische Vorgänge erfordern eine zweite Person), die *Funktionstrennung* (wer eine Zahlung vorbereitet, gibt sie nicht frei), *Freigabegrenzen* (höhere Beträge brauchen höhere Freigabestufen) und der *Dreifachabgleich* (Bestellung, Lieferung und Rechnung müssen zusammenpassen). Hinzu kommen regelmäßige Kontenabstimmungen und Zugriffsrechte auf Bank und Buchhaltung (Modul 06, IAM).

Typische Bedrohungen sind doppelt bezahlte Rechnungen, geänderte Bankverbindungen durch gefälschte E-Mails (Zahlungsumleitung, „CEO-Fraud“), nicht autorisierte Ausgaben und fehlende Belege. Gegenmaßnahmen sind Rückruf bei Änderung von Bankdaten über eine bekannte Telefonnummer, Freigaben im System statt per E-Mail und ein dokumentierter Ablauf für Spesen und Kreditkarten.

Das Programm prüft eine Zahlungsliste auf Freigabegrenzen und Funktionstrennung und sucht doppelte Rechnungen.

```python
LIMITS = {"mitarbeiter": 500, "teamleitung": 5_000, "geschaeftsfuehrung": 50_000}
zahlungen = [
    {"id": 1, "betrag": 480,    "freigabe": ["mitarbeiter"], "ersteller": "anna"},
    {"id": 2, "betrag": 4_200,  "freigabe": ["mitarbeiter"], "ersteller": "ben"},
    {"id": 3, "betrag": 12_000, "freigabe": ["teamleitung", "geschaeftsfuehrung"], "ersteller": "cleo"},
    {"id": 4, "betrag": 900,    "freigabe": ["teamleitung"], "ersteller": "cleo", "freigeber": "cleo"},
]
def noetige_stufe(betrag):
    for stufe, grenze in LIMITS.items():
        if betrag <= grenze:
            return stufe
    return "geschaeftsfuehrung"
RANG = list(LIMITS)
for z in zahlungen:
    soll = noetige_stufe(z["betrag"])
    hoechste = max(RANG.index(s) for s in z["freigabe"])
    probleme = []
    if hoechste < RANG.index(soll):
        probleme.append(f"Freigabe zu niedrig (noetig: {soll})")
    if z.get("freigeber") == z["ersteller"]:
        probleme.append("Ersteller gibt selbst frei (Vier-Augen-Prinzip verletzt)")
    print(z["id"], "OK" if not probleme else "; ".join(probleme))

rechnungen = [("LiefA", "R-100", 1200.0), ("LiefB", "R-77", 300.0), ("LiefA", "R-100", 1200.0)]
gesehen = set()
for lief, nr, betrag in rechnungen:
    if (lief, nr, betrag) in gesehen:
        print("Doppelte Rechnung:", lief, nr)
    gesehen.add((lief, nr, betrag))
```

Die Grenzen sind als geordnetes Wörterbuch hinterlegt, `noetige_stufe` liefert die niedrigste Stufe, die den Betrag freigeben darf. Danach wird für jede Zahlung geprüft, ob die höchste vorhandene Freigabe mindestens der nötigen Stufe entspricht und ob der Ersteller sich nicht selbst freigegeben hat. Zahlung 1 (480 Euro) ist in Ordnung, Zahlung 2 (4 200 Euro) wurde nur von einem Mitarbeiter freigegeben, nötig wäre die Teamleitung. Zahlung 3 (12 000 Euro) hat Teamleitung und Geschäftsführung und ist in Ordnung. Bei Zahlung 4 hat die Ersteller-Person selbst freigegeben, was gegen das Vier-Augen-Prinzip verstößt. Der zweite Teil merkt sich Kombinationen aus Lieferant, Rechnungsnummer und Betrag in einer Menge und meldet, dass die Rechnung R-100 von LiefA doppelt vorliegt.

Typische Fehler: Zu lockere Grenzen, weil „es sonst zu langsam ist“, Freigaben, die per E-Mail oder Chat ohne Nachweis erfolgen, gleiche Person für Anlage von Lieferanten und Zahlung, Bankzugänge auf persönliche Geräte ohne Schutz. Falsch: „Ich vertraue meinem Team, wir brauchen keine Kontrollen.“ Richtig: Kontrollen wirken ohne Misstrauen, indem sie Fehler abfangen; bei kleinen Teams kann die Geschäftsführung die zweite Freigabe sein, und externe Prüfungen ergänzen sie.

> **Merke**
>
> Vier-Augen-Prinzip, Funktionstrennung, Freigabegrenzen und Abgleiche schützen vor Fehlern und Betrug. Änderungen von Bankdaten werden über einen zweiten Kanal bestätigt. Freigaben sind nachweisbar zu dokumentieren.

> **Praxisbeispiel**
>
> Investoren, Förderstellen und Wirtschaftsprüfer fragen bei Prüfungen nach Freigabeprozessen, Zugriffsrechten auf Bank und Buchhaltung und nach der Behandlung von Spesen. Ein kurzes, gelebtes Regelwerk überzeugt mehr als ein langes, das niemand kennt.

## 7.9 Investor Reporting

Wer Geld von Investoren erhält, schuldet ihnen regelmäßige Berichte. Das *Investor Reporting* fasst Geschäftsstand, Kennzahlen, Cashflow, Erreichtes, Risiken und Bedarf an Unterstützung zusammen, meist als monatliches oder quartalsweises Update per E-Mail oder in einem Berichtsdokument. Ein gutes Reporting schafft Vertrauen, hilft bei Folgefinanzierungen und zwingt das Team, selbst klar zu sehen, wo es steht. Die Inhalte entsprechen weitgehend den Kennzahlen aus den vorigen Lerneinheiten: MRR und Wachstum, Burn und Runway, Kundenzahl und Churn, dazu eine kurze Erzählung (Highlights, Lowlights, Ziele des nächsten Zeitraums, konkrete Bitten um Hilfe). Der Bericht deckt vier Felder ab: Finanzen (Umsatz, Cashflow, Runway), Produkt (ausgelieferte Funktionen, Qualität), Sales (Pipeline, abgeschlossene Verträge) und Risiken (offene Probleme, Abhängigkeiten, Fristen). Für ein Board oder einen Beirat wird derselbe Bericht ausführlicher mit Entscheidungsvorlagen aufbereitet.

Die Struktur sollte stabil bleiben, damit Leser Veränderungen schnell erkennen. Wichtig ist die Ehrlichkeit: Schlechte Nachrichten gehören früh in den Bericht, denn Investoren schätzen Offenheit und helfen eher, als wenn sie von Problemen aus anderen Quellen erfahren. Zahlen müssen aus derselben Quelle stammen wie die Buchhaltung und das Abrechnungssystem, damit sie zu Prüfungen im Rahmen einer Due Diligence passen (Modul 08).

```python
daten = {"mrr": 52_000.0, "mrr_vormonat": 48_000.0, "kasse": 84_000.0,
         "kosten": 64_000.0, "einnahmen": 55_000.0, "kunden": 920, "churn_kunden": 18}
burn = daten["kosten"] - daten["einnahmen"]
runway = daten["kasse"] / burn
wachstum = (daten["mrr"] / daten["mrr_vormonat"] - 1) * 100
churn = daten["churn_kunden"] / daten["kunden"] * 100
bericht = [
    f"MRR: {daten['mrr']:,.0f} EUR (+{wachstum:.1f} % ggue. Vormonat)",
    f"ARR: {daten['mrr']*12:,.0f} EUR",
    f"Netto-Burn: {burn:,.0f} EUR/Monat, Runway: {runway:.1f} Monate",
    f"Kunden: {daten['kunden']}, monatlicher Churn: {churn:.2f} %",
]
print("\n".join(bericht))
warnungen = []
if runway < 12: warnungen.append("Runway unter 12 Monaten: Finanzierung vorbereiten")
if churn > 2: warnungen.append("Churn ueber 2 %: Ursachen pruefen")
print("Warnungen:", warnungen or "keine")
```

Das Programm berechnet aus den Rohwerten die Berichtszahlen: Der MRR ist von 48 000 auf 52 000 Euro gewachsen, das sind 8,3 Prozent, der ARR beträgt 624 000 Euro. Der Netto-Burn ist Kosten minus Einnahmen, also 9 000 Euro im Monat; bei einem Kassenstand von 84 000 Euro ergibt sich eine Runway von 9,3 Monaten. Der monatliche Kunden-Churn beträgt 18 von 920, also 1,96 Prozent. Ein kleiner Regelblock erzeugt Warnungen, hier den Hinweis, dass die Runway unter zwölf Monaten liegt und die Finanzierung vorbereitet werden sollte. Der Churn liegt knapp unter der Schwelle von 2 Prozent und löst deshalb keine Warnung aus; solche Schwellenwerte sind Vereinbarungen, die das Team festlegt, keine allgemeinen Grenzen.

Typische Fehler: Berichte nur bei guten Nachrichten, wechselnde Definitionen, Zahlen aus verschiedenen Quellen ohne Abstimmung, zu lange Berichte, die niemand liest. Falsch: im Update zwei Monate lang keine Zahlen zu nennen, bis die Runde ansteht. Richtig: monatlich, kurz (eine Seite), mit denselben fünf bis acht Kennzahlen und einer Liste konkreter Bitten. Hinweis: Weitergabe vertraulicher Kennzahlen an Dritte ist durch Vertraulichkeitsvereinbarungen geschützt (Modul 11).

> **Merke**
>
> Investor Reporting schafft Vertrauen: regelmäßig, kurz, mit gleichbleibenden Kennzahlen und ehrlich auch bei schlechten Nachrichten. Die Zahlen stammen aus abgestimmten Quellen und passen zur Buchhaltung.

> **Praxisbeispiel**
>
> Viele Start-ups schicken am Monatsanfang ein Update mit Kennzahlen, Highlights, Lowlights, Zielen und Bitten. Diese Routine hilft zugleich als Vorbereitung auf Folgerunden: Das Datenraum-Material (Modul 08) entsteht fast nebenbei.

## Übungsaufgaben zu Modul 07

1.  **(leicht)** Erkläre den Unterschied zwischen Gewinn und Cashflow und gib ein Beispiel, in dem ein profitables Unternehmen zahlungsunfähig wird.

2.  **(leicht)** Ein Unternehmen kauft einen Laptop für 2 400 Euro auf Rechnung (noch nicht bezahlt). Auf welchen Konten wird im Soll und im Haben gebucht?

3.  **(leicht)** Ein Einzelunternehmer erzielt 58 000 Euro Nettoumsatz in einem Kalenderjahr. Ist er nach der Kleinunternehmerregelung (Grenze laut Q13) im selben Jahr noch befreit? Was gilt im Folgejahr?

4.  **(mittel)** Preis 79 Euro, variable Kosten 14 Euro, Fixkosten 26 000 Euro im Monat. Wie viele Kunden braucht das Unternehmen für den Break-even?

5.  **(mittel)** ARPA 60 Euro, Bruttomarge 75 Prozent, monatlicher Kunden-Churn 2 Prozent, CAC 900 Euro. Berechne LTV, LTV zu CAC und Payback-Zeit.

6.  **(praktisch)** Schreibe ein Programm, das eine Liste von Buchungen mit je getrenntem Soll- und Haben-Betrag prüft und Buchungen meldet, bei denen beide Beträge nicht übereinstimmen.

7.  **(praktisch)** Schreibe ein Programm, das eine Rechnung mit Positionen zu 20 und 10 Prozent Umsatzsteuer auswertet und Nettosumme und Steuer je Steuersatz sowie den Bruttobetrag ausgibt.

8.  **(schwer/praktisch)** Erweitere die Finanzplanung aus 7.1 um eine einmalige Investition von 30 000 Euro in Monat 4. In welchem Monat wird die Kasse erstmals negativ?

## Lösungen zu den Übungsaufgaben Modul 07

**1.** Der Gewinn ist die Differenz aus Erträgen und Aufwänden einer Periode, der Cashflow die tatsächliche Veränderung des Kontostands. Schreibt ein Unternehmen im Dezember Rechnungen über 100 000 Euro (Umsatz und Gewinn), zahlen die Kunden aber erst nach 60 bis 90 Tagen, während Gehälter und Miete sofort fließen, sinkt die Kasse trotz Gewinn und kann negativ werden.

**2.** Soll: Betriebsausstattung 2 400 Euro, Haben: Verbindlichkeiten 2 400 Euro. Der Kauf erhöht das Vermögen und zugleich die Schulden; die Bank wird erst bei der Zahlung angesprochen (Soll: Verbindlichkeiten, Haben: Bank). Die Umsatzsteuer ist in dieser Aufgabe vernachlässigt.

**3.** Im selben Jahr ja: Die Grenze liegt bei 55 000 Euro, aber die Toleranzgrenze von 10 Prozent (60 500 Euro) wird nicht überschritten, daher bleibt die Befreiung bis Jahresende. Im Folgejahr ist die Befreiung nicht mehr anwendbar, weil die Grenze überschritten wurde. Einzelheiten und Ausnahmen sind mit dem Steuerberater zu klären.

**4.** Deckungsbeitrag 79 minus 14, also 65 Euro. Break-even: 26 000 geteilt durch 65, also genau 400 Kunden.

**5.** LTV = 60 mal 0,75 geteilt durch 0,02 = 2 250 Euro. LTV zu CAC = 2 250 geteilt durch 900 = 2,5. Payback = 900 geteilt durch (60 mal 0,75) = 20 Monate. Das Verhältnis liegt unter dem Richtwert 3, und 20 Monate sind für ein Abo mit 2 Prozent Churn lang; hier lohnt es sich, CAC zu senken oder die Bindung zu verbessern.

**6.** Mögliche Lösung:

```python
buchungen = [
    (1, "Einzahlung", "Bank", "Stammkapital", 35_000.00, 35_000.00),
    (2, "Kauf Laptop", "Betriebsausstattung", "Bank", 2_400.00, 2_040.00),
]
for nr, text, soll, haben, soll_betrag, haben_betrag in buchungen:
    if round(soll_betrag - haben_betrag, 2) != 0:
        print(f"Buchung {nr} ({text}): Soll {soll_betrag} != Haben {haben_betrag}, Differenz {soll_betrag - haben_betrag:.2f}")
    else:
        print(f"Buchung {nr} ({text}): ausgeglichen")
```

Die Schleife entpackt jede Buchung und vergleicht die Beträge mit `round`, um Fließkomma-Rundungsfehler zu vermeiden. Buchung 2 hat Soll 2 400, Haben 2 040: Ein Zahlendreher, Differenz 360 Euro, wird erkannt.

**7.** Mögliche Lösung:

```python
positionen = [("Beratung", 1000.0, 0.20), ("Buch", 40.0, 0.10), ("Workshop", 600.0, 0.20)]
summe_netto, summe_ust = {}, {}
for text, netto, satz in positionen:
    summe_netto[satz] = summe_netto.get(satz, 0) + netto
    summe_ust[satz] = summe_ust.get(satz, 0) + round(netto * satz, 2)
for satz in sorted(summe_netto, reverse=True):
    print(f"Satz {satz:.0%}: netto {summe_netto[satz]:8.2f}  USt {summe_ust[satz]:7.2f}")
print("Brutto gesamt:", sum(summe_netto.values()) + sum(summe_ust.values()))
```

Die Positionen werden nach Steuersatz zusammengefasst. Für 20 Prozent ergeben sich 1 600 Euro netto und 320 Euro Steuer, für 10 Prozent 40 Euro netto und 4 Euro Steuer. Brutto gesamt: 1 640 plus 324, also 1 964 Euro.

**8.** Mögliche Lösung:

```python
kasse, umsatz = 250_000, 12_000
for monat in range(1, 25):
    netto = umsatz - 38_000 - umsatz * 0.15
    kasse += netto
    if monat == 4:
        kasse -= 30_000
    if kasse < 0:
        print("Kasse erstmals negativ in Monat", monat, "Stand", round(kasse))
        break
    umsatz *= 1.08
```

Mit der zusätzlichen Investition sinkt die Kasse früher unter null: in Monat 10 (Stand rund −12 237 Euro) statt in Monat 12. Die Investition kostet also etwa zwei Monate Runway, was man bei der Entscheidung bewusst abwägen muss.
