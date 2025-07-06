    if pgrep -x rocrail > /dev/null; then
      echo "[WARNUNG] Rocrail läuft bereits – bitte zuerst stoppen (Punkt 3)."
    else
      echo "[INFO] Rocrail wird im Benutzer-Modus gestartet..."
      "$HOME/Rocrail/startrocrail.sh" "$HOME/Documents/Rocrail"
      echo "[OK] Benutzer-Modus gestartet."
    fi
    ;;
