#!/bin/bash

PASSFILE="/var/www/html/tmp/.smbpass-pi"

echo "[INFO] Setze Samba-Passwort für Benutzer 'pi'..."

if [ ! -f "$PASSFILE" ]; then
  echo "[HINWEIS] Passwortdatei fehlt. Bitte zuerst über das Webformular eingeben."
  exit 1
fi

echo "[HINWEIS] Passwort wird aus Datei gelesen..."

sudo /usr/local/bin/set_samba_pass.sh "$PASSFILE"
RC=$?

if [ $RC -eq 0 ]; then
  echo "[OK] Passwort erfolgreich gesetzt."
else
  echo "[FEHLER] Passwort konnte nicht gesetzt werden."
fi
