#!/usr/bin/env python3
"""Gewichtete Entscheidungsmatrix für Stellen oder Angebote (Python 3, ohne Fremdpakete).

Aufruf:  python entscheidung.py datei.csv

CSV-Spalten: kriterium,art,gewicht,<Name Angebot 1>,<Name Angebot 2>,...
  art      muss | soll | kann
  gewicht  ganze Zahl 1 bis 5 (bei "muss" ohne Wirkung auf die Summe)
  Werte    bei "muss": 1 = erfüllt, 0 = nicht erfüllt (das Angebot scheidet aus)
           bei "soll" und "kann": Punkte 1 bis 5

Die Summe ist die Summe aus Gewicht mal Punkte über alle Soll- und Kann-Kriterien.
Die Zahlen sind eine Entscheidungshilfe und ersetzen die Entscheidung nicht.
"""
import csv
import sys


def lesen(pfad):
    with open(pfad, encoding="utf-8", newline="") as f:
        zeilen = list(csv.DictReader(f))
    if not zeilen:
        sys.exit("Fehler: Datei ohne Zeilen")
    spalten = list(zeilen[0].keys())
    if spalten[:3] != ["kriterium", "art", "gewicht"] or len(spalten) < 4:
        sys.exit("Fehler: Spalten müssen kriterium,art,gewicht und mindestens ein Angebot heißen")
    return zeilen, spalten[3:]


def pruefen(zeilen, angebote):
    for z in zeilen:
        art = z["art"].strip()
        if art not in ("muss", "soll", "kann"):
            sys.exit("Fehler: art muss muss, soll oder kann sein: %s" % z["kriterium"])
        gew = int(z["gewicht"])
        if not 1 <= gew <= 5:
            sys.exit("Fehler: Gewicht außerhalb 1 bis 5: %s" % z["kriterium"])
        for a in angebote:
            w = int(z[a])
            if art == "muss" and w not in (0, 1):
                sys.exit("Fehler: Muss-Kriterium nur mit 0 oder 1: %s" % z["kriterium"])
            if art != "muss" and not 1 <= w <= 5:
                sys.exit("Fehler: Punkte außerhalb 1 bis 5: %s" % z["kriterium"])


def main(pfad):
    zeilen, angebote = lesen(pfad)
    pruefen(zeilen, angebote)
    muss = [z for z in zeilen if z["art"].strip() == "muss"]
    wertung = [z for z in zeilen if z["art"].strip() != "muss"]
    maximum = sum(5 * int(z["gewicht"]) for z in wertung)
    print("Kriterien: %d Muss, %d Soll/Kann" % (len(muss), len(wertung)))
    if len(muss) != 1:
        print("Hinweis: Dieser Kurs empfiehlt genau ein Muss-Kriterium (gefunden: %d)." % len(muss))
    print()
    ergebnis = []
    for a in angebote:
        ausgeschieden = [z["kriterium"] for z in muss if int(z[a]) == 0]
        summe = sum(int(z["gewicht"]) * int(z[a]) for z in wertung)
        ergebnis.append((a, summe, ausgeschieden))
    breite = max(len(a) for a in angebote)
    print("%-*s %8s %8s  %s" % (breite, "Angebot", "Summe", "Prozent", "Muss-Kriterium"))
    for a, summe, aus in ergebnis:
        status = "ausgeschieden: " + "; ".join(aus) if aus else "erfüllt"
        print("%-*s %4d/%-3d %7.1f%%  %s" % (breite, a, summe, maximum, 100.0 * summe / maximum, status))
    zulaessig = [e for e in ergebnis if not e[2]]
    print()
    if not zulaessig:
        print("Kein Angebot erfüllt das Muss-Kriterium.")
    else:
        beste = max(zulaessig, key=lambda e: e[1])
        gleich = [e[0] for e in zulaessig if e[1] == beste[1]]
        if len(gleich) > 1:
            print("Gleichstand: " + ", ".join(gleich))
        else:
            print("Höchste Summe unter den zulässigen Angeboten: %s" % beste[0])


if __name__ == "__main__":
    if len(sys.argv) != 2:
        sys.exit("Aufruf: python entscheidung.py datei.csv")
    main(sys.argv[1])
