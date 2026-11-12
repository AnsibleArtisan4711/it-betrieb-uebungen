#!/bin/bash
# Uebung 09.1, Teil 1: lauschende Ports auf LX-UBU01 auflisten (nur lesen, aendert nichts).
# Aufruf:  sudo ./09.1-angriffsflaeche.sh        (ohne sudo fehlen die Prozessnamen)
set -euo pipefail
command -v ss >/dev/null || { echo "Das Programm 'ss' fehlt (Paket iproute2)."; exit 1; }
[ "$(id -u)" -eq 0 ] || echo "Hinweis: ohne root sind Prozessnamen nicht sichtbar."
echo "== Lauschende TCP/UDP-Ports =="
ss -tulpn
echo
echo "== Anzahl lauschender Sockets (ohne Kopfzeile) =="
ss -tulnH | wc -l
