# Modul 06 - Datenschutz, Cybersecurity und AI-Tech-Regulierung

> **Hinweis zu diesem Kapitel:** Das ist das Kapitel des Skripts „Unternehmensgründung“, aus der LaTeX-Quelle in Markdown umgewandelt (Text und Codeblöcke unverändert, farbige Boxen als Zitatblöcke mit fettem Titel, Tabellen als Markdown-Tabellen). Die Lerneinheiten sind wie in der Quelle nach Modul nummeriert (6.1 bis 6.9), danach folgen „Übungsaufgaben zu Modul 06“ (8 Aufgaben, mit Schwierigkeitsangabe) und „Lösungen zu den Übungsaufgaben Modul 06“. Rechtliche und steuerliche Aussagen sind keine Rechtsberatung. Was ich an den Beispielen geprüft habe, steht in der [README des Repositories](../README.md). Übersicht zum Modul: [README](README.md).

**Dauer:** 10 h laut Modulübersicht (Summe der Einzelwerte: 9 × 1,1 h = 9,9 h, gerundet)

**Priorität:** 1 (höchste)

| **Nr.** | **Lerneinheit**                | **Dauer (h)** |
|--------:|:-------------------------------|--------------:|
|     6.1 | DSGVO Grundlagen               |           1,1 |
|     6.2 | Privacy-by-Design              |           1,1 |
|     6.3 | Security-by-Design             |           1,1 |
|     6.4 | Identity und Access Management |           1,1 |
|     6.5 | Secure Development Lifecycle   |           1,1 |
|     6.6 | Cloud Security Baseline        |           1,1 |
|     6.7 | AI und Datenrisiken            |           1,1 |
|     6.8 | Compliance Readiness           |           1,1 |
|     6.9 | Security Incident Handling     |           1,1 |
|         | **Summe**                      |       **9,9** |

Technikfirmen verarbeiten Daten anderer Menschen und Unternehmen. Dafür gelten Regeln, die in der EU strenger und zahlreicher sind als in vielen anderen Regionen: die Datenschutz-Grundverordnung (DSGVO), Vorgaben zur Cybersicherheit (NIS2, Cyber Resilience Act) und die KI-Verordnung (AI Act). Dieses Modul erklärt, was diese Regeln verlangen, und vor allem, wie man sie *in die Technik und in die Arbeitsweise einbaut*, statt sie nachträglich aufzupfropfen. **Alle rechtlichen Aussagen sind allgemeine Information und keine Rechtsberatung.** Gerade bei diesen Themen ändern sich Fristen und Auslegung laufend; der Stand der Nachrecherche ist der 1. November 2026. Die Programme sind lauffähig mit Python 3 ohne Zusatzpakete; Zahlen und Namen sind Beispiele, die Schlüsselwerte nur Platzhalter.

## 6.1 DSGVO Grundlagen

Die *Datenschutz-Grundverordnung* (DSGVO, englisch GDPR) regelt in der gesamten EU, wie *personenbezogene Daten* verarbeitet werden dürfen. Personenbezogen ist jede Information, die sich auf eine identifizierte oder identifizierbare Person bezieht: Name, E-Mail-Adresse, aber auch IP-Adresse, Kennung eines Geräts oder Standortdaten. *Verarbeitung* ist praktisch jeder Umgang damit: erheben, speichern, ändern, übermitteln, löschen. Das Grundprinzip lautet: Verarbeitung ist verboten, außer es gibt eine Rechtsgrundlage und die Grundsätze sind eingehalten (Rechtmäßigkeit, Zweckbindung, Datenminimierung, Richtigkeit, Speicherbegrenzung, Integrität und Vertraulichkeit sowie Rechenschaftspflicht).

Zuerst ist zu klären, in welcher *Rolle* man auftritt. Der *Verantwortliche* entscheidet über Zwecke und Mittel der Verarbeitung; ein Unternehmen ist es für die Daten seiner Mitarbeitenden und, bei eigenen Zwecken, für Kundendaten. Der *Auftragsverarbeiter* verarbeitet Daten im Auftrag und nach Weisung eines anderen. Ein SaaS-Anbieter ist für die Daten, die Kunden in sein System eingeben, meist Auftragsverarbeiter; für die eigenen Kundenkonten und Abrechnungsdaten ist er Verantwortlicher. Beide Rollen haben unterschiedliche Pflichten, und zwischen ihnen braucht es einen Vertrag, die *Auftragsverarbeitungsvereinbarung* (AVV, englisch DPA; vertieft in Modul 11).

Als *Rechtsgrundlagen* kommen vor allem in Betracht: Einwilligung der betroffenen Person, Erfüllung eines Vertrags, rechtliche Verpflichtung und berechtigtes Interesse (mit Interessenabwägung). Wer sich auf berechtigte Interessen stützt, muss die Abwägung dokumentieren. Betroffene haben *Rechte*: auf Auskunft, Berichtigung, Löschung, Einschränkung, Datenübertragbarkeit und Widerspruch. Anfragen sind grundsätzlich ohne unangemessene Verzögerung zu beantworten, in der Regel binnen eines Monats (allgemeines Fachwissen, im Einzelfall prüfen). Das *Verzeichnis von Verarbeitungstätigkeiten* (VVT, englisch RoPA) listet alle Verarbeitungen mit Zweck, Datenarten, Grundlage, Speicherdauer und Empfängern.

> **Ergänzung aus der Nachrecherche**
>
> Bei einer Verletzung des Schutzes personenbezogener Daten (Datenpanne) muss der Verantwortliche sie der Datenschutzbehörde melden, sobald er sie festgestellt hat; die Frist beträgt 72 Stunden. Verspätungen sind zu begründen. Keine Meldung ist nötig, wenn voraussichtlich kein Risiko für die Betroffenen besteht; im Zweifel kann vorsorglich gemeldet werden. Alle Verletzungen müssen intern dokumentiert werden, auch wenn sie nicht gemeldet werden. Auftragsverarbeiter melden unverzüglich an den Verantwortlichen. Bei hohem Risiko sind zusätzlich die Betroffenen zu benachrichtigen (Quelle Q11, WKO; keine Rechtsberatung).

Das Beispiel prüft ein Verarbeitungsverzeichnis automatisch auf typische Lücken: fehlende Rechtsgrundlage, fehlende Speicherdauer und fehlende Auftragsverarbeitungsvereinbarung bei eingesetzten Dienstleistern.

```python
GRUNDLAGEN = {"einwilligung", "vertrag", "rechtliche_pflicht", "berechtigtes_interesse"}

vvt = [
    {"name": "Kundenkonten", "zweck": "Vertragserfuellung", "grundlage": "vertrag",
     "daten": ["Name", "E-Mail"], "dauer_monate": 36, "dienstleister": None},
    {"name": "Newsletter", "zweck": "Marketing", "grundlage": "",
     "daten": ["E-Mail"], "dauer_monate": 12, "dienstleister": "MailTool"},
    {"name": "Server-Logs", "zweck": "Betrieb und Sicherheit", "grundlage": "berechtigtes_interesse",
     "daten": ["IP-Adresse"], "dauer_monate": None, "dienstleister": None},
    {"name": "Support-Tickets", "zweck": "Kundensupport", "grundlage": "vertrag",
     "daten": ["Name", "E-Mail", "Freitext"], "dauer_monate": 24, "dienstleister": "TicketTool"},
]
avv_vorhanden = {"TicketTool"}

for v in vvt:
    luecken = []
    if v["grundlage"] not in GRUNDLAGEN:
        luecken.append("keine gueltige Rechtsgrundlage")
    if v["dauer_monate"] is None:
        luecken.append("Speicherdauer fehlt")
    if v["dienstleister"] and v["dienstleister"] not in avv_vorhanden:
        luecken.append(f"AVV mit {v['dienstleister']} fehlt")
    print(f"{v['name']:16s}", "OK" if not luecken else "; ".join(luecken))
```

Jede Verarbeitung ist ein Wörterbuch mit den Pflichtangaben. Die Prüfung sammelt für jede Zeile die Lücken in einer Liste: Eine leere oder unbekannte Rechtsgrundlage fällt durch die Prüfung `not in GRUNDLAGEN`, `None` bei der Speicherdauer markiert fehlende Fristen, und für Dienstleister wird geprüft, ob eine Vereinbarung vorliegt. Die Ausgabe zeigt, dass die Kundenkonten und die Support-Tickets in Ordnung sind, der Newsletter dagegen ohne Rechtsgrundlage (typischerweise fehlt hier die Einwilligung) und ohne Vereinbarung mit dem Dienstleister läuft, und dass bei den Server-Logs die Speicherdauer fehlt. Auf dieselbe Weise lassen sich VVT-Tabellen in Audits prüfen.

Typische Fehler: Daten auf Vorrat sammeln („könnte nützlich sein“), pauschal auf „berechtigtes Interesse“ verweisen, ohne abzuwägen, Dienstleister ohne Vereinbarung einsetzen und Betroffenenanfragen nicht innerhalb der Frist beantworten. Falsch: Eine Einwilligung durch ein vorangekreuztes Kästchen. Richtig: eine freiwillige, informierte, eindeutige Einwilligung, die so leicht widerrufbar ist, wie sie erteilt wurde. Zu den Pflichten gehört auch, Datenschutzhinweise verständlich bereitzustellen, und bei bestimmten Fällen eine Datenschutz-Folgenabschätzung durchzuführen.

> **Merke**
>
> Personenbezogene Daten dürfen nur mit Rechtsgrundlage und nach den Grundsätzen der DSGVO verarbeitet werden. Rollen (Verantwortlicher oder Auftragsverarbeiter) bestimmen die Pflichten. Das Verarbeitungsverzeichnis ist das Rückgrat der Nachweispflicht. Datenpannen sind innerhalb von 72 Stunden zu melden.

> **Praxisbeispiel**
>
> Kundenfragebögen (englisch *security questionnaires*) verlangen früh: Datenschutzerklärung, VVT, Liste der Unterauftragsverarbeiter, AVV-Muster und Ansprechperson. Wer das bereit hat, verkürzt Verkaufszyklen (Modul 12, Enterprise Readiness).

## 6.2 Privacy-by-Design

*Privacy-by-Design* (Datenschutz durch Technikgestaltung) bedeutet, dass Datenschutz von Anfang an in Architektur und Produktanforderungen eingebaut wird, statt später mit Texten nachgereicht zu werden. Die DSGVO verlangt es ausdrücklich, zusammen mit *datenschutzfreundlichen Voreinstellungen* (Privacy by Default): Standardmäßig wird nur verarbeitet, was für den Zweck nötig ist. Drei Hebel stehen im Vordergrund. *Datenminimierung*: nur Daten erheben, die für den Zweck wirklich gebraucht werden. *Zweckbindung*: Daten nur für den Zweck nutzen, für den sie erhoben wurden. *Löschkonzept*: Für jede Datenart ist festgelegt, wann sie gelöscht oder anonymisiert wird, und die Löschung läuft automatisch.

Hilfreich ist die *Pseudonymisierung*: Direkte Kennungen (E-Mail-Adresse) werden durch ein Kennzeichen ersetzt, das ohne zusätzliche, getrennt aufbewahrte Information (den Schlüssel) nicht auf die Person zurückführbar ist. Pseudonymisierte Daten sind weiterhin personenbezogen, aber das Risiko sinkt. Von der *Anonymisierung* spricht man, wenn kein Personenbezug mehr herstellbar ist; dann fällt die Information aus der DSGVO heraus, was in der Praxis schwer zu belegen ist, weil Kombinationen von Merkmalen Personen wieder erkennbar machen können.

Das Beispiel zeigt drei Bausteine: Pseudonymisierung mit einem Schlüssel-Hash (HMAC), eine Datenminimierung nach Zweck und eine automatische Löschung nach Aufbewahrungsfrist in einer Datenbank.

```python
import hashlib, hmac, sqlite3
from datetime import date, timedelta

SCHLUESSEL = b"nur-demo-in-echt-aus-dem-Geheimnis-Dienst-laden"

def pseudonym(email):
    return hmac.new(SCHLUESSEL, email.strip().lower().encode(), hashlib.sha256).hexdigest()[:16]

ERLAUBT = {"statistik": {"land", "plan"}, "support": {"name", "email", "land"}}
def minimiere(datensatz, zweck):
    return {k: v for k, v in datensatz.items() if k in ERLAUBT[zweck]}

kunde = {"name": "Eva Muster", "email": "Eva@Example.at", "land": "AT", "plan": "pro"}
print("Pseudonym:", pseudonym(kunde["email"]))
print("Statistik:", minimiere(kunde, "statistik"))

db = sqlite3.connect(":memory:")
db.execute("CREATE TABLE ereignis (id INTEGER PRIMARY KEY, nutzer TEXT, erstellt TEXT)")
heute = date(2026, 11, 1)
for i, alter_tage in enumerate((5, 40, 100, 200), 1):
    db.execute("INSERT INTO ereignis VALUES (?, ?, ?)",
               (i, pseudonym(f"user{i}@example.at"), (heute - timedelta(days=alter_tage)).isoformat()))
grenze = (heute - timedelta(days=90)).isoformat()
geloescht = db.execute("DELETE FROM ereignis WHERE erstellt < ?", (grenze,)).rowcount
rest = db.execute("SELECT COUNT(*) FROM ereignis").fetchone()[0]
print(f"Loeschlauf: {geloescht} geloescht, {rest} verbleiben (Frist 90 Tage)")
```

Die Funktion `pseudonym` bildet mit einem geheimen Schlüssel einen Hash der normalisierten E-Mail-Adresse; gleiche Eingaben ergeben dasselbe Pseudonym, sodass Auswertungen möglich bleiben, ohne die Adresse zu kennen. Ohne den Schlüssel lassen sich Pseudonyme nicht einfach durch Probieren umkehren, was bei einem ungeschützten Hash ohne Schlüssel möglich wäre. `minimiere` gibt für den Zweck „Statistik“ nur Land und Tarif weiter. Der Löschlauf löscht Ereignisse, die älter als 90 Tage sind: Von vier Einträgen (5, 40, 100 und 200 Tage alt) werden zwei gelöscht, zwei bleiben. Im Betrieb läuft so ein Löschjob regelmäßig, und sein Ergebnis wird protokolliert.

Typische Fehler: Einen Hash ohne Schlüssel (oder mit einem im Code abgelegten Schlüssel) für „anonym“ halten, Löschfristen nur auf dem Papier festlegen und Daten aus Backups und Protokollen vergessen. Falsch: „Wir speichern nur die gehashte E-Mail, also ist es anonym.“ Richtig: Es bleibt personenbezogen, solange jemand die Zuordnung herstellen kann; also schützen und nur zweckgebunden nutzen. Außerdem sollte man bei neuen Funktionen eine kurze Datenschutzprüfung in den Anforderungsprozess einbauen (Modul 04): Welche Daten, welcher Zweck, welche Löschfrist?

> **Merke**
>
> Datenschutz wird in Anforderungen und Architektur eingebaut: Datenminimierung, Zweckbindung, sichere Voreinstellungen und ein automatisches Löschkonzept. Pseudonymisierte Daten bleiben personenbezogen; Anonymisierung ist schwer zu belegen.

> **Praxisbeispiel**
>
> Ein häufiger Auslöser für Aufwand sind Testdaten: Produktionsdaten in Testumgebungen zu kopieren, ist heikel. Besser sind synthetische oder pseudonymisierte Daten. Auch bei Analysewerkzeugen lohnt der Blick, welche Kennungen sie weitergeben.

## 6.3 Security-by-Design

*Security-by-Design* heißt, Sicherheit als Eigenschaft des Entwurfs zu behandeln. Statt ein fertiges System zu „härten“, fragt man schon beim Entwurf: Was könnte schiefgehen, wer könnte es ausnutzen, und wie begrenzen wir den Schaden? Zentral ist das *Bedrohungsmodell* (englisch *threat model*): Man zeichnet das System auf, markiert Vertrauensgrenzen (wo wechseln Daten zwischen Bereichen mit unterschiedlichem Schutz?) und sucht systematisch nach Bedrohungen. Eine verbreitete Gedächtnisstütze ist *STRIDE*: *Spoofing* (Identität vortäuschen), *Tampering* (Daten verändern), *Repudiation* (Handlung abstreiten), *Information Disclosure* (Daten offenlegen), *Denial of Service* (Dienst lahmlegen) und *Elevation of Privilege* (Rechte ausweiten).

Aus dem Schutzbedarf (Wie schlimm wäre der Verlust von Vertraulichkeit, Integrität oder Verfügbarkeit?) leiten sich *Kontrollen* ab. Zwei Grundsätze gelten fast immer: *sichere Voreinstellungen* (secure defaults) und *Least Privilege* (jede Person und jeder Dienst erhält nur die Rechte, die er braucht). Dazu kommt *Defense in Depth*: mehrere Schutzschichten, sodass der Ausfall einer einzelnen nicht alles öffnet. Passwörter werden nie im Klartext gespeichert, sondern mit einem dafür gedachten, absichtlich langsamen Verfahren (zum Beispiel scrypt, bcrypt oder Argon2) und einem zufälligen Zusatz (*Salt*) gehasht.

```python
import hashlib, hmac, os

def hash_passwort(passwort, salt=None):
    salt = salt or os.urandom(16)
    h = hashlib.scrypt(passwort.encode(), salt=salt, n=2**14, r=8, p=1)
    return salt, h

def pruefe(passwort, salt, erwartet):
    _, h = hash_passwort(passwort, salt)
    return hmac.compare_digest(h, erwartet)

salt, gespeichert = hash_passwort("korrekt-pferd-batterie-heftklammer")
print("richtig:", pruefe("korrekt-pferd-batterie-heftklammer", salt, gespeichert))
print("falsch :", pruefe("123456", salt, gespeichert))

bedrohungen = [
    ("S", "Login", "Gestohlene Zugangsdaten", 4, "MFA, Anmeldeversuche begrenzen"),
    ("T", "API", "Manipulierte Anfragen", 3, "Eingaben validieren, Signaturen"),
    ("I", "Datenbank", "Mandantenleck", 5, "Mandantenfilter zentral erzwingen"),
    ("D", "Upload", "Riesige Dateien", 2, "Groessenlimit, Ratenbegrenzung"),
]
for kuerzel, ort, text, schaden, kontrolle in sorted(bedrohungen, key=lambda b: -b[3]):
    print(f"[{kuerzel}] Risiko {schaden} {ort}: {text} -> {kontrolle}")
```

Die Funktion `hash_passwort` erzeugt einen zufälligen Salt und berechnet mit `scrypt` einen Hash; die Parameter `n`, `r` und `p` bestimmen den Rechenaufwand, der Angreifer ausbremst. `pruefe` berechnet den Hash der Eingabe mit demselben Salt und vergleicht mit `hmac.compare_digest`, einem Vergleich in konstanter Zeit, der keine Rückschlüsse aus der Rechendauer erlaubt. Das richtige Passwort liefert `True`, das falsche `False`. Der zweite Teil ist ein kleines Bedrohungsmodell als Tabelle, nach Schaden absteigend sortiert: Das Mandantenleck (Schaden 5) steht oben, danach gestohlene Zugangsdaten (4). Genau diese Reihenfolge entscheidet, wo Entwicklungszeit zuerst hinfließt.

Typische Fehler: Eigene Verschlüsselungs- oder Hash-Verfahren erfinden, Sicherheit als letzte Aufgabe vor dem Release einplanen und Bedrohungen nur technisch statt auch organisatorisch betrachten (Phishing, interne Fehler). Falsch: `hashlib.md5(passwort)` als Passwort-Speicherung, weil es „schon verschlüsselt“ aussieht. Richtig: ein bewährtes, langsames Verfahren mit Salt aus einer geprüften Bibliothek. Weitere Grundsatzfehler: Sicherheit durch Geheimhaltung des Verfahrens („Security by Obscurity“) und fehlende Prüfung auf der Serverseite, wenn die Oberfläche etwas „verbietet“.

> **Merke**
>
> Bedrohungsmodelle (zum Beispiel mit STRIDE) machen Risiken früh sichtbar. Sichere Voreinstellungen, Least Privilege und Defense in Depth sind Grundprinzipien. Passwörter werden mit langsamen, gesalzenen Verfahren gehasht, Vergleiche in konstanter Zeit durchgeführt.

> **Praxisbeispiel**
>
> Ein Bedrohungsmodell entsteht in einem Workshop von ein bis zwei Stunden mit einem Architekturbild und den Daten, die fließen. Das Ergebnis wandert als Anforderungen ins Backlog (Modul 04) und dient Kunden und Auditoren als Nachweis.

## 6.4 Identity und Access Management

*Identity and Access Management* (IAM) regelt, wer (Identität) auf was zugreifen darf (Zugriff). Es besteht aus drei Fragen: *Authentifizierung* (wer bist du? Passwort, Schlüssel, Gerät), *Autorisierung* (was darfst du?) und *Auditierung* (was hast du getan?). Die Authentifizierung wird durch *Multi-Faktor-Authentifizierung* (MFA) wesentlich sicherer: Zusätzlich zum Passwort wird ein zweiter Faktor verlangt, etwa ein Code aus einer App oder ein Hardware-Schlüssel. Gestohlene Passwörter allein genügen Angreifern dann nicht mehr.

Zur Autorisierung nutzt man häufig *rollenbasierte Zugriffskontrolle* (RBAC): Rechte werden an Rollen vergeben (Support, Entwickler, Administrator), und Personen erhalten Rollen. Das folgt dem Prinzip der minimalen Rechte, vereinfacht Prüfungen und die Rechtevergabe beim Eintritt. Besonders schutzbedürftig sind *Administrationszugriffe* und *Service Accounts* (technische Konten, mit denen Programme sich anmelden). Service Accounts sollten einzelne, eng begrenzte Rechte haben, ihre Schlüssel regelmäßig erneuern und nie von Menschen für den Alltag genutzt werden.

Der Lebenszyklus ist ebenso wichtig wie die Rechtevergabe: *Joiner*, *Mover*, *Leaver*. Beim Eintritt bekommt man die nötigen Rechte, beim Wechsel der Rolle werden alte entzogen, beim Austritt wird alles gesperrt. Das Beispiel prüft ein Benutzerverzeichnis gegen die Personalliste auf verwaiste Konten, fehlende MFA und zu viele Administratoren.

```python
rollen = {
    "admin":      {"lesen", "schreiben", "loeschen", "benutzer_verwalten"},
    "entwickler": {"lesen", "schreiben"},
    "support":    {"lesen"},
}
benutzer = {"anna": "admin", "ben": "entwickler", "cleo": "support", "dave": "admin"}
mfa = {"anna": True, "ben": False, "cleo": True, "dave": True}
hr_aktiv = {"anna", "ben", "cleo"}          # laut Personalliste

def darf(name, recht):
    return recht in rollen.get(benutzer.get(name, ""), set())

print("cleo darf schreiben?", darf("cleo", "schreiben"))
print("ben darf schreiben? ", darf("ben", "schreiben"))

for name in benutzer:
    if name not in hr_aktiv:
        print(f"VERWAIST: {name} ist nicht mehr aktiv, hat aber Rolle {benutzer[name]}")
    if not mfa[name]:
        print(f"OHNE MFA: {name}")
admins = [n for n, r in benutzer.items() if r == "admin" and n in hr_aktiv]
print("Aktive Administratoren:", admins)
```

Die Funktion `darf` schlägt die Rolle der Person nach und prüft, ob das gewünschte Recht darin enthalten ist; unbekannte Personen erhalten über die leere Menge keine Rechte (ein sicherer Standard). Danach läuft ein einfacher Abgleich: Dave steht noch als Administrator im System, obwohl er laut Personalliste nicht mehr aktiv ist, und Ben hat keine MFA. Das sind genau die Funde, die bei Prüfungen auffallen. Außerdem zeigt die letzte Zeile, dass nur noch eine Person (Anna) aktive Administratorin ist, was ein Verfügbarkeitsrisiko darstellt: Fällt sie aus, kann niemand Benutzer verwalten.

Typische Fehler: Geteilte Konten („admin“ für alle), nie widerrufene Zugänge von Ehemaligen oder Dienstleistern, dauerhafte Admin-Rechte für Alltagsarbeit, Service-Account-Schlüssel im Code. Falsch: Alle Entwickelnden haben Produktions-Administratorrechte, weil es bequem ist. Richtig: Alltagsarbeit mit normalen Rechten, Administratorrechte zeitlich begrenzt und protokolliert, regelmäßige Rechteprüfung (etwa vierteljährlich) und ein Offboarding-Ablauf, der am letzten Arbeitstag alle Zugänge sperrt, einschließlich Cloud-Konsole, Code-Plattform und SaaS-Werkzeuge.

> **Merke**
>
> IAM besteht aus Authentifizierung, Autorisierung und Auditierung. MFA, Rollen mit minimalen Rechten und ein sauberer Joiner-Mover-Leaver-Prozess verhindern die häufigsten Zugriffsvorfälle. Service Accounts sind besonders zu schützen.

> **Praxisbeispiel**
>
> Prüfer und Kunden verlangen Nachweise zu Rechtevergabe und Offboarding. Eine vierteljährliche, dokumentierte Rechteprüfung mit Unterschrift der Verantwortlichen erfüllt viele Anforderungen und lässt sich leicht mit einem Skript wie oben vorbereiten.

## 6.5 Secure Development Lifecycle

Der *Secure Development Lifecycle* (SDL oder Secure SDLC) baut Sicherheitsaktivitäten in jede Phase der Softwareentwicklung ein. Der Grundgedanke: Je früher ein Fehler gefunden wird, desto billiger ist seine Behebung (*Shift Left*, „nach links schieben“). Typische Bausteine sind: Sicherheitsanforderungen und Bedrohungsmodell im Entwurf (Lerneinheit 6.3), sichere Programmierrichtlinien und Reviews (Modul 05), automatische Prüfungen in der Pipeline und Sicherheitstests vor Release.

Die automatischen Prüfungen haben vier Hauptarten. *SAST* (Static Application Security Testing) analysiert den Quellcode auf Muster unsicherer Programmierung. *DAST* (Dynamic Application Security Testing) greift die laufende Anwendung von außen an. *SCA* (Software Composition Analysis, im Alltag *Dependency Scan*) prüft die verwendeten Bibliotheken auf bekannte Schwachstellen. Ein *Secret Scan* sucht nach versehentlich eingecheckten Zugangsdaten. Neue Werkzeuge liefern viele Meldungen; deshalb werden Schwachstellen *priorisiert* nach Schweregrad, Ausnutzbarkeit und Betroffenheit der eigenen Anwendung und mit Fristen behoben (zum Beispiel kritisch innerhalb von sieben Tagen; die Fristen legt jedes Team selbst fest).

```python
import re

muster = {
    "AWS-Schluessel":     r"AKIA[0-9A-Z]{16}",
    "Privater Schluessel": r"-----BEGIN [A-Z ]*PRIVATE KEY-----",
    "Passwort im Code":   r"(?i)(passwort|password|secret)\s*=\s*['\"][^'\"]{6,}['\"]",
}
beispielcode = '''
db_host = "db.intern"
PASSWORD = "SuperGeheim99"
aws_key = "AKIAABCDEFGHIJKLMNOP"   # Demo-Wert
token = os.environ["API_TOKEN"]
'''
for zeilennr, zeile in enumerate(beispielcode.splitlines(), 1):
    for name, m in muster.items():
        if re.search(m, zeile):
            print(f"Zeile {zeilennr}: moeglicher Fund ({name})")

def version(text):
    return tuple(int(t) for t in text.split("."))

schwachstellen = {"libbild": ("2.4.3", "kritisch"), "webkit-x": ("1.9.0", "mittel")}
eingesetzt = {"libbild": "2.4.0", "webkit-x": "1.9.2", "jsonparser": "3.0.1"}
for name, v in eingesetzt.items():
    if name in schwachstellen and version(v) < version(schwachstellen[name][0]):
        print(f"{name} {v}: betroffen, aktualisieren auf {schwachstellen[name][0]} ({schwachstellen[name][1]})")
```

Der Secret Scan durchsucht jede Zeile mit regulären Ausdrücken. Die Zeile mit `PASSWORD` trifft das dritte Muster, die mit dem Demo-Schlüssel das erste; die Zeile, die das Token aus einer Umgebungsvariablen liest, bleibt unauffällig, weil dort kein Wert im Code steht. Der Abhängigkeits-Scan vergleicht Versionen als Zahlenfolgen: `libbild` 2.4.0 liegt unter der behobenen Version 2.4.3 und wird als kritisch gemeldet, die Bibliothek `webkit-x` 1.9.2 ist bereits neuer als die behobene Version 1.9.0, und `jsonparser` kommt nicht in der Liste vor. Echte Werkzeuge nutzen gepflegte Datenbanken bekannter Schwachstellen, das Prinzip ist aber dasselbe.

Typische Fehler: Werkzeuge einführen, aber Meldungen ignorieren, jede Meldung als gleich dringend behandeln (dann kippt das Team in Ignoranz) und Geheimnisse nach versehentlichem Einchecken nur aus dem Code löschen, ohne sie zu erneuern. Falsch: „Der Schlüssel steht nur in einem alten Commit.“ Richtig: Als offengelegt behandeln, sofort tauschen, Zugriff prüfen und den Vorfall dokumentieren. Hilfreich ist ein dokumentiertes *Software-Stücklisten-Verzeichnis* (SBOM), das alle Komponenten und Versionen auflistet; es wird zunehmend von Kunden und Regulierung verlangt (siehe Lerneinheit 6.9, Cyber Resilience Act).

> **Merke**
>
> Sicherheit wird in jede Phase der Entwicklung eingebaut und in der Pipeline automatisiert: SAST, DAST, Dependency- und Secret-Scan. Schwachstellen werden priorisiert und mit Fristen behoben. Offengelegte Geheimnisse werden getauscht, nicht nur gelöscht.

> **Praxisbeispiel**
>
> Kundenfragebögen fragen regelmäßig nach Dependency-Scans, Penetrationstests und Behebungsfristen. Ein jährlicher unabhängiger Penetrationstest (Test durch beauftragte Angreifer) ergänzt die automatischen Prüfungen, besonders vor Großkunden-Verträgen.

## 6.6 Cloud Security Baseline

Eine *Cloud Security Baseline* ist ein Mindeststandard für die Konfiguration von Cloud-Umgebungen. Er ist nötig, weil die meisten Cloud-Vorfälle nicht durch ausgefeilte Angriffe entstehen, sondern durch *Fehlkonfigurationen*: ein öffentlich lesbarer Speicher, eine offene Datenbank, ein vergessener Testzugang. Dahinter steht das *Modell der geteilten Verantwortung* (shared responsibility): Der Anbieter schützt die Rechenzentren und die Basis-Infrastruktur, der Kunde ist für Konfiguration, Zugriffsrechte, Daten und Anwendungen verantwortlich.

Die Baseline besteht aus wenigen Bereichen. *Netzwerk*: Datenbanken und interne Dienste sind nicht aus dem Internet erreichbar, nur notwendige Ports sind offen, Verwaltungszugänge laufen über abgesicherte Wege. *Verschlüsselung*: Daten werden bei der Übertragung (TLS) und im Ruhezustand verschlüsselt. *Backup*: regelmäßig, getrennt vom Produktionssystem und mit Wiederherstellungstests. *Logging*: Aktivitäten in der Verwaltungsoberfläche und im Zugriff auf Daten werden protokolliert und manipulationsgeschützt aufbewahrt. *Identitäten*: MFA, keine geteilten Konten, Rechte minimal. Wer das als Programmcode (*Infrastructure as Code*) beschreibt, kann Abweichungen automatisch erkennen.

```python
ressourcen = [
    {"typ": "speicher",  "name": "kunden-export", "oeffentlich": True,  "verschluesselt": True,  "backup": True},
    {"typ": "datenbank", "name": "prod-db",       "oeffentlich": False, "verschluesselt": False, "backup": True},
    {"typ": "datenbank", "name": "test-db",       "oeffentlich": True,  "verschluesselt": True,  "backup": False},
    {"typ": "firewall",  "name": "fw-1",          "offene_ports": [22, 443, 5432]},
]
GEFAEHRLICH = {22: "SSH", 3389: "RDP", 5432: "PostgreSQL", 3306: "MySQL"}

for r in ressourcen:
    funde = []
    if r["typ"] in ("speicher", "datenbank"):
        if r["oeffentlich"]:
            funde.append("oeffentlich erreichbar")
        if not r["verschluesselt"]:
            funde.append("nicht verschluesselt")
        if r["typ"] == "datenbank" and not r["backup"]:
            funde.append("kein Backup")
    if r["typ"] == "firewall":
        for port in r["offene_ports"]:
            if port in GEFAEHRLICH:
                funde.append(f"Port {port} ({GEFAEHRLICH[port]}) offen")
    print(f"{r['name']:14s}", "OK" if not funde else "; ".join(funde))
```

Das Programm prüft jede Ressource gegen einfache Regeln der Baseline. Der Speicher `kunden-export` ist öffentlich erreichbar, was bei Kundendaten ein schwerer Befund ist; die Produktionsdatenbank ist unverschlüsselt; die Testdatenbank ist öffentlich und ohne Backup; die Firewall lässt SSH und PostgreSQL aus dem Internet zu. Das sind typische Funde aus echten Audits. Die Prüfung ist bewusst einfach; Cloud-Anbieter bieten dafür eigene Werkzeuge (Konfigurationsprüfer, Sicherheitsberichte), die man in die Pipeline einbinden kann.

Typische Fehler: „Nur kurz zum Testen“ geöffnete Zugänge, die bleiben; fehlende Trennung von Entwicklungs-, Test- und Produktionskonten; nie getestete Backups; Protokolle, die niemand liest. Falsch: Die Produktionsdatenbank hat eine öffentliche Adresse, weil der Entwickler von zu Hause zugreifen wollte. Richtig: Zugriff über einen abgesicherten Zugangsweg (VPN oder Bastion-Host mit MFA), und Zugänge sind zeitlich begrenzt. Zusätzlich beachten: Datenstandort und Auftragsverarbeiter-Verträge mit dem Cloud-Anbieter (Lerneinheit 6.1 und Modul 11).

> **Merke**
>
> Die meisten Cloud-Vorfälle sind Fehlkonfigurationen. Eine Baseline fordert abgeschottete Netze, Verschlüsselung, getestete Backups, Logging und saubere Identitäten. Konfiguration als Code macht Abweichungen automatisch sichtbar.

> **Praxisbeispiel**
>
> Bei Kundenaudits und bei Zertifizierungen (zum Beispiel nach ISO 27001) legt man Nachweise für diese Kontrollen vor: Screenshots oder Berichte der Konfigurationsprüfung, Backup-Protokolle, Wiederherstellungstests. Das lohnt sich zu automatisieren (siehe Lerneinheit 6.8).

## 6.7 AI und Datenrisiken

Die *KI-Verordnung* (englisch *AI Act*) regelt in der EU Entwicklung und Einsatz von Systemen künstlicher Intelligenz nach einem risikobasierten Ansatz. Die Idee: Je größer das Risiko für Grundrechte, Gesundheit und Sicherheit, desto strenger die Regeln. Man unterscheidet vereinfacht vier Stufen. *Verbotene Praktiken* (zum Beispiel bestimmte Formen von Social Scoring oder manipulativen Techniken) sind untersagt. *Hochrisiko-Systeme* (etwa KI in der Personalauswahl, bei Kreditwürdigkeitsprüfung oder in Sicherheitskomponenten regulierter Produkte) unterliegen umfangreichen Pflichten wie Risikomanagement, Datenqualität, Dokumentation, menschliche Aufsicht und Konformitätsbewertung. Für Systeme mit *Transparenzpflichten* (zum Beispiel Chatbots oder KI-erzeugte Inhalte) gilt, dass Nutzer informiert werden müssen. Für *minimales Risiko* gibt es keine besonderen Pflichten. Für KI-Modelle mit allgemeinem Verwendungszweck (GPAI) gibt es gesonderte Regeln.

> **Ergänzung aus der Nachrecherche**
>
> Laut einer Analyse von Gibson Dunn (Mai 2026) wurde am 6. Mai 2026 eine vorläufige politische Einigung zum „Digital Omnibus on AI“ erzielt, die der Rat am 13. Mai bestätigte. Vorgeschlagen sind neue Anwendungstermine: für Hochrisiko-Systeme nach Anhang III der 2. Dezember 2027 (ursprünglich 2. August 2026), für solche nach Anhang I der 2. August 2028 (ursprünglich 2. August 2027). Die Transparenzpflichten nach Art. 50 gelten unverändert ab 2. August 2026; für die Kennzeichnung synthetischer Inhalte gibt es für bereits am Markt befindliche Systeme eine Übergangsfrist bis 2. Dezember 2026. Die Pflichten für GPAI-Modelle gelten seit 2. August 2025. Die neuen Termine wirken erst nach Veröffentlichung im Amtsblatt; ob und wann das erfolgt ist, ist vor jeder Planung zu prüfen (Quelle Q6; keine Rechtsberatung).

Neben der Regulierung gibt es technische *Datenrisiken*: Trainingsdaten können verzerrt sein (*Bias*) und zu Benachteiligung führen, personenbezogene Daten können im Modell oder in Ausgaben auftauchen, Eingaben an externe KI-Dienste können vertrauliche Daten abfließen lassen, und Modelle können falsche Aussagen überzeugend formulieren (*Halluzination*). Wesentlich sind *Transparenz* (Nutzer wissen, dass sie mit KI interagieren) und *menschliche Kontrolle* bei folgenreichen Entscheidungen.

Das Beispiel zeigt zwei Hilfsmittel: eine stark vereinfachte Vorprüfung der Risikostufe anhand von Einsatzzwecken und einen einfachen Fairness-Check, der die Auswahlquoten zweier Gruppen vergleicht.

```python
STUFEN = {
    "social scoring":        "VERBOTEN (pruefen lassen)",
    "bewerberauswahl":       "HOCHRISIKO",
    "kreditwuerdigkeit":     "HOCHRISIKO",
    "chatbot kundendienst":  "TRANSPARENZPFLICHT",
    "rechtschreibkorrektur": "MINIMAL",
}
for einsatz in ("bewerberauswahl", "chatbot kundendienst", "rechtschreibkorrektur", "triage notaufnahme"):
    print(f"{einsatz:24s} -> {STUFEN.get(einsatz, 'UNKLAR: rechtlich einordnen lassen')}")

entscheidungen = {"Gruppe A": (50, 100), "Gruppe B": (30, 100)}     # (positive, gesamt)
quoten = {g: p / n for g, (p, n) in entscheidungen.items()}
verhaeltnis = min(quoten.values()) / max(quoten.values())
print({g: round(q, 2) for g, q in quoten.items()}, "Verhaeltnis:", round(verhaeltnis, 2))
if verhaeltnis < 0.8:
    print("Auffaellig: Auswahlquoten weichen stark ab, Ursachen und Daten pruefen")
```

Die Tabelle ordnet einige Einsatzzwecke grob einer Stufe zu; unbekannte Zwecke landen bei „UNKLAR“, denn die echte Einstufung hängt von Anhängen und Ausnahmen der Verordnung ab und gehört in rechtliche Prüfung. Die Triage in der Notaufnahme wäre ein solcher Fall. Der zweite Teil berechnet die Auswahlquote je Gruppe (0,50 und 0,30) und das Verhältnis der kleineren zur größeren (0,60). Die „Vier-Fünftel-Regel“ (Schwelle 0,8) stammt als Faustregel aus der US-Praxis und ist kein EU-Rechtstest; hier dient sie als Warnsignal. Ein auffälliger Wert beweist keine Diskriminierung, verlangt aber eine Untersuchung von Daten, Merkmalen und Prozess.

Typische Fehler: KI-Dienste ohne Prüfung einsetzen und vertrauliche Daten eingeben, Entscheidungen vollständig automatisieren, wo menschliche Kontrolle nötig wäre, und die Einstufung erst nach Produktstart prüfen. Falsch: „Das ist nur ein Hilfstool“ für eine Software, die Bewerbungen vorsortiert. Richtig: früh klären, ob der Einsatzzweck als hochriskant gilt, und dann Dokumentation, Datenqualität, Protokollierung und menschliche Aufsicht einplanen. Bei Einsatz externer KI-Dienste gehören Vereinbarungen zur Datennutzung und zum Standort in die Prüfung (Modell der Auftragsverarbeitung).

> **Merke**
>
> Der AI Act ordnet KI-Systeme nach Risiko: verboten, hohes Risiko, Transparenzpflicht, minimal. Die Einstufung hängt vom Einsatzzweck ab und gehört früh geprüft. Zeitpläne ändern sich (Digital Omnibus); aktuelle Fristen vor Planung prüfen. Verzerrungen, Datenabfluss und Halluzinationen sind technische Risiken, die man mit Tests, Transparenz und menschlicher Kontrolle begrenzt.

> **Praxisbeispiel**
>
> Kunden aus regulierten Branchen fragen nach KI-Einsatz, Trainingsdaten, Modellanbietern und menschlicher Kontrolle. Ein kurzes KI-Register (welche Systeme, Zweck, Anbieter, Daten, Risikostufe) beantwortet das und dient als Grundlage für spätere Pflichten.

## 6.8 Compliance Readiness

*Compliance* bedeutet, Regeln einzuhalten und das nachweisen zu können. *Compliance Readiness* ist der Zustand, in dem ein Unternehmen auf Verlangen (Kunde, Aufsicht, Investor, Zertifizierer) belegen kann, welche Anforderungen gelten, welche Kontrollen sie erfüllen, wer verantwortlich ist und wo die Nachweise liegen. Es geht weniger um Zertifikate als um *Auditfähigkeit*: Man baut sie schrittweise auf, statt sie in einem Kraftakt vor der Prüfung zu erzwingen.

Ein bewährtes Werkzeug ist die *Kontrollmatrix*: eine Tabelle, die jede Anforderung (aus DSGVO, Kundenvertrag, ISO 27001, NIS2) einer Kontrolle, einem Verantwortlichen, einem Nachweis und einem Prüfrhythmus zuordnet. Aus dem Zusammenspiel entstehen *Policies* (verbindliche Regeln wie Informationssicherheitsrichtlinie oder Zugriffsrichtlinie, siehe Modul 11), *Verfahren* (wie wird etwas konkret getan) und *Nachweise* (Protokolle, Tickets, Berichte). Bei Normen wie ISO 27001 oder Prüfberichten wie SOC 2 prüft ein unabhängiger Dritter. Nach der aktuellen österreichischen Umsetzung der NIS2 (siehe Lerneinheit 6.9) sind Registrierung und Selbstdeklaration vorgesehen; vorhandene Zertifizierungen können nach der abgerufenen Quelle organisatorische Maßnahmen belegen, ersetzen aber keine technischen Wirksamkeitsprüfungen wie Penetrationstests.

```python
kontrollen = [
    # (Kontrolle, Anforderung, Verantwortlich, Nachweis vorhanden, Pruefintervall in Monaten, letzte Pruefung)
    ("MFA fuer alle Konten",      "ISO 27001 A.8 / NIS2",    "CTO", True,  3,  "2026-08-15"),
    ("Backup-Restore-Test",       "NIS2 / Kundenvertrag",     "COO", False, 6,  "2026-02-01"),
    ("Verarbeitungsverzeichnis",  "DSGVO Art. 30",            "DSB", True,  12, "2025-12-01"),
    ("Penetrationstest",          "Kundenvertrag",            "CTO", True,  12, "2025-09-10"),
    ("Mitarbeiterschulung",       "ISO 27001 / DSGVO",        "HR",  True,  12, "2026-05-20"),
]
from datetime import date

heute = date(2026, 11, 1)
def monate_seit(datum):
    j, m, _ = (int(x) for x in datum.split("-"))
    return (heute.year - j) * 12 + (heute.month - m)

mit_nachweis = sum(1 for k in kontrollen if k[3])
print(f"Nachweis vorhanden: {mit_nachweis}/{len(kontrollen)} = {100*mit_nachweis//len(kontrollen)} %")
for name, anf, owner, nachweis, intervall, letzte in kontrollen:
    ueberfaellig = monate_seit(letzte) > intervall
    if not nachweis or ueberfaellig:
        grund = "kein Nachweis" if not nachweis else f"Pruefung ueberfaellig ({monate_seit(letzte)} Monate)"
        print(f"LUECKE {name} [{owner}]: {grund}")
```

Die Kontrollmatrix ist eine Liste von Tupeln; `monate_seit` rechnet die Zeit seit der letzten Prüfung in Monaten aus. Das Programm meldet zwei Lücken: Für den Backup-Restore-Test fehlt der Nachweis, und das Verarbeitungsverzeichnis wurde zuletzt vor 11 Monaten geprüft, was innerhalb des Intervalls liegt und daher nicht gemeldet wird; dagegen ist der Penetrationstest (14 Monate bei einem Intervall von 12) überfällig. Nachweis ist bei 4 von 5 Kontrollen vorhanden (80 Prozent). Dieselbe Tabelle wird später für Audits exportiert; Verantwortliche bekommen automatisch Erinnerungen.

Typische Fehler: Policies schreiben, die niemand liest oder lebt; Nachweise erst im Audit zusammensuchen; Zertifizierung als Selbstzweck anstreben, ohne dass Kunden sie verlangen; Verantwortliche nicht benennen. Falsch: eine 40-seitige Richtlinie aus dem Internet kopieren und unterschreiben. Richtig: kurze, zum Unternehmen passende Richtlinien, die tatsächlich so gelebt werden, mit jährlicher Überprüfung. Auch bei Zertifizierungen gilt der Grundsatz: Zuerst wirksame Kontrollen aufbauen, dann prüfen lassen.

> **Merke**
>
> Compliance Readiness heißt: Anforderungen, Kontrollen, Verantwortliche und Nachweise sind bekannt und aktuell. Eine Kontrollmatrix macht Lücken sichtbar. Auditfähigkeit wird schrittweise aufgebaut; Zertifikate folgen dem Kundenbedarf.

> **Praxisbeispiel**
>
> Typisch ist der Weg: Zuerst Kundenanforderungen sammeln, dann Kontrollen mit geringem Aufwand umsetzen, Nachweise automatisch erzeugen (Pipeline-Berichte, Konfigurationsprüfungen), später ISO 27001 oder SOC 2, wenn Verträge es verlangen.

## 6.9 Security Incident Handling

Ein *Sicherheitsvorfall* ist ein Ereignis, das Vertraulichkeit, Integrität oder Verfügbarkeit von Daten oder Systemen beeinträchtigt: ein kompromittiertes Konto, Ransomware, ein Datenabfluss, eine ausgenutzte Sicherheitslücke. Für den Ablauf gilt dasselbe Grundmuster wie bei technischen Störungen (Modul 05, Lerneinheit 5.7), mit zusätzlichen Aufgaben: *Eindämmung* (Zugänge sperren, Systeme isolieren), *Beweissicherung* (Protokolle und Abbilder sichern, bevor aufgeräumt wird, eine einfache Form der *Forensik*), *Beseitigung* der Ursache, *Wiederherstellung*, *Kommunikation* mit Kunden und Behörden und *Lessons Learned*. Wichtig ist, Meldewege vor dem Ernstfall festzulegen, denn im Vorfall bleibt keine Zeit zum Nachdenken.

> **Ergänzung aus der Nachrecherche**
>
> Mehrere Regelwerke setzen Meldefristen, die parallel laufen können. **DSGVO**: Meldung an die Datenschutzbehörde binnen 72 Stunden ab Feststellung, wenn voraussichtlich ein Risiko besteht (Quelle Q11). **NISG 2026** (österreichische NIS2-Umsetzung): Frühwarnung unverzüglich, spätestens binnen 24 Stunden, Meldung binnen 72 Stunden, Abschlussbericht spätestens einen Monat nach der Meldung. Laut der abgerufenen Analyse gilt das Gesetz ab 1. Oktober 2026; Registrierung innerhalb von drei Monaten nach Inkrafttreten, Selbstdeklaration der Risikomanagementmaßnahmen innerhalb von zwölf Monaten, Bußgelder für wesentliche Einrichtungen von mindestens 10 Mio. EUR oder 2 % des weltweiten Umsatzes (Quelle Q7; Anwendungsbereich und aktuelle Fristen sind zu prüfen). **Cyber Resilience Act**: Seit 11. September 2026 müssen Hersteller aktiv ausgenutzte Schwachstellen und schwere Sicherheitsvorfälle bei Produkten mit digitalen Elementen melden: Frühwarnung binnen 24 Stunden, Meldung binnen 72 Stunden, Abschlussbericht binnen 14 Tagen nach Verfügbarkeit einer Korrekturmaßnahme beziehungsweise einem Monat nach der Meldung bei Vorfällen; über eine zentrale Meldeplattform der ENISA (Quelle Q8). Keine Rechtsberatung.

Das Programm berechnet aus dem Zeitpunkt der Kenntnisnahme alle relevanten Meldefristen und sortiert sie. So hat das Team in den ersten Minuten eines Vorfalls eine Liste, welche Meldungen bis wann nötig sein könnten.

```python
from datetime import datetime, timedelta

kenntnis = datetime(2026, 11, 3, 9, 30)      # Dienstag, 09:30 Uhr
fristen = [
    ("NIS2/NISG Fruehwarnung (24 h)",          timedelta(hours=24)),
    ("CRA Fruehwarnung (24 h)",                timedelta(hours=24)),
    ("DSGVO-Meldung Datenschutzbehoerde (72 h)", timedelta(hours=72)),
    ("NIS2/NISG Meldung (72 h)",               timedelta(hours=72)),
    ("CRA Meldung (72 h)",                     timedelta(hours=72)),
]
for name, dauer in sorted(fristen, key=lambda f: f[1]):
    faellig = kenntnis + dauer
    print(f"{faellig:%a %d.%m.%Y %H:%M}  {name}")

meldung_nis2 = kenntnis + timedelta(hours=72)
print("Abschlussbericht NIS2 spaetestens ca.:", (meldung_nis2 + timedelta(days=30)).strftime("%d.%m.%Y"))
```

Die Liste enthält die Frist als Zeitspanne, `kenntnis + dauer` ergibt den Fälligkeitszeitpunkt. Die Sortierung nach Dauer stellt die Fristen von 24 Stunden vor die von 72 Stunden: Mittwoch 4. November 2026 um 09:30 Uhr für die beiden Frühwarnungen, Freitag 6. November 2026 um 09:30 Uhr für die 72-Stunden-Meldungen. Der Abschlussbericht wird hier mit 30 Tagen als Näherung für „einen Monat“ berechnet; die exakte Fristberechnung ist im Gesetz nachzulesen. Wochentage und Feiertage verlängern die Fristen in der Regel nicht, weshalb Bereitschaft am Wochenende nötig ist.

Typische Fehler: Erst nach Tagen merken, dass eine Meldepflicht besteht; unklare Zuständigkeit für Meldungen; der Versuch, den Vorfall intern „klein zu halten“; Systeme sofort neu aufsetzen und dabei Beweise vernichten. Falsch: „Wir melden, sobald wir alles wissen.“ Richtig: Früh melden, Kenntnisstand ergänzen, weil die Fristen ab Kenntnis laufen und eine vorläufige Meldung vorgesehen ist. Außerdem: Kundenkommunikation vorbereiten (Vorlagen, Ansprechpersonen), damit Betroffene sachlich und rechtzeitig informiert werden, und das Ergebnis in Verbesserungen von Produkt und Betrieb übernehmen.

> **Merke**
>
> Bei einem Sicherheitsvorfall: eindämmen, Beweise sichern, beseitigen, wiederherstellen, kommunizieren, lernen. Meldefristen (DSGVO 72 Stunden, NIS2 24 und 72 Stunden, CRA 24 und 72 Stunden) laufen ab Kenntnis und können parallel gelten. Meldewege und Vorlagen gehören vorab vorbereitet.

> **Praxisbeispiel**
>
> Teams üben Vorfälle mindestens einmal jährlich als Planspiel („Tabletop Exercise“) und halten die Ergebnisse fest. Nach einem Vorfall wird das Risikoregister (Modul 11) aktualisiert, und Kunden erhalten bei Bedarf einen Bericht, wie er in Verträgen vorgesehen ist.

## Übungsaufgaben zu Modul 06

1.  **(leicht)** Erkläre den Unterschied zwischen Verantwortlichem und Auftragsverarbeiter und gib ein Beispiel für ein SaaS-Unternehmen.

2.  **(leicht)** Nenne vier Rechtsgrundlagen der DSGVO und beschreibe, wann eine Einwilligung nicht gültig ist.

3.  **(leicht)** Was bedeutet STRIDE, und welcher Buchstabe passt zu einem Mandantenleck?

4.  **(mittel)** Warum sind pseudonymisierte Daten weiterhin personenbezogen, und wie unterscheidet sich das von Anonymisierung?

5.  **(mittel)** Ein Vorfall wird am Freitag um 16:00 Uhr festgestellt. Bis wann ist eine 72-Stunden-Meldung nach DSGVO nötig? Welche Konsequenz hat das für die Bereitschaft?

6.  **(praktisch)** Erweitere das Verarbeitungsverzeichnis-Programm um eine Prüfung, ob besonders sensible Daten (Liste: `Gesundheit`, `Religion`) vorkommen, und gib dafür einen Hinweis auf eine Folgenabschätzung aus.

7.  **(praktisch)** Schreibe ein Skript, das aus einer Liste von Benutzern mit `letzter_login`-Datum alle Konten findet, die seit mehr als 90 Tagen nicht genutzt wurden.

8.  **(schwer/praktisch)** Ergänze die Baseline-Prüfung aus 6.6 um eine Bewertung: Jeder Fund erhält ein Gewicht (öffentlich erreichbar = 5, unverschlüsselt = 3, kein Backup = 2, gefährlicher Port = 4), und das Programm gibt je Ressource die Summe aus.

## Lösungen zu den Übungsaufgaben Modul 06

**1.** Der Verantwortliche entscheidet über Zwecke und Mittel, der Auftragsverarbeiter verarbeitet nach Weisung. Ein SaaS-Unternehmen ist für Daten, die Kunden in die Software eingeben, meist Auftragsverarbeiter, für seine eigenen Kundenkonten, Rechnungs- und Marketingdaten Verantwortlicher.

**2.** Einwilligung, Vertrag, rechtliche Verpflichtung, berechtigtes Interesse (außerdem lebenswichtige Interessen und öffentliches Interesse). Eine Einwilligung ist nicht gültig, wenn sie nicht freiwillig, nicht informiert oder nicht eindeutig ist, zum Beispiel bei vorangekreuztem Kästchen, gebündelt mit anderen Bedingungen oder wenn der Widerruf erschwert wird.

**3.** Spoofing, Tampering, Repudiation, Information Disclosure, Denial of Service, Elevation of Privilege. Das Mandantenleck ist ein Fall von *Information Disclosure* (I).

**4.** Pseudonymisierte Daten lassen sich mit Zusatzinformationen (zum Beispiel dem Schlüssel) wieder einer Person zuordnen, deshalb bleiben sie personenbezogen und unterliegen der DSGVO. Bei der Anonymisierung ist die Zuordnung auch mit vertretbarem Aufwand nicht mehr möglich; dann gilt die DSGVO nicht mehr, was aber hohe Anforderungen an den Nachweis stellt.

**5.** Fristbeginn ist die Feststellung (Freitag 16:00 Uhr); 72 Stunden später ist Montag 16:00 Uhr. Wochenenden verlängern die Frist nicht, deshalb müssen Zuständige am Wochenende erreichbar sein, oder es braucht einen Bereitschaftsplan.

**6.** Eine mögliche Ergänzung:

```python
SENSIBEL = {"Gesundheit", "Religion"}
for v in vvt:
    if SENSIBEL & set(v["daten"]):
        print(f"{v['name']}: besondere Datenkategorie, Folgenabschaetzung pruefen")
```

Der Schnitt zweier Mengen (`&`) ist nicht leer, wenn mindestens eine sensible Datenart vorkommt. Im Beispiel-VVT erscheint kein Treffer; fügt man `"Gesundheit"` einer Verarbeitung hinzu, wird sie gemeldet.

**7.** Mögliche Lösung:

```python
from datetime import date, timedelta
heute = date(2026, 11, 1)
konten = [("anna", "2026-10-30"), ("ben", "2026-06-01"), ("cleo", "2026-09-15")]
for name, login in konten:
    if date.fromisoformat(login) < heute - timedelta(days=90):
        print("Inaktiv:", name, login)
```

Die Grenze liegt am 3. August 2026; nur `ben` (1. Juni) ist länger inaktiv.

**8.** Mögliche Lösung (die Liste `ressourcen` und `GEFAEHRLICH` aus 6.6 vorausgesetzt):

```python
for r in ressourcen:
    punkte = 0
    if r["typ"] in ("speicher", "datenbank"):
        punkte += 5 if r["oeffentlich"] else 0
        punkte += 3 if not r["verschluesselt"] else 0
        punkte += 2 if r["typ"] == "datenbank" and not r["backup"] else 0
    if r["typ"] == "firewall":
        punkte += 4 * sum(1 for p in r["offene_ports"] if p in GEFAEHRLICH)
    print(r["name"], punkte)
```

Ergebnis: `kunden-export` 5, `prod-db` 3, `test-db` 7, `fw-1` 8. Die Firewall hat die höchste Punktzahl (zwei gefährliche Ports), gefolgt von der öffentlichen Testdatenbank ohne Backup.
