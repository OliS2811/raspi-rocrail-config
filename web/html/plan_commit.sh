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

if git diff --cached --quiet; then
  exit 0
fi

# Rocrail schaltet beim Start jedes Feld einmal durch (Selbsttest/Sync) und
# zaehlt das im operated="..."-Attribut jeder Weiche mit - das allein ist
# keine echte Planaenderung. Wenn der Unterschied zum letzten Commit
# ausschliesslich aus diesen Zaehlern besteht, wird nicht committet.
if git rev-parse --verify -q HEAD > /dev/null; then
  if diff -q \
      <(git show HEAD:"$PLAN" | sed -E 's/operated="[0-9]+"/operated="X"/g') \
      <(sed -E 's/operated="[0-9]+"/operated="X"/g' "$PLAN") \
      > /dev/null; then
    git reset -q "$PLAN"
    exit 0
  fi
fi

git commit -q -m "Automatische Sicherung $(date '+%Y-%m-%d %H:%M')"
echo "[PLAN_CHANGED]"
