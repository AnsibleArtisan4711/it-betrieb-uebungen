"""Kennzahlen des ISMS aus Rohdaten berechnen (Übung 07.1).

Die Zielwerte sind ANNAHMEN der Übung. Nur Standardbibliothek.
"""
import csv
import os
import statistics

ZIEL_SCHULUNG = 90.0     # Prozent
ZIEL_UPDATE_TAGE = 4     # Tage (Mittelwert); Anteil innerhalb von 3 Tagen separat
ZIEL_RESTORE = 100.0     # Prozent
ZIEL_VORFAELLE = 80.0    # Prozent


def main():
    pfad = os.path.join(os.path.dirname(os.path.abspath(__file__)), "kennzahlen-rohdaten.csv")
    with open(pfad, encoding="utf-8", newline="") as f:
        roh = {z["Kennzahl"]: int(z["Wert"]) for z in csv.DictReader(f)}
    update = [v for k, v in roh.items() if k.startswith("Tage bis Einspielen")]

    schulung = roh["Mitarbeitende mit Schulung im Jahr"] / roh["Mitarbeitende gesamt"] * 100
    mittel = statistics.mean(update)
    median = statistics.median(update)
    innerhalb = sum(1 for t in update if t <= ZIEL_UPDATE_TAGE) / len(update) * 100
    restore = roh["Wiederherstellungstests erfolgreich durchgeführt"] / roh["Wiederherstellungstests geplant"] * 100
    vorfaelle = roh["Sicherheitsvorfälle innerhalb Zielzeit behandelt"] / roh["Sicherheitsvorfälle im Quartal"] * 100

    def zeile(name, wert, ziel, einheit, groesser_besser=True):
        ok = wert >= ziel if groesser_besser else wert <= ziel
        print(f"{name:55} {wert:7.1f} {einheit:6} Ziel {'>=' if groesser_besser else '<='} {ziel:5.1f}  {'erreicht' if ok else 'verfehlt'}")

    print("Kennzahlen (Zielwerte sind Annahmen der Übung)\n")
    zeile("Anteil geschulter Mitarbeitender", schulung, ZIEL_SCHULUNG, "%")
    zeile("Dauer bis zum Einspielen kritischer Updates (Mittelwert)", mittel, ZIEL_UPDATE_TAGE, "Tage", False)
    print(f"{'  Median der Dauer':55} {median:7.1f} {'Tage':6}")
    zeile("Anteil kritischer Updates innerhalb von 3 Tagen", innerhalb, 80.0, "%")
    zeile("Erfolgreiche Wiederherstellungstests", restore, ZIEL_RESTORE, "%")
    zeile("Vorfälle innerhalb der Zielzeit behandelt", vorfaelle, ZIEL_VORFAELLE, "%")


if __name__ == "__main__":
    main()
