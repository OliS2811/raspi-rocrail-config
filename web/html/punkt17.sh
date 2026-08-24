#!/bin/bash
# Zeigt die Historie der Planänderungen (plan.xml) aus dem lokalen Git-Verlauf.

REPO="$HOME/Documents/Rocrail"

if [ ! -d "$REPO/.git" ]; then
  echo "[INFO] Noch keine Planänderungen erfasst."
  exit 0
fi

if pgrep -x rocrail > /dev/null; then
  echo "ROCRAIL_RUNNING=1"
else
  echo "ROCRAIL_RUNNING=0"
fi

git -C "$REPO" log --pretty=format:'%h|%ad|%s' --date=format:'%d.%m.%Y %H:%M' -n 50 -- plan.xml
echo
