#!/bin/bash
# Sichert plan.xml (und rocrail.ini) automatisch in einem lokalen Git-Verlauf,
# falls sich der Plan seit der letzten Sicherung veraendert hat. Laeuft
# komplett lokal, ohne Internetverbindung und ohne Zutun des Nutzers.

source "$(dirname "$0")/rocrail_workdir.sh"
PLAN="plan.xml"
INI="rocrail.ini"

[ -f "$REPO/$PLAN" ] || exit 0

cd "$REPO" || exit 0

if [ ! -d .git ]; then
  git init -q
  git config user.name "Rocrail Automatik"
  git config user.email "rocrail@lokal"
fi

git add "$PLAN"
# rocrail.ini (Zentralen-/Netzwerk-Konfiguration) wird bei jeder echten
# Sicherung passiv mitversioniert, damit auch Konfigurationsaenderungen
# nachvollziehbar sind - loest aber selbst KEINE Sicherung aus (enthaelt
# u.a. die Uhrzeit, die sich staendig aendert) und wird nicht auf "hat sich
# etwas geaendert" geprueft, siehe unten.
[ -f "$INI" ] && git add "$INI"

if git diff --cached --quiet; then
  exit 0
fi

# Rocrail schreibt beim Start/Stopp mehrere Laufzeit-Attribute automatisch
# mit, die keine echte Planaenderung sind:
# - operated="..."  Weichen-Schaltzaehler (Selbsttest beim Start)
# - actor="..."     wer/was das Element zuletzt angefasst hat
# - locid="..."     welche Lok gerade in einem Block erkannt wird
#                    (Belegtmelder-Neubewertung beim Start, keine Bearbeitung)
# - der Anzeigetext des Status-Feldes "tx_controller_state_power" (Power ON/OFF)
# Wenn der Unterschied zum letzten Commit ausschliesslich aus diesen
# Laufzeit-Werten besteht, wird nicht committet.
normalize() {
  sed -E \
    -e 's/operated="[0-9]+"/operated="X"/g' \
    -e 's/actor="[^"]*"/actor="X"/g' \
    -e 's/locid="[^"]*"/locid="X"/g' \
    -e 's/(id="tx_controller_state_power"[^>]*text)="[^"]*"/\1="X"/'
}
if git rev-parse --verify -q HEAD > /dev/null; then
  if diff -q \
      <(git show HEAD:"$PLAN" | normalize) \
      <(normalize < "$PLAN") \
      > /dev/null; then
    # Keine echte Planaenderung - auch rocrail.ini wieder unstagen, sonst
    # bleibt es (z.B. wegen der Uhrzeit) dauerhaft haengen.
    git reset -q "$PLAN" "$INI"
    exit 0
  fi
fi

git commit -q -m "Automatische Sicherung $(date '+%Y-%m-%d %H:%M')"
echo "[PLAN_CHANGED]"
