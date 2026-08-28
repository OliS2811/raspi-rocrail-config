#!/bin/bash
# Stellt ein zuvor über Punkt 5 erstelltes Backup-ZIP wieder her.

RESTOREFILE="/var/www/html/tmp/.backup_restore"

if pgrep -x rocrail > /dev/null; then
  echo "[FEHLER] Rocrail läuft noch – bitte zuerst stoppen (Punkt 3), sonst wird die Wiederherstellung sofort wieder überschrieben."
  exit 1
fi

if [ ! -f "$RESTOREFILE" ]; then
  echo "[FEHLER] Kein Backup ausgewählt."
  exit 1
fi

CHOSEN=$(cat "$RESTOREFILE")
rm -f "$RESTOREFILE"

# Sicherheitscheck: Der gewählte Pfad muss exakt einem tatsächlich vorhandenen
# Backup-ZIP aus einem der bekannten Backup-Verzeichnisse entsprechen - so kann
# über die Übergabedatei kein beliebiger Pfad zum Entpacken untergeschoben werden.
VALID=0
for DIR in "$HOME/Backups" /media/usb*/Backups; do
  [ -d "$DIR" ] || continue
  for f in "$DIR"/rocrail_backup_*.zip; do
    [ -f "$f" ] || continue
    if [ "$f" = "$CHOSEN" ]; then
      VALID=1
      break 2
    fi
  done
done

if [ "$VALID" -ne 1 ]; then
  echo "[FEHLER] Ungültiges oder nicht mehr vorhandenes Backup."
  exit 1
fi

echo "[INFO] Sichere aktuellen Stand vor der Wiederherstellung..."
bash "$(dirname "$0")/punkt5.sh"

echo "[INFO] Stelle Backup wieder her: $CHOSEN"
if unzip -o "$CHOSEN" -d / > /dev/null; then
  echo "[OK] Backup wiederhergestellt."
else
  echo "[FEHLER] Wiederherstellung fehlgeschlagen."
  exit 1
fi
