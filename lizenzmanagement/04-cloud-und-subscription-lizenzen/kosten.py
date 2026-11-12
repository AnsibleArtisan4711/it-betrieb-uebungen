# Rechenhilfe zu Modul 04 und 07: Kosten und ungenutzte Lizenzen (Python 3, nur Standardbibliothek)
# ALLE PREISE SIND ERFUNDENE BEISPIELWERTE ohne Stand und ohne Bezug zu realen Angeboten.
import csv
from datetime import date

STICHTAG = date(2026, 11, 30)
INAKTIV_TAGE = 90

with open("plaene.csv", newline="", encoding="utf-8") as f:
    preis = {z["plan"]: float(z["preis_je_benutzer_monat"]) for z in csv.DictReader(f)}
with open("benutzer.csv", newline="", encoding="utf-8") as f:
    nutzer = list(csv.DictReader(f))

def eur(x):
    return f"{x:,.2f}".replace(",", "X").replace(".", ",").replace("X", ".") + " EUR"

print("Jahreskosten für 60 Benutzer je Plan (Beispielpreise):")
for plan, p in preis.items():
    print(f"  {plan}: {eur(p * 60 * 12)}")

print(f"Konten ohne Anmeldung seit mehr als {INAKTIV_TAGE} Tagen (Stichtag {STICHTAG.isoformat()}):")
ersparnis = 0.0
for n in nutzer:
    tage = (STICHTAG - date.fromisoformat(n["letzte_anmeldung"])).days
    if tage > INAKTIV_TAGE:
        jahr = preis[n["plan"]] * 12
        ersparnis += jahr
        print(f"  {n['konto']} ({n['plan']}): {tage} Tage, {eur(jahr)} pro Jahr")
print(f"Mögliche Einsparung pro Jahr: {eur(ersparnis)}")
