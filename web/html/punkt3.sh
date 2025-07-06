#!/bin/bash
echo "[INFO] Rocrail wird gestoppt..."

pid=$(pgrep -x rocrail)
if [ -n "$pid" ]; then
  kill "$pid"
  echo "[OK] Rocrail wurde beendet (PID: $pid)."
else
  echo "[INFO] Kein laufender Rocrail-Prozess gefunden."
fi
