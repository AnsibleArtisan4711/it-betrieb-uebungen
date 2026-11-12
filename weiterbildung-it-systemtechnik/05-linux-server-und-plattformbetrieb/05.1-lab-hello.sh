#!/bin/bash
# Ziel: /usr/local/bin/lab-hello.sh (ausfuehrbar, chmod 755). Uebung 05.1, Teil 5.
# Schreibt alle 30 Sekunden eine Zeile ins Journal (stdout).
while true; do
    echo "lab-hello $(date)"
    sleep 30
done
