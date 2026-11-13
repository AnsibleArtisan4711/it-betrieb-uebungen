"""Fristrechner für Betroffenenanfragen (Übung 03.1).

KURSANNAHME, KEIN RECHTSRAT: Es gilt die Annahme "ein Monat ab Eingang, bei
begründeter Verlängerung höchstens zwei weitere Monate". Die Rechtsfrist, den
Beginn (Eingang oder Identitätsnachweis) und die Behandlung von Wochenenden und
Feiertagen muss die Übende im Gesetz nachlesen. Hier gibt es keine Verschiebung
auf Werktage. Nur Standardbibliothek, keine Fremdpakete.
"""
import calendar
from datetime import date

STICHTAG = date(2026, 11, 30)   # fester Stichtag, damit die Ausgabe wiederholbar ist
WOCHENTAGE = ["Montag", "Dienstag", "Mittwoch", "Donnerstag", "Freitag", "Samstag", "Sonntag"]


def monate_addieren(d, monate):
    """Addiert Kalendermonate; gibt es den Tag im Zielmonat nicht, gilt der letzte Tag."""
    index = d.month - 1 + monate
    jahr = d.year + index // 12
    monat = index % 12 + 1
    tag = min(d.day, calendar.monthrange(jahr, monat)[1])
    return date(jahr, monat, tag)


# (Nummer, Recht, Eingang)
ANFRAGEN = [
    ("A-01", "Auskunft", date(2026, 10, 15)),
    ("A-02", "Löschung", date(2026, 10, 31)),
    ("A-03", "Berichtigung", date(2026, 11, 30)),
    ("A-04", "Auskunft", date(2027, 1, 31)),
    ("A-05", "Datenübertragbarkeit", date(2028, 1, 31)),
    ("A-06", "Widerspruch", date(2026, 8, 31)),
]


def main():
    print(f"Stichtag: {STICHTAG.isoformat()} (Annahme: ein Monat ab Eingang, Verlängerung höchstens zwei weitere Monate)")
    print()
    print(f"{'Nr':5} {'Recht':22} {'Eingang':11} {'Fristende':11} {'Wochentag':11} {'Rest (Tage)':>18} {'spätestes Ende bei Verlängerung':>32}")
    for nr, recht, eingang in ANFRAGEN:
        ende = monate_addieren(eingang, 1)
        spaet = monate_addieren(eingang, 3)
        rest = (ende - STICHTAG).days
        if rest < 0:
            status = f"{-rest} Tage überfällig"
        else:
            status = str(rest)
        print(f"{nr:5} {recht:22} {eingang.isoformat():11} {ende.isoformat():11} {WOCHENTAGE[ende.weekday()]:11} {status:>18} {spaet.isoformat():>32}")
    print()
    print("Hinweis: Fällt das Fristende auf ein Wochenende, wird hier NICHT verschoben (Kursannahme).")


if __name__ == "__main__":
    main()
