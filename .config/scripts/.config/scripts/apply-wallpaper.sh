#!/bin/bash

set -u

WALLPAPER="${1:-}"
LOG_FILE="/tmp/waypaper-apply.log"

{
    printf '[%s] apply-wallpaper invoked: %s\n' "$(date '+%F %T')" "$WALLPAPER"
    printf 'WAYLAND_DISPLAY=%s XDG_RUNTIME_DIR=%s\n' "${WAYLAND_DISPLAY:-}" "${XDG_RUNTIME_DIR:-}"
} >>"$LOG_FILE"

if [ -z "$WALLPAPER" ] || [ ! -f "$WALLPAPER" ]; then
    printf '[%s] invalid wallpaper path\n' "$(date '+%F %T')" >>"$LOG_FILE"
    notify-send "Wallpaper Error" "Invalid wallpaper path: $WALLPAPER"
    exit 1
fi

if ! pgrep -x "swww-daemon" >/dev/null; then
    swww-daemon >/tmp/swww-daemon.log 2>&1 &
    sleep 0.8
fi

swww img "$WALLPAPER" \
    --resize crop \
    --fill-color ffffff \
    --transition-type any \
    --transition-step 63 \
    --transition-angle 0 \
    --transition-duration 3 \
    --transition-fps 60 \
    >>"$LOG_FILE" 2>&1

SWWW_STATUS=$?
printf '[%s] swww status: %s\n' "$(date '+%F %T')" "$SWWW_STATUS" >>"$LOG_FILE"
if [ "$SWWW_STATUS" -ne 0 ]; then
    notify-send "Wallpaper Error" "swww failed to apply wallpaper."
    exit "$SWWW_STATUS"
fi

"$HOME/.config/scripts/matugen-update.sh" "$WALLPAPER" &
"$HOME/.config/scripts/niri_set_overview_blur_dark_bg.sh" "$WALLPAPER" &

mkdir -p "$HOME/.cache/rofi"
convert "$WALLPAPER" -resize 800x800^ -gravity center -extent 800x800 "$HOME/.cache/rofi/wall.sqre" >/dev/null 2>&1 &
