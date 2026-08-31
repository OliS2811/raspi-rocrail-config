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

# Konsolen-Pipe für sauberes Beenden: rocrail_stop.sh schickt hier "q" rein
# (Rocrails eigenes Shutdown-Kommando), statt sich auf OS-Signale zu
# verlassen, auf die Rocrail bei aktiven Hardware-Interfaces kaum reagiert.
FIFO="$HOME/.rocrail_console"
rm -f "$FIFO"
mkfifo "$FIFO"
exec 3<>"$FIFO"

nohup "$HOME/Rocrail/bin/rocrail" \
  -l "$HOME/Rocrail/bin" \
  -w "$Arbeitsbereich" \
  -img "$Arbeitsbereich/images" \
  -f -pwr -console <&3 > /dev/null 2>&1 &

exec 3<&-
