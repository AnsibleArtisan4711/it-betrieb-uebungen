# Modul 13 - Security, Datenschutz und Compliance in Dokumenten

> **Hinweis zu diesem Kapitel:** Das ist das Kapitel des Skripts „Technische Dokumentation und Dokumentations-Governance“, aus der LaTeX-Quelle in Markdown umgewandelt (Text und Listings unverändert, farbige Boxen als Zitatblöcke mit fettem Titel, Tabellen als Markdown-Tabellen, Übungsaufgaben und Lösungen als Absätze). Die Lerneinheiten sind wie in der Quelle nach Modul nummeriert (13.1 bis 13.15), danach folgen „Übungsaufgaben“ (8 Aufgaben) und „Lösungen und Erläuterungen“. Die Sprachangabe der Codeblöcke ist in der Quelle nur für Python und Bash gesetzt; die übrigen Blöcke sind hier nach ihrem Inhalt als `python`, `yaml`, `markdown`, `bash` oder `text` ausgezeichnet, der Inhalt selbst ist unverändert. **Prüfstand der Beispiele für dieses Repository:** Die Python-Beispiele wurden auf Syntax geprüft; welche Beispiele ausgeführt wurden und welche zusätzlich PyYAML brauchen, steht in der [README des Repositories](../README.md). Übersicht zum Modul: [README](README.md).

**Dauer:** 15,75 Stunden | **Priorität:** 1 | **Lerneinheiten:** 15

| **Nr.** | **Lerneinheit**              | **Dauer (h)** | **Prio** |
|--------:|:-----------------------------|--------------:|---------:|
|       1 | Informationsklassifizierung  |             1 |        1 |
|       2 | Geheimnisse und Zugangsdaten |             1 |        1 |
|       3 | Datenschutz und PII          |             1 |        1 |
|       4 | Need-to-know Prinzip         |             1 |        1 |
|       5 | Auditfähigkeit               |             1 |        1 |
|       6 | Aufbewahrung                 |             1 |        2 |
|       7 | Dokumentationsrisiken        |             1 |        2 |
|       8 | Security-Troubleshooting     |             1 |        2 |
|       9 | Compliance Anforderungen     |          1,25 |        1 |
|      10 | DSGVO Bezug                  |          1,25 |        1 |
|      11 | Berechtigungskonzept         |             1 |        1 |
|      12 | Aufbewahrung und Löschung    |             1 |        1 |
|      13 | Security by Documentation    |             1 |        2 |
|      14 | Vertraulichkeit              |             1 |        2 |
|      15 | Compliance-Troubleshooting   |          1,25 |        2 |
|         | **Summe**                    |     **15,75** |          |

## 13.1 Informationsklassifizierung

Nicht jede Information ist gleich schützenswert. Das Betriebsmenü der Kantine darf jeder lesen, die Zugangsdaten zur Produktionsdatenbank dürfen es nicht. Informationsklassifizierung ist das Verfahren, mit dem eine Organisation festlegt, *wie schutzbedürftig* eine Information ist, und daraus ableitet, wie sie behandelt, gespeichert, weitergegeben und gelöscht wird. Für Dokumentation ist das besonders wichtig, weil Dokumente Informationen sammeln, die an anderer Stelle gut geschützt sind: In einem Betriebshandbuch stehen Systemarchitektur, Adressen, Verantwortliche und manchmal sogar Zugangsdaten an einem Ort.

Ein Klassifizierungsschema besteht aus wenigen, klar abgegrenzten Stufen. Eine häufige Einteilung kennt vier: *öffentlich* (darf jeder sehen), *intern* (nur für Mitarbeitende), *vertraulich* (nur für einen definierten Personenkreis) und *streng vertraulich* (äußerst kleiner Kreis, besonderer Schutz). Die Namen und die Zahl der Stufen sind Sache der Organisation; wichtiger als die Namen ist, dass jede Stufe eine *Handlungsanweisung* hat: Wo darf das Dokument liegen? Darf es per E-Mail verschickt werden? Muss es verschlüsselt sein? Wer genehmigt die Weitergabe? Ohne diese Regeln bleibt Klassifizierung ein Etikett ohne Wirkung.

> **Ergänzung aus der Nachrecherche**
>
> Klassifizieren und Kennzeichnen nach ISO/IEC 27001: Laut der abgerufenen Beschreibung der Maßnahme 5.13 (Kennzeichnung von Informationen) sollen Informationen gemäß dem festgelegten Klassifizierungsschema gekennzeichnet werden, damit alle verstehen, wie sensibel sie sind. Kennzeichnungsregeln können in einer Klassifizierungsrichtlinie oder einem eigenen Verfahren stehen; festzulegen ist, wer kennzeichnet, wie das Etikett aussieht und wie es angebracht wird. Die Seite nennt keine konkreten Stufen; diese verweist sie an die zugehörige Maßnahme zur Klassifizierung. Die Norm selbst wurde nicht eingesehen. (Abruf 28.10.2026, siehe Quellenverzeichnis.)

In der Praxis ist entscheidend, *wer klassifiziert* und *wie*. Der Owner eines Dokuments legt die Klasse fest, weil er Inhalt und Risiko kennt. Enthält ein Dokument Teile unterschiedlicher Schutzstufen, gilt die höchste (das sogenannte *High-Water-Mark-Prinzip*) oder man trennt das Dokument in einen öffentlichen und einen vertraulichen Teil. Das Etikett steht sichtbar im Dokument (Kopf- oder Fußzeile) und in den Metadaten, damit Werkzeuge es auswerten können.

Das folgende Beispiel zeigt eine Klassifizierungsrichtlinie als Daten, die den Stufen Regeln zuordnet, und ein Skript, das Dokumente gegen diese Regeln prüft: Hat jedes Dokument eine gültige Klasse, und liegt es in einem Ablagebereich, der für diese Klasse zulässig ist?

```yaml
klassen:
  oeffentlich:       {ablage: [web, intern, vertraulich_ablage]}
  intern:            {ablage: [intern, vertraulich_ablage]}
  vertraulich:       {ablage: [vertraulich_ablage]}
  streng_vertraulich: {ablage: [vertraulich_ablage]}
```

```text
titel;klasse;ablage
Preisliste;oeffentlich;web
Betriebshandbuch Shop;intern;intern
Netzplan Produktion;vertraulich;intern
Zugangskonzept;streng_vertraulich;vertraulich_ablage
Altes Memo;;intern
```

```python
import csv, sys, yaml

klassen = yaml.safe_load(open(sys.argv[1], encoding="utf-8"))["klassen"]
for z in csv.DictReader(open(sys.argv[2], encoding="utf-8"), delimiter=";"):
    if not z["klasse"]:
        print(f"{z['titel']}: keine Klasse vergeben")
    elif z["klasse"] not in klassen:
        print(f"{z['titel']}: unbekannte Klasse '{z['klasse']}'")
    elif z["ablage"] not in klassen[z["klasse"]]["ablage"]:
        print(f"{z['titel']}: Ablage '{z['ablage']}' unzulässig für Klasse {z['klasse']}")
    else:
        print(f"{z['titel']}: ok")
```

Die Richtlinie ordnet jeder Klasse die zulässigen Ablagebereiche zu. Je höher die Klasse, desto kleiner die Liste. Das Skript geht jedes Dokument durch und meldet fehlende oder unbekannte Klassen und unzulässige Ablageorte. Im Beispiel liegt der Netzplan (vertraulich) in einem internen Bereich, das ist ein Befund, und das alte Memo hat gar keine Klasse. Beachten Sie, dass das Skript die Klasse nicht beurteilt, es kontrolliert nur, ob die Regeln eingehalten wurden.

Typische Fehler: Zu viele Stufen, die niemand auseinanderhält; Klassifizierung nur beim Anlegen, ohne spätere Überprüfung, obwohl sich der Inhalt ändert; alles ist „vertraulich“, sodass die Kennzeichnung ihren Wert verliert; Klasse im Dokument, aber kein Regelwerk dahinter.

| **Falsch**                                                                             | **Richtig**                                                                                                     |
|:---------------------------------------------------------------------------------------|:----------------------------------------------------------------------------------------------------------------|
| Stempel „VERTRAULICH“ auf allen Dokumenten, Ablage auf dem frei zugänglichen Laufwerk. | Vier Stufen mit Regeln, Klasse im Kopf und in den Metadaten, Ablagebereich je Klasse, Prüfung durch ein Skript. |

Im Projekt beginnen Sie am besten mit dem, was am meisten schadet: den Dokumenten mit Zugangsinformationen, Netzplänen und Personendaten. Diese zuerst zu klassifizieren und zu schützen bringt am meisten Wirkung je Aufwand.

## 13.2 Geheimnisse und Zugangsdaten

Zu den gefährlichsten Inhalten einer Dokumentation gehören Geheimnisse: Passwörter, API-Schlüssel, Zugriffstoken, private Schlüssel, Verbindungszeichenfolgen mit Kennwort. Sie erscheinen in Dokumentation aus verständlichem Grund, denn eine Anleitung „melden Sie sich an der Datenbank an“ wird einfacher, wenn das Passwort gleich dabeisteht. Doch ein Dokument wird kopiert, in Wikis veröffentlicht, in Mails weitergeleitet und in Repositories gesichert; ein Geheimnis darin ist faktisch öffentlich für jeden, der das Dokument je sieht.

> **Ergänzung aus der Nachrecherche**
>
> Geheimnisse laut OWASP: Der abgerufene Cheat Sheet zur Verwaltung von Geheimnissen empfiehlt unter anderem, Geheimnisse nicht fest im Quelltext, in Konfigurationsdateien oder Werkzeugen zu hinterlegen; sie zentral zu verwalten; regelmäßig und möglichst automatisiert zu rotieren, damit gestohlene Zugangsdaten nur kurz nutzbar sind; jedem Benutzer, Dienst und jeder Pipeline nur die nötigen Geheimnisse zugänglich zu machen; alle Zugriffe zu protokollieren; und Geheimnisse nie im Klartext in Logs zu schreiben. Ausdrücklich empfohlen wird auch, zu dokumentieren, welche Geheimnisse wo gespeichert sind, warum, wer Zugriff hat, wie rotiert wird und welche Folgen eine Offenlegung hätte, nicht aber die Geheimnisse selbst. (Abruf 28.10.2026, siehe Quellenverzeichnis.)

Daraus folgt die Grundregel der Dokumentation: *Dokumentieren Sie, wo ein Geheimnis liegt, nicht was es ist.* Eine Anleitung nennt den Namen des Eintrags im Geheimnisspeicher (Vault, Passwortmanager) und beschreibt den Abruf, aber enthält nie den Wert. Zusätzlich führt man ein *Geheimnisinventar* mit Metadaten: Name, Zweck, Ablageort, Owner, Rotationsintervall, Datum der letzten Rotation. Und man sucht aktiv nach versehentlich dokumentierten Geheimnissen. Hierfür gibt es spezialisierte Werkzeuge (Secret Scanner); das folgende Beispiel zeigt das Prinzip mit einfachen Mustern.

```python
import re, sys
from pathlib import Path

MUSTER = {
    "Passwort-Zuweisung": re.compile(r"(?i)\b(passwort|password|pwd|kennwort)\s*[:=]\s*\S{4,}"),
    "Privater Schluessel": re.compile(r"-----BEGIN [A-Z ]*PRIVATE KEY-----"),
    "Bearer-Token": re.compile(r"(?i)bearer\s+[A-Za-z0-9._-]{20,}"),
    "AWS-Zugangsschluessel": re.compile(r"\bAKIA[0-9A-Z]{16}\b"),
    "URL mit Zugangsdaten": re.compile(r"\b[a-z]+://[^/\s:@]+:[^/\s@]+@"),
}
PLATZHALTER = re.compile(r"(?i)(<[^>]+>|\*{3,}|xxx+|beispiel|changeme|vault:)")

funde = 0
for datei in Path(sys.argv[1]).rglob("*.md"):
    for nr, zeile in enumerate(datei.read_text(encoding="utf-8").splitlines(), 1):
        for name, muster in MUSTER.items():
            if muster.search(zeile) and not PLATZHALTER.search(zeile):
                print(f"{datei.name}:{nr}: {name}")
                funde += 1
sys.exit(1 if funde else 0)
```

Das Skript definiert fünf Muster für typische Geheimnisse (Zuweisungen mit dem Wort Passwort, die Kopfzeile eines privaten Schlüssels, Bearer-Token, die Form eines Zugangsschlüssels bestimmter Cloud-Anbieter und Adressen mit Benutzer und Passwort) und eine Ausnahme für Platzhalter, damit Dokumentation, die erkennbar nur Muster zeigt, nicht gemeldet wird. Es durchsucht alle Markdown-Dateien zeilenweise und beendet sich mit Fehlercode, wenn es etwas fand, sodass man es als Sperre in eine Pipeline einbauen kann. Muster erzeugen Fehlalarme und übersehen Geheimnisse, die anders aussehen; reale Werkzeuge ergänzen sie um die Prüfung der Zufälligkeit von Zeichenketten. Wichtig ist, dass die Prüfung *vor* der Veröffentlichung läuft: Ein einmal veröffentlichtes Geheimnis gilt als kompromittiert und muss ausgetauscht werden, auch wenn man den Text später entfernt.

Das Geheimnisinventar kann so aussehen. Es enthält keine Werte, nur Metadaten.

```text
- name: shop/db/passwort
  zweck: Datenbankzugang der Shop-Anwendung
  ort: Vault, Pfad kv/shop/db
  owner: Team Plattform
  rotation_tage: 90
  zuletzt_rotiert: 2026-08-01
```

Typische Fehler: Geheimnisse im Klartext in der Anleitung, im Screenshot, im Kommentar; Entfernen des Geheimnisses aus der aktuellen Fassung, während es in der Versionsgeschichte bleibt; das gleiche Passwort in mehreren Dokumenten; fehlende Rotation nach Offenlegung.

| **Falsch**               | **Richtig**                                                          |
|:-------------------------|:---------------------------------------------------------------------|
| „Verbinden mit: `postgres://shop:Sommer2026!@db01/shop`“ | „Verbinden mit: `postgres://shop:<PASSWORT>@db01/shop`. Das Passwort steht im Vault unter `kv/shop/db`.“ |

Im Projekt gilt für den Ernstfall: Wird ein Geheimnis in einem Dokument gefunden, ist es sofort zu *rotieren*, nicht nur zu löschen. Danach ist festzustellen, wer Zugriff hatte, und die Ursache zu beheben.

## 13.3 Datenschutz und PII

PII steht für *Personally Identifiable Information*, im deutschen Recht heißen die Daten *personenbezogene Daten*: alle Informationen, die sich auf eine identifizierte oder identifizierbare Person beziehen. Dazu zählen offensichtliche Angaben (Name, Anschrift, E-Mail, Telefonnummer, Kontonummer) und weniger offensichtliche (IP-Adresse, Kennungen, Standortdaten, Benutzernamen in Protokollen, Fotos). In Dokumentation tauchen sie oft ungeplant auf: in Beispieldaten, in Screenshots, in eingefügten Protokollauszügen, in Ansprechpartnerlisten und in Fehlerberichten.

Aus Sicht der Dokumentation gelten drei Grundregeln. Erstens: *Vermeiden.* Beispiele werden mit erfundenen Daten erstellt, Screenshots werden aus Testsystemen gemacht. Zweitens: *Minimieren.* Wo Personenbezug unvermeidlich ist (Verantwortliche, Bereitschaftslisten), stehen nur die notwendigen Angaben darin, möglichst als Funktion und nicht als Privatadresse. Drittens: *Schützen.* Dokumente mit Personenbezug werden klassifiziert, haben begrenzten Zugriff und Löschfristen.

Hilfreich ist die automatische Erkennung typischer Muster. Das folgende Beispiel sucht in Text nach E-Mail-Adressen, nach IBAN-Nummern und nach Telefonnummern in einer einfachen Form. Bei IBAN prüft es zusätzlich die Prüfziffer nach dem Verfahren Modulo 97, damit zufällige Zeichenfolgen nicht als IBAN gelten. Dieses Verfahren stellt die ersten vier Zeichen ans Ende, ersetzt Buchstaben durch Zahlen (A gleich 10 bis Z gleich 35) und prüft, ob die entstehende Zahl bei Division durch 97 den Rest 1 lässt.

```python
import re, sys

def iban_gueltig(iban):
    iban = iban.replace(" ", "").upper()
    umgestellt = iban[4:] + iban[:4]
    zahl = "".join(str(int(c, 36)) for c in umgestellt)
    return int(zahl) % 97 == 1

EMAIL = re.compile(r"\b[\w.+-]+@[\w-]+(?:\.[\w-]+)+\b")
IBAN = re.compile(r"\b[A-Z]{2}\d{2}(?: ?[A-Z0-9]{4}){2,7}(?: ?[A-Z0-9]{1,3})?\b")
TELEFON = re.compile(r"(?<!\w)(?<!\d )(?:\+|00)\d{1,3}[\d /-]{6,14}\d")

for nr, zeile in enumerate(open(sys.argv[1], encoding="utf-8"), 1):
    for m in EMAIL.finditer(zeile):
        print(f"Zeile {nr}: E-Mail {m.group()}")
    for m in IBAN.finditer(zeile):
        if iban_gueltig(m.group()):
            print(f"Zeile {nr}: gültige IBAN {m.group()}")
    for m in TELEFON.finditer(zeile):
        print(f"Zeile {nr}: Telefonnummer {m.group().strip()}")
```

Die Funktion `iban_gueltig` setzt das Verfahren in drei Zeilen um. `int(c, 36)` wandelt jede Ziffer oder jeden Buchstaben in einen Zahlenwert um (Buchstaben ab 10), die Ergebnisse werden zu einer langen Zahl verkettet, und Python rechnet mit beliebig großen ganzen Zahlen, sodass der Rest ohne Tricks bestimmt werden kann. Die drei Muster finden E-Mail-Adressen, IBAN-Kandidaten und internationale Telefonnummern. Der Zusatz `(?<!\d )` im Telefonmuster verhindert, dass Ziffernblöcke mitten in einer IBAN als Telefonnummer gelten; ohne ihn meldet das Skript für die Beispielzeile mit der IBAN zusätzlich zwei Scheintreffer. Treffer sind *Hinweise*: Eine gefundene Adresse kann eine Funktionsadresse sein, die unbedenklich ist, und nicht jede Person ist an einem Muster erkennbar. Die Prüfung ersetzt kein Urteil, hilft aber, offensichtliche Stellen zu finden.

Typische Fehler: Echte Kundendaten als Beispiel in der Anleitung; Screenshots mit sichtbaren Namen; Protokollauszüge mit IP-Adressen und Benutzernamen in Fehlerberichten; Personenlisten, die nie aktualisiert werden und Menschen enthalten, die längst nicht mehr im Unternehmen sind.

| **Falsch**                                                                                                | **Richtig**                                                                                                                                                       |
|:----------------------------------------------------------------------------------------------------------|:------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Beispiel in der Anleitung: „Kunde Maria Huber, Hauptstraße 5, IBAN …“ mit echten Angaben aus dem Support. | Beispiel mit erfundenen Daten: „Kunde Erika Mustermann, Beispielweg 1, IBAN DE89 3704 0044 0532 0130 00“ (bekannte Testnummer), klar als Beispiel gekennzeichnet. |

Im Projekt hat sich eine Richtlinie bewährt: Beispieldaten stammen aus einer gemeinsamen Sammlung erfundener Datensätze. So muss niemand überlegen, ob er echte Daten verwenden darf.

## 13.4 Need-to-know Prinzip

Das Need-to-know-Prinzip („Kenntnis nur, wenn nötig“) besagt, dass eine Person Zugang zu Informationen nur dann bekommt, wenn sie diese für ihre Aufgabe braucht. Es ist enger als die Klassifizierung: Selbst innerhalb der Klasse „intern“ sehen nicht alle alles, sondern nur diejenigen, die einen konkreten Grund haben. Das Prinzip begrenzt den Schaden bei Fehlern, Missbrauch und Angriffen: Wer wenig sieht, kann wenig verraten, verlieren oder verändern.

Es hat zwei Seiten. Das *Prinzip der minimalen Rechte* (Least Privilege) fordert, dass Berechtigungen auf das Nötige beschränkt sind. Die *Trennung von Aufgaben* (Separation of Duties) fordert, dass kritische Abläufe nicht in einer Hand liegen. Für Dokumentation heißt das: Betriebsdokumentation mit Details zu Systemen und Zugängen ist nur dem Betriebsteam zugänglich; Entwürfe sind nur für Autoren und Reviewer sichtbar; der Zugriff auf Archive und Personendaten ist besonders eng. Das Gegenteil, das „Alle dürfen alles“-Wiki, ist bequem, aber gefährlich.

Need-to-know ist Prinzip, kein Verfahren. Es wird durch ein Berechtigungskonzept umgesetzt (siehe unten) und durch regelmäßige Überprüfung gehalten, denn Menschen wechseln Aufgaben und behalten alte Rechte. Das folgende Beispiel vergleicht tatsächliche Zugriffe mit dem Bedarf einer Rolle und findet Überberechtigungen.

```text
rolle;bedarf
service_desk;intern
betrieb;intern|vertraulich
personal;intern|personenbezogen
```

```text
person;rolle;zugriff_auf
Anna;betrieb;intern|vertraulich
Bernd;service_desk;intern|vertraulich
Cora;service_desk;intern
Dieter;personal;intern|personenbezogen|vertraulich
```

```python
import csv

bedarf = {z["rolle"]: set(z["bedarf"].split("|"))
          for z in csv.DictReader(open("bedarf.csv", encoding="utf-8"), delimiter=";")}

for z in csv.DictReader(open("zugriffe.csv", encoding="utf-8"), delimiter=";"):
    ist = set(z["zugriff_auf"].split("|"))
    zuviel = ist - bedarf[z["rolle"]]
    fehlt = bedarf[z["rolle"]] - ist
    meldung = []
    if zuviel:
        meldung.append("ÜBERBERECHTIGT: " + ", ".join(sorted(zuviel)))
    if fehlt:
        meldung.append("fehlt: " + ", ".join(sorted(fehlt)))
    print(f"{z['person']} ({z['rolle']}): " + ("; ".join(meldung) or "ok"))
```

Das Skript bildet aus Rollenbedarf und tatsächlichen Zugriffen Mengen und bildet jeweils die Differenz. Die Menge `ist - bedarf` enthält alles, was die Person darf, aber nicht braucht, die Menge `bedarf - ist` alles, was sie braucht, aber nicht hat. Für das Beispiel ergibt sich: Bernd hat als Mitarbeiter im Service Desk Zugriff auf Vertrauliches (überberechtigt), und Dieter hat zusätzlich Zugriff auf Vertrauliches, den seine Rolle nicht vorsieht. Beide Befunde sind Fragen an die Rollenzuordnung: Hat sich die Aufgabe geändert, oder ist das Recht ein Überbleibsel?

Typische Fehler: Rechte werden bei Aufgabenwechsel nur ergänzt, nie entzogen; Gruppen sind so groß, dass faktisch jeder Zugriff hat; temporäre Rechte werden nie zurückgenommen; Dokumente liegen in Bereichen mit pauschalen Rechten, weil die Einzelvergabe als zu aufwendig gilt.

| **Falsch**                                                                       | **Richtig**                                                                                                     |
|:---------------------------------------------------------------------------------|:----------------------------------------------------------------------------------------------------------------|
| Die ganze IT-Abteilung hat Lesezugriff auf alle Betriebsdokumente und Netzpläne. | Netzpläne und Zugangskonzepte nur für das Betriebsteam, Rechte über Rollen vergeben und halbjährlich überprüft. |

Im Projekt wirkt die regelmäßige Rezertifizierung am stärksten: Einmal im Halbjahr bestätigen die Owner, wer Zugriff behalten soll, und nicht Bestätigtes wird entzogen.

## 13.5 Auditfähigkeit

Auditfähigkeit heißt, dass sich Dokumentation und die dahinterliegenden Prozesse von Dritten prüfen lassen: von internen Revisoren, externen Zertifizierern, Kunden oder Behörden. Ein Audit stellt im Kern drei Fragen. Gibt es die vorgeschriebene Dokumentation? Ist sie aktuell und freigegeben? Und kann belegt werden, dass entsprechend gehandelt wurde? Die dritte Frage erfordert *Nachweise* (Evidenz): Protokolle, Freigabevermerke, Prüfberichte, Schulungsnachweise.

Auditfähige Dokumentation hat fünf Eigenschaften. Sie ist *vollständig* gegenüber den Anforderungen, *eindeutig versioniert* (welche Fassung galt zu welchem Zeitpunkt?), *freigegeben* mit Nachweis (wer hat wann zugestimmt?), *rückverfolgbar* (aus welcher Anforderung folgt welches Dokument?) und *auffindbar* (der Auditor findet sie in Minuten, nicht in Tagen). Die technischen Grundlagen für Versionierung, Freigabe und Protokollierung wurden in Modul 10 behandelt, insbesondere der Audit Trail; hier geht es um die Sicht des Prüfers.

Das folgende Beispiel zeigt einen *Nachweiskatalog*: Er listet für jede Kontrollanforderung die erwarteten Nachweise mit Ablageort und maximalem Alter. Ein Skript prüft, ob sie vorhanden und aktuell sind. So wird die Frage „Sind wir auditbereit?“ jederzeit beantwortbar und nicht erst eine Woche vor dem Termin.

```text
kontrolle;nachweis;max_alter_tage
Dokumente freigegeben;nachweise/freigaben.csv;365
Zugriffe überprüft;nachweise/rezertifizierung.pdf;180
Datensicherung getestet;nachweise/restore-test.txt;90
Schulung durchgeführt;nachweise/schulung.csv;365
```

```python
import csv, os, time
from pathlib import Path

jetzt = time.time()
for z in csv.DictReader(open("katalog.csv", encoding="utf-8"), delimiter=";"):
    datei = Path(z["nachweis"])
    if not datei.exists():
        print(f"{z['kontrolle']}: Nachweis FEHLT ({datei})")
        continue
    alter = (jetzt - os.path.getmtime(datei)) / 86400
    grenze = int(z["max_alter_tage"])
    status = "ok" if alter <= grenze else f"VERALTET ({round(alter)} Tage, erlaubt {grenze})"
    print(f"{z['kontrolle']}: {status}")
```

Das Skript prüft pro Kontrolle, ob die Nachweisdatei existiert und wie alt sie ist, wobei das Alter über die Änderungszeit der Datei (`os.path.getmtime`) bestimmt wird. Das ist eine Näherung: Die Änderungszeit kann sich durch Kopieren verändern, und ein Datum im Dokument selbst wäre belastbarer. Der Kern der Idee ist, Nachweise als Daten zu verwalten und regelmäßig zu prüfen, ob sie vollständig und aktuell sind.

Typische Fehler: Nachweise werden erst kurz vor dem Audit rekonstruiert; Dokumente existieren, werden aber nicht gelebt („Papiertiger“); die Fassung, die im Audit vorgelegt wird, ist nicht die, nach der gearbeitet wird; es gibt keine Zuordnung von Anforderung zu Nachweis.

| **Falsch**                                               | **Richtig**                                                                                                   |
|:---------------------------------------------------------|:--------------------------------------------------------------------------------------------------------------|
| Auditvorbereitung: „Wir suchen die Unterlagen zusammen.“ | Nachweiskatalog mit Ablageort und Aktualitätsgrenzen, monatlicher Lauf, Befunde werden vor dem Audit behoben. |

Im Projekt ist ein Mini-Audit im eigenen Haus der beste Test: Eine unbeteiligte Person bekommt eine Anforderung und soll in 15 Minuten das Dokument, die Freigabe und den Nachweis der Anwendung finden.

## 13.6 Aufbewahrung

Aufbewahrung beantwortet die Frage, *wie lange* ein Dokument oder ein Nachweis aufgehoben werden muss. Es gibt zwei gegenläufige Kräfte. Gesetze, Verträge und Normen verlangen, dass bestimmte Unterlagen mindestens für eine bestimmte Zeit aufbewahrt werden. Der Datenschutz verlangt, dass personenbezogene Daten nicht länger als nötig gespeichert werden. Eine gute Aufbewahrungsregelung findet für jede Dokumentart die Frist, die beides vereint: so lange wie nötig, so kurz wie möglich. Die Umsetzung der Löschung behandelt der Abschnitt „Aufbewahrung und Löschung“ weiter unten.

> **Ergänzung aus der Nachrecherche**
>
> Aufbewahrungsfristen in Deutschland (keine Rechtsberatung): Laut der abgerufenen Seite einer Industrie- und Handelskammer gilt für Bücher und Jahresabschlüsse eine Frist von 10 Jahren, für Buchungsbelege 8 Jahre (die Frist wurde ab 2025 von zehn auf acht Jahre verkürzt, und zwar für alle Belege, deren Frist zu Beginn des Jahres 2025 noch nicht abgelaufen war), und für übrige aufbewahrungspflichtige Geschäftsunterlagen 6 Jahre. Die Frist beginnt mit Ablauf des Kalenderjahres, in dem die letzte Eintragung, Änderung oder Handlung vorgenommen wurde; bei Handelsbriefen zählt der Empfang oder Versand, bei Verträgen das Vertragsende. Laufende Außenprüfungen oder Rechtsbehelfsverfahren können die Frist verlängern. Die Seite benennt die Rechtsgrundlagen nicht ausdrücklich; die Zuordnung der Fristen zu bestimmten Dokumentarten Ihrer Organisation klären Sie mit Steuerberatung oder Rechtsabteilung. Für Österreich oder andere Länder gelten eigene Regeln, die hier nicht abgerufen wurden. (Abruf 28.10.2026, siehe Quellenverzeichnis.)

Für technische Dokumentation sind die gesetzlichen Fristen nur ein Teil des Bildes. Weitere Vorgaben ergeben sich aus Verträgen (Gewährleistung, Wartungsverträge), aus Produktpflichten (Betriebsanleitungen, technische Unterlagen müssen für die Lebensdauer oder eine bestimmte Zeit nach dem Inverkehrbringen verfügbar sein), aus Normen und Zertifizierungen (Nachweise für Audits) und aus internen Anforderungen. Ein praktisches Hilfsmittel ist die *Aufbewahrungsmatrix*: Sie ordnet jeder Dokumentart eine Frist, einen Fristbeginn und die Quelle der Frist zu. Das folgende Beispiel berechnet daraus das Ende der Aufbewahrung nach der Regel „Fristbeginn mit Ablauf des Kalenderjahres“.

```text
art;jahre;quelle
buchungsbeleg;8;gesetzlich (Steuer/Handel)
geschaeftsbrief;6;gesetzlich (Steuer/Handel)
betriebsanleitung;10;Produktpflicht, intern festgelegt
audit_nachweis;3;Zertifizierung, intern festgelegt
```

```python
import csv, sys
from datetime import date

regeln = {z["art"]: z for z in csv.DictReader(open("matrix.csv", encoding="utf-8"), delimiter=";")}
art, letzte_handlung = sys.argv[1], date.fromisoformat(sys.argv[2])

jahre = int(regeln[art]["jahre"])
fristbeginn = date(letzte_handlung.year, 12, 31)          # Ablauf des Kalenderjahres
frist_ende = date(fristbeginn.year + jahre, 12, 31)
print(f"{art}: letzte Handlung {letzte_handlung}, Aufbewahrung bis {frist_ende}")
print(f"Quelle: {regeln[art]['quelle']}")
```

Das Skript liest die Matrix, bestimmt das Ende des Kalenderjahres der letzten Handlung als Fristbeginn und addiert die Jahre. Für einen Buchungsbeleg mit letzter Handlung am 10. März 2025 ergibt sich das Ende am 31. Dezember 2033: Das Jahr 2025 endet am 31. Dezember 2025, dann laufen acht Jahre. Die Quelle wird mit ausgegeben, damit nachvollziehbar bleibt, warum die Frist gilt. Zu beachten bleibt, dass dies eine vereinfachte Regel ist; Ausnahmen (Verlängerung durch Prüfungen, Sonderfristen) kennt das Skript nicht, und die Matrix selbst muss von fachkundiger Stelle bestätigt werden.

Typische Fehler: Eine einzige Frist für alles; Fristen ohne Quelle, sodass niemand sie begründen kann; Aufbewahrung ohne Löschung (alles wird ewig gesichert, was datenschutzrechtlich ein Problem sein kann); Löschung ohne Prüfung auf laufende Verfahren.

| **Falsch**                           | **Richtig**                                                                                                 |
|:-------------------------------------|:------------------------------------------------------------------------------------------------------------|
| „Wir bewahren alles zehn Jahre auf.“ | Matrix mit Dokumentarten, Fristen, Fristbeginn und Quelle, von Fachabteilung und Rechtsabteilung bestätigt. |

Im Projekt ist die erste Frage, die man stellen sollte: „Wer weiß, welche Fristen für uns gelten?“ Meist sitzt die Antwort in der Buchhaltung, der Rechtsabteilung oder beim Datenschutzbeauftragten, und Dokumentation sollte sie von dort übernehmen, nicht selbst erfinden.

## 13.7 Dokumentationsrisiken

Dokumentation ist nicht nur Schutzmaßnahme, sondern selbst eine Quelle von Risiken. Eine Risikobetrachtung der Dokumentation fragt: Was kann schiefgehen, wie wahrscheinlich ist es, und wie schlimm wäre es? Typische Risiken lassen sich in vier Gruppen ordnen. *Offenlegung*: Vertrauliche Inhalte (Geheimnisse, Netzpläne, Personendaten) gelangen zu Unberechtigten. *Falschheit*: Veraltete oder fehlerhafte Anleitungen führen zu Fehlbedienung, Ausfällen oder Sicherheitslücken. *Verlust*: Dokumentation geht verloren oder ist im Notfall nicht verfügbar (zum Beispiel liegt das Notfallhandbuch auf dem ausgefallenen System). *Nichtkonformität*: Vorgeschriebene Dokumentation fehlt oder wird nicht nachgewiesen.

Das Standardwerkzeug ist das *Risikoregister*. Jedes Risiko wird mit Eintrittswahrscheinlichkeit und Auswirkung bewertet, aus deren Produkt sich eine Priorität ergibt. Beide Größen werden auf einer einfachen Skala, etwa 1 bis 5, eingeschätzt; die Werte sind Schätzungen und dienen der Reihenfolge, nicht der Genauigkeit. Zu jedem Risiko gehören eine Maßnahme, ein Verantwortlicher und ein Prüftermin. Das folgende Beispiel zeigt ein kleines Register und ein Skript, das es nach Priorität ordnet und überfällige Maßnahmen meldet.

```text
risiko;wahrscheinlichkeit;auswirkung;massnahme;owner;termin
Passwort im Runbook;4;5;Secret-Scan in Pipeline;Team Plattform;2026-11-15
Notfallplan nur im Wiki;2;5;Offline-Kopie jährlich;Leitung Betrieb;2026-09-30
Veraltete Anleitung Backup;3;4;Review-Zyklus 6 Monate;Team Betrieb;2026-12-01
Fehlende Freigabenachweise;2;3;Freigabe in Plattform;Redaktion;2027-01-31
```

```python
import csv
from datetime import date

HEUTE = date(2026, 10, 28)
zeilen = list(csv.DictReader(open("register.csv", encoding="utf-8"), delimiter=";"))
for z in zeilen:
    z["prio"] = int(z["wahrscheinlichkeit"]) * int(z["auswirkung"])

for z in sorted(zeilen, key=lambda z: z["prio"], reverse=True):
    stufe = "HOCH" if z["prio"] >= 15 else "mittel" if z["prio"] >= 8 else "niedrig"
    ueberfaellig = " - Maßnahme ÜBERFÄLLIG" if date.fromisoformat(z["termin"]) < HEUTE else ""
    print(f"{z['prio']:2} {stufe:7} {z['risiko']} ({z['owner']}){ueberfaellig}")
```

Das Skript multipliziert Wahrscheinlichkeit und Auswirkung, ordnet die Risiken absteigend und teilt sie anhand zweier Schwellen (15 und 8, Beispielwerte) in Stufen ein. Außerdem prüft es, ob der Termin der Maßnahme überschritten ist. Mit den Beispieldaten steht „Passwort im Runbook“ mit Priorität 20 an der Spitze, gefolgt von der veralteten Backup-Anleitung (12) und dem Notfallplan (10). Beim Notfallplan zeigt das Skript zusätzlich, dass die Maßnahme überfällig ist: Er hat eine niedrigere Priorität, wäre aber im Ernstfall besonders folgenreich, und der Hinweis verhindert, dass er unter den mittleren Risiken untergeht.

Typische Fehler: Das Register wird einmal erstellt und nie fortgeschrieben; Risiken ohne Owner und Termin; Pseudogenauigkeit durch feine Zahlen, die niemand begründen kann; nur Risiken *durch* fehlende Dokumentation werden betrachtet, nicht Risiken *der* Dokumentation (Offenlegung).

| **Falsch**                                    | **Richtig**                                                                                                                                                                                |
|:----------------------------------------------|:-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Risiko: „Dokumentation könnte veraltet sein.“ | Risiko: „Anleitung Backup veraltet, Wiederherstellung schlägt im Ernstfall fehl; Wahrscheinlichkeit 3, Auswirkung 4; Maßnahme Review alle 6 Monate; Owner Team Betrieb; Termin 1.12.2026.“ |

Im Projekt genügt ein Register mit zehn bis zwanzig Einträgen, das vierteljährlich im Team besprochen wird. Ein umfangreicheres, das niemand liest, schützt nicht besser.

## 13.8 Security-Troubleshooting

Dieser Abschnitt zeigt, wie man typische Fehlerbilder rund um Sicherheit in Dokumenten anhand von Struktur, Aktualität, Zielgruppenfeedback und Review-Kommentaren eingrenzt und daraus Runbook-Schritte für Redaktion, Fachbereich und Betrieb ableitet.

Die häufigsten Symptome und ihre Ursachen: „Im Dokument stand ein Passwort“ deutet auf fehlende Vorabprüfung und fehlende Geheimnisverwaltung. „Ein vertrauliches Dokument war für alle sichtbar“ deutet auf falsche Ablage oder zu große Gruppen. „Wir wissen nicht, wer das gesehen hat“ deutet auf fehlende Zugriffsprotokolle. „Ein ehemaliger Mitarbeiter hat noch Zugriff“ deutet auf fehlende Rezertifizierung. „Das Dokument steht in einer Suchmaschine“ deutet auf eine versehentlich öffentliche Freigabe.

Für die Eingrenzung ist eine *kombinierte Prüfung* hilfreich, die mehrere Aspekte gleichzeitig betrachtet. Das folgende Skript verbindet drei Informationsquellen: die Klassifizierung der Dokumente, den Ablageort und die Fundstellen des Geheimnisscans. Es meldet Dokumente, bei denen mehrere Warnzeichen zusammentreffen, und stuft sie nach Schwere.

```text
titel;klasse;ablage;owner;geheimnis_funde
Betriebshandbuch;intern;intern;Team Betrieb;0
Netzplan;vertraulich;web;Team Betrieb;0
Runbook DB;intern;intern;;2
Altes Memo;;intern;;0
```

```python
import csv

OEFFENTLICH = {"web"}
for z in csv.DictReader(open("bestand.csv", encoding="utf-8"), delimiter=";"):
    punkte, gruende = 0, []
    if not z["klasse"]:
        punkte += 1; gruende.append("keine Klasse")
    if not z["owner"]:
        punkte += 1; gruende.append("kein Owner")
    if z["klasse"] in {"vertraulich", "streng_vertraulich"} and z["ablage"] in OEFFENTLICH:
        punkte += 5; gruende.append("vertraulich, aber öffentlich abgelegt")
    if int(z["geheimnis_funde"]) > 0:
        punkte += 4; gruende.append(f"{z['geheimnis_funde']} Geheimnis-Fund(e)")
    stufe = "KRITISCH" if punkte >= 5 else "Hinweis" if punkte else "ok"
    print(f"{stufe:9} {z['titel']}: {', '.join(gruende) or '-'}")
```

Das Skript vergibt für jedes Warnzeichen Punkte, wobei die schwerwiegenden (vertrauliches Dokument an öffentlichem Ort) deutlich mehr zählen als formale Mängel. Die Summe bestimmt die Stufe. Mit den Beispieldaten ist der Netzplan kritisch, weil er vertraulich ist, aber im Webbereich liegt. Das Runbook der Datenbank hat zwei Geheimnisfunde und keinen Owner und wird ebenfalls als kritisch ausgegeben (4 plus 1 Punkte), das alte Memo erhält einen Hinweis (2 Punkte: keine Klasse, kein Owner). Die Gewichte sind Beispielwerte, die zur Organisation passen müssen.

Als Runbook ergibt sich für einen kritischen Fund: Zugriff sofort einschränken oder Dokument aus dem öffentlichen Bereich nehmen; Geheimnisse rotieren; feststellen, wer Zugriff hatte (Protokolle); bewerten, ob Personendaten betroffen sind und ob Meldepflichten bestehen (Datenschutzbeauftragte einbeziehen); Ursache beheben (Prüfung in die Pipeline, Schulung); Vorfall dokumentieren. Bei möglichen Datenpannen sind Fristen zu beachten, die Datenschutzbeauftragte und Rechtsabteilung bewerten; das ist keine Aufgabe der Redaktion allein.

Typische Fehler: Man löscht das Dokument, aber rotiert das Geheimnis nicht; man dokumentiert den Vorfall nicht; man verlässt sich darauf, dass „es schon keiner gesehen hat“, statt es zu prüfen.

| **Falsch**                                                                      | **Richtig**                                                                                                                         |
|:--------------------------------------------------------------------------------|:------------------------------------------------------------------------------------------------------------------------------------|
| „Das Passwort steht seit einem Jahr im Wiki, aber es hat wohl niemand gesehen.“ | „Passwort rotiert, Zugriffsprotokoll ausgewertet (14 Lesezugriffe, alle intern), Scan in Pipeline aktiviert, Vorfall dokumentiert.“ |

Im Projekt sind die schnellsten Gegenmittel einfach: Scan vor Veröffentlichung, kleine Gruppen, klare Ablage und eine bekannte Meldestelle für Funde.

## 13.9 Compliance Anforderungen

Compliance bedeutet, Regeln einzuhalten, die von außen oder innen vorgegeben sind: Gesetze, Verordnungen, Normen, Verträge und interne Richtlinien. Für Dokumentation ergeben sich aus ihnen zwei Arten von Anforderungen. Manche Regeln verlangen, dass bestimmte Dokumente *existieren* (Betriebsanleitung, Verarbeitungsverzeichnis, Notfallkonzept). Andere schreiben vor, wie Dokumentation *beschaffen* sein muss (aktuell, freigegeben, nachvollziehbar, in einer bestimmten Sprache, zugänglich). Compliance in Dokumenten heißt, beides sicherzustellen und nachzuweisen.

> **Ergänzung aus der Nachrecherche**
>
> Beispiele für Compliance-Treiber (keine Rechtsberatung): Der abgerufene IHK-Leitfaden zur EU-Maschinenverordnung nennt als Geltungsbeginn den 20. Januar 2027 und behandelt die digitale Betriebsanleitung; ob und wie diese Verordnung für ein Produkt gilt, ist im Einzelfall zu klären. Die abgerufene Beschreibung zu ISO/IEC 27001, Abschnitt 7.5 (dokumentierte Information), nennt Anforderungen an das Erstellen und Aktualisieren, die Kennzeichnung, die Lenkung (Verfügbarkeit, Schutz, Zugriff, Änderungskontrolle, Aufbewahrung) dokumentierter Information. Die Norm IEC/IEEE 82079-1 regelt die Erstellung von Gebrauchsanleitungen; der Webshop der IEC wurde mit Titel und Anwendungsbereich abgerufen. Normtexte selbst wurden nicht eingesehen. (Abruf 28.10.2026, siehe Quellenverzeichnis.)

Das Handwerkszeug für diese Aufgabe ist die *Anforderungsmatrix* (Traceability-Matrix): Sie ordnet jede Anforderung den Dokumenten und Nachweisen zu, die sie erfüllen. Dadurch sieht man auf einen Blick, welche Anforderungen nicht belegt sind (Lücken) und welche Dokumente keine Anforderung erfüllen (möglicherweise überflüssig oder falsch zugeordnet). Das folgende Beispiel zeigt eine solche Zuordnung und ein Skript, das beide Richtungen prüft.

```text
anforderung;quelle;dokument
Dokumentierte Information lenken;ISO 27001 7.5;Dokumentenlenkung SOP-001
Verarbeitungsverzeichnis führen;DSGVO Art. 30;Verarbeitungsverzeichnis
Notfallkonzept vorhalten;intern;
Betriebsanleitung bereitstellen;Produktpflicht;Betriebsanleitung Shop
```

```text
titel
Dokumentenlenkung SOP-001
Verarbeitungsverzeichnis
Betriebsanleitung Shop
Betriebshandbuch DB
```

```python
import csv

anf = list(csv.DictReader(open("anforderungen.csv", encoding="utf-8"), delimiter=";"))
vorhanden = {z["titel"] for z in csv.DictReader(open("dokumente.csv", encoding="utf-8"))}
genutzt = {a["dokument"] for a in anf if a["dokument"]}

for a in anf:
    if not a["dokument"]:
        print(f"LÜCKE: {a['anforderung']} ({a['quelle']}) hat kein Dokument")
    elif a["dokument"] not in vorhanden:
        print(f"FEHLT: {a['dokument']} (für {a['anforderung']}) existiert nicht")
for d in sorted(vorhanden - genutzt):
    print(f"Ohne Anforderung: {d}")
```

Das Skript prüft drei Dinge: Anforderungen ohne zugeordnetes Dokument, zugeordnete Dokumente, die nicht existieren, und Dokumente, die keiner Anforderung dienen. Mit den Beispieldaten meldet es die Lücke beim Notfallkonzept und das Betriebshandbuch der Datenbank als Dokument ohne Anforderung. Letzteres ist keine Fehlermeldung, sondern eine Frage: Dient es einer Anforderung, die in der Matrix fehlt (etwa dem Betrieb), oder ist es überflüssig? Die Liste der vorhandenen Dokumente hat nur eine Spalte und wird deshalb ohne das Semikolon als Trennzeichen eingelesen.

Typische Fehler: Compliance wird als einmaliges Projekt behandelt, nicht als laufende Aufgabe; Anforderungen werden aus Quellen abgeleitet, die niemand benennt; Dokumente erfüllen formal die Anforderung, sind aber nicht gelebt; es gibt keine Verantwortlichen für die Beobachtung von Rechtsänderungen.

| **Falsch**                                      | **Richtig**                                                                      |
|:------------------------------------------------|:---------------------------------------------------------------------------------|
| „Wir sind compliant, wir haben ja Richtlinien.“ | Anforderungsmatrix mit Quelle, Dokument, Nachweis und Owner, im Quartal geprüft. |

Im Projekt lohnt es, Rechtsfragen nicht allein zu beantworten: Die Anforderungsmatrix wird mit Rechtsabteilung, Datenschutzbeauftragter und Informationssicherheitsbeauftragter abgestimmt.

## 13.10 DSGVO Bezug

Die Datenschutz-Grundverordnung (DSGVO) regelt die Verarbeitung personenbezogener Daten in der EU. Für Dokumentation hat sie zwei Seiten. Zum einen ist sie *Anforderung an Dokumentation*: Der Verantwortliche muss die Einhaltung nachweisen können, was ohne Dokumentation nicht gelingt (zum Beispiel Verarbeitungsverzeichnis, Konzepte für Löschung und technische Maßnahmen, Verträge mit Dienstleistern). Zum anderen ist sie *Einschränkung für Dokumentation*: Wer Personendaten dokumentiert, verarbeitet sie selbst und braucht dafür Grundlage, Zweck und Schutz. Dieser Abschnitt ist eine Einführung für Redaktion und Technik und *keine Rechtsberatung*; verbindliche Auskünfte geben Datenschutzbeauftragte und Rechtsabteilung.

> **Ergänzung aus der Nachrecherche**
>
> Grundsätze der DSGVO: Laut der abgerufenen Darstellung enthält Art. 5 sechs Grundsätze für die Verarbeitung: Rechtmäßigkeit, Treu und Glauben, Transparenz; Zweckbindung; Datenminimierung; Richtigkeit; Speicherbegrenzung; Integrität und Vertraulichkeit. Dazu kommt die Rechenschaftspflicht (Art. 5 Abs. 2): Der Verantwortliche muss die Einhaltung nicht nur sicherstellen, sondern auch nachweisen können, etwa durch geeignete Dokumentation sowie technische und organisatorische Maßnahmen. Zum Verarbeitungsverzeichnis nach Art. 30 wurde ein Glossareintrag eines Anbieters abgerufen; die Gesetzestexte selbst wurden nicht eingesehen. (Abruf 28.10.2026, siehe Quellenverzeichnis.)

Für die Praxis der Dokumentation lassen sich die Grundsätze in Fragen übersetzen. *Zweckbindung*: Wofür steht die Personenangabe im Dokument, und passt der Zweck? *Datenminimierung*: Reicht eine Funktionsadresse statt einer Privatnummer? *Richtigkeit*: Wer pflegt die Angaben? *Speicherbegrenzung*: Wann wird gelöscht? *Integrität und Vertraulichkeit*: Wer darf zugreifen, ist das Dokument geschützt? *Rechenschaft*: Können wir all das belegen? Ein besonders wichtiges Dokument ist das *Verzeichnis von Verarbeitungstätigkeiten* (Art. 30), das für jede Verarbeitung unter anderem Zweck, Kategorien betroffener Personen und Daten, Empfänger, Löschfristen und eine allgemeine Beschreibung der Sicherheitsmaßnahmen nennt. Für die Frage, ob eine Organisation es führen muss, und in welchem Umfang, sind die Gesetzestexte und die Beratung maßgeblich.

Das folgende Beispiel zeigt einen Eintrag des Verzeichnisses als YAML und ein Skript, das die genannten Angaben auf Vollständigkeit prüft. Die Pflichtfelder sind eine Arbeitshilfe, abgeleitet aus dem Glossareintrag, und ersetzen nicht die Prüfung des Gesetzestextes.

```text
- verarbeitung: Kundenverwaltung
  verantwortlicher: Muster GmbH
  zweck: Vertragsabwicklung und Support
  betroffene: [Kunden, Interessenten]
  datenarten: [Name, Anschrift, E-Mail, Bestellhistorie]
  empfaenger: [Zahlungsdienstleister, Versanddienstleister]
  drittland: nein
  loeschfrist: 6 Jahre nach Vertragsende, Rechnungen 8 Jahre
  massnahmen: Zugriff nach Rolle, Verschlüsselung, Protokollierung
- verarbeitung: Bewerberverwaltung
  verantwortlicher: Muster GmbH
  zweck: Besetzung offener Stellen
  betroffene: [Bewerber]
  datenarten: [Lebenslauf, Zeugnisse]
```

```python
import sys, yaml

PFLICHT = ["verantwortlicher", "zweck", "betroffene", "datenarten",
           "empfaenger", "drittland", "loeschfrist", "massnahmen"]
for v in yaml.safe_load(open(sys.argv[1], encoding="utf-8")):
    fehlt = [p for p in PFLICHT if not v.get(p)]
    print(f"{v['verarbeitung']}: " + ("es fehlt " + ", ".join(fehlt) if fehlt else "vollständig"))
```

Die Einträge beschreiben zwei Verarbeitungen. Das Skript prüft pro Eintrag, ob alle Pflichtangaben gefüllt sind. Mit den Beispieldaten ist die Kundenverwaltung vollständig, bei der Bewerberverwaltung fehlen Empfänger, Drittland, Löschfrist und Maßnahmen. Auch hier gilt: Vollständigkeit der Felder heißt nicht Richtigkeit der Inhalte. Die Angaben zu Löschfristen sind Beispielwerte und müssen aus der Aufbewahrungsmatrix des Unternehmens stammen.

Typische Fehler: Das Verzeichnis ist einmal erstellt und nie gepflegt; Dokumentation enthält Personendaten ohne Zweck und Löschfrist; man vergisst, dass auch Protokolle, Tickets und Screenshots Verarbeitungen sind; technische Dokumentation wird mit Dienstleistern geteilt, ohne zu prüfen, ob Personendaten enthalten sind.

| **Falsch**                                                                             | **Richtig**                                                                                            |
|:---------------------------------------------------------------------------------------|:-------------------------------------------------------------------------------------------------------|
| Verarbeitungsverzeichnis als vierzeilige Tabelle ohne Löschfristen und ohne Maßnahmen. | Eintrag pro Verarbeitung mit allen Pflichtangaben, Owner, Prüfdatum und Verweis auf die Löschregelung. |

Im Projekt ist es hilfreich, die Datenschutzbeauftragte früh einzubinden: Sie kennt die Vorgaben, und frühe Abstimmung ist deutlich billiger als nachträgliche Korrektur.

## 13.11 Berechtigungskonzept

Ein Berechtigungskonzept legt fest, wer auf welche Dokumente zu welchen Zwecken zugreifen darf, und wie diese Rechte vergeben, geändert und entzogen werden. Es setzt das Need-to-know-Prinzip (oben) in die Praxis um. Ohne Konzept entsteht ein Wildwuchs aus Einzelrechten, in dem niemand mehr weiß, wer was sieht. Ein dokumentiertes Konzept ist zudem eine Voraussetzung der Auditfähigkeit.

Bewährt hat sich das *rollenbasierte Modell* (Role-Based Access Control, RBAC). Rechte werden nicht Personen, sondern *Rollen* zugeordnet, und Personen erhalten Rollen. Ändert sich die Aufgabe einer Person, ändert sich ihre Rolle, nicht ein Dutzend Einzelrechte. Typische Rechtearten für Dokumente sind Lesen, Schreiben (Änderungen vorschlagen oder einreichen), Freigeben und Verwalten (Struktur, Rechte). Das Konzept legt außerdem fest, wer Rechte vergeben darf (Owner), wie Anträge laufen und wie oft die Zuordnung überprüft wird.

Wichtig ist die Beachtung der *Funktionstrennung*: Wer schreibt, soll nicht freigeben können, wer Rechte verwaltet, nicht zugleich Inhalte freigeben. Das folgende Beispiel hält Rollen und Zuordnung als Daten fest und prüft zwei Dinge: Welche Rechte hat jede Person tatsächlich, und verletzt eine Person die Funktionstrennung?

```yaml
rollen:
  leser:       [lesen]
  autor:       [lesen, schreiben]
  approver:    [lesen, freigeben]
  admin:       [lesen, verwalten]
personen:
  Anna:  [autor, approver]
  Bernd: [autor]
  Cora:  [approver]
  Dieter: [admin, approver, autor]
```

```python
import sys, yaml

d = yaml.safe_load(open(sys.argv[1], encoding="utf-8"))
UNVEREINBAR = [{"schreiben", "freigeben"}, {"verwalten", "freigeben"}]

for person, rollen in d["personen"].items():
    rechte = set()
    for r in rollen:
        rechte |= set(d["rollen"][r])
    konflikte = [sorted(u) for u in UNVEREINBAR if u <= rechte]
    text = ", ".join(sorted(rechte))
    if konflikte:
        text += "  -> KONFLIKT: " + "; ".join(" + ".join(k) for k in konflikte)
    print(f"{person}: {text}")
```

Das Skript bildet pro Person die Vereinigung der Rechte aller ihrer Rollen. Die Operation `|=` fügt Rechte zu einer Menge hinzu, der Vergleich `u <= rechte` prüft, ob alle Rechte einer unvereinbaren Kombination vorhanden sind. Mit den Beispieldaten haben Anna (Autor und Approver) und Dieter Konflikte: Anna kann schreiben und freigeben, Dieter außerdem verwalten und freigeben. Das heißt nicht, dass sie böswillig handeln, sondern dass die Organisation sie nicht gegen unbeabsichtigte Fehler schützt. Mögliche Lösung: Anna erhält nur eine der Rollen, oder Freigaben für ihre eigenen Dokumente übernimmt eine andere Person (siehe Vier-Augen-Prinzip in Modul 10).

Typische Fehler: Rechte werden direkt an Personen vergeben; Rollen sind so breit, dass sie keinen Schutz bieten; die Zuordnung wird nie überprüft; Berechtigungen werden bei Austritt nicht entzogen; Dienstkonten und technische Zugänge sind in keinem Konzept erfasst.

| **Falsch**                                                         | **Richtig**                                                                                                                                      |
|:-------------------------------------------------------------------|:-------------------------------------------------------------------------------------------------------------------------------------------------|
| Schreibrecht für „alle Mitarbeiter“ im Wiki, Freigabe durch jeden. | Rollen Leser, Autor, Approver und Admin, Funktionstrennung geprüft, Zuordnung halbjährlich rezertifiziert, Austritt entzieht Rechte automatisch. |

Im Projekt ist die Verbindung zum Personalprozess entscheidend: Eintritt, Wechsel und Austritt lösen automatisch Rechteänderungen aus, sonst veralten die Zuordnungen innerhalb weniger Monate.

## 13.12 Aufbewahrung und Löschung

Der Abschnitt zur Aufbewahrung hat gezeigt, wie lange Dokumente mindestens aufzuheben sind. Dieser Abschnitt behandelt die andere Seite: Wann und wie werden sie *gelöscht*, und wie lässt sich beides in Einklang bringen? Die Speicherbegrenzung ist ein Grundsatz des Datenschutzes: Personenbezogene Daten dürfen nicht länger gespeichert werden, als es der Zweck erfordert. Eine Organisation, die nie löscht, verstößt deshalb gegen den Grundsatz, ebenso eine, die zu früh löscht und damit Aufbewahrungspflichten verletzt.

> **Ergänzung aus der Nachrecherche**
>
> Recht auf Löschung (Art. 17 DSGVO, keine Rechtsberatung): Laut dem abgerufenen Beitrag besteht die Pflicht zur Löschung unter anderem, wenn die Daten für ihren Zweck nicht mehr benötigt werden, eine Einwilligung widerrufen wurde und keine andere Rechtsgrundlage besteht, die Daten unrechtmäßig verarbeitet wurden oder eine Rechtspflicht zur Löschung besteht. Der Verantwortliche muss selbst tätig werden; ein Antrag ist nicht Voraussetzung. Ausnahmen (Art. 17 Abs. 3) bestehen unter anderem, soweit die Verarbeitung zur Erfüllung einer rechtlichen Verpflichtung oder zur Geltendmachung, Ausübung oder Verteidigung von Rechtsansprüchen erforderlich ist. Als Beispiele gesetzlicher Aufbewahrungspflichten nennt der Beitrag § 147 AO und § 257 HGB. Werden Daten nur noch wegen einer Aufbewahrungspflicht gespeichert, empfiehlt der Beitrag eine Einschränkung der Verarbeitung (Sperrung) mit Zugriff nur für wenige benannte Personen. Die Ausnahme gilt nur, solange ihr Zweck besteht, danach lebt der Löschanspruch wieder auf. (Abruf 28.10.2026, siehe Quellenverzeichnis.)

Daraus ergibt sich ein dreistufiges Verfahren. In der *aktiven Phase* ist das Dokument im Gebrauch. Läuft der Zweck aus, beginnt die *gesperrte Phase*: Das Dokument wird nur noch aufbewahrt, weil eine Pflicht es verlangt; der Zugriff wird auf wenige Personen beschränkt. Mit Ablauf der Frist folgt die *Löschung*. Zwei Sonderfälle sind zu beachten. Bei einem *Legal Hold* (Sperre wegen laufender oder drohender Verfahren) darf nicht gelöscht werden, bis die Sperre aufgehoben ist. Und Löschung muss *vollständig* sein: auch Kopien, Sicherungen, Suchindizes und die Versionsgeschichte sind zu bedenken.

Das folgende Beispiel zeigt einen Löschlauf, der zunächst nur berichtet (Trockenlauf) und erst mit ausdrücklichem Schalter löscht. Es berücksichtigt das Fristende und den Legal Hold und schreibt ein Löschprotokoll ohne Inhalte.

```text
datei;frist_ende;legal_hold
a.txt;2026-01-31;nein
b.txt;2026-06-30;ja
c.txt;2030-12-31;nein
```

```python
import csv, sys, time
from datetime import date
from pathlib import Path

HEUTE = date(2026, 10, 28)
echt = "--loeschen" in sys.argv

for z in csv.DictReader(open("register.csv", encoding="utf-8"), delimiter=";"):
    ende = date.fromisoformat(z["frist_ende"])
    datei = Path(z["datei"])
    if ende >= HEUTE:
        print(f"{z['datei']}: Frist läuft bis {ende}")
    elif z["legal_hold"] == "ja":
        print(f"{z['datei']}: Frist abgelaufen, aber LEGAL HOLD - nicht löschen")
    else:
        aktion = "gelöscht" if echt else "würde gelöscht"
        if echt and datei.exists():
            datei.unlink()
        print(f"{z['datei']}: {aktion}")
        if echt:
            with open("loeschprotokoll.txt", "a", encoding="utf-8") as p:
                p.write(f"{time.strftime('%Y-%m-%d')};{z['datei']};Frist {ende}\n")
```

Das Skript geht durch das Löschregister. Läuft die Frist noch, passiert nichts. Ist sie abgelaufen und besteht ein Legal Hold, wird gemeldet und nicht gelöscht. Andernfalls wird gelöscht, aber nur, wenn der Schalter `--loeschen` angegeben wurde; ohne ihn zeigt das Skript lediglich, was geschehen würde. Das Protokoll hält Datum, Dateiname und Grund fest, nicht den Inhalt. Mit den Beispieldaten würde `a.txt` gelöscht, `b.txt` wegen des Legal Holds nicht, und `c.txt` läuft noch bis 2030. Der Trockenlauf ist ein zentrales Sicherheitsmuster für unumkehrbare Aktionen.

Typische Fehler: Löschung nur in einem System, aber nicht in Sicherungen und Kopien; Löschung ohne Prüfung auf Verfahren oder Prüfungen; keine Protokollierung, sodass der Nachweis fehlt; die Versionsgeschichte eines Repositorys enthält die gelöschte Datei weiter, ohne dass jemand daran denkt.

| **Falsch**                                                                                   | **Richtig**                                                                                                 |
|:---------------------------------------------------------------------------------------------|:------------------------------------------------------------------------------------------------------------|
| Datei wird aus dem Wiki gelöscht, die Kopie im Backup und im E-Mail-Archiv bleibt unbemerkt. | Löschkonzept benennt alle Speicherorte, Fristen für Sicherungen, Verantwortliche und Nachweis der Löschung. |

Im Projekt gehört zu jedem Löschkonzept die Frage der Versionsgeschichte. Wer Personendaten in ein Git-Repository eingecheckt hat, muss klären, wie sie dort entfernt werden; das ist aufwendig und ein weiterer Grund, solche Daten gar nicht erst zu dokumentieren.

## 13.13 Security by Documentation

Der Begriff meint zwei zusammenhängende Gedanken. Erstens: *Sicherheit wird auch durch Dokumentation erreicht.* Wer Sicherheitsmaßnahmen, Konfigurationen und Verfahren sauber dokumentiert, macht sie wiederholbar, prüfbar und weniger abhängig von einzelnen Personen. Zweitens: *Dokumentation selbst muss sicher sein.* Sie darf keine unnötigen Angriffsflächen schaffen. Beides zusammen führt zu der Frage, wie viel Detail dokumentiert wird und für wen.

Zur Sicherheitsdokumentation gehören typischerweise: das Sicherheitskonzept (Schutzbedarf, Bedrohungen, Maßnahmen), Härtungsanleitungen (Konfiguration von Systemen nach Sicherheitsvorgaben), Notfall- und Vorfallpläne, Zuständigkeiten und Meldewege, sowie die Dokumentation von Berechtigungen und Schlüsselverwaltung. Dabei gilt das Prinzip *Transparenz nach innen, Zurückhaltung nach außen*: Intern müssen Verantwortliche genau wissen, was gilt. Nach außen wird nur offengelegt, was nötig ist; eine Detailbeschreibung der Verteidigung eines Systems ist für Angreifer wertvoller als für Kunden. Wichtig ist, nicht auf „Sicherheit durch Geheimhaltung“ zu setzen: Ein System sollte auch dann sicher sein, wenn seine Funktionsweise bekannt ist. Die Dokumentation bleibt aber trotzdem vertraulich, weil sie unnötig hilft.

Auch normale Betriebsdokumentation hat Sicherheitsaspekte. Eine Anleitung, die zur Fehlerbehebung `chmod 777` empfiehlt, einen Befehl als Administrator ohne Begründung verlangt oder ein heruntergeladenes Skript ungeprüft ausführt, wirkt als Risikoverstärker, weil Leser Beispiele kopieren. Das folgende Beispiel prüft Dokumentation auf solche riskanten Muster und verlangt in Runbooks Hinweise zu erforderlichen Rechten und zum Rückfall.

```python
import re, sys
from pathlib import Path

RISIKO = {
    "chmod 777": "Rechte zu weit geöffnet",
    r"curl[^|\n]*\|\s*(sudo\s+)?(ba)?sh": "Skript aus dem Netz ungeprüft ausgeführt",
    r"rm\s+-rf\s+/(\s|$)": "Löschen des Wurzelverzeichnisses",
    r"--insecure|\s-k\s": "Zertifikatsprüfung abgeschaltet",
    r"sudo\s+su\b": "Dauerhafte Administratorsitzung",
}
PFLICHT = ["Benötigte Rechte", "Rückfall"]

for datei in sorted(Path(sys.argv[1]).glob("*.md")):
    text = datei.read_text(encoding="utf-8")
    for muster, warnung in RISIKO.items():
        for m in re.finditer(muster, text):
            nr = text[:m.start()].count("\n") + 1
            print(f"{datei.name}:{nr}: {warnung}")
    if "Schritte" in text:
        for p in PFLICHT:
            if p not in text:
                print(f"{datei.name}: Abschnitt '{p}' fehlt")
```

Das Skript sucht fünf riskante Muster mit regulären Ausdrücken, berechnet aus der Position der Fundstelle die Zeilennummer (Anzahl der Zeilenumbrüche davor plus eins) und prüft, ob Dokumente mit Handlungsschritten die Abschnitte „Benötigte Rechte“ und „Rückfall“ enthalten. Die Muster sind ein Ausgangspunkt, den jede Organisation für ihre Umgebung erweitert. Dass ein Befund auftritt, heißt nicht, dass der Befehl nie vorkommen darf: Eine Anleitung zum Aufräumen eines Testsystems kann ihn legitim enthalten, dann aber mit Warnhinweis und Begründung.

Typische Fehler: Dokumentation zeigt unsichere Abkürzungen, die später in der Produktion landen; Sicherheitskonzepte existieren, aber die Umsetzung weicht ab; Details der Verteidigung werden breit verteilt; Dokumentation vertraut auf Verborgenheit.

| **Falsch**                                | **Richtig**                                                                                                                                        |
|:------------------------------------------|:---------------------------------------------------------------------------------------------------------------------------------------------------|
| „Falls es Rechteprobleme gibt: `chmod -R 777 /var/app`.“ | „Prüfen Sie Besitzer und Gruppe mit `ls -l`. Setzen Sie das Recht 750 für das Verzeichnis und fordern Sie zusätzliche Rechte über den Antrag an.“ |

Im Projekt hilft es, Beispiele in Anleitungen *sicher als Vorgabe* zu schreiben: Die Anleitung ist die Vorlage, nach der Menschen arbeiten, also soll sie zeigen, wie es richtig geht.

## 13.14 Vertraulichkeit

Vertraulichkeit ist neben Integrität und Verfügbarkeit eines der drei klassischen Schutzziele der Informationssicherheit: Informationen sollen nur Befugten zugänglich sein. Die Klassifizierung (oben) legt den Schutzbedarf fest, das Berechtigungskonzept regelt den Zugriff. Dieser Abschnitt behandelt, wie Vertraulichkeit im *Umgang* mit Dokumenten gewahrt wird, besonders bei Weitergabe, Veröffentlichung und beim Zusammenarbeiten mit Externen.

Drei Situationen kommen in der Praxis häufig vor. Erstens die *Weitergabe an Dritte*: Kunden, Dienstleister oder Behörden erhalten Dokumentation. Hier ist zu klären, was sie sehen dürfen, ob eine Vertraulichkeitsvereinbarung besteht und ob eine bereinigte Fassung genügt. Zweitens die *Veröffentlichung*: Dokumente für das Web sind bewusst öffentlich, sollten aber geprüft werden, ob versehentlich interne Angaben (Hostnamen, interne Adressen, Namen von Mitarbeitenden) enthalten sind. Drittens die *Werkzeugkette*: Metadaten in Dateien (Autor, Pfade, Änderungsverläufe, Kommentare, versteckte Textebenen in Office-Dokumenten und PDF) geben oft mehr preis, als man sieht.

Die übliche Maßnahme für die Weitergabe ist die *Bereinigung* (Redaktion, englisch Redaction): Vertrauliche Angaben werden entfernt oder durch Platzhalter ersetzt, bevor das Dokument das Haus verlässt. Das folgende Beispiel ersetzt IP-Adressen, interne Hostnamen und E-Mail-Adressen nach einer Liste und gibt einen Bericht aus, was ersetzt wurde. Ein Bericht ist wichtig, weil man sonst nicht weiß, ob die Bereinigung etwas bewirkt hat.

```python
import re, sys
from collections import Counter

REGELN = [
    (re.compile(r"\b(?:10|192\.168|172\.(?:1[6-9]|2\d|3[01]))(?:\.\d{1,3}){2,3}\b"), "[interne-IP]"),
    (re.compile(r"\b[\w-]+\.intern\.example\.org\b"), "[interner-Host]"),
    (re.compile(r"\b[\w.+-]+@example\.org\b"), "[E-Mail]"),
]

text = open(sys.argv[1], encoding="utf-8").read()
bericht = Counter()
for muster, ersatz in REGELN:
    text, n = muster.subn(ersatz, text)
    if n:
        bericht[ersatz] = n

open(sys.argv[2], "w", encoding="utf-8").write(text)
for ersatz, n in bericht.items():
    print(f"{n} x {ersatz}")
print("Bereinigt:", sum(bericht.values()), "Ersetzung(en)")
```

Das Skript definiert drei Ersetzungsregeln: private IPv4-Adressen der bekannten Bereiche, interne Hostnamen der fiktiven Domäne `intern.example.org` und Adressen der Beispielfirma. Mit `subn` ersetzt es und zählt gleichzeitig die Treffer, schreibt die bereinigte Fassung in eine neue Datei (das Original bleibt unverändert) und gibt den Bericht aus. Der Ausdruck für die IP-Adressen deckt die privaten Bereiche 10.x, 192.168.x und 172.16 bis 172.31 ab. Eine Bereinigung nach Mustern ist nie vollständig; Namen von Personen, Projektnamen oder Hinweise im Fließtext erkennt sie nicht. Deshalb ist ein menschliches Review der bereinigten Fassung unverzichtbar.

Typische Fehler: Bereinigung durch Überdecken (schwarzer Balken in einem PDF, unter dem der Text weiter vorhanden ist); Metadaten bleiben unbemerkt; die bereinigte Fassung wird aus dem Original abgeleitet, aber das Original geht versehentlich mit; die Vertraulichkeitsstufe wird beim Weiterleiten nicht beachtet.

| **Falsch**                                                                       | **Richtig**                                                                                                                                                     |
|:---------------------------------------------------------------------------------|:----------------------------------------------------------------------------------------------------------------------------------------------------------------|
| PDF mit schwarzen Rechtecken über Namen, die sich markieren und kopieren lassen. | Bereinigte Fassung aus der Quelle neu erzeugt (Text ersetzt, Metadaten entfernt), Prüfung durch eine zweite Person, Weitergabe mit Hinweis auf Vertraulichkeit. |

Im Projekt ist ein fester Freigabeschritt für externe Weitergaben sinnvoll: Nichts verlässt das Haus ohne Prüfung durch den Owner und, bei Bedarf, die Informationssicherheit.

## 13.15 Compliance-Troubleshooting

Dieser Abschnitt zeigt, wie man typische Fehlerbilder bei Compliance-Anforderungen an Dokumentation anhand von Struktur, Aktualität, Zielgruppenfeedback und Review-Kommentaren eingrenzt und daraus Runbook-Schritte für Redaktion, Fachbereich und Betrieb ableitet. Rechtliche Bewertungen bleiben bei den zuständigen Stellen, dies ist keine Rechtsberatung.

Die häufigsten Symptome: „Im Audit fehlte ein Nachweis“ deutet auf fehlenden Nachweiskatalog oder fehlende Aufbewahrung. „Wir wussten nicht, dass das gefordert war“ deutet auf eine fehlende Anforderungsmatrix. „Das Dokument existiert, aber niemand arbeitet danach“ deutet auf einen Papiertiger. „Frist verpasst oder zu früh gelöscht“ deutet auf eine unklare Aufbewahrungsmatrix. „Zwei Abteilungen haben unterschiedliche Fristen“ deutet auf fehlende zentrale Regelung. „Eine Änderung der Rechtslage wurde übersehen“ deutet auf eine fehlende Beobachtungsverantwortung.

Zur Eingrenzung dient ein Gesamtbild: Wie viele Dokumente haben Owner, Klasse, Aufbewahrungsfrist und Prüfdatum? Das folgende Skript verdichtet einen Dokumentenbestand zu einem Compliance-Überblick nach Lücken-Kategorie. Es zeigt, wo die größten Defizite liegen, und erleichtert die Priorisierung der Maßnahmen.

```text
titel;owner;klasse;frist;geprueft
Betriebshandbuch;Team Betrieb;intern;6;2026-09-01
Notfallplan;Team Betrieb;vertraulich;;2025-03-01
Zugangskonzept;;streng_vertraulich;3;2026-02-01
Preisliste;Vertrieb;oeffentlich;6;2024-11-01
Richtlinie Backup;Leitung IT;;6;2026-06-01
```

```python
import csv
from datetime import date

HEUTE = date(2026, 10, 28)
zeilen = list(csv.DictReader(open("bestand.csv", encoding="utf-8"), delimiter=";"))
pruefungen = {
    "ohne Owner": lambda z: not z["owner"],
    "ohne Klasse": lambda z: not z["klasse"],
    "ohne Aufbewahrungsfrist": lambda z: not z["frist"],
    "Prüfung älter als 12 Monate": lambda z: (HEUTE - date.fromisoformat(z["geprueft"])).days > 365,
}

for name, regel in pruefungen.items():
    treffer = [z["titel"] for z in zeilen if regel(z)]
    print(f"{name}: {len(treffer)} von {len(zeilen)}" + (f" ({', '.join(treffer)})" if treffer else ""))

problematisch = {z["titel"] for z in zeilen if any(r(z) for r in pruefungen.values())}
print(f"Dokumente mit mindestens einem Mangel: {len(problematisch)} von {len(zeilen)}")
```

Die Prüfungen sind als Wörterbuch von Namen auf kleine Funktionen (`lambda`) abgelegt. Das hat zwei Vorteile: Neue Regeln lassen sich in einer Zeile ergänzen, und die Ausgabe wird automatisch erzeugt. Mit den Beispieldaten betrifft jede Regel ein bis zwei Dokumente; vier von fünf Dokumenten haben mindestens einen Mangel, nur das Betriebshandbuch ist frei von Befunden. Die letzte Ausgabezeile fasst das zusammen. Das Datum ist fest eingetragen, damit das Beispiel reproduzierbar ist.

Als Runbook ergibt sich: Gesamtbild erstellen; die kritischsten Lücken (fehlende Aufbewahrungsfrist, fehlende Klasse bei sensiblen Dokumenten) zuerst schließen; offene Rechtsfragen an die zuständigen Stellen geben; Nachweise ergänzen; die Anforderungsmatrix aktualisieren; die Prüfungen in die regelmäßigen Abläufe aufnehmen; Wirkung im nächsten Quartal messen.

Typische Fehler: Man bearbeitet Befunde einzeln, ohne die Ursachen (fehlende Regeln) zu beheben; man trifft rechtliche Entscheidungen in der Redaktion; man wartet auf das nächste Audit, statt kontinuierlich zu prüfen.

| **Falsch**                                                  | **Richtig**                                                                                        |
|:------------------------------------------------------------|:---------------------------------------------------------------------------------------------------|
| „Wir bereiten uns im Dezember auf das Audit im Januar vor.“ | Monatlicher Compliance-Überblick, Maßnahmenliste mit Owner und Termin, Nachweise laufend gepflegt. |

Im Projekt ist Compliance leichter, wenn sie in den Alltag eingebaut ist: Wer beim Anlegen eines Dokuments gleich Owner, Klasse und Frist festlegen muss, erzeugt diese Lücken gar nicht erst.

## Übungsaufgaben

Die Aufgaben steigen von Verständnisfragen (1 bis 3) über Anwendungsaufgaben (4 bis 5) bis zu Programmier- und Transferaufgaben (6 bis 8) an. Rechtliche Fragen sind als Lernübung zu verstehen und keine Rechtsberatung.

**Aufgabe 1.** *(leicht)* Nennen Sie die sechs Grundsätze nach Art. 5 DSGVO in eigenen Worten und geben Sie für zwei davon ein Beispiel aus der Dokumentation.

**Aufgabe 2.** *(leicht)* Warum ist es nicht ausreichend, ein Passwort aus einem Dokument zu löschen, nachdem es veröffentlicht wurde? Was muss zusätzlich geschehen?

**Aufgabe 3.** *(leicht bis mittel)* Worin unterscheiden sich Need-to-know-Prinzip und Klassifizierung? Erklären Sie an einem Beispiel, wie beide zusammenwirken.

**Aufgabe 4.** *(mittel)* Entwerfen Sie ein Klassifizierungsschema mit vier Stufen und geben Sie je Stufe an: zulässige Ablage, Weitergabe per E-Mail erlaubt oder nicht, Verschlüsselung erforderlich oder nicht.

**Aufgabe 5.** *(mittel)* Berechnen Sie: Ein Buchungsbeleg wurde zuletzt am 15.11.2026 bearbeitet. Bis wann ist er nach der in diesem Modul beschriebenen vereinfachten Regel (8 Jahre ab Ablauf des Kalenderjahres) aufzubewahren? Wie ändert sich das Ergebnis für einen Geschäftsbrief (6 Jahre)?

**Aufgabe 6.** *(mittel, praktisch)* Erweitern Sie den Geheimnisscanner um ein Muster für GitHub-ähnliche Token der Form `ghp_` gefolgt von mindestens 30 Buchstaben oder Ziffern, und testen Sie es mit einer Beispieldatei.

**Aufgabe 7.** *(anspruchsvoll, praktisch)* Schreiben Sie ein Skript, das eine CSV-Datei mit den Spalten person, rolle und austritt einliest und alle Personen meldet, deren Austrittsdatum in der Vergangenheit liegt, die aber noch in der Rollenzuordnung stehen.

**Aufgabe 8.** *(anspruchsvoll, Transfer)* Ein Unternehmen stellt fest, dass ein Betriebshandbuch mit Zugangsdaten zwei Jahre lang in einem für alle Mitarbeiter lesbaren Wiki lag. Skizzieren Sie das Vorgehen (Sofortmaßnahmen, Bewertung, Ursachenbehebung, Dokumentation) und nennen Sie, welche Stellen einzubinden sind.

## Lösungen und Erläuterungen

**Lösung zu Aufgabe 1.** Die Grundsätze: (1) Rechtmäßigkeit, Treu und Glauben, Transparenz (es braucht eine Rechtsgrundlage, die Verarbeitung ist redlich und nachvollziehbar); (2) Zweckbindung (Daten werden nur für festgelegte Zwecke verwendet); (3) Datenminimierung (nur, was nötig ist); (4) Richtigkeit (Daten sind korrekt und aktuell); (5) Speicherbegrenzung (nicht länger als nötig); (6) Integrität und Vertraulichkeit (Schutz vor unbefugtem Zugriff, Verlust, Zerstörung). Beispiele: Datenminimierung: In der Bereitschaftsliste steht die Funktionsadresse statt der privaten Handynummer. Speicherbegrenzung: Eine Ansprechpartnerliste eines beendeten Projekts wird nach Projektende gelöscht oder archiviert mit begrenztem Zugriff.

**Lösung zu Aufgabe 2.** Ein veröffentlichtes Geheimnis gilt als kompromittiert: Es kann kopiert, gespeichert, indexiert oder in der Versionsgeschichte bewahrt worden sein. Das Löschen aus der aktuellen Fassung schließt diese Spuren nicht. Zusätzlich muss das Geheimnis *rotiert* (ausgetauscht), die Gültigkeit des alten beendet, der Zugriff geprüft (wer hat das Dokument gesehen?) und die Ursache behoben werden (Scan, Schulung, Geheimnisspeicher).

**Lösung zu Aufgabe 3.** Die Klassifizierung legt den Schutzbedarf einer Information fest (zum Beispiel vertraulich). Need-to-know begrenzt, wer innerhalb des zulässigen Kreises tatsächlich zugreift: nur wer die Information für die Aufgabe braucht. Beispiel: Ein Netzplan ist vertraulich (Klassifizierung); Zugriff haben nicht alle, die vertrauliche Dokumente lesen dürften, sondern nur das Betriebsteam und die Sicherheit (Need-to-know). Die Klassifizierung begrenzt den Kreis grob, Need-to-know fein.

**Lösung zu Aufgabe 4.** Ein mögliches Schema: *öffentlich*: Ablage Webbereich oder intern, Weitergabe per E-Mail erlaubt, keine Verschlüsselung nötig. *intern*: Ablage interne Bereiche, E-Mail nur intern, Verschlüsselung auf Transportebene vorausgesetzt. *vertraulich*: Ablage nur im geschützten Bereich, Weitergabe nur mit Genehmigung des Owners und verschlüsselt, Zugriff nach Need-to-know. *streng vertraulich*: kleiner benannter Kreis, keine Weitergabe per E-Mail, Verschlüsselung der Ablage, Zugriffsprotokollierung. Wichtig ist, dass jede Stufe eine überprüfbare Regel enthält. Die konkreten Festlegungen sind Sache der Organisation.

**Lösung zu Aufgabe 5.** Das Kalenderjahr der letzten Bearbeitung ist 2026, die Frist beginnt mit dessen Ablauf am 31.12.2026. Nach 8 Jahren endet sie am 31.12.2034. Für den Geschäftsbrief mit 6 Jahren endet sie am 31.12.2032. Sie können es mit dem Skript prüfen: `python3 frist.py buchungsbeleg 2026-11-15`. Beachten Sie die Einschränkung aus dem Text: Die Regel ist vereinfacht, Sonderfälle (Außenprüfung, Verträge) erfordern fachliche Klärung.

**Lösung zu Aufgabe 6.** Eine mögliche Ergänzung im Dictionary `MUSTER`:

```text
    "Token mit Praefix ghp_": re.compile(r"\bghp_[A-Za-z0-9]{30,}\b"),
```

Testdatei: eine Zeile `Token: ghp_` gefolgt von 36 beliebigen Buchstaben oder Ziffern, ohne Platzhalterwort. Das Skript meldet sie; eine Zeile mit `<TOKEN>` oder dem Wort „beispiel“ wird durch die Platzhalter-Ausnahme übergangen. Beachten Sie, dass ein so gefundenes Token nicht echt sein muss, aber wie ein echtes behandelt werden sollte, bis das Gegenteil bewiesen ist.

**Lösung zu Aufgabe 7.** Eine mögliche Lösung:

```python
import csv, sys
from datetime import date

HEUTE = date.today()
for z in csv.DictReader(open(sys.argv[1], encoding="utf-8"), delimiter=";"):
    if z["austritt"] and date.fromisoformat(z["austritt"]) < HEUTE and z["rolle"]:
        print(f"{z['person']}: ausgetreten am {z['austritt']}, Rolle '{z['rolle']}' noch zugeordnet")
```

Das Skript meldet Personen mit Austrittsdatum in der Vergangenheit und noch eingetragener Rolle. Leere Austrittsdaten (aktive Mitarbeitende) werden übersprungen. In einer echten Umgebung würde man die Rollenliste aus dem Berechtigungssystem und die Austritte aus dem Personalsystem beziehen und den Abgleich regelmäßig automatisch durchführen.

**Lösung zu Aufgabe 8.** Sofortmaßnahmen: Zugriff auf das Dokument sperren, Zugangsdaten rotieren und alte Zugänge deaktivieren. Bewertung: Wer hatte Zugriff, wurde das Dokument gelesen (Zugriffsprotokolle des Wikis auswerten, auch Suchindex und Kopien beachten), wurden die Zugangsdaten missbraucht (Protokolle der betroffenen Systeme prüfen), sind Personendaten betroffen? Falls ja oder unklar, sind Datenschutzbeauftragte und Rechtsabteilung zu informieren, damit sie über Melde- und Informationspflichten entscheiden (Fristen können kurz sein). Ursachenbehebung: Geheimnisspeicher einführen, Scan vor der Veröffentlichung, Dokumentationsrichtlinie (keine Geheimnisse), kleinere Lesegruppen, Schulung. Dokumentation: Vorfall mit Zeitverlauf, Bewertung und Maßnahmen festhalten, Lehren in Review-Checkliste und Pipeline übernehmen. Einzubindende Stellen: Betriebs- und Plattformteam (Rotation), Informationssicherheit, Datenschutzbeauftragte, Rechtsabteilung, Dokumentenowner, gegebenenfalls Geschäftsleitung. Die rechtliche Bewertung (Meldepflicht) obliegt den zuständigen Stellen, nicht der Redaktion.
