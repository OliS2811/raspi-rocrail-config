#!/bin/bash
echo "[INFO] Update-Skript gestartet (Platzhalter)"
#!/bin/sh

mkdir ~/Downloads/Rocrail
cd ~/Downloads/Rocrail
wget https://wiki.rocrail.net/rocrail-snapshot/Rocrail-PiOS11-ARM64.zip
unzip -u Rocrail-PiOS11-ARM64.zip
cp -v ./bin/*  ~/Rocrail/bin
cp -v -r ./svg/*  ~/Rocrail/svg
rm -rv ~/Downloads/Rocrail
nohup ~/Rocrail/startrocrail.sh &
