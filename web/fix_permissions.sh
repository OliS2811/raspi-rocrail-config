#!/bin/bash

echo "[INFO] Setze Dateiberechtigungen für Rocrail-Webinterface..."

# Webverzeichnis
WEBROOT="/var/www/html"

# Besitzer setzen (alle Dateien dem Benutzer pi und Gruppe www-data zuweisen)
sudo chown -R pi:www-data "$WEBROOT"

# Leserechte für HTML, CSS, JS, PHP
sudo find "$WEBROOT" -type f -name "*.php" -exec chmod 640 {} \;
sudo find "$WEBROOT" -type f -name "*.html" -exec chmod 644 {} \;
sudo find "$WEBROOT" -type f -name "*.css" -exec chmod 644 {} \;
sudo find "$WEBROOT" -type f -name "*.js" -exec chmod 644 {} \;
# Schreibrechte für tmp-Verzeichnis und versteckte Passwortdateien
sudo chmod 770 "$WEBROOT/tmp"
sudo chown -R pi:www-data "$WEBROOT/tmp"
sudo find "$WEBROOT/tmp" -type f -name ".*" -exec chmod 600 {} \;

# Punkt-Skripte ausführbar machen (punkt0.sh bis punkt16.sh)
sudo find "$WEBROOT" -type f -name "punkt*.sh" -exec chmod +x {} \;
# WLAN- und Samba-Hilfsskripte
sudo chmod 755 /usr/local/bin/set_samba_pass.sh
# Optional: Benutzerbefehle
sudo chmod +x "$WEBROOT/save_wifi.php"
sudo chmod +x "$WEBROOT/save_samba_pass.php"
sudo chmod +x "$WEBROOT/run.php"
# Eigentümer ggf. auf www-data setzen (optional)
sudo chown www-data:www-data /var/www/html/*
echo "[OK] Berechtigungen gesetzt."
=======
#!/bin/bash

echo "[INFO] Setze Dateiberechtigungen für Rocrail-Webinterface..."

# Webverzeichnis
WEBROOT="/var/www/html"

# Besitzer setzen (alle Dateien dem Benutzer pi und Gruppe www-data zuweisen)
sudo chown -R pi:www-data "$WEBROOT"

# Leserechte für HTML, CSS, JS, PHP
sudo find "$WEBROOT" -type f -name "*.php" -exec chmod 640 {} \;
sudo find "$WEBROOT" -type f -name "*.html" -exec chmod 644 {} \;
sudo find "$WEBROOT" -type f -name "*.css" -exec chmod 644 {} \;
sudo find "$WEBROOT" -type f -name "*.js" -exec chmod 644 {} \;
# Schreibrechte für tmp-Verzeichnis und versteckte Passwortdateien
sudo chmod 770 "$WEBROOT/tmp"
sudo chown -R pi:www-data "$WEBROOT/tmp"
sudo find "$WEBROOT/tmp" -type f -name ".*" -exec chmod 600 {} \;

# Punkt-Skripte ausführbar machen (punkt0.sh bis punkt16.sh)
sudo find "$WEBROOT" -type f -name "punkt*.sh" -exec chmod +x {} \;
# WLAN- und Samba-Hilfsskripte
sudo chmod 755 /usr/local/bin/set_samba_pass.sh
# Optional: Benutzerbefehle
sudo chmod +x "$WEBROOT/save_wifi.php"
sudo chmod +x "$WEBROOT/save_samba_pass.php"
sudo chmod +x "$WEBROOT/run.php"
# Eigentümer ggf. auf www-data setzen (optional)
sudo chown www-data:www-data /var/www/html/*
echo "[OK] Berechtigungen gesetzt."
