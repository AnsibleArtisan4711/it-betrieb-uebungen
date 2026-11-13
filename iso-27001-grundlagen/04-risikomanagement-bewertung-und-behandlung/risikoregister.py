"""Risikoregister auswerten (Übung 04.1).

Skalen, Klassen und das Akzeptanzkriterium sind ANNAHMEN der Übung:
Risiko = Eintritt x Auswirkung (je 1 bis 5); akzeptabel ist ein Restrisiko
bis einschließlich 6. Das Skript prüft zusätzlich, ob jedes Risiko einen
Risikoeigner und eine Restrisikobewertung hat. Nur Standardbibliothek.
"""
import csv
import os

AKZEPTANZ = 6


def zahl(text):
    text = (text or "").strip()
    return int(text) if text else None


def main():
    pfad = os.path.join(os.path.dirname(os.path.abspath(__file__)), "risikoregister.csv")
    with open(pfad, encoding="utf-8", newline="") as f:
        zeilen = list(csv.DictReader(f))
    for z in zeilen:
        for k in ("Eintritt", "Auswirkung", "Rest_Eintritt", "Rest_Auswirkung"):
            z[k] = zahl(z[k])
        z["Roh"] = z["Eintritt"] * z["Auswirkung"]
        r = None
        if z["Rest_Eintritt"] is not None and z["Rest_Auswirkung"] is not None:
            r = z["Rest_Eintritt"] * z["Rest_Auswirkung"]
        z["Rest"] = r
    zeilen.sort(key=lambda z: (-z["Roh"], z["ID"]))
    print(f"Akzeptanzkriterium (Annahme): Restrisiko bis einschließlich {AKZEPTANZ}\n")
    print(f"{'ID':4} {'Wert':4} {'Roh':>3} {'Rest':>4} {'Option':11} {'Eigner':20} Bewertung")
    offen = []
    luecken = []
    for z in zeilen:
        rest = "-" if z["Rest"] is None else str(z["Rest"])
        if z["Rest"] is None:
            bew = "Restrisiko fehlt"
            luecken.append(f"{z['ID']}: Restrisiko nicht bewertet")
        elif z["Rest"] <= AKZEPTANZ:
            bew = "akzeptabel"
        else:
            bew = "über Kriterium: Entscheidung der Leitung nötig"
            offen.append(z["ID"])
        if not z["Eigner"].strip():
            luecken.append(f"{z['ID']}: kein Risikoeigner")
        print(f"{z['ID']:4} {z['Wert']:4} {z['Roh']:3} {rest:>4} {z['Option']:11} {z['Eigner'] or '(fehlt)':20} {bew}")
    print()
    print("Risiken über dem Kriterium:", ", ".join(offen) if offen else "keine")
    print("Lücken im Register:")
    for l in luecken:
        print("  -", l)
    if not luecken:
        print("  keine")


if __name__ == "__main__":
    main()
