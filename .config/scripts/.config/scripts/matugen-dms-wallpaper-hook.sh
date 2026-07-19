#!/bin/bash

set -u

LOCK_FILE="$HOME/.cache/matugen-dms-wallpaper-hook.lock"
DMS_SESSION="$HOME/.local/state/DankMaterialShell/session.json"
SELECT_SCRIPT="$HOME/.config/scripts/matugen-select-type.sh"

exec 9>"$LOCK_FILE"
# Serialize rapid wallpaper changes so the final change is never dropped.
flock 9

# DMS persists SessionData just after emitting wallpaperPathChanged.
sleep 1

if ! command -v jq >/dev/null 2>&1 || [ ! -f "$DMS_SESSION" ]; then
    exit 1
fi

WALLPAPER=$(jq -r '.wallpaperPath // empty' "$DMS_SESSION")
if [ -z "$WALLPAPER" ] || [ ! -f "$WALLPAPER" ]; then
    exit 1
fi

# Reuse the same selector invoked by Mod+Shift+M.
exec "$SELECT_SCRIPT"
