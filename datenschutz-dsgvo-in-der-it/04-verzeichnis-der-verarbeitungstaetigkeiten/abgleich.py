"""Vergleicht die Systemliste (Modul 1) mit dem Verzeichnis dieses Moduls (Übung 04.1).

Meldet Systeme ohne Eintrag und Einträge mit leeren Pflichtfeldern. Nur Standardbibliothek.
"""
import csv
import os

HIER = os.path.dirname(os.path.abspath(__file__))
SYSTEMLISTE = os.path.join(HIER, "..", "01-grundbegriffe-und-grundsaetze", "systemliste.csv")
VERZEICHNIS = os.path.join(HIER, "verzeichnis-beispiel.csv")
PFLICHT = ["Zweck", "Betroffene", "Datenkategorien", "Empfaenger", "Loeschfrist", "Massnahmen"]


def lesen(pfad):
    with open(pfad, encoding="utf-8", newline="") as f:
        return list(csv.DictReader(f))


def main():
    systeme = [z["System"] for z in lesen(SYSTEMLISTE)]
    eintraege = {z["System"]: z for z in lesen(VERZEICHNIS)}
    print(f"Systeme in der Systemliste: {len(systeme)}, Einträge im Verzeichnis: {len(eintraege)}\n")
    print("Systeme ohne Eintrag im Verzeichnis:")
    fehlt = [s for s in systeme if s not in eintraege]
    for s in fehlt:
        print("  -", s)
    if not fehlt:
        print("  keine")
    print("\nEinträge mit leeren Pflichtfeldern:")
    for name, z in eintraege.items():
        leer = [p for p in PFLICHT if not z[p].strip()]
        if leer:
            print(f"  - {name}: {', '.join(leer)}")
    print("\nHinweis: Pflichtangaben aus dem Fachwissen, nicht am Gesetz geprüft.")


if __name__ == "__main__":
    main()
