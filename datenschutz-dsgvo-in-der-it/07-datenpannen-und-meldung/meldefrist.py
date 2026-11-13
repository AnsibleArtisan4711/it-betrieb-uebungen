"""72-Stunden-Frist für die Meldung einer Datenpanne (Übung 07.1).

KURSANNAHME, KEIN RECHTSRAT: Laut der gelesenen Sekundärquelle (WKO-Seite) ist so
früh wie möglich zu melden; wird die Meldung nach mehr als 72 Stunden abgegeben,
ist die Verspätung zu begründen. Hier beginnt die Frist mit dem Zeitpunkt der
Kenntnis. Wie "Kenntnis" auszulegen ist, ist rechtlich zu klären. Wochenenden und
Feiertage werden nicht ausgeklammert (die Stunden laufen durch). Nur Standardbibliothek.
"""
from datetime import datetime, timedelta

FRIST = timedelta(hours=72)
JETZT = datetime(2026, 11, 20, 9, 0)   # fester Zeitpunkt für noch offene Fälle

# (Nummer, Beschreibung, Kenntnis, Meldung oder None)
FAELLE = [
    ("F-1", "Laptop im Zug verloren (Montag)", datetime(2026, 11, 2, 8, 30), datetime(2026, 11, 3, 10, 0)),
    ("F-2", "Falsche Freigabe, Freitagabend entdeckt", datetime(2026, 11, 6, 17, 30), datetime(2026, 11, 9, 17, 0)),
    ("F-3", "Ransomware, Meldung nach Wochenende", datetime(2026, 11, 6, 22, 15), datetime(2026, 11, 10, 9, 0)),
    ("F-4", "Newsletter an falschen Verteiler", datetime(2026, 11, 18, 14, 0), None),
    ("F-5", "Zugangsdaten im Netz gefunden", datetime(2026, 11, 17, 6, 45), None),
]


def stunden(delta):
    return delta.total_seconds() / 3600


def main():
    print(f"Frist: {int(stunden(FRIST))} Stunden ab Kenntnis (Annahme). Zeitpunkt für offene Fälle: {JETZT:%Y-%m-%d %H:%M}")
    print()
    print(f"{'Nr':4} {'Kenntnis':16} {'Fristende':16} {'Meldung':16} {'Dauer (h)':>9}  Bewertung")
    for nr, text, kenntnis, meldung in FAELLE:
        ende = kenntnis + FRIST
        if meldung is not None:
            dauer = stunden(meldung - kenntnis)
            if meldung <= ende:
                bewertung = "innerhalb von 72 Stunden"
            else:
                bewertung = f"{dauer - 72:.1f} Stunden zu spät: Begründung der Verspätung nötig"
            meldung_text = f"{meldung:%Y-%m-%d %H:%M}"
            dauer_text = f"{dauer:.1f}"
        else:
            rest = stunden(ende - JETZT)
            meldung_text = "offen"
            dauer_text = "-"
            if rest >= 0:
                bewertung = f"offen, noch {rest:.1f} Stunden bis zum Fristende"
            else:
                bewertung = f"offen, Frist seit {-rest:.1f} Stunden überschritten"
        print(f"{nr:4} {kenntnis:%Y-%m-%d %H:%M} {ende:%Y-%m-%d %H:%M} {meldung_text:16} {dauer_text:>9}  {bewertung}")
        print(f"     ({text})")


if __name__ == "__main__":
    main()
