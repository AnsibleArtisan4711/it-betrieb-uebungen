# Rechenhilfe zu Modul 04 (frei erfundene Daten). Minutenrechnung mit datetime.
from datetime import datetime, timedelta
print("Aufgabe 1")
for z in [99.0, 99.5, 99.9, 99.95, 99.99]:
    j = 365*24*60*(1-z/100)
    print(f"  {z} %: {j:.2f} min/Jahr = {j/60:.3f} h, {30*24*60*(1-z/100):.2f} min/Monat")
tage = [d for d in range(1, 32) if datetime(2026,10,d).weekday() < 5 and d != 26]
sz = len(tage)*12*60
print(f"  S2 Oktober: {len(tage)} Servicetage, {sz} min, bei 99 % zulaessig {sz*0.01:.1f} min")
def mins(a, b): return (b - a).total_seconds()/60
def ueberlapp(a1,b1,a2,b2):
    return max(0, mins(max(a1,a2), min(b1,b2)))
D = datetime
print("Aufgabe 2")
mo_a, mo_b = D(2026,9,1), D(2026,10,1)
wa, wb = D(2026,9,12,2,0), D(2026,9,12,6,0)
aus = [(D(2026,9,2,14,10),D(2026,9,2,14,55)),(D(2026,9,12,5,10),D(2026,9,12,7,25)),(D(2026,9,21,9,0),D(2026,9,21,9,20)),
       (D(2026,9,24,23,40),D(2026,9,25,0,35)),(D(2026,9,30,23,30),D(2026,10,1,0,30))]
anr = []
for a,b in aus:
    im_monat = ueberlapp(a,b,mo_a,mo_b)
    anr.append(im_monat - ueberlapp(a,b,wa,wb))
for i,x in enumerate(anr,1): print(f"  Ausfall {i}: {x:.0f} min anrechenbar")
sz1 = 30*24*60; basis = sz1 - mins(wa,wb)
s = sum(anr)
print(f"  Summe {s:.0f} min, Basis {basis:.0f} min, Verfuegbarkeit {(basis-s)/basis*100:.3f} % (zulaessig {basis*0.005:.1f} min)")
naiv = sum(ueberlapp(a,b,mo_a,mo_b) for a,b in aus)
print(f"  naiv: {naiv:.0f} min, Basis {sz1} min, {(sz1-naiv)/sz1*100:.3f} %")
print(f"  MTTR {s/5:.0f} min, MTBF {(basis-s)/5:.0f} min = {(basis-s)/5/60:.1f} h")
print("Aufgabe 3")
a3 = [(D(2026,10,5,8,0),D(2026,10,5,9,30)),(D(2026,10,14,18,30),D(2026,10,14,19,45)),(D(2026,10,17,10,0),D(2026,10,17,12,0)),
      (D(2026,10,26,8,0),D(2026,10,26,10,0)),(D(2026,10,29,6,15),D(2026,10,29,7,45))]
tot = 0
for a,b in a3:
    if a.weekday() >= 5 or a.day == 26: x = 0
    else: x = ueberlapp(a,b,a.replace(hour=7,minute=0),a.replace(hour=19,minute=0))
    tot += x; print(f"  {a:%d.%m.}: {x:.0f} min")
print(f"  Summe {tot:.0f} min, Verfuegbarkeit {(sz-tot)/sz*100:.3f} % (Ziel 99 %, zulaessig {sz*0.01:.1f} min)")
print("Aufgabe 4")
reihe = 0.9995*0.999*0.998*0.997
print(f"  Reihe {reihe*100:.3f} %, Ausfall {365*24*60*(1-reihe):.0f} min/Jahr = {365*24*(1-reihe):.1f} h")
for name, a in [("Host-Cluster", 1-0.001**2), ("DB-Cluster", 1-0.002**2)]:
    ges = 0.9995*(a if name=="Host-Cluster" else 0.999)*(0.998 if name=="Host-Cluster" else a)*0.997
    print(f"  {name}: Cluster {a*100:.4f} %, Gesamt {ges*100:.3f} %")
