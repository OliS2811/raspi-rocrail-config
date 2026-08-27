#!/bin/bash
# Prüft, ob eine Rocweb-Lizenzdatei vorhanden ist - Voraussetzung dafür,
# dass die Mini-Vorschau im Webinterface überhaupt etwas anzeigen kann.

if [ -f "$HOME/Rocrail/lic.dat" ]; then
  echo "LIZENZ_OK"
else
  echo "LIZENZ_FEHLT"
fi
