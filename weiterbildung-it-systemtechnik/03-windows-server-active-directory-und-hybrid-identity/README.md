# 03 Windows Server, Active Directory und Hybrid Identity

Übung **03.1**: Rollen einordnen, Domäne `lab.example.internal` aufbauen, Mitglieder aufnehmen, Gruppenrichtlinie (Vorrang der OU), Dateiserver nach AGDLP, Patch-Vorgang mit Rückfallplan, Hybrid Identity als Papierübung, Fehlersuche. Geschätzte Zeit: 7,5 Stunden (Lehrplan: 10 UE).

> Skripte nur auf Syntax geprüft, nichts auf Windows oder in einer Domäne ausgeführt.

| Datei | Zweck |
|---|---|
| `03.1-windows-server-active-directory-und-hybrid-identity.md` | Die Übung |
| `03.1-domaene-aufbauen.ps1` | AD DS installieren, Gesamtstruktur anlegen (DSRM-Abfrage interaktiv) |
| `03.1-ou-und-konten.ps1` | OUs, Konten, Gruppen (Kennwort interaktiv) |
| `03.1-mitglieder-aufnehmen.ps1` | DNS setzen, Domänenbeitritt |
| `03.1-gpo-anlegen.ps1` | GPOs anlegen und verknüpfen, Testzweig, Rückbau |
| `03.1-dateiserver-agdlp.ps1` | E:, Ordner, NTFS- und Freigaberechte |
| `03.1-fehler-einbauen.ps1` | Kursleiter: drei Fehler ein- und ausbauen |
| `03.1-wartungsplan-vorlage.md` | Wartungsplan |
| `03.1-fehlerpfad-vorlage.md` | Fehlerpfade |
