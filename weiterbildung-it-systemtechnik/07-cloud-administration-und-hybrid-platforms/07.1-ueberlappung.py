#!/usr/bin/env python3
"""Kontrolle fuer Modul 7, Aufgabe 3 (Adressraeume ueberlappen?). Nur Standardbibliothek.

Aufruf:   python3 07.1-ueberlappung.py <Kandidat> [<Kandidat> ...]
Beispiel: python3 07.1-ueberlappung.py 10.100.0.0/16 192.168.0.0/16 192.168.50.0/24 172.16.0.0/12
Verglichen wird mit den Labornetzen 192.168.50.0/24, 192.168.60.0/24 und 192.168.100.0/24 (NAT-Ersatznetz).
Rechne zuerst auf Papier und pruefe dann.
"""
import ipaddress
import sys

LABOR = ["192.168.50.0/24", "192.168.60.0/24", "192.168.100.0/24"]


def main(argv):
    if len(argv) < 2:
        print(__doc__)
        return 2
    labor = [ipaddress.ip_network(n) for n in LABOR]
    rc = 0
    for text in argv[1:]:
        try:
            netz = ipaddress.ip_network(text, strict=True)
        except ValueError as fehler:
            print(f"{text}: Eingabefehler ({fehler})")
            rc = 1
            continue
        treffer = [str(n) for n in labor if netz.overlaps(n)]
        if treffer:
            print(f"{netz}: UEBERLAPPT mit {', '.join(treffer)}")
        else:
            print(f"{netz}: keine Ueberlappung mit dem Labor")
    return rc


if __name__ == "__main__":
    sys.exit(main(sys.argv))
