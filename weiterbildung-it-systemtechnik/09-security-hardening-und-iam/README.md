# 09 Security, Hardening und Identity & Access Management

Übung **09.1**: Ports und Schutzbedarf, Patch-Priorität (Übungsregel), MFA mit Sicherheitsstandards (Cloud-Ausnahme), delegierte Kennwortrücksetzung, `Protected Users`, Ping-Härtung, Checkliste, Soll/Ist der Gruppen, Auditing von Fehlanmeldungen, offene Freigabe, Fehlerbilder. Geschätzte Zeit: 7,5 Stunden (Lehrplan: 10 UE).

> Rechenhilfe und Linux-Skript real ausgeführt; Windows- und Portal-Teile nur auf Syntax geprüft. Viele Befehle *nicht bestätigt*; Auditunterkategorien sind sprachabhängig.

| Datei | Zweck |
|---|---|
| `09.1-security-hardening-und-iam.md` | Die Übung |
| `09.1-angriffsflaeche.ps1` | Lauschende Ports mit Prozess unter Windows (nur lesen) |
| `09.1-angriffsflaeche.sh` | Dasselbe unter Linux mit `ss` (real getestet) |
| `09.1-patch-prioritaet.py` | Meldungen nach Übungsregel ordnen (real ausgeführt) |
| `09.1-delegation-testen.ps1` | Kennwort-Reset als Helpdesk-Konto (interaktive Eingabe) |
| `09.1-icmp-einschraenken.ps1` | Ping-Regel auf Labornetze, mit Rückweg |
| `09.1-audit-anmeldung.ps1` | Audit merken, aktivieren, zurücksetzen, Ereignisse |
| `09.1-freigaben-pruefen.ps1` | Freigaben mit Rechten, offene markieren, optional entfernen |
| `09.1-vorlagen.md` | Tabellen, Checkliste, Protokolle |
| `beispiele/` | Echte Ausgaben der Rechenhilfe und Hinweis zum Linux-Skript |
