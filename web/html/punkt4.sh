#!/bin/bash
echo "[INFO] Prüfe Rocrail-Status..."

pid=$(pgrep -x rocrail)
if [ -n "$pid" ]; then
  echo "[OK] Rocrail läuft (PID: $pid)."
  ps -p "$pid" -o pid,etime,cmd
else
  echo "[INFO] Rocrail ist nicht aktiv."
fi
