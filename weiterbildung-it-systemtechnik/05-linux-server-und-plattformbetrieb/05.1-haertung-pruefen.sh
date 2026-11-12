#!/bin/bash
# Uebung 05.1, Teil 8: Ist-Zustand lesen (aendert nichts). Aufruf: sudo ./05.1-haertung-pruefen.sh
set -u
echo "== Lauschende Ports =="
ss -tulpn 2>/dev/null || echo "ss nicht verfuegbar"
echo
echo "== sshd: wirksame Einstellungen =="
sshd -T 2>/dev/null | grep -iE "^(permitrootlogin|passwordauthentication|pubkeyauthentication)" || echo "sshd -T nicht verfuegbar oder keine Rechte"
echo
echo "== Firewall =="
if command -v ufw >/dev/null; then ufw status verbose 2>/dev/null || echo "ufw: keine Rechte"; else echo "ufw nicht installiert"; fi
echo
echo "== Paketstand =="
apt list --upgradable 2>/dev/null | tail -n +2 | wc -l | sed 's/^/aktualisierbare Pakete: /'
