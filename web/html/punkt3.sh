#!/bin/bash
echo "[INFO] Rocrail wird gestoppt..."

bash "$(dirname "$0")/rocrail_stop.sh"
bash "$(dirname "$0")/plan_commit.sh"
