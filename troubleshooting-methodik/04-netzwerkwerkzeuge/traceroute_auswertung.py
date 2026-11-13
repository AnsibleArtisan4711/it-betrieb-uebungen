"""Wertet Beispielausgaben im Stil von 'tracert' aus (erfundene Dateien, Format nicht gegen das echte Werkzeug geprüft).

Je Hop: Mittelwert der Antwortzeiten, Zeitüberschreitung, auffälliger Sprung (>= 50 ms gegenüber dem Hop davor).
Wichtig: Sterne am Ende heißen nicht automatisch 'Ziel kaputt': Viele Geräte antworten nicht auf ICMP.
Nur Standardbibliothek.
"""
import re

def hops(datei):
    ergebnis = []
    with open(datei, encoding="utf-8") as f:
        for zeile in f:
            m = re.match(r"\s*(\d+)\s+(.*)$", zeile)
            if not m:
                continue
            rest = m.group(2)
            zeiten = [0.5 if t == "<1" else float(t) for t in re.findall(r"(<1|\d+) ms", rest)]
            stern = rest.count("*")
            ziel = rest.split()[-1] if zeiten else None
            ergebnis.append((int(m.group(1)), zeiten, stern, ziel))
    return ergebnis

for datei in ("tracert_ok.txt", "tracert_fehler.txt"):
    print(f"== {datei}")
    vorher = None
    for nr, zeiten, stern, ziel in hops(datei):
        if zeiten:
            mw = sum(zeiten) / len(zeiten)
            sprung = " SPRUNG" if vorher is not None and mw - vorher >= 50 else ""
            print(f"Hop {nr}: {mw:6.1f} ms  {ziel}{sprung}")
            vorher = mw
        else:
            print(f"Hop {nr}: Zeitüberschreitung ({stern} von 3 Paketen ohne Antwort)")
    letzter = [h for h in hops(datei) if h[1]]
    print(f"Letzter antwortender Hop: {letzter[-1][0]} ({letzter[-1][3]})\n")
