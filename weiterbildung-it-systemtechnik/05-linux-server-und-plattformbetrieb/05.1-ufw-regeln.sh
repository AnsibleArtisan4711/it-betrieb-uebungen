#!/bin/bash
# Uebung 05.1, Teil 8: ufw nur mit zweiter offener SSH-Sitzung aktivieren.
# Aufruf:  sudo ./05.1-ufw-regeln.sh [-n]
#   -n   zeigt nur die Befehle (nichts wird geaendert)
# Beide Quellnetze sind noetig: SRV-FS01 routet ohne NAT, die Quelladresse von CL-W11-01 bleibt 192.168.60.x.
# Notausstieg (Hyper-V-Konsole, nicht ueber SSH):  sudo ufw disable
set -euo pipefail

DRY=0
[ "${1:-}" = "-n" ] && DRY=1
run() { if [ "$DRY" -eq 1 ]; then printf "[Trockenlauf] "; printf "%q " "$@"; echo; else "$@"; fi; }

if [ "$DRY" -eq 0 ]; then
    [ "$(id -u)" -eq 0 ] || { echo "Bitte mit sudo ausfuehren."; exit 1; }
    read -r -p "Ist eine ZWEITE SSH-Sitzung offen und die Hyper-V-Konsole erreichbar? (ja/nein) " antwort
    [ "$antwort" = "ja" ] || { echo "Abbruch. Erst zweite Sitzung oeffnen."; exit 1; }
fi

run ufw default deny incoming
run ufw default allow outgoing
run ufw allow from 192.168.50.0/24 to any port 22 proto tcp
run ufw allow from 192.168.60.0/24 to any port 22 proto tcp
if [ "$DRY" -eq 1 ]; then echo "[Trockenlauf] ufw --force enable"; else ufw --force enable; fi
[ "$DRY" -eq 1 ] || ufw status verbose
