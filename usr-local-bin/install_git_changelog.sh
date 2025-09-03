#!/bin/bash
set -e

REPO_DIR="/home/pi/Documents/Rocrail/"
USER=$1
EMAIL=$2
REMOTE=$3

cd "$REPO_DIR"

# Git init, falls noch nicht vorhanden
if [ ! -d ".git" ]; then
  git init
fi

git config user.name "$USER"
git config user.email "$EMAIL"

# Remote überschreiben, falls schon vorhanden
git remote remove origin 2>/dev/null || true
git remote add origin "$REMOTE"

# plan.xml ins Repo aufnehmen
git add plan.xml
git commit -m "Initial commit von plan.xml" || true

echo "✅ Git-Repo eingerichtet für plan.xml"
