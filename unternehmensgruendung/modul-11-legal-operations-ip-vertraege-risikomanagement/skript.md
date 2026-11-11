# Modul 11 - Legal Operations, IP, Verträge und Risikomanagement

> **Hinweis zu diesem Kapitel:** Das ist das Kapitel des Skripts „Unternehmensgründung“, aus der LaTeX-Quelle in Markdown umgewandelt (Text und Codeblöcke unverändert, farbige Boxen als Zitatblöcke mit fettem Titel, Tabellen als Markdown-Tabellen). Die Lerneinheiten sind wie in der Quelle nach Modul nummeriert (11.1 bis 11.9), danach folgen „Übungsaufgaben zu Modul 11“ (8 Aufgaben, mit Schwierigkeitsangabe) und „Lösungen zu den Übungsaufgaben Modul 11“. Rechtliche und steuerliche Aussagen sind keine Rechtsberatung. Was ich an den Beispielen geprüft habe, steht in der [README des Repositories](../README.md). Übersicht zum Modul: [README](README.md).

**Dauer:** 8 h laut Modulübersicht (Summe der Einzelwerte: 9 × 0,9 h = 8,1 h, gerundet)

**Priorität:** 2

| **Nr.** | **Lerneinheit**          | **Dauer (h)** |
|--------:|:-------------------------|--------------:|
|    11.1 | IP Strategie             |           0,9 |
|    11.2 | Open Source Compliance   |           0,9 |
|    11.3 | Kundenverträge           |           0,9 |
|    11.4 | Auftragsverarbeitung     |           0,9 |
|    11.5 | Lieferantenmanagement    |           0,9 |
|    11.6 | Haftung und Versicherung |           0,9 |
|    11.7 | Policy Set               |           0,9 |
|    11.8 | Risikoregister           |           0,9 |
|    11.9 | Board und Governance     |           0,9 |
|         | **Summe**                |       **8,1** |

*Legal Operations* meint die laufende Organisation der rechtlichen Seite eines Unternehmens: Verträge, Rechte an geistigem Eigentum, Lieferanten, Richtlinien und Risiken. Es geht nicht darum, Juristinnen oder Juristen zu ersetzen, sondern darum, Ordnung zu schaffen, damit Fachleute effizient helfen können und das Unternehmen bei Kunden, Investoren und Behörden vorbereitet auftritt. Das Modul baut auf Modul 02 (Rechtsform), Modul 06 (Datenschutz und Sicherheit) und Modul 08 (Due Diligence) auf. **Alle Inhalte sind allgemeine Information und keine Rechtsberatung.** Vertragsentwürfe und Haftungsfragen gehören vor Verwendung rechtlich geprüft. Die Programme laufen mit Python 3 ohne Zusatzpakete; alle Zahlen sind erfundene Beispiele.

## 11.1 IP Strategie

*IP* steht für *Intellectual Property*, geistiges Eigentum. Für ein Technikunternehmen liegt darin oft der größte Wert. Zu den Arten gehören: *Marken* (Name, Logo; Schutz durch Registrierung), *Domains* (Internetadressen, die auf einer Person oder Firma laufen), *Urheberrecht* am Quellcode, an Texten und Designs (entsteht automatisch beim Schaffen), *Daten* und Datensätze (Schutz teils nur über Verträge und Geschäftsgeheimnisse), *Geschäftsgeheimnisse* (vertrauliches Wissen, das durch angemessene Schutzmaßnahmen geschützt ist) und *Patente* (Schutz technischer Erfindungen, aufwendig und in manchen Bereichen, etwa bei reiner Software, eingeschränkt). Eine IP-Strategie legt fest, was man schützt, wie man es schützt und wem es gehört.

Der wichtigste Punkt ist die *saubere Zuordnung der Eigentumsrechte*. Bei Mitarbeitenden hängt die Zuordnung vom Arbeitsverhältnis und von Vereinbarungen ab; bei *Freelancern* und bei Gründerinnen und Gründern, die vor der Gründung am Produkt gearbeitet haben, gehört der Code zunächst den Schöpfern, solange er nicht ausdrücklich übertragen oder lizenziert wurde. Fehlende Übertragungen sind eine der häufigsten Red Flags in einer Due Diligence (Modul 08). Ebenso ist zu klären, wer die Marke und die Domain hält: gehört die Domain einer Privatperson, hat die Firma ein Risiko.

Ein praktisches Werkzeug ist ein *IP-Register*: eine Liste aller wesentlichen Werte mit Art, Inhaber und Status der Anmeldung, ergänzt um eine Liste aller Beitragenden und ihrer Verträge.

```python
ip_register = [
    {"gegenstand": "Marke 'Beispielwerk'",  "art": "Marke",   "inhaber": "Muster GmbH", "angemeldet": True},
    {"gegenstand": "Domain beispielwerk.at", "art": "Domain",  "inhaber": "Max Muster (privat)", "angemeldet": True},
    {"gegenstand": "Quellcode Kernprodukt",  "art": "Code",    "inhaber": "Muster GmbH", "angemeldet": False},
    {"gegenstand": "Trainingsdatensatz",     "art": "Daten",   "inhaber": "unklar", "angemeldet": False},
]
beitragende = {
    "Anna (Angestellte)":    {"vertrag_mit_rechteuebertragung": True},
    "Ben (Freelancer)":      {"vertrag_mit_rechteuebertragung": False},
    "Cleo (Gruenderin, vor Gruendung)": {"vertrag_mit_rechteuebertragung": False},
}
firma = "Muster GmbH"
for eintrag in ip_register:
    if eintrag["inhaber"] != firma:
        print(f"Inhaber pruefen: {eintrag['gegenstand']} -> {eintrag['inhaber']}")
for name, daten in beitragende.items():
    if not daten["vertrag_mit_rechteuebertragung"]:
        print(f"Rechteuebertragung fehlt: {name}")
```

Das Programm enthält ein Register mit vier Werten und eine Liste dreier Beitragender. Zuerst vergleicht es den Inhaber jedes Eintrags mit der Firma und meldet zwei Fälle: Die Domain gehört einer Privatperson, und der Trainingsdatensatz hat einen unklaren Inhaber. Danach prüft es, ob für jede beitragende Person ein Vertrag mit Rechteübertragung vorliegt. Beim Freelancer Ben und bei der Gründerin Cleo (die vor der Gründung mitgearbeitet hat) fehlt er. Genau diese Lücken stören später Finanzierungen und Verkäufe. Die Behebung ist meist einfach: eine nachträgliche Übertragungsvereinbarung, die Domain auf die Firma übertragen und der Datensatz mit seinen Rechten dokumentiert.

Typische Fehler: Markennamen verwenden, ohne Konflikte mit bestehenden Marken zu prüfen (Recherche in den Registern des Österreichischen Patentamts, des EUIPO und anderer Ämter); Patente anmelden, bevor man den Nutzen geprüft hat, oder die Erfindung vorher öffentlich zeigen (Neuheitsschädlichkeit); Geschäftsgeheimnisse ohne Vertraulichkeitsvereinbarungen weitergeben. Falsch: „Der Freelancer hat den Code geschrieben und bezahlt bekommen, also gehört er uns.“ Richtig: Eine schriftliche Vereinbarung, die Nutzungs- und Verwertungsrechte ausdrücklich überträgt oder in ausreichendem Umfang einräumt. Wenn Daten und KI eine Rolle spielen, gehört auch die Herkunft der Trainingsdaten dazu (Modul 06).

> **Merke**
>
> IP umfasst Marken, Domains, Code, Daten, Geschäftsgeheimnisse und Patente. Entscheidend ist die lückenlose Zuordnung: Wer hat etwas geschaffen, und wurden die Rechte ausdrücklich übertragen? Ein IP-Register mit Beitragsliste schafft Überblick.

> **Praxisbeispiel**
>
> Bei jeder Investorenprüfung wird nach IP-Zuordnung gefragt. Wer das Register, die Abtretungsvereinbarungen und den Domain-Zugang vorbereitet hat, spart Wochen und hält Verhandlungsspielraum.

## 11.2 Open Source Compliance

Moderne Software besteht zum größten Teil aus fremden Bausteinen, viele davon *Open Source*: Der Quellcode ist öffentlich und darf unter Bedingungen einer *Lizenz* genutzt werden. Die Lizenz entscheidet, was man tun muss oder darf. *Permissive Lizenzen* (zum Beispiel MIT, BSD, Apache 2.0) erlauben fast jede Nutzung, auch in kommerzieller, geschlossener Software, verlangen aber meist die Nennung der Urheber und der Lizenz (*Attribution*). *Copyleft-Lizenzen* (zum Beispiel GPL) verlangen, dass abgeleitete Werke unter derselben Lizenz veröffentlicht werden, was für ein kommerzielles Produkt, das nicht offengelegt werden soll, ein Problem sein kann. Die AGPL erweitert das auf Software, die nur über ein Netzwerk genutzt wird (typisch bei SaaS). Zwischen beiden liegen *schwaches Copyleft* (zum Beispiel LGPL, MPL), bei dem die Verpflichtungen auf bestimmte Dateien oder Bibliotheken beschränkt sind. Welche Folge eine Lizenz bei konkreter Nutzung (Einbindung, Verlinkung, Weitergabe) hat, ist im Einzelfall juristisch zu prüfen.

Compliance heißt, die eingesetzten Komponenten zu *kennen*, zu *bewerten* und die Pflichten zu *erfüllen*. Grundlage ist eine *Komponentenliste* (SBOM, Software Bill of Materials, vergleiche Modul 06) mit Name, Version und Lizenz, idealerweise automatisch aus der Entwicklungsumgebung erzeugt. Dazu kommt ein *Freigabeprozess*: Eine kurze Richtlinie legt fest, welche Lizenzen automatisch erlaubt sind, welche zur Prüfung vorgelegt werden müssen und welche verboten sind.

```python
POLICY = {"MIT": "erlaubt", "BSD-3-Clause": "erlaubt", "Apache-2.0": "erlaubt",
          "LGPL-3.0": "pruefen", "MPL-2.0": "pruefen", "GPL-3.0": "verboten", "AGPL-3.0": "verboten"}
sbom = [
    ("web-framework", "4.2.0", "MIT"), ("json-lib", "1.8.1", "Apache-2.0"),
    ("pdf-render", "2.0.3", "LGPL-3.0"), ("chart-kit", "0.9.0", "GPL-3.0"),
    ("cache-x", "3.1.0", "Proprietary"),
]
for name, version, lizenz in sbom:
    status = POLICY.get(lizenz, "unbekannt: klaeren")
    print(f"{name:14s} {version:7s} {lizenz:12s} -> {status}")
pflichten = [f"{n} {v}: {l}" for n, v, l in sbom if POLICY.get(l) == "erlaubt"]
print("Attribution (Hinweisdatei):")
for z in pflichten:
    print("  ", z)
```

Die Richtlinie ordnet Lizenzen drei Stufen zu. Die Liste `sbom` enthält fünf Komponenten. Für jede wird die Stufe nachgeschlagen; `POLICY.get(lizenz, ...)` liefert bei unbekannter Lizenz den Standardtext „unbekannt: klären“. Das Web-Framework (MIT) und die JSON-Bibliothek (Apache-2.0) sind erlaubt. Die PDF-Bibliothek (LGPL-3.0) ist zu prüfen, etwa wie sie eingebunden ist. Die Diagramm-Bibliothek (GPL-3.0) ist verboten, weil sie das eigene Produkt unter die GPL bringen könnte, und die Komponente „cache-x“ hat eine proprietäre Lizenz, die erst geklärt werden muss. Im zweiten Teil entsteht aus den erlaubten Komponenten eine Hinweisliste für die Attribution. Vereinfachend enthält sie nur die „erlaubten“; auch geprüfte Komponenten mit Pflichten gehören in eine echte Hinweisdatei.

Typische Fehler: Lizenzen erst im Verkaufsprozess prüfen, Abhängigkeiten von Abhängigkeiten übersehen (transitive Abhängigkeiten), Code aus Foren oder KI-Werkzeugen ohne Herkunftsprüfung übernehmen, Komponenten ohne Lizenz verwenden (ohne Lizenz gilt grundsätzlich „alle Rechte vorbehalten“). Falsch: „Es steht auf GitHub, also darf man es nutzen.“ Richtig: Die Lizenz prüfen und die Komponentenliste führen. Wer selbst Open Source veröffentlicht, wählt die Lizenz bewusst und beachtet Beiträge Dritter (Contributor-Vereinbarungen).

> **Merke**
>
> Open-Source-Lizenzen haben Pflichten: Permissive verlangen meist Attribution, Copyleft kann Offenlegung verlangen, die AGPL erfasst auch Netzwerknutzung. Eine Komponentenliste und eine Freigaberichtlinie machen Compliance beherrschbar.

> **Praxisbeispiel**
>
> Kunden aus regulierten Branchen und Käufer in einer Due Diligence fordern häufig eine Liste der Komponenten mit Lizenzen. Wer sie automatisiert erzeugt und regelmäßig prüft, kann sie sofort liefern.

## 11.3 Kundenverträge

Ein *Kundenvertrag* legt fest, was ein Unternehmen liefert, was der Kunde zahlt und wer bei Problemen wofür einsteht. Bei Software-Abonnements besteht er meist aus einem Hauptvertrag (Rahmenbedingungen) und Anlagen: Leistungsbeschreibung, *SLA* (Service Level Agreement, zugesicherte Verfügbarkeit und Reaktionszeiten, siehe Modul 05), Auftragsverarbeitung (Lerneinheit 11.4) und Preisliste. Wichtige Regelungsfelder sind: Leistungsumfang und Abgrenzung, Preise, Zahlungsfristen und Anpassung, Laufzeit und Kündigung, SLA und Folgen bei Nichteinhaltung (zum Beispiel eine Gutschrift), Haftung und deren Begrenzung, Datenschutz und Sicherheit, Geheimhaltung, Rechte am Arbeitsergebnis und an Daten, sowie Gerichtsstand und anwendbares Recht.

Besonders wichtig ist der *Standardvertrag mit Verhandlungsspielraum*: Ein Unternehmen, das jeden Vertrag neu verhandelt, verliert Zeit. Besser ist eine Standardvorlage, die man bei Großkunden in definierten Punkten anpassen darf (zum Beispiel Laufzeit, SLA-Staffel, Haftungsdeckel), und eine Liste von Punkten, bei denen man nie nachgibt (zum Beispiel unbegrenzte Haftung). Wer das vorab entscheidet, verhandelt schneller und konsistenter.

> **Ergänzung aus der Nachrecherche**
>
> Die Regeln des EU Data Act zum Anbieterwechsel bei Datenverarbeitungsdiensten beeinflussen Verträge mit Kunden: Laut einer Analyse von DLA Piper (31. Juli 2025) gilt der Data Act seit 12. September 2025; Wechselrechte erlauben Kunden eine Kündigung mit höchstens zwei Monaten Frist, und Wechselentgelte sind bei SaaS bis 12. Jänner 2027 ausgeschlossen (Quelle Q5). Kündigungs- und Datenexport-Klauseln sind daher gegen diese Vorgaben zu prüfen (keine Rechtsberatung; Anwendbarkeit auf das konkrete Produkt klären).

```python
# SLA-Gutschrift und Haftungsgrenze (Beispielwerte)
monatsentgelt = 2_000.0
verfuegbarkeit_ist = 99.2
staffel = [(99.9, 0.0), (99.0, 0.10), (95.0, 0.25), (0.0, 0.50)]   # (Untergrenze der Verfuegbarkeit, Gutschrift)
for grenze, quote in staffel:
    if verfuegbarkeit_ist >= grenze:
        gutschrift = monatsentgelt * quote
        print(f"Verfuegbarkeit {verfuegbarkeit_ist} % -> Gutschrift {quote:.0%} = {gutschrift:.2f} EUR")
        break

jahresentgelt = 24_000.0
haftungsgrenze = 1.0 * jahresentgelt       # Deckel: einfaches Jahresentgelt
schaden = 80_000.0
print(f"Schaden {schaden:,.0f} EUR, Haftungsdeckel {haftungsgrenze:,.0f} EUR -> ersetzt max. {min(schaden, haftungsgrenze):,.0f} EUR")

checkliste = {"Leistungsumfang": True, "SLA": True, "Haftungsbegrenzung": True, "AV-Vertrag": False, "Kuendigung": True, "Zahlungsziel": True}
print("Fehlt im Vertrag:", [k for k, v in checkliste.items() if not v])
```

Das Beispiel rechnet drei Dinge. Erstens eine SLA-Gutschrift: Die Staffel besteht aus Untergrenzen der Verfügbarkeit und zugehörigen Gutschriftsquoten. Bei einer Ist-Verfügbarkeit von 99,2 Prozent trifft die zweite Zeile zu (mindestens 99,0 Prozent), die Gutschrift beträgt 10 Prozent des Monatsentgelts von 2 000 Euro, also 200 Euro. Zweitens ein Haftungsdeckel in Höhe eines Jahresentgelts von 24 000 Euro: Bei einem Schaden von 80 000 Euro ersetzt das Unternehmen höchstens 24 000 Euro, das Restrisiko trägt der Kunde. Drittens eine Checkliste, die meldet, dass im Vertrag noch der AV-Vertrag fehlt. Die Zahlen sind Beispielwerte; ob eine Haftungsbegrenzung wirksam ist, hängt unter anderem davon ab, ob sie in Allgemeinen Geschäftsbedingungen steht und welche Schäden betroffen sind (zum Beispiel sind Haftungsausschlüsse für Vorsatz oder Personenschäden regelmäßig begrenzt), weshalb eine juristische Prüfung nötig ist.

Typische Fehler: Verträge aus dem Internet kopieren, ohne sie anzupassen, mündliche Nebenabreden, Zusagen im Vertrieb, die der Vertrag nicht deckt, und Haftung unbegrenzt zu akzeptieren. Falsch: Der Vertrieb sagt Verfügbarkeit von 100 Prozent zu, um den Abschluss zu erreichen. Richtig: Zusagen müssen mit dem SLA im Vertrag und mit dem technischen Betrieb übereinstimmen (Modul 05). Ein Vertragsregister (Kunde, Laufzeit, Kündigungsfrist, Sonderklauseln) hilft, Verlängerungen im Blick zu behalten.

> **Merke**
>
> Kundenverträge regeln Leistung, SLA, Haftung, Datenschutz und Kündigung. Ein Standardvertrag mit definiertem Verhandlungsspielraum beschleunigt den Vertrieb. Zusagen im Vertrieb müssen mit Vertrag und Betrieb übereinstimmen.

> **Praxisbeispiel**
>
> Großkunden legen oft eigene Vertragsvorlagen vor. Wer die eigenen Kernforderungen kennt (Haftung, Datenschutz, Kündigung), kann deren Vorlage gezielt prüfen und spart Wochen an Verhandlungen.

## 11.4 Auftragsverarbeitung

Verarbeitet ein Unternehmen personenbezogene Daten im Auftrag seiner Kunden (typisch bei SaaS), ist es *Auftragsverarbeiter*, der Kunde ist *Verantwortlicher* (Modul 06). Dann verlangt die DSGVO einen schriftlichen Vertrag, die *Auftragsverarbeitungsvereinbarung* (AVV, englisch DPA, Data Processing Agreement). Sie regelt Gegenstand und Dauer, Art und Zweck der Verarbeitung, Datenarten und Betroffene, Weisungsgebundenheit, Vertraulichkeit, Sicherheitsmaßnahmen, Unterstützung bei Betroffenenanfragen, Löschung oder Rückgabe nach Vertragsende, Kontrollrechte und den Einsatz weiterer Auftragsverarbeiter.

Zwei Bestandteile sind in der Praxis besonders wichtig. Die *TOMs* (technische und organisatorische Maßnahmen) beschreiben, wie Daten geschützt werden: Zugangskontrolle, Verschlüsselung, Backups, Protokollierung, Schulungen. Die *Subprozessoren* sind die Dienstleister, die der Auftragsverarbeiter seinerseits einsetzt (Cloud-Hosting, E-Mail-Versand, Ticketsystem). Der Verantwortliche darf nur zustimmen, wenn er sie kennt; der Auftragsverarbeiter benötigt dafür eine Genehmigung und muss Änderungen mitteilen, oft mit einer Frist zum Widerspruch. Für Subprozessoren gelten wiederum eigene Verträge mit denselben Pflichten. Werden Daten in Länder außerhalb des EU/EWR übermittelt, ist zusätzlich eine Übermittlungsgrundlage nötig (rechtlich zu prüfen).

```python
from datetime import date, timedelta
subprozessoren = [
    {"name": "CloudHost", "zweck": "Hosting", "standort": "EU", "avv": True,  "mitgeteilt_am": date(2026, 1, 10)},
    {"name": "MailTool",  "zweck": "E-Mail-Versand", "standort": "USA", "avv": True, "mitgeteilt_am": None},
    {"name": "SupportDesk", "zweck": "Ticketsystem", "standort": "EU", "avv": False, "mitgeteilt_am": date(2026, 3, 1)},
]
for s in subprozessoren:
    fehler = []
    if not s["avv"]: fehler.append("Vertrag mit Subprozessor fehlt")
    if s["mitgeteilt_am"] is None: fehler.append("Kunden nicht informiert")
    if s["standort"] != "EU": fehler.append("Drittland: Uebermittlungsgrundlage pruefen")
    print(f"{s['name']:12s}", "OK" if not fehler else "; ".join(fehler))

einspruchsfrist_tage = 30
neu_am = date(2026, 12, 1)
print(f"Neuer Subprozessor fruehestens ab {neu_am + timedelta(days=einspruchsfrist_tage)} (Ankuendigung am {neu_am})")

toms = {"Zugangskontrolle": True, "Verschluesselung": True, "Backup": True, "Protokollierung": False, "Schulung": False}
print(f"TOMs umgesetzt: {sum(toms.values())}/{len(toms)}; offen: {[k for k, v in toms.items() if not v]}")
```

Das Programm führt das Register der Subprozessoren. CloudHost ist in Ordnung. Beim E-Mail-Dienst MailTool wurden die Kunden nicht informiert, und der Standort USA verlangt die Prüfung einer Übermittlungsgrundlage. Beim Ticketsystem SupportDesk fehlt der Vertrag. Danach wird mit einer Einspruchsfrist von 30 Tagen berechnet, dass ein am 1. Dezember 2026 angekündigter neuer Subprozessor frühestens am 31. Dezember 2026 eingesetzt werden darf. Die letzte Auswertung zählt die TOMs: Drei von fünf sind umgesetzt, offen sind Protokollierung und Schulung. Für Kundenaudits ist diese Liste Gold wert, denn sie beantwortet die Standardfragen sofort.

Typische Fehler: Vorlagen ohne eigene TOMs, Subprozessoren ohne Vertrag, Änderungen ohne Information, Kundenaudits, bei denen jede Frage neu recherchiert wird. Falsch: „Wir haben einen AV-Vertrag, den hat uns der Anbieter geschickt.“ Richtig: Den Vertrag auf die eigene Situation prüfen, die Maßnahmen tatsächlich umsetzen und die Liste der Subprozessoren pflegen. Als Vorbereitung für Audits eignet sich ein Antwortbaukasten mit Standardantworten, Zertifikaten (zum Beispiel ISO 27001) und Berichten.

> **Merke**
>
> Als Auftragsverarbeiter braucht man eine AVV mit Kunden, dokumentierte TOMs und ein gepflegtes Register der Subprozessoren samt Vertrag und Mitteilungspflichten. Drittlandübermittlungen sind gesondert zu prüfen. Ein Antwortbaukasten beschleunigt Audits.

> **Praxisbeispiel**
>
> Ein öffentlich zugängliches „Trust Center“ mit AVV-Muster, Subprozessorenliste, TOMs und Sicherheitsdokumenten verkürzt Vertriebszyklen, weil Einkauf und IT-Sicherheit vieles selbst nachlesen können.

## 11.5 Lieferantenmanagement

Auch ein kleines Technikunternehmen hängt von Lieferanten ab: Cloud-Provider, Zahlungsdienste, E-Mail- und Kommunikationswerkzeuge, Entwicklungswerkzeuge, Beratungen. Fällt einer aus, wird teurer oder verstößt gegen Datenschutzregeln, trifft das das eigene Geschäft. *Lieferantenmanagement* bedeutet, die Anbieter zu erfassen, nach Bedeutung zu bewerten und die Risiken zu steuern. Die relevanten Risiken sind *Ausfall* (Verfügbarkeit), *Datenschutz und Sicherheit* (Zugriff auf personenbezogene Daten, Zertifikate), *Kosten* (Preiserhöhungen, nutzungsabhängige Preise) und *Abhängigkeit* (Lock-in, schwere Ersetzbarkeit).

Für die Bewertung genügt ein einfaches Modell: Wie kritisch ist der Lieferant für das Geschäft, verarbeitet er personenbezogene Daten, und wie schwer wäre ein Wechsel? Kritische Anbieter erhalten genauere Prüfung (Sicherheitsnachweise, Vertrag mit SLA und Datenrückgabe, Exit-Plan), unkritische werden einfach erfasst. Auch die *Exit-Frage* gehört dazu: Wie kommen wir an unsere Daten, und wie lange dauert ein Wechsel?

```python
lieferanten = [
    # (Name, Kritikalitaet 1-5, personenbezogene Daten, Ersetzbarkeit 1 leicht - 5 schwer, Monatskosten, Wechselaufwand EUR)
    ("Cloud-Provider", 5, True,  4, 6_000, 80_000),
    ("E-Mail-Dienst",  3, True,  2, 400,   3_000),
    ("Design-Tool",    1, False, 1, 150,   500),
    ("Zahlungsdienst", 5, True,  3, 900,   20_000),
]
def risiko(krit, daten, ersetz):
    return krit * 2 + (3 if daten else 0) + ersetz
for name, krit, daten, ersetz, kosten, wechsel in sorted(lieferanten, key=lambda l: -risiko(l[1], l[2], l[3])):
    r = risiko(krit, daten, ersetz)
    stufe = "hoch" if r >= 14 else "mittel" if r >= 8 else "niedrig"
    print(f"{name:15s} Risiko {r:2d} ({stufe:7s}) Wechselaufwand = {wechsel / kosten:5.1f} Monatskosten")
```

Jeder Lieferant bekommt vier Angaben: Kritikalität (1 bis 5), Datenverarbeitung (ja oder nein), Ersetzbarkeit (1 leicht bis 5 schwer) und Kosten. Das Risiko ist Kritikalität mal 2, plus 3 Punkte bei personenbezogenen Daten, plus Ersetzbarkeit. Der Cloud-Provider erreicht 17 (hoch), der Zahlungsdienst 16 (hoch), der E-Mail-Dienst 11 (mittel), das Design-Tool 3 (niedrig). Die letzte Spalte ist der Wechselaufwand in Monatskosten: Beim Zahlungsdienst entspricht ein Wechsel 22,2 Monatskosten (20 000 durch 900 Euro), beim Cloud-Provider 13,3. Das macht sichtbar, wie teuer eine Abhängigkeit wäre. Die Gewichte sind Annahmen und gehören an das eigene Geschäft angepasst.

Typische Fehler: Werkzeuge ohne Prüfung einkaufen („Schatten-IT“), nur auf den Preis schauen, Verträge ohne Kündigungsregelungen oder Datenrückgabe, kein Ersatzplan für kritische Anbieter. Falsch: Man speichert alle Daten in einem proprietären Format eines einzigen Anbieters. Richtig: Exportfunktionen testen, Standardformate bevorzugen und für kritische Bereiche eine Alternative kennen (Modul 12, Resilienz). Zusätzlich sind regulatorische Anforderungen zu beachten, wenn Kunden den Einsatz bestimmter Unterauftragnehmer einschränken (Lerneinheit 11.4).

> **Merke**
>
> Lieferanten werden erfasst und nach Kritikalität, Datenzugriff und Ersetzbarkeit bewertet. Für kritische Anbieter gelten Sicherheitsprüfung, Vertragsregelungen und ein Exit-Plan. Wechselaufwand macht Abhängigkeit sichtbar.

> **Praxisbeispiel**
>
> Eine Liste aller Werkzeuge mit Verantwortlichen, Kosten, Vertragsende und Datenarten deckt oft vergessene Abonnements auf und liefert die Grundlage für Kostenoptimierung (Modul 12) und für das Register der Subprozessoren.

## 11.6 Haftung und Versicherung

*Haftung* bedeutet, für Schäden einstehen zu müssen, die man anderen zufügt. Für Technikunternehmen kommen mehrere Quellen in Betracht: *vertragliche Haftung* gegenüber Kunden (zum Beispiel für Ausfälle oder fehlerhafte Leistung, begrenzt durch Vertragsklauseln), *Produkthaftung* für Schäden durch fehlerhafte Produkte, *Datenschutz- und Cyber-Risiken* (Datenleck, Ransomware, Folgen und Bußgelder) und *Berufsrisiken* bei Beratung und Dienstleistung (Vermögensschäden durch Fehler).

> **Ergänzung aus der Nachrecherche**
>
> Die neue EU-Produkthaftungsrichtlinie (Richtlinie (EU) 2024/2853) zieht Software ausdrücklich in die Produkthaftung ein. Nach einer Übersicht der IHK Frankfurt am Main gilt Software unabhängig davon als Produkt, ob sie auf einem Gerät liegt, als App oder über die Cloud genutzt wird; auch KI-Systeme können erfasst sein. Das neue Recht soll für Produkte gelten, die ab dem 9. Dezember 2026 in Verkehr gebracht werden. Neue Beweiserleichterungen für Geschädigte, etwa Vermutungen bei Verstößen gegen verbindliche Sicherheitsanforderungen oder bei übermäßigen Beweisschwierigkeiten, sowie gerichtliche Anordnungen zur Offenlegung von Beweismitteln sind vorgesehen; Open-Source-Software außerhalb einer Geschäftstätigkeit ist ausgenommen. Datenschäden sind ersatzfähig, soweit die Daten nicht beruflich genutzt werden; Selbstbeteiligung und Haftungshöchstgrenze sollen entfallen. Die Seite beschreibt den Stand der deutschen Umsetzung; wie Österreich die Richtlinie umsetzt, wurde nicht abgerufen und ist zu prüfen (Quelle Q17; keine Rechtsberatung). Für Unternehmen, deren Produkt Personen- oder Sachschäden verursachen kann (zum Beispiel Software in Maschinen, Medizin oder Mobilität), ist das ein Anlass, Sicherheitsprozesse und Versicherungsschutz zu überprüfen.

*Versicherungen* übertragen einen Teil des Risikos auf einen Versicherer. Relevante Arten sind die *Betriebshaftpflicht* (Schäden an Dritten), die *Vermögensschaden-Haftpflicht* (reine Vermögensschäden, typisch für Beratung und Software), die *Cyber-Versicherung* (Kosten bei Datenpannen und Angriffen, oft inklusive Krisenhilfe) und weitere (Rechtsschutz, Sachversicherung, Managerhaftpflicht). Der Bedarf richtet sich nach dem Geschäftsmodell: Wer Großkundenverträge mit Haftungsklauseln abschließt, braucht meist Versicherungsnachweise. Wichtige Begriffe sind *Deckungssumme* (höchste Zahlung), *Selbstbehalt* (Anteil, den die Firma trägt), *Ausschlüsse* und *Obliegenheiten* (Pflichten wie Sicherheitsmaßnahmen, die erfüllt sein müssen).

```python
szenarien = [
    # (Szenario, Wahrscheinlichkeit pro Jahr, Schaden in EUR)
    ("Ransomware",                       0.04, 250_000),
    ("Datenleck mit Meldepflicht",       0.05, 120_000),
    ("Fehler im Produkt, Kundenschaden", 0.03,  90_000),
    ("Ausfall > 3 Tage",                 0.08,  60_000),
]
erwartet = sum(p * s for _, p, s in szenarien)
print(f"Erwarteter Jahresschaden: {erwartet:,.0f} EUR")
for name, p, s in szenarien:
    print(f"  {name:36s} {p * s:8,.0f} EUR  ({p * s / erwartet:5.1%})")

praemie, selbstbehalt, deckung = 4_800, 5_000, 200_000
worst = 250_000
zahlung = min(max(worst - selbstbehalt, 0), deckung)
print(f"Worst Case {worst:,}: Versicherung zahlt {zahlung:,}, Firma traegt {worst - zahlung:,} plus Praemie {praemie:,}")
```

Vier erfundene Szenarien haben eine jährliche Eintrittswahrscheinlichkeit und eine Schadenhöhe. Der erwartete Jahresschaden ist die Summe aus Wahrscheinlichkeit mal Schaden: 23 500 Euro, davon Ransomware 10 000 Euro (42,6 Prozent), Datenleck 6 000 Euro (25,5 Prozent), Ausfall 4 800 Euro (20,4 Prozent) und Produktfehler 2 700 Euro (11,5 Prozent). Der zweite Teil zeigt die Wirkung einer Versicherung für den schlimmsten Fall (250 000 Euro): Bei 5 000 Euro Selbstbehalt und 200 000 Euro Deckung zahlt der Versicherer 200 000 Euro, 50 000 Euro bleiben bei der Firma, zusätzlich zur Prämie von 4 800 Euro. Die Deckung deckt also nicht jeden Fall voll ab; deshalb prüft man die Höhe auch im Verhältnis zu Haftungsdeckeln der Verträge (Lerneinheit 11.3).

Typische Fehler: Versicherung ohne Prüfung der Ausschlüsse abschließen, vertragliche Haftung höher zusagen als die Deckung, Obliegenheiten missachten (zum Beispiel eine in der Police geforderte MFA), Schäden zu spät melden. Falsch: Die Police gilt als „Garantie“, obwohl Cyber-Vorfälle ohne Mindestmaßnahmen ausgeschlossen sind. Richtig: Policenbedingungen lesen, Sicherheitsmaßnahmen umsetzen (Modul 06) und Versicherung als Ergänzung zur Vorsorge sehen.

> **Merke**
>
> Haftung entsteht vertraglich, durch Produkte, durch Datenschutz- und Cyber-Vorfälle und bei Beratung. Software ist unter dem neuen Produkthaftungsrecht ausdrücklich ein Produkt. Versicherungen mindern, ersetzen aber nicht die Vorsorge; Deckung, Selbstbehalt und Ausschlüsse sind genau zu prüfen.

> **Praxisbeispiel**
>
> Bei Großkunden und Ausschreibungen gehört ein Versicherungsnachweis oft zu den Mindestanforderungen. Ein unabhängiger Versicherungsmakler kann Bedarf und Angebote vergleichen; der Bedarf wird jährlich überprüft.

## 11.7 Policy Set

*Policies* sind schriftliche, verbindliche Regeln, die festlegen, wie das Unternehmen mit einem Thema umgeht. Sie dienen dreifach: als Orientierung für Mitarbeitende, als Grundlage für Sicherheit und Compliance und als Nachweis gegenüber Kunden, Prüfern und Investoren. Ein sinnvolles Grundset für ein Technikunternehmen besteht aus der *Informationssicherheitsrichtlinie* (Schutzziele, Verantwortung, Grundregeln), der *Datenschutzrichtlinie* (Umgang mit personenbezogenen Daten, Betroffenenanfragen, Löschung), der *Acceptable-Use-Policy* (erlaubte Nutzung von Geräten, Konten, Software) und der *Incident-Response-Policy* (Meldewege, Rollen und Fristen bei Vorfällen, Modul 06). Später kommen Policies zu Zugriffsrechten, Lieferanten, Remote Work, Passwörtern und Backups hinzu.

Damit Policies wirken, müssen sie *nutzbar* sein: kurz, verständlich, an die tatsächliche Arbeit angepasst und mit klarem Eigentümer (Owner), Version und Prüfrhythmus versehen. Im Betrieb und im Vertrieb werden sie genutzt, indem Mitarbeitende sie bestätigen (Acknowledgement), sie im Onboarding vorkommen und Vertriebsteams sie Kunden zur Verfügung stellen können.

```python
from datetime import date
heute = date(2026, 11, 2)
policies = [
    {"name": "Informationssicherheit", "owner": "CTO", "version": "1.2", "geprueft": date(2026, 2, 1),  "intervall_monate": 12},
    {"name": "Datenschutz",            "owner": "DSB", "version": "2.0", "geprueft": date(2025, 9, 15), "intervall_monate": 12},
    {"name": "Acceptable Use",         "owner": "COO", "version": "1.0", "geprueft": date(2026, 6, 1),  "intervall_monate": 12},
    {"name": "Incident Response",      "owner": "CTO", "version": "1.1", "geprueft": date(2025, 11, 1), "intervall_monate": 12},
]
def monate(a, b): return (b.year - a.year) * 12 + b.month - a.month
for p in policies:
    alter = monate(p["geprueft"], heute)
    print(f"{p['name']:24s} v{p['version']} Owner {p['owner']}  letzte Pruefung vor {alter:2d} Mon.", "-> ueberfaellig" if alter > p["intervall_monate"] else "")
mitarbeitende = 20
bestaetigt = {"Informationssicherheit": 20, "Datenschutz": 17, "Acceptable Use": 12, "Incident Response": 20}
for name, n in bestaetigt.items():
    print(f"{name:24s} bestaetigt {n}/{mitarbeitende} = {n / mitarbeitende:.0%}")
```

Das Programm führt ein Register von vier Policies mit Owner, Version, letzter Prüfung und Intervall. Die Funktion `monate` berechnet die vergangenen Monate; überschreitet das Alter das Intervall, wird „überfällig“ markiert. Die Datenschutz-Richtlinie wurde zuletzt vor 14 Monaten geprüft und ist überfällig. Die Incident-Response-Policy liegt mit genau 12 Monaten noch innerhalb des Intervalls. Der zweite Teil zeigt die Bestätigungsquote bei 20 Mitarbeitenden: Informationssicherheit und Incident Response sind vollständig bestätigt (100 Prozent), Datenschutz zu 85 Prozent, die Nutzungsrichtlinie zu nur 60 Prozent. Diese Lücke ist ein Handlungsauftrag, denn eine nicht bestätigte Policy ist im Zweifel nicht wirksam kommuniziert.

Typische Fehler: Policies aus dem Internet kopieren und nicht anpassen; zu viele, zu lange Dokumente, die niemand liest; keine Versionierung; Policies, die der Realität widersprechen. Falsch: Die Policy verlangt monatliche Rechteprüfungen, die niemand durchführt. Richtig: Nur zusagen, was gelebt wird, und lieber mit weniger Regeln beginnen. Ein Policy-Register mit Owner und Prüfdatum bildet die Brücke zur Compliance-Kontrollmatrix aus Modul 06.

> **Merke**
>
> Policies sind kurze, verbindliche Regeln mit Owner, Version und Prüfrhythmus. Ein Grundset aus Informationssicherheit, Datenschutz, Nutzung und Incident Response genügt zum Start. Bestätigung und Schulung machen sie wirksam.

> **Praxisbeispiel**
>
> Kundenfragebögen verlangen regelmäßig das Policy-Set. Wer die Richtlinien als gepflegte Dokumente mit Versionsstand bereithält, beantwortet sie in Stunden statt Wochen.

## 11.8 Risikoregister

Ein *Risikoregister* ist die zentrale Liste aller bekannten Risiken eines Unternehmens, mit Bewertung, Verantwortlichem und Maßnahme. Es führt Risikomanagement von der Ahnung zur Struktur. Die Risiken stammen aus mehreren Bereichen: *strategisch* (zum Beispiel Abhängigkeit von einem Großkunden, Marktveränderung), *operativ* (Ausfall von Schlüsselpersonen, Prozessfehler), *technisch* (Sicherheitslücken, fehlende Backups, Schulden im Code) und *rechtlich* (fehlende Rechte, Compliance-Lücken). Jedes Risiko wird nach *Eintrittswahrscheinlichkeit* und *Auswirkung* bewertet; ihr Produkt ergibt eine Kennzahl, mit der man priorisiert.

Zu jedem Risiko gehören ein *Owner* (eine Person, die sich kümmert) und eine *Maßnahme*. Die üblichen Strategien sind: vermeiden, verringern (Kontrollen), übertragen (Versicherung, Vertrag) oder bewusst akzeptieren (dokumentiert). Das Register wird regelmäßig überprüft, etwa vierteljährlich im Management-Termin.

```python
risiken = [
    # (Risiko, Kategorie, Wahrscheinlichkeit 1-5, Auswirkung 1-5, Owner, Massnahme)
    ("Abhaengigkeit von einem Grosskunden", "strategisch", 4, 5, "CEO", "Neukundenpipeline aufbauen"),
    ("Kein Restore-Test des Backups",       "technisch",   3, 5, "CTO", "Quartalsweise Restore-Test"),
    ("Fehlende IP-Abtretung Freelancer",    "rechtlich",   3, 4, "COO", "Vertraege nachholen"),
    ("Schluesselperson faellt aus",         "operativ",    2, 5, "CEO", ""),
    ("Tool-Preiserhoehung",                 "operativ",    4, 1, "COO", "Vertrag pruefen"),
]
def stufe(score):
    return "kritisch" if score >= 15 else "hoch" if score >= 10 else "mittel" if score >= 5 else "niedrig"
for name, kat, w, a, owner, massnahme in sorted(risiken, key=lambda r: -(r[2] * r[3])):
    score = w * a
    hinweis = "  <- Massnahme fehlt" if not massnahme and score >= 10 else ""
    print(f"{score:2d} {stufe(score):9s} {name:38s} [{kat}, {owner}]{hinweis}")
```

Jedes Risiko hat Wahrscheinlichkeit und Auswirkung auf einer Skala von 1 bis 5; die Kennzahl ist ihr Produkt (maximal 25). Die Stufen: ab 15 kritisch, ab 10 hoch, ab 5 mittel, darunter niedrig. Das Register sortiert absteigend. Ganz oben steht die Abhängigkeit von einem Großkunden (20, kritisch), gefolgt vom fehlenden Restore-Test des Backups (15, kritisch), der fehlenden IP-Abtretung für einen Freelancer (12, hoch) und dem Ausfall einer Schlüsselperson (10, hoch). Für diesen letzten Fall markiert das Programm, dass keine Maßnahme eingetragen ist. Die Preiserhöhung eines Tools hat nur die Kennzahl 4. Eine Maßnahme zu einem hoch bewerteten Risiko ist die Mindestanforderung, ohne sie ist das Register nur eine Liste.

Typische Fehler: Register einmalig ausfüllen und vergessen, Risiken ohne Verantwortlichen, zu viele Risiken (dann verliert man den Überblick), Bewertung nach Gefühl ohne Kriterien. Falsch: „Alles ist wichtig, wir bewerten gar nicht.“ Richtig: Skalen mit Beispielen festlegen (was bedeutet Auswirkung 5? Zum Beispiel Verlust von mehr als 20 Prozent des Jahresumsatzes) und die zehn größten Risiken aktiv steuern. Das Register verbindet sich mit den Risiken aus Lerneinheit 11.5 (Lieferanten), 11.6 (Haftung) und Modul 06 (Sicherheit).

> **Merke**
>
> Das Risikoregister erfasst Risiken nach Kategorie, bewertet sie nach Wahrscheinlichkeit und Auswirkung und weist Owner und Maßnahme zu. Es wird regelmäßig überprüft; hohe Risiken ohne Maßnahme sind ein Befund.

> **Praxisbeispiel**
>
> Ein gepflegtes Risikoregister ist für Investoren, Aufsichtsgremien und Versicherer ein Zeichen von Reife und liefert nebenbei die Tagesordnung für die Quartalsrunde.

## 11.9 Board und Governance

*Governance* bezeichnet die Regeln, nach denen ein Unternehmen geführt und kontrolliert wird: Wer entscheidet was, wer berichtet an wen, wer darf kontrollieren? Bei einer GmbH sind die Organe im Kern die *Gesellschafterversammlung*, die *Geschäftsführung* und, wo vorgesehen oder vorgeschrieben, ein *Aufsichtsrat* oder ein freiwilliger *Beirat* (Board). Mit Investoren kommen Zustimmungsvorbehalte und Informationsrechte dazu. Welche Beschlüsse mit welcher Mehrheit gefasst werden, ergibt sich aus Gesetz und Gesellschaftsvertrag (Modul 02); der Vertrag kann in vielen Punkten abweichen, daher sind die folgenden Schwellenwerte reine Beispiele.

Wichtig sind drei Dinge. Die *Beschlusswege*: Wer muss eingeladen werden, wie viele müssen anwesend sein (Quorum), welche Mehrheit ist nötig, und wie wird dokumentiert? Das *Reporting*: Die Geschäftsführung berichtet regelmäßig an das Board mit Kennzahlen und Entscheidungsvorlagen (Modul 07, 10). Die *Kontrollrechte*: Informations- und Einsichtsrechte der Gesellschafter, Zustimmungsvorbehalte für bestimmte Geschäfte (zum Beispiel Aufnahme von Schulden, Verkauf wesentlicher Vermögenswerte, Budgetabweichungen).

```python
def beschluss(stimmen_ja, stimmen_gesamt, schwelle, quorum_anwesend, anwesend):
    if anwesend < quorum_anwesend:
        return "nicht beschlussfaehig"
    return "angenommen" if stimmen_ja / stimmen_gesamt >= schwelle else "abgelehnt"

anteile = {"A": 40, "B": 40, "Investor": 20}
beschluesse = [
    ("Jahresabschluss",           ["A", "B"],        0.50),
    ("Neue Finanzierungsrunde",   ["A", "Investor"], 0.75),
    ("Aenderung Gesellschaftsvertrag", ["A", "B", "Investor"], 0.75),
]
for titel, ja, schwelle in beschluesse:
    n = sum(anteile[x] for x in ja)
    print(f"{titel:32s} Ja {n}% (Schwelle {schwelle:.0%}) -> {beschluss(n, 100, schwelle, 50, 100)}")
print("Nur 40 % anwesend:", beschluss(40, 40, 0.5, 50, 40))
```

Die Funktion `beschluss` prüft zuerst das Quorum (Mindestanwesenheit) und dann, ob der Anteil der Ja-Stimmen die Schwelle erreicht. Im Beispiel halten zwei Gründer je 40 Prozent und ein Investor 20 Prozent. Der Jahresabschluss wird mit 80 Prozent Ja-Stimmen bei einer Schwelle von 50 Prozent angenommen. Eine neue Finanzierungsrunde, für die im Beispiel 75 Prozent verlangt werden, scheitert mit 60 Prozent (Gründer A und Investor). Die Änderung des Gesellschaftsvertrags wird mit 100 Prozent angenommen. Bei nur 40 Prozent anwesenden Stimmen ist das Gremium nicht beschlussfähig. Das Beispiel zeigt, wie die Verteilung der Anteile und die Schwellen zusammen über Handlungsspielraum entscheiden; wenn ein Gesellschafter ein Veto hat, kann auch ein kleiner Anteil entscheidend sein.

Typische Fehler: Beschlüsse mündlich oder per Chat ohne Protokoll, Einladungen ohne Frist, Zustimmungsvorbehalte, die so weit gefasst sind, dass die Geschäftsführung kaum handlungsfähig ist, und Governance, die erst bei der ersten Krise geschaffen wird. Falsch: Alle laufenden Entscheidungen müssen vom Board freigegeben werden. Richtig: Das Board entscheidet über wenige, wichtige Dinge und lässt der Geschäftsführung Spielraum im Rahmen von Budget und Strategie. Mit wachsendem Unternehmen wird Governance schrittweise professionalisiert: formelle Protokolle, Ausschüsse (zum Beispiel Audit), unabhängige Mitglieder (Modul 12).

> **Merke**
>
> Governance regelt Beschlusswege, Reporting und Kontrollrechte. Quorum und Mehrheiten ergeben sich aus Gesetz und Gesellschaftsvertrag. Beschlüsse werden protokolliert; das Board entscheidet über wenige wichtige Dinge und lässt der Geschäftsführung Handlungsspielraum.

> **Praxisbeispiel**
>
> Ein jährlicher Kalender mit Terminen für Gesellschafterversammlung, Quartals-Board und Jahresabschluss, plus eine Vorlage für Protokolle und Beschlussfassung im Umlaufverfahren, entlastet das Management und ist bei Prüfungen ein Pluspunkt.

## Übungsaufgaben zu Modul 11

1.  **(leicht)** Erkläre den Unterschied zwischen einer permissiven und einer Copyleft-Lizenz und nenne je ein Beispiel.

2.  **(leicht)** Was ist ein Subprozessor, und wann muss ein Auftragsverarbeiter seine Kunden darüber informieren?

3.  **(leicht)** Ein Risiko hat Wahrscheinlichkeit 3 und Auswirkung 4. Welche Kennzahl und welche Stufe ergibt sich nach dem Schema aus 11.8?

4.  **(mittel)** Ein Kunde zahlt 3 000 Euro im Monat. Die SLA-Staffel lautet: ab 99,9 Prozent keine Gutschrift, ab 99,0 Prozent 10 Prozent, ab 95,0 Prozent 25 Prozent, darunter 50 Prozent. Wie hoch ist die Gutschrift bei 99,0 und bei 94,5 Prozent Verfügbarkeit?

5.  **(mittel)** Der Haftungsdeckel beträgt zwölf Monatsentgelte à 1 500 Euro; der Schaden beträgt 50 000 Euro. Wie viel ersetzt das Unternehmen?

6.  **(praktisch)** Schreibe ein Programm, das für eine Komponentenliste die Lizenzrichtlinie prüft und Komponenten ohne Lizenz ausdrücklich ablehnt.

7.  **(praktisch)** Schreibe eine Funktion, die anhand von letztem Prüfdatum, Intervall in Monaten und heutigem Datum entscheidet, ob eine Policy überfällig ist, und teste sie.

8.  **(schwer/praktisch)** Berechne mit den Szenarien aus 11.6 die erwarteten Jahreskosten ohne und mit Versicherung (Prämie 4 800 Euro, Selbstbehalt 5 000 Euro, Deckung 200 000 Euro).

## Lösungen zu den Übungsaufgaben Modul 11

**1.** Permissive Lizenzen (zum Beispiel MIT, Apache 2.0) erlauben auch die Nutzung in geschlossener, kommerzieller Software und verlangen meist nur Namensnennung und Lizenztext. Copyleft-Lizenzen (zum Beispiel GPL) verlangen, dass abgeleitete Werke unter derselben Lizenz offengelegt werden; die AGPL erfasst zusätzlich Software, die nur über ein Netzwerk angeboten wird.

**2.** Ein Subprozessor ist ein Dienstleister, den ein Auftragsverarbeiter für die Verarbeitung der Daten des Kunden einsetzt (zum Beispiel Cloud-Hosting). Der Auftragsverarbeiter benötigt die Genehmigung des Verantwortlichen und informiert über Änderungen, meist mit einer Frist, in der der Kunde widersprechen kann; die genaue Regelung steht in der AVV.

**3.** 3 mal 4 = 12; das entspricht der Stufe „hoch“ (ab 10 hoch, ab 15 kritisch).

**4.** Bei 99,0 Prozent gilt die Zeile „ab 99,0“: 10 Prozent von 3 000 Euro = 300 Euro. Bei 94,5 Prozent greift die letzte Zeile: 50 Prozent von 3 000 Euro = 1 500 Euro.

**5.** Der Deckel beträgt 12 mal 1 500 Euro = 18 000 Euro. Das Unternehmen ersetzt höchstens 18 000 Euro; die übrigen 32 000 Euro bleiben beim Kunden, vorausgesetzt die Klausel ist wirksam.

**6.** Mögliche Lösung:

```python
POLICY = {"MIT": "erlaubt", "Apache-2.0": "erlaubt", "GPL-3.0": "verboten"}
komponenten = [("lib-a", "MIT"), ("lib-b", "GPL-3.0"), ("lib-c", None)]
for name, lizenz in komponenten:
    if lizenz is None:
        print(name, "-> Lizenz unbekannt, nicht freigeben")
    else:
        print(name, "->", POLICY.get(lizenz, "pruefen"))
```

Der Fall `None` wird vor dem Nachschlagen abgefangen. Unbekannte Lizenzen liefern über `get` den Standardwert „prüfen“.

**7.** Mögliche Lösung:

```python
from datetime import date
def ueberfaellig(letzte, intervall_monate, heute):
    vergangen = (heute.year - letzte.year) * 12 + heute.month - letzte.month
    return vergangen > intervall_monate
heute = date(2026, 11, 2)
print(ueberfaellig(date(2025, 9, 1), 12, heute), ueberfaellig(date(2025, 11, 1), 12, heute), ueberfaellig(date(2026, 5, 1), 6, heute))
```

Die Funktion vergleicht die vergangenen Monate mit dem Intervall. Das Beispiel von September 2025 ist mit 14 Monaten überfällig, November 2025 liegt mit genau 12 Monaten noch im Rahmen, und Mai 2026 bei Intervall 6 ebenfalls.

**8.** Mögliche Lösung:

```python
szenarien = [("Ransomware", 0.04, 250_000), ("Datenleck", 0.05, 120_000), ("Produktfehler", 0.03, 90_000), ("Ausfall", 0.08, 60_000)]
praemie, selbstbehalt, deckung = 4_800, 5_000, 200_000
ohne = sum(p * s for _, p, s in szenarien)
mit = praemie
for _, p, s in szenarien:
    gezahlt = min(max(s - selbstbehalt, 0), deckung)
    mit += p * (s - gezahlt)
print(f"Ohne Versicherung: {ohne:,.0f}   Mit Versicherung (inkl. Praemie): {mit:,.0f}")
```

Ohne Versicherung betragen die erwarteten Jahreskosten 23 500 Euro, mit Versicherung 7 600 Euro (4 800 Euro Prämie plus erwartete Eigenanteile von 2 800 Euro). Der Vergleich ist stark vereinfacht: Er geht davon aus, dass alle Schäden gedeckt sind und die Wahrscheinlichkeiten stimmen, und beachtet keine Ausschlüsse; im Zweifel bestimmt die Policenbedingung.
