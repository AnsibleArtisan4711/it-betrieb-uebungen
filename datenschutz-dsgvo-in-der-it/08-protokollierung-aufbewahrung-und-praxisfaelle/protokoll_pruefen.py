"""Prüft einen fiktiven Protokollauszug auf personenbezogene Angaben (Übung 08.1).

Die Muster sind grobe Hilfen für die Übung und erkennen NICHT alles (zum Beispiel
keine Namen im Freitext). Ob eine Angabe personenbezogen ist, entscheidet die
Beurteilung der Lernenden, nicht das Skript. Nur Standardbibliothek.
"""
import os
import re
from collections import defaultdict

MUSTER = {
    "IP-Adresse": re.compile(r"\b\d{1,3}(?:\.\d{1,3}){3}\b"),
    "E-Mail": re.compile(r"[\w.+-]+@[\w-]+(?:\.[\w-]+)+"),
    "Benutzerkennung": re.compile(r"\buser=\S+"),
    "Telefonnummer": re.compile(r"\+\d{2}[\d ]{8,}"),
    "Kundennummer": re.compile(r"\bK-\d{5}\b"),
    "Buchungsnummer": re.compile(r"\bB-\d{6}\b"),
}


def main():
    pfad = os.path.join(os.path.dirname(os.path.abspath(__file__)), "protokoll-auszug.log")
    zeilen = [z.rstrip("\n") for z in open(pfad, encoding="utf-8") if z.strip()]
    je_art = defaultdict(lambda: {"zeilen": 0, "mit": 0, "arten": set()})
    gesamt = defaultdict(int)
    print(f"Datei: protokoll-auszug.log, {len(zeilen)} Zeilen\n")
    for z in zeilen:
        art = z[1:z.index("]")]
        funde = sorted(n for n, m in MUSTER.items() if m.search(z))
        je_art[art]["zeilen"] += 1
        if funde:
            je_art[art]["mit"] += 1
            je_art[art]["arten"].update(funde)
            for n in funde:
                gesamt[n] += 1
    print(f"{'Protokoll':10} {'Zeilen':>6} {'mit Personenbezug':>18}  gefundene Arten")
    for art, d in je_art.items():
        arten = ", ".join(sorted(d["arten"])) or "-"
        print(f"{art:10} {d['zeilen']:6} {d['mit']:18}  {arten}")
    print("\nHäufigkeit je Art (Zeilen):")
    for n, c in sorted(gesamt.items(), key=lambda x: (-x[1], x[0])):
        print(f"  {n:16} {c}")
    print("\nHinweis: Das Skript findet nur Muster; die Einordnung als personenbezogen bleibt Aufgabe der Beurteilung.")


if __name__ == "__main__":
    main()
