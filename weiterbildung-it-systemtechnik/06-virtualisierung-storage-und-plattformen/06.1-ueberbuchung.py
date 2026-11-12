#!/usr/bin/env python3
"""Rechenhilfe fuer Modul 6, Aufgabe 3 (Dynamic Memory, Ueberbuchung). Nur Standardbibliothek.

Aufruf:  python3 06.1-ueberbuchung.py <Host-RAM GB> <Anzahl VMs> <Maximum je VM GB> [Reserve Host GB]
Beispiel: python3 06.1-ueberbuchung.py 24 4 8 4
Rechne zuerst von Hand. Die Reserve fuer das Host-Betriebssystem ist im Lehrplan-Beispiel NICHT abgezogen (Faktor 1,33);
mit Reserve ist der Faktor hoeher. Das Skript zeigt beide Werte.
"""
import sys


def main(argv):
    if len(argv) not in (4, 5):
        print(__doc__)
        return 2
    try:
        host, anzahl, maxvm = float(argv[1]), int(argv[2]), float(argv[3])
        reserve = float(argv[4]) if len(argv) == 5 else 0.0
    except ValueError as fehler:
        print(f"Eingabefehler: {fehler}")
        return 1
    if host <= 0 or anzahl <= 0 or maxvm <= 0 or reserve < 0 or reserve >= host:
        print("Eingabefehler: Werte muessen positiv sein, Reserve kleiner als Host-RAM.")
        return 1
    summe = anzahl * maxvm
    print(f"Summe der Maximalwerte: {anzahl} x {maxvm:g} GB = {summe:g} GB")
    print(f"Faktor ohne Reserve:    {summe:g} / {host:g} = {summe / host:.2f}")
    if reserve:
        print(f"Faktor mit {reserve:g} GB Reserve fuer den Host: {summe:g} / {host - reserve:g} = {summe / (host - reserve):.2f}")
    if summe > host:
        print("Werden alle Maximalwerte gleichzeitig gebraucht, reicht der Speicher nicht: Speicherdruck, Auslagerung, VMs starten nicht.")
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv))
