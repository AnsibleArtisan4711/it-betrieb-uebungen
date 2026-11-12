# Rechenhilfe zu Modul 04, Aufgabe 3. Ohne Feiertage, nur Mo-Fr 08:00-17:00.
from datetime import datetime, timedelta
START, ENDE = 8, 17
def frist(beginn, stunden):
    rest = timedelta(hours=stunden)
    t = beginn
    while True:
        if t.weekday() >= 5:                      # Wochenende
            t = (t + timedelta(days=7-t.weekday())).replace(hour=START, minute=0)
            continue
        if t.hour < START:
            t = t.replace(hour=START, minute=0); continue
        tagesende = t.replace(hour=ENDE, minute=0)
        if t >= tagesende:
            t = (t + timedelta(days=1)).replace(hour=START, minute=0); continue
        if tagesende - t >= rest:
            return t + rest
        rest -= (tagesende - t)
        t = (t + timedelta(days=1)).replace(hour=START, minute=0)
for b in [datetime(2026,11,6,16,0), datetime(2026,11,7,10,0), datetime(2026,11,9,8,30)]:
    print(b.strftime("%a %d.%m.%Y %H:%M"), "-> Frist 2 h:", frist(b, 2).strftime("%a %d.%m.%Y %H:%M"))
