#!/bin/sh

# Standard: Benutzer-Arbeitsverzeichnis
Arbeitsbereich="$HOME/Documents/Rocrail"

# Falls ein Pfad übergeben wurde, verwende diesen
if [ -n "$1" ]; then
  Arbeitsbereich="$1"
fi

# Merken, welches Arbeitsverzeichnis gerade läuft (z.B. für den
# Planänderungs-Verlauf im Webinterface, der sonst immer vom
# Standardverzeichnis ausgehen würde)
echo "$Arbeitsbereich" > "$HOME/.rocrail_workdir"

cd "$HOME/Rocrail" || exit 1

nohup "$HOME/Rocrail/bin/rocrail" \
  -l "$HOME/Rocrail/bin" \
  -w "$Arbeitsbereich" \
  -img "$Arbeitsbereich/images" \
  -f -pwr > /dev/null 2>&1 &
