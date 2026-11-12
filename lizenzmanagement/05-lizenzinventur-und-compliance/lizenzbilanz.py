# Rechenhilfe zu Modul 05: Bedarf (aus Inventar) gegen Bestand (erworbene Lizenzen) (Python 3, nur Standardbibliothek)
import csv

with open("bedarf.csv", newline="", encoding="utf-8") as f:
    bedarf = {z["produkt"]: int(z["menge"]) for z in csv.DictReader(f)}
with open("bestand.csv", newline="", encoding="utf-8") as f:
    bestand = {z["produkt"]: int(z["menge"]) for z in csv.DictReader(f)}

unter = ueber = 0
for produkt in sorted(set(bedarf) | set(bestand)):
    b = bedarf.get(produkt, 0)
    h = bestand.get(produkt, 0)
    diff = h - b
    if diff < 0:
        status, unter = f"UNTERLIZENZIERT um {-diff}", unter + 1
    elif diff > 0:
        status, ueber = f"überlizenziert um {diff}", ueber + 1
    else:
        status = "ausgeglichen"
    print(f"{produkt:<22} Bedarf {b:>3}  Bestand {h:>3}  {status}")
print(f"Unterlizenziert: {unter}, überlizenziert: {ueber}")
