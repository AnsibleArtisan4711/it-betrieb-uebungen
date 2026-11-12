#!/usr/bin/env python3
"""Rechenhilfe fuer Modul 8 (Kapazitaet, RPO/RTO). Nur Standardbibliothek.

Aufrufe:
  python3 08.1-kapazitaet-und-rto.py tage <frei GB> <Wachstum GB pro Tag> <Alarmgrenze GB>
  python3 08.1-kapazitaet-und-rto.py werte <csv-Datei> <Spalte>
  python3 08.1-kapazitaet-und-rto.py rto <Sicherung min> <Wiederherstellung min> <Vorbereitung min> <Pruefung min> [erlaubter Ausfall h]
Beispiele:
  python3 08.1-kapazitaet-und-rto.py tage 40 0.5 10        # Aufgabe 3 (Papieruebung): 60 Tage
  python3 08.1-kapazitaet-und-rto.py rto 12 8 30 15 4
Rechne zuerst von Hand.
"""
import csv
import statistics
import sys


def tage(argv):
    frei, wachstum, grenze = (float(x.replace(",", ".")) for x in argv)
    if wachstum <= 0:
        print("Eingabefehler: Wachstum muss > 0 sein.")
        return 1
    if frei <= grenze:
        print("Die Alarmgrenze ist bereits erreicht oder unterschritten.")
        return 0
    t = (frei - grenze) / wachstum
    print(f"({frei:g} - {grenze:g}) / {wachstum:g} = {t:g} Tage bis zur Alarmgrenze")
    return 0


def werte(argv):
    datei, spalte = argv
    with open(datei, newline="", encoding="utf-8-sig") as f:
        zahlen = [float(z[spalte].replace(",", ".")) for z in csv.DictReader(f)]
    if not zahlen:
        print("Keine Werte.")
        return 1
    print(f"n={len(zahlen)}  Mittelwert={statistics.mean(zahlen):.2f}  Minimum={min(zahlen):g}  "
          f"Maximum={max(zahlen):g}  Spanne={max(zahlen) - min(zahlen):g}")
    return 0


def rto(argv):
    sich, wied, vorb, pruef = (float(x) for x in argv[:4])
    erlaubt = float(argv[4]) if len(argv) > 4 else None
    gesamt = wied + vorb + pruef
    print(f"Sicherung dauert {sich:g} min (taeglich -> RPO hoechstens 24 h Datenverlust)")
    print(f"RTO (gemessene Wiederherstellung {wied:g} + Vorbereitung {vorb:g} + Pruefung {pruef:g}) = {gesamt:g} min = {gesamt / 60:.2f} h")
    if erlaubt is not None:
        print(f"Erlaubter Ausfall {erlaubt:g} h: RTO {'passt' if gesamt / 60 <= erlaubt else 'passt NICHT'}.")
        print("Ob ein RPO von 24 h (Datenverlust bis zu einem Tag) fuer den Betrieb tragbar ist, ist eine eigene Frage: im Betrieb klaeren.")
    return 0


if __name__ == "__main__":
    try:
        modus = sys.argv[1] if len(sys.argv) > 1 else ""
        a = sys.argv[2:]
        if modus == "tage" and len(a) == 3:
            sys.exit(tage(a))
        if modus == "werte" and len(a) == 2:
            sys.exit(werte(a))
        if modus == "rto" and len(a) in (4, 5):
            sys.exit(rto(a))
        print(__doc__)
        sys.exit(2)
    except (ValueError, KeyError, OSError) as fehler:
        print(f"Eingabefehler: {fehler}")
        sys.exit(1)
