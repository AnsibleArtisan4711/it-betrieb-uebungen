# Rechenhilfe zu Modul 08, Aufgabe 2 (frei erfundene Daten)
from datetime import date
stichtag = date(2026,11,30)
rb = {"RB-01":date(2026,6,15),"RB-02":date(2025,11,30),"RB-03":date(2025,10,20),"RB-04":date(2026,3,2),"RB-05":date(2025,5,5),
      "RB-06":date(2026,9,1),"RB-07":date(2024,12,12),"RB-08":date(2026,1,20),"RB-09":date(2025,11,29),"RB-10":date(2026,10,10)}
ue = {}
for k, d in rb.items():
    tage = (stichtag - d).days
    print(f"{k}: {tage} Tage", "UEBERFAELLIG" if tage > 365 else "")
    if tage > 365: ue[k] = tage
print(f"Ueberfaellig: {len(ue)} von {len(rb)}, Aktualitaetsquote {(len(rb)-len(ue))/len(rb)*100:.0f} %")
