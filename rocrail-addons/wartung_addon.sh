#!/bin/bash
# ==========================================================
# 🚂 Add-On: Lok- & Wagenwartung für Rocrail Webinterface
# Autor: Olli / 2025
# Vollautonom: erstellt & repariert sudo-Regeln bei Bedarf
# ==========================================================

set -e

# --- Root-Fix: Wenn nicht root, führe Skript mit sudo neu aus ---
if [ "$EUID" -ne 0 ]; then
  echo "🔁 Wechsle in Root-Kontext..."
  exec sudo bash "$0" "$@"
fi

echo "📦 Starte Installation des Add-Ons 'Lok- & Wagenwartung'..."

# ==========================================================
# 🧩 Vollautonomes Selbstheilungs-Setup für Rocrail Webinterface
# ==========================================================
SUDO_FILE="/etc/sudoers.d/rocrail-web"
EXPECTED_RULE="# Rocrail Webinterface – automatische Sudoer-Regeln"

if ! grep -q "$EXPECTED_RULE" "$SUDO_FILE" 2>/dev/null; then
  echo "🔧 Erstelle oder repariere fehlende Sudo-Regeln für Webinterface..."

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
/var/www/html/*_addon.sh, \
/var/www/html/punkt*.sh, \
/home/pi/Rocrail/startrocrail.sh, \
/var/www/html/stoprocrail.sh, \
/usr/local/bin/set_samba_pass.sh
Defaults:www-data !requiretty
EOF

  chmod 440 "$SUDO_FILE"
  echo "✅ Sudo-Regeln erfolgreich erstellt oder repariert."
else
  echo "✅ Sudo-Regeln bereits vorhanden."
fi

# ==========================================================
# 📂 Add-On Dateien installieren
# ==========================================================
WEBROOT="/var/www/html"
APIDIR="$WEBROOT/api"
DATADIR="$WEBROOT/data"
SRC="https://raw.githubusercontent.com/OliS2811/raspi-rocrail-config/master/rocrail-addons"

mkdir -p "$APIDIR" "$DATADIR"

# Eigentümer nur ändern, wenn möglich
chown -R www-data:www-data "$DATADIR" 2>/dev/null || true
chmod -R 775 "$DATADIR"

# Lade Dateien
echo "📥 Lade aktuelle Dateien herunter..."
curl -fsSL "$SRC/wartung.php"        -o "$WEBROOT/wartung.php"
curl -fsSL "$SRC/wartung_list.php"   -o "$APIDIR/wartung_list.php"
curl -fsSL "$SRC/wartung_save.php"   -o "$APIDIR/wartung_save.php"

# Falls keine Daten vorhanden sind, Grundstruktur erzeugen
if [ ! -f "$DATADIR/wartung.json" ]; then
  echo "[]" > "$DATADIR/wartung.json"
  chown www-data:www-data "$DATADIR/wartung.json" 2>/dev/null || true
  echo "📄 Datei wartung.json angelegt."
fi

# ==========================================================
# ✅ Abschluss
# ==========================================================
echo ""
echo "✅ Add-On 'Lok- & Wagenwartung' erfolgreich installiert!"
echo "📂 Dateien:"
echo "   → $WEBROOT/wartung.php"
echo "   → $APIDIR/wartung_list.php"
echo "   → $APIDIR/wartung_save.php"
echo "   → $DATADIR/wartung.json"
echo ""
echo "ℹ️ Aufruf im Browser: http://rocrail/wartung.php"
echo ""