"""Eingrenzen von unten nach oben (Bottom-up) anhand protokollierter Testergebnisse.

Liest messwerte.csv (fall, schicht, test, ziel, ergebnis) und nennt je Fall
die erste fehlgeschlagene Schicht. Das ist ein Hinweis auf den Ort der
Ursache, kein Beweis: Die Ursache kann auch in der Schicht darüber liegen.
Nur Standardbibliothek.
"""
import csv
from collections import OrderedDict

HINWEIS = {
    "1 Verbindung": "Adapter, Kabel, virtueller Switch prüfen",
    "2 Adresse": "IP-Konfiguration prüfen (statisch oder DHCP)",
    "3 Erreichbarkeit": "Routing, Firewall für ICMP, Gegenstelle prüfen",
    "4 Namensauflösung": "DNS-Server des Clients und DNS-Einträge prüfen",
    "5 Port und Dienst": "Dienst läuft? Lauscht er? Firewall auf dem Zielsystem?",
    "6 Anwendung": "Anwendungskonfiguration, Rechte und Protokolle prüfen",
}

with open("messwerte.csv", newline="", encoding="utf-8") as f:
    zeilen = list(csv.DictReader(f))

faelle = OrderedDict()
for z in zeilen:
    faelle.setdefault(z["fall"], []).append(z)

for fall, tests in faelle.items():
    print(f"Fall {fall}: {len(tests)} Tests")
    erster = None
    for t in tests:
        marke = "ok    " if t["ergebnis"] == "ok" else "FEHLER"
        print(f"  {marke} {t['schicht']:<18} {t['test']}")
        if t["ergebnis"] != "ok" and erster is None:
            erster = t
    if erster is None:
        print("  Ergebnis: alle Tests ok, Symptom nicht reproduziert")
    else:
        spaeter_ok = [t for t in tests if t["ergebnis"] == "ok" and t["schicht"] > erster["schicht"]]
        print(f"  Erste Abweichung: {erster['schicht']} ({erster['test']})")
        print(f"  Nächster Schritt: {HINWEIS[erster['schicht']]}")
        if spaeter_ok:
            print("  Achtung: höhere Schichten sind ok, Reihenfolge der Tests und Messung prüfen")
    print()
