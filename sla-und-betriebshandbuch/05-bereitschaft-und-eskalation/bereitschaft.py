# Rechenhilfe zu Modul 05 (frei erfundene Namen und Daten)
from datetime import date, timedelta
plan = [("Huber",date(2026,8,31),date(2026,9,7)),("Maier",date(2026,9,7),date(2026,9,14)),("Gruber",date(2026,9,14),date(2026,9,21)),
        ("Bauer",date(2026,9,21),date(2026,9,28)),("Huber",date(2026,9,28),date(2026,10,5))]
def tage(plan, monat=(2026,9)):
    z = {}
    for name, a, b in plan:
        d = a
        while d <= b:                              # angefangene Kalendertage, Wechsel montags
            if (d.year, d.month) == monat: z.setdefault(name, set()).add(d)
            d += timedelta(days=1)
    return {k: len(v) for k, v in z.items()}
print("Plan:", tage(plan))
plan2 = [("Huber",a,b) if n == "Gruber" else (n,a,b) for n,a,b in plan]
print("Huber uebernimmt Gruber:", tage(plan2))
# Mindestzahl Personen im Wochenrhythmus ueber 140 Wochen
for p in (3, 4, 5):
    start = date(2026,8,31); m = 0
    for monat in [(2026+(8+k)//12, (8+k)%12+1) for k in range(30)]:
        plan3 = [(f"P{i%p}", start+timedelta(weeks=i), start+timedelta(weeks=i+1)) for i in range(140)]
        m = max(m, max(tage(plan3, monat).values(), default=0))
    print(f"{p} Personen: Maximum Tage/Monat = {m}")
