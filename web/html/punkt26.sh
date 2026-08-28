#!/bin/bash
# Listet die automatisch vor jedem Update erstellten Sicherheits-Backups des
# Webinterfaces auf (für die Rückgängig-Funktion im Webinterface).

DIR="$HOME/WebinterfaceBackups"
[ -d "$DIR" ] || exit 0

for f in "$DIR"/webinterface_backup_*.zip; do
  [ -f "$f" ] || continue
  SIZE_MB=$(du -m "$f" 2>/dev/null | cut -f1)
  DATUM=$(date -r "$f" '+%d.%m.%Y %H:%M')
  echo "${f}|${DATUM}|${SIZE_MB} MB"
done
