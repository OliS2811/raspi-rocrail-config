#!/bin/bash
echo "[INFO] System wird aktualisiert..."

sudo apt-get update
sudo apt-get upgrade -y

echo "[OK] Systemupdate abgeschlossen."
