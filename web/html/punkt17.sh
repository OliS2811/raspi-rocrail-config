#!/bin/bash
# Zeigt die Historie der Planänderungen (plan.xml) aus dem lokalen Git-Verlauf,
# inkl. einer lesbaren Kurzfassung, welche benannten Elemente sich geändert haben.

source "$(dirname "$0")/rocrail_workdir.sh"

if [ ! -d "$REPO/.git" ]; then
  echo "[INFO] Noch keine Planänderungen erfasst."
  exit 0
fi

if pgrep -x rocrail > /dev/null; then
  echo "ROCRAIL_RUNNING=1"
else
  echo "ROCRAIL_RUNNING=0"
fi

cd "$REPO" || exit 0

git log --pretty=format:'%h|%ad|%s' --date=format:'%d.%m.%Y %H:%M' -n 50 -- plan.xml | while IFS='|' read -r HASH DATE NOTE || [ -n "$HASH" ]; do
  if git rev-parse -q --verify "${HASH}^" < /dev/null > /dev/null 2>&1; then
    DIFF=$(git diff "${HASH}^" "${HASH}" -- plan.xml < /dev/null 2>/dev/null)
  else
    DIFF=$(git show "${HASH}" -- plan.xml < /dev/null 2>/dev/null)
  fi

  ELEMENTS=$(echo "$DIFF" | command grep -E '^[+-][^+-]' | command grep -oE 'name="[^"]*"' | sed -E 's/name="(.*)"/\1/' | command grep -vE '^(plan\.xml)?$' | sort -u | paste -sd, - )

  echo "${HASH}|${DATE}|${NOTE}|${ELEMENTS}"
done
