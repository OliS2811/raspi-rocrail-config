#!/bin/bash
# Sichert plan.xml automatisch in einem lokalen Git-Verlauf, falls sich die
# Datei seit der letzten Sicherung verändert hat. Läuft komplett lokal,
# ohne Internetverbindung und ohne Zutun des Nutzers.

source "$(dirname "$0")/rocrail_workdir.sh"
PLAN="plan.xml"

[ -f "$REPO/$PLAN" ] || exit 0

cd "$REPO" || exit 0

if [ ! -d .git ]; then
  git init -q
  git config user.name "Rocrail Automatik"
  git config user.email "rocrail@lokal"
fi

git add "$PLAN"

if ! git diff --cached --quiet; then
  git commit -q -m "Automatische Sicherung $(date '+%Y-%m-%d %H:%M')"
  echo "[PLAN_CHANGED]"
fi
