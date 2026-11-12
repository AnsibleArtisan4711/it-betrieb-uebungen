#!/usr/bin/env python3
"""Uebung 09.1, Teil 2: Schwachstellen nach einer UEBUNGSREGEL ordnen.

ACHTUNG: Die Regel ist eine Lernregel dieser Uebung, KEIN Standard. Reihenfolge der Kriterien:
  1. Ausnutzung bekannt (ja vor nein)
  2. Erreichbarkeit (Internet vor intern)
  3. Schwere laut Hersteller (kritisch > hoch > mittel > niedrig)
Aufruf:  python3 09.1-patch-prioritaet.py            (die drei Meldungen A, B, C der Uebung)
         python3 09.1-patch-prioritaet.py datei.csv  (Spalten: Meldung,Schwere,Erreichbarkeit,Ausnutzung)
Das Skript liest nur und aendert nichts.
"""
import csv
import sys

SCHWERE = {"kritisch": 3, "hoch": 2, "mittel": 1, "niedrig": 0}
ERREICH = {"internet": 1, "intern": 0}
JA = {"ja": 1, "nein": 0}

BEISPIEL = [
    ("A", "kritisch", "internet", "ja"),
    ("B", "hoch", "intern", "nein"),
    ("C", "mittel", "internet", "nein"),
]


def lies(pfad):
    with open(pfad, newline="", encoding="utf-8") as f:
        return [(z["Meldung"], z["Schwere"], z["Erreichbarkeit"], z["Ausnutzung"]) for z in csv.DictReader(f)]


def schluessel(z):
    try:
        return (JA[z[3].lower()], ERREICH[z[2].lower()], SCHWERE[z[1].lower()])
    except KeyError as e:
        raise ValueError(f"Unbekannter Wert {e} in Meldung {z[0]}")


def main():
    try:
        daten = lies(sys.argv[1]) if len(sys.argv) > 1 else BEISPIEL
        geordnet = sorted(daten, key=schluessel, reverse=True)
    except (OSError, ValueError, KeyError) as e:
        print(f"Eingabefehler: {e}")
        return 1
    print("Uebungsregel: 1. Ausnutzung bekannt, 2. Erreichbarkeit, 3. Schwere (kein Standard!)")
    for i, z in enumerate(geordnet, 1):
        print(f"{i}. Meldung {z[0]}: Schwere {z[1]}, {z[2]}, Ausnutzung bekannt: {z[3]}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
