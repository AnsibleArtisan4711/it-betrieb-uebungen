#!/usr/bin/env python3
"""Uebung 12.1, Teil 1 und 4: gewichtete Bewertung (Entscheidungsmatrix).

ACHTUNG: Das Ergebnis ist DEINE Einschaetzung mit DEINEN Gewichten, keine Marktdaten.
Eingabe: CSV mit einer Kopfzeile  Option,<Kriterium1>,<Kriterium2>,...  und einer ersten Datenzeile
  'Gewicht', die die Gewichte (ganze oder Dezimalzahlen > 0) enthaelt. Alle weiteren Zeilen: Bewertungen 1 bis 5.
Aufruf:  python3 12.1-gewichtung.py datei.csv
Ausgabe: Rangliste mit gewichteter Summe und Anteil am Maximum. Das Skript liest nur.
"""
import csv
import sys


def lies(pfad):
    with open(pfad, newline="", encoding="utf-8") as f:
        zeilen = list(csv.reader(f))
    if len(zeilen) < 3:
        raise ValueError("Mindestens Kopfzeile, Gewichtszeile und eine Option noetig.")
    kopf = zeilen[0]
    if kopf[0] != "Option" or len(kopf) < 2:
        raise ValueError("Erste Spalte der Kopfzeile muss 'Option' heissen, danach mindestens ein Kriterium.")
    if zeilen[1][0] != "Gewicht":
        raise ValueError("Zweite Zeile muss mit 'Gewicht' beginnen.")
    n = len(kopf) - 1
    gew = [float(x) for x in zeilen[1][1:]]
    if len(gew) != n or any(g <= 0 for g in gew):
        raise ValueError("Gewichte: je Kriterium eine Zahl groesser 0.")
    optionen = []
    for z in zeilen[2:]:
        if len(z) != n + 1:
            raise ValueError(f"Zeile '{z[0] if z else ''}' hat nicht {n} Bewertungen.")
        w = [float(x) for x in z[1:]]
        if any(not 1 <= x <= 5 for x in w):
            raise ValueError(f"Bewertungen in '{z[0]}' muessen zwischen 1 und 5 liegen.")
        optionen.append((z[0], w))
    return kopf[1:], gew, optionen


def main():
    if len(sys.argv) != 2:
        print("Aufruf: python3 12.1-gewichtung.py datei.csv")
        return 2
    try:
        kriterien, gew, optionen = lies(sys.argv[1])
    except (OSError, ValueError) as e:
        print(f"Eingabefehler: {e}")
        return 1
    maximum = 5 * sum(gew)
    ergebnis = sorted(((sum(g * b for g, b in zip(gew, w)), name) for name, w in optionen), reverse=True)
    print("Eigene Einschaetzung, keine Marktdaten. Kriterien: " + ", ".join(kriterien))
    for i, (summe, name) in enumerate(ergebnis, 1):
        print(f"{i}. {name}: {summe:g} von {maximum:g} ({100 * summe / maximum:.0f} %)")
    return 0


if __name__ == "__main__":
    sys.exit(main())
