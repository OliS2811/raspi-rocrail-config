#!/bin/bash
echo "[INFO] Raspberry wird jetzt heruntergefahren..."
echo "[HINWEIS] Das Gerät schaltet sich in wenigen Sekunden ab."
echo "[HINWEIS] Du kannst den Strom trennen, sobald die grüne LED aus ist."

echo "[INFO] Stoppe Rocrail vor dem Herunterfahren..."
bash "$(dirname "$0")/rocrail_stop.sh"
bash "$(dirname "$0")/plan_commit.sh"

sleep 10
sudo shutdown -h now
