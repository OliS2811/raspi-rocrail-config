#!/bin/bash
# ==============================================================
# 🌐 Rocrail Webinterface Update Script (mit Git-Check)
# Version: 1.8.1
# Autor: Oliver / Rocrail Webinterface Project
# ==============================================================
# Dieses Skript aktualisiert das Webinterface, Addons und PHP-Dateien
# ohne Benutzerdaten oder Wartungsdateien zu überschreiben.
# Es prüft automatisch, ob Git vorhanden ist, und installiert es bei Bedarf.
# ==============================================================

echo "🚀 Starte Update des Rocrail Webinterface..."
sleep 1

# --- Git prüfen und ggf. installieren ---
if ! command -v git &> /dev/null; then
  echo "📦 Git ist nicht installiert – Installation wird gestartet..."
  sudo apt update -y && sudo apt install -y git
  if [ $? -ne 0 ]; then
    echo "❌ Git-Installation fehlgeschlagen. Bitte Netzwerk prüfen."
    exit 1
  fi
else
  echo "✅ Git bereits installiert."
fi

# --- Neues Repository klonen ---
cd ~ || exit 1
if [ -d "raspi-rocrail-config-new" ]; then
  echo "🧹 Entferne altes temporäres Update-Verzeichnis..."
  sudo rm -rf ~/raspi-rocrail-config-new
fi

git clone https://github.com/OliS2811/raspi-rocrail-config.git raspi-rocrail-config-new
if [ $? -ne 0 ]; then
  echo "❌ Konnte Repository nicht klonen. Bitte Internetverbindung prüfen."
  exit 1
fi

# --- Dateien synchronisieren ---
echo "📦 Synchronisiere Dateien (ohne Benutzerdaten)..."
sudo rsync -a \
  --exclude 'data/' \
  --exclude '*.json.backup' \
  ~/raspi-rocrail-config-new/web/html/ /var/www/html/

# --- Eigentümer & Rechte setzen ---
echo "🔧 Setze Eigentümer und Dateirechte..."
sudo chown -R www-data:www-data /var/www/html
sudo chmod -R 755 /var/www/html
sudo chmod +x /var/www/html/punkt*.sh 2>/dev/null

# --- Sudo-Regeln prüfen und ggf. neu anlegen ---
if [ ! -f /etc/sudoers.d/rocrail-web ]; then
  echo "🛠️  Lege fehlende Sudo-Regeln an..."
  echo "www-data ALL=(pi) NOPASSWD: /var/www/html/punkt*.sh, /home/pi/Rocrail/startrocrail.sh, /var/www/html/stoprocrail.sh, /usr/local/bin/set_samba_pass.sh" | \
  sudo tee /etc/sudoers.d/rocrail-web >/dev/null
  sudo chmod 440 /etc/sudoers.d/rocrail-web
fi

# --- Abschlussmeldung ---
echo ""
echo "✅ Rocrail Webinterface erfolgreich aktualisiert!"
echo "ℹ️ Benutzer- und Wartungsdaten (data/) wurden beibehalten."
echo "🌍 Die Änderungen sind sofort aktiv. Seite kann neu geladen werden."
echo ""