#!/bin/bash
echo "[INFO] Starte Rocrail im aktuellen Benutzerverzeichnis..."

echo "$HOME/Documents/Rocrail" > "$HOME/.rocrail_workdir"

# Konsolen-Pipe fuer sauberes Beenden, siehe rocrail_stop.sh
FIFO="$HOME/.rocrail_console"
rm -f "$FIFO"
mkfifo "$FIFO"
exec 3<>"$FIFO"

nohup "$HOME/Rocrail/bin/rocrail" -l "$HOME/Rocrail/bin" -w "$HOME/Documents/Rocrail" -img "$HOME/Documents/Rocrail/images" -f -pwr -console <&3 > /dev/null 2>&1 &
exec 3<&-
sleep 2

pid=$(pgrep -x rocrail)
if [ -n "$pid" ]; then
  echo "[OK] Rocrail gestartet (PID: $pid)."
  echo "[RELOAD]"
else
  echo "[FEHLER] Rocrail konnte nicht gestartet werden."
fi
