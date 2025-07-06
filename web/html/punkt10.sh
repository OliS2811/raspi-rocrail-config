#!/bin/bash

echo "[INFO] Prüfe, ob Rocrail bereits läuft…"

if pgrep -x rocrail > /dev/null; then
  echo "[WARNUNG] Rocrail läuft bereits – bitte zuerst stoppen (Punkt 3)."
else
  echo "[INFO] Rocrail wird im Demo-Modus (wikidemo) gestartet..."
  DEMO_DIR="$HOME/Rocrail/wikidemo"
  mkdir -p "$DEMO_DIR/images"
  cp -n "$HOME/Rocrail/wikidemo/plan.xml" "$DEMO_DIR/" 2>/dev/null
  "$HOME/Rocrail/startrocrail.sh" "$DEMO_DIR"
  echo "[OK] Demo-Modus gestartet."
fi
