echo "[INFO] Rocrail Autostart-Eintrag in Crontab prüfen..."
CRON_ENTRY="@reboot /home/pi/Rocrail/startrocrail.sh"

if crontab -l 2>/dev/null | grep -Fxq "$CRON_ENTRY"; then
  echo "[OK] Der Autostart-Eintrag ist bereits vorhanden:"
  echo "     $CRON_ENTRY"
else
  (crontab -l 2>/dev/null; echo "$CRON_ENTRY") | crontab -
  echo "[OK] Autostart-Eintrag hinzugefügt:"
  echo "     $CRON_ENTRY"
fi
read -p "Weiter mit Enter..."
