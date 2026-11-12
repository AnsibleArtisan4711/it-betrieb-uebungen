# Rechenhilfe zu Modul 03, Aufgabe 1 (frei erfundene Zeiten)
from datetime import datetime
ereignisse = [("Beginn","08:02"),("Meldung","08:10"),("Eskalation","08:20"),("Ursache gefunden","09:05"),("Behebung","09:50")]
t = [datetime.strptime(z, "%H:%M") for _, z in ereignisse]
for i, (name, z) in enumerate(ereignisse):
    delta = int((t[i] - t[i-1]).total_seconds() // 60) if i else 0
    print(f"{z}  {name:<18} +{delta:>3} min")
print("Gesamtdauer:", int((t[-1]-t[0]).total_seconds()//60), "Minuten")
