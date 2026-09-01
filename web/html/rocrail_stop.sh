#!/bin/bash
# Beendet einen laufenden Rocrail-Prozess und wartet, bis er wirklich beendet ist,
# damit plan.xml vollständig geschrieben ist, bevor weitergemacht wird.

pid=$(pgrep -x rocrail)
if [ -n "$pid" ]; then
  # Laut offizieller Rocrail-Doku (wiki.rocrail.net, rocrail-linux-user-en)
  # ist "kill"/"killall rocrail" der vorgesehene Weg zum Beenden unter Linux -
  # Rocrail faengt SIGTERM ab und speichert dabei rocrail.ini/Plan/occ.xml
  # selbst. Bewusst ohne -console/Netzwerk-Protokoll-Tricks, damit RocViews
  # eigenes "Rocrail und Rocview beenden"-Menue nutzbar bleibt. Die
  # Wartezeit ist grosszuegig, weil das bei aktiven Hardware-Interfaces
  # (Z21, Booster) je nach Verbindung spuerbar dauern kann.
  kill "$pid"

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
