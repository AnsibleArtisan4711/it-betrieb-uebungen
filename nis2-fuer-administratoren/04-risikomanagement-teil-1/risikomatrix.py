"""Einfache Risikomatrix aus Eintritt und Auswirkung (Übung 04.1).

Skalen und Klassengrenzen sind ANNAHMEN der Übung und im Dokument zu begründen:
Risiko = Eintritt x Auswirkung (je 1 bis 5); niedrig 1 bis 6, mittel 7 bis 14,
hoch 15 bis 25. Nur Standardbibliothek.
"""
import csv
import os


def klasse(wert):
    if wert >= 15:
        return "hoch"
    if wert >= 7:
        return "mittel"
    return "niedrig"


def main():
    pfad = os.path.join(os.path.dirname(os.path.abspath(__file__)), "systeme-risiko.csv")
    with open(pfad, encoding="utf-8", newline="") as f:
        zeilen = list(csv.DictReader(f))
    for z in zeilen:
        z["Eintritt"] = int(z["Eintritt"])
        z["Auswirkung"] = int(z["Auswirkung"])
        z["Risiko"] = z["Eintritt"] * z["Auswirkung"]
    zeilen.sort(key=lambda z: (-z["Risiko"], -z["Auswirkung"], z["ID"]))
    print("Rangliste (Risiko = Eintritt x Auswirkung, Skalen 1 bis 5, Annahme)\n")
    print(f"{'Rang':4} {'ID':4} {'System':40} {'E':>2} {'A':>2} {'Risiko':>6}  Klasse")
    for rang, z in enumerate(zeilen, 1):
        print(f"{rang:4} {z['ID']:4} {z['System']:40} {z['Eintritt']:2} {z['Auswirkung']:2} {z['Risiko']:6}  {klasse(z['Risiko'])}")
    print("\nMatrix (Zeilen: Eintritt 5 bis 1, Spalten: Auswirkung 1 bis 5, Einträge: System-IDs)")
    print(f"{'':10}" + "".join(f"A={a:<14}" for a in range(1, 6)))
    for e in range(5, 0, -1):
        zellen = []
        for a in range(1, 6):
            ids = ",".join(z["ID"] for z in zeilen if z["Eintritt"] == e and z["Auswirkung"] == a)
            zellen.append(f"{ids or '.':<16}")
        print(f"E={e:<8}" + "".join(zellen))
    anzahl = {}
    for z in zeilen:
        anzahl[klasse(z["Risiko"])] = anzahl.get(klasse(z["Risiko"]), 0) + 1
    print("\nAnzahl je Klasse: " + ", ".join(f"{k} {anzahl.get(k, 0)}" for k in ("hoch", "mittel", "niedrig")))


if __name__ == "__main__":
    main()
