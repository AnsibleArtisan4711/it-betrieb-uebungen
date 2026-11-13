"""Dreipunktschätzung (PERT) aus aufwand.csv.

Erwartungswert E = (O + 4*M + P) / 6, Streuung s = (P - O) / 6 (übliche Näherung, Fachwissen).
Summe der Erwartungswerte; Streuung der Summe = Wurzel aus der Summe der Quadrate (Annahme: Aufgaben unabhängig,
in der Praxis oft zu optimistisch). Ausgabe auch 'Erwartung + 1 Streuung' als Planungswert mit Puffer.
Nur Standardbibliothek.
"""
import csv
from math import sqrt

summe_e = summe_var = 0.0
print(f"{'Aufgabe':<30} {'O':>4} {'M':>4} {'P':>4} {'E':>6} {'s':>5}")
with open("aufwand.csv", newline="", encoding="utf-8") as f:
    for z in csv.DictReader(f):
        o, m, p = (float(z[k]) for k in ("optimistisch_h", "wahrscheinlich_h", "pessimistisch_h"))
        e = (o + 4 * m + p) / 6
        s = (p - o) / 6
        summe_e += e
        summe_var += s * s
        print(f"{z['aufgabe']:<30} {o:>4.0f} {m:>4.0f} {p:>4.0f} {e:>6.1f} {s:>5.1f}")
s_ges = sqrt(summe_var)
print(f"\nSumme der Erwartungswerte: {summe_e:.1f} h")
print(f"Streuung der Summe: {s_ges:.1f} h")
print(f"Planungswert (Erwartung + 1 Streuung): {summe_e + s_ges:.1f} h")
print(f"Das entspricht bei 6 Stunden Projektarbeit pro Tag etwa {(summe_e + s_ges) / 6:.1f} Arbeitstagen.")
