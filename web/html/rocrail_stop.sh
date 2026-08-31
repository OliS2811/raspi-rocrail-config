#!/bin/bash
# Beendet einen laufenden Rocrail-Prozess und wartet, bis er wirklich beendet ist,
# damit plan.xml vollständig geschrieben ist, bevor weitergemacht wird.

pid=$(pgrep -x rocrail)
if [ -n "$pid" ]; then
  FIFO="$HOME/.rocrail_console"
  if [ -p "$FIFO" ]; then
    # Sauberes Shutdown-Kommando ueber Rocrails eigene Konsole (speichert
    # rocrail.ini/Plan/occ.xml) - reagiert zuverlaessiger als ein OS-Signal.
    # "timeout" schuetzt vor einem haengenden Schreibversuch, falls die FIFO
    # aus irgendeinem Grund keinen Leser (mehr) hat.
    timeout 3 sh -c "echo q > '$FIFO'" 2>/dev/null
  else
    kill "$pid"
  fi

  for i in $(seq 1 60); do
    kill -0 "$pid" 2>/dev/null || break
    sleep 1
  done

  if kill -0 "$pid" 2>/dev/null; then
    echo "[WARNUNG] Rocrail reagiert nicht, wird hart beendet..."
    kill -9 "$pid" 2>/dev/null
    sleep 1
  fi

  echo "[OK] Rocrail wurde beendet (PID: $pid)."
else
  echo "[INFO] Kein laufender Rocrail-Prozess gefunden."
fi
