#!/bin/bash
# Nicht ausgeführt. Nur Laborwerte.
sudo useradd --system --no-create-home --shell /usr/sbin/nologin mailpit
sudo mkdir -p /etc/mailpit
echo 'zammad:Lab-Passwort-1' | sudo tee /etc/mailpit/pop3users.txt
sudo chown root:mailpit /etc/mailpit/pop3users.txt
sudo chmod 640 /etc/mailpit/pop3users.txt
