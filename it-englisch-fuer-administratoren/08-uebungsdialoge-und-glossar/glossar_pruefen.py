"""Prüft glossar.csv und gibt das Glossar nach Bereichen sortiert aus.

Prüfungen: leere Felder, doppelte deutsche Begriffe, doppelte englische Begriffe. Ausgabe: Zahl der Einträge je Bereich
und die Tabelle Deutsch-Englisch alphabetisch je Bereich. Nur Standardbibliothek.
"""
import csv
from collections import defaultdict

with open("glossar.csv", newline="", encoding="utf-8") as f:
    eintraege = list(csv.DictReader(f))

probleme = []
for key in ("deutsch", "englisch"):
    gesehen = set()
    for e in eintraege:
        wert = e[key].strip().lower()
        if not wert:
            probleme.append(f"leeres Feld {key}")
        if wert in gesehen:
            probleme.append(f"doppelt ({key}): {e[key]}")
        gesehen.add(wert)

bereiche = defaultdict(list)
for e in eintraege:
    bereiche[e["bereich"]].append(e)

print(f"{len(eintraege)} Einträge in {len(bereiche)} Bereichen")
print("Probleme:", "keine" if not probleme else "; ".join(probleme))
for bereich in sorted(bereiche):
    print(f"\n{bereich} ({len(bereiche[bereich])})")
    for e in sorted(bereiche[bereich], key=lambda x: x["deutsch"].lower()):
        print(f"  {e['deutsch']:<22} {e['englisch']}")
