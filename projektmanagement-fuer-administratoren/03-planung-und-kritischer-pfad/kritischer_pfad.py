"""Berechnet Anfangs- und Endzeiten, Puffer und den kritischen Pfad aus vorgaenge.csv.

Spalten: id, vorgang, dauer_tage, vorgaenger (mehrere mit ';'). Vorwärtsrechnung (frühester Start/Ende),
Rückwärtsrechnung (spätester Start/Ende), Gesamtpuffer = spätester - frühester Start.
Vorgänge mit Puffer 0 liegen auf dem kritischen Pfad. Annahmen: Ende-Anfang-Beziehungen, keine Kalender (Tage durchgezählt).
Nur Standardbibliothek.
"""
import csv

with open("vorgaenge.csv", newline="", encoding="utf-8") as f:
    zeilen = list(csv.DictReader(f))
v = {z["id"]: dict(name=z["vorgang"], d=int(z["dauer_tage"]),
                   vor=[x for x in z["vorgaenger"].split(";") if x]) for z in zeilen}
ids = [z["id"] for z in zeilen]   # Reihenfolge der Datei ist topologisch geordnet (Vorgänger stehen vorher)

for i in ids:
    es = max((v[p]["ef"] for p in v[i]["vor"]), default=0)
    v[i]["es"], v[i]["ef"] = es, es + v[i]["d"]
ende = max(v[i]["ef"] for i in ids)
for i in reversed(ids):
    nachf = [n for n in ids if i in v[n]["vor"]]
    lf = min((v[n]["ls"] for n in nachf), default=ende)
    v[i]["lf"], v[i]["ls"] = lf, lf - v[i]["d"]

print(f"{'ID':<3} {'Vorgang':<36} {'Dauer':>5} {'FS':>3} {'FE':>3} {'SS':>3} {'SE':>3} {'Puffer':>6}")
for i in ids:
    x = v[i]
    puffer = x["ls"] - x["es"]
    print(f"{i:<3} {x['name']:<36} {x['d']:>5} {x['es']:>3} {x['ef']:>3} {x['ls']:>3} {x['lf']:>3} {puffer:>6}{'  kritisch' if puffer == 0 else ''}")
krit = [i for i in ids if v[i]["ls"] - v[i]["es"] == 0]
print(f"\nProjektdauer: {ende} Tage")
print("Kritischer Pfad:", " -> ".join(krit), f"(Summe {sum(v[i]['d'] for i in krit)} Tage)")
print("Hinweis: Tage sind durchgezählt, Wochenenden und Feiertage sind nicht berücksichtigt.")
