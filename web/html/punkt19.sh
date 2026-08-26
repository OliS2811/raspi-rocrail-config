#!/bin/bash
# Stellt eine frühere Version von plan.xml aus dem lokalen Git-Verlauf wieder her.

source "$(dirname "$0")/rocrail_workdir.sh"
HASHFILE="/var/www/html/tmp/.plan_restore"

if [ ! -d "$REPO/.git" ]; then
  echo "[FEHLER] Noch keine Planänderungen erfasst."
  exit 1
fi

if pgrep -x rocrail > /dev/null; then
  echo "[FEHLER] Rocrail läuft noch – bitte zuerst stoppen (Punkt 3), sonst wird die Wiederherstellung sofort wieder überschrieben."
  exit 1
fi

if [ ! -f "$HASHFILE" ]; then
  echo "[FEHLER] Keine Version übergeben."
  exit 1
fi

HASH=$(cat "$HASHFILE")
rm -f "$HASHFILE"

if ! [[ "$HASH" =~ ^[0-9a-f]{7,40}$ ]]; then
  echo "[FEHLER] Ungültige Version."
  exit 1
fi

if git -C "$REPO" checkout "$HASH" -- plan.xml; then
  echo "[OK] plan.xml wurde auf den Stand vom ausgewählten Zeitpunkt zurückgesetzt."
else
  echo "[FEHLER] Wiederherstellung fehlgeschlagen."
fi
