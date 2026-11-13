"""Einstufungshilfe nach einer KURSREGEL (Übung 02.1).

KEIN RECHTSRAT. Die Regel ist aus einer Sekundärquelle (Austrian Standards, ohne
Datum) und aus dem Fachwissen des Verfassers abgeleitet; Wortlaut von Richtlinie
und NISG 2026 wurden nicht gelesen. Schwellen, Sektorlisten und Zählweise sind
vor jeder echten Einstufung im Gesetz zu prüfen.

Kursregel:
  1. Größe "mittel oder größer", wenn mindestens 50 Beschäftigte ODER mehr als
     10 Mio. EUR Umsatz ODER mehr als 10 Mio. EUR Bilanzsumme.
  2. Sektor muss in Anlage 1 (hohe Kritikalität) oder Anlage 2 (sonstige kritische
     Sektoren) fallen. Hier nur als Stichwort der Übungsdaten angegeben.
  3. Wesentlich: Anlage 1 und "groß" (Annahme: mindestens 250 Beschäftigte ODER
     mehr als 50 Mio. EUR Umsatz und mehr als 43 Mio. EUR Bilanzsumme).
     Wichtig: alle anderen erfassten Einrichtungen.
Nur Standardbibliothek.
"""

# (Name, Beschäftigte, Umsatz Mio. EUR, Bilanzsumme Mio. EUR, Anlage 1/2/None, Sektor-Stichwort)
UNTERNEHMEN = [
    ("Beispiel A: Energieversorger", 300, 120.0, 150.0, 1, "Energie"),
    ("Beispiel B: Softwarehaus", 48, 6.0, 4.0, None, "Software (kein Sektor der Anlagen, Annahme)"),
    ("Beispiel C: Lebensmittelhersteller", 70, 14.0, 9.0, 2, "Lebensmittel"),
    ("Beispiel D: Rechenzentrumsbetreiber", 40, 12.0, 8.0, 1, "digitale Infrastruktur"),
    ("Donauwerk Fertigungs GmbH", 120, 28.0, None, 2, "Produktion (Annahme: Maschinenteile)"),
]


def gross(beschaeftigte, umsatz, bilanz):
    if beschaeftigte >= 250:
        return True
    return umsatz > 50.0 and bilanz is not None and bilanz > 43.0


def mittel_oder_groesser(beschaeftigte, umsatz, bilanz):
    return beschaeftigte >= 50 or umsatz > 10.0 or (bilanz is not None and bilanz > 10.0)


def main():
    print("Kursregel, kein Rechtsrat (siehe Kopf der Datei)\n")
    for name, besch, umsatz, bilanz, anlage, sektor in UNTERNEHMEN:
        print(name)
        print(f"  Beschäftigte {besch}, Umsatz {umsatz} Mio., Bilanzsumme {bilanz if bilanz is not None else 'unbekannt'} Mio.")
        unsicher = []
        if bilanz is None:
            unsicher.append("Bilanzsumme fehlt")
        groesse = mittel_oder_groesser(besch, umsatz, bilanz)
        print(f"  Schritt 1 Größe mittel oder größer: {'ja' if groesse else 'nein'}")
        if 45 <= besch < 50:
            unsicher.append("Beschäftigtenzahl nahe der Schwelle von 50 (Zählweise klären)")
        print(f"  Schritt 2 Sektor: {sektor}; Anlage {anlage if anlage else 'keine'}")
        if anlage is None:
            ergebnis = "voraussichtlich nicht erfasst (Sektor prüfen)"
        elif not groesse:
            ergebnis = "nicht erfasst nach der Größenregel (Sonderfälle laut Gesetz prüfen)"
        elif anlage == 1 and gross(besch, umsatz, bilanz):
            ergebnis = "wesentliche Einrichtung"
        else:
            ergebnis = "wichtige Einrichtung"
        print(f"  Schritt 3 Ergebnis nach Kursregel: {ergebnis}")
        if unsicher:
            print("  Unsicherheiten: " + "; ".join(unsicher))
        print()


if __name__ == "__main__":
    main()
