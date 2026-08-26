#!/bin/bash
# Ersetzt die automatische Zeitstempel-Nachricht der letzten Plansicherung
# durch die vom Nutzer eingegebene Notiz (gleicher Sicherungspunkt bleibt erhalten).

source "$(dirname "$0")/rocrail_workdir.sh"
NOTEFILE="/var/www/html/tmp/.plan_note"

if [ ! -d "$REPO/.git" ]; then
  echo "[FEHLER] Noch keine Planänderungen erfasst."
  exit 1
fi

if [ ! -f "$NOTEFILE" ]; then
  echo "[FEHLER] Keine Notiz übergeben."
  exit 1
fi

NOTE=$(cat "$NOTEFILE")
rm -f "$NOTEFILE"

if [ -z "$NOTE" ]; then
  echo "[FEHLER] Notiz ist leer."
  exit 1
fi

git -C "$REPO" commit -q --amend -m "$NOTE"
echo "[OK] Notiz gespeichert."
