#!/bin/sh
# Read text only. Keep trailing newlines intact and do not reuse a stale buffer.
set -eu
pane=${1:?Usage: paste-from-clipboard.sh PANE_ID}
if ! command -v wl-paste >/dev/null 2>&1; then
    tmux display-message -t "$pane" 'wl-paste is missing'
    exit 1
fi

umask 077
clipboard_file=$(mktemp "${TMPDIR:-/tmp}/tmux-clipboard.XXXXXXXX")
buffer="system-clipboard-$$"
cleanup() {
    rm -f "$clipboard_file"
    tmux delete-buffer -b "$buffer" 2>/dev/null || :
}
trap cleanup EXIT
trap 'exit 1' HUP INT TERM

if ! wl-paste --no-newline --type text > "$clipboard_file"; then
    tmux display-message -t "$pane" 'No clipboard text available (empty, image, or Wayland unavailable)'
    exit 1
fi
[ -s "$clipboard_file" ] || exit 0

tmux load-buffer -b "$buffer" "$clipboard_file"
# Exiting mode only after a successful read preserves the selection on failure.
tmux copy-mode -q -t "$pane"
tmux paste-buffer -d -p -r -b "$buffer" -t "$pane"
