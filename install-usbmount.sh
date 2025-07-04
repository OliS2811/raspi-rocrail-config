#!/bin/bash
# usbmount installieren und konfigurieren

set -e

echo "[INFO] System updaten…"
echo "[INFO] Abhängigkeiten installieren…"
sudo apt install -y git debhelper build-essential ntfs-3g
echo "[INFO] usbmount aus GitHub holen und paketieren…"
cd /tmp
rm -rf usbmount
git clone https://github.com/rbrito/usbmount.git
cd usbmount
dpkg-buildpackage -us -uc -b

echo "[INFO] usbmount-Paket installieren…"
cd ..
sudo apt install -y ./usbmount_*.deb

echo "[INFO] Standard-Mount-Optionen anpassen…"
/etc/init.d/usbmount stop 2>/dev/null || true
sudo sed -i \
  -e 's|^FS_MOUNTOPTIONS=.*|FS_MOUNTOPTIONS="-fstype=vfat,gid=users,dmask=0007,fmask=0111"|' \
  /etc/usbmount/usbmount.conf

echo "[INFO] systemd-udevd anpassen…"
sudo sed -i \
  -e 's|^PrivateMounts=yes|PrivateMounts=no|' \
  /lib/systemd/system/systemd-udevd.service

echo "[INFO] udev-Regeln neu laden…"
sudo systemctl daemon-reload

echo "[INFO] usbmount installiert und konfiguriert."
