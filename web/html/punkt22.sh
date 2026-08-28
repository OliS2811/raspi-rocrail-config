#!/bin/bash
# Listet vorhandene Rocrail-Backup-ZIPs (lokal und USB) für die
# Wiederherstellen-Funktion im Webinterface.

# usbmount legt neben dem echten Mountpoint (z.B. /media/usb0) zusätzlich
# einen Symlink /media/usb auf das erste Gerät an - ohne Abgleich über den
# aufgelösten Pfad würden dieselben Backups doppelt aufgelistet.
SEEN=""

for DIR in "$HOME/Backups" /media/usb*/Backups; do
  [ -d "$DIR" ] || continue
  REAL=$(realpath "$DIR")
  case " $SEEN " in
    *" $REAL "*) continue ;;
  esac
  SEEN="$SEEN $REAL"

  if [ "$DIR" = "$HOME/Backups" ]; then
    ORT="Lokal auf dem Pi"
  else
    ORT="USB-Stick ($(basename "$(dirname "$DIR")"))"
  fi

  for f in "$DIR"/rocrail_backup_*.zip; do
    [ -f "$f" ] || continue
    SIZE_MB=$(du -m "$f" 2>/dev/null | cut -f1)
    DATUM=$(date -r "$f" '+%d.%m.%Y %H:%M')
    echo "${f}|${DATUM}|${SIZE_MB} MB|${ORT}"
  done
done
