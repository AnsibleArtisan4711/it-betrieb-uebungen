# Architekturbeschreibung example.com (fiktiv, Beispiel)

Die example.com betreibt ein Büro mit rund 200 Arbeitsplätzen und drei Services:

- **E-Mail und Kalender** für alle Mitarbeiter (Server im Rechenzentrum).
- **ERP-System** für Auftragsabwicklung, Server `10.10.10.50`, Datenbank `10.5.5.10`.
- **File-Sharing** für Dokumente der Abteilungen.

Netz: Gateway/Core-Router `10.0.0.1` (Internet, Firewall), Büro-Netz `10.1.0.0/16`, WLAN der Konferenzräume `10.2.0.0/24`.
Alle Angaben sind frei erfunden.
