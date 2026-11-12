# 05 Linux-Server, Open-Source-Dienste und Plattformbetrieb

Übung **05.1**: Distributionen vergleichen, Ubuntu Server 24.04 per netplan ins Labornetz einbinden, Rechte mit Setgid, Pakete, eigener systemd-Dienst mit Fehleranalyse, SSH-Schlüssel, Protokolle, Härtung mit `ufw`. Geschätzte Zeit: 6,75 Stunden (Lehrplan: 9 UE).

> Linux-Teile in der Testumgebung real geprüft (Rechte, Unit-Prüfung, sshd-Vorrang, netplan), siehe `beispiele/05-testlauf.txt`. Nicht geprüft: Hyper-V, `ufw` aktiv, `systemctl`/`journalctl`, SSH über das Netz.

| Datei | Zweck |
|---|---|
| `05.1-linux-server-und-plattformbetrieb.md` | Die Übung |
| `05.1-netplan-lx-ubu01.yaml` | Netzkonfiguration (MAC-Adressen sind Platzhalter) |
| `05.1-gruppe-und-rechte.sh` | Gruppe, Benutzer, Setgid-Verzeichnis (mit `-n` und `-r`) |
| `05.1-lab-hello.sh`, `05.1-lab-hello.service` | Beispieldienst |
| `05.1-ssh-lab-haertung.conf` | SSH-Drop-in (`10-` wegen Vorrang) |
| `05.1-ufw-regeln.sh` | Firewall mit Sicherheitsabfrage (mit `-n`) |
| `05.1-haertung-pruefen.sh` | Ist-Zustand lesen |
| `beispiele/05-testlauf.txt` | Echte Ausgaben des Testlaufs |
