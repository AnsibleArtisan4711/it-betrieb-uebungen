#!/usr/bin/env python3
"""Rücklaufquote aus dem Bewerbungs-Tracker (Python 3, ohne Fremdpakete).

Aufruf:  python tracker_auswerten.py tracker.csv

CSV-Spalten: datum,firma,kanal,art,status
  kanal   zum Beispiel portal, direkt, netzwerk, vermittler
  art     bewerbung | kontaktanfrage
  status  offen | reaktion | einladung | absage

Definition in diesem Kurs: Rücklaufquote = Einträge mit Reaktion (status reaktion,
einladung oder absage) geteilt durch alle Einträge. Einladungsquote = Einladungen
geteilt durch alle Bewerbungen. Kleine Zahlen sind keine Statistik.
"""
import csv
import sys
from collections import OrderedDict

REAKTION = ("reaktion", "einladung", "absage")


def lesen(pfad):
    with open(pfad, encoding="utf-8", newline="") as f:
        zeilen = list(csv.DictReader(f))
    for z in zeilen:
        if z["status"] not in ("offen",) + REAKTION:
            sys.exit("Fehler: unbekannter Status: %s" % z["status"])
        if z["art"] not in ("bewerbung", "kontaktanfrage"):
            sys.exit("Fehler: unbekannte Art: %s" % z["art"])
    return zeilen


def quote(teil, gesamt):
    return 100.0 * teil / gesamt if gesamt else 0.0


def main(pfad):
    zeilen = lesen(pfad)
    gesamt = len(zeilen)
    reakt = sum(1 for z in zeilen if z["status"] in REAKTION)
    print("Einträge gesamt: %d" % gesamt)
    print("Rücklaufquote gesamt: %d von %d = %.1f%%" % (reakt, gesamt, quote(reakt, gesamt)))
    bew = [z for z in zeilen if z["art"] == "bewerbung"]
    einl = sum(1 for z in bew if z["status"] == "einladung")
    print("Einladungsquote (nur Bewerbungen): %d von %d = %.1f%%" % (einl, len(bew), quote(einl, len(bew))))
    print()
    kanaele = OrderedDict()
    for z in zeilen:
        kanaele.setdefault(z["kanal"], []).append(z)
    print("%-12s %8s %10s %9s" % ("Kanal", "Einträge", "Reaktion", "Quote"))
    for k, liste in kanaele.items():
        r = sum(1 for z in liste if z["status"] in REAKTION)
        print("%-12s %8d %10d %8.1f%%" % (k, len(liste), r, quote(r, len(liste))))


if __name__ == "__main__":
    if len(sys.argv) != 2:
        sys.exit("Aufruf: python tracker_auswerten.py tracker.csv")
    main(sys.argv[1])
