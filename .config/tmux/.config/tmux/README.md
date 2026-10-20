# tmux 使用说明

配置入口为 `~/.config/tmux/tmux.conf`。`tmux.reference.conf` 仅作参考，不会加载。
要求 tmux 3.3+、zsh、Wayland 会话和 wl-clipboard。当前在 tmux 3.7c 上验证。

## 快捷键

“前缀”表示先按 `Ctrl+a`，松开后再按下一键。

| 操作 | 快捷键 |
| --- | --- |
| 新建窗口（继承目录） | 前缀 → `c` |
| 左右 / 上下分屏 | 前缀 → `\|` / `-` |
| 向左 / 下 / 上 / 右分屏 | 前缀 → `h/j/k/l` |
| 向左 / 下 / 上 / 右切换窗格 | `Alt+h/j/k/l` |
| 调整窗格，每次 5 格 | `Alt+Shift+h/j/k/l` |
| 前后窗口 | `Alt+←/→` |
| 跳转窗口 1–9 | `Alt+1…9` |
| 返回上次窗口 | 前缀 → `Tab` |
| 会话列表 | `Alt+s` 或前缀 → `s` |
| 上一个 / 下一个会话（循环切换） | `Ctrl+←/→` |
| 重命名窗口 / 会话 | 前缀 → `,` / `$` |
| 放大或还原当前窗格 | 前缀 → `z` |
| 进入复制模式 | `Alt+v` 或前缀 → `Enter` |
| 开始选择 / 矩形选择 | 复制模式中 `v` / `Ctrl+v` |
| 复制到 tmux 和系统剪贴板 | 选择后 `y`（或 `Enter`） |
| 粘贴系统剪贴板文字 | `Ctrl+Shift+V` 或前缀 → `]` |
| 退出复制模式 | `q` |
| 手动保存 / 恢复 | 前缀 → `Ctrl+s` / `Ctrl+r` |
| 重载配置 | 前缀 → `r` |

niri 已交换左 Alt 和左 Win；上表使用逻辑键名。全局剪贴板历史仍由
`Super+Shift+V` 打开 DMS 面板。

窗口命名：自动命名已关闭，窗口名只由你手动设置。用前缀 → `,` 输入新名称
并回车；新建窗口会先显示序号作为默认名。会话用前缀 → `$` 重命名。
`allow-rename off` 同时阻止程序自行修改窗口名。重新加载配置不会改动
已有窗口的名称。

## 剪贴板与 Kitty

复制使用 `wl-copy`，粘贴使用 `wl-paste --type text --no-newline`，读写同一个
Wayland CLIPBOARD。粘贴脚本保持原始换行，使用括号粘贴（内部程序需要支持），
不把图片数据或读取失败时的旧 tmux 缓冲区粘贴进去。

`kitty.conf` 的 `Ctrl+Shift+V` 调用 `tmux_paste.py`：前台进程是 tmux 时发送
CSI-u 按键给 tmux，由 tmux 读取剪贴板并退出复制模式后粘贴；其他程序使用
Kitty 原生粘贴。这样解决 tmux 3.7c 在复制模式下忽略终端原生粘贴的问题。
该适配用于本机直接运行的 tmux；SSH 到远端时不检测远端的 tmux。

修改 Kitty 配置后，按 Kitty 默认的 `Ctrl+Shift+F5` 重新加载，或打开新终端。
如果 tmux 中启动的程序无法访问 Wayland 剪贴板，从图形会话重新 attach，
让 `update-environment` 同步最新的 `WAYLAND_DISPLAY` 和 `XDG_RUNTIME_DIR`。

## 插件与快照

首次部署：

```sh
sh ~/.config/tmux/scripts/install-plugins.sh
```

安装脚本使用固定上游提交的压缩包，不覆盖已有目录；插件放在
`~/.tmux/plugins/{tpm,tmux,tmux-resurrect,tmux-continuum}`，不放入 dotfiles。
其中 `tmux` 是 Catppuccin 主题插件，固定为 `v2.3.2`。
当前是压缩包安装，TPM 的 Git 安装/更新快捷键不适用于这些目录；升级时需要
明确更新安装脚本中的版本并替换对应插件目录，或自行迁移到 Git 安装。

continuum 在有客户端显示状态栏时检查保存间隔，每 5 分钟保存一次。
只运行 detached 会话、不显示状态栏时，不保证定时保存；退出前可手动保存。
配置重载后也会重新挂载 continuum 的状态栏计时命令。

快照位于 `~/.tmux/resurrect`，包括窗格历史文本。自动恢复关闭，使用
前缀 → `Ctrl+r` 手动恢复布局、目录和支持恢复的程序。AI 进程的内存及
对话会话不由这些插件保存。不要将快照目录加入公开仓库。

## 外观

使用 `catppuccin/tmux#v2.3.2` 的 Mocha 配色，配置项为
`set -g @catppuccin_flavor 'mocha'`。颜色直接引用插件的 `@thm_*` 色板变量。
保留单行状态栏：背景为 Mocha Base（`#1e1e2e`），窗口列表使用箭头形
Powerline 标签，显示 `编号:窗口名`。当前窗口为 Teal（`#94e2d5`）底色，
其他窗口为 Surface 0（`#313244`）底色搭配 Teal 文字，标签之间留空隙。
箭头字符需要 Nerd Font（当前 Kitty 使用的 Maple Mono NF CN 支持）。

窗格背景固定为 `#222435`（Neovim 主题的 Normal 背景）。终端版 Neovim 配置为
透明背景，若不设置窗格底色，会透出 Kitty 的 `#373b4b`，对比度明显偏低；
设置后与 Neovide 中的显示一致。Shell 等其他程序的面板底色也会变成该颜色。
`PREFIX`、`COPY`、`ZOOM` 按需显示。窗格不显示编号与程序名，当前窗格
边框用 Mauve 突出。历史输出上限为每个窗格 100,000 行。
