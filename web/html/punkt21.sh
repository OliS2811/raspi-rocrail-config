#!/bin/bash
# Prüft, ob Rocrail bereits installiert ist - Grundlage für die
# Sicherheitsabfrage vor einer (Neu-)Installation im Webinterface.

if [ -f "$HOME/Rocrail/bin/rocrail" ]; then
  echo "INSTALLIERT"
else
  echo "NICHT_INSTALLIERT"
fi
