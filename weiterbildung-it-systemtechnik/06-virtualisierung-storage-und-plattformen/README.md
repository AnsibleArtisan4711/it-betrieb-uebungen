# 06 Virtualisierung, Storage und Plattformen für Rechenzentrum und Edge

Übung **06.1** (Priorität 2, Vertiefung): Hypervisoren vergleichen, VM exportieren und als Klon im isolierten Switch importieren, Dynamic Memory und Überbuchung, feste und dynamische VHDX, Checkpoints, Switch-Typen, Fehlerbilder. Geschätzte Zeit: 6,75 Stunden (Lehrplan: 9 UE).

> Rechenhilfe real ausgeführt; PowerShell nur auf Syntax geprüft, Hyper-V nicht verwendet. Kein Pflichtmodul hängt von diesem Modul ab.

| Datei | Zweck |
|---|---|
| `06.1-virtualisierung-storage-und-plattformen.md` | Die Übung |
| `06.1-klon-importieren.ps1` | Export, Import als Kopie, Umbenennen, Adapter isolieren (vor dem Start) |
| `06.1-klon-rueckbau.ps1` | Klon entfernen, nur nach Pfadprüfung |
| `06.1-vhd-vergleich.ps1` | Feste und dynamische VHDX anlegen und löschen |
| `06.1-switch-typen.ps1` | Internen Switch anlegen und entfernen |
| `06.1-ueberbuchung.py` | Rechenhilfe Überbuchungsfaktor (real ausgeführt) |
| `06.1-vorlagen.md` | Vergleichstabellen, Messwerte, Fallstudien |
| `beispiele/06-ueberbuchung-ausgabe.txt` | Echte Ausgabe der Rechenhilfe |
