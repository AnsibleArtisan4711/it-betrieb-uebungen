# Rechenhilfe zu Modul 01, Aufgabe 3
import ipaddress
for netz in ["10.30.0.0/22", "10.40.0.0/25"]:
    n = ipaddress.ip_network(netz)
    print(f"{netz}: {n.num_addresses - 2} nutzbare Hostadressen")
scanner = 90
print(f"Scanner: {scanner}, Reserve im /25: {126 - scanner} Adressen")
