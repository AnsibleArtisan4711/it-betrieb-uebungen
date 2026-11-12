# Rechenhilfe zu Modul 08, Aufgabe 1 (frei erfundene Daten)
from datetime import datetime, timedelta
def t(tag, uhr):
    h, m = map(int, uhr.split(":"))
    return timedelta(days=tag-1, hours=h, minutes=m)
ausfaelle = [((3,"08:10"),(3,"09:40")),((5,"14:00"),(5,"14:30")),((9,"22:15"),(10,"02:15")),((12,"10:00"),(12,"10:45")),
             ((15,"03:30"),(15,"05:30")),((18,"16:20"),(18,"17:20")),((21,"07:00"),(21,"07:30")),((24,"11:10"),(24,"13:40")),
             ((27,"19:00"),(27,"19:45")),((30,"09:00"),(30,"10:00"))]
dauern = [(t(*e) - t(*b)).total_seconds()/3600 for b, e in ausfaelle]
beobachtung = 720.0
gesamt = sum(dauern); n = len(dauern)
print("Dauern in h:", ", ".join(f"{d:g}" for d in dauern))
print(f"Gesamtausfallzeit: {gesamt:.2f} h")
print(f"MTTR = {gesamt/n:.2f} h")
print(f"Betriebszeit = {beobachtung-gesamt:.2f} h")
print(f"MTBF = {(beobachtung-gesamt)/n:.2f} h")
