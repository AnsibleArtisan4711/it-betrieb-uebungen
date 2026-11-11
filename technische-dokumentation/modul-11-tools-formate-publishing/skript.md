# Modul 11 - Tools, Formate und Publishing-Prozesse

> **Hinweis zu diesem Kapitel:** Das ist das Kapitel des Skripts „Technische Dokumentation und Dokumentations-Governance“, aus der LaTeX-Quelle in Markdown umgewandelt (Text und Listings unverändert, farbige Boxen als Zitatblöcke mit fettem Titel, Tabellen als Markdown-Tabellen, Übungsaufgaben und Lösungen als Absätze). Die Lerneinheiten sind wie in der Quelle nach Modul nummeriert (11.1 bis 11.8), danach folgen „Übungsaufgaben“ (8 Aufgaben) und „Lösungen und Erläuterungen“. Die Sprachangabe der Codeblöcke ist in der Quelle nur für Python und Bash gesetzt; die übrigen Blöcke sind hier nach ihrem Inhalt als `python`, `yaml`, `markdown`, `bash` oder `text` ausgezeichnet, der Inhalt selbst ist unverändert. **Prüfstand der Beispiele für dieses Repository:** Die Python-Beispiele wurden auf Syntax geprüft; welche Beispiele ausgeführt wurden und welche zusätzlich PyYAML brauchen, steht in der [README des Repositories](../README.md). Übersicht zum Modul: [README](README.md).

**Dauer:** 8,75 Stunden | **Priorität:** 2 | **Lerneinheiten:** 8

| **Nr.** | **Lerneinheit**             | **Dauer (h)** | **Prio** |
|--------:|:----------------------------|--------------:|---------:|
|       1 | Markdown                    |          1,25 |        1 |
|       2 | LaTeX Grundlagen            |          1,25 |        1 |
|       3 | Word und Vorlagen           |             1 |        1 |
|       4 | Wiki-Systeme                |             1 |        1 |
|       5 | Docs-as-Code                |             1 |        1 |
|       6 | Static Site Generator Bezug |             1 |        2 |
|       7 | PDF und HTML Export         |             1 |        2 |
|       8 | Tooling-Troubleshooting     |          1,25 |        2 |
|         | **Summe**                   |      **8,75** |          |

## 11.1 Markdown

Markdown ist eine einfache Auszeichnungssprache für Text. Man schreibt normalen Text und deutet Struktur mit wenigen Zeichen an: Eine Raute am Zeilenanfang macht eine Überschrift, ein Bindestrich eine Aufzählung, Sternchen um ein Wort machen es fett. Aus dieser einfachen Quelle erzeugt ein Programm das Zielformat, meist HTML, aber auch PDF oder Word. Der Gedanke dahinter ist, dass die Quelle auch ohne Programm lesbar bleibt und sich mit jedem Texteditor bearbeiten lässt. Für Dokumentation hat das große Vorteile: Die Dateien sind klein, lassen sich mit Git versionieren (Modul 10), Änderungen sind zeilenweise vergleichbar, und kein Hersteller kann das Format entziehen.

Dem stehen Grenzen gegenüber, die man kennen muss. Markdown beschreibt nur die *Struktur* (Überschrift, Liste, Zitat, Codeblock, Tabelle), nicht das Aussehen. Wie eine Überschrift der Ebene zwei aussieht, entscheidet erst das Werkzeug, das die Datei umwandelt. Wer feste Seitenumbrüche, Spalten oder exakte Schriftgrößen braucht, stößt schnell an die Grenze und muss auf ein anderes Format (Abschnitt LaTeX, Abschnitt Word) ausweichen. Außerdem gibt es nicht *das* Markdown, sondern mehrere Dialekte, die sich in Details unterscheiden.

> **Ergänzung aus der Nachrecherche**
>
> Zur Einordnung der Dialekte nach einem abgerufenen Beitrag des GitHub-Blogs: CommonMark ist ein Projekt, das die Markdown-Syntax formal festlegt und Referenzimplementierungen bereitstellt, damit derselbe Text überall gleich dargestellt wird. Der Kern deckt bewusst nur die gemeinsame Teilmenge des ursprünglichen Markdown ab; Tabellen, Durchstreichungen, automatische Links und Aufgabenlisten gehören nicht dazu. GitHub Flavored Markdown (GFM) baut auf CommonMark auf und ergänzt genau diese Erweiterungen als optionale Obermenge. Praktische Folge für die Dokumentation: Eine Tabelle, die auf GitHub richtig aussieht, kann in einem anderen Werkzeug als Fließtext erscheinen, wenn dieses nur den Kern beherrscht. (Abruf 28.10.2026, siehe Quellenverzeichnis.)

Das folgende Beispiel ist eine vollständige Anleitung in Markdown. Sie beginnt mit einem Kopfbereich zwischen zwei Linien aus drei Strichen. Dieser Bereich heißt Front Matter und enthält Metadaten (Titel, Owner) im Format YAML; er ist kein Teil des Markdown-Standards, wird aber von vielen Werkzeugen verstanden und ist die Grundlage für Dokumentverwaltung, wie sie in Modul 07 und 10 beschrieben wurde. Danach folgen Überschriften, ein Absatz mit Hervorhebung und Inline-Code, zwei Listen, eine Tabelle und ein Verweis auf eine andere Datei.

```markdown
---
titel: Anleitung Neustart
owner: Team Betrieb
---
# Anleitung Neustart

Dieser Text beschreibt den **Neustart** des Dienstes `shop`.

## Voraussetzungen

- Zugriff auf den Server
- Wartungsfenster vereinbart

## Schritte

1. Dienst stoppen: `systemctl stop shop`
2. Dienst starten: `systemctl start shop`

| Schritt | Dauer |
|---------|-------|
| Stoppen | 1 min |
| Starten | 2 min |

Siehe auch [Backup](backup.md).
```

Die Zeile mit einer einzelnen Raute ist die Überschrift der ersten Ebene, zwei Rauten ergeben die zweite Ebene. Die Nummerierung der Liste schreibt man selbst; beim Umwandeln entsteht daraus eine echte nummerierte Liste. Die Tabelle wird durch senkrechte Striche und eine Trennzeile aus Bindestrichen aufgebaut. Der Verweis steht in der Form *Text in eckigen, Ziel in runden Klammern*. Ich habe die Datei mit dem Werkzeug Pandoc (Version 3.1.3 im Arbeitsbereich) in HTML umgewandelt: Es entstanden zwei Überschriften der zweiten Ebene mit automatisch vergebenen Kennungen (`voraussetzungen` und `schritte`), eine Tabelle und ein Verweis, der weiterhin auf `backup.md` zeigt. Der letzte Punkt ist wichtig: Der Verweis funktioniert in einem Editor, der Markdown-Dateien verknüpft, aber nicht im erzeugten HTML, solange das Werkzeug den Verweis nicht auf `backup.html` umschreibt. Wie man das löst, zeigt der Abschnitt über Static Site Generatoren.

Zur Auswahl des Werkzeugs nach Zweck und Zielgruppe: Markdown eignet sich sehr gut für technische Inhalte, die von Menschen geschrieben werden, die ohnehin mit Editoren und Versionsverwaltung arbeiten, und für Inhalte, die in mehreren Formaten erscheinen sollen. Weniger geeignet ist es für Autoren, die ein Layout sehen wollen, während sie schreiben, für Dokumente mit starken Formatvorgaben und für Inhalte mit vielen komplexen Tabellen oder Abbildungen mit Beschriftung und Querverweis.

Typische Fehler: Eine Liste wird ohne Leerzeile vor dem ersten Punkt begonnen und erscheint dann als Fließtext; die Tabellentrennzeile fehlt; Überschriften springen von Ebene eins auf Ebene vier; Dateinamen enthalten Leerzeichen, die in Verweisen mit `%20` maskiert werden müssen; man verwendet Dialekt-Funktionen, die das Zielwerkzeug nicht kennt.

| **Falsch**                                                                                         | **Richtig**                                                                                        |
|:---------------------------------------------------------------------------------------------------|:---------------------------------------------------------------------------------------------------|
| Text: `Schritte:` direkt gefolgt von `- Punkt 1` ohne Leerzeile, Überschrift `#### Details` direkt unter `# Titel`. | Leerzeile vor der Liste, Überschriftenebenen lückenlos (eins, zwei, drei), Tabelle mit Trennzeile. |

Im Projekt legt man fest, welcher Dialekt gilt (meist CommonMark mit den GFM-Erweiterungen Tabellen und Aufgabenlisten), welche Metadaten das Front Matter enthalten muss und wie Dateien benannt werden (Kleinbuchstaben, Bindestriche, keine Leerzeichen). Diese drei Festlegungen verhindern den größten Teil der späteren Probleme.

## 11.2 LaTeX Grundlagen

LaTeX ist ein Satzsystem. Anders als bei Markdown beschreibt man hier nicht nur die Struktur, sondern kann das Layout bis ins Detail steuern: Seitenränder, Schriften, Kopf- und Fußzeilen, Inhaltsverzeichnis, Verzeichnisse, Querverweise, Literatur, mathematische Formeln. Man schreibt eine Textdatei mit Befehlen, ein Programm (hier `pdflatex`) setzt daraus ein PDF. Genau dieses System erzeugt das Skript, das Sie gerade lesen. Seine Stärken sind reproduzierbare, typografisch hochwertige PDFs, Querverweise und Verzeichnisse, die sich selbst aktualisieren, und eine vollständige Textform, die sich versionieren lässt. Seine Schwächen sind die Einarbeitungszeit, schwer verständliche Fehlermeldungen und die Tatsache, dass Fachbereiche ohne Vorkenntnisse es kaum bearbeiten können.

Ein LaTeX-Dokument hat zwei Teile. Die *Präambel* steht vor `\begin{document}` und legt Dokumentklasse und Pakete fest. Die Dokumentklasse bestimmt das Grundlayout (`scrartcl` ist die deutsche Variante einer Artikelklasse aus dem KOMA-Script), Pakete erweitern die Funktionen: `babel` mit der Option `ngerman` für deutsche Silbentrennung und Bezeichnungen, `fontenc` mit `T1` für korrekte Umlaute in der Ausgabe, `lmodern` für eine skalierbare Schrift, `listings` für Codeblöcke. Der *Hauptteil* zwischen `begin` und `end` enthält den Inhalt, gegliedert durch Befehle wie `\section`.

Das folgende Beispiel ist ein vollständiges, kompilierbares Dokument, dieselbe Anleitung wie im Markdown-Abschnitt. Ich habe es mit `pdflatex` übersetzt, es ergab ein PDF mit einer Seite. Die Zuordnung zu Markdown ist lehrreich: Aus der Überschrift mit zwei Rauten wird `\section`, aus der nummerierten Liste die Umgebung `enumerate`, aus dem Inline-Code `\texttt`, aus einem Codeblock die Umgebung `lstlisting`, die im Beispiel der Übersicht halber weggelassen ist.

```text
\documentclass[11pt]{scrartcl}
\usepackage[ngerman]{babel}
\usepackage[T1]{fontenc}
\usepackage{lmodern}
\usepackage{listings}
\title{Anleitung Neustart}
\author{Team Betrieb}
\begin{document}
\maketitle
\section{Voraussetzungen}
Zugriff auf den Server und ein vereinbartes Wartungsfenster.
\section{Schritte}
\begin{enumerate}
\item Dienst stoppen: \texttt{systemctl stop shop}
\item Dienst starten: \texttt{systemctl start shop}
\end{enumerate}
\end{document}
```

Jede Zeile hat eine Aufgabe. Die erste Zeile wählt die Klasse mit der Schriftgröße elf Punkt. Die vier Paketzeilen schalten Deutsch, Umlaute, Schrift und Codeblöcke ein. `title` und `author` speichern Angaben, die `maketitle` im Hauptteil als Titelblock ausgibt. Beachten Sie, dass bestimmte Zeichen in LaTeX eine Sonderbedeutung haben (Prozentzeichen, Und-Zeichen, Raute, Unterstrich, geschweifte Klammern, Dollar, Zirkumflex, Tilde und Rückwärtsschrägstrich) und mit einem Rückwärtsschrägstrich maskiert werden müssen, wenn sie als normales Zeichen erscheinen sollen. Wer einen Dateinamen mit Unterstrich in den Text setzt, erhält ohne Maskierung eine Fehlermeldung.

Für größere Dokumentationen unterteilt man in mehrere Dateien. Dieses Skript nutzt dafür das Paket `subfiles`: Jedes Modul ist eine eigene Datei, die einzeln und zusammen übersetzt werden kann. Das Prinzip passt zu Docs-as-Code, weil jede Datei einen eigenen Verantwortlichen haben kann.

Typische Fehler: Ein Paket fehlt auf dem Rechner und die Übersetzung bricht ab; Umlaute erscheinen falsch, weil Kodierung oder Schriftpaket nicht passen; man übersetzt nur einmal und die Verweise zeigen Fragezeichen, weil LaTeX mindestens zwei Durchläufe für Verzeichnisse und Verweise braucht; ein einziger Fehler in einer Zeile lässt die Meldung auf eine ganz andere Stelle zeigen.

| **Falsch**                                                                                 | **Richtig**                                                                             |
|:-------------------------------------------------------------------------------------------|:----------------------------------------------------------------------------------------|
| Der Text `Datei bestand_2026` mit ungeschütztem Unterstrich im Fließtext und nur ein Übersetzungslauf. | Unterstrich maskiert (`bestand\_2026`) und zwei Läufe, damit Verweise und Verzeichnis stimmen. |

Im Projekt eignet sich LaTeX für lange, formal strenge Dokumente mit Verzeichnissen und Querverweisen, etwa Handbücher oder Prüfungsunterlagen, und für alles, was als PDF archiviert wird. Es eignet sich nicht für Dokumente, die viele Fachbereichsmitarbeiter ohne Vorkenntnisse pflegen müssen. Für diese Gruppe ist Markdown oder ein Wiki die bessere Wahl; Pandoc kann bei Bedarf Markdown zu LaTeX oder PDF umwandeln (siehe Abschnitt PDF und HTML Export).

## 11.3 Word und Vorlagen

Word ist das Werkzeug, das die meisten Fachbereiche kennen. Das ist sein größter Vorteil in der Dokumentation: Die Hemmschwelle zum Mitarbeiten ist gering, Kommentare und Änderungsverfolgung sind eingebaut, und das Programm ist in Unternehmen bereits vorhanden. Seine Nachteile sind ein binäres Paketformat, das sich schlecht versionieren und vergleichen lässt, und die Neigung, Formatierung von Hand statt über Formatvorlagen vorzunehmen. Ein Dokument mit von Hand vergrößerter und fett gesetzter „Überschrift“ sieht gleich aus wie eines mit der Vorlage „Überschrift 1“, verhält sich aber ganz anders: Es erscheint nicht im Inhaltsverzeichnis, nicht in der Navigation und für Vorleseprogramme nicht als Überschrift.

Eine *Dokumentvorlage* legt fest, welche Formatvorlagen es gibt (Überschriften, Absatz, Aufzählung, Codeblock, Tabelle), wie sie aussehen, welche Kopf- und Fußzeilen gelten und welche Platzhalter vorhanden sind. Wer konsequent Formatvorlagen verwendet, kann das Aussehen des ganzen Dokuments an einer Stelle ändern, und Inhaltsverzeichnis, Navigation und Barrierefreiheit funktionieren. Die inhaltlichen Mindestanforderungen an Vorlagen (Pflichtabschnitte, Metadaten) wurden in Modul 07 behandelt; hier geht es um die technische Durchsetzung in Word-Dateien.

Eine .docx-Datei ist ein Archiv im ZIP-Format, in dem der eigentliche Text als XML liegt. Das erlaubt automatische Prüfungen, auch ohne Word. Das folgende Beispiel nutzt Pandoc, um aus der Markdown-Anleitung eine Word-Datei zu erzeugen, die sich an einer Vorlage orientiert, und prüft danach mit einem kleinen Python-Skript, welche Absatzformatvorlagen verwendet wurden und ob sie in der Liste der erlaubten Vorlagen stehen.

```bash
pandoc -o vorlage.docx --print-default-data-file reference.docx
pandoc anleitung.md -o anleitung.docx --reference-doc=vorlage.docx
python3 pruefe_docx.py anleitung.docx
```

```python
import re, sys, zipfile

ERLAUBT = {"Title", "Heading1", "Heading2", "Heading3", "BodyText",
           "FirstParagraph", "Compact", "SourceCode", "TableCaption"}

with zipfile.ZipFile(sys.argv[1]) as z:
    xml = z.read("word/document.xml").decode("utf-8")

verwendet = re.findall(r'<w:pStyle w:val="([^"]+)"', xml)
unbekannt = sorted(set(verwendet) - ERLAUBT)
print("Verwendete Formatvorlagen:", sorted(set(verwendet)))
print("Nicht erlaubt:", unbekannt or "keine")
if re.search(r"<w:b/>", xml) and not re.search(r'w:val="Strong"', xml):
    print("Hinweis: direkte Fettformatierung statt Zeichenformatvorlage")
```

Die erste Zeile lässt Pandoc seine eingebaute Standardvorlage als Datei ausgeben. In der Praxis öffnet man diese Datei in Word, passt Schriften, Farben und Abstände der Formatvorlagen an und speichert sie als Unternehmensvorlage. Die zweite Zeile erzeugt die Word-Datei, die diese Formatvorlagen übernimmt: Der Inhalt kommt aus Markdown, das Aussehen aus der Vorlage. Das Skript öffnet die Datei als ZIP-Archiv, liest den Text als XML und sucht alle Absatzformatvorlagen. Für die Beispieldatei meldet es die Vorlagen `BodyText`, `Compact`, `FirstParagraph`, `Heading1` und `Heading2` und stellt fest, dass keine nicht erlaubte darunter ist. Hätte jemand in Word einen Absatz mit einer selbst erfundenen Vorlage versehen, stünde sie in der Meldung.

Typische Fehler: Überschriften werden von Hand formatiert; Dokumente werden aus alten Dokumenten kopiert und tragen deren Formatreste mit; es existieren mehrere Vorlagenfassungen nebeneinander; die Vorlage liegt auf dem Laufwerk einer Person und nicht an zentraler Stelle; Änderungen werden ohne Änderungsverfolgung eingearbeitet.

| **Falsch**                                            | **Richtig**                                                                                                  |
|:------------------------------------------------------|:-------------------------------------------------------------------------------------------------------------|
| Überschrift: markierter Text, Schrift 16 Punkt, fett. | Absatzformatvorlage „Überschrift 1“ aus der Unternehmensvorlage; Aussehen einmalig in der Vorlage definiert. |

Im Projekt lohnt sich der Blick auf den Fluss der Dokumente: Wer Word als Bearbeitungsformat zulässt, muss entscheiden, wo die maßgebliche Fassung liegt (Modul 10, Freigabe und Archivierung) und wie Versionen verglichen werden. Der Vergleich zweier .docx-Dateien gelingt mit der Vergleichsfunktion von Word, nicht mit Git.

## 11.4 Wiki-Systeme

Ein Wiki ist eine Sammlung von Seiten, die direkt im Browser bearbeitet werden und sich gegenseitig verlinken. Der Name stammt vom hawaiianischen Wort für „schnell“. Der Kerngedanke ist, dass Wissen dort entsteht und gepflegt wird, wo es gebraucht wird, ohne Umweg über Dateien und Freigaben. Wikis eignen sich für lebendige Inhalte wie Betriebswissen, Anleitungen, Teamabsprachen und Fragen und Antworten. Sie eignen sich weniger für Inhalte, die formal freigegeben und unveränderlich archiviert werden müssen, weil jede Seite jederzeit änderbar ist und der Freigabestatus (Modul 10) nicht in jedem Wiki vorgesehen ist. Konkrete Plattformen wie Confluence und SharePoint behandelt Modul 12; hier geht es um das, was alle Wikis gemeinsam haben, und um die typischen Pflegeprobleme.

Ein Wiki besteht aus einem *Seitenbaum* (Elternseiten und Unterseiten), Verweisen zwischen Seiten, einer Suche, einer Versionsgeschichte je Seite und Berechtigungen. Die Freiheit des Wikis ist zugleich sein größtes Risiko: Ohne Ordnung entstehen verwaiste Seiten, die niemand findet, tote Verweise auf gelöschte oder umbenannte Seiten, tief verschachtelte Hierarchien und mehrere Seiten zum gleichen Thema, die sich widersprechen. Das Gegenmittel sind Regeln: Jede Seite hat eine Elternseite und einen Owner, die Hierarchie ist höchstens drei bis vier Ebenen tief, Seiten sind von mindestens einer anderen Seite aus erreichbar, und Titel folgen einer Konvention.

Viele Wikis erlauben, Seiten zu exportieren, etwa als Markdown-Dateien mit Kopfdaten. Das folgende Beispiel prüft einen solchen Export auf die drei Pflegeprobleme: tote Verweise, fehlende Elternseiten, verwaiste Seiten. Es liest je Seite die Metadaten aus dem Kopf, sammelt alle Verweise auf andere Seiten und berechnet die Tiefe im Seitenbaum.

```python
import re, sys, yaml
from pathlib import Path

seiten = {}
for datei in Path(sys.argv[1]).glob("*.md"):
    text = datei.read_text(encoding="utf-8")
    kopf = yaml.safe_load(text.split("---")[1])
    seiten[datei.stem] = {"parent": kopf.get("parent"), "text": text}

verlinkt = set()
for name, s in seiten.items():
    for ziel in re.findall(r"\]\(([^)]+)\.md\)", s["text"]):
        verlinkt.add(ziel)
        if ziel not in seiten:
            print(f"{name}: toter Link auf {ziel}")

for name, s in sorted(seiten.items()):
    if s["parent"] and s["parent"] not in seiten:
        print(f"{name}: Elternseite '{s['parent']}' existiert nicht")
    if s["parent"] and name not in verlinkt:
        print(f"{name}: verwaist (keine Seite verweist darauf)")

def tiefe(name, gesehen=()):
    p = seiten[name]["parent"]
    if not p or p not in seiten or p in gesehen:
        return 1
    return 1 + tiefe(p, gesehen + (name,))

print("Tiefe je Seite:", {n: tiefe(n) for n in sorted(seiten)})
```

Ich habe das Skript mit fünf Beispielseiten ausgeführt: Startseite „betrieb“, darunter „shop“ (mit Unterseite „neustart“) und „backup“, dazu eine Seite „notiz“. Das Ergebnis: Die Seite „backup“ verweist auf eine nicht vorhandene Seite „restore“ (toter Link); „notiz“ nennt eine nicht existierende Elternseite und wird von keiner Seite verlinkt (verwaist); die Tiefen sind eins für die Startseite, zwei für Shop und Backup, drei für den Neustart. Die Wurzelseite zählt nicht als verwaist, weil sie keine Elternseite hat. Die Rekursion in `tiefe` hat einen Schutz gegen Zyklen: Zeigt eine Seite über mehrere Schritte auf sich selbst als Elternseite, bricht die Funktion ab, statt endlos zu laufen.

Typische Fehler: Jeder legt Seiten dort an, wo er gerade ist; Titel wie „Neu“ oder „Notizen 2“; Seiten ohne Owner; das Wiki wird zum Ablageort für Anhänge, die niemand mehr öffnet; Verweise werden als Text statt als Verknüpfung gesetzt, sodass Umbenennungen sie nicht mitziehen.

| **Falsch**                                                                                    | **Richtig**                                                                                      |
|:----------------------------------------------------------------------------------------------|:-------------------------------------------------------------------------------------------------|
| Seite „Neu 2“ unter der Startseite, ohne Owner, ohne Verlinkung, Kopie einer alten Anleitung. | Seite „Neustart Shop“ unter „Shop“, mit Owner und Prüfdatum, verlinkt aus der Betriebsübersicht. |

Im Projekt steht und fällt ein Wiki mit der Pflege (Modul 14, Lifecycle Management): Ohne regelmäßigen Pflegelauf gegen verwaiste Seiten und tote Verweise verliert es nach wenigen Monaten das Vertrauen der Leser.

## 11.5 Docs-as-Code

Docs-as-Code bedeutet, Dokumentation mit denselben Werkzeugen und Verfahren zu behandeln wie Software-Quelltext: Textdateien in einem Git-Repository, Änderungen über Branches und Pull Requests, Reviews durch Kolleginnen und Kollegen, automatische Prüfungen und automatisches Veröffentlichen. Die Grundlagen von Git und Review wurden in Modul 10 behandelt, die API- und Entwicklerdokumentation in Modul 08. Hier steht die Frage im Vordergrund, wann sich Docs-as-Code für welche Dokumentation lohnt und wie die Automatisierung im Kern aussieht.

Die Vorteile ergeben sich aus der Nähe zum Code. Dokumentation und Software ändern sich im selben Pull Request, sodass Änderungen nicht auseinanderlaufen. Jede Änderung ist nachvollziehbar (wer, wann, warum), Reviews sind Teil des Alltags der Entwickler, und automatische Prüfungen fangen Fehler vor der Veröffentlichung ab: tote Verweise, Stilregeln, Formatfehler, Pflichtangaben. Die Nachteile sind ebenso real: Wer kein Git kennt, kann nicht mitarbeiten; Fachbereiche und Management sind meist nicht im Repository unterwegs; Rückmeldungen von Lesern kommen schwerer an. Docs-as-Code ist deshalb kein Ersatz für alle anderen Werkzeuge, sondern eine gute Wahl für technische Inhalte mit technischen Autoren.

Der Kern der Automatisierung ist eine *Pipeline*: Bei jeder Änderung wird die Dokumentation automatisch gebaut, geprüft und bei Erfolg veröffentlicht. Das folgende Beispiel zeigt eine solche Pipeline als Konfigurationsdatei für GitHub Actions. Sie startet bei jedem Pull Request, der Dateien im Ordner `docs` verändert, installiert Pandoc, wandelt jede Markdown-Datei in HTML um und legt das Ergebnis als Artefakt ab. Schlägt ein Schritt fehl, schlägt die Pipeline fehl, und der Pull Request wird als fehlerhaft markiert.

```yaml
name: Dokumentation
on:
  pull_request:
    paths: ["docs/**"]
jobs:
  pruefen:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Pandoc installieren
        run: sudo apt-get update && sudo apt-get install -y pandoc
      - name: Dokumentation bauen
        run: |
          mkdir -p public
          for f in docs/*.md; do
            pandoc "$f" -s -o "public/$(basename "${f%.md}").html"
          done
      - uses: actions/upload-artifact@v4
        with:
          name: doku
          path: public
```

Ich konnte diese Datei im Arbeitsbereich nicht auf der Plattform ausführen; geprüft habe ich, dass sie gültiges YAML ist und die erwartete Struktur hat (ein Auslöser, ein Job mit vier Schritten). Die enthaltenen Befehle für Pandoc entsprechen dem, was ich lokal getestet habe. Die Versionsangaben der Aktionen (`checkout@v4`, `upload-artifact@v4`) sollten Sie vor dem Einsatz mit der aktuellen Plattformdokumentation abgleichen, weil sie sich ändern. Eine Eigenart von YAML sei erwähnt, weil sie bei eigenen Prüfskripten verwirrt: Manche YAML-Leser deuten das Wort `on` als Wahrheitswert und liefern als Schlüssel `True`; das hat mein Test mit PyYAML gezeigt. Wer Konfigurationsdateien selbst einliest, muss das wissen.

Die Zeilen im Detail: Der Auslöser (`on`) begrenzt die Pipeline auf Pull Requests mit Änderungen im Ordner `docs`, damit nicht jede Code-Änderung einen Dokumentationsbau auslöst. `runs-on` nennt die Umgebung, in der die Schritte laufen. Der erste Schritt holt das Repository, der zweite installiert Pandoc, der dritte baut, der vierte legt das Ergebnis ab. Das Konstrukt in der Schleife schneidet die Endung ab und ersetzt sie durch `.html`.

Typische Fehler: Die Pipeline prüft nichts und baut nur; ein Fehler im Bau wird ignoriert, weil der letzte Befehl erfolgreich war; Zugangsdaten für die Veröffentlichung stehen im Repository (siehe Modul 13, Geheimnisse); es gibt keinen Weg für Nicht-Entwickler, Korrekturen vorzuschlagen.

| **Falsch**                                                                                        | **Richtig**                                                                                                        |
|:--------------------------------------------------------------------------------------------------|:-------------------------------------------------------------------------------------------------------------------|
| Dokumentation liegt im Repository, aber jeder Fehler wird erst nach der Veröffentlichung bemerkt. | Pipeline baut bei jedem Pull Request, prüft Verweise und Stilregeln und blockiert die Zusammenführung bei Fehlern. |

Im Projekt hat sich bewährt, mit einer schmalen Pipeline zu beginnen (bauen und Verweise prüfen) und sie schrittweise zu erweitern. Nicht-Entwickler sollten einen einfachen Weg erhalten: ein Formular, das einen Pull Request erzeugt, oder ein Ticket, das ein Redakteur ins Repository überträgt.

## 11.6 Static Site Generator Bezug

Ein Static Site Generator (SSG) wandelt eine Sammlung von Textdateien in eine fertige, statische Webseite um: HTML-Dateien, die ein einfacher Webserver ausliefern kann, ohne Datenbank und ohne Programmcode zur Laufzeit. Das macht sie schnell, sicher und billig im Betrieb, denn es gibt keinen Server-Code, den jemand angreifen könnte. Typische Aufgaben eines SSG sind das Umwandeln von Markdown in HTML, das Einbetten in eine Seitenvorlage, das Erzeugen der Navigation, das Umschreiben von Verweisen und häufig eine clientseitige Suche. Bekannte Vertreter sind MkDocs, Sphinx, Docusaurus und Hugo. Welcher zu einem Projekt passt, hängt von Sprache, Umfang und Team ab; die Prinzipien sind bei allen gleich.

> **Ergänzung aus der Nachrecherche**
>
> Stand der Werkzeuglandschaft nach einer abgerufenen Drittseite (pydevtools): Das verbreitete Theme Material for MkDocs ist nach dieser Quelle Anfang 2026 in den Wartungsmodus gewechselt. Kritische Fehler und Sicherheitsprobleme sollen demnach noch mindestens zwölf Monate ab der Ankündigung behoben werden; neue Funktionen entwickelt das Team in einem Nachfolger namens Zensical, der bestehende `mkdocs.yml`-Konfigurationen lesen können soll. Für neue Projekte empfiehlt die Quelle, Zensical neben Material zu prüfen, für bestehende gilt Material weiter als sichere Wahl; zudem sei mit MkDocs 2.0 eine grundlegende Neuentwicklung des Basiswerkzeugs in Arbeit. Das zeigt, wie schnell sich diese Landschaft bewegt: Die Entscheidung für ein Werkzeug sollte begründet und überprüfbar sein, und die Inhalte sollten in Markdown bleiben, damit ein Wechsel möglich ist. Prüfen Sie den aktuellen Stand vor einer Entscheidung auf den Projektseiten selbst. (Abruf 28.10.2026, Drittquelle, nicht Herstellerangabe.)

Um zu verstehen, was ein SSG tut, hilft es, einen sehr kleinen selbst zu bauen. Das folgende Skript liest alle Markdown-Dateien eines Ordners, liest die Metadaten aus dem Kopf, sortiert die Seiten nach einer Reihenfolge, wandelt den Text mit der Python-Bibliothek `markdown` in HTML um, setzt jede Seite in eine Vorlage mit Navigation und schreibt das Ergebnis in den Ordner `public`. Dabei schreibt es Verweise auf `.md`-Dateien in Verweise auf `.html`-Dateien um, womit das Problem aus dem Markdown-Abschnitt gelöst ist.

```python
import re, shutil, yaml
from pathlib import Path
import markdown

QUELLE, ZIEL = Path("docs"), Path("public")
VORLAGE = """<!doctype html>
<html lang="de"><head><meta charset="utf-8"><title>{titel}</title></head>
<body><nav>{navigation}</nav><main>{inhalt}</main>
<footer>Owner: {owner}</footer></body></html>"""

def lesen(datei):
    teile = datei.read_text(encoding="utf-8").split("---", 2)
    return yaml.safe_load(teile[1]), teile[2]

seiten = []
for datei in QUELLE.glob("*.md"):
    kopf, text = lesen(datei)
    seiten.append((kopf.get("reihenfolge", 99), datei.stem, kopf, text))
seiten.sort(key=lambda s: (s[0], s[1]))

navigation = " | ".join(f'<a href="{name}.html">{kopf["titel"]}</a>' for _, name, kopf, _ in seiten)

shutil.rmtree(ZIEL, ignore_errors=True)
ZIEL.mkdir()
for _, name, kopf, text in seiten:
    inhalt = markdown.markdown(text, extensions=["tables"])
    inhalt = re.sub(r'href="([^"]+)\.md"', r'href="\1.html"', inhalt)
    html = VORLAGE.format(titel=kopf["titel"], navigation=navigation,
                          inhalt=inhalt, owner=kopf.get("owner", "unbekannt"))
    (ZIEL / f"{name}.html").write_text(html, encoding="utf-8")
print(len(seiten), "Seiten gebaut:", ", ".join(f"{n}.html" for _, n, _, _ in seiten))
```

Ich habe das Skript mit zwei Seiten ausgeführt (Neustart mit Reihenfolge eins und Backup mit Reihenfolge zwei). Es meldete „2 Seiten gebaut: neustart.html, backup.html“. Beide Seiten enthalten dieselbe Navigation, die Seite Neustart enthält ihre Tabelle, und der Verweis auf `backup.md` zeigt nun auf `backup.html`. Die Seite Backup hat im Fuß „Owner: unbekannt“, weil ihr Kopf keinen Owner enthält: Das ist genau die Art von Lücke, die ein SSG sichtbar machen kann, und man könnte das Skript so erweitern, dass es bei fehlendem Owner den Bau abbricht.

Dieses Spielzeug zeigt die Bausteine, die echte Generatoren professioneller liefern: Konfiguration (Titel, Navigation, Theme), Vorlagen, Erweiterungen (Tabellen, Hinweisboxen, Diagramme), Suche, Mehrsprachigkeit und Versionierung. In Projekten nutzt man dafür keinen Eigenbau, sondern ein gepflegtes Werkzeug. Der Wert des Selbstbaus liegt im Verständnis: Wer weiß, was ein Generator tut, findet Fehler schneller und beurteilt Werkzeuge nüchterner.

Typische Fehler: Verweise zwischen Seiten funktionieren im Editor, aber nicht im erzeugten HTML; die Navigation wird von Hand gepflegt und weicht ab; Bilder werden mit absoluten Pfaden eingebunden, die nur auf einem Rechner stimmen; das Werkzeug wird gewählt, weil es gerade beliebt ist, nicht weil es zum Team passt.

| **Falsch**                                    | **Richtig**                                                                     |
|:----------------------------------------------|:--------------------------------------------------------------------------------|
| Verweis `[Backup](C:/Doku/backup.md)` mit absolutem Laufwerkspfad. | Relativer Verweis `[Backup](backup.md)`, den der Generator beim Bau auf `backup.html` umschreibt. |

Im Projekt ist ein SSG sinnvoll, wenn Dokumentation als durchsuchbare Webseite für Entwickler oder Betrieb erscheinen soll und im Repository gepflegt wird. Er ersetzt kein Wiki, wenn viele Nicht-Techniker direkt bearbeiten sollen.

## 11.7 PDF und HTML Export

Dieselbe Dokumentation wird oft in mehreren Formaten gebraucht: HTML für das Lesen am Bildschirm und die Suche, PDF für Archivierung, Freigabe und Weitergabe an Dritte, Word für die Bearbeitung durch Fachbereiche. Der Grundsatz dahinter heißt *Single Source*: Der Inhalt liegt einmal in einer Quelle (meist Markdown), die Formate werden daraus erzeugt, nie von Hand nachbearbeitet. Wer ein erzeugtes PDF von Hand ändert, hat zwei Wahrheiten, und beim nächsten Export gehen die Änderungen verloren.

HTML und PDF unterscheiden sich im Wesen. HTML ist *fließend*: Es passt sich der Fenstergröße an, enthält Verknüpfungen und ist für Suchmaschinen und Vorleseprogramme geeignet. PDF ist *seitenfest*: Es sieht überall gleich aus und eignet sich für Nachweise, Ausdruck und Archivierung. Für beides gilt, dass Barrierefreiheit nicht von selbst entsteht, sondern aus der Struktur der Quelle: echte Überschriften, Alternativtexte für Bilder, Dokumentsprache und Dokumenttitel.

> **Ergänzung aus der Nachrecherche**
>
> Zur Archivierung und Barrierefreiheit von PDF nach einem abgerufenen Leitfaden der PDF Association (2025): PDF/A ist der Archivierungsstandard (ISO 19005), PDF/UA der Standard für barrierefreie PDF (ISO 14289). Wegen zunehmender Anforderungen an zugängliche Dokumente fragen Archivfachleute und Barrierefreiheitsverantwortliche zunehmend, wie sich beide Normen zugleich erfüllen lassen; der Leitfaden gibt dazu Hinweise und eine Tabelle, welche Versionen beider Normen kombinierbar sind. Ob ein bestimmtes Exportwerkzeug diese Normen einhält, muss man mit einem Prüfwerkzeug nachweisen und nicht annehmen. In diesem Skript habe ich keine Konformität zu PDF/A oder PDF/UA erzeugt oder geprüft. (Abruf 28.10.2026, siehe Quellenverzeichnis.)

Das folgende Skript erzeugt aus der Markdown-Anleitung per Pandoc zugleich HTML und PDF und meldet für beide, ob der Export gelungen ist. Pandoc ist ein Umwandlungsprogramm für Textformate; es liest Markdown und schreibt unter anderem HTML, PDF (über LaTeX), Word und viele weitere. Das Skript ruft es über `subprocess` auf, prüft den Rückgabewert und gibt eine Fehlermeldung aus, falls etwas schiefgeht.

```python
import subprocess, sys
from pathlib import Path

quelle = Path(sys.argv[1])
ziel = Path("ausgabe")
ziel.mkdir(exist_ok=True)

def pandoc(*args):
    r = subprocess.run(["pandoc", *args], capture_output=True, text=True)
    if r.returncode != 0:
        print("FEHLER:", r.stderr.strip()[:200])
    return r.returncode == 0

ok_html = pandoc(str(quelle), "-s", "--toc", "--metadata", "lang=de",
                 "--metadata", "title=Anleitung Neustart",
                 "-o", str(ziel / "anleitung.html"))
ok_pdf = pandoc(str(quelle), "--metadata", "lang=de",
                "-V", "documentclass=scrartcl", "--toc",
                "-o", str(ziel / "anleitung.pdf"))
for name, ok in (("HTML", ok_html), ("PDF", ok_pdf)):
    print(name, "erzeugt" if ok else "fehlgeschlagen")
```

Die Option `-s` erzeugt ein vollständiges HTML-Dokument statt eines Schnipsels, `--toc` fügt ein Inhaltsverzeichnis ein, `lang=de` setzt die Dokumentsprache, die für Silbentrennung, Vorlesen und Rechtschreibprüfung wichtig ist. Das Skript meldete „HTML erzeugt“ und „PDF erzeugt“. Das HTML enthält das Sprachattribut und ein Inhaltsverzeichnis, das PDF hat eine Seite und beginnt mit dem Inhaltsverzeichnis. Beim Prüfen mit `pdfinfo` fiel allerdings auf, dass das Feld *Title* der PDF-Metadaten leer ist. Die Ursache liegt in der Quelle: Die Kopfdaten verwenden das Feld `titel`, Pandoc erwartet `title`. Das ist ein gutes Beispiel dafür, dass ein Export „erfolgreich“ sein kann und trotzdem Qualitätsmängel hat: Ein PDF ohne Titel in den Metadaten ist für Vorleseprogramme und Archive schlechter nutzbar. Die Lösung ist, den Titel im Export mitzugeben (wie beim HTML geschehen) oder die Kopfdaten an die Erwartung des Werkzeugs anzupassen.

Typische Fehler: Das PDF wird von Hand nachbearbeitet; der Export läuft nur auf dem Rechner einer Person; Schrift und Sonderzeichen fehlen im PDF, weil die LaTeX-Installation unvollständig ist; Abbildungen ohne Alternativtext; PDF ohne Titel und Sprache in den Metadaten; Dateinamen der Ausgabe ohne Version oder Datum.

| **Falsch**                                                                 | **Richtig**                                                                                                                          |
|:---------------------------------------------------------------------------|:-------------------------------------------------------------------------------------------------------------------------------------|
| PDF in Word geöffnet, Fehler von Hand korrigiert, neu als PDF gespeichert. | Fehler in der Markdown-Quelle korrigiert, Export automatisch neu erzeugt, Dateiname mit Version, Titel und Sprache in den Metadaten. |

Im Projekt gehört der Export in die Pipeline (Abschnitt Docs-as-Code): Bei jedem Release entstehen HTML und PDF automatisch, und das PDF trägt Versionsnummer und Datum im Namen. Für Dokumente mit rechtlicher Bedeutung (Nachweise, Verträge) sollte man vorher klären, ob PDF/A gefordert ist.

## 11.8 Tooling-Troubleshooting

Dieser Abschnitt zeigt, wie man typische Fehlerbilder bei Werkzeugen und Veröffentlichung anhand von Struktur, Aktualität, Zielgruppenfeedback und Review-Kommentaren eingrenzt und daraus Runbook-Schritte für Redaktion, Fachbereich und Betrieb ableitet. Die Methode ist dieselbe wie in den Troubleshooting-Abschnitten der früheren Module: vom Symptom zur wahrscheinlichen Ursache, von dort zu einer Prüfung, die die Ursache bestätigt oder ausschließt, und erst dann zur Korrektur.

Häufige Symptome und ihre naheliegenden Ursachen: „Umlaute sehen kaputt aus“ deutet auf Kodierungsprobleme (Datei nicht in UTF-8, Byte-Order-Mark am Anfang). „Das Inhaltsverzeichnis ist leer oder unvollständig“ deutet auf Überschriften, die nicht als Überschriften ausgezeichnet sind, oder auf einen fehlenden zweiten Übersetzungslauf. „Bilder fehlen im Export“ deutet auf falsche oder absolute Pfade. „Der Export klappt bei mir, aber nicht in der Pipeline“ deutet auf unterschiedliche Werkzeugversionen oder fehlende Pakete. „Die Tabelle erscheint als Text“ deutet auf einen Markdown-Dialekt ohne Tabellenerweiterung oder eine fehlende Leerzeile. „Leser finden die Seite nicht“ verweist auf Titel, Metadaten und Suche (Modul 12 und 15).

Ein großer Teil dieser Probleme lässt sich mit einem Diagnoseskript vor dem Export erkennen. Das folgende Skript prüft jede Markdown-Datei eines Ordners auf Leerzeichen im Dateinamen, Byte-Order-Mark, Windows-Zeilenenden, ungültige Kodierung, fehlende Bilddateien und Sprünge in der Überschriftenhierarchie.

```python
import re, sys
from pathlib import Path

for datei in sorted(Path(sys.argv[1]).glob("*.md")):
    roh = datei.read_bytes()
    befunde = []
    if " " in datei.name:
        befunde.append("Leerzeichen im Dateinamen")
    if roh.startswith(b"\xef\xbb\xbf"):
        befunde.append("UTF-8-BOM am Dateianfang")
    if b"\r\n" in roh:
        befunde.append("Windows-Zeilenenden (CRLF)")
    try:
        text = roh.decode("utf-8-sig")
    except UnicodeDecodeError:
        befunde.append("kein gültiges UTF-8 (vermutlich Latin-1)")
        print(f"{datei.name}: " + "; ".join(befunde))
        continue
    for bild in re.findall(r"!\[[^\]]*\]\(([^)]+)\)", text):
        if not (datei.parent / bild).exists():
            befunde.append(f"Bild fehlt: {bild}")
    ebenen = [len(m) for m in re.findall(r"^(#{1,6}) ", text, re.M)]
    if not ebenen or ebenen[0] != 1:
        befunde.append("erste Überschrift ist keine Ebene 1")
    for a, b in zip(ebenen, ebenen[1:]):
        if b > a + 1:
            befunde.append(f"Überschriftensprung von {a} auf {b}")
    print(f"{datei.name}: " + ("; ".join(befunde) or "ohne Befund"))
```

Ich habe es an vier absichtlich fehlerhaften Beispieldateien ausgeführt. Die erste hatte Byte-Order-Mark, Windows-Zeilenenden und ein Bild, das nicht existiert; die zweite war in Latin-1 gespeichert; die dritte war sauber; die vierte hatte Leerzeichen im Namen, begann ohne Überschrift der ersten Ebene und sprang von Ebene zwei auf vier. Das Skript meldete genau diese Befunde und für die dritte Datei „ohne Befund“. Die Prüfung der Kodierung funktioniert über den Versuch, die Datei als UTF-8 zu lesen: Gelingt er nicht, ist die Datei in einer anderen Kodierung gespeichert. Wichtig ist die Grenze: Das Skript findet technische Auffälligkeiten, aber keine inhaltlichen Fehler, und es ersetzt weder Review noch Leserfeedback.

Als Runbook für Redaktion, Fachbereich und Betrieb ergibt sich folgende Reihenfolge: zuerst das Symptom reproduzieren und notieren, welche Datei und welcher Schritt betroffen sind; dann Werkzeugversionen vergleichen (lokal gegen Pipeline); dann das Diagnoseskript über die Quellen laufen lassen; dann einen minimalen Ausschnitt exportieren, um den Fehler einzugrenzen; erst danach die Quelle korrigieren und den Export wiederholen. Die Ursache wird als Prüfregel in die Pipeline aufgenommen, damit der Fehler nicht wiederkehrt.

Typische Fehler: Man korrigiert das Ergebnis statt der Quelle; man ändert mehrere Dinge gleichzeitig und weiß danach nicht, was geholfen hat; man dokumentiert die Lösung nicht, sodass derselbe Fehler später wieder auftritt; die Pipeline meldet Fehler, die niemand liest.

| **Falsch**                                                                        | **Richtig**                                                                                                                       |
|:----------------------------------------------------------------------------------|:----------------------------------------------------------------------------------------------------------------------------------|
| Umlaute im PDF sind kaputt, also wird das PDF in einem Editor von Hand repariert. | Kodierung der Quelle prüfen, auf UTF-8 umstellen, Export neu erzeugen und eine Prüfregel für Kodierung in die Pipeline aufnehmen. |

Im Projekt ist die Einrichtung einer Prüfstufe vor dem Export die lohnendste Investition: Sie fängt die häufigsten Fehler ab, bevor ein Leser sie sieht.

## Übungsaufgaben

Die Aufgaben steigen von Verständnisfragen (1 bis 3) über Anwendungsaufgaben (4 bis 5) bis zu Programmier- und Transferaufgaben (6 bis 8) an.

**Aufgabe 1.** *(leicht)* Erklären Sie in eigenen Worten den Unterschied zwischen Struktur und Aussehen und ordnen Sie Markdown, LaTeX und Word danach ein.

**Aufgabe 2.** *(leicht)* Was bedeutet „Single Source“, und welches Risiko entsteht, wenn ein erzeugtes PDF von Hand nachbearbeitet wird?

**Aufgabe 3.** *(leicht bis mittel)* Nennen Sie je zwei Vor- und Nachteile von Wiki, Word und Docs-as-Code für eine Betriebsdokumentation.

**Aufgabe 4.** *(mittel)* Schreiben Sie eine Markdown-Seite (Überschrift, Aufzählung, nummerierte Liste, Tabelle, Verweis, Front Matter mit Titel und Owner) für eine Anleitung Ihrer Wahl und wandeln Sie sie mit Pandoc in HTML um.

**Aufgabe 5.** *(mittel)* Entscheiden Sie für drei Dokumente (Notfallplan für die Geschäftsleitung, Entwicklerhandbuch, FAQ für Support-Mitarbeiter) jeweils Format und Werkzeug und begründen Sie die Wahl.

**Aufgabe 6.** *(mittel, praktisch)* Erweitern Sie das Wiki-Prüfskript um eine Regel, die Seiten ohne Owner meldet (Feld `owner` im Kopf fehlt oder ist leer).

**Aufgabe 7.** *(anspruchsvoll, praktisch)* Erweitern Sie das Static-Site-Skript so, dass es bei fehlendem Owner mit einer Fehlermeldung abbricht und einen von Null verschiedenen Rückgabewert liefert, und erzeugen Sie zusätzlich eine Seite `index.html` mit einer Liste aller Seiten.

**Aufgabe 8.** *(anspruchsvoll, Transfer)* Ihre Organisation hat 300 Word-Dokumente, 80 Wiki-Seiten und ein Repository mit 40 Markdown-Dateien. Entwerfen Sie einen Plan, wie daraus eine Single-Source-Struktur mit HTML- und PDF-Ausgabe werden könnte, und nennen Sie die Risiken.

## Lösungen und Erläuterungen

**Lösung zu Aufgabe 1.** Struktur beschreibt, was ein Textteil *ist* (Überschrift, Liste, Tabelle), Aussehen beschreibt, *wie* er dargestellt wird (Schrift, Farbe, Abstand). Markdown beschreibt fast nur Struktur; das Aussehen kommt vom Werkzeug beim Umwandeln. LaTeX trennt beides ebenfalls, erlaubt aber feine Steuerung des Aussehens in der Präambel und in Paketen. In Word gehören Struktur und Aussehen zusammen, wenn man von Hand formatiert; über Formatvorlagen lassen sie sich trennen. Dieser Unterschied entscheidet, wie gut sich Inhalte wiederverwenden und in mehrere Formate umwandeln lassen.

**Lösung zu Aufgabe 2.** Single Source bedeutet, dass der Inhalt genau einmal gepflegt wird und alle Ausgabeformate daraus erzeugt werden. Wird ein erzeugtes PDF von Hand geändert, gibt es zwei Fassungen mit verschiedenem Inhalt. Beim nächsten automatischen Export geht die Änderung verloren, oder sie bleibt unbemerkt in einem Format stehen. Die Korrektur gehört deshalb immer in die Quelle.

**Lösung zu Aufgabe 3.** Wiki: Vorteile sind einfache Bearbeitung im Browser und schnelle Verlinkung; Nachteile sind mangelnde Ordnung und schwache Freigabekontrolle. Word: Vorteile sind Vertrautheit und Änderungsverfolgung; Nachteile sind schlechte Versionierbarkeit und uneinheitliche Formatierung. Docs-as-Code: Vorteile sind Nachvollziehbarkeit, Review und Automatisierung; Nachteile sind die Einstiegshürde für Nicht-Entwickler und der Aufwand für Pipeline und Pflege.

**Lösung zu Aufgabe 4.** Eine mögliche Antwort entspricht dem Markdown-Beispiel dieses Moduls mit eigenem Thema. Prüfen Sie nach dem Umwandeln im HTML, dass die Listen als Listen, die Tabelle als Tabelle und die Überschriften als Überschriften erscheinen. Falls die Tabelle als Text erscheint, fehlt meist die Trennzeile oder die Leerzeile davor.

**Lösung zu Aufgabe 5.** Notfallplan für die Geschäftsleitung: PDF, erzeugt aus einer Quelle, mit Versionsnummer, freigegeben und archiviert; Bearbeitung im Team über Markdown oder Word. Entwicklerhandbuch: Docs-as-Code mit Markdown im Repository und einem Static Site Generator, weil Entwickler im Repository arbeiten und Änderungen mit dem Code zusammenhängen. FAQ für Support: Wiki, weil viele Personen schnell ergänzen müssen und die Inhalte kurzlebig sind. Entscheidend ist die Begründung nach Zielgruppe und Pflegeaufwand.

**Lösung zu Aufgabe 6.** Eine mögliche Ergänzung nach dem Einlesen des Kopfes:

```text
    if not kopf.get("owner"):
        print(f"{datei.stem}: kein Owner gepflegt")
```

Die Zeile gehört in die erste Schleife, direkt nach `kopf = ...`. Der Ausdruck `kopf.get("owner")` liefert `None`, wenn das Feld fehlt, und einen leeren Text, wenn es leer ist; beide gelten in der Bedingung als falsch. Eine Seite mit dem Owner „-“ würde damit nicht erkannt; die Regel prüft nur Vorhandensein, nicht Sinnhaftigkeit.

**Lösung zu Aufgabe 7.** Eine mögliche Ergänzung in der Schleife über die Seiten, vor dem Schreiben:

```text
    if not kopf.get("owner"):
        print(f"FEHLER: {name} hat keinen Owner")
        sys.exit(1)
```

Zusätzlich muss `import sys` ergänzt werden. Die Indexseite entsteht nach der Schleife: Man baut aus den Seiten eine Liste von Verweisen (je Seite ein Listenpunkt mit Link auf die HTML-Datei und dem Titel) und schreibt sie mit derselben Vorlage in die Datei `index.html`. Der Rückgabewert eins ist das übliche Signal für „fehlgeschlagen“ und lässt eine Pipeline abbrechen. Testen Sie beide Fälle: mit und ohne Owner.

**Lösung zu Aufgabe 8.** Ein möglicher Plan in fünf Schritten. Erstens eine Bestandsaufnahme: Welche Dokumente sind aktuell, genutzt und freigegeben (Modul 14 und 17)? Zweitens eine Zielstruktur mit Markdown als Quelle, einem Metadatenmodell und Namenskonventionen. Drittens die Umwandlung in Etappen, beginnend mit den wichtigsten Dokumenten, mit Pandoc für Word nach Markdown und manueller Nacharbeit. Viertens eine Pipeline für HTML und PDF, danach die Abschaltung der alten Ablage mit Weiterleitungen. Fünftens Schulung und ein einfacher Weg für Nicht-Entwickler. Risiken sind Formatierungsverlust bei der Umwandlung (Tabellen, Abbildungen, Kommentare), Widerstand der Autoren, Verlust von Änderungshistorie, doppelte Pflege während der Übergangszeit und die Gefahr, veraltete Dokumente mitzuziehen, statt sie zu archivieren. Pandoc konvertiert Struktur zuverlässig, aber keine komplexe Formatierung; jede umgewandelte Datei muss von Menschen geprüft werden.
