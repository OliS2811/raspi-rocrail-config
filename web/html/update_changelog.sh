#!/bin/bash
set -e
REPO_DIR="/home/pi/Rocrail"
MSG=$1

cd "$REPO_DIR"

git add plan.xml
git commit -m "$MSG" || true
