#!/bin/bash
# --- Root-Fix: Wenn nicht root, führe Skript mit sudo neu aus ---
if [ "$EUID" -ne 0 ]; then
  sudo bash "$0" "$@"
  exit
fi
# ==========================================================
# 🚂 Add-On: Lok- & Wagenwartung für Rocrail Webinterface
# Autor: Olli / 2025
# ==========================================================

set -e

echo "📦 Starte Installation des Add-Ons 'Lok- & Wagenwartung'..."

# ----------------------------------------------------------
# 🧩 Automatisches Sudo-Setup (ohne verschachteltes sudo!)
# ----------------------------------------------------------
SUDO_FILE="/etc/sudoers.d/rocrail-web"

if [ ! -f "$SUDO_FILE" ]; then
  echo "🔧 Erstelle fehlende Sudo-Regeln für Rocrail Webinterface..."

  cat << "EOF" > "$SUDO_FILE"
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
EOF

  chmod 440 "$SUDO_FILE"
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

mkdir -p "$APIDIR" "$DATADIR"
chown -R www-data:www-data "$DATADIR"
chmod -R 775 "$DATADIR"

curl -fsSL "$SRC/wartung.php"        -o "$WEBROOT/wartung.php"
curl -fsSL "$SRC/wartung_list.php"   -o "$APIDIR/wartung_list.php"
curl -fsSL "$SRC/wartung_save.php"   -o "$APIDIR/wartung_save.php"

echo ""
echo "✅ Add-On 'Lok- & Wagenwartung' erfolgreich installiert!"
echo "📂 Dateien:"
echo "   → $WEBROOT/wartung.php"
echo "   → $APIDIR/wartung_list.php"
echo "   → $APIDIR/wartung_save.php"
echo "   → $DATADIR (für wartung.json)"
echo ""
echo "ℹ️ Aufruf im Browser: http://rocrail/wartung.php"
echo ""
