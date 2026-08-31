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

# Rocrail schreibt beim Start/Stopp mehrere Laufzeit-Attribute automatisch
# mit, die keine echte Planaenderung sind:
# - operated="..."  Weichen-Schaltzaehler (Selbsttest beim Start)
# - actor="..."     wer/was das Element zuletzt angefasst hat
# - der Anzeigetext des Status-Feldes "tx_controller_state_power" (Power ON/OFF)
# Wenn der Unterschied zum letzten Commit ausschliesslich aus diesen
# Laufzeit-Werten besteht, wird nicht committet.
normalize() {
  sed -E \
    -e 's/operated="[0-9]+"/operated="X"/g' \
    -e 's/actor="[^"]*"/actor="X"/g' \
    -e 's/(id="tx_controller_state_power"[^>]*text)="[^"]*"/\1="X"/'
}
if git rev-parse --verify -q HEAD > /dev/null; then
  if diff -q \
      <(git show HEAD:"$PLAN" | normalize) \
      <(normalize < "$PLAN") \
      > /dev/null; then
    git reset -q "$PLAN"
    exit 0
  fi
fi

git commit -q -m "Automatische Sicherung $(date '+%Y-%m-%d %H:%M')"
echo "[PLAN_CHANGED]"
