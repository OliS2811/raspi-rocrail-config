#!/bin/bash

USER="pi"
PASSFILE="/var/www/html/tmp/.smbpass-${USER}"

echo "[INFO] Setze Samba-Passwort für Benutzer '$USER'..."

if [ ! -f "$PASSFILE" ]; then
  echo "[FEHLER] Passwortdatei fehlt. Bitte zuerst über das Webformular eingeben."
  exit 1
fi

echo "[HINWEIS] Passwort wird aus Datei gelesen..."

PASS=$(cat "$PASSFILE")
if (echo "$PASS"; echo "$PASS") | smbpasswd -a "$USER"; then
  echo "[OK] Passwort wurde erfolgreich gesetzt."
  rm -f "$PASSFILE"
else
  echo "[FEHLER] Passwort konnte nicht gesetzt werden."
fi
