#!/bin/bash
set -e

REPO_DIR="/home/pi/Documents/Rocrail/"

MSG=$1

cd "$REPO_DIR"

git add plan.xml
git commit -m "$MSG" || true

echo "✅ Commit erstellt für plan.xml: $MSG"
