"""Exercise Vim's clipboard provider without touching the desktop clipboard."""
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest

REPO = Path(__file__).resolve().parents[1]
VIM = shutil.which("vim")


@unittest.skipUnless(VIM, "Vim is not installed")
class VimClipboardTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory(prefix="vim-clipboard-test-")
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)
        tools = self.root / "bin"
        tools.mkdir()
        stub = tools / "clipboard-stub"
        stub.write_text("""#!/usr/bin/env python3
import os, sys
from pathlib import Path
name = Path(sys.argv[0]).name
if name == 'fcitx5-remote':
    print('1')
    raise SystemExit(0)
path = Path(os.environ['MOCK_CLIP_DIR']) / ('primary' if '--primary' in sys.argv else 'clipboard')
if os.environ.get('MOCK_CLIP_FAIL') == name:
    raise SystemExit(1)
if name == 'wl-copy':
    path.write_bytes(sys.stdin.buffer.read())
else:
    if not path.exists():
        raise SystemExit(1)
    sys.stdout.buffer.write(path.read_bytes())
    if '--no-newline' not in sys.argv:
        sys.stdout.buffer.write(b'\\n')
""")
        stub.chmod(0o755)
        for name in ["wl-copy", "wl-paste", "fcitx5-remote"]:
            (tools / name).symlink_to(stub)
        self.env = dict(os.environ, HOME=str(self.root),
                        PATH=str(tools) + os.pathsep + os.environ["PATH"],
                        WAYLAND_DISPLAY="mock-wayland", DISPLAY="",
                        MOCK_CLIP_DIR=str(self.root))

    def run_vim(self, commands):
        script = self.root / "test.vim"
        errors = self.root / "errors"
        script.write_text("if !has('clipboard_provider') | cquit 77 | endif\n" + commands +
                          "\ncall writefile(v:errors, '" + str(errors) + "')\n"
                          "if !empty(v:errors) | cquit | endif\nqa!\n")
        result = subprocess.run([VIM, "-Nu", str(REPO / ".vimrc"), "-i", "NONE", "-n",
                                 "-es", "-S", str(script)], env=self.env,
                                capture_output=True, text=True, timeout=10)
        if result.returncode == 77:
            self.skipTest("Vim lacks +clipboard_provider")
        self.assertEqual(result.returncode, 0,
                         (errors.read_text() if errors.exists() else "") + result.stderr)

    def test_mapped_yank_and_linewise_paste(self):
        self.run_vim(r'''
call assert_equal('wl_clipboard', v:clipmethod)
call setline(1, ['中文第一行', 'second'])
normal yy
call assert_equal("中文第一行\n", getreg('+'))
call assert_equal('V', getregtype('+'))
normal p
call assert_equal(['中文第一行', '中文第一行', 'second'], getline(1, '$'))
''')
        self.assertEqual((self.root / "clipboard").read_text(), "中文第一行\n")

    def test_external_characterwise_and_visual_paste(self):
        (self.root / "clipboard").write_text("中文粘贴")
        self.run_vim(r'''
call setline(1, 'AB')
normal p
call assert_equal('A中文粘贴B', getline(1))
call setline(1, 'XYZ')
normal! 0
normal vp
call assert_equal('中文粘贴YZ', getline(1))
call setline(1, 'AB')
normal! 0
execute "normal i\<C-R>+\<Esc>"
call assert_equal('中文粘贴AB', getline(1))
''')

    def test_external_multiline_preserves_blank_line(self):
        (self.root / "clipboard").write_text("first\n\n")
        self.run_vim(r'''
call assert_equal("first\n\n", getreg('+'))
call assert_equal('V', getregtype('+'))
call setline(1, 'tail')
normal P
call assert_equal(['first', '', 'tail'], getline(1, '$'))
''')

    def test_register_types_primary_selection_and_cut(self):
        self.run_vim(r'''
call setreg('+', ['ab', 'cd'], "\<C-V>2")
call assert_equal("\<C-V>2", getregtype('+'))
call assert_equal(['ab', 'cd'], getreg('+', 1, 1))
call setreg('+', "one\n", 'v')
call assert_equal('v', getregtype('+'))
call assert_equal("one\n", getreg('+'))
call setreg('*', 'primary text', 'v')
call assert_equal('primary text', getreg('*'))
call assert_equal("one\n", getreg('+'))
call setline(1, 'xyz')
normal x
call assert_equal('x', getreg('+'))
call assert_equal('yz', getline(1))
''')

    def test_failed_reads_report_error(self):
        self.env["MOCK_CLIP_FAIL"] = "wl-paste"
        self.run_vim(r'''
let caught = 0
try
    call getreg('+')
catch /Wayland clipboard:/
    let caught = 1
endtry
call assert_equal(1, caught)
''')

    def test_provider_is_unavailable_outside_wayland(self):
        self.env["WAYLAND_DISPLAY"] = ""
        self.run_vim("call assert_notequal('wl_clipboard', v:clipmethod)")


if __name__ == "__main__":
    unittest.main()
