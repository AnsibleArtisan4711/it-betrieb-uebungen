#!/bin/bash
# Uebung 08.1, Teil 6: Sicherung von /etc mit tar, Pruefsumme, Teil-Wiederherstellung und Vergleich.
# Aufruf:  sudo ./08.1-linux-sicherung.sh [-q Quellordner] [-z Zielordner] [-d Datei-fuer-Restore]
#   Standard: Quelle /etc, Ziel $HOME des aufrufenden Benutzers, Restore-Datei etc/hostname
# Das Skript AENDERT NICHTS ausser: es schreibt <Ziel>/etc-backup.tar.gz und legt /tmp/restore-test an
# (wird am Ende geloescht). Die Pruefsumme steht neben dem Archiv. Danach: scp auf CL-W11-01 und Get-FileHash.
set -euo pipefail

QUELLE=/etc
ZIEL="${SUDO_USER:+$(getent passwd "$SUDO_USER" | cut -d: -f6)}"
ZIEL="${ZIEL:-$HOME}"
DATEI="etc/hostname"
while getopts "q:z:d:" opt; do
    case "$opt" in q) QUELLE="$OPTARG" ;; z) ZIEL="$OPTARG" ;; d) DATEI="$OPTARG" ;; *) echo "Aufruf: $0 [-q Quelle] [-z Ziel] [-d Datei]"; exit 2 ;; esac
done

[ -d "$QUELLE" ] || { echo "Quelle $QUELLE nicht gefunden."; exit 1; }
[ -d "$ZIEL" ] || { echo "Ziel $ZIEL nicht gefunden."; exit 1; }
ARCHIV="$ZIEL/etc-backup.tar.gz"
BASIS="$(basename "$QUELLE")"

echo "== Sicherung =="
start=$(date +%s)
tar -czf "$ARCHIV" -C "$(dirname "$QUELLE")" "$BASIS"
dauer=$(( $(date +%s) - start ))
( cd "$ZIEL" && sha256sum etc-backup.tar.gz | tee etc-backup.tar.gz.sha256 )
echo "Dauer Sicherung: ${dauer} s, Groesse: $(du -h "$ARCHIV" | cut -f1)"

echo "== Teil-Wiederherstellung von $DATEI =="
TMP=$(mktemp -d /tmp/restore-test.XXXXXX)
trap 'rm -rf "$TMP"' EXIT
tar -xzf "$ARCHIV" -C "$TMP" "$DATEI"
if diff "$(dirname "$QUELLE")/$DATEI" "$TMP/$DATEI" >/dev/null; then
    echo "Vergleich OK: $DATEI ist identisch mit dem Original."
else
    echo "ABWEICHUNG: $DATEI unterscheidet sich vom Original." ; exit 1
fi
echo "== Archivpruefung =="
( cd "$ZIEL" && sha256sum -c etc-backup.tar.gz.sha256 )
