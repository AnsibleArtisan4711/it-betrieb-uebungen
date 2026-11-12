# Rechenhilfe zu Modul 02: Kernlizenzen nach der BEISPIELREGEL (Stand Windows Server 2016, archivierte Microsoft-Quelle)
# NICHT BESTÄTIGT für aktuelle Versionen. Regel: mindestens 8 Kerne je Prozessor, mindestens 16 je Server,
# Verkauf in 2er-Paketen; Edition Standard: je zwei weitere VMs werden alle Kerne erneut lizenziert.
from math import ceil

# (Name, Prozessoren, Kerne je Prozessor, virtuelle Maschinen)
SERVER = [
    ("SRV-A", 1, 4, 2),
    ("SRV-B", 2, 8, 6),
    ("SRV-C", 2, 12, 4),
    ("SRV-D", 1, 6, 0),
]

gesamt_kerne = 0
for name, cpus, kerne, vms in SERVER:
    je_cpu = max(8, kerne)
    kerne_lizenz = max(16, cpus * je_cpu)
    if kerne_lizenz % 2:
        kerne_lizenz += 1
    runden = max(1, ceil(vms / 2))  # Standard: je 2 VMs ein Durchgang (Beispielregel)
    benoetigt = kerne_lizenz * runden
    pakete = benoetigt // 2
    gesamt_kerne += benoetigt
    print(f"{name}: {cpus} CPU x {kerne} Kerne, {vms} VMs -> {kerne_lizenz} Kerne je Durchgang x {runden} = {benoetigt} Kernlizenzen ({pakete} 2er-Pakete)")
print(f"Summe Standard-Annahme: {gesamt_kerne} Kernlizenzen ({gesamt_kerne // 2} 2er-Pakete)")
