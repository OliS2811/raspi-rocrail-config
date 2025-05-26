#!/bin/sh

echo "[INFO] Rocrail-Update wird gestartet..."

ARCH=$(uname -m)

if [ "$ARCH" = "aarch64" ]; then
  echo "[INFO] 64-Bit System erkannt – lade ARM64-Version"
  SNAPSHOT_URL="https://wiki.rocrail.net/rocrail-snapshot/Rocrail-PiOS11-ARM64.zip"
elif [ "$ARCH" = "armv7l" ]; then
  echo "[INFO] 32-Bit System erkannt – lade ARMHF-Version"
  SNAPSHOT_URL="https://wiki.rocrail.net/rocrail-snapshot/Rocrail-PiOS11-ARMHF.zip"
else
  echo "[FEHLER] Nicht unterstützte Architektur: $ARCH"
  exit 1
fi

# Download-Verzeichnis vorbereiten
mkdir -p ~/Downloads/Rocrail
cd ~/Downloads/Rocrail || exit 1

# Download und Entpacken
wget --no-check-certificate "$SNAPSHOT_URL" -O Rocrail.zip
unzip -u Rocrail.zip

# Dateien kopieren
cp -v ./bin/* ~/Rocrail/bin
cp -v -r ./svg/* ~/Rocrail/svg

# Aufräumen
rm -rv ~/Downloads/Rocrail

# Rocrail neu starten
echo "[INFO] Starte Rocrail neu..."
nohup ~/Rocrail/startrocrail.sh > /dev/null 2>&1 &

echo "[OK] Rocrail-Update abgeschlossen und neu gestartet."
exit 0
