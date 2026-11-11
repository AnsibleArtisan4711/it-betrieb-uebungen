# Modul 12 - Skalierung, Internationalisierung, Exit und Resilienz

> **Hinweis zu diesem Kapitel:** Das ist das Kapitel des Skripts „Unternehmensgründung“, aus der LaTeX-Quelle in Markdown umgewandelt (Text und Codeblöcke unverändert, farbige Boxen als Zitatblöcke mit fettem Titel, Tabellen als Markdown-Tabellen). Die Lerneinheiten sind wie in der Quelle nach Modul nummeriert (12.1 bis 12.9), danach folgen „Übungsaufgaben zu Modul 12“ (8 Aufgaben, mit Schwierigkeitsangabe) und „Lösungen zu den Übungsaufgaben Modul 12“. Rechtliche und steuerliche Aussagen sind keine Rechtsberatung. Was ich an den Beispielen geprüft habe, steht in der [README des Repositories](../README.md). Übersicht zum Modul: [README](README.md).

**Dauer:** 10 h laut Modulübersicht (Summe der Einzelwerte: 9 × 1,1 h = 9,9 h, gerundet)

**Priorität:** 2

| **Nr.** | **Lerneinheit**              | **Dauer (h)** |
|--------:|:-----------------------------|--------------:|
|    12.1 | EU-Skalierungsstrategie      |           1,1 |
|    12.2 | Internationalisierung        |           1,1 |
|    12.3 | Enterprise Readiness         |           1,1 |
|    12.4 | Kostenoptimierung            |           1,1 |
|    12.5 | Resilienz und BCDR           |           1,1 |
|    12.6 | Strategische Partnerschaften |           1,1 |
|    12.7 | M&A und Exit Optionen        |           1,1 |
|    12.8 | Scaleup Governance           |           1,1 |
|    12.9 | Abschlussroadmap             |           1,1 |
|         | **Summe**                    |       **9,9** |

Das letzte Modul schaut nach vorn: Was kommt, wenn das Unternehmen funktioniert? Es geht um Wachstum über Ländergrenzen, um die Anforderungen großer Kunden, um schlanke Kosten, um die Fähigkeit, Störungen zu überstehen, um Partnerschaften, um mögliche Wege zum Ausstieg und um die Frage, wie man ein größer werdendes Unternehmen führt. Zum Schluss steht eine Roadmap, die alle Module zusammenführt. Das Modul setzt Kenntnisse aus fast allen vorherigen Modulen voraus, insbesondere Modul 03 (Markteintritt), 05 (Betrieb), 06 (Sicherheit), 07 (Finanzen), 08 (Finanzierung) und 11 (Verträge und Risiken). **Alle rechtlichen und steuerlichen Aussagen sind allgemeine Information und keine Rechtsberatung.** Die Programme laufen mit Python 3 ohne Zusatzpakete; alle Zahlen sind erfundene Beispiele. Steuersätze in den Beispielen sind ausdrücklich erfundene Platzhalter.

## 12.1 EU-Skalierungsstrategie

Die EU ist rechtlich ein Binnenmarkt, wirtschaftlich aber ein Mosaik: Sprachen, Gewohnheiten, Zahlungsarten, Vertriebskulturen und Wettbewerber unterscheiden sich von Land zu Land. Die Skalierungsstrategie entscheidet, wie man damit umgeht. Zwei Grundmodelle stehen sich gegenüber. Beim Modell *Land für Land* betritt man einen Markt nach dem anderen, mit eigener lokaler Ansprache, eigenem Vertrieb und Support. Das erlaubt gezieltes Lernen und begrenzt das Risiko, kostet aber mit jedem Land zusätzlich ähnlich viel. Beim Modell *zentrale Plattform* baut man einmal eine Infrastruktur (mehrsprachiges Produkt, zentrale Abrechnung, Support, Vertrieb aus der Ferne und über Partner) und fügt Länder mit geringen Zusatzkosten hinzu. Das verlangt höhere Vorabinvestitionen und funktioniert besser bei standardisierten Produkten mit wenig lokalem Bedarf.

> **Ergänzung aus der Nachrecherche**
>
> Zur rechtlichen Seite des Binnenmarkts: Die Europäische Kommission hat am 18. März 2026 den Vorschlag für ein „28. Regime“ (EU Inc.) vorgelegt, das eine einheitliche europäische Gesellschaftsform ohne Mindestkapital und mit Gründung in 48 Stunden für 100 Euro vorsieht. Laut dem Beitrag von Eubelius (14. April 2026) ist das ein Vorschlag im Gesetzgebungsverfahren und noch kein geltendes Recht (Quelle Q1). Bis zum Inkrafttreten gelten weiterhin die nationalen Gesellschaftsformen (Modul 02).

Für die Wahl der Länder genügt ein einfaches Bewertungsmodell mit Marktgröße, Eintrittsaufwand, Sprache und vorhandenen Kunden (vorhandene Kunden sind der beste Beleg für Bedarf).

```python
maerkte = {
    #            Marktgroesse (Mio EUR), Eintrittsaufwand (1 leicht - 5 schwer), Sprache gleich?, bestehende Kunden
    "Oesterreich": (120, 1, True,  14),
    "Deutschland": (900, 2, True,  6),
    "Frankreich":  (700, 4, False, 1),
    "Niederlande": (250, 3, False, 2),
}
def score(groesse, aufwand, sprache, kunden):
    return groesse / 100 * 2 + (3 if sprache else 0) + kunden * 0.5 - aufwand * 2
rangliste = sorted(maerkte.items(), key=lambda kv: -score(*kv[1]))
for name, werte in rangliste:
    print(f"{name:12s} Score {score(*werte):5.1f}")
print("Reihenfolge:", " -> ".join(n for n, _ in rangliste))

# Land fuer Land: Kosten steigen mit der Zahl der Maerkte; Plattform: hoher Fixaufwand, geringe Zusatzkosten
land_fuer_land = lambda n: 150_000 * n
plattform = lambda n: 400_000 + 40_000 * n
for n in (1, 2, 3, 4, 5):
    print(f"{n} Maerkte: Land-fuer-Land {land_fuer_land(n):>8,}  Plattform {plattform(n):>8,}")
```

Die Funktion `score` gewichtet die Marktgröße (zwei Punkte je 100 Millionen Euro), gibt drei Punkte für gleiche Sprache und einen halben Punkt je vorhandenem Kunden und zieht zwei Punkte je Stufe Eintrittsaufwand ab. Deutschland führt mit 20,0 Punkten vor Österreich (10,4), Frankreich (6,5) und den Niederlanden (0,0). Die Gewichte sind Annahmen und das Ergebnis eine Diskussionsgrundlage. Der zweite Teil vergleicht die Kosten beider Modelle: Land für Land kostet 150 000 Euro je Markt, die Plattform 400 000 Euro Aufbau plus 40 000 Euro je Markt. Bei einem und bis zu drei Märkten ist der Länderansatz günstiger (zum Beispiel 450 000 gegenüber 520 000 Euro bei drei Märkten); ab vier Märkten gewinnt die Plattform (560 000 gegenüber 600 000 Euro). Die Kostenfunktionen sind erfunden, aber das Muster ist typisch: hohe Fixkosten, niedrige Grenzkosten.

Typische Fehler: zu viele Märkte gleichzeitig, Markteintritt ohne lokale Referenzkunden, Übersetzung als reine Textaufgabe (Kultur, Preise, Beispiele und Rechtstexte sind ebenfalls lokal), Plattform bauen, bevor ein Markt belegt ist. Falsch: Man startet in fünf Ländern gleichzeitig, weil der Binnenmarkt es erlaubt. Richtig: Erst im Heimatmarkt und einem nahen Markt Produkt-Markt-Fit belegen, dann in Wellen expandieren und aus jedem Schritt lernen. Welche Vertriebsform zum Land passt (Direktvertrieb, Partner, Marktplatz), hängt von Kaufverhalten und Wettbewerb ab (Modul 09).

> **Merke**
>
> Land für Land begrenzt das Risiko, die zentrale Plattform senkt die Grenzkosten ab einer gewissen Zahl von Märkten. Länder werden nach Marktgröße, Aufwand, Sprache und vorhandenen Kunden priorisiert. Expansion erfolgt in Wellen und erst nach belegtem Produkt-Markt-Fit.

> **Praxisbeispiel**
>
> Ein günstiger Test vor der Expansion ist eine kleine Pilotkampagne mit lokalisierter Landing Page und ein paar Kundengesprächen. Das zeigt Interesse und Preisakzeptanz, bevor man in Vertrieb und Support investiert.

## 12.2 Internationalisierung

Hinter jedem neuen Land steht eine Liste praktischer Fragen. *Sprache*: Genügt Englisch, oder erwarten Kunden eine lokale Oberfläche, lokalen Support und lokale Verträge? *Recht*: Welche Pflichten gelten für Verbraucher- und Unternehmensverträge, Datenschutz, Werbung, Branchenregeln? *Steuern*: Umsatzsteuer, mögliche Registrierungs- oder Meldepflichten, Quellensteuer, Betriebsstätten (feste Niederlassung kann Steuerpflichten auslösen, wenn Personal vor Ort arbeitet). *Zahlungsarten*: In manchen Ländern erwarten Kunden Überweisung, Lastschrift oder lokale Bezahlverfahren statt Kreditkarte. *Partner*: Wer kennt den Markt und kann Vertrieb, Einführung oder Support übernehmen? Für Umsatzsteuer bei Verkäufen an Privatkunden in der EU gibt es das One-Stop-Shop-Verfahren (Modul 02); die Einzelheiten sind mit dem Steuerberater zu klären.

Weil diese Liste lang ist, braucht man eine *Priorisierung nach Risiko*: Welche offenen Punkte können den Markteintritt scheitern lassen (zum Beispiel fehlende rechtliche Zulässigkeit), und welche sind nur lästig (zum Beispiel fehlende Übersetzung der Hilfeseiten)?

```python
maerkte = {
    "Land A": {"sprache": True,  "mwst_satz": 0.20, "zahlarten": ["Karte", "SEPA"], "rechtsprueung": True, "partner": True},
    "Land B": {"sprache": False, "mwst_satz": 0.19, "zahlarten": ["Karte"],          "rechtsprueung": False, "partner": False},
    "Land C": {"sprache": False, "mwst_satz": 0.21, "zahlarten": ["Karte", "iDeal-aehnlich"], "rechtsprueung": True, "partner": True},
}
LOKAL = {"Land C": "iDeal-aehnlich"}
nettopreis = 100.0
for name, m in maerkte.items():
    brutto = nettopreis * (1 + m["mwst_satz"])
    offen = []
    if not m["sprache"]: offen.append("Lokalisierung")
    if not m["rechtsprueung"]: offen.append("Rechtspruefung")
    if name in LOKAL and LOKAL[name] not in m["zahlarten"]: offen.append("lokale Zahlart")
    if not m["partner"]: offen.append("Partnersuche")
    risiko = len(offen)
    print(f"{name}: Brutto {brutto:6.2f} (Beispielsatz {m['mwst_satz']:.0%}), offen: {offen or '-'}  Risiko-Punkte: {risiko}")
```

Das Programm bewertet drei erfundene Märkte. Aus dem Nettopreis von 100 Euro entsteht der Bruttopreis mit einem *Beispielsatz* je Land (hier erfundene Prozentsätze von 20, 19 und 21 Prozent, keine echten Steuersätze) und es sammelt offene Punkte. Land A hat keine offenen Punkte (Brutto 120,00 Euro). Land B (119,00 Euro) hat drei offene Punkte: Lokalisierung, Rechtsprüfung und Partnersuche, also drei Risiko-Punkte. Land C (121,00 Euro) braucht nur Lokalisierung; die lokale Zahlart ist dort schon vorhanden. Die Anzahl der offenen Punkte ist ein grobes Maß; wichtiger ist, welche davon blockieren. Rechtsprüfung und Steuern sind fast immer Voraussetzung, Übersetzungen lassen sich schrittweise nachholen.

Typische Fehler: Bruttopreise ohne Rücksicht auf lokale Steuern und Preiserwartungen, lokale Zahlarten vergessen (die Abbruchrate beim Bezahlen steigt), Datenschutz und Verträge nur im Heimatland geprüft, Verträge nur auf Englisch. Falsch: Man stellt in allen Ländern denselben Bruttopreis ein. Richtig: Preise pro Markt bewusst festlegen (Netto, Brutto, Währung) und die Preiswahrnehmung testen. Rechtlich gelten bei Verbrauchergeschäften oft zwingend die Regeln des Kundenlandes, bei Unternehmensverträgen ist Rechtswahl häufiger möglich; beides ist zu prüfen.

> **Merke**
>
> Internationalisierung prüft Sprache, Recht, Steuern, Zahlungsarten und Partner je Markt. Risiken werden nach Blockierwirkung priorisiert. Preise, Verträge und Zahlarten werden pro Markt bewusst gestaltet.

> **Praxisbeispiel**
>
> Eine Länder-Checkliste, die jeder neue Markt abarbeitet, vermeidet, dass Wissen bei einer Person liegt. Sie wird nach jedem Markteintritt aktualisiert.

## 12.3 Enterprise Readiness

Wer Großkunden gewinnen will, begegnet einem anderen Einkaufsprozess: Statt eines Fachbereichs, der per Kreditkarte entscheidet, prüfen *Beschaffung*, *IT-Sicherheit*, *Datenschutz*, *Recht* und *Finanzen* den Anbieter. Das dauert länger und verlangt Nachweise. *Enterprise Readiness* bedeutet, auf diese Prüfungen vorbereitet zu sein: Sicherheitsfragebögen beantworten, Zertifizierungen vorlegen (häufig ISO 27001 oder SOC 2), SLA und Verfügbarkeit nachweisen, ein belastbares Vertragswerk mit Haftungsregeln und Auftragsverarbeitung anbieten (Modul 11) und die Anforderungen der Beschaffung erfüllen (zum Beispiel Lieferantenregistrierung, Versicherungsnachweise, Referenzen).

> **Ergänzung aus der Nachrecherche**
>
> Regulatorische Fristen verstärken diese Anforderungen. Nach der KPMG-Analyse zum österreichischen NISG 2026 (Quelle Q7) gelten dort die Meldefristen von 24 Stunden (Frühwarnung), 72 Stunden und einem Monat sowie eine Registrierung und Selbstdeklaration; die Analyse nennt das Gesetz als ab 1. Oktober 2026 geltend. Für Hersteller von Produkten mit digitalen Elementen gelten nach der Kommission (Quelle Q8) seit 11. September 2026 Meldepflichten für aktiv ausgenutzte Schwachstellen und schwere Vorfälle. Als Einschätzung (nicht aus diesen Quellen): Kunden, die selbst solche Pflichten haben, werden von Zulieferern zunehmend Nachweise über Sicherheitsmaßnahmen, Meldewege und Lieferkettenkontrolle verlangen. Anwendbarkeit und Fristen sind im Einzelfall zu prüfen (keine Rechtsberatung).

Planung braucht Realismus über Zeit und Aufwand. Das Programm beantwortet zwei Fragen: Wie vollständig ist ein typischer Sicherheitsfragebogen schon abgedeckt, und wie lang wird der Verkaufszyklus?

```python
fragebogen = {"Sicherheit": 42, "Datenschutz": 31, "Verfuegbarkeit/SLA": 18, "Recht/Vertrag": 25, "Finanzen": 12}
beantwortet = {"Sicherheit": 38, "Datenschutz": 31, "Verfuegbarkeit/SLA": 12, "Recht/Vertrag": 19, "Finanzen": 12}
for bereich, n in fragebogen.items():
    print(f"{bereich:20s} {beantwortet[bereich]:2d}/{n:2d} = {beantwortet[bereich] / n:5.0%}")
print(f"Gesamt: {sum(beantwortet.values())}/{sum(fragebogen.values())} = {sum(beantwortet.values()) / sum(fragebogen.values()):.0%}")

phasen = [("Erstgespraech", 14), ("Sicherheitspruefung", 30), ("Rechtspruefung/Vertrag", 45), ("Einkauf/Beschaffung", 30), ("Pilot", 60)]
gesamt = sum(t for _, t in phasen)
print(f"Verkaufszyklus: {gesamt} Tage = {gesamt / 30:.1f} Monate")
kosten_pro_tag = 350
print(f"Kosten des Vertriebs bei {kosten_pro_tag} EUR/Tag: {gesamt * kosten_pro_tag:,} EUR")
```

Der Fragebogen hat fünf Bereiche mit der Zahl der Fragen und der Zahl bereits vorbereiteter Antworten. Sicherheit ist zu 90 Prozent abgedeckt (38 von 42), Datenschutz und Finanzen zu 100 Prozent, Verfügbarkeit und SLA nur zu 67 Prozent (12 von 18) und Recht und Vertrag zu 76 Prozent (19 von 25). Insgesamt sind 112 von 128 Fragen beantwortet, das sind 88 Prozent. Die Lücken liegen bei SLA und Recht, also bei Themen, die Betrieb und Verträge verbinden. Der zweite Teil addiert die Dauer der Einkaufsphasen: 14 Tage Erstgespräch, 30 Tage Sicherheitsprüfung, 45 Tage Rechtsprüfung, 30 Tage Beschaffung und 60 Tage Pilot ergeben 179 Tage, also etwa sechs Monate. Bei einem angenommenen Vertriebsaufwand von 350 Euro pro Tag entstehen Kosten von 62 650 Euro je Abschluss. Das zeigt, warum Enterprise-Vertrieb einen hohen Auftragswert braucht.

Typische Fehler: Zertifizierungen starten, ohne dass Kontrollen gelebt werden (Modul 06), Verkaufszyklen zu kurz planen, bei jeder Anfrage von vorn beginnen, Sicherheitsfragebögen von Vertrieb und Technik getrennt beantworten lassen. Falsch: „Für den Großkunden bauen wir alles bis Quartalsende.“ Richtig: Anforderungen mit dem Kunden vorab klären, was zwingend ist, und realistische Zeitpläne einplanen. Ein zentraler Antwortbaukasten mit Standardantworten, Dokumenten und einem Trust Center beschleunigt jede Prüfung.

> **Merke**
>
> Enterprise Readiness umfasst Sicherheit, Datenschutz, SLA, Verträge und Beschaffungsanforderungen. Verkaufszyklen dauern Monate und verlangen Nachweise; ein zentraler Antwortbaukasten und gelebte Kontrollen verkürzen sie.

> **Praxisbeispiel**
>
> Die ersten Großkunden prägen die Roadmap. Lohnend ist es, deren Anforderungen (SSO, Rechtekonzept, Audit-Logs, Datenresidenz) als wiederverwendbare Produktfunktionen zu bauen, nicht als Sonderlösung.

## 12.4 Kostenoptimierung

Mit wachsendem Unternehmen wachsen auch die Kosten, oft schneller als der Umsatz. *Kostenoptimierung* heißt nicht blind sparen, sondern verstehen, wo Geld hinfließt und welche Ausgaben Wert erzeugen. Die großen Blöcke sind *Cloud* (Infrastruktur, Verbrauch), *Tools* (Software-Abonnements), *Personal* (meist der größte Posten, Modul 07 und 10) und *Vertrieb und Marketing* (Modul 09). In der Cloud entstehen Einsparungen durch passende Dimensionierung, Abschalten ungenutzter Ressourcen, Reservierungen für planbare Last und Optimierung der Datenhaltung; bei Tools durch Bestandsaufnahme der Abonnements und Zusammenlegung; bei Personal durch bessere Produktivität und Priorisierung statt Abbau; im Vertrieb durch bessere Kanalwahl und Konzentration auf die rentabelsten Segmente.

Damit Optimierung Teil der Führung wird, nutzt man *Effizienzkennzahlen*. Die *Rule of 40* addiert Wachstumsrate und Ergebnismarge; ein Wert ab 40 Prozent gilt in der SaaS-Branche als gesund (Faustregel). Der *Burn Multiple* setzt den Netto-Burn ins Verhältnis zum neu gewonnenen wiederkehrenden Umsatz: je niedriger, desto effizienter das Wachstum. Die *Magic Number* misst, wie viel neuer ARR je investiertem Euro in Vertrieb und Marketing entsteht.

```python
arr, arr_vorjahr = 1_800_000, 1_200_000
wachstum = arr / arr_vorjahr - 1
marge = 0.12                                   # Ergebnismarge (Free-Cashflow oder EBITDA, hier als Beispielwert)
print(f"Wachstum {wachstum:.0%}, Marge {marge:.0%}, Rule of 40 = {(wachstum + marge) * 100:.0f}")

netto_neu_arr = 600_000
burn_netto = 900_000
print(f"Burn Multiple: {burn_netto / netto_neu_arr:.2f}")
vertrieb_marketing_vorquartal = 300_000
neu_arr_quartal = 150_000
print(f"Magic Number: {neu_arr_quartal / vertrieb_marketing_vorquartal:.2f}")

kosten = {"Cloud": 18_000, "Tools": 9_000, "Personal": 120_000, "Vertrieb/Marketing": 32_000}
umsatz_monat = 150_000
for k, v in sorted(kosten.items(), key=lambda x: -x[1]):
    print(f"{k:20s} {v:8,d}  {v / umsatz_monat:5.1%} des Umsatzes")
kunden = 1_000
print(f"Cloud-Kosten je Kunde: {kosten['Cloud'] / kunden:.2f} EUR/Monat")
```

Das Unternehmen wuchs von 1,2 Millionen auf 1,8 Millionen Euro ARR, also um 50 Prozent, bei einer Marge von 12 Prozent (Beispielwert), die Rule of 40 ergibt 62. Der Burn Multiple beträgt 900 000 geteilt durch 600 000 neuen ARR, also 1,50: Für jeden Euro neuen ARR werden 1,50 Euro verbrannt. Die Magic Number ist 150 000 geteilt durch 300 000, also 0,50: Ein Euro Vertriebs- und Marketingausgabe bringt 0,50 Euro neuen ARR. Beide Werte sind kein Urteil, sondern Ausgangspunkte für Vergleiche mit der eigenen Entwicklung. Die Kostenverteilung zeigt Personal mit 80,0 Prozent des Monatsumsatzes von 150 000 Euro, Vertrieb und Marketing mit 21,3 Prozent, Cloud mit 12,0 und Tools mit 6,0 Prozent. Die Summe von 179 000 Euro liegt über dem Umsatz, der Monat ist also defizitär. Bei 1 000 Kunden kostet die Cloud 18,00 Euro je Kunde und Monat; diese Größe vergleicht man mit dem Preis, um die Bruttomarge zu verstehen (Modul 07).

Typische Fehler: pauschale Kürzungen, die Wachstum und Qualität treffen; Einsparungen ohne Messung; einmalige Aktionen statt dauerhafter Gewohnheit; Cloud-Kosten ohne Zuordnung zu Kunden und Funktionen. Falsch: „Wir streichen alle Marketingausgaben.“ Richtig: Zuerst Daten sammeln (Kosten pro Kunde, Kanal, Funktion), dann dort sparen, wo Ausgaben keine Wirkung zeigen, und Wachstumstreiber schützen. Verbrauchsbasierte Abrechnung mit Budgets und Warnschwellen verhindert Überraschungen.

> **Merke**
>
> Kostenoptimierung beginnt mit Transparenz: Kosten werden Kunden, Funktionen und Kanälen zugeordnet. Rule of 40, Burn Multiple und Magic Number verknüpfen Kosten und Wachstum. Gespart wird dort, wo Ausgaben keine Wirkung haben, nicht pauschal.

> **Praxisbeispiel**
>
> Ein vierteljährlicher „Kosten-Review“ mit Cloud-Rechnung, Tool-Liste und Vertriebskosten (je 30 Minuten) deckt vergessene Abonnements und überdimensionierte Ressourcen auf; die Einsparungen finanzieren oft neue Funktionen.

## 12.5 Resilienz und BCDR

*Resilienz* ist die Fähigkeit, Störungen zu überstehen und schnell wieder arbeitsfähig zu sein. *BCDR* fasst zwei Teile zusammen: *Business Continuity* (Geschäftsfortführung: Wie läuft das Geschäft weiter, wenn etwas ausfällt?) und *Disaster Recovery* (Wiederherstellung: Wie bekommen wir Systeme und Daten zurück?). Die Grundlage ist eine Analyse der *kritischen Prozesse*: Welche Abläufe müssen unbedingt laufen (Kundenzugang, Abrechnung, Support), welche Systeme und Personen hängen daran, und wie lange darf ein Ausfall dauern?

Zwei Kennzahlen machen das konkret. Das *RTO* (Recovery Time Objective) ist die höchste tolerierbare Ausfallzeit, nach der ein System wieder laufen muss. Das *RPO* (Recovery Point Objective) ist der höchste tolerierbare Datenverlust, gemessen in Zeit. Aus dem RPO folgt das Sicherungsintervall: Soll höchstens eine Stunde Daten verloren gehen, muss mindestens stündlich gesichert werden. Das RTO bestimmt die Wiederanlaufstrategie. Außerdem braucht es einen *Notbetrieb*: einen einfachen Ersatzprozess (etwa manuelle Abrechnung oder Statusseite für Kunden), solange die Systeme nicht laufen, und *regelmäßige Restore-Tests*, denn ein Backup, dessen Wiederherstellung nie geprobt wurde, ist nur eine Hoffnung.

```python
systeme = [
    # (System, RTO in Stunden, RPO in Stunden, Backup-Intervall in Stunden, letzter Restore-Test in Tagen)
    ("Kundendatenbank", 4,  1, 1,  20),
    ("Dokumentenablage", 24, 24, 24, 200),
    ("Abrechnung",      8,  4, 24, 95),
    ("Wiki",            72, 24, 168, None),
]
MAX_TESTALTER = 90
for name, rto, rpo, intervall, test in systeme:
    probleme = []
    if intervall > rpo:
        probleme.append(f"Backup alle {intervall} h, erlaubt {rpo} h Datenverlust")
    if test is None:
        probleme.append("nie getestet")
    elif test > MAX_TESTALTER:
        probleme.append(f"Restore-Test {test} Tage alt")
    print(f"{name:17s} RTO {rto:2d} h  RPO {rpo:2d} h ", "OK" if not probleme else "; ".join(probleme))
```

Für vier Systeme sind RTO, RPO, Sicherungsintervall und das Alter des letzten Restore-Tests in Tagen angegeben. Die Prüfung meldet zwei Arten von Problemen: ein Sicherungsintervall über dem RPO und einen Restore-Test, der älter als 90 Tage ist oder nie stattfand. Die Kundendatenbank (stündliche Sicherung bei RPO 1 Stunde, Test vor 20 Tagen) ist in Ordnung. Die Dokumentenablage hat zwar passende Sicherung, aber einen 200 Tage alten Test. Die Abrechnung wird nur täglich gesichert, obwohl höchstens vier Stunden Verlust erlaubt sind, und der Test ist 95 Tage alt. Beim Wiki wird nur wöchentlich (alle 168 Stunden) gesichert, obwohl 24 Stunden erlaubt wären, und es wurde nie getestet. Die Auswertung macht deutlich, dass die Anforderungen (RPO, RTO) und die Realität erst durch Prüfung zusammenkommen.

Typische Fehler: Backups ohne Restore-Test, Backups im selben Konto wie die Produktion (bei einem Angriff mit weg), kein Plan für Ausfall von Schlüsselpersonen, Notfallpläne, die nicht mehr aktuell sind, und Notfallkontakte, die niemand kennt. Falsch: „Der Cloud-Anbieter hat ja Backups.“ Richtig: Eigenverantwortung prüfen (Modell der geteilten Verantwortung, Modul 06), eigene Backups getrennt aufbewahren und mindestens jährlich einen realistischen Wiederanlauf üben. Die Ergebnisse fließen in das Risikoregister (Modul 11) und in Kundennachweise (Lerneinheit 12.3).

> **Merke**
>
> Resilienz heißt: kritische Prozesse kennen, RTO und RPO festlegen, Sicherungen darauf auslegen, einen Notbetrieb definieren und die Wiederherstellung regelmäßig testen. Ein nicht getestetes Backup gilt nicht als Backup.

> **Praxisbeispiel**
>
> Eine halbtägige Übung („Game Day“), in der das Team den Ausfall eines wichtigen Dienstes durchspielt und Zeiten misst, liefert die ehrlichsten Zahlen und ist zugleich ein Nachweis für Kunden und Prüfer.

## 12.6 Strategische Partnerschaften

Die Vertriebspartner aus Modul 09 sind ein Spezialfall. *Strategische Partnerschaften* reichen weiter: Sie betreffen *Cloud-Anbieter* (Co-Selling, Förderprogramme, Marktplätze, technische Unterstützung), *Systemintegratoren* (Einführung großer Projekte), *Branchenpartner* (Verbände, Plattformen, Datenlieferanten) und *Technologiepartner* (gemeinsame Produkte, Integrationen). Die Erwartung ist eine Wirkung, die man allein nicht erreichen würde: Reichweite, Glaubwürdigkeit, Zugang zu Großkunden oder Technologie.

Zwei Steuerungsgrößen sind wichtig. Der *Partner-ROI* vergleicht den vermittelten Umsatz mit den Kosten der Partnerschaft (Provision, Enablement, Zeit). Die *Abhängigkeit* misst, wie stark das Geschäft an einem Partner hängt: Fällt ein Partner weg oder ändert seine Bedingungen, kann das ein großer Teil des Umsatzes sein. Ein gängiges Maß für Konzentration ist der *Herfindahl-Index*: Man summiert die Quadrate der Anteile; je höher der Wert (maximal 1), desto stärker die Konzentration.

> **Ergänzung aus der Nachrecherche**
>
> Die EU-Regeln zum Anbieterwechsel bei Datenverarbeitungsdiensten (Data Act) betreffen auch die Abhängigkeit von Cloud-Anbietern. Laut DLA Piper (31. Juli 2025) gilt der Data Act seit 12. September 2025, mit höchstens zwei Monaten Kündigungsfrist für Wechselwillige und ohne Wechselentgelte bei SaaS bis 12. Jänner 2027 (Quelle Q5; keine Rechtsberatung). Wer von einem Cloud-Anbieter abhängt, sollte diese Wechselrechte kennen und die Datenexport-Fähigkeit prüfen.

```python
partner = {
    "Cloud-Marktplatz":   {"umsatz": 180_000, "kosten": 27_000, "anteil_an_gesamtumsatz": 0.30},
    "Systemintegrator X": {"umsatz": 120_000, "kosten": 24_000, "anteil_an_gesamtumsatz": 0.20},
    "Branchenverband":    {"umsatz": 30_000,  "kosten": 3_000,  "anteil_an_gesamtumsatz": 0.05},
}
for n, p in partner.items():
    roi = (p["umsatz"] - p["kosten"]) / p["kosten"]
    print(f"{n:19s} ROI {roi:4.1f}  Anteil {p['anteil_an_gesamtumsatz']:.0%}")

kanaele = {"Direkt": 0.45, "Cloud-Marktplatz": 0.30, "Systemintegrator X": 0.20, "Branchenverband": 0.05}
hhi = sum(a * a for a in kanaele.values())
print(f"Konzentration (Herfindahl): {hhi:.3f}", "-> hoch, Abhaengigkeit pruefen" if hhi > 0.30 else "-> unauffaellig")
groesster = max(kanaele, key=kanaele.get)
print("Groesster Kanal:", groesster, f"{kanaele[groesster]:.0%}")
```

Der erste Teil berechnet den ROI je Partner als (Umsatz minus Kosten) geteilt durch Kosten: Cloud-Marktplatz 5,7 bei 30 Prozent des Gesamtumsatzes, Systemintegrator X 4,0 bei 20 Prozent und Branchenverband 9,0 bei nur 5 Prozent. Der Branchenverband hat den höchsten ROI, aber den kleinsten Anteil; hier steckt also Wachstumspotenzial. Der zweite Teil bildet die Verteilung der Umsätze über die Kanäle ab (Direkt 45 Prozent, Marktplatz 30, Integrator 20, Verband 5) und berechnet den Herfindahl-Index zu 0,335. Die Schwelle von 0,30 ist hier eine frei gewählte Beispielgrenze; das Programm schlägt wegen des höheren Werts eine Abhängigkeitsprüfung vor. Der größte Kanal ist mit 45 Prozent der Direktvertrieb.

Typische Fehler: Partnerschaften aus Prestige, ohne Ziele; Exklusivität zugesagt, ohne Gegenleistung; Partnerbedingungen (Marktplatz-Gebühren, Listingregeln) werden einseitig geändert; Daten und Kundenbeziehung liegen allein beim Partner. Falsch: „Der Marktplatz bringt uns die Hälfte der Kunden, das läuft.“ Richtig: Abhängigkeit begrenzen, direkte Kundenbeziehung behalten, Vertragsklauseln zu Laufzeit, Exklusivität und Datenzugang prüfen und eine Alternative aufbauen.

> **Merke**
>
> Strategische Partnerschaften bringen Reichweite, Glaubwürdigkeit und Technologie, kosten aber Marge und Unabhängigkeit. Partner-ROI und Konzentration (zum Beispiel Herfindahl-Index) werden laufend gemessen; die direkte Kundenbeziehung bleibt erhalten.

> **Praxisbeispiel**
>
> Cloud-Anbieter bieten Start-up-Programme mit Guthaben und Co-Selling. Wer sie nutzt, sollte das Guthaben ausdrücklich nicht als dauerhafte Kostenbasis planen, sondern den Preis nach Ablauf kennen.

## 12.7 M&A und Exit Optionen

Ein *Exit* ist der Weg, auf dem Gründer und Investoren ihre Beteiligung in Geld umwandeln. Die wichtigsten Optionen sind: die *Akquisition* (ein anderes Unternehmen kauft das Unternehmen ganz oder mehrheitlich; englisch M&A für Mergers and Acquisitions), der *Secondary* (Anteilseigner verkaufen Anteile an neue Investoren, ohne dass das Unternehmen Geld erhält), der *Börsengang* (IPO, Initial Public Offering; für junge Unternehmen selten und mit hohen Anforderungen) und weitere strategische Optionen wie Fusion, Management-Buy-out oder dauerhafte Eigenständigkeit. Welche Option passt, hängt von Größe, Branche, Wünschen der Gründer und Erwartungen der Investoren ab (Modul 08).

Wichtige Begriffe: Der *Unternehmenswert* (Enterprise Value) ist der Preis für das gesamte Geschäft; der *Eigenkapitalwert* ergibt sich, indem man Schulden abzieht und Kasse hinzurechnet. Ein Teil des Kaufpreises wird oft in einem *Escrow* (Treuhand) zurückgehalten, um Gewährleistungsansprüche des Käufers abzusichern. Ein *Earn-out* macht einen weiteren Teil des Preises von künftigen Zielen abhängig. Die Verteilung auf die Beteiligten folgt der Cap Table und den Vorzugsrechten (Liquidationspräferenz, Modul 08).

```python
kaufpreis = 20_000_000
schulden, kasse = 1_500_000, 2_500_000
equity_wert = kaufpreis - schulden + kasse
escrow = 0.10 * equity_wert
print(f"Eigenkapitalwert: {equity_wert:,.0f}  davon Escrow (10 %): {escrow:,.0f}")
bei_closing = equity_wert - escrow

inhaber = {"Gruender A": 0.36, "Gruender B": 0.36, "Investor": 0.20, "Mitarbeiter (Optionen)": 0.08}
print(f"{'':24s} {'bei Closing':>12s} {'Escrow':>10s}")
for n, a in inhaber.items():
    print(f"{n:24s} {bei_closing * a:12,.0f} {escrow * a:10,.0f}")

earn_out = 3_000_000
print("Moeglicher Earn-out:", f"{earn_out:,}", "(nur bei Zielerreichung)")
```

Der Kaufpreis (Unternehmenswert) beträgt 20 Millionen Euro, die Schulden 1,5 Millionen, die Kasse 2,5 Millionen. Der Eigenkapitalwert ist 20 minus 1,5 plus 2,5, also 21 Millionen Euro. 10 Prozent davon, 2,1 Millionen Euro, werden als Escrow einbehalten, 18,9 Millionen Euro fließen beim Closing. Nach der Verteilung (Gründer je 36 Prozent, Investor 20 Prozent, Mitarbeiter 8 Prozent) erhält jeder Gründer beim Closing 6 804 000 Euro und später bis zu 756 000 Euro aus dem Escrow, der Investor 3 780 000 Euro (plus 420 000 Euro), die Mitarbeiter 1 512 000 Euro (plus 168 000 Euro). Ein möglicher Earn-out von 3 Millionen Euro käme dazu, wenn die Ziele erreicht werden. Das Beispiel vereinfacht stark: Es ignoriert Liquidationspräferenzen, Ausübungspreise der Optionen, Transaktionskosten, Steuern und Haltefristen und ist daher nur ein Rechenmodell.

Typische Fehler: Exit nicht vorbereiten (kein Datenraum, unklare Cap Table, offene Rechtsfragen, siehe Modul 08 und 11), von einem einzigen Bieter abhängig sein, Earn-out-Bedingungen unklar formulieren, und bei der Unternehmensstruktur keine saubere Trennung von Gesellschaften, Rechten und Verträgen. Falsch: Man spricht nur mit dem ersten Interessenten. Richtig: Mehrere Interessenten führen zu besseren Konditionen; Berater (Rechtsanwalt, Steuerberater, gegebenenfalls M&A-Berater) begleiten den Prozess. Vorbereitung heißt auch, den Gründern selbst klar zu machen, was sie wollen (Geld, Fortführung der Mission, Rolle nach dem Verkauf).

> **Merke**
>
> Exit-Wege sind Akquisition, Secondary und Börsengang. Zwischen Unternehmenswert und Auszahlung liegen Schulden, Kasse, Escrow, Earn-out, Vorzugsrechte und Steuern. Vorbereitung (Datenraum, saubere Struktur) und mehrere Interessenten verbessern die Konditionen.

> **Praxisbeispiel**
>
> Auch wer nie verkaufen will, profitiert von „exitfähiger“ Organisation: saubere Cap Table, vollständige Verträge, dokumentierte Prozesse. Das erleichtert Finanzierungsrunden, Partnerschaften und Notfälle (zum Beispiel Ausfall eines Gründers).

## 12.8 Scaleup Governance

Was in einem Team von zehn Personen informell funktioniert, bricht bei fünfzig oder hundert zusammen. *Scaleup Governance* meint, Management und Kontrolle mit dem Wachstum zu professionalisieren, ohne die Beweglichkeit zu verlieren. Vier Elemente tragen sie. Ein *Managementsystem* legt fest, wie Ziele gesetzt, Arbeit verteilt und Ergebnisse überprüft werden (Rhythmus aus Modul 10: Weekly, Monthly, OKRs). Die *KPIs* wachsen mit: Ein kleines Team braucht wenige Zahlen (Cash, MRR, Churn), ein größeres ergänzt ARR, NRR, Burn Multiple, Pipeline und später Bruttomarge und Mitarbeiterzufriedenheit. *Policies* werden präziser und mit Verantwortlichen versehen (Modul 11). Der *Board-Rhythmus* wird formeller, mit festen Terminen, Vorlagen und Ausschüssen (zum Beispiel für Audit und Vergütung).

Ziel ist die *Entscheidungsqualität bei Wachstum*: Entscheidungen werden dort getroffen, wo die beste Information liegt, mit klaren Limits (Ausgaben, Verträge, Einstellungen) und dokumentierten Entscheidungsgründen. Freigabelimits wachsen mit der Organisation, damit die Geschäftsführung nicht zum Engpass wird.

```python
stufen = [("bis 10 Personen", 10), ("11-50", 50), ("51-150", 150)]
kpis = {
    "bis 10 Personen": ["Cash", "MRR", "Churn"],
    "11-50": ["Cash", "ARR", "NRR", "Burn Multiple", "Pipeline"],
    "51-150": ["Cash", "ARR", "NRR", "Burn Multiple", "Pipeline", "Gross Margin", "eNPS"],
}
limits = {"bis 10 Personen": 5_000, "11-50": 25_000, "51-150": 100_000}
mitarbeitende = 38
for name, bis in stufen:
    if mitarbeitende <= bis:
        print(f"Stufe {name}: {len(kpis[name])} Kennzahlen: {', '.join(kpis[name])}")
        print(f"Freigabelimit Geschaeftsfuehrung: {limits[name]:,} EUR")
        break
runden = [
    # (Termin, Dauer in Stunden, Teilnehmer, Haeufigkeit pro Monat)
    ("Weekly", 1.0, 8, 4),
    ("Monthly Review", 2.0, 10, 1),
    ("Quartals-Board", 4.0, 6, 1 / 3),
]
for name, dauer, personen, oft in runden:
    print(f"{name:15s} {dauer * personen * oft:5.1f} Personenstunden pro Monat")
print(f"Summe: {sum(d * p * o for _, d, p, o in runden):.1f} Personenstunden pro Monat")
```

Das Programm wählt für ein Team von 38 Personen die passende Stufe (11 bis 50), nennt fünf Kennzahlen (Cash, ARR, NRR, Burn Multiple, Pipeline) und ein Freigabelimit für die Geschäftsführung von 25 000 Euro. Der zweite Teil schätzt die Management-Zeit für wiederkehrende Termine in Personenstunden pro Monat: Weekly (8 Personen, 1 Stunde, vier Mal) 32 Stunden, Monthly Review (10 Personen, 2 Stunden) 20 Stunden, Quartals-Board (6 Personen, 4 Stunden, ein Drittel pro Monat) 8 Stunden, zusammen 60 Personenstunden. Diese Zahl dient dazu, den Verwaltungsaufwand sichtbar zu machen und zu fragen, ob jeder Termin sein Geld wert ist.

Typische Fehler: Prozesse zu früh und zu schwer einführen (Bürokratie), zu spät (Chaos), Kennzahlen ohne Definition, Entscheidungen, die bei den Gründern hängen bleiben, und Meetings ohne Beschlussprotokoll. Falsch: „Jetzt, da wir 50 sind, brauchen wir 30 Kennzahlen und ein Komitee für alles.“ Richtig: Governance in Stufen ausbauen, jeweils so viel, wie die Größe verlangt, und mit jeder Stufe prüfen, ob die Entscheidungsgeschwindigkeit leidet. Eine einfache Entscheidungsliste (Was, wer, wann, warum) macht Entscheidungen nachvollziehbar.

> **Merke**
>
> Governance wächst in Stufen mit dem Unternehmen: Managementsystem, KPIs, Policies und Board-Rhythmus. Freigabelimits und Entscheidungsrechte werden delegiert, damit die Geschäftsführung kein Engpass wird. Zu viel Prozess bremst, zu wenig schafft Chaos.

> **Praxisbeispiel**
>
> Bei einem Übergang (zum Beispiel von 30 auf 60 Personen) lohnt eine „Prozessinventur“: Welche Abläufe sind überholt, welche fehlen, welche Rollen sind unklar? Eine Stunde im Leitungsteam genügt, um die drei wichtigsten Punkte zu bestimmen.

## 12.9 Abschlussroadmap

Die *Abschlussroadmap* führt alles zusammen: Produkt, Markt, Team und Finanzierung für die nächsten 12 bis 24 Monate. Sie beantwortet drei Fragen: Was wollen wir erreichen (Meilensteine mit messbaren Kriterien), wer ist dafür verantwortlich (Owner), und was kann dazwischenkommen (Risiken, Abhängigkeiten)? Die Roadmap ist kein Wunschzettel, sondern ein Plan mit Prioritäten. Sie verknüpft die Teile, die in den vorigen Modulen einzeln behandelt wurden: Der Markt bestimmt das Produkt (Modul 01, 03, 04), das Produkt erzwingt Betrieb und Sicherheit (Modul 05, 06), alles braucht Finanzierung und Kontrolle (Modul 07, 08) und tragfähige Menschen und Verträge (Modul 09 bis 11).

Eine nützliche Technik ist das Aufschreiben der *Abhängigkeiten*: Welche Aufgabe kann erst beginnen, wenn eine andere abgeschlossen ist? Daraus ergibt sich eine mögliche Reihenfolge und zeigt Konflikte (etwas ist früher geplant als seine Voraussetzung). Zusätzlich prüft man die *Kapazität*: Wie viel Aufwand fällt in welches Quartal, und passt das zum Team?

```python
from graphlib import TopologicalSorter
aufgaben = {
    "Pilot mit 3 Kunden":        {"owner": "CEO", "quartal": 1, "braucht": [], "aufwand": 6},
    "Security-Zertifizierung":   {"owner": "CTO", "quartal": 2, "braucht": ["Pilot mit 3 Kunden"], "aufwand": 8},
    "Enterprise-Vertrieb":       {"owner": "CEO", "quartal": 3, "braucht": ["Security-Zertifizierung"], "aufwand": 10},
    "Seed-Folgerunde":           {"owner": "CEO", "quartal": 2, "braucht": ["Pilot mit 3 Kunden"], "aufwand": 5},
    "Zweiter Markt":             {"owner": "COO", "quartal": 4, "braucht": ["Enterprise-Vertrieb", "Seed-Folgerunde"], "aufwand": 12},
}
graph = {n: set(a["braucht"]) for n, a in aufgaben.items()}
print("Reihenfolge:", list(TopologicalSorter(graph).static_order()))
for n, a in aufgaben.items():
    for v in a["braucht"]:
        if aufgaben[v]["quartal"] >= a["quartal"]:
            print(f"Problem: {n} (Q{a['quartal']}) haengt von {v} (Q{aufgaben[v]['quartal']}) ab")
kapazitaet = 12
je_quartal = {}
for n, a in aufgaben.items():
    je_quartal[a["quartal"]] = je_quartal.get(a["quartal"], 0) + a["aufwand"]
for q in sorted(je_quartal):
    print(f"Q{q}: Aufwand {je_quartal[q]:2d} von {kapazitaet}", "ueberlastet" if je_quartal[q] > kapazitaet else "")
```

Fünf Meilensteine haben Owner, Quartal, Voraussetzungen und Aufwand (in Personenmonaten). Das Modul `graphlib` aus der Standardbibliothek sortiert sie topologisch, also so, dass jede Aufgabe nach ihren Voraussetzungen kommt: erst der Pilot mit drei Kunden, dann die Security-Zertifizierung und die Seed-Folgerunde, danach der Enterprise-Vertrieb und zuletzt der zweite Markt. Die Prüfschleife untersucht, ob eine Aufgabe in einem Quartal geplant ist, das nicht nach dem ihrer Voraussetzung liegt; hier gibt es keinen Konflikt. Die Kapazitätsprüfung zeigt dagegen: In Quartal 2 liegen 13 Personenmonate Aufwand (Security-Zertifizierung 8 plus Seed-Folgerunde 5) bei einer Kapazität von 12, das Quartal ist überlastet. Quartal 1 hat 6, Quartal 3 hat 10 und Quartal 4 genau 12. Konsequenz: eine der beiden Aufgaben verschieben, Aufwand verringern oder Kapazität erhöhen, und das Risiko im Register festhalten (Modul 11).

Typische Fehler: Roadmaps ohne Prioritäten, zu viele parallele Ziele, Meilensteine ohne messbares Kriterium („Markt entwickeln“), kein Puffer. Falsch: „Im nächsten Jahr bauen wir Produkt, Vertrieb, drei Märkte und Zertifizierung gleichzeitig.“ Richtig: Fokus auf wenige Ziele je Quartal, jedes mit Owner, Kriterium, Aufwand und Abhängigkeit, und ein Kontrolltermin je Quartal, an dem die Roadmap angepasst wird. Die Roadmap sollte in einer Seite erklärbar sein; sie ist ein Führungsinstrument, kein Dokument für die Schublade.

> **Merke**
>
> Die Abschlussroadmap bündelt Produkt, Markt, Team und Finanzierung in Meilensteinen mit Owner, Kriterium, Aufwand und Abhängigkeiten. Kapazität und Reihenfolge werden geprüft; die Roadmap wird quartalsweise angepasst.

> **Praxisbeispiel**
>
> Investoren, Förderstellen und Beirat erhalten dieselbe Roadmap in unterschiedlichen Detailgraden. Eine ehrliche Roadmap mit Risiken und Alternativen wirkt glaubwürdiger als eine, in der alles planmäßig läuft.

## Übungsaufgaben zu Modul 12

1.  **(leicht)** Erkläre den Unterschied zwischen dem Modell „Land für Land“ und der „zentralen Plattform“ und nenne je einen Vorteil.

2.  **(leicht)** Was bedeuten RTO und RPO, und welches der beiden bestimmt das Sicherungsintervall?

3.  **(leicht)** Ein Unternehmen wächst um 30 Prozent und hat eine Marge von 5 Prozent. Wie hoch ist die Rule of 40, und wie ist sie einzuordnen?

4.  **(mittel)** Ein Verkaufsprozess hat die Phasen Erstgespräch 10 Tage, Sicherheitsprüfung 20 Tage, Rechtsprüfung 30 Tage und Beschaffung 25 Tage. Wie lang ist der Zyklus, und warum ist das für die Planung der Kasse wichtig?

5.  **(mittel)** Ein Unternehmen verbrennt 600 000 Euro und gewinnt 400 000 Euro neuen ARR. Berechne den Burn Multiple und interpretiere ihn.

6.  **(praktisch)** Schreibe eine Funktion, die prüft, ob das Backup-Intervall eines Systems zum RPO passt, und wende sie auf drei Systeme an.

7.  **(praktisch)** Schreibe eine Funktion für den Herfindahl-Index (Summe der quadrierten Anteile) und teste sie mit mehreren Verteilungen.

8.  **(schwer/praktisch)** Ein Unternehmen wird für 12 Mio. Euro (Unternehmenswert) verkauft; Schulden 1 Mio., Kasse 0,5 Mio., Escrow 15 Prozent des Eigenkapitalwerts. Beteiligte: A 60 Prozent, B 30, C 10. Berechne die Auszahlung bei Closing und den Escrow-Anteil je Beteiligtem.

## Lösungen zu den Übungsaufgaben Modul 12

**1.** Beim Modell „Land für Land“ betritt man Märkte nacheinander mit lokaler Ansprache; der Vorteil ist begrenztes Risiko und gezieltes Lernen. Bei der zentralen Plattform baut man eine gemeinsame Infrastruktur auf, die Länder mit geringen Zusatzkosten bedient; der Vorteil sind niedrige Grenzkosten ab mehreren Märkten.

**2.** RTO ist die höchste tolerierbare Ausfallzeit, RPO der höchste tolerierbare Datenverlust (in Zeit). Das RPO bestimmt das Sicherungsintervall, weil bei längerem Intervall im Ernstfall mehr Daten verloren gehen als erlaubt.

**3.** Rule of 40 = 30 plus 5 = 35. Das liegt unter der Faustregel von 40; das Unternehmen sollte entweder das Wachstum steigern oder die Marge verbessern, wobei beides je nach Phase abgewogen wird.

**4.** 10 plus 20 plus 30 plus 25 = 85 Tage, knapp drei Monate. Für die Kasse bedeutet das, dass zwischen Aufnahme der Kosten (Vertrieb, Sicherheitsprüfung) und der ersten Zahlung viele Wochen liegen; diese Vorfinanzierung muss in Runway und Finanzplanung eingehen (Modul 07).

**5.** Burn Multiple = 600 000 geteilt durch 400 000 = 1,5. Pro neuem Euro ARR werden 1,50 Euro Cash verbraucht. Je niedriger, desto effizienter; Werte um 1 oder darunter gelten als sehr gut, deutlich über 2 als kritisch (Faustwerte, abhängig von Phase und Branche).

**6.** Mögliche Lösung:

```python
def backup_ok(intervall_h, rpo_h):
    return intervall_h <= rpo_h
for name, intervall, rpo in (("DB", 1, 1), ("Dateien", 24, 4), ("Wiki", 168, 24)):
    print(name, "OK" if backup_ok(intervall, rpo) else "Datenverlust groesser als erlaubt")
```

Die Funktion vergleicht Intervall und RPO. Die Datenbank (1 Stunde gegen 1 Stunde) ist in Ordnung, bei den Dateien (24 gegen 4 Stunden) und beim Wiki (168 gegen 24 Stunden) wäre der Datenverlust größer als erlaubt.

**7.** Mögliche Lösung:

```python
def herfindahl(anteile):
    assert abs(sum(anteile) - 1) < 1e-9
    return sum(a * a for a in anteile)
print(round(herfindahl([0.5, 0.3, 0.2]), 3), round(herfindahl([0.25] * 4), 3), round(herfindahl([1.0]), 3))
```

Drei Kanäle mit 50, 30 und 20 Prozent ergeben 0,38, vier gleich große Kanäle 0,25, und ein einziger Kanal den Maximalwert 1,0. Die `assert`-Zeile fängt Eingaben ab, deren Anteile nicht 1 ergeben.

**8.** Mögliche Lösung:

```python
kaufpreis, schulden, kasse, escrow_quote = 12_000_000, 1_000_000, 500_000, 0.15
equity = kaufpreis - schulden + kasse
escrow = equity * escrow_quote
closing = equity - escrow
inhaber = {"A": 0.60, "B": 0.30, "C": 0.10}
print(f"Equity {equity:,.0f}  Escrow {escrow:,.0f}  bei Closing {closing:,.0f}")
for n, a in inhaber.items():
    print(f"{n}: bei Closing {closing * a:,.0f}, Escrow-Anteil {escrow * a:,.0f}")
```

Der Eigenkapitalwert beträgt 12 minus 1 plus 0,5 = 11,5 Mio. Euro, der Escrow 15 Prozent davon, also 1 725 000 Euro, und beim Closing fließen 9 775 000 Euro. A erhält davon 5 865 000 Euro (plus bis zu 1 035 000 Euro aus dem Escrow), B 2 932 500 Euro (plus 517 500 Euro), C 977 500 Euro (plus 172 500 Euro).
