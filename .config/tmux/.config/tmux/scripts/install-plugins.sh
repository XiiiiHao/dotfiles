#!/bin/sh
# Bootstrap pinned upstream archives outside the dotfiles repository.
# Existing installations are left intact; no Git commands are run.
set -eu
python3 - <<'PY'
import shutil
import tarfile
import tempfile
import urllib.request
from pathlib import Path

plugins = {
    "tpm": ("tmux-plugins/tpm", "e261deb1b47614eed3400089ce7197dc68acc4eb"),
    "tmux-resurrect": ("tmux-plugins/tmux-resurrect", "cff343cf9e81983d3da0c8562b01616f12e8d548"),
    "tmux-continuum": ("tmux-plugins/tmux-continuum", "0698e8f4b17d6454c71bf5212895ec055c578da0"),
    # TPM derives the directory name "tmux" from catppuccin/tmux.
    "tmux": ("catppuccin/tmux", "v2.3.2"),
}
root = Path.home() / ".tmux" / "plugins"
root.mkdir(parents=True, exist_ok=True)
for name, (repository, revision) in plugins.items():
    destination = root / name
    if destination.exists():
        print(f"Already installed: {destination}")
        continue
    url = f"https://codeload.github.com/{repository}/tar.gz/{revision}"
    with tempfile.TemporaryDirectory(prefix=".install-", dir=root) as temporary:
        temporary = Path(temporary)
        archive_path = temporary / "plugin.tar.gz"
        with urllib.request.urlopen(url, timeout=30) as response:
            with archive_path.open("wb") as output:
                shutil.copyfileobj(response, output)
        with tarfile.open(archive_path) as archive:
            archive.extractall(temporary, filter="data")
        # Tagged archives omit the leading "v" in their root directory.
        extracted = temporary / f"{repository.rsplit('/', 1)[1]}-{revision.removeprefix('v')}"
        extracted.rename(destination)
    print(f"Installed {repository} at {revision[:12]}: {destination}")
print("Reload tmux with prefix + r after installation.")
PY
