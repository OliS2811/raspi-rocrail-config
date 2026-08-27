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
sudo sed -i '/^\[homes\]/,/^$/ s/^/#/' /etc/samba/smb.conf
sudo sed -i '/^\[printers\]/,/^$/ s/^/#/' /etc/samba/smb.conf
sudo sed -i '/^\[print\$\]/,/^$/ s/^/#/' /etc/samba/smb.conf

echo ""
echo -e "\e[1mKonfiguriere /etc/samba/smb.conf …\e[0m"
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
echo ""
sleep 05
echo -e "\e[1mStarte Samba-Dienst neu …\e[0m"
echo ""
sudo systemctl restart smbd
echo -e "\e[1;32m[SUCCESS] Samba-Freigaben wurden eingerichtet!\e[0m"
echo ""
