#!/bin/bash
echo "[INFO] Starte Update über update1.sh..."

if pgrep -x rocrail > /dev/null; then
  echo "[WARNUNG] Rocrail läuft noch!"
  echo "[HINWEIS] Bitte stoppen Sie Rocrail zuerst über Menüpunkt 3."
  exit 1
sleep 5
fi

if [ -x "$HOME/update1.sh" ]; then
  (
    bash "$HOME/update1.sh"
    echo "[INFO] Update fertig."
  )
sleep 5
else
  echo "[FEHLER] update1.sh fehlt oder ist nicht ausführbar!"
fi
