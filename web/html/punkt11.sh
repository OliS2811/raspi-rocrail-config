#!/bin/bash

echo "[INFO] WLAN einrichten..."

# Lies SSID und Passwort aus POST-Daten (siehe dazu AJAX/Webseite)
SSID_FILE="/tmp/wifi_ssid"
PASS_FILE="/tmp/wifi_pass"

if [ ! -f "$SSID_FILE" ] || [ ! -f "$PASS_FILE" ]; then
  echo "[FEHLER] SSID oder Passwort nicht übergeben."
  exit 1
fi

SSID=$(cat "$SSID_FILE")
PASS=$(cat "$PASS_FILE")

# Konfigurationsdatei schreiben
sudo tee /etc/wpa_supplicant/wpa_supplicant.conf > /dev/null <<EOF
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1
country=DE

network={
    ssid="$SSID"
    psk="$PASS"
}
EOF

echo "[INFO] Stoppe evtl. laufenden wpa_supplicant..."
sudo systemctl stop wpa_supplicant
sudo pkill -f wpa_supplicant
sudo rm -f /var/run/wpa_supplicant/wlan0

echo "[INFO] WLAN-Schnittstelle aktivieren..."
sudo ip link set wlan0 up
sudo rfkill unblock wifi

echo "[INFO] Starte wpa_supplicant manuell..."
sudo wpa_supplicant -B -i wlan0 -c /etc/wpa_supplicant/wpa_supplicant.conf -D nl80211,wext

echo "[INFO] Hole IP-Adresse via DHCP..."
sudo dhclient wlan0 || echo "[WARNUNG] DHCP fehlgeschlagen"

echo "[INFO] Verbindung prüfen..."
if iw wlan0 link | grep -q "Connected"; then
  echo "[OK] WLAN-Verbindung erfolgreich:"
  iw wlan0 link | grep -E "SSID|signal"
else
  echo "[FEHLER] WLAN-Verbindung nicht hergestellt."
fi
