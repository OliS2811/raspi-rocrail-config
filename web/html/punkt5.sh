#!/bin/bash
echo "[INFO] Backup wird erstellt..."

SRC="$HOME/Documents/Rocrail"
DEFAULT_DEST="$HOME/Backups"
LOGFILE="$DEFAULT_DEST/backup.log"
DATE=$(date +'%Y-%m-%d_%H-%M')

# 1) USB‑Mountpoint suchen
USB_MP=""
for MP in /media/usb*; do
  if [ -d "$MP" ] && mountpoint -q "$MP"; then
    USB_MP="$MP"
    break
  fi
done

if [ -n "$USB_MP" ]; then
  DEST="$USB_MP/Backups"
  echo "[INFO] USB-Stick erkannt – Sicherung nach: $DEST"
else
  DEST="$DEFAULT_DEST"
  echo "[INFO] Kein USB-Stick erkannt – Sicherung nach: $DEST"
fi

# 2) Quelle prüfen
if [ ! -d "$SRC" ]; then
  echo "[FEHLER] Quellordner '$SRC' existiert nicht."
  exit 1
fi

# 3) Backup-Verzeichnis anlegen
mkdir -p "$DEST"

ZIPFILE="$DEST/rocrail_backup_$DATE.zip"
echo "[INFO] Sichere nach: $ZIPFILE"
zip -r "$ZIPFILE" "$SRC" > /dev/null 2>&1

if [ -f "$ZIPFILE" ]; then
  echo "[OK] Backup gespeichert: $ZIPFILE"
  echo "$(date +'%Y-%m-%d %H:%M') Backup: $ZIPFILE" >> "$LOGFILE"
else
  echo "[FEHLER] Backup fehlgeschlagen!"
  echo "$(date +'%Y-%m-%d %H:%M') Fehler beim Backup!" >> "$LOGFILE"
fi

# 4) Alte Backups löschen
OLD=$(find "$DEST" -name 'rocrail_backup_*.zip' -mtime +30)
if [ -n "$OLD" ]; then
  echo "[INFO] Alte Backups (>30 Tage) in $DEST werden gelöscht…"
  find "$DEST" -name 'rocrail_backup_*.zip' -mtime +30 -delete
else
  echo "[INFO] Keine alten Backups (>30 Tage) in $DEST gefunden."
fi
