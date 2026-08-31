#!/bin/bash
echo ""
echo -e "\e[1mSamba installieren und konfigurieren …\e[0m"
echo ""
sudo apt-get update
sudo apt-get install -y samba

echo ""
echo -e "\e[1mEntferne Debian-Standardfreigaben (Drucker, Benutzer-Homeverzeichnisse) …\e[0m"
# [homes] erscheint beim anonymen Durchsuchen als Freigabe "nobody" (Debians
# Standard-Gastkonto), [printers]/[print$] sind Drucker-Freigaben - beides
# unerwünscht, da es hier nur um die Rocrail-Freigaben geht.
#
# Nicht mit "sed .../^$/" auskommentieren: Debians Standard-[homes]-Block
# enthält selbst eine echte Leerzeile, bei der ein bereichsbasiertes sed
# viel zu früh aufhören würde. Die dahinter liegenden, dann unkommentiert
# bleibenden Zeilen ("valid users = %S" u.a.) rutschen sonst in [global]
# und blockieren dort z. B. jeden Zugriff auf die IPC$-Verwaltungsfreigabe
# (Freigaben-Auflistung schlägt fehl, obwohl der direkte Zugriff auf die
# echten Freigaben noch funktioniert). Stattdessen bis zur nächsten
# Abschnittsmarkierung (auch auskommentierte wie ";[netlogon]") kommentieren.
# "#?" vor den Abschnittsnamen macht das robust gegenüber einem bereits
# (fehlerhaft) halb-auskommentierten [homes]-Block aus einem älteren Lauf
# dieses Skripts - so heilt sich ein zuvor kaputter Stand beim erneuten
# Ausführen automatisch.
sudo awk '
  BEGIN{skip=0}
  /^#?\[homes\]/ || /^#?\[printers\]/ || /^#?\[print\$\]/ {skip=1}
  skip && !/^#?\[homes\]/ && !/^#?\[printers\]/ && !/^#?\[print\$\]/ && /^[#;]?\[/ {skip=0}
  skip && !/^#/ {sub(/^/,"#")}
  {print}
' /etc/samba/smb.conf > /tmp/smb.conf.awktmp && sudo mv /tmp/smb.conf.awktmp /etc/samba/smb.conf

echo ""
echo -e "\e[1mKonfiguriere /etc/samba/smb.conf …\e[0m"
# Falls das Skript schon einmal gelaufen ist: vorherige Rocrail-Freigaben
# entfernen, damit sie nicht bei jedem erneuten Lauf dupliziert werden.
sudo sed -i '/^\[Rocrail\]$/,/^$/d' /etc/samba/smb.conf
sudo sed -i '/^\[Rocrail-Documents\]$/,/^$/d' /etc/samba/smb.conf
sudo sed -i '/^\[Rocrail-Images\]$/,/^$/d' /etc/samba/smb.conf
sudo sed -i '/^\[Rocrail-Backups\]$/,/^$/d' /etc/samba/smb.conf
sudo sed -i '/^\[Rocrail-WebinterfaceBackups\]$/,/^$/d' /etc/samba/smb.conf

# Backup-Verzeichnisse existieren evtl. noch nicht (werden erst bei Punkt 5
# bzw. beim ersten Webinterface-Update angelegt) - ohne sie zeigt die
# Freigabe im Netzwerk nur einen Fehler statt eines leeren Ordners.
mkdir -p "$HOME/Backups" "$HOME/WebinterfaceBackups"
echo "" | sudo tee -a /etc/samba/smb.conf > /dev/null
echo "[Rocrail]" | sudo tee -a /etc/samba/smb.conf > /dev/null
echo "   path = /home/pi/Rocrail" | sudo tee -a /etc/samba/smb.conf > /dev/null
echo "   browseable = yes" | sudo tee -a /etc/samba/smb.conf > /dev/null
echo "   writeable = yes" | sudo tee -a /etc/samba/smb.conf > /dev/null
echo "   only guest = no" | sudo tee -a /etc/samba/smb.conf > /dev/null
echo "   create mask = 0775" | sudo tee -a /etc/samba/smb.conf > /dev/null
echo "   directory mask = 0775" | sudo tee -a /etc/samba/smb.conf > /dev/null
echo "   valid users = pi" | sudo tee -a /etc/samba/smb.conf > /dev/null
echo "" | sudo tee -a /etc/samba/smb.conf > /dev/null
echo "[Rocrail-Documents]" | sudo tee -a /etc/samba/smb.conf > /dev/null
echo "   path = /home/pi/Documents/Rocrail" | sudo tee -a /etc/samba/smb.conf > /dev/null
echo "   browseable = yes" | sudo tee -a /etc/samba/smb.conf > /dev/null
echo "   writeable = yes" | sudo tee -a /etc/samba/smb.conf > /dev/null
echo "   only guest = no" | sudo tee -a /etc/samba/smb.conf > /dev/null
echo "   create mask = 0775" | sudo tee -a /etc/samba/smb.conf > /dev/null
echo "   directory mask = 0775" | sudo tee -a /etc/samba/smb.conf > /dev/null
echo "   valid users = pi" | sudo tee -a /etc/samba/smb.conf > /dev/null
echo "" | sudo tee -a /etc/samba/smb.conf > /dev/null
echo "[Rocrail-Images]" | sudo tee -a /etc/samba/smb.conf > /dev/null
echo "   path = /home/pi/Documents/Rocrail/images" | sudo tee -a /etc/samba/smb.conf > /dev/null
echo "   browseable = yes" | sudo tee -a /etc/samba/smb.conf > /dev/null
echo "   writeable = yes" | sudo tee -a /etc/samba/smb.conf > /dev/null
echo "   only guest = no" | sudo tee -a /etc/samba/smb.conf > /dev/null
echo "   create mask = 0775" | sudo tee -a /etc/samba/smb.conf > /dev/null
echo "   directory mask = 0775" | sudo tee -a /etc/samba/smb.conf > /dev/null
echo "   valid users = pi" | sudo tee -a /etc/samba/smb.conf > /dev/null
echo "" | sudo tee -a /etc/samba/smb.conf > /dev/null
echo "[Rocrail-Backups]" | sudo tee -a /etc/samba/smb.conf > /dev/null
echo "   path = /home/pi/Backups" | sudo tee -a /etc/samba/smb.conf > /dev/null
echo "   browseable = yes" | sudo tee -a /etc/samba/smb.conf > /dev/null
echo "   writeable = yes" | sudo tee -a /etc/samba/smb.conf > /dev/null
echo "   only guest = no" | sudo tee -a /etc/samba/smb.conf > /dev/null
echo "   create mask = 0775" | sudo tee -a /etc/samba/smb.conf > /dev/null
echo "   directory mask = 0775" | sudo tee -a /etc/samba/smb.conf > /dev/null
echo "   valid users = pi" | sudo tee -a /etc/samba/smb.conf > /dev/null
echo "" | sudo tee -a /etc/samba/smb.conf > /dev/null
echo "[Rocrail-WebinterfaceBackups]" | sudo tee -a /etc/samba/smb.conf > /dev/null
echo "   path = /home/pi/WebinterfaceBackups" | sudo tee -a /etc/samba/smb.conf > /dev/null
echo "   browseable = yes" | sudo tee -a /etc/samba/smb.conf > /dev/null
echo "   writeable = yes" | sudo tee -a /etc/samba/smb.conf > /dev/null
echo "   only guest = no" | sudo tee -a /etc/samba/smb.conf > /dev/null
echo "   create mask = 0775" | sudo tee -a /etc/samba/smb.conf > /dev/null
echo "   directory mask = 0775" | sudo tee -a /etc/samba/smb.conf > /dev/null
echo "   valid users = pi" | sudo tee -a /etc/samba/smb.conf > /dev/null
echo ""
sleep 05
echo -e "\e[1mStarte Samba-Dienst neu …\e[0m"
echo ""
sudo systemctl restart smbd
echo -e "\e[1;32m[SUCCESS] Samba-Freigaben wurden eingerichtet!\e[0m"
echo ""
