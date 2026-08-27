#!/bin/bash

echo "[INFO] Setze Dateiberechtigungen für Rocrail-Webinterface..."

# Webverzeichnis
WEBROOT="/var/www/html"

# Verzeichnis selbst muss für www-data (Apache) und pi (sudo-Ausführung) durchsuchbar sein
sudo chmod 755 "$WEBROOT"

# Besitzer setzen (alle Dateien dem Benutzer pi und Gruppe www-data zuweisen)
sudo chown -R pi:www-data "$WEBROOT"

# Leserechte für HTML, CSS, JS, PHP
sudo find "$WEBROOT" -type f -name "*.php" -exec chmod 640 {} \;
sudo find "$WEBROOT" -type f -name "*.html" -exec chmod 644 {} \;
sudo find "$WEBROOT" -type f -name "*.css" -exec chmod 644 {} \;
sudo find "$WEBROOT" -type f -name "*.js" -exec chmod 644 {} \;

# Schreibrechte für tmp-Verzeichnis
# tmp/ selbst muss pi:www-data gehören (pi braucht Zugriff für punkt*.sh,
# z.B. um Übergabedateien zu löschen). Der INHALT muss aber www-data bleiben:
# dort schreibt PHP (www-data) bei jedem Aufruf neu hinein, und der obige
# rekursive chown auf "$WEBROOT" hätte bestehende Dateien sonst auf "pi"
# umgehängt und für www-data beim nächsten Schreiben unschreibbar gemacht
# ("Permission denied" trotz vorher funktionierendem Code).
sudo chmod 770 "$WEBROOT/tmp"
sudo chown pi:www-data "$WEBROOT/tmp"
sudo find "$WEBROOT/tmp" -mindepth 1 -exec chown www-data:www-data {} \;

# Nur das Samba-Passwort bleibt strikt auf 600 (Besitzer-only) beschränkt -
# das läuft über eine eigene Root-Eskalation (set_samba_pass.sh) und braucht
# diese Absicherung. Andere Übergabedateien (Notiz, Wiederherstellen-Hash)
# werden von save_plan_note.php/save_plan_restore.php bewusst auf 644 gesetzt,
# damit "pi" sie ohne Root-Eskalation lesen kann - hier nicht überschreiben.
sudo find "$WEBROOT/tmp" -type f -name ".smbpass-*" -exec chmod 600 {} \;

# Punkt-Skripte ausführbar machen (punkt0.sh bis punkt19.sh)
# 755 statt +x: die Skripte laufen per "sudo -u pi", pi ist weder Besitzer noch
# in der Gruppe www-data, braucht als "Andere" also auch Leserechte, sonst
# scheitert schon das Einlesen der Shebang-Zeile mit "Permission denied".
sudo find "$WEBROOT" -type f -name "punkt*.sh" -exec chmod 755 {} \;

# Hilfsskripte für den Planänderungs-Verlauf
sudo chmod 755 "$WEBROOT/plan_commit.sh"
sudo chmod 755 "$WEBROOT/rocrail_stop.sh"
sudo chmod 644 "$WEBROOT/rocrail_workdir.sh"

# WLAN- und Samba-Hilfsskripte
sudo chmod 755 /usr/local/bin/set_samba_pass.sh

# Optional: PHP-Skripte ausführbar machen
sudo chmod +x "$WEBROOT/save_wifi.php"
sudo chmod +x "$WEBROOT/save_samba_pass.php"
sudo chmod +x "$WEBROOT/save_plan_note.php"
sudo chmod +x "$WEBROOT/save_plan_restore.php"
sudo chmod +x "$WEBROOT/save_rocweb_port.php"
sudo chmod +x "$WEBROOT/get_rocweb_port.php"
sudo chmod +x "$WEBROOT/run.php"

# Eigentümer ggf. auf www-data setzen (optional, kann auch entfernt werden)
# "tmp" bewusst ausgenommen - muss pi:www-data bleiben, siehe oben.
sudo find "$WEBROOT" -maxdepth 1 -mindepth 1 ! -name tmp -exec chown www-data:www-data {} \;

echo "[OK] Berechtigungen gesetzt."
