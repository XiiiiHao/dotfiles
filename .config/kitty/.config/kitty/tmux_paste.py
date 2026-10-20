"""Route Ctrl+Shift+V to tmux; retain Kitty's native paste elsewhere."""
from pathlib import Path

from kittens.tui.handler import result_handler


def main(args: list[str]) -> str:
    return ""


@result_handler(no_ui=True)
def handle_result(args, answer, target_window_id, boss):
    window = boss.window_id_map.get(target_window_id)
    if window is None:
        return
    in_tmux = any(
        process.get("cmdline")
        and Path(process["cmdline"][0]).name == "tmux"
        for process in window.child.foreground_processes
    )
    if in_tmux:
        # CSI-u Ctrl+Shift+V; tmux owns the clipboard read and mode cancellation.
        window.write_to_child(b"\x1b[118;6u")
    else:
        boss.paste_from_clipboard()
