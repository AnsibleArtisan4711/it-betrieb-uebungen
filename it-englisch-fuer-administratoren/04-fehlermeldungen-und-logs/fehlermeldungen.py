"""Erkennt bekannte englische Fehlermeldungen in einem Text und zeigt die deutsche Entsprechung.

Liest phrasen.csv (englisch, deutsch, hinweis) und meldungen.txt (ein Logauszug, ERFUNDEN). Die Tabelle ist ein
Lernhilfsmittel mit einfachen, allgemein bekannten Meldungen; der genaue Wortlaut echter Programme kann abweichen
und ist hier nicht gegen Software geprüft. Groß- und Kleinschreibung wird ignoriert. Nur Standardbibliothek.
"""
import csv

with open("phrasen.csv", newline="", encoding="utf-8") as f:
    phrasen = list(csv.DictReader(f))
with open("meldungen.txt", encoding="utf-8") as f:
    zeilen = [z.rstrip("\n") for z in f if z.strip()]

gefunden = 0
for nr, zeile in enumerate(zeilen, 1):
    for p in phrasen:
        if p["englisch"] in zeile.lower():
            gefunden += 1
            print(f"Zeile {nr}: {zeile}")
            print(f"   -> {p['deutsch']}  (Hinweis: {p['hinweis']})")
print(f"\n{len(zeilen)} Zeilen gelesen, {gefunden} bekannte Meldungen erkannt.")
unbekannt = [z for z in zeilen if not any(p["englisch"] in z.lower() for p in phrasen)]
print(f"{len(unbekannt)} Zeilen ohne Treffer (mit dem Wörterbuch selbst nachschlagen):")
for z in unbekannt:
    print("  ", z)
