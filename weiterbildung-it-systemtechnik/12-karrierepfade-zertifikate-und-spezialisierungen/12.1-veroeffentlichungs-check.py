#!/usr/bin/env python3
"""Uebung 12.1, Teil 3: einfache Vorpruefung eines Ordners vor der Veroeffentlichung (nur lesen).

ACHTUNG: Heuristik, KEIN Beweis. Sie findet nur bekannte Muster und ersetzt nicht die Durchsicht per Hand.
Sie sucht in Textdateien nach:
  - Kennwort-aehnlichen Zuweisungen (password, passwort, kennwort, secret, token, apikey mit '=' oder ':' und Wert;
    ausgenommen Read-Host und Get-Credential, also interaktive Eingabe)
  - GUID-artigen IDs (moegliche Mandanten-, Subscription-, Geraete-IDs)
  - IPv4-Adressen ausserhalb der privaten Bereiche 10/8, 172.16/12, 192.168/16 (und ausser 127.x, 0.0.0.0)
  - E-Mail-Adressen (ausser @example.* und @users.noreply.github.com)
  - privaten Schluesselbloecken (BEGIN ... PRIVATE KEY)
Aufruf:  python3 -I 12.1-veroeffentlichungs-check.py ORDNER
Rueckgabe: 0 = nichts gefunden, 1 = Fund(e), 2 = Aufruf-/Lesefehler.
"""
import ipaddress
import os
import re
import sys

TEXT_ENDUNGEN = {".md", ".txt", ".ps1", ".sh", ".py", ".csv", ".json", ".yaml", ".yml", ".conf", ".service", ".tex", ".xml", ".ini"}
MAX_BYTES = 2_000_000

MUSTER = {
    "Kennwort/Schluessel-Zuweisung": re.compile(r"(?i)\b(password|passwort|kennwort|secret|token|apikey|api_key)\b\s*[=:]\s*['\"]?(?!Read-Host|Get-Credential)[^\s'\"<>$]{3,}"),
    "GUID": re.compile(r"\b[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}\b"),
    "E-Mail": re.compile(r"\b[\w.+-]+@([\w-]+\.)+[A-Za-z]{2,}\b"),
    "Privater Schluessel": re.compile(r"-----BEGIN [A-Z ]*PRIVATE KEY-----"),
}
IPV4 = re.compile(r"\b(?:\d{1,3}\.){3}\d{1,3}\b")


def oeffentliche_ip(text):
    try:
        ip = ipaddress.ip_address(text)
    except ValueError:
        return False
    return not (ip.is_private or ip.is_loopback or ip.is_unspecified or ip.is_link_local or ip.is_multicast or ip.is_reserved)


def mail_ok(treffer):
    domain = treffer.lower().split("@", 1)[1]
    return domain.startswith("example.") or domain == "example.com" or domain.endswith(".example.internal") or domain == "users.noreply.github.com"


def pruefe_datei(pfad):
    funde = []
    try:
        with open(pfad, encoding="utf-8", errors="replace") as f:
            for nr, zeile in enumerate(f, 1):
                for art, rx in MUSTER.items():
                    for m in rx.finditer(zeile):
                        if art == "E-Mail" and mail_ok(m.group(0)):
                            continue
                        funde.append((nr, art))
                for m in IPV4.finditer(zeile):
                    if oeffentliche_ip(m.group(0)):
                        funde.append((nr, "Oeffentliche IPv4-Adresse"))
    except OSError as e:
        print(f"Lesefehler: {pfad}: {e}")
        return None
    return funde


def main():
    if len(sys.argv) != 2 or not os.path.isdir(sys.argv[1]):
        print("Aufruf: python3 -I 12.1-veroeffentlichungs-check.py ORDNER")
        return 2
    gesamt = 0
    dateien = 0
    for wurzel, ordner, namen in os.walk(sys.argv[1]):
        ordner[:] = [d for d in ordner if d not in {".git"}]
        for n in sorted(namen):
            pfad = os.path.join(wurzel, n)
            if os.path.splitext(n)[1].lower() not in TEXT_ENDUNGEN or os.path.getsize(pfad) > MAX_BYTES:
                continue
            dateien += 1
            funde = pruefe_datei(pfad)
            if funde is None:
                return 2
            for nr, art in funde:
                # Der Treffer selbst wird bewusst NICHT ausgegeben (keine Weitergabe moeglicher Geheimnisse in Logs).
                print(f"{os.path.relpath(pfad, sys.argv[1])}:{nr}: {art}")
                gesamt += 1
    print(f"{dateien} Textdatei(en) geprueft, {gesamt} Fund(e). Heuristik: ersetzt keine Durchsicht per Hand.")
    return 1 if gesamt else 0


if __name__ == "__main__":
    sys.exit(main())
