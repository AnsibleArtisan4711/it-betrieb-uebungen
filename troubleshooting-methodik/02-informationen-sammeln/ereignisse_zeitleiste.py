"""Führt Ereignisse mehrerer Systeme zu einer gemeinsamen Zeitleiste zusammen.

Liest srv01_ereignisse.csv und lnx01_journal.csv (Spalten: zeit, quelle, level, id, text)
und symptom.txt (erste Zeile: Zeitpunkt der Störungsmeldung). Ausgabe: sortierte Zeitleiste;
Ereignisse in den 15 Minuten VOR dem Symptom werden mit '>>' markiert (mögliche Auslöser).
Zeitstempel werden als gleiche Zeitzone und synchrone Uhren angenommen (in der Praxis prüfen!).
Nur Standardbibliothek.
"""
import csv
from datetime import datetime, timedelta

FORMAT = "%Y-%m-%d %H:%M:%S"
DATEIEN = [("SRV01", "srv01_ereignisse.csv"), ("LNX01", "lnx01_journal.csv")]

with open("symptom.txt", encoding="utf-8") as f:
    symptom = datetime.strptime(f.readline().strip(), FORMAT)

ereignisse = []
for system, datei in DATEIEN:
    with open(datei, newline="", encoding="utf-8") as f:
        for z in csv.DictReader(f):
            ereignisse.append((datetime.strptime(z["zeit"], FORMAT), system, z))
ereignisse.sort(key=lambda e: e[0])

print(f"Symptom gemeldet: {symptom}")
print(f"{len(ereignisse)} Ereignisse aus {len(DATEIEN)} Systemen\n")
for zeit, system, z in ereignisse:
    abstand = int((zeit - symptom).total_seconds() // 60)
    marke = ">>" if timedelta(minutes=-15) <= (zeit - symptom) < timedelta(0) else "  "
    print(f"{marke} {zeit:%H:%M:%S} ({abstand:+4d} min) {system} {z['level']:<11} {z['quelle']}: {z['text']}")

vorher = [e for e in ereignisse if timedelta(minutes=-15) <= (e[0] - symptom) < timedelta(0)
          and e[2]["level"] in ("Warning", "Error")]
print(f"\nWarnungen und Fehler in den 15 Minuten vor dem Symptom: {len(vorher)}")
for zeit, system, z in vorher:
    print(f"  {zeit:%H:%M:%S} {system}: {z['text']}")
print("Hinweis: Zeitliche Nähe ist ein Indiz, kein Beweis für die Ursache.")
