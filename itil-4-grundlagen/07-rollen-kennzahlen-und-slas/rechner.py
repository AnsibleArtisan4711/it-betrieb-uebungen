# Rechenhilfe zu Modul 07, Aufgabe 1 (frei erfundene Zahlen der Example Corp)
ausfaelle_h = [2, 1, 3]
woche_h = 168
gesamt = sum(ausfaelle_h)
n = len(ausfaelle_h)
betrieb = woche_h - gesamt
print(f"Gesamtausfallzeit: {gesamt} h")
print(f"MTTR: {gesamt / n:.2f} h")
print(f"Betriebszeit:      {betrieb} h")
print(f"MTBF: {betrieb / n:.2f} h")
print(f"Verfuegbarkeit:    {betrieb / woche_h * 100:.2f} %")
