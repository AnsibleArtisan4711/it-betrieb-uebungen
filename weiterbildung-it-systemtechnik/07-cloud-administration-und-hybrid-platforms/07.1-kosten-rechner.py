#!/usr/bin/env python3
"""Rechenhilfe fuer Modul 7, Aufgabe 7 (Monatskosten einer VM). Nur Standardbibliothek.

Aufruf:   python3 07.1-kosten-rechner.py <Preis je Stunde> <Stunden pro Tag> [Tage pro Monat]
Der STUNDENPREIS stammt aus dem Preisrechner des Anbieters (Datum notieren) - er steht hier absichtlich nicht
als Beispiel, weil Preise sich aendern. Zum Ueben kannst du einen frei erfundenen Wert wie 0,10 verwenden;
dann ist das Ergebnis nur eine Uebungszahl.
Tage pro Monat: Standard 30.
"""
import sys


def main(argv):
    if len(argv) not in (3, 4):
        print(__doc__)
        return 2
    try:
        preis = float(argv[1].replace(",", "."))
        stunden = float(argv[2].replace(",", "."))
        tage = float(argv[3]) if len(argv) == 4 else 30.0
    except ValueError as fehler:
        print(f"Eingabefehler: {fehler}")
        return 1
    if preis < 0 or not (0 <= stunden <= 24) or tage <= 0:
        print("Eingabefehler: Preis >= 0, Stunden zwischen 0 und 24, Tage > 0.")
        return 1
    dauerbetrieb = preis * 24 * tage
    teilbetrieb = preis * stunden * tage
    print(f"Dauerbetrieb (24 h x {tage:g} Tage):        {dauerbetrieb:8.2f}")
    print(f"Betrieb {stunden:g} h pro Tag ({tage:g} Tage):    {teilbetrieb:8.2f}")
    if dauerbetrieb:
        print(f"Anteil gegenueber Dauerbetrieb:            {100 * teilbetrieb / dauerbetrieb:7.1f} %")
    print("Hinweis: Datentraeger und oeffentliche Adresse kosten auch bei gestoppter (nicht freigegebener) VM; Freigeben ist nicht dasselbe wie Stoppen (nicht bestaetigt, Preisseite pruefen).")
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv))
