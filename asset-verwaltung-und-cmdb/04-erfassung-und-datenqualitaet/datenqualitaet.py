# Rechenhilfe zu Modul 04: Datenqualität einer Asset-Liste prüfen (Python 3, nur Standardbibliothek)
import csv, re
from collections import Counter

PFLICHT = ["name", "typ", "seriennr", "standort", "zustaendig", "status"]
STATUS = {"planung", "im Lager", "in Betrieb", "in Reparatur", "ausgemustert"}
NAME = re.compile(r"^(WIE|GRZ)-(NB|PC|MO|SW|SRV|DR)-\d{3}$")

with open("assets-beispiel.csv", newline="", encoding="utf-8") as f:
    zeilen = list(csv.DictReader(f))

print(f"Datensätze: {len(zeilen)}")
fehler = []
seriennr = Counter(z["seriennr"] for z in zeilen if z["seriennr"])
namen = Counter(z["name"] for z in zeilen)
for nr, z in enumerate(zeilen, start=2):  # Zeile 1 ist die Kopfzeile
    for feld in PFLICHT:
        if not z[feld]:
            fehler.append((nr, z["name"], f"Pflichtfeld leer: {feld}"))
    if not NAME.match(z["name"]):
        fehler.append((nr, z["name"], "Name entspricht nicht der Konvention"))
    if z["status"] and z["status"] not in STATUS:
        fehler.append((nr, z["name"], f"Status unbekannt: '{z['status']}'"))
    if z["seriennr"] and seriennr[z["seriennr"]] > 1:
        fehler.append((nr, z["name"], f"Seriennummer doppelt: {z['seriennr']}"))
    if namen[z["name"]] > 1:
        fehler.append((nr, z["name"], "Name doppelt"))

for nr, name, text in fehler:
    print(f"Zeile {nr:>2} {name:<12} {text}")
fehlerhaft = {nr for nr, _, _ in fehler}
print(f"Fehlermeldungen: {len(fehler)}, betroffene Datensätze: {len(fehlerhaft)}")

gefuellt = sum(1 for z in zeilen for feld in PFLICHT if z[feld])
gesamt = len(zeilen) * len(PFLICHT)
print(f"Vollständigkeit der Pflichtfelder: {gefuellt}/{gesamt} = {gefuellt / gesamt * 100:.1f} %".replace(".", ","))
