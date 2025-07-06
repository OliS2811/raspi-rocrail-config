#!/bin/bash
echo "[INFO] Starte Rocrail im aktuellen Benutzerverzeichnis..."

nohup "$HOME/Rocrail/bin/rocrail" -l "$HOME/Rocrail/bin" -w "$HOME/Documents/Rocrail" -img "$HOME/Documents/Rocrail/images" -f -pwr > /dev/null 2>&1 &
sleep 2

pid=$(pgrep -x rocrail)
if [ -n "$pid" ]; then
  echo "[OK] Rocrail gestartet (PID: $pid)."
else
  echo "[FEHLER] Rocrail konnte nicht gestartet werden."
fi
