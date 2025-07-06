#!/bin/bash

echo "[INFO] Ersteinrichtung – Verzeichnisse, Startskript & Automatisierungen..."

# 1) Verzeichnisse anlegen
mkdir -p "$HOME/Documents/Rocrail/images"
mkdir -p "$HOME/Rocrail/bin"

# 2) Startskript erzeugen (nur, wenn noch nicht vorhanden)
if [ ! -f "$HOME/Rocrail/startrocrail.sh" ]; then
  echo "[INFO] Erzeuge startrocrail.sh..."
  cat > "$HOME/Rocrail/startrocrail.sh" <<'EOF'
#!/bin/sh
# Standard: Benutzer-Arbeitsverzeichnis
Arbeitsbereich="$HOME/Documents/Rocrail"
# Falls ein Pfad übergeben wurde, verwende diesen
if [ -n "$1" ]; then
  Arbeitsbereich="$1"
fi
cd "$HOME/Rocrail" || exit 1
nohup "$HOME/Rocrail/bin/rocrail" \
  -l "$HOME/Rocrail/bin" \
  -w "$Arbeitsbereich" \
  -img "$Arbeitsbereich/images" \
  -f -pwr > /dev/null 2>&1 &
EOF
  chmod +x "$HOME/Rocrail/startrocrail.sh"
  echo "[OK] startrocrail.sh erstellt und ausführbar gemacht."
else
  echo "[INFO] startrocrail.sh ist bereits vorhanden – keine Änderung."
fi

# 3) Symlink im Home-Verzeichnis setzen (Überschreibung gewollt)
ln -sf "$HOME/Rocrail/startrocrail.sh" "$HOME/startrocrail.sh"

# 4) Zeitsynchronisation einrichten
echo "[INFO] Zeitsynchronisation einrichten…"
if ! dpkg -s ntp &>/dev/null; then
  echo "[INFO] Installiere NTP…"
  sudo apt-get install -y ntp
fi
echo "[INFO] starte NTP-Dienst…"
sudo systemctl enable ntp.service 2>/dev/null || true
sudo systemctl restart ntp.service
echo "[INFO] Warte 10 Sekunden auf NTP Sync…"
sleep 10

# 5) Paketquellen aktualisieren
echo "[INFO] Aktualisiere Paketlisten…"
sudo apt-get update

# 6) USB‑Automount per externem Skript
if [ -x "$HOME/install-usbmount.sh" ]; then
  echo "[INFO] USB-Automount installieren…"
  bash "$HOME/install-usbmount.sh"
  echo "[OK] USB-Automount eingerichtet."
else
  echo "[WARNUNG] install-usbmount.sh nicht gefunden – USB-Automount übersprungen."
fi

echo "[OK] Ersteinrichtung abgeschlossen."
