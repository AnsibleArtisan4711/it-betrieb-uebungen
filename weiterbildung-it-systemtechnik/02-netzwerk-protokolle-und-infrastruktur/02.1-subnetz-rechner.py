#!/usr/bin/env python3
"""Kontrollrechner fuer Modul 2, Aufgabe 1 (Subnetting). Nur Standardbibliothek.

Aufruf:
    python3 02.1-subnetz-rechner.py teilen 192.168.50.0/24 26
    python3 02.1-subnetz-rechner.py info 192.168.60.101/24
    python3 02.1-subnetz-rechner.py gleiches-netz 192.168.50.20/24 192.168.60.101/24
Rechne die Aufgabe zuerst von Hand und pruefe dann mit diesem Skript.
"""
import ipaddress
import sys


def teilen(netz: str, praefix: int) -> None:
    n = ipaddress.ip_network(netz, strict=True)
    for sub in n.subnets(new_prefix=praefix):
        hosts = list(sub.hosts())
        print(f"{sub}  Netz-ID {sub.network_address}  Praefix /{sub.prefixlen}  "
              f"Hosts {hosts[0]} bis {hosts[-1]}  Broadcast {sub.broadcast_address}  "
              f"nutzbar {len(hosts)} (2^{32 - sub.prefixlen} - 2)")


def info(adresse: str) -> None:
    i = ipaddress.ip_interface(adresse)
    n = i.network
    print(f"{i}  Netz-ID {n.network_address}  Maske {n.netmask}  Broadcast {n.broadcast_address}")


def gleiches_netz(a: str, b: str) -> None:
    ia, ib = ipaddress.ip_interface(a), ipaddress.ip_interface(b)
    print(f"{ia} liegt in {ia.network}; {ib} liegt in {ib.network}; "
          f"gleiches Netz: {'ja' if ia.network == ib.network else 'nein'}")


if __name__ == "__main__":
    befehl = sys.argv[1] if len(sys.argv) > 1 else ""
    try:
        if befehl == "teilen" and len(sys.argv) == 4:
            teilen(sys.argv[2], int(sys.argv[3]))
        elif befehl == "info" and len(sys.argv) == 3:
            info(sys.argv[2])
        elif befehl == "gleiches-netz" and len(sys.argv) == 4:
            gleiches_netz(sys.argv[2], sys.argv[3])
        else:
            print(__doc__)
            sys.exit(2)
    except ValueError as fehler:
        print(f"Eingabefehler: {fehler}")
        sys.exit(1)
