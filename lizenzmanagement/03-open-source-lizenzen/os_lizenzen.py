# Rechenhilfe zu Modul 03: Komponenten nach Lizenzfamilie einordnen und Prüfbedarf markieren
# Die Einordnung ist eine Kursvereinfachung und keine Rechtsauslegung (Python 3, nur Standardbibliothek).
import csv

FAMILIE = {
    "MIT": "permissiv", "BSD-3-Clause": "permissiv", "Apache-2.0": "permissiv",
    "LGPL-2.1": "schwaches Copyleft", "MPL-2.0": "schwaches Copyleft",
    "GPL-2.0": "starkes Copyleft", "GPL-3.0": "starkes Copyleft",
    "AGPL-3.0": "Netzwerk-Copyleft",
}

with open("komponenten.csv", newline="", encoding="utf-8") as f:
    zeilen = list(csv.DictReader(f))

pruefen = 0
for z in zeilen:
    fam = FAMILIE.get(z["lizenz"], "nicht eingeordnet")
    grund = []
    if fam == "nicht eingeordnet":
        grund.append("Lizenz unbekannt oder nicht in der Tabelle")
    if fam in ("starkes Copyleft", "schwaches Copyleft") and z["weitergabe"] == "ja":
        grund.append("Weitergabe mit Copyleft")
    if fam == "Netzwerk-Copyleft":
        grund.append("Netzwerkdienst prüfen")
    if grund:
        pruefen += 1
    print(f"{z['komponente']:<14} {z['lizenz']:<14} {fam:<20} {'PRÜFEN: ' + '; '.join(grund) if grund else 'ok'}")
print(f"Prüfbedarf: {pruefen} von {len(zeilen)} Komponenten")
