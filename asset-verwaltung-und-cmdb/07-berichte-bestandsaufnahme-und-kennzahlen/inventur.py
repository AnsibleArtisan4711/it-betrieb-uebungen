# Rechenhilfe zu Modul 07: Soll (Verwaltung) gegen Ist (Zählung vor Ort) vergleichen
# und Aktualität nach Stichtag berechnen (Python 3, nur Standardbibliothek)
import csv
from datetime import date

STICHTAG = date(2026, 11, 30)
MAX_ALTER_TAGE = 365

def lies(datei):
    with open(datei, newline="", encoding="utf-8") as f:
        return list(csv.DictReader(f))

soll = {z["seriennr"]: z for z in lies("inventur-soll.csv")}
ist = {z["seriennr"]: z for z in lies("inventur-ist.csv")}

fehlend = sorted(set(soll) - set(ist))
unbekannt = sorted(set(ist) - set(soll))
abweichend = sorted(s for s in set(soll) & set(ist) if soll[s]["standort"] != ist[s]["standort"])

print(f"Soll: {len(soll)}, Ist: {len(ist)}")
print("Fehlend (im Soll, nicht gezählt):")
for s in fehlend:
    print(f"  {s}  {soll[s]['name']}  (Soll-Standort {soll[s]['standort']})")
print("Unbekannt (gezählt, nicht im Soll):")
for s in unbekannt:
    print(f"  {s}  (gefunden in {ist[s]['standort']})")
print("Abweichender Standort:")
for s in abweichend:
    print(f"  {s}  {soll[s]['name']}: Soll {soll[s]['standort']}, Ist {ist[s]['standort']}")

gefunden = len(set(soll) & set(ist))
print(f"Treffer: {gefunden}/{len(soll)} = {gefunden / len(soll) * 100:.1f} %".replace(".", ","))

veraltet = []
for z in soll.values():
    alter = (STICHTAG - date.fromisoformat(z["letzte_pruefung"])).days
    if alter > MAX_ALTER_TAGE:
        veraltet.append((z["name"], alter))
print(f"Aktualität am {STICHTAG.isoformat()} (höchstens {MAX_ALTER_TAGE} Tage seit letzter Prüfung):")
for name, alter in sorted(veraltet):
    print(f"  {name}: {alter} Tage")
aktuell = len(soll) - len(veraltet)
print(f"Aktuell: {aktuell}/{len(soll)} = {aktuell / len(soll) * 100:.1f} %".replace(".", ","))
