#!/bin/bash
echo "[HINWEIS] Der Raspberry Pi wird jetzt neu gestartet."
echo "[HINWEIS] Die Verbindung zur Webseite wird dabei getrennt."
echo "[HINWEIS] Bitte nach etwa 1 Minute neu laden."

echo "[INFO] Stoppe Rocrail vor dem Neustart..."
bash "$(dirname "$0")/rocrail_stop.sh"
bash "$(dirname "$0")/plan_commit.sh"

echo "[INFO] Neustart in 10 Sekunden – abbrechbar mit STRG+C..."
sleep 10

sudo reboot
