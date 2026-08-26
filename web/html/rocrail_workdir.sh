# Zum Einbinden (source) gedacht, kein eigenständiges Skript.
# Setzt $REPO auf das zuletzt gestartete Rocrail-Arbeitsverzeichnis
# (normale Anlage oder Wiki-Demo), damit der Planänderungs-Verlauf zum
# jeweils aktiven Verzeichnis passt statt immer fest auf
# ~/Documents/Rocrail zu zeigen.

WORKDIR_FILE="$HOME/.rocrail_workdir"

if [ -s "$WORKDIR_FILE" ]; then
  REPO=$(cat "$WORKDIR_FILE")
else
  REPO="$HOME/Documents/Rocrail"
fi
