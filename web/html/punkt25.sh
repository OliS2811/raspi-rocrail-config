#!/bin/bash
# Spielt die per punkt24.sh geladene neue Version ein.
#
# WICHTIG: Dieses Skript überschreibt gleich /var/www/html - also auch sich
# selbst. Ein laufendes Bash-Skript liest seine Datei aber weiter Zeile für
# Zeile nach, während es läuft; würde man es an Ort und Stelle überschreiben,
# könnte es sich mitten in der Ausführung selbst zerstören. Deshalb kopiert
# es sich beim ersten Aufruf nach /tmp und führt sich von dort aus zu Ende -
# unabhängig davon, was anschließend mit dem Original in /var/www/html passiert.
SELF="/tmp/.rocrail_apply_update.sh"
if [ "$(readlink -f "$0")" != "$SELF" ]; then
  cp "$0" "$SELF"
  chmod +x "$SELF"
  exec "$SELF"
fi

SRC_DIR="$HOME/.raspi-rocrail-config-src"
BACKUP_DIR="$HOME/WebinterfaceBackups"

if [ ! -d "$SRC_DIR/.git" ]; then
  echo "[FEHLER] Kein Quellcode vorhanden. Bitte zuerst auf Updates prüfen."
  exit 1
fi

echo "[INFO] Lade neuesten Quellcode..."
if ! git -C "$SRC_DIR" pull -q; then
  echo "[FEHLER] Aktualisierung fehlgeschlagen. Bitte Internetverbindung prüfen."
  exit 1
fi

# Grobe Plausibilitätsprüfung, bevor überhaupt etwas überschrieben wird
for REQUIRED in VERSION.txt web/html web/fix_permissions.sh raspi-rocrail-config startrocrail.sh update1.sh; do
  if [ ! -e "$SRC_DIR/$REQUIRED" ]; then
    echo "[FEHLER] Heruntergeladener Quellcode ist unvollständig ($REQUIRED fehlt). Update wird abgebrochen."
    exit 1
  fi
done

echo "[INFO] Sichere aktuellen Stand des Webinterfaces..."
mkdir -p "$BACKUP_DIR"
BACKUP_ZIP="$BACKUP_DIR/webinterface_backup_$(date +'%Y-%m-%d_%H-%M').zip"
# sudo ist hier nötig: einige *.php-Dateien haben durch fix_permissions.sh
# den Modus 751 (kein Lesen für "Andere"), ein zip als einfacher Nutzer "pi"
# würde sie sonst stillschweigend auslassen und ein unvollständiges,
# gefährliches Backup erzeugen.
sudo zip -r "$BACKUP_ZIP" /var/www/html "$HOME/raspi-rocrail-config" "$HOME/startrocrail.sh" "$HOME/update1.sh" -x "/var/www/html/tmp/*" > /dev/null
sudo chown "$(id -un):$(id -gn)" "$BACKUP_ZIP" 2>/dev/null

if [ ! -f "$BACKUP_ZIP" ]; then
  echo "[FEHLER] Sicherheits-Backup fehlgeschlagen - Update wird abgebrochen, um nichts zu riskieren."
  exit 1
fi

# Vollständigkeit grob prüfen: die wichtigsten Dateien müssen im Backup sein,
# sonst lieber abbrechen als ein Update auf Basis eines kaputten Backups zu riskieren.
for REQUIRED_ENTRY in "var/www/html/index.html" "var/www/html/fix_permissions.sh" "var/www/html/run.php"; do
  if ! unzip -l "$BACKUP_ZIP" | command grep -q "$REQUIRED_ENTRY"; then
    echo "[FEHLER] Sicherheits-Backup ist unvollständig ($REQUIRED_ENTRY fehlt) - Update wird abgebrochen, um nichts zu riskieren."
    exit 1
  fi
done
echo "[OK] Sicherheits-Backup gespeichert: $BACKUP_ZIP"

# Alte Backups (>30 Tage) aufräumen, wie beim Rocrail-Backup üblich
find "$BACKUP_DIR" -name 'webinterface_backup_*.zip' -mtime +30 -delete

echo "[INFO] Spiele neue Version ein..."
FEHLER=0

sudo find /var/www/html -mindepth 1 -maxdepth 1 ! -name tmp -exec rm -rf {} +
sudo cp -a "$SRC_DIR/web/html/." /var/www/html/ || FEHLER=1
sudo cp "$SRC_DIR/web/fix_permissions.sh" /var/www/html/fix_permissions.sh || FEHLER=1
sudo cp "$SRC_DIR/VERSION.txt" /var/www/html/VERSION.txt || FEHLER=1

# rm vor cp: falls diese Dateien durch eine frühere Wiederherstellung als
# root angelegt wurden, könnte "pi" eine bestehende Datei sonst nicht
# überschreiben, obwohl "pi" sein eigenes Home-Verzeichnis besitzt und sie
# jederzeit löschen und neu anlegen darf.
rm -f "$HOME/raspi-rocrail-config" && cp "$SRC_DIR/raspi-rocrail-config" "$HOME/raspi-rocrail-config" && chmod +x "$HOME/raspi-rocrail-config" || FEHLER=1
rm -f "$HOME/startrocrail.sh" && cp "$SRC_DIR/startrocrail.sh" "$HOME/startrocrail.sh" && chmod +x "$HOME/startrocrail.sh" || FEHLER=1
rm -f "$HOME/update1.sh" && cp "$SRC_DIR/update1.sh" "$HOME/update1.sh" && chmod +x "$HOME/update1.sh" || FEHLER=1

if [ ! -f "/var/www/html/index.html" ]; then
  echo "[FEHLER] /var/www/html sieht nach dem Kopieren unvollständig aus."
  FEHLER=1
fi

echo "[INFO] Setze Dateiberechtigungen..."
sudo bash /var/www/html/fix_permissions.sh || FEHLER=1

if [ "$FEHLER" -eq 0 ]; then
  echo "[OK] Update abgeschlossen."
else
  echo "[FEHLER] Update lief nicht vollständig fehlerfrei durch - bitte oben stehende Meldungen prüfen. Falls nötig: über 'Frühere Version wiederherstellen' zurücksetzen."
  exit 1
fi
