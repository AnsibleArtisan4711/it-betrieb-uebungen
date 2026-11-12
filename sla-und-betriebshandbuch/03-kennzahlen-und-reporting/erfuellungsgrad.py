# Rechenhilfe zu Modul 03, Aufgabe 2 und 3 (frei erfundene Daten)
ziel = {"P1": (15, 240), "P2": (60, 480), "P3": (240, 2880)}   # Reaktion min, Loesung min
t = [("T01","P1",5,110,0),("T02","P1",10,200,1),("T03","P1",20,180,1),("T04","P2",40,300,0),("T05","P2",50,420,1),("T06","P2",30,360,0),
     ("T07","P2",90,480,0),("T08","P3",120,1500,0),("T09","P3",200,2000,1),("T10","P3",240,2600,0),("T11","P3",60,1200,0),("T12","P3",30,900,0)]
def quote(sel):
    n = len(sel); r = sum(1 for x in sel if x[2] <= ziel[x[1]][0]); l = sum(1 for x in sel if x[3] <= ziel[x[1]][1])
    return n, r, l
n, r, l = quote(t)
print(f"Gesamt: Reaktion {r}/{n} = {r/n*100:.1f} %, Loesung {l}/{n} = {l/n*100:.1f} %")
for p in ["P1","P2","P3"]:
    n, r, l = quote([x for x in t if x[1] == p])
    print(f"{p}: Reaktion {r}/{n} = {r/n*100:.1f} %, Loesung {l}/{n} = {l/n*100:.1f} %")
w = sum(x[4] for x in t)
print(f"Wiedereroeffnet: {w}/{len(t)} = {w/len(t)*100:.1f} %")
