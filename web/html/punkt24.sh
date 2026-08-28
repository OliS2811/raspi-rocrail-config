#!/bin/bash
# Prüft, ob eine neuere Version des Webinterfaces/der Skripte auf GitHub
# verfügbar ist. Verändert nichts, lädt nur den Quellcode in einen
# dauerhaften lokalen Klon (für punkt25.sh) und vergleicht die Versionen.

REPO_URL="https://github.com/OliS2811/raspi-rocrail-config.git"
SRC_DIR="$HOME/.raspi-rocrail-config-src"
LOCAL_VERSION_FILE="/var/www/html/VERSION.txt"

if [ ! -d "$SRC_DIR/.git" ]; then
  echo "[INFO] Lade Projekt-Quellcode erstmalig herunter..."
  if ! git clone -q "$REPO_URL" "$SRC_DIR"; then
    echo "[FEHLER] Download fehlgeschlagen. Bitte Internetverbindung prüfen."
    exit 1
  fi
else
  echo "[INFO] Prüfe auf neue Version..."
  if ! git -C "$SRC_DIR" pull -q; then
    echo "[FEHLER] Aktualisierung fehlgeschlagen. Bitte Internetverbindung prüfen."
    exit 1
  fi
fi

# Erste echte "Version X.Y.Z"-Zeile finden (nicht den Titel "Versionsverlauf"),
# dabei sowohl normales als auch geschütztes Leerzeichen (U+00A0) zwischen
# "Version" und der Nummer berücksichtigen.
extract_version() {
  command grep -m1 -E 'Version[^0-9]{1,3}[0-9]' "$1" 2>/dev/null | sed 's/\xc2\xa0/ /g' | command grep -oE '[0-9]+(\.[0-9]+)*' | head -1
}

REMOTE_VERSION=$(extract_version "$SRC_DIR/VERSION.txt")
if [ -f "$LOCAL_VERSION_FILE" ]; then
  LOCAL_VERSION=$(extract_version "$LOCAL_VERSION_FILE")
else
  LOCAL_VERSION=""
fi

echo "LOKAL=${LOCAL_VERSION:-unbekannt}"
echo "VERFUEGBAR=${REMOTE_VERSION:-unbekannt}"
