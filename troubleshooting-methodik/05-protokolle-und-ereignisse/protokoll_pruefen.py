"""Wertet app_protokoll.log aus: Anzahl je Stufe, erster Fehler, häufigste Meldung, Fehler je Minute.

Zeilenformat: 'JJJJ-MM-TT hh:mm:ss STUFE quelle: text'. Das Ergebnis ist eine Zusammenfassung zum Einstieg;
die Ursache steht oft NICHT in der ersten, sondern in der Zeile davor oder in einem anderen System.
Nur Standardbibliothek.
"""
import re
from collections import Counter

stufen = Counter()
meldungen = Counter()
pro_minute = Counter()
erster = None
with open("app_protokoll.log", encoding="utf-8") as f:
    for zeile in f:
        m = re.match(r"(\S+ \S+) (\w+)\s+(\w+): (.*)$", zeile.strip())
        if not m:
            continue
        zeit, stufe, quelle, text = m.groups()
        stufen[stufe] += 1
        if stufe == "ERROR":
            meldungen[text] += 1
            pro_minute[zeit[:16]] += 1
            if erster is None:
                erster = (zeit, text)

print("Zeilen je Stufe:", dict(sorted(stufen.items())))
print("Erster Fehler:", erster[0], "-", erster[1])
text, anzahl = meldungen.most_common(1)[0]
print(f"Häufigste Fehlermeldung ({anzahl}x): {text}")
print("Fehler je Minute:")
for minute, n in sorted(pro_minute.items()):
    print(f"  {minute} {'#' * n} ({n})")
