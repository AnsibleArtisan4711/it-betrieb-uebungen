# Modul 10 - People, Organisation und Founder Operations

> **Hinweis zu diesem Kapitel:** Das ist das Kapitel des Skripts „Unternehmensgründung“, aus der LaTeX-Quelle in Markdown umgewandelt (Text und Codeblöcke unverändert, farbige Boxen als Zitatblöcke mit fettem Titel, Tabellen als Markdown-Tabellen). Die Lerneinheiten sind wie in der Quelle nach Modul nummeriert (10.1 bis 10.9), danach folgen „Übungsaufgaben zu Modul 10“ (8 Aufgaben, mit Schwierigkeitsangabe) und „Lösungen zu den Übungsaufgaben Modul 10“. Rechtliche und steuerliche Aussagen sind keine Rechtsberatung. Was ich an den Beispielen geprüft habe, steht in der [README des Repositories](../README.md). Übersicht zum Modul: [README](README.md).

**Dauer:** 8 h laut Modulübersicht (Summe der Einzelwerte: 9 × 0,9 h = 8,1 h, gerundet)

**Priorität:** 2

| **Nr.** | **Lerneinheit**             | **Dauer (h)** |
|--------:|:----------------------------|--------------:|
|    10.1 | Founder Rollen              |           0,9 |
|    10.2 | Hiring Strategie            |           0,9 |
|    10.3 | Recruiting Prozess          |           0,9 |
|    10.4 | Remote und Hybrid Work      |           0,9 |
|    10.5 | Mitarbeiterbeteiligung      |           0,9 |
|    10.6 | Kultur und Werte            |           0,9 |
|    10.7 | Leadership Operating Rhythm |           0,9 |
|    10.8 | Policies und HR Compliance  |           0,9 |
|    10.9 | Konfliktmanagement          |           0,9 |
|         | **Summe**                   |       **8,1** |

Unternehmen bestehen aus Menschen, und gerade junge Technikunternehmen scheitern häufiger an Zusammenarbeit als an Technik: unklare Zuständigkeiten, falsche Einstellungen, Konflikte zwischen Gründern. Dieses Modul zeigt, wie man ein Team aufbaut, Verantwortung klärt, Entscheidungen strukturiert und Regeln so setzt, dass sie wirklich getragen werden. Es knüpft an Modul 07 (Personalkosten) und Modul 08 (Cap Table, Beteiligungen) an. **Rechtliche Aussagen, insbesondere zu Arbeitsrecht und Steuern, sind allgemeine Information und keine Rechtsberatung.** Arbeitsrechtliche Details hängen von Kollektivvertrag, Branche und Einzelfall ab. Die Programme laufen mit Python 3 ohne Zusatzpakete; alle Zahlen sind erfundene Beispiele.

## 10.1 Founder Rollen

In der Anfangszeit machen Gründerinnen und Gründer alles gemeinsam, und das funktioniert gut, solange das Team klein ist. Mit wachsender Komplexität wird es zum Problem: Wenn jeder alles entscheiden darf, entscheidet am Ende niemand; wenn jeder glaubt, ein anderer kümmere sich, bleibt Wichtiges liegen. Deshalb klärt man früh, wer wofür verantwortlich ist. Üblich sind vier Funktionen. Der *CEO* (Chief Executive Officer) verantwortet Strategie, Finanzierung, Gesamtführung und Außenauftritt. Der *CTO* (Chief Technology Officer) verantwortet Technik, Architektur und Entwicklungsteam. Der *COO* (Chief Operating Officer) verantwortet den laufenden Betrieb, Prozesse, Finanzen und Verwaltung. Die Funktion *Sales* oder *CRO* (Chief Revenue Officer) verantwortet Umsatz und Kundengewinnung. In kleinen Teams vereinen einzelne Personen mehrere Rollen; wichtig ist nicht der Titel, sondern dass die Aufgaben jemandem gehören.

Ein bewährtes Werkzeug sind *Entscheidungsrechte*, häufig als *RACI-Matrix* dargestellt. Für jede Entscheidung wird festgelegt, wer *Responsible* ist (führt aus), wer *Accountable* ist (entscheidet und trägt die Verantwortung; genau eine Person), wer *Consulted* wird (wird vorher gefragt) und wer *Informed* wird (erfährt das Ergebnis). Die Regel „genau ein A“ ist der Kern: Mehrere A bedeuten Streit, kein A bedeutet Stillstand.

```python
entscheidungen = {
    "Produkt-Roadmap":        {"CEO": "C", "CTO": "A", "COO": "I", "Sales": "C"},
    "Preisgestaltung":        {"CEO": "A", "CTO": "C", "COO": "C", "Sales": "R"},
    "Einstellung Entwickler": {"CEO": "C", "CTO": "A", "COO": "R", "Sales": "I"},
    "Budget Marketing":       {"CEO": "A", "CTO": "I", "COO": "A", "Sales": "C"},
    "Vertragsunterzeichnung": {"CEO": "C", "CTO": "I", "COO": "C", "Sales": "I"},
}
for thema, rollen in entscheidungen.items():
    a = [r for r, k in rollen.items() if k == "A"]
    if len(a) == 1:
        print(f"{thema:24s} OK: entscheidet {a[0]}")
    elif not a:
        print(f"{thema:24s} FEHLT: niemand entscheidet")
    else:
        print(f"{thema:24s} KONFLIKT: {' und '.join(a)} entscheiden")
```

Das Wörterbuch ordnet jeder Entscheidung die Rollen mit ihrem RACI-Buchstaben zu. Für jede Entscheidung werden die Rollen mit `A` gesammelt. Bei genau einer Rolle ist alles klar. Das Programm findet zwei Probleme: Beim Marketingbudget sind CEO und COO beide „Accountable“, sodass bei Meinungsverschiedenheit niemand das letzte Wort hat, und bei der Vertragsunterzeichnung hat niemand das A, es fehlt also die Verantwortung. Beide Befunde sollten in einem Gespräch der Gründer geklärt und schriftlich festgehalten werden. Eine solche Matrix wird in wenigen Stunden erstellt und verhindert viele spätere Konflikte.

Typische Fehler: Rollen nur nach Titeln vergeben, ohne Entscheidungsrechte festzulegen; Rollen nie anpassen, obwohl sich das Unternehmen verändert; ungeklärte Stellung der Gründer, die gleichzeitig Gesellschafter, Geschäftsführer und Angestellte sind. Falsch: „Wir entscheiden alles gemeinsam.“ Richtig: Für wiederkehrende Entscheidungen steht fest, wer entscheidet, bei grundlegenden Entscheidungen (Finanzierung, Verkauf, neue Gesellschafter) gilt ein gemeinsames Verfahren mit Mehrheit oder Einstimmigkeit, wie es der Gesellschaftsvertrag regelt (Modul 02).

> **Merke**
>
> Rollen werden über Verantwortung und Entscheidungsrechte definiert, nicht über Titel. In einer RACI-Matrix hat jede Entscheidung genau einen Entscheider (A). Die Matrix wird schriftlich festgehalten und regelmäßig überprüft.

> **Praxisbeispiel**
>
> Investoren fragen früh nach der Rollenverteilung der Gründer und der Frage, ob die Verantwortung klar ist. Ein Team, das offen über Schwächen und Rollenwechsel spricht (zum Beispiel wenn ein technischer Gründer nicht der beste CEO ist), wirkt reifer als eines, das alles perfekt darstellt.

## 10.2 Hiring Strategie

Die *Hiring-Strategie* beantwortet die Frage, wen man wann einstellt. Weil Personal der größte Kostenblock ist (Modul 07) und jede Fehlbesetzung Monate kostet, gilt: Nicht alle offenen Stellen sind gleich dringend. Man priorisiert nach zwei Kriterien. Das erste ist das *Risiko*: Welche Rolle fehlt so sehr, dass ohne sie ein Ausfall oder Stillstand droht? Das zweite ist der *Meilenstein*: Welche Rolle bringt das Unternehmen dem nächsten Ziel (Finanzierungsrunde, erster Großkunde) am schnellsten näher? Ergänzend betrachtet man die Kosten, denn die gleiche Wirkung zum halben Preis ist besser.

Eine wichtige Entscheidung ist die *Seniorität*: Erfahrene Fachleute sind teurer, arbeiten aber selbstständiger, brauchen weniger Führung und machen weniger grundlegende Fehler. Junge Talente sind günstiger und entwickeln sich, binden aber Betreuungszeit. In frühen Phasen, in denen niemand Zeit zum Anleiten hat, sind die ersten Stellen meist mit erfahrenen Personen besser besetzt. Zudem sollte man echte Kosten rechnen: Zum Bruttogehalt kommen Lohnnebenkosten (in Modul 07 mit einem Faktor von etwa 1,28 als Annahme gerechnet), Ausstattung, Software und Recruiting-Kosten.

```python
FAKTOR = 1.28            # Lohnnebenkosten-Faktor als Annahme (siehe Modul 07)
budget_monat = 20_000
rollen = [
    # (Rolle, Risiko 1-5, Meilenstein 1-5, Brutto/Monat)
    ("Senior Backend",      5, 5, 6_000),
    ("Customer Success",    3, 4, 3_800),
    ("Marketing Manager",   2, 3, 4_200),
    ("DevOps/Security",     4, 4, 5_800),
    ("Office Management",   1, 1, 3_000),
]
bewertet = [(name, (r * m) / (brutto * FAKTOR), brutto * FAKTOR) for name, r, m, brutto in rollen]
bewertet.sort(key=lambda x: -x[1])
rest = budget_monat
for name, wert, kosten in bewertet:
    if kosten <= rest:
        rest -= kosten
        print(f"EINSTELLEN {name:18s} Kosten {kosten:7.0f}  Nutzen/Kosten {wert * 1000:5.2f}  Rest {rest:7.0f}")
    else:
        print(f"SPAETER    {name:18s} Kosten {kosten:7.0f}  passt nicht ins Budget (Rest {rest:.0f})")
```

Das Programm ordnet fünf Rollen nach einem einfachen Wert: Risiko mal Meilenstein-Bedeutung (jeweils 1 bis 5) geteilt durch die Monatskosten (Brutto mal Faktor 1,28). Die Werte sind für die Lesbarkeit mit 1 000 multipliziert. Senior Backend (Kosten 7 680 Euro im Monat, Wert 3,26) steht oben, Customer Success (4 864 Euro, 2,47) und DevOps/Security (7 424 Euro, 2,16) folgen. Bei einem Monatsbudget von 20 000 Euro bleibt danach ein Rest von nur 32 Euro, weshalb Marketing Manager (5 376 Euro) und Office Management (3 840 Euro) nach hinten rücken. Die Rangfolge ist eine Diskussionsgrundlage: Sie macht Annahmen sichtbar, ersetzt aber nicht die Frage, ob sich die Einstellung durch Umsatz oder Förderung refinanziert.

Typische Fehler: Einstellen auf Vorrat, Einstellen aus Sympathie, Rollen, die vor allem aus Gewohnheit besetzt werden, und das Ignorieren der Einarbeitungszeit (neue Mitarbeitende sind in den ersten Monaten selten voll produktiv). Falsch: „Wir stellen drei Entwickler ein, dann sind wir schneller.“ Richtig: Prüfen, ob ein Engpass wirklich bei der Entwicklungskapazität liegt, und die Einstellung an einen Meilenstein koppeln. Alternativen sind Freelancer, Partner oder Automatisierung, wobei die Rechte am Code (Modul 11) vertraglich geklärt sein müssen.

> **Merke**
>
> Stellen werden nach Risiko, Meilenstein und Kosten priorisiert. Echte Kosten sind höher als das Bruttogehalt. Frühe Stellen werden eher mit erfahrenen Personen besetzt; Einstellungen werden an Meilensteine gekoppelt.

> **Praxisbeispiel**
>
> Ein Hiring-Plan mit Rolle, Zeitpunkt, Kosten und Meilenstein gehört in jede Finanzplanung und in die Unterlagen für Investoren (Modul 08). Er zeigt, dass das eingeworbene Geld gezielt eingesetzt wird.

## 10.3 Recruiting Prozess

Der *Recruiting-Prozess* beschreibt, wie aus einer offenen Stelle eine Einstellung wird: Stellenbeschreibung, Ansprache, Vorauswahl, Interviews, Aufgaben oder Probearbeit, Referenzen, Angebot. Das Ziel ist, die richtige Person mit möglichst wenig Zufall zu finden. Studien zur Personalauswahl zeigen, dass freie, unstrukturierte Gespräche schlechte Vorhersagen liefern, weil sie von Sympathie und Bauchgefühl geprägt sind. Strukturierte Verfahren sind verlässlicher: Für die Stelle werden vorab Kriterien festgelegt und gewichtet, allen Kandidaten werden vergleichbare Fragen gestellt, und jede interviewende Person bewertet anhand einer *Scorecard* getrennt, bevor man sich austauscht.

> **Ergänzung aus der Nachrecherche**
>
> Zur Gehaltstransparenz in Stellenausschreibungen: Die EU-Entgelttransparenzrichtlinie (Umsetzungsfrist 7. Juni 2026) sieht laut einem Beitrag von Forvis Mazars vor, dass Ausschreibungen geschlechtsneutral sind, Bewerbende Anspruch auf Auskunft über das vorgesehene Einstiegsentgelt haben und nicht nach früheren Gehältern gefragt werden darf. Beschäftigte können das Durchschnittsentgelt ihrer Vergleichsgruppe nach Geschlecht erfahren; die Berichtspflicht zum Entgeltgefälle betrifft laut Artikel ab 2027 Unternehmen mit mindestens 250 Beschäftigten, unter 100 Beschäftigten besteht nach der Richtlinie keine Berichtspflicht. Die Umsetzung in Österreich war laut dem Artikel noch nicht abgeschlossen und ein konkreter Gesetzesentwurf wurde nicht genannt; der Stand ist vor jeder Anwendung zu prüfen (Quelle Q16; keine Rechtsberatung).

Das Programm bewertet zwei Kandidaten mit einer gewichteten Scorecard und zwei Interviewern und prüft auf Auffälligkeiten.

```python
kriterien = {"Fachkompetenz": 0.35, "Problemloesung": 0.25, "Kommunikation": 0.20, "Werte-Passung": 0.20}
bewertungen = {
    "Kandidat X": {"Anna": {"Fachkompetenz": 5, "Problemloesung": 4, "Kommunikation": 3, "Werte-Passung": 4},
                   "Ben":  {"Fachkompetenz": 4, "Problemloesung": 4, "Kommunikation": 3, "Werte-Passung": 3}},
    "Kandidat Y": {"Anna": {"Fachkompetenz": 3, "Problemloesung": 3, "Kommunikation": 5, "Werte-Passung": 5},
                   "Ben":  {"Fachkompetenz": 3, "Problemloesung": 4, "Kommunikation": 4, "Werte-Passung": 5}},
}
assert abs(sum(kriterien.values()) - 1) < 1e-9
for kandidat, juroren in bewertungen.items():
    punkte = []
    for juror, werte in juroren.items():
        p = sum(kriterien[k] * werte[k] for k in kriterien)
        punkte.append(p)
        print(f"{kandidat} / {juror}: {p:.2f}")
    print(f"{kandidat} Mittel: {sum(punkte)/len(punkte):.2f}  Spreizung: {max(punkte)-min(punkte):.2f}")

alle = {}
for juroren in bewertungen.values():
    for juror, werte in juroren.items():
        alle.setdefault(juror, []).extend(werte.values())
for juror, w in alle.items():
    print(f"{juror}: durchschnittliche Vergabe {sum(w)/len(w):.2f}")
```

Die Gewichte der vier Kriterien summieren sich zu 1; die `assert`-Zeile bricht ab, falls ein Tippfehler das ändert. Jede Bewertung berechnet eine gewichtete Summe. Kandidat X erhält von Anna 4,15 und von Ben 3,60 Punkte, im Mittel 3,88 bei einer Spreizung von 0,55; die beiden Bewerter sehen den Kandidaten also unterschiedlich, das ist ein Anlass für ein Gespräch über die Kriterien. Kandidat Y liegt bei 3,80 und 3,85 (Mittel 3,82), die Bewertungen stimmen fast überein. Der zweite Teil vergleicht die durchschnittliche Vergabe der Bewerter: Anna vergibt im Schnitt 4,00 Punkte, Ben 3,75, Ben ist also strenger. Solche Unterschiede sind normal, sollten aber bei Entscheidungen berücksichtigt werden, damit nicht die Strenge einer Person über die Wahl entscheidet.

Typische Fehler: Entscheidungen aus Sympathie, Fragen, die zu einer Gleichheit mit dem Team führen („passt zu uns“ als Ersatz für Kriterien), die Bewertung erst nach der Diskussion und Referenzen, die nicht eingeholt werden. Falsch: Jeder Interviewer stellt eigene Fragen und gibt am Ende ein Gefühl ab. Richtig: Vorab festgelegte Fragen, schriftliche Einzelbewertung, danach Abgleich. Um *Bias* (unbewusste Verzerrung) zu verringern, helfen anonymisierte Vorauswahl, vergleichbare Aufgaben und mehrere Beurteilende; die Zusammensetzung des Auswahlteams sollte möglichst vielfältig sein.

> **Merke**
>
> Strukturierte Interviews mit gewichteter Scorecard, getrennter Bewertung und Referenzen sind verlässlicher als Bauchgefühl. Bias lässt sich durch vorab festgelegte Kriterien und mehrere Bewertende verringern. Gehaltsangaben und Fragen im Bewerbungsprozess unterliegen Regeln.

> **Praxisbeispiel**
>
> Für Schlüsselstellen lohnt eine bezahlte Arbeitsprobe (zum Beispiel ein halber Tag an einem realen Problem). Sie zeigt die Arbeitsweise besser als ein Gespräch und gibt der Person einen Einblick ins Team.

## 10.4 Remote und Hybrid Work

Bei *Remote Work* arbeitet das Team überwiegend von verschiedenen Orten aus, bei *Hybrid* wechseln sich Büro und Heimarbeit ab. Beides erweitert den Pool an Fachkräften und spart Büro-Kosten, verlangt aber bewusste Organisation, weil das spontane Gespräch am Flur fehlt. Drei Bausteine tragen die Zusammenarbeit. Erstens *Kommunikationsregeln*: Welcher Kanal wird wofür genutzt (Chat für Schnelles, E-Mail für Externes, Tickets für Aufgaben), wie schnell wird geantwortet, was ist dringend? Zweitens *Dokumentation*: Entscheidungen, Prozesse und Wissen stehen schriftlich an einem zentralen Ort, damit Menschen in verschiedenen Zeitzonen und mit unterschiedlicher Arbeitszeit arbeiten können (*asynchrones Arbeiten*). Drittens *Meeting-Kultur*: Jedes Meeting hat Zweck, Agenda und Ergebnisprotokoll; Meetings ohne Entscheidung werden durch Textupdates ersetzt.

Produktivität ohne *Mikromanagement* entsteht durch klare Ziele und Ergebnisse statt durch Kontrolle der Anwesenheit. Man führt über Absprachen (Ziele, Prioritäten, Fristen), regelmäßige Einzelgespräche und transparente Arbeitsstände. Dazu gehören Regeln zu Erreichbarkeit und Pausen, damit Heimarbeit nicht zu Dauerverfügbarkeit führt.

```python
teilnehmer = {"Wien": 1, "Lissabon": 0, "Berlin": 1, "Kapstadt": 2}   # Offset zu UTC im Winter (vereinfacht)
kern_start, kern_ende = 9, 17
def lokal_fenster(offset):
    return kern_start - offset, kern_ende - offset
von = max(lokal_fenster(o)[0] for o in teilnehmer.values())
bis = min(lokal_fenster(o)[1] for o in teilnehmer.values())
print(f"Gemeinsame Arbeitszeit in UTC: {von}:00 bis {bis}:00 ({max(0, bis - von)} Stunden)")
print("Vorschlag Kernzeit (UTC):", f"{von}:00-{von+3}:00" if bis - von >= 3 else "keine ausreichende Ueberlappung")

meetings = [("Daily", 15, 5), ("Weekly", 60, 1), ("Planung", 90, 1), ("1:1 (4 Personen)", 30, 4)]
minuten = sum(dauer * oft for _, dauer, oft in meetings)
print(f"Meeting-Zeit pro Woche (Entwickler): {minuten} Minuten = {minuten/60:.1f} Stunden ({minuten/60/40:.0%} von 40 h)")
```

Im ersten Teil stehen vier Standorte mit ihrem Zeitversatz zu UTC (im Winter, vereinfacht): Wien und Berlin plus 1, Lissabon 0, Kapstadt plus 2. Die Funktion `lokal_fenster` rechnet die lokale Kernarbeitszeit von 9 bis 17 Uhr in UTC um. Die gemeinsame Arbeitszeit beginnt beim spätesten Beginn (9 Uhr UTC) und endet beim frühesten Ende (15 Uhr UTC); es bleiben sechs Stunden. Als Kernzeit für Abstimmungen wird 9 bis 12 Uhr UTC vorgeschlagen. Der zweite Teil addiert die wöchentlichen Meetings eines Entwicklers (Daily, Weekly, Planung, vier Einzelgespräche) zu 345 Minuten, also etwa 5,8 Stunden oder 14 Prozent einer 40-Stunden-Woche. Was ein angemessener Anteil ist, hängt von der Rolle ab; entscheidend ist, dass man ihn kennt.

Typische Fehler: Alles synchron erledigen wollen, Wissen in Chats vergraben, kein persönlicher Kontakt (Neue Teammitglieder und Gründer brauchen auch Treffen vor Ort), Zeitzonen vergessen. Falsch: „Wir sind remote, also gibt es keine Regeln.“ Richtig: Wenige, klare Regeln und gelegentliche Präsenztermine für Planung und Teambindung. Arbeitsrechtlich sind Heimarbeit, Arbeitszeit, Arbeitsmittel und Datenschutz schriftlich zu regeln (Lerneinheit 10.8 und Modul 06).

> **Merke**
>
> Remote und Hybrid funktionieren mit klaren Kommunikationsregeln, schriftlicher Dokumentation und disziplinierter Meeting-Kultur. Führung erfolgt über Ziele und Ergebnisse statt Anwesenheitskontrolle. Zeitzonen und Kernzeiten sind zu planen.

> **Praxisbeispiel**
>
> Eine „Arbeitsweise-Seite“ (Handbuch) mit Kanälen, Antwortzeiten, Kernzeit, Meeting-Regeln und Entscheidungsprozess spart in der Einarbeitung viel Zeit und macht Erwartungen sichtbar.

## 10.5 Mitarbeiterbeteiligung

Junge Unternehmen können mit Gehältern selten gegen große Konzerne mithalten. Eine *Mitarbeiterbeteiligung* bietet Ausgleich, indem Mitarbeitende am Erfolg teilhaben. Üblich sind *Optionen* (das Recht, später Anteile zu einem vorher festgelegten Preis, dem *Ausübungspreis*, zu erwerben), echte Anteile (häufig über eine Beteiligungsgesellschaft) und *virtuelle Beteiligungen* (Phantom Shares, bei denen die Person im Verkaufsfall einen Geldbetrag nach dem Wert von Anteilen erhält, ohne Gesellschafterin zu werden). Die Grundlagen von Cap Table, Verwässerung und Vesting stehen in Modul 08; hier geht es um die Planung für das Team.

> **Ergänzung aus der Nachrecherche**
>
> Zur Besteuerung virtueller Beteiligungen berichtet Trending Topics (Stand 20. Jänner 2026) von einer verlängerten österreichischen Übergangsregelung: Bestehende Phantom Shares sollen bis Ende 2026 in echte Beteiligungen umgewandelt werden können, ohne dass bei der Umwandlung sofort Steuer anfällt; die Besteuerung erfolgt erst bei Realisierung eines Erlöses. Als Bedingungen des bestehenden Rahmens werden unter anderem höchstens 100 Beschäftigte und höchstens 40 Mio. Euro Umsatz genannt. Der endgültige Stand ist zu prüfen (Quelle Q10; keine Steuerberatung). Wichtig ist, steuerliche Folgen vor der Zusage mit einer Beratung zu klären und den Mitarbeitenden klar zu sagen, dass Optionen keinen garantierten Wert haben.

Der *Optionspool* ist der Anteil des Unternehmens (oft 5 bis 15 Prozent, abhängig von Phase und Markt; eine Faustregel), der für Mitarbeitende reserviert ist. Man dimensioniert ihn aus dem Hiring-Plan: Für welche Rollen sind wie viele Optionen geplant? Üblicherweise erhalten Schlüsselpersonen früher und mehr. Das *Vesting* verteilt die Zuteilung über vier Jahre mit einem Jahr Sperrfrist (Cliff); wer früher geht, verliert den nicht erdienten Teil.

```python
pool_prozent = 0.10
gesamt_anteile = 10_000_000
pool = int(gesamt_anteile * pool_prozent)
plan = [("Senior Backend", 0.0100), ("Customer Success", 0.0040), ("CTO (Nachbesetzung)", 0.0300), ("Reserve spaeter", 0.0300)]
verteilt = 0
for name, anteil in plan:
    n = int(gesamt_anteile * anteil)
    verteilt += n
    print(f"{name:20s} {n:8,d} Optionen ({anteil:.2%})")
print(f"Pool {pool:,}  verplant {verteilt:,}  frei {pool - verteilt:,}")

def erdient(monate, gesamt, cliff=12, laufzeit=48):
    return 0 if monate < cliff else min(gesamt, gesamt * monate // laufzeit)
optionen, strike = 100_000, 0.40
for monate in (6, 12, 30, 48):
    e = erdient(monate, optionen)
    print(f"Monat {monate:2d}: erdient {e:7,d}  Ausuebungskosten {e * strike:10,.0f} EUR")
```

Bei 10 Millionen Anteilen und einem Pool von 10 Prozent stehen 1 000 000 Optionen zur Verfügung. Der Plan verteilt 100 000 an einen Senior-Backend-Entwickler (1,00 Prozent), 40 000 an Customer Success, 300 000 für die Nachbesetzung der CTO-Rolle (3,00 Prozent) und reserviert 300 000 für spätere Einstellungen. Insgesamt sind 740 000 verplant und 260 000 frei. Das Beispiel zeigt, dass ein einziger großer Posten den Pool stark beansprucht und dass man ihn mit der Verwässerung in künftigen Runden zusammen betrachten muss. Der zweite Teil rechnet das Vesting für 100 000 Optionen mit einem Ausübungspreis von 0,40 Euro: Nach 6 Monaten ist nichts erdient, nach 12 Monaten 25 000 (Ausübungskosten 10 000 Euro), nach 30 Monaten 62 500 (25 000 Euro) und nach 48 Monaten alle 100 000 (40 000 Euro).

Typische Fehler: Zusagen per Handschlag („du bekommst ein Prozent“), unklare Bedingungen bei Kündigung (*Good Leaver, Bad Leaver*), fehlende Erklärung des Werts und der Steuerfolgen, Pool zu klein für künftige Einstellungen. Falsch: Man teilt Prozent aus, ohne Vesting und Ausübungspreis zu nennen. Richtig: Ein schriftlicher Plan mit Zuteilung, Vesting, Cliff, Ausübungsbedingungen und Vorgehen bei Austritt; eine Beispielrechnung, was Optionen bei verschiedenen Exit-Werten wert wären, schafft realistische Erwartungen.

> **Merke**
>
> Beteiligungen binden Mitarbeitende am Erfolg: Optionen, Anteile oder virtuelle Beteiligungen. Der Pool wird aus dem Hiring-Plan dimensioniert, Vesting und Cliff regeln die Zuteilung. Erwartungen und steuerliche Folgen werden vor der Zusage geklärt.

> **Praxisbeispiel**
>
> Eine einfache Übersichtsseite („Was sind meine Optionen wert?“) mit Beispielrechnungen bei verschiedenen Exit-Werten verhindert Missverständnisse und stärkt die Bindung, solange sie ehrlich auch das Risiko eines wertlosen Ausgangs nennt.

## 10.6 Kultur und Werte

*Kultur* ist die Summe der unausgesprochenen Regeln, wie im Unternehmen gearbeitet wird: wie man mit Fehlern umgeht, wie offen man Kritik äußert, wer Entscheidungen trifft, was belohnt wird. Sie entsteht immer, auch wenn man nichts tut, dann aber zufällig und geprägt von den lautesten Personen. Wer sie bewusst gestalten will, beginnt mit *Werten*: wenigen (drei bis fünf) Leitsätzen, die sagen, wofür das Unternehmen steht. Allgemeine Wörter wie „Qualität“ oder „Respekt“ helfen wenig, weil sie jeder unterschreibt. Wirksam werden Werte erst, wenn sie als *beobachtbares Verhalten* beschrieben sind: Statt „Kundenfokus“ steht dort „Wir rufen Kunden bei Problemen selbst an und schließen Tickets erst nach Rückfrage“.

Kultur muss sich in *Hiring und Performance* wiederfinden. Bei der Einstellung gibt es zu jedem Wert eine Interviewfrage, die nach Verhalten in der Vergangenheit fragt, bei der Beurteilung zählen Verhalten und Ergebnisse. Ein häufiger Irrtum ist „Culture Fit“ im Sinne von „uns ähnlich“; das führt zu homogenen Teams. Besser ist „Culture Add“: Passt die Person zu den Werten und erweitert sie das Team?

```python
werte = {
    "Kundenfokus": {"verhalten": ["Ruft Kunden bei Problemen selbst an", "Schliesst Tickets erst nach Rueckfrage"], "frage": "Erzaehl von einem Kunden, dem du ueber das Soll hinaus geholfen hast."},
    "Ehrlichkeit": {"verhalten": ["Meldet Fehler selbst im Team"], "frage": ""},
    "Eigenverantwortung": {"verhalten": [], "frage": "Wann hast du ohne Auftrag etwas verbessert?"},
}
for name, w in werte.items():
    luecken = []
    if len(w["verhalten"]) < 2: luecken.append("weniger als 2 beobachtbare Verhaltensweisen")
    if not w["frage"]: luecken.append("keine Interviewfrage")
    print(f"{name:20s}", "OK" if not luecken else "; ".join(luecken))
```

Das Wörterbuch beschreibt drei Werte mit beobachtbaren Verhaltensweisen und einer Interviewfrage. Die Prüfung verlangt mindestens zwei Verhaltensweisen und eine Frage. „Kundenfokus“ ist vollständig. „Ehrlichkeit“ hat nur ein Verhalten und gar keine Frage, bei „Eigenverantwortung“ fehlen die Verhaltensweisen ganz (die Frage ist vorhanden). Ein Wert, der sich nicht beobachten lässt, ist Dekoration; die Prüfung zwingt dazu, ihn zu konkretisieren.

Typische Fehler: Werte, die auf Postern stehen, aber im Alltag nicht gelten; Kultur mit Freizeitangeboten verwechseln; Verhalten, das den Werten widerspricht, aber Ergebnisse bringt, wird belohnt. Falsch: Eine Spitzenverkäuferin, die Kolleginnen herabsetzt, wird wegen Zahlen toleriert. Richtig: Werte gelten für alle, auch für Top-Performer; sonst zählen sie nicht. Kultur wird auch durch Gründer vorgelebt: Was die Gründer tun, wird kopiert, nicht was sie sagen.

> **Merke**
>
> Kultur entsteht ohnehin; Werte machen sie bewusst. Wirksame Werte sind als beobachtbares Verhalten beschrieben und in Hiring und Beurteilung verankert. Sie gelten für alle, auch für Spitzenleistende.

> **Praxisbeispiel**
>
> Eine Probe aufs Exempel: Fragen Sie Mitarbeitende, welches Verhalten im letzten Quartal belohnt wurde und welches nicht. Die Antwort zeigt die gelebte Kultur besser als jedes Wertepapier.

## 10.7 Leadership Operating Rhythm

Der *Operating Rhythm* (Betriebsrhythmus) ist die feste Abfolge von Terminen und Berichten, mit denen ein Unternehmen Fokus und Verantwortlichkeit sichert. Ohne ihn werden Entscheidungen zufällig getroffen, und Dringendes verdrängt Wichtiges. Üblich ist ein Rhythmus aus mehreren Ebenen. Das *Weekly* (30 bis 60 Minuten) bespricht Zahlen der Woche, Blockaden und Prioritäten. Das *Monthly Review* betrachtet Kennzahlen, Budget (Modul 07) und Fortschritt gegenüber Zielen. Quartalsweise werden *OKRs* gesetzt und überprüft, und das *Board Update* informiert Beirat oder Investoren (Modul 07 und 11).

*OKR* steht für *Objectives and Key Results*: Ein Ziel (Objective) beschreibt qualitativ, wohin man will, mehrere messbare Schlüsselergebnisse (Key Results) zeigen, ob man dort ist. Gute Key Results sind messbar, haben Ausgangs- und Zielwert und gehören einer Person. Der Fortschritt eines Key Results ergibt sich als (Ist minus Start) geteilt durch (Ziel minus Start), auf den Bereich 0 bis 1 begrenzt.

```python
from datetime import date, timedelta
okr = {
    "Objective: Zahlende Kunden gewinnen": [
        ("100 zahlende Kunden", 0, 100, 62),
        ("Conversion Trial->Kunde 15 %", 0, 15, 11),
    ],
    "Objective: Stabiler Betrieb": [
        ("Verfuegbarkeit 99,9 %", 99.0, 99.9, 99.7),
        ("MTTR unter 60 Minuten", 120, 60, 85),
    ],
}
for ziel, krs in okr.items():
    scores = []
    for name, start, ziel_wert, ist in krs:
        fortschritt = (ist - start) / (ziel_wert - start)
        scores.append(max(0, min(1, fortschritt)))
        print(f"  {name:32s} {scores[-1]:5.0%}")
    print(f"{ziel}: {sum(scores) / len(scores):.0%}")

montag = date(2026, 11, 2)
termine = [(montag + timedelta(days=7 * i), "Weekly") for i in range(4)] + [(date(2026, 12, 1), "Monthly Review"), (date(2026, 12, 15), "Board Update")]
for d, name in sorted(termine):
    print(f"{d:%d.%m.%Y} {name}")
```

Zwei Ziele haben je zwei Key Results mit Start-, Ziel- und Istwert. Das erste Ziel (Kunden gewinnen) steht bei 62 Prozent (62 von 100 Kunden) und 73 Prozent (11 von 15 Prozent Conversion), im Mittel 68 Prozent. Beim zweiten Ziel (Betrieb) hat die Verfügbarkeit mit 99,7 Prozent zwischen Start 99,0 und Ziel 99,9 einen Fortschritt von 78 Prozent; die Wiederherstellungszeit MTTR (Modul 05) liegt mit 85 Minuten zwischen Start 120 und Ziel 60 bei 58 Prozent, im Mittel ebenfalls 68 Prozent. Die Formel funktioniert auch für absteigende Ziele, weil Zähler und Nenner dann beide negativ sind. Der zweite Teil erzeugt einen Terminplan: vier wöchentliche Termine ab 2. November 2026, ein Monthly Review am 1. Dezember und ein Board Update am 15. Dezember.

Typische Fehler: zu viele Ziele, Key Results als Aufgabenlisten („Webinar organisieren“) statt Ergebnisse, Termine ohne Vorbereitung oder Protokoll, Zahlen, die nicht stimmen. Falsch: zehn Objectives pro Quartal. Richtig: höchstens drei bis fünf Ziele je Unternehmen und Quartal, jedes mit einer verantwortlichen Person. Der Rhythmus muss kurz und stabil sein; wenn er zu schwer wird, verfällt er.

> **Merke**
>
> Ein fester Rhythmus aus Weekly, Monthly, OKRs und Board Update sichert Fokus und Verantwortung. OKRs bestehen aus einem Ziel und messbaren Key Results mit Start- und Zielwert. Wenige Ziele, klare Verantwortliche.

> **Praxisbeispiel**
>
> Das Board Update folgt jedes Mal derselben Gliederung: Kennzahlen, Highlights, Lowlights, Entscheidungen, die man braucht, und Ausblick. Es entspricht dem Investor Reporting aus Modul 07.

## 10.8 Policies und HR Compliance

*HR Compliance* bedeutet, die arbeitsrechtlichen und datenschutzrechtlichen Pflichten gegenüber Mitarbeitenden einzuhalten und das nachweisen zu können. Dazu gehören schriftliche *Arbeitsverträge* (in Österreich muss der Arbeitgeber bei Beginn einen Dienstzettel mit den wesentlichen Bedingungen ausstellen), eine Regelung zu *Arbeitszeit und Ruhezeiten*, Aufzeichnung der Arbeitszeit, klare Regeln für *Remote Work* (Ort, Arbeitsmittel, Kosten, Datenschutz), *Datenschutz* im Personalbereich (Rechtsgrundlagen, Zugriffsrechte, Löschfristen; Modul 06), Vertraulichkeit sowie die Regelung der *Rechte am Arbeitsergebnis*, insbesondere am Quellcode (Modul 11). Die konkreten Anforderungen hängen vom Kollektivvertrag und der Branche ab; die Angaben hier sind allgemeines Fachwissen ohne abgerufene Quelle und im Einzelfall zu prüfen.

Wichtig ist, dass die Dokumente *zentral gepflegt* werden und vollständig sind. Fehlende Unterlagen werden spätestens bei einer Due Diligence (Modul 08) oder einem Rechtsstreit zum Problem.

```python
pflicht = ["Arbeitsvertrag", "Datenschutzbelehrung", "Vertraulichkeitsvereinbarung", "IP-Abtretung"]
personal = {
    "anna":  {"Arbeitsvertrag", "Datenschutzbelehrung", "Vertraulichkeitsvereinbarung", "IP-Abtretung"},
    "ben":   {"Arbeitsvertrag", "Datenschutzbelehrung"},
    "cleo":  {"Arbeitsvertrag", "IP-Abtretung", "Vertraulichkeitsvereinbarung"},
}
for name, docs in personal.items():
    fehlt = [d for d in pflicht if d not in docs]
    print(f"{name:5s}", "vollstaendig" if not fehlt else "fehlt: " + ", ".join(fehlt))

# Arbeitszeitpruefung (Grenzwerte als Parameter, im Einzelfall nach Gesetz/Kollektivvertrag festlegen)
MAX_TAG, MAX_WOCHE, MIN_RUHE = 12, 60, 11
woche = [("Mo", 9, 18.5), ("Di", 8, 21.0), ("Mi", 9, 19.0), ("Do", 8.5, 23.0), ("Fr", 9, 17.0)]
summe = 0
for i, (tag, start, ende) in enumerate(woche):
    dauer = ende - start
    summe += dauer
    if dauer > MAX_TAG:
        print(tag, "ueber Tageshoechstgrenze")
    if i > 0:
        ruhe = (24 - woche[i-1][2]) + start
        if ruhe < MIN_RUHE:
            print(f"{tag}: Ruhezeit nur {ruhe:.1f} h (Parameter {MIN_RUHE} h)")
print(f"Wochensumme {summe:.1f} h", "OK" if summe <= MAX_WOCHE else "zu hoch")
```

Der erste Teil vergleicht für drei Personen die Pflichtdokumente mit den vorhandenen: Anna ist vollständig, bei Ben fehlen Vertraulichkeitsvereinbarung und IP-Abtretung, bei Cleo fehlt die Datenschutzbelehrung. Der zweite Teil prüft eine Arbeitswoche gegen Parameter: höchstens 12 Stunden pro Tag, höchstens 60 pro Woche und mindestens 11 Stunden Ruhezeit. Das sind *Beispielwerte*, die im Programm einstellbar sind; die geltenden Grenzen ergeben sich aus Gesetz und Kollektivvertrag und sind zu prüfen. Am Dienstag (8 bis 21 Uhr, 13 Stunden) und am Donnerstag (8,5 bis 23 Uhr, 14,5 Stunden) wird die Tagesgrenze überschritten, am Freitag liegt die Ruhezeit nach dem langen Donnerstag mit 10,0 Stunden unter dem Parameter. Die Wochensumme beträgt 55,0 Stunden und liegt unter 60.

Typische Fehler: Verträge nach Vorlage ohne Anpassung, mündliche Vereinbarungen, keine Arbeitszeitaufzeichnung, fehlende Datenschutzbelehrung, keine IP-Regelung für Freelancer. Falsch: „Wir sind ein Start-up, da zählt keine Uhr.“ Richtig: Gesetzliche Grenzen und Aufzeichnungen einhalten; wo Vertrauensarbeitszeit vereinbart ist, bleiben Aufzeichnungspflichten bestehen. Ein HR-Ordner mit Verträgen, Belehrungen, Richtlinien und einem Ablaufplan für Eintritt und Austritt (Onboarding und Offboarding, vergleiche Modul 06) ist wenig Aufwand, der sich mehrfach bezahlt macht.

> **Merke**
>
> HR Compliance bündelt Arbeitsverträge, Arbeitszeit, Remote-Regeln, Datenschutz und IP-Regelungen. Dokumente werden vollständig und zentral gepflegt; geltende Grenzen ergeben sich aus Gesetz und Kollektivvertrag und sind im Einzelfall zu prüfen.

> **Praxisbeispiel**
>
> Eine Checkliste für den Eintritt (Vertrag, Belehrungen, IP-Abtretung, Zugänge) und eine für den Austritt (Zugänge sperren, Geräte zurück, Wissensübergabe) macht Compliance zur Routine und kann mit dem Zugriffs-Offboarding aus Modul 06 verbunden werden.

## 10.9 Konfliktmanagement

Konflikte sind in Teams normal und können nützlich sein, wenn sie früh und sachlich behandelt werden. Gefährlich sind unausgesprochene Konflikte, die Monate schwelen. Besonders belastend sind *Founder-Konflikte*: unterschiedliche Vorstellungen über Tempo, Finanzierung, Rollen oder Anteile. Hinzu kommen *Rollenwechsel* (wenn ein Gründer eine Aufgabe abgeben soll, die er bisher innehatte) und *Performance-Probleme*. Die meisten Konflikte beginnen als Missverständnisse über Erwartungen, daher hilft früh klare Kommunikation: Beobachtung, Wirkung, Wunsch statt Vorwurf.

Für den Fall, dass Gespräche nicht genügen, definiert man vorab *Eskalationsmechanismen*. Üblich ist eine Stufenfolge: das direkte Gespräch, ein moderiertes Gespräch mit einer vertrauten Drittperson (Mentor, Beiratsmitglied), danach eine Mediation durch eine neutrale Fachperson und zuletzt eine vertraglich vereinbarte Entscheidungsklausel. Ein besonders wichtiger Punkt sind *Pattsituationen*: Bei zwei Gründern mit je 50 Prozent der Stimmen kann keiner die Mehrheit erreichen. Gegenmittel sind ein Beirat mit unabhängigem Mitglied, ein Stichentscheid oder Regeln für den Ausstieg (zum Beispiel Kauf- und Verkaufsklauseln); die rechtliche Ausgestaltung gehört in den Gesellschaftervertrag (Modul 02).

```python
from datetime import date, timedelta
def stimmen(anteile, ja):
    gesamt = sum(anteile.values())
    return sum(anteile[n] for n in ja) / gesamt

anteile = {"Gruender A": 0.40, "Gruender B": 0.40, "Investor": 0.20}
for titel, ja in (("A und B", ["Gruender A", "Gruender B"]), ("A und Investor", ["Gruender A", "Investor"]), ("nur A", ["Gruender A"])):
    anteil = stimmen(anteile, ja)
    print(f"{titel:15s} {anteil:5.0%} -> einfache Mehrheit: {anteil > 0.5}, 75 %: {anteil >= 0.75}")

stufen = [("Direktes Gespraech der Beteiligten", 7), ("Moderiertes Gespraech (Mentor/Beirat)", 14), ("Mediation", 30), ("Vertragliche Entscheidungsklausel", 0)]
start = date(2026, 11, 2)
for name, tage in stufen:
    start_stufe = start
    start = start + timedelta(days=tage)
    print(f"{start_stufe:%d.%m.%Y} {name} (bis {start:%d.%m.%Y})")
```

Die Funktion `stimmen` berechnet den Stimmanteil der Zustimmenden. Bei der Beispielstruktur (Gründer A 40 Prozent, Gründer B 40 Prozent, Investor 20 Prozent) erreichen A und B zusammen 80 Prozent und damit sowohl die einfache Mehrheit als auch eine Schwelle von 75 Prozent; A und der Investor erreichen 60 Prozent (einfache Mehrheit ja, 75 Prozent nein); A allein hat 40 Prozent. Die Schwellen sind Beispiele: Welche Mehrheiten für welche Beschlüsse gelten, steht im Gesellschaftsvertrag und im Gesetz. Der zweite Teil legt für eine Eskalation Fristen fest: direktes Gespräch bis 9. November 2026, moderiertes Gespräch bis 23. November, Mediation bis 23. Dezember, danach greift eine vertragliche Entscheidungsklausel. Feste Fristen verhindern, dass Konflikte sich ewig hinziehen.

Typische Fehler: Probleme aussitzen, Konflikte über Dritte austragen, keine Regel für Pattsituationen, ein Ausscheiden ohne geregelte Anteile (Vesting und Leaver-Klauseln, Modul 08). Falsch: „Das regeln wir, wenn es soweit ist.“ Richtig: Die Regeln schreibt man am Anfang auf, wenn man sich gut versteht; im Streit sind Vereinbarungen kaum noch möglich. Wer Konflikte früh anspricht, spart meist Zeit und Geld.

> **Merke**
>
> Konflikte werden früh und sachlich angesprochen. Eskalationsstufen, Fristen und Regeln für Pattsituationen und Ausstieg werden im Voraus vereinbart und im Gesellschaftsvertrag verankert.

> **Praxisbeispiel**
>
> Investoren prüfen die Gründerbeziehung genau, weil Konflikte der häufigste Grund für das Scheitern junger Unternehmen sind. Ein halbjährliches Gründergespräch zu Rollen, Erwartungen und Zufriedenheit ist ein günstiges Frühwarnsystem.

## Übungsaufgaben zu Modul 10

1.  **(leicht)** Erkläre den Unterschied zwischen *Responsible* und *Accountable* in einer RACI-Matrix und warum es genau ein A geben soll.

2.  **(leicht)** Nenne drei Vorteile strukturierter Interviews gegenüber freien Gesprächen.

3.  **(leicht)** Ein Pool von 10 Prozent soll bei 8 000 000 Anteilen reserviert werden. Wie viele Optionen sind das?

4.  **(mittel)** Eine Entwicklerin verdient 4 500 Euro brutto im Monat. Wie hoch sind die Monatskosten bei dem Faktor 1,28 aus Modul 07 (Annahme)?

5.  **(mittel)** 6 000 Optionen werden über drei Jahre mit einem Jahr Cliff erdient. Wie viele sind nach 11, 18 und 36 Monaten erdient?

6.  **(praktisch)** Schreibe ein Programm, das in einer RACI-Matrix Entscheidungen findet, bei denen niemand *Responsible* (R) ist.

7.  **(praktisch)** Schreibe eine Funktion, die den Fortschritt eines Key Results aus Start-, Ziel- und Istwert berechnet und auf 0 bis 1 begrenzt; teste sie mit auf- und absteigenden Zielen.

8.  **(schwer/praktisch)** Verallgemeinere die Vesting-Funktion aus 10.5 auf beliebige Laufzeit und Cliff und prüfe sie an dem Beispiel aus Aufgabe 5.

## Lösungen zu den Übungsaufgaben Modul 10

**1.** Responsible ist, wer die Aufgabe ausführt; Accountable ist, wer entscheidet und die Verantwortung für das Ergebnis trägt. Es soll genau ein A geben, weil bei zwei Entscheidern bei Meinungsverschiedenheit niemand das letzte Wort hat und bei keinem Entscheider niemand haftet; beides führt zu Stillstand oder Streit.

**2.** Strukturierte Interviews sind vergleichbarer (gleiche Fragen), weniger anfällig für Sympathie und Bias (vorab festgelegte Kriterien, getrennte Bewertung) und besser nachvollziehbar (schriftliche Scorecard). Außerdem sind sie rechtlich leichter zu begründen.

**3.** 8 000 000 mal 0,10 = 800 000 Optionen.

**4.** 4 500 mal 1,28 = 5 760 Euro pro Monat. Der Faktor ist eine Annahme und hängt unter anderem vom Sozialversicherungssatz ab (Modul 07).

**5.** Nach 11 Monaten sind es 0 (Cliff nicht erreicht), nach 18 Monaten 6 000 mal 18 geteilt durch 36 = 3 000, nach 36 Monaten alle 6 000.

**6.** Mögliche Lösung:

```python
matrix = {
    "Preisgestaltung": {"CEO": "A", "Sales": "R", "CTO": "C"},
    "Release-Freigabe": {"CTO": "A", "CEO": "I"},
}
for thema, rollen in matrix.items():
    ohne_r = "R" not in rollen.values()
    print(thema, "-> niemand fuehrt aus (kein R)" if ohne_r else "-> OK")
```

Das Programm prüft, ob in den Werten der Rollen ein `R` vorkommt. Bei der Preisgestaltung führt der Vertrieb aus (R), bei der Release-Freigabe fehlt ein Ausführender.

**7.** Mögliche Lösung:

```python
import math
def okr_score(start, ziel, ist):
    return max(0.0, min(1.0, (ist - start) / (ziel - start)))
print(round(okr_score(0, 50, 30), 2))        # aufsteigend
print(round(okr_score(10, 2, 4), 2))         # absteigend: Ziel unter Start
print(round(okr_score(0, 50, 80), 2))        # uebererfuellt wird bei 1,0 gekappt
```

Im ersten Fall ist (30 minus 0) geteilt durch (50 minus 0) = 0,6. Im zweiten Fall sinkt das Ziel von 10 auf 2; mit Ist 4 ergibt sich (4 minus 10) geteilt durch (2 minus 10) = 0,75. Im dritten Fall wird die Übererfüllung auf 1,0 begrenzt.

**8.** Mögliche Lösung:

```python
def lineares_vesting(monate, gesamt, cliff, laufzeit):
    return 0 if monate < cliff else min(gesamt, gesamt * monate // laufzeit)
print(lineares_vesting(18, 6000, 12, 36), lineares_vesting(11, 6000, 12, 36), lineares_vesting(36, 6000, 12, 36))
```

Die Funktion gibt für 18 Monate 3 000, für 11 Monate 0 und für 36 Monate 6 000 zurück, entsprechend Aufgabe 5. Wichtig ist die Ganzzahl-Division, damit keine halben Optionen entstehen, und die Begrenzung auf die Gesamtzahl.
