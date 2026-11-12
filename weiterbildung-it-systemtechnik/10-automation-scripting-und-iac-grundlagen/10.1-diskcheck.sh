#!/bin/bash
# Uebung 10.1, Teil 3: prueft die Belegung von / gegen einen Grenzwert (nur lesen).
# Aufruf:  ./10.1-diskcheck.sh [Limit-Prozent]     (Standard 80; zum Test z. B. 1)
# Rueckgabe: 0 = OK, 1 = Grenzwert erreicht, 2 = falscher Aufruf
set -euo pipefail
LIMIT="${1:-80}"
case "$LIMIT" in ''|*[!0-9]*) echo "Limit muss eine ganze Zahl sein."; exit 2 ;; esac
USED=$(df --output=pcent / | tail -n 1 | tr -dc '0-9')
if [ "$USED" -ge "$LIMIT" ]; then
    echo "WARNUNG: / zu ${USED}% belegt (Limit ${LIMIT}%)"
    exit 1
fi
echo "OK: / zu ${USED}% belegt (Limit ${LIMIT}%)"
