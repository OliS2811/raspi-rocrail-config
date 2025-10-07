#!/bin/bash
# ==========================================================
# 🚂 Add-On: Lok- & Wagenwartung für Rocrail Webinterface
# Autor: Olli / 2025
# ==========================================================
# Dieses Skript:
#  - richtet bei Bedarf sudo-Regeln für das Webinterface ein
#  - installiert PHP-Dateien ins Webverzeichnis
#  - erstellt Datenordner für Wartungsdateien
# ==========================================================

set -e

# ----------------------------------------------------------
# 🧩 Automatisches Sudo-Setup
# ----------------------------------------------------------
SUDO_FILE="/etc/sudoers.d/rocrail-web"

if [ ! -f "$SUDO_FILE" ]; then
  echo "🔧 Erstelle fehlende Sudo-Regeln für Rocrail Webinterface..."
  sudo bash -c 'cat << "EOF" > /etc/sudoers.d/rocrail-web
# Rocrail Webinterface – automatische Sudoer-Regeln
www-data ALL=(pi) NOPASSWD: \
/usr/bin/git, \
/usr/bin/curl, \
/usr/bin/wget, \
/usr/bin/chmod, \
/usr/bin/chown, \
/usr/bin/mkdir, \
/usr/bin/rm, \
/usr/bin/mv, \
/usr/bin/cp, \
/usr/local/bin/*_addon.sh, \
/usr/local/share/rocrail-addons/*_addon.sh, \
/var/www/html/addons/*_addon.sh, \
/var/www/html/*_addon.sh
Defaults:www-data !requiretty
EOF'
  sudo chmod 440 /etc/sudoers.d/rocrail-web
  echo "✅ Sudo-Regeln erfolgreich eingerichtet."
else
  echo "✅ Sudo-Regeln bereits vorhanden."
fi

# ----------------------------------------------------------
# 📦 Add-On Installation
# ----------------------------------------------------------
WEBROOT="/var/www/html"
APIDIR="$WEBROOT/api"
DATADIR="$WEBROOT/data"
SRC="https://raw.githubusercontent.com/OliS2811/raspi-rocrail-config/master/rocrail-addons"

echo "📦 Installiere Add-On 'Lok- & Wagenwartung'..."

# Verzeichnisse vorbereiten
sudo mkdir -p "$APIDIR" "$DATADIR"
sudo chown -R www-data:www-data "$DATADIR"
sudo chmod -R 775 "$DATADIR"

# PHP-Dateien herunterladen
sudo curl -fsSL "$SRC/wartung.php"        -o "$WEBROOT/wartung.php"
sudo curl -fsSL "$SRC/wartung_list.php"   -o "$APIDIR/wartung_list.php"
sudo curl -fsSL "$SRC/wartung_save.php"   -o "$APIDIR/wartung_save.php"

# ----------------------------------------------------------
# 📁 Zusammenfassung
# ----------------------------------------------------------
echo ""
echo "✅ Add-On 'Lok- & Wagenwartung' erfolgreich installiert!"
echo "📂 Dateien:"
echo "   → $WEBROOT/wartung.php"
echo "   → $APIDIR/wartung_list.php"
echo "   → $APIDIR/wartung_save.php"
echo "   → $DATADIR (für wartung.json)"
echo ""
echo "ℹ️ Aufruf im Browser: http://<pi-ip>/wartung.php"
echo ""
