#!/bin/bash
# Beendet einen laufenden Rocrail-Prozess und wartet, bis er wirklich beendet ist,
# damit plan.xml vollständig geschrieben ist, bevor weitergemacht wird.

pid=$(pgrep -x rocrail)
if [ -n "$pid" ]; then
  kill "$pid"

  for i in $(seq 1 15); do
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
