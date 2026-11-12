#!/bin/bash
# Uebung 05.1, Teil 3: gemeinsames Verzeichnis mit Setgid, Gruppe und zwei Benutzern.
# Aufruf:  sudo ./05.1-gruppe-und-rechte.sh [-n] [Basisordner]
#   -n   zeigt nur die Befehle (nichts wird geaendert)
# Es werden KEINE Kennwoerter gesetzt: die Benutzer sind gesperrt (--disabled-password). Fuer die
# Anmeldung setzt du das Kennwort selbst interaktiv:  sudo passwd labuser01
# Rueckbau: ./05.1-gruppe-und-rechte.sh -r [Basisordner]  (entfernt NUR die hier angelegten Benutzer, Gruppe und den Ordner,
# wenn er leer ist).
set -euo pipefail

DRY=0; RUECK=0
while getopts "nr" opt; do
    case "$opt" in n) DRY=1 ;; r) RUECK=1 ;; *) echo "Aufruf: $0 [-n|-r] [Basisordner]"; exit 2 ;; esac
done
shift $((OPTIND - 1))
BASIS="${1:-/srv/lab/shared}"

run() { if [ "$DRY" -eq 1 ]; then printf "[Trockenlauf] "; printf "%q " "$@"; echo; else "$@"; fi; }

if [ "$(id -u)" -ne 0 ] && [ "$DRY" -eq 0 ]; then echo "Bitte mit sudo ausfuehren."; exit 1; fi

if [ "$RUECK" -eq 1 ]; then
    for u in labuser01 labuser02; do
        id "$u" >/dev/null 2>&1 && run deluser --remove-home "$u"
    done
    getent group labgrp >/dev/null && run delgroup labgrp
    [ -d "$BASIS" ] && run rmdir "$BASIS"
    echo "Rueckbau beendet."
    exit 0
fi

getent group labgrp >/dev/null || run addgroup labgrp
for u in labuser01 labuser02; do
    id "$u" >/dev/null 2>&1 || run adduser --disabled-password --gecos "" "$u"
done
run usermod -aG labgrp labuser01          # labuser02 bleibt BEWUSST ohne Gruppe (Negativtest)
run mkdir -p "$BASIS"
run chgrp labgrp "$BASIS"
run chmod 2770 "$BASIS"
[ "$DRY" -eq 1 ] || ls -ld "$BASIS"
