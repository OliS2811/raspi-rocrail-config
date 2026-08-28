#!/bin/bash
# Stellt einen vorherigen Webinterface-Stand aus einem automatisch vor einem
# Update erstellten Sicherheits-Backup wieder her.
#
# Überschreibt /var/www/html - also auch sich selbst. Siehe punkt25.sh für
# die Begründung des Selbst-Umzugs nach /tmp vor dem eigentlichen Entpacken.
SELF="/tmp/.rocrail_apply_webrestore.sh"
if [ "$(readlink -f "$0")" != "$SELF" ]; then
  cp "$0" "$SELF"
  chmod +x "$SELF"
  exec "$SELF"
fi

RESTOREFILE="/var/www/html/tmp/.webupdate_restore"
BACKUP_DIR="$HOME/WebinterfaceBackups"

if [ ! -f "$RESTOREFILE" ]; then
  echo "[FEHLER] Keine Version ausgewählt."
  exit 1
fi

CHOSEN=$(cat "$RESTOREFILE")
rm -f "$RESTOREFILE"

# Sicherheitscheck: Der gewählte Pfad muss exakt einem tatsächlich vorhandenen
# Webinterface-Backup entsprechen.
VALID=0
for f in "$BACKUP_DIR"/webinterface_backup_*.zip; do
  [ -f "$f" ] || continue
  if [ "$f" = "$CHOSEN" ]; then
    VALID=1
    break
  fi
done

if [ "$VALID" -ne 1 ]; then
  echo "[FEHLER] Ungültiges oder nicht mehr vorhandenes Backup."
  exit 1
fi

echo "[INFO] Stelle vorherigen Webinterface-Stand wieder her: $CHOSEN"
sudo find /var/www/html -mindepth 1 -maxdepth 1 ! -name tmp -exec rm -rf {} +

if ! sudo unzip -o "$CHOSEN" -d / > /dev/null; then
  echo "[FEHLER] Wiederherstellung fehlgeschlagen."
  exit 1
fi

if [ ! -f "/var/www/html/index.html" ] || [ ! -f "/var/www/html/fix_permissions.sh" ]; then
  echo "[FEHLER] Wiederhergestellter Stand sieht unvollständig aus."
  exit 1
fi

# unzip lief als root - die Home-Verzeichnis-Skripte gehören danach root statt
# pi, wodurch pi sie beim nächsten Update nicht mehr überschreiben könnte.
for F in raspi-rocrail-config startrocrail.sh update1.sh; do
  [ -f "$HOME/$F" ] && sudo chown pi:pi "$HOME/$F"
done

echo "[INFO] Setze Dateiberechtigungen..."
if sudo bash /var/www/html/fix_permissions.sh; then
  echo "[OK] Vorheriger Stand wiederhergestellt."
else
  echo "[FEHLER] Dateiberechtigungen konnten nicht gesetzt werden."
  exit 1
fi
