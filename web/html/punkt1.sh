#!/bin/bash
echo "[INFO] Rocrail wird installiert..."

ARCH=$(uname -m)

if [ "$ARCH" = "aarch64" ]; then
  URL="https://www.rocrail.online/rocrail-snapshot/Rocrail-PiOS11-ARM64.zip"
  echo "[INFO] 64-Bit System erkannt – lade ARM64-Version"
else
  URL="https://www.rocrail.online/rocrail-snapshot/Rocrail-PiOS11-ARMHF.zip"
  echo "[INFO] 32-Bit System erkannt – lade ARMHF-Version"
fi

mkdir -p "$HOME/Downloads/Rocrail"
cd "$HOME/Downloads/Rocrail" || exit 1

if ! wget --no-check-certificate "$URL" -O Rocrail.zip; then
  echo "[FEHLER] Download fehlgeschlagen. Bitte Internetverbindung prüfen."
  echo "[FEHLER] URL: $URL"
  exit 1
fi

# Prüfen, ob wirklich ein ZIP-Archiv heruntergeladen wurde (wget wertet auch
# eine HTML-Fehlerseite als "Erfolg", wenn der Server z.B. 200 OK liefert)
if ! unzip -tq Rocrail.zip > /dev/null 2>&1; then
  echo "[FEHLER] Heruntergeladene Datei ist kein gültiges ZIP-Archiv."
  echo "[FEHLER] Download vermutlich fehlgeschlagen oder URL nicht mehr gültig."
  exit 1
fi

# Vorhandene startrocrail.sh sichern, falls sie existiert
if [ -f "$HOME/Rocrail/startrocrail.sh" ]; then
  echo "[INFO] Sichere vorhandene startrocrail.sh..."
  cp "$HOME/Rocrail/startrocrail.sh" "$HOME/startrocrail_backup.sh"
fi

if ! unzip -o Rocrail.zip -d "$HOME/Rocrail"; then
  echo "[FEHLER] Entpacken fehlgeschlagen."
  exit 1
fi

if [ ! -f "$HOME/Rocrail/bin/rocrail" ]; then
  echo "[FEHLER] rocrail-Programmdatei fehlt nach dem Entpacken (${HOME}/Rocrail/bin/rocrail)."
  exit 1
fi

chmod +x "$HOME/Rocrail/bin/rocrail"

# Wiederherstellen, falls nötig
if [ -f "$HOME/startrocrail_backup.sh" ]; then
  echo "[INFO] Stelle eigene startrocrail.sh wieder her..."
  mv "$HOME/startrocrail_backup.sh" "$HOME/Rocrail/startrocrail.sh"
  chmod +x "$HOME/Rocrail/startrocrail.sh"
fi

echo "[OK] Rocrail erfolgreich installiert."
echo "[HINWEIS] Bitte jetzt das System manuell neu starten, z. B. über Menüpunkt 8 (System neu starten)."
