#!/bin/bash
# Wartung Add-On Installer für Rocrail Webinterface
# (c) Olli 2025

set -e

WEBROOT="/var/www/html"
APIDIR="$WEBROOT/api"
DATADIR="$WEBROOT/data"
SRC="https://raw.githubusercontent.com/OliS2811/raspi-rocrail-config/master/rocrail-addons"

echo "📦 Installiere Add-On 'Lok- & Wagenwartung'..."

sudo mkdir -p "$APIDIR" "$DATADIR"
sudo chown -R www-data:www-data "$DATADIR"
sudo chmod -R 775 "$DATADIR"

sudo curl -fsSL "$SRC/wartung.php"        -o "$WEBROOT/wartung.php"
sudo curl -fsSL "$SRC/wartung_list.php"   -o "$APIDIR/wartung_list.php"
sudo curl -fsSL "$SRC/wartung_save.php"   -o "$APIDIR/wartung_save.php"

echo "✅ Add-On 'Lok- & Wagenwartung' erfolgreich installiert!"