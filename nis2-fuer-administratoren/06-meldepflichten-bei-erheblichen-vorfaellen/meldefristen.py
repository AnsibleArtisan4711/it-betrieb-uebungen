"""Gestufte Meldefristen bei einem erheblichen Vorfall (Übung 06.1).

KURSANNAHME, KEIN RECHTSRAT. Stufen laut Wiedergabe von Art. 23 der Richtlinie
(nicht an EUR-Lex geprüft): Frühwarnung 24 Stunden, Meldung 72 Stunden ab Kenntnis;
Abschlussbericht einen Monat nach der Meldung. Die Sekundärquelle Austrian
Standards nennt dagegen "einen Monat nach der Frühwarnung". Beide Werte werden
ausgegeben; im Kurs gilt die Frist laut Richtlinie. Wie der Beginn der Frist
("Kenntnis") und ein Monatsende zu behandeln sind, ist im Gesetz zu klären.
Nur Standardbibliothek.
"""
import calendar
from datetime import datetime, timedelta


def monat_dazu(zeit):
    index = zeit.month
    jahr = zeit.year + index // 12
    monat = index % 12 + 1
    tag = min(zeit.day, calendar.monthrange(jahr, monat)[1])
    return zeit.replace(year=jahr, month=monat, day=tag)


# (Nummer, Beschreibung, Kenntnis, Meldung tatsächlich oder None)
VORFAELLE = [
    ("V-1", "Ransomware im ERP (Dienstag)", datetime(2026, 11, 3, 14, 20), datetime(2026, 11, 6, 9, 0)),
    ("V-2", "Fertigungsausfall am Freitagabend", datetime(2026, 11, 6, 19, 45), None),
    ("V-3", "Datenabfluss am Monatsende", datetime(2026, 12, 30, 10, 0), datetime(2026, 12, 31, 8, 30)),
    ("V-4", "Störung beim Lieferanten", datetime(2027, 1, 29, 16, 10), None),
]


def zeigen(z):
    return f"{z:%Y-%m-%d %H:%M}"


def main():
    print("Stufen: Frühwarnung 24 h, Meldung 72 h ab Kenntnis, Abschlussbericht 1 Monat nach der Meldung (Richtlinie, Kursannahme)\n")
    for nr, text, kenntnis, meldung in VORFAELLE:
        fruehwarnung = kenntnis + timedelta(hours=24)
        meldefrist = kenntnis + timedelta(hours=72)
        bezug = meldung if meldung is not None else meldefrist
        bericht_richtlinie = monat_dazu(bezug)
        bericht_quelle = monat_dazu(fruehwarnung)
        print(f"{nr} {text}")
        print(f"  Kenntnis                 {zeigen(kenntnis)}")
        print(f"  Frühwarnung bis          {zeigen(fruehwarnung)}")
        print(f"  Meldung bis              {zeigen(meldefrist)}" + (f"  (abgegeben {zeigen(meldung)})" if meldung else "  (noch nicht abgegeben)"))
        basis = "tatsächlicher Meldung" if meldung else "Fristende der Meldung"
        print(f"  Abschlussbericht bis     {zeigen(bericht_richtlinie)}  (Richtlinie, ein Monat nach {basis})")
        print(f"  abweichend laut Quelle   {zeigen(bericht_quelle)}  (Austrian Standards: ein Monat nach der Frühwarnung)")
        print()


if __name__ == "__main__":
    main()
