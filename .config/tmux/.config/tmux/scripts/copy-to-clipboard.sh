#!/bin/sh
# copy-pipe already retains a tmux buffer; forward the same bytes to Wayland.
set -eu
if ! command -v wl-copy >/dev/null 2>&1; then
    tmux display-message 'wl-copy is missing; selection remains in the tmux buffer'
    exit 1
fi
if ! wl-copy --type 'text/plain;charset=utf-8'; then
    tmux display-message 'Cannot access the Wayland clipboard; reattach from the desktop session'
    exit 1
fi
