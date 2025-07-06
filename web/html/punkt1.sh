#!/bin/bash
echo "[INFO] Rocrail wird installiert..."

ARCH=$(uname -m)

if [ "$ARCH" = "aarch64" ]; then
  URL="https://wiki.rocrail.net/rocrail-snapshot/Rocrail-PiOS11-ARM64.zip"
  echo "[INFO] 64-Bit System erkannt – lade ARM64-Version"
else
  URL="https://wiki.rocrail.net/rocrail-snapshot/Rocrail-PiOS11-ARMHF.zip"
  echo "[INFO] 32-Bit System erkannt – lade ARMHF-Version"
fi

mkdir -p "$HOME/Downloads/Rocrail"
cd "$HOME/Downloads/Rocrail" || exit 1
wget --no-check-certificate "$URL" -O Rocrail.zip

# Vorhandene startrocrail.sh sichern, falls sie existiert
if [ -f "$HOME/Rocrail/startrocrail.sh" ]; then
  echo "[INFO] Sichere vorhandene startrocrail.sh..."
  cp "$HOME/Rocrail/startrocrail.sh" "$HOME/startrocrail_backup.sh"
fi

unzip -o Rocrail.zip -d "$HOME/Rocrail"
chmod +x "$HOME/Rocrail/bin/rocrail"

# Wiederherstellen, falls nötig
if [ -f "$HOME/startrocrail_backup.sh" ]; then
  echo "[INFO] Stelle eigene startrocrail.sh wieder her..."
  mv "$HOME/startrocrail_backup.sh" "$HOME/Rocrail/startrocrail.sh"
  chmod +x "$HOME/Rocrail/startrocrail.sh"
fi

echo "[OK] Rocrail erfolgreich installiert."
echo "[HINWEIS] Bitte jetzt das System manuell neu starten, z. B. über Menüpunkt 16 (Neustart)."
