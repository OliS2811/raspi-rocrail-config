#!/bin/bash
echo "[INFO] Raspberry wird jetzt heruntergefahren..."
echo "[HINWEIS] Das Gerät schaltet sich in wenigen Sekunden ab."
echo "[HINWEIS] Du kannst den Strom trennen, sobald die grüne LED aus ist."
sleep 10
sudo shutdown -h now
