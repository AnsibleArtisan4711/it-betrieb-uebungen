# Modul 05 - Software Engineering, DevOps und Plattformbetrieb

> **Hinweis zu diesem Kapitel:** Das ist das Kapitel des Skripts „Unternehmensgründung“, aus der LaTeX-Quelle in Markdown umgewandelt (Text und Codeblöcke unverändert, farbige Boxen als Zitatblöcke mit fettem Titel, Tabellen als Markdown-Tabellen). Die Lerneinheiten sind wie in der Quelle nach Modul nummeriert (5.1 bis 5.9), danach folgen „Übungsaufgaben zu Modul 05“ (8 Aufgaben, mit Schwierigkeitsangabe) und „Lösungen zu den Übungsaufgaben Modul 05“. Rechtliche und steuerliche Aussagen sind keine Rechtsberatung. Was ich an den Beispielen geprüft habe, steht in der [README des Repositories](../README.md). Übersicht zum Modul: [README](README.md).

**Dauer:** 10 h laut Modulübersicht (Summe der Einzelwerte: 9 × 1,1 h = 9,9 h, gerundet)

**Priorität:** 1 (höchste)

| **Nr.** | **Lerneinheit**             | **Dauer (h)** |
|--------:|:----------------------------|--------------:|
|     5.1 | Engineering Operating Model |           1,1 |
|     5.2 | Codequalität und Reviews    |           1,1 |
|     5.3 | CI/CD Pipeline              |           1,1 |
|     5.4 | Teststrategie               |           1,1 |
|     5.5 | Cloud-Betrieb               |           1,1 |
|     5.6 | Monitoring und Logging      |           1,1 |
|     5.7 | Incident Response           |           1,1 |
|     5.8 | SLA und Verfügbarkeit       |           1,1 |
|     5.9 | Betriebsdokumentation       |           1,1 |
|         | **Summe**                   |       **9,9** |

Modul 04 hat geklärt, *was* gebaut wird. Dieses Modul beschreibt, wie Software zuverlässig entsteht und im Betrieb bleibt. *DevOps* ist die Arbeitsweise, bei der Entwicklung (Dev) und Betrieb (Ops) nicht getrennte Abteilungen sind, sondern gemeinsam für ein Produkt verantwortlich sind: Wer eine Funktion baut, trägt mit, dass sie läuft. Die Lerneinheiten folgen dem Weg einer Änderung vom Entwicklungsprozess über Prüfung, Auslieferung und Betrieb bis zur Störung und ihrer Aufarbeitung. Alle Programme sind lauffähig mit Python 3 ohne Zusatzpakete, die Zahlen sind Beispielwerte. Sicherheit und Datenschutz vertieft Modul 06, die vertragliche Seite von SLAs Modul 11.

## 5.1 Engineering Operating Model

Das *Engineering Operating Model* beschreibt, wie ein Technikteam arbeitet: Wer entscheidet was, in welchem Takt wird geliefert, woran erkennt man, dass etwas fertig ist, und wie hängen Produkt- und Technikentscheidungen zusammen? Ohne ausdrückliche Absprachen entsteht ein Modell trotzdem, nur zufällig und von Person zu Person verschieden. Mit zwei bis fünf Entwickelnden kommt man lange mit wenig Regeln aus; spätestens ab etwa acht Personen kosten ungeklärte Zuständigkeiten spürbar Zeit.

Die wichtigsten Bausteine sind *Rollen* (zum Beispiel Product Owner, der priorisiert, was wichtig ist; Tech Lead, der technische Entscheidungen verantwortet; Engineers, die liefern), ein *Sprint-Takt* (ein fester Zeitraum von meist zwei Wochen, an dessen Ende ein nutzbarer Stand steht) und die *Definition of Done* (DoD, siehe Modul 04). Dazu kommen wiederkehrende Treffen: Planung (was nehmen wir uns vor?), kurzes tägliches Abstimmen (Daily), Review (zeigen, was fertig ist) und Retrospektive (wie arbeiten wir besser?). Entscheidend ist, dass Produkt- und Technikentscheidungen *verbunden* werden: Technische Schulden (Modul 04, Lerneinheit 4.8) konkurrieren im selben Backlog mit neuen Funktionen und werden gemeinsam priorisiert, nicht in einer Schattenliste.

Zur Planung dient die *Velocity*, die Menge an Arbeit (gemessen in Story Points, einer relativen Größeneinheit), die ein Team pro Sprint erfahrungsgemäß abschließt. Sie ist kein Leistungsmaß für Personen, sondern ein Planungswerkzeug. Man sollte sie als Bereich angeben (pessimistisch, typisch, optimistisch) statt als einzelne Zahl. Das Programm berechnet aus fünf vergangenen Sprints eine Prognose für ein Backlog von 130 Punkten und prüft eine Story gegen die Definition of Done.

```python
from math import ceil
from statistics import mean

velocity = [21, 18, 24, 20, 22]      # abgeschlossene Punkte je Sprint
backlog = 130
typisch = mean(velocity[-3:])        # Mittel der letzten drei Sprints
for name, v in (("pessimistisch", min(velocity)), ("typisch", typisch),
                ("optimistisch", max(velocity))):
    print(f"{name:14s} v={v:5.1f} -> {ceil(backlog / v)} Sprints")

dod = ["code_review", "tests_gruen", "doku_aktualisiert", "in_staging_geprueft"]
story = {"titel": "PDF-Export", "code_review": True, "tests_gruen": True,
         "doku_aktualisiert": False, "in_staging_geprueft": True}
offen = [p for p in dod if not story.get(p)]
print("Story fertig" if not offen else f"Story NICHT fertig, offen: {offen}")
```

Die Prognose rechnet drei Szenarien: Bei der niedrigsten bisherigen Velocity (18) braucht das Team 8 Sprints, bei der typischen (22) 6 Sprints, bei der höchsten (24) ebenfalls 6 Sprints. `ceil` rundet auf ganze Sprints auf, denn ein angefangener Sprint ist ein ganzer Sprint. Die Definition of Done wird als Liste von Kriterien geführt; die Listenbildung `offen` sammelt alle, die nicht erfüllt sind. Die Story gilt wegen der fehlenden Dokumentation als nicht fertig. Dass man das maschinell prüfen kann, ist der Grund, warum viele Teams ihre DoD als Checkliste in der Pull-Request-Vorlage führen.

Typische Fehler: Velocity als Vergleichszahl zwischen Teams oder als Zielvorgabe nutzen (dann werden Punkte aufgebläht), die DoD für „später“ aufheben und ein Sprint-Ritual abhalten, ohne dass sich etwas ändert. Falsch: „Die Story ist fertig, die Tests schreiben wir im nächsten Sprint.“ Richtig: Die Story bleibt offen, bis die DoD erfüllt ist, oder sie wird kleiner geschnitten. Zu viel Prozess ist ebenso ein Fehler: Ein Zwei-Personen-Team braucht keine fünf Rollen und wöchentlich drei Stunden Meetings.

> **Merke**
>
> Ein Operating Model legt Rollen, Takt, Definition of Done und Entscheidungswege fest. Produkt- und Technikarbeit stehen in einem gemeinsamen Backlog. Velocity ist ein Planungsbereich, kein Leistungsmaß.

> **Praxisbeispiel**
>
> Investoren und Kunden fragen in Prüfungen, wie Releases entstehen und wer freigibt. Ein dokumentiertes Modell (eine Seite) mit Rollen, Takt und DoD beantwortet das und beschleunigt auch das Onboarding neuer Entwickelnder.

## 5.2 Codequalität und Reviews

*Codequalität* ist kein Schönheitsideal, sondern ein Kostenfaktor: Unverständlicher Code wird langsamer geändert, enthält mehr Fehler und hängt an einzelnen Personen. Gemeint sind Lesbarkeit, einheitliche Struktur, geringe Komplexität und Prüfbarkeit. Drei Praktiken sichern sie im Alltag. Erstens *Coding Standards*: Absprachen zu Namensgebung, Formatierung und Struktur, die von Werkzeugen (Formatierer, Linter) automatisch durchgesetzt werden, damit in Reviews nicht über Leerzeichen diskutiert wird. Zweitens *Code Reviews*: Eine zweite Person liest jede Änderung, bevor sie übernommen wird. Drittens *Pull Requests* (PR): Eine Änderung wird als Vorschlag mit Beschreibung eingereicht, durch Reviewer kommentiert und nach Freigabe in den Hauptzweig übernommen.

Reviews haben drei Ziele: Fehler früh finden, Wissen im Team verteilen (gegen *Wissenssilos*, in denen nur eine Person ein Modul versteht) und Standards sichern. Gute Reviews sind klein (unter etwa 400 geänderten Zeilen), zeitnah (innerhalb eines Arbeitstages) und höflich: Kommentare beziehen sich auf den Code, nicht auf die Person. Ein *Security Review* schaut zusätzlich auf Eingabeprüfung, Zugriffskontrolle, Umgang mit Geheimnissen und Abhängigkeiten (Modul 06).

Werkzeuge können einfache Regeln selbst prüfen. Das folgende Programm analysiert mit dem Python-Modul `ast` (Abstract Syntax Tree, die Baumdarstellung von Quelltext) einen Codeausschnitt und meldet drei typische Mängel: Funktionen ohne Dokumentation, zu lange Funktionen und ein „nacktes“ `except`, das alle Fehler stillschweigend verschluckt.

```python
import ast

quelle = '''
def berechne(a, b):
    try:
        x = a / b
    except:
        pass
    return x

def lang():
''' + "    y = 1\n" * 45 + "    return y\n"

baum = ast.parse(quelle)
for knoten in ast.walk(baum):
    if isinstance(knoten, ast.FunctionDef):
        laenge = knoten.end_lineno - knoten.lineno + 1
        if ast.get_docstring(knoten) is None:
            print(f"Zeile {knoten.lineno}: {knoten.name}() ohne Docstring")
        if laenge > 40:
            print(f"Zeile {knoten.lineno}: {knoten.name}() zu lang ({laenge} Zeilen)")
    if isinstance(knoten, ast.ExceptHandler) and knoten.type is None:
        print(f"Zeile {knoten.lineno}: nacktes except verschluckt alle Fehler")
```

`ast.parse` zerlegt den Text in einen Baum, `ast.walk` läuft über alle Knoten. Bei Funktionsdefinitionen berechnet das Programm die Länge aus Anfangs- und Endzeile und prüft, ob ein Docstring vorhanden ist. Bei einem `except`-Block ohne Typangabe (`knoten.type is None`) schlägt es Alarm. Die Ausgabe nennt für `berechne` den fehlenden Docstring und das nackte `except`, für `lang` den fehlenden Docstring und die Länge von 47 Zeilen. Genau solche Prüfungen übernehmen in der Praxis Linter; wichtig ist die Einsicht, dass Regeln, die sich maschinell prüfen lassen, nicht im Review verhandelt werden sollten.

Typische Fehler: Reviews als Formalität („LGTM“ ohne Lesen), riesige Pull Requests, die niemand mehr prüfen kann, und Fehler, die das `except` verschluckt. Falsch: `except: pass`, das den Division-durch-Null-Fehler verbirgt und später `x` undefiniert zurücklässt. Richtig: konkrete Fehlerarten abfangen, protokollieren und sinnvoll reagieren. Ein weiterer Fehler ist Kritik ohne Alternative; ein guter Kommentar nennt das Problem, begründet es und schlägt eine Lösung vor.

> **Merke**
>
> Standards werden automatisiert, Reviews sind für Verständnis und Risiko da. Kleine, zeitnahe Pull Requests mit Beschreibung verteilen Wissen und finden Fehler früh. Kritik gilt dem Code, nicht der Person.

> **Praxisbeispiel**
>
> Der Hauptzweig wird geschützt: Änderungen gehen nur über einen Pull Request mit mindestens einer Freigabe und grüner Pipeline (Lerneinheit 5.3). Das erzeugt zugleich einen Nachweis für Audits (Modul 06) und für Kunden.

## 5.3 CI/CD Pipeline

*CI* (Continuous Integration) bedeutet, dass jede Änderung mehrmals täglich in den gemeinsamen Code integriert und automatisch gebaut und getestet wird. *CD* steht für *Continuous Delivery* (jede geprüfte Änderung ist jederzeit auslieferbar) oder *Continuous Deployment* (jede geprüfte Änderung wird automatisch ausgeliefert). Die *Pipeline* ist die automatisierte Kette von Schritten, die das umsetzt. Typische Stufen sind: Quellcode holen, Abhängigkeiten installieren, formale Prüfung (Linter), Tests, Sicherheitsprüfungen (Abhängigkeits- und Geheimnis-Scan, siehe Modul 06), Bauen eines Artefakts (zum Beispiel eines Container-Images), Auslieferung in eine Testumgebung und schließlich in die Produktion.

Der Nutzen ist doppelt: Fehler werden in Minuten statt in Wochen entdeckt, und Auslieferungen werden langweilig, weil sie ständig geübt werden. Zwei Mechanismen machen das sicher. Mit einem *Rollback* kehrt man schnell auf den letzten funktionierenden Stand zurück, wenn die neue Version Probleme macht. *Release-Freigaben* sind definierte Bedingungen oder Personen, die eine Auslieferung erlauben; bei regulierten Produkten wird eine manuelle Freigabe vor Produktion verlangt. Zusätzlich gibt es Strategien wie *Blue-Green* (zwei parallele Umgebungen, Umschalten per Schalter) oder *Canary* (neue Version zunächst für wenige Nutzer).

Das erste Beispiel zeigt, wie eine solche Pipeline als Konfiguration aussieht. Es verwendet das bei GitHub übliche YAML-Format; es ist ein Muster zum Lesen, kein Teil der Python-Programme.

```yaml
name: ci
on:
  pull_request:
  push:
    branches: [main]
jobs:
  pruefen:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
        with: { python-version: "3.12" }
      - run: pip install -r requirements.txt
      - run: python -m unittest discover
  deploy:
    needs: pruefen
    if: github.ref == 'refs/heads/main'
    runs-on: ubuntu-latest
    steps:
      - run: echo "Hier wuerde die Auslieferung stattfinden"
```

Die Konfiguration sagt: Bei jedem Pull Request und bei jedem Push auf den Hauptzweig läuft der Job `pruefen`; er holt den Code, richtet Python ein, installiert Abhängigkeiten und führt die Tests aus. Der Job `deploy` hängt über `needs` vom ersten ab und läuft nur auf dem Hauptzweig. Schlägt ein Schritt fehl, bricht die Pipeline ab, und die Auslieferung findet nicht statt. Die genauen Versionsangaben ändern sich ständig und sind vor der Verwendung zu prüfen.

Das zweite Beispiel baut das Prinzip in Python nach: ein Mini-Läufer mit Stufen, der beim ersten Fehler abbricht und im Fall eines fehlgeschlagenen Deployments einen Rollback auslöst.

```python
def lauf(stufen, rollback):
    for name, aktion in stufen:
        ok = aktion()
        print(f"{name:14s} {'OK' if ok else 'FEHLER'}")
        if not ok:
            if name == "deploy":
                rollback()
            print("Pipeline abgebrochen")
            return False
    print("Pipeline erfolgreich")
    return True

stufen_a = [("lint", lambda: True), ("tests", lambda: True),
            ("security-scan", lambda: False), ("deploy", lambda: True)]
stufen_b = [("lint", lambda: True), ("tests", lambda: True),
            ("security-scan", lambda: True), ("deploy", lambda: False)]
rb = lambda: print("   -> Rollback auf letzte Version")
lauf(stufen_a, rb)
print()
lauf(stufen_b, rb)
```

Jede Stufe besteht aus einem Namen und einer Funktion, die wahr oder falsch zurückgibt. Im ersten Durchlauf schlägt der Sicherheits-Scan fehl; die Pipeline bricht ab, und das Deployment findet gar nicht statt. Im zweiten Durchlauf gelingen alle Prüfungen, aber das Deployment selbst scheitert; deshalb wird der Rollback ausgeführt. Dass die Stufen in einer festen Reihenfolge laufen und ein Fehler den Rest blockiert, ist die zentrale Eigenschaft: Fehler bleiben so billig, weil sie früh auffallen.

Typische Fehler: Langsame Pipelines (nach 30 Minuten wartet niemand mehr), instabile Tests („flaky tests“), die zufällig fehlschlagen und ignoriert werden, Geheimnisse im Code und eine Produktionsfreigabe ohne Rollback-Plan. Falsch: „Wir deployen freitagabends manuell vom Laptop.“ Richtig: ein dokumentierter, automatisierter Ablauf mit Rollback und möglichst kleinen, häufigen Änderungen, die leichter zu verstehen und zurückzunehmen sind.

> **Merke**
>
> CI baut und testet jede Änderung automatisch, CD liefert sie sicher aus. Eine Pipeline hat feste Stufen und bricht bei Fehlern ab. Rollback und Release-Regeln gehören vorab geplant.

> **Praxisbeispiel**
>
> Pipelines sind zugleich Nachweis für Qualität und Sicherheit gegenüber Kunden und Auditoren. Die Dauer von Änderung bis Produktion (*Lead Time*) und die Häufigkeit der Auslieferungen gelten als Kennzahlen für die Leistungsfähigkeit eines Teams.

## 5.4 Teststrategie

Eine *Teststrategie* legt fest, was auf welcher Ebene geprüft wird, damit man mit vertretbarem Aufwand Vertrauen in die Software bekommt. Üblich ist das Bild der *Testpyramide*. Die Basis bilden viele schnelle *Unit-Tests*, die einzelne Funktionen isoliert prüfen. In der Mitte stehen weniger *Integrationstests*, die das Zusammenspiel mehrerer Bausteine (zum Beispiel Anwendung und Datenbank) prüfen. An der Spitze stehen wenige *End-to-End-Tests* (E2E), die einen kompletten Nutzerpfad durch die echte Oberfläche durchspielen. Dazu kommen *Akzeptanztests*, die die Kriterien aus Modul 04 bestätigen. Je höher die Ebene, desto langsamer, teurer und anfälliger der Test; deshalb liegt die Masse unten.

Wichtiger als die Zahl der Tests ist ihre Auswahl. *Kritische Kundenpfade* (Anmeldung, Bezahlen, Daten exportieren) werden besonders sorgfältig abgesichert, weil Fehler dort Umsatz und Vertrauen kosten. Außerdem prüft man *Grenzwerte*, denn Fehler häufen sich dort, wo Regeln wechseln: bei 0, genau an einer Schwelle und knapp darüber. Eine hohe Testabdeckung (der Anteil des Codes, den Tests ausführen) ist kein Beweis für Qualität; sie zeigt nur, was nie ausgeführt wird.

Das Beispiel prüft eine Versandkostenfunktion mit Grenzwerttests. Die Regeln lauten: bis 2 kg 4,90 EUR, bis 10 kg 7,90 EUR, darüber 14,90 EUR, Express verdoppelt, Gewicht null oder negativ ist ungültig.

```python
import unittest

def versandkosten(gewicht_kg, express=False):
    if gewicht_kg <= 0:
        raise ValueError("Gewicht muss positiv sein")
    basis = 4.90 if gewicht_kg <= 2 else 7.90 if gewicht_kg <= 10 else 14.90
    return round(basis * (2 if express else 1), 2)

class Grenzwerte(unittest.TestCase):
    def test_stufen(self):
        faelle = [(0.1, 4.90), (2, 4.90), (2.01, 7.90), (10, 7.90), (10.01, 14.90)]
        for gewicht, erwartet in faelle:
            with self.subTest(gewicht=gewicht):
                self.assertEqual(versandkosten(gewicht), erwartet)

    def test_express(self):
        self.assertEqual(versandkosten(2, express=True), 9.80)

    def test_ungueltig(self):
        for g in (0, -1):
            with self.assertRaises(ValueError):
                versandkosten(g)

unittest.main(argv=["x"], exit=False, verbosity=2)
```

Die Funktion verschachtelt zwei Bedingungsausdrücke zu einer Stufenlogik. In der Testklasse prüft `test_stufen` fünf Fälle, darunter genau die Grenzen 2 und 10 und die Werte knapp darüber; `subTest` sorgt dafür, dass bei einem Fehler genau der betroffene Fall im Bericht steht. Der Express-Test prüft die Verdoppelung, der letzte Test die Ablehnung ungültiger Werte. Alle drei Methoden laufen durch. Hätte jemand versehentlich `< 2` statt `<= 2` geschrieben, schlüge genau der Grenzwertfall bei 2 kg an, den man im Alltag leicht übersieht.

Typische Fehler: Nur die schönen Fälle testen, Tests mit externen Diensten ohne Ersatzobjekte (Mocks) bauen, die dadurch langsam und unzuverlässig werden, und eine pyramidenförmige Verteilung auf den Kopf stellen („Eiscreme-Kegel“ mit vielen E2E-Tests). Falsch: Hundert E2E-Tests, die eine Stunde laufen und halb zufällig fehlschlagen. Richtig: viele Unit-Tests, gezielte Integrationstests und wenige stabile E2E-Tests für die kritischen Pfade. Bei Fehlern im Betrieb gilt die Regel: Zuerst einen Test schreiben, der den Fehler reproduziert, dann beheben.

> **Merke**
>
> Viele schnelle Unit-Tests, gezielte Integrationstests, wenige E2E-Tests. Kritische Kundenpfade und Grenzwerte werden zuerst abgesichert. Jeder behobene Fehler bekommt einen Test, der ihn künftig verhindert.

> **Praxisbeispiel**
>
> Die Tests laufen in der Pipeline (Lerneinheit 5.3) bei jeder Änderung. Bei Verträgen mit SLA (Lerneinheit 5.8) und bei Sicherheitsprüfungen für Kunden dient der Nachweis automatischer Tests als Beleg für Sorgfalt.

## 5.5 Cloud-Betrieb

Der *Betrieb* einer Software umfasst alles, was nach der Auslieferung nötig ist, damit sie zuverlässig läuft: Umgebungen, Konfiguration, Geheimnisse, Skalierung, Kosten. Man trennt *Umgebungen* (englisch *environments*): Entwicklung (lokal), Test oder Staging (eine möglichst produktionsähnliche Umgebung für die Abnahme) und Produktion. Wichtig ist, dass der Code in allen Umgebungen derselbe ist und nur die *Konfiguration* abweicht. Konfiguration (Adressen, Schalter) und *Geheimnisse* (Passwörter, Schlüssel, Zugangstoken) liegen deshalb nicht im Code, sondern kommen von außen, zum Beispiel aus Umgebungsvariablen oder einem Geheimnis-Dienst (englisch *secrets manager*). So lassen sie sich ändern, ohne neu zu bauen, und landen nicht versehentlich im Versionsverwaltungssystem.

*Skalierung* heißt, dass das System mit steigender Last mitwächst: *vertikal* (größere Maschine) oder *horizontal* (mehr Instanzen hinter einem Lastverteiler). Horizontale Skalierung setzt voraus, dass Instanzen keinen lokalen Zustand halten. Außerdem gehören *Backups* und regelmäßige Wiederherstellungstests zum Betrieb (siehe Modul 12, Resilienz). Und: Betriebskosten werden von Anfang an sichtbar gemacht, denn Cloud-Rechnungen wachsen leise, und Kostenverteilung auf Kunden und Produkte ist später schwer nachzuziehen. Hilfreich ist, alle Ressourcen mit Etiketten (*Tags*) wie Umgebung und Verantwortlichem zu versehen.

```python
def lade_konfig(env):
    pflicht = ["DB_URL", "SECRET_KEY"]
    fehlt = [k for k in pflicht if not env.get(k)]
    if fehlt:
        raise RuntimeError(f"Konfiguration unvollstaendig: {fehlt}")
    return {"db": env["DB_URL"], "debug": env.get("DEBUG", "0") == "1"}

print(lade_konfig({"DB_URL": "postgres://db/prod", "SECRET_KEY": "***"}))
try:
    lade_konfig({"DB_URL": "postgres://db/prod"})
except RuntimeError as e:
    print("Start abgebrochen:", e)

# Kostenabschaetzung pro Monat (730 Stunden)
ressourcen = [
    ("App-Instanzen", 3, 0.05 * 730),
    ("Datenbank",     1, 0.12 * 730),
    ("Speicher 500 GB", 1, 500 * 0.02),
    ("Datenverkehr 300 GB", 1, 300 * 0.08),
]
summe = 0
for name, anzahl, preis in ressourcen:
    kosten = anzahl * preis
    summe += kosten
    print(f"{name:22s} {kosten:8.2f} EUR")
print(f"{'Summe':22s} {summe:8.2f} EUR")
```

Die Funktion `lade_konfig` prüft beim Start, ob alle Pflichtwerte vorhanden sind, und bricht sonst sofort ab (*Fail Fast*): Ein Dienst, der ohne Datenbank-Adresse „irgendwie“ startet, erzeugt später schwer zu findende Fehler. Das Programm nimmt zur Demonstration ein Wörterbuch; in echten Anwendungen ist das `os.environ`. Der zweite Teil schätzt Monatskosten: drei Instanzen zu je 36,50 EUR, eine Datenbank für 87,60 EUR, Speicher für 10 EUR und Datenverkehr für 24 EUR ergeben 231,10 EUR. Die Preise sind erfundene Beispielwerte; wichtig ist die Methode, jede Position nach Einheit und Menge zu kalkulieren und die größten Kostentreiber (hier die Datenbank) zu erkennen.

Typische Fehler: Zugangsdaten im Quellcode, produktionsnahe Daten in der Testumgebung ohne Schutz (Datenschutzproblem, Modul 06), nicht getestete Backups und fehlende Kostenüberwachung. Falsch: `PASSWORT = "geheim123"` im Repository, das nie mehr vollständig aus der Versionshistorie verschwindet. Richtig: Geheimnisse aus dem Geheimnis-Dienst laden, bei Verdacht auf Offenlegung sofort austauschen. Auch Budgetwarnungen beim Cloud-Anbieter helfen, bevor die Monatsrechnung überrascht.

> **Merke**
>
> Gleicher Code in allen Umgebungen, Konfiguration und Geheimnisse von außen. Horizontale Skalierung braucht zustandslose Instanzen. Kosten werden von Anfang an pro Ressource sichtbar gemacht und beobachtet.

> **Praxisbeispiel**
>
> Kunden fragen nach Rechenzentrumsstandort, Backup-Rhythmus und Wiederherstellungszeiten. Teams halten dafür ein kurzes Betriebsdatenblatt bereit (Lerneinheit 5.9). Die Kosten pro Kunde fließen in die Unit Economics ein (Modul 03).

## 5.6 Monitoring und Logging

Ohne Beobachtung fliegt man im Betrieb blind. *Observability* (Beobachtbarkeit) bedeutet, von außen verstehen zu können, was im Inneren eines Systems geschieht. Drei Datenarten tragen dazu bei. *Metriken* sind Zahlen über die Zeit (Anfragen pro Sekunde, Fehlerrate, Antwortzeit, Speicherbedarf). *Logs* sind Textprotokolle einzelner Ereignisse („Zahlung 4711 fehlgeschlagen: Zeitüberschreitung“). *Traces* verfolgen eine einzelne Anfrage durch mehrere Dienste und zeigen, wo die Zeit vergeht. *Alerts* (Alarme) benachrichtigen Menschen, wenn eine Metrik eine Schwelle verletzt.

Gute Logs sind *strukturiert* (zum Beispiel als JSON), enthalten eine Korrelationskennung, über die man alle Zeilen einer Anfrage findet, und vermeiden personenbezogene Daten und Geheimnisse (Modul 06). Gute Alarme melden *Symptome* (Nutzer sind betroffen: hohe Fehlerrate, langsame Antworten) statt jeder Ursache, und jeder Alarm hat einen Verantwortlichen und eine Handlungsanweisung. Zu viele Alarme führen zu *Alarmmüdigkeit*: Man ignoriert sie, auch den wichtigen.

Bei Antwortzeiten ist der Durchschnitt irreführend, weil wenige sehr langsame Anfragen darin untergehen. Man betrachtet *Perzentile*: Das 95. Perzentil (p95) ist der Wert, unter dem 95 % der Anfragen liegen.

```python
import json
from math import ceil

zeiten = [120, 130, 110, 150, 140, 160, 125, 135, 145, 155,
          300, 280, 170, 165, 180, 190, 210, 950, 220, 1200]    # Millisekunden
status = [200] * 18 + [500, 503]

def perzentil(werte, p):
    s = sorted(werte)
    return s[ceil(p / 100 * len(s)) - 1]

mittel = sum(zeiten) / len(zeiten)
p95 = perzentil(zeiten, 95)
fehlerrate = sum(1 for s in status if s >= 500) / len(status)
print(f"Mittelwert {mittel:.0f} ms, p95 {p95} ms, Fehlerrate {fehlerrate:.0%}")

alarme = []
if p95 > 500:
    alarme.append("p95 ueber 500 ms")
if fehlerrate > 0.02:
    alarme.append("Fehlerrate ueber 2 Prozent")
print(json.dumps({"ereignis": "alarm", "gruende": alarme, "korrelation": "req-8f2a"}))
```

Die Funktion `perzentil` sortiert die Werte und wählt nach dem Nächste-Rang-Verfahren das Element an der Stelle ⌈ p · n ⌉. Der Mittelwert liegt bei 262 ms und wirkt unbedenklich, während das 95. Perzentil mit 950 ms zeigt, dass jeder zwanzigste Nutzer fast eine Sekunde wartet. Die Fehlerrate beträgt 10 %. Beide Schwellen werden verletzt, und das Programm gibt ein strukturiertes Log-Ereignis in JSON mit Korrelationskennung aus. Das Beispiel zeigt, weshalb man in Dashboards Perzentile statt Mittelwerte anzeigt.

Typische Fehler: Ausschließlich Mittelwerte beobachten, alles protokollieren (Kosten und Datenschutzrisiko), Logs ohne Struktur und Alarme ohne Handlungsanweisung. Falsch: Der Alarm „CPU 81 %“ weckt nachts jemanden, obwohl niemand betroffen ist. Richtig: Alarm bei hoher Fehlerrate oder Antwortzeit aus Nutzersicht, CPU-Werte als Hilfsmetrik auf einem Dashboard. Außerdem sollte die Beobachtung selbst überwacht werden; ein ausgefallener Alarm-Dienst merkt sich nicht selbst.

> **Merke**
>
> Metriken, Logs und Traces ergänzen sich. Alarme melden Symptome mit Verantwortlichem und Handlungsanweisung. Für Antwortzeiten zählen Perzentile, nicht der Mittelwert. Logs enthalten keine Geheimnisse und möglichst keine personenbezogenen Daten.

> **Praxisbeispiel**
>
> Aus den Messwerten entstehen später die Kennzahlen für SLAs (Lerneinheit 5.8). Eine öffentliche Statusseite zeigt Kunden den Zustand und reduziert Supportanfragen bei Störungen.

## 5.7 Incident Response

Ein *Incident* ist ein Ereignis, das den Dienst für Nutzer beeinträchtigt oder bedroht. Störungen lassen sich nicht ganz vermeiden; entscheidend ist, wie schnell und geordnet man reagiert. Die *Incident Response* legt Rollen, Ablauf und Kommunikation fest. Zuerst die *Severity* (Schweregrad): zum Beispiel SEV1 (Dienst komplett ausgefallen oder Datenverlust), SEV2 (wichtige Funktion gestört), SEV3 (kleinere Beeinträchtigung). Der Schweregrad bestimmt, wer geweckt wird und wie schnell reagiert werden muss. Die *Eskalation* regelt, wen man wann hinzuzieht, wenn die erste Person nicht weiterkommt. Die *Kommunikationswege* sichern, dass Kunden, Management und Team zur richtigen Zeit informiert werden, ohne dass die Technikerinnen davon abgelenkt werden.

Bewährt ist eine Rollenteilung im größeren Vorfall: eine Person leitet (*Incident Commander*), andere analysieren und beheben, eine dritte kommuniziert. Zuerst steht die *Wiederherstellung* des Dienstes (Rollback, Neustart, Umschalten), erst danach die Ursachenforschung. Nach dem Vorfall folgt das *Postmortem*: eine schuldzuweisungsfreie Aufarbeitung (englisch *blameless*) mit Zeitverlauf, Ursachen, was gut und schlecht lief und konkreten Maßnahmen mit Verantwortlichen. Das Ziel ist Lernen, nicht Schuldsuche; sonst verschweigen Menschen Fehler.

Das Beispiel klassifiziert Vorfälle nach Schweregrad und berechnet die wichtigsten Kennzahlen: *MTTD* (mittlere Zeit bis zur Erkennung), *MTTR* (mittlere Zeit bis zur Wiederherstellung).

```python
from datetime import datetime

def severity(nutzer_betroffen_prozent, datenverlust):
    if datenverlust or nutzer_betroffen_prozent >= 50:
        return "SEV1"
    if nutzer_betroffen_prozent >= 10:
        return "SEV2"
    return "SEV3"

f = "%Y-%m-%d %H:%M"
vorfaelle = [   # Beginn, erkannt, behoben, betroffen in Prozent, Datenverlust
    ("2026-09-03 14:00", "2026-09-03 14:12", "2026-09-03 15:02", 80, False),
    ("2026-09-18 02:30", "2026-09-18 03:10", "2026-09-18 04:40", 15, False),
    ("2026-10-07 11:00", "2026-10-07 11:05", "2026-10-07 11:35", 3,  False),
]
erkennung, behebung = [], []
for beginn, erkannt, behoben, prozent, verlust in vorfaelle:
    b, e, h = (datetime.strptime(x, f) for x in (beginn, erkannt, behoben))
    erkennung.append((e - b).total_seconds() / 60)
    behebung.append((h - b).total_seconds() / 60)
    print(severity(prozent, verlust), f"erkannt nach {erkennung[-1]:.0f} min, behoben nach {behebung[-1]:.0f} min")
print(f"MTTD {sum(erkennung)/3:.1f} min, MTTR {sum(behebung)/3:.1f} min")
```

Die Funktion `severity` ordnet nach Anteil betroffener Nutzer und Datenverlust ein. In der Schleife wandelt `strptime` die Texte in Zeitpunkte um; die Differenz zweier Zeitpunkte ergibt ein Intervall, aus dem `total_seconds` die Sekunden liefert. Die drei Vorfälle erhalten SEV1, SEV2 und SEV3. Der zweite Vorfall wurde erst nach 40 Minuten erkannt, weil er nachts auftrat; das ist ein Hinweis auf eine Lücke im Alarm-System, die das Postmortem bearbeiten sollte. MTTD liegt im Mittel bei 19,0 Minuten, MTTR bei 75,7 Minuten. Verbesserungen sollten gezielt an dem Kennzahlteil ansetzen, der am meisten Zeit kostet.

Typische Fehler: Kein Bereitschaftsplan, unklare Zuständigkeiten, Kommunikation per Zuruf, Ursachenforschung vor Wiederherstellung und Postmortems, die Schuldige suchen oder in der Schublade enden. Falsch: „Wer hat das verbockt?“ Richtig: „Welche Bedingungen haben den Fehler möglich gemacht, und was ändern wir im System?“ Sicherheitsvorfälle haben zusätzlich gesetzliche Meldefristen (Modul 06, Lerneinheit 6.9), die der Ablauf von Anfang an berücksichtigen muss.

> **Merke**
>
> Vorfälle werden nach Schweregrad eingeordnet, mit klaren Rollen und Eskalationswegen bearbeitet; erst wiederherstellen, dann analysieren. Postmortems sind schuldzuweisungsfrei und münden in Maßnahmen mit Verantwortlichen.

> **Praxisbeispiel**
>
> Größere Kunden verlangen im Vertrag Reaktionszeiten und Berichte nach Vorfällen. Die Dokumentation aus dem Postmortem ist die Grundlage dafür und zugleich Nachweis in Audits.

## 5.8 SLA und Verfügbarkeit

Ein *SLA* (Service Level Agreement) ist die vertragliche Zusage über die Qualität eines Dienstes, meist mit Verfügbarkeitsziel, Reaktionszeiten und Folgen bei Nichteinhaltung (Gutschriften). Technisch liegt darunter ein *SLO* (Service Level Objective), das interne Ziel, und ein *SLI* (Service Level Indicator), die gemessene Kenngröße (zum Beispiel der Anteil erfolgreicher Anfragen). Man setzt SLOs strenger als SLAs, damit ein Puffer bleibt. Die *Verfügbarkeit* wird in Prozent angegeben („Neunen“): 99,9 % bedeuten rund 43 Minuten Ausfall pro 30-Tage-Monat. Das *Wartungsfenster* ist ein vereinbarter Zeitraum für geplante Arbeiten, der nicht zur Ausfallzeit zählt; eine *Statusseite* informiert transparent.

Der *Fehlerbudget*-Gedanke (englisch *error budget*) macht daraus ein Steuerinstrument: Bei einem SLO von 99,9 % darf in einem Monat 0,1 % der Zeit gestört sein. Solange das Budget reicht, darf das Team Neues riskieren; ist es aufgebraucht, hat Stabilität Vorrang. Ein Fallstrick: Die Gesamtverfügbarkeit ist niedriger als die der Einzelteile, weil bei hintereinander geschalteten Abhängigkeiten alle funktionieren müssen. Sie ergibt sich als Produkt der einzelnen Verfügbarkeiten.

```python
MINUTEN_MONAT = 30 * 24 * 60

def ausfall_minuten(verfuegbarkeit_prozent):
    return MINUTEN_MONAT * (1 - verfuegbarkeit_prozent / 100)

for ziel in (99.0, 99.9, 99.95, 99.99):
    print(f"{ziel:6.2f} % -> {ausfall_minuten(ziel):7.1f} min Ausfall/Monat")

# Kette von Abhaengigkeiten: alle muessen funktionieren
abhaengigkeiten = {"Cloud-Hosting": 99.95, "Datenbank-Dienst": 99.9, "Zahlungsanbieter": 99.9}
gesamt = 1.0
for v in abhaengigkeiten.values():
    gesamt *= v / 100
print(f"Gesamtverfuegbarkeit: {gesamt*100:.3f} % -> {ausfall_minuten(gesamt*100):.0f} min/Monat")

budget = ausfall_minuten(99.9)
verbraucht = 31
print(f"Fehlerbudget Rest: {budget - verbraucht:.1f} von {budget:.1f} min")
```

Die Funktion rechnet die Ausfallminuten eines Monats mit 43.200 Minuten aus dem Verfügbarkeitsziel. Die Tabelle zeigt: 99 % erlauben 432 Minuten, 99,9 % etwa 43 Minuten, 99,95 % etwa 22 Minuten und 99,99 % nur etwa 4 Minuten. Die Kette aus drei Abhängigkeiten erreicht trotz Einzelwerten von mindestens 99,9 % nur rund 99,75 %, also etwa 108 Minuten Ausfall pro Monat; ein Versprechen von 99,9 % an Kunden wäre dann nicht haltbar, wenn man nicht Redundanz einbaut oder ausfallsichere Pfade schafft. Zuletzt zeigt das Fehlerbudget, dass bei 31 verbrauchten Minuten noch etwa 12 Minuten übrig sind, was riskante Releases bremst.

Typische Fehler: Mehr versprechen, als technisch möglich ist, SLAs ohne Messung, Ausnahmen (Wartung, höhere Gewalt, Anbieterausfälle) nicht vertraglich definieren und jede Störung als SLA-Verstoß zu verhandeln. Falsch: „100 % Verfügbarkeit garantiert.“ Richtig: ein realistisches Ziel mit klar definierter Messmethode, Ausnahmen, Gutschriften als einziger Rechtsfolge und Statusseite. Die rechtliche Gestaltung gehört mit Beratung geklärt (Modul 11).

> **Merke**
>
> SLAs sind Zusagen, SLOs interne Ziele, SLIs Messwerte. Jede zusätzliche Neun kostet überproportional viel. Abhängigkeiten multiplizieren sich; das Fehlerbudget verbindet Stabilität und Innovationstempo.

> **Praxisbeispiel**
>
> Großkunden verlangen SLA-Anlagen mit Verfügbarkeit, Supportzeiten und Berichtspflichten. Teams berechnen vor der Zusage mit Zahlen wie oben, ob sie das halten können, und beginnen oft mit „Best Effort“ und einer Statusseite, bis Messdaten vorliegen.

## 5.9 Betriebsdokumentation

Betriebsdokumentation hält das Wissen fest, das ein System am Laufen hält und im Notfall schnell zugänglich sein muss. Dazu gehören *Runbooks* (Schritt-für-Schritt-Anleitungen für wiederkehrende Aufgaben und bekannte Störungen: „Datenbank-Neustart“, „Zertifikat erneuern“), *Architekturdiagramme* (wie hängen die Teile zusammen) und eine *Dienstübersicht mit Abhängigkeiten* (was braucht was). Ein gutes Runbook beantwortet knapp: Wann trifft es zu? Wer ist verantwortlich? Wie prüfe ich den Zustand? Was tue ich Schritt für Schritt? Wie nehme ich es zurück? Wen eskaliere ich? Es ist für jemanden geschrieben, der mitten in der Nacht, unter Stress und ohne Vorwissen liest.

Dokumentation veraltet schnell. Deshalb gilt: nah am Code halten (im selben Repository), bei jeder Änderung prüfen und die Dokumentation, wo möglich, aus Konfiguration erzeugen. Ihr Nutzen zeigt sich beim *Onboarding*: Neue Entwickelnde sollten mit der Dokumentation in einem Tag eine Änderung ausliefern können. Das Beispiel prüft Dienstbeschreibungen auf Vollständigkeit, erkennt Zyklen in den Abhängigkeiten und berechnet eine sinnvolle Startreihenfolge mit dem Python-Modul `graphlib`.

```python
from graphlib import TopologicalSorter, CycleError

pflichtfelder = ["owner", "restart", "rollback", "eskalation"]
dienste = {
    "datenbank": {"owner": "Ben", "restart": "systemctl restart db", "rollback": "Backup einspielen",
                  "eskalation": "Bereitschaft", "braucht": []},
    "cache":     {"owner": "Ben", "restart": "systemctl restart cache", "rollback": "leeren",
                  "eskalation": "Bereitschaft", "braucht": []},
    "api":       {"owner": "Anna", "restart": "deploy neu starten", "rollback": "letzte Version",
                  "braucht": ["datenbank", "cache"]},
    "web":       {"owner": "Anna", "restart": "deploy neu starten", "rollback": "letzte Version",
                  "eskalation": "Bereitschaft", "braucht": ["api"]},
}
for name, d in dienste.items():
    fehlt = [f for f in pflichtfelder if f not in d]
    if fehlt:
        print(f"{name}: Runbook unvollstaendig, fehlt {fehlt}")

try:
    reihenfolge = list(TopologicalSorter({n: d["braucht"] for n, d in dienste.items()}).static_order())
    print("Startreihenfolge:", " -> ".join(reihenfolge))
except CycleError as e:
    print("Zyklus in Abhaengigkeiten:", e)
```

Die Schleife prüft für jeden Dienst, ob alle Pflichtfelder vorhanden sind; für `api` fehlt die Eskalation. Der `TopologicalSorter` erhält ein Wörterbuch, das jedem Dienst seine Voraussetzungen zuordnet, und liefert eine Reihenfolge, in der jeder Dienst erst nach seinen Voraussetzungen kommt: Datenbank und Cache, dann API, dann Web. Würde `datenbank` fälschlich von `web` abhängen, entstünde ein Zyklus, den `CycleError` meldet. Dasselbe Wissen braucht man im Störfall: Welche Dienste sind betroffen, wenn die Datenbank ausfällt (alle, die davon abhängen), und in welcher Reihenfolge fährt man sie nach einem Totalausfall hoch.

Typische Fehler: Wissen nur in Köpfen oder verstreut in Chats, Runbooks, die nie ausprobiert wurden, und Diagramme, die den Stand von vor einem Jahr zeigen. Falsch: „Frag Ben, der weiß es.“ Richtig: das Runbook liegt im Repository, und eine zweite Person hat es einmal durchgespielt. Eine gute Gewohnheit sind regelmäßige Übungen („Game Days“), bei denen das Team Störungen simuliert und dabei die Dokumentation verbessert. Zugangsdaten gehören nicht ins Runbook (Lerneinheit 5.5).

> **Merke**
>
> Runbooks, Diagramme und eine Dienstübersicht mit Abhängigkeiten tragen den Betrieb. Sie liegen nah am Code, werden geübt und gepflegt. Gutes Onboarding ist der Test für gute Dokumentation.

> **Praxisbeispiel**
>
> In der Due Diligence (Modul 08) und bei Kundenprüfungen wird Betriebsdokumentation häufig verlangt. Sie ist außerdem die Grundlage für Notfallplanung und Wiederanlauf (Modul 12, BCDR).

## Übungsaufgaben zu Modul 05

1.  **(leicht)** Erkläre den Unterschied zwischen Continuous Delivery und Continuous Deployment.

2.  **(leicht)** Nenne die drei Datenarten der Observability und gib je ein Beispiel.

3.  **(leicht)** Warum verwendet man für Antwortzeiten Perzentile statt des Mittelwerts?

4.  **(mittel)** Ein Dienst hat ein SLO von 99,95 %. Wie viele Minuten Ausfall sind in einem 30-Tage-Monat erlaubt? Was passiert, wenn davon schon 15 Minuten verbraucht sind?

5.  **(mittel)** Beschreibe, warum ein „Eiscreme-Kegel“ an Tests (viele E2E, wenige Unit-Tests) problematisch ist, und wie du die Verteilung verbessern würdest.

6.  **(praktisch)** Erweitere den Linter aus 5.2 um eine Prüfung auf Funktionen mit mehr als fünf Parametern.

7.  **(praktisch)** Schreibe Grenzwerttests für eine Funktion `rabatt(menge)`: Menge unter 10 keinen Rabatt, ab 10 5 %, ab 50 10 %, negative Mengen sind ungültig.

8.  **(schwer/praktisch)** Schreibe ein Skript, das aus einer Liste von Log-Zeilen im Format `2026-10-01T12:00:03 GET /api/angebote 200 87ms` je Pfad Anfragezahl, Fehlerrate und p95 berechnet.

## Lösungen zu den Übungsaufgaben Modul 05

**1.** Bei Continuous Delivery ist jede geprüfte Änderung jederzeit auslieferbar, die Auslieferung in die Produktion wird aber per Entscheidung (zum Beispiel Knopfdruck oder Freigabe) ausgelöst. Bei Continuous Deployment wird jede Änderung, die die Pipeline besteht, automatisch in die Produktion ausgeliefert.

**2.** Metriken (Fehlerrate pro Minute), Logs (Fehlermeldung zu einer einzelnen Zahlung), Traces (Weg einer Anfrage von der Web-Oberfläche über die API bis zur Datenbank mit Zeiten je Schritt).

**3.** Der Mittelwert versteckt wenige sehr langsame Anfragen, die für einzelne Nutzer das Erlebnis bestimmen. Das 95. Perzentil zeigt, welche Zeit 95 % der Anfragen unterschreiten, und macht Ausreißer sichtbar.

**4.** 43 200 · 0,0005 = 21,6 Minuten. Bei 15 verbrauchten Minuten bleiben 6,6 Minuten Budget; riskante Änderungen sollten pausieren, bis Stabilität wiederhergestellt ist.

**5.** E2E-Tests sind langsam, instabil und schwer zu diagnostizieren. Mit vielen davon dauert jede Prüfung lange, Fehler lassen sich schwer lokalisieren, und das Team ignoriert zufällige Ausfälle. Besser: die Logik in Unit-Tests absichern, Zusammenspiel in Integrationstests, E2E nur für wenige kritische Pfade.

**6.** Ergänzung in der Schleife:

```python
    if isinstance(knoten, ast.FunctionDef):
        anzahl = len(knoten.args.args)
        if anzahl > 5:
            print(f"Zeile {knoten.lineno}: {knoten.name}() hat {anzahl} Parameter")
```

Die Parameterliste steht im Knoten unter `args.args`; ihre Länge ist die Parameterzahl (ohne Sternchen-Parameter).

**7.** Eine mögliche Lösung:

```python
import unittest

def rabatt(menge):
    if menge < 0:
        raise ValueError("Menge negativ")
    return 0.10 if menge >= 50 else 0.05 if menge >= 10 else 0.0

class T(unittest.TestCase):
    def test_grenzen(self):
        for menge, erwartet in [(0, 0.0), (9, 0.0), (10, 0.05), (49, 0.05), (50, 0.10)]:
            with self.subTest(menge=menge):
                self.assertEqual(rabatt(menge), erwartet)
    def test_negativ(self):
        with self.assertRaises(ValueError):
            rabatt(-1)

unittest.main(argv=["x"], exit=False)
```

Die Fälle 9, 10, 49 und 50 liegen unmittelbar an den Grenzen; dort entstehen die typischen Vergleichsfehler.

**8.** Mögliche Lösung:

```python
from collections import defaultdict
from math import ceil

zeilen = """2026-10-01T12:00:03 GET /api/angebote 200 87ms
2026-10-01T12:00:04 GET /api/angebote 200 95ms
2026-10-01T12:00:05 GET /api/angebote 500 410ms
2026-10-01T12:00:06 GET /api/kunden 200 40ms
2026-10-01T12:00:07 GET /api/kunden 200 55ms""".splitlines()

je_pfad = defaultdict(list)
for z in zeilen:
    _, _, pfad, code, ms = z.split()
    je_pfad[pfad].append((int(code), int(ms.rstrip("ms"))))

for pfad, werte in je_pfad.items():
    zeiten = sorted(m for _, m in werte)
    p95 = zeiten[ceil(0.95 * len(zeiten)) - 1]
    fehler = sum(1 for c, _ in werte if c >= 500) / len(werte)
    print(f"{pfad}: {len(werte)} Anfragen, Fehlerrate {fehler:.0%}, p95 {p95} ms")
```

Die Zeilen werden an Leerzeichen zerlegt, nach Pfad gruppiert und je Gruppe ausgewertet. Ausgabe: `/api/angebote`: 3 Anfragen, Fehlerrate 33 %, p95 410 ms; `/api/kunden`: 2 Anfragen, Fehlerrate 0 %, p95 55 ms.
