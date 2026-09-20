# 配置同步与恢复

本仓库区分手写配置、应用偏好、本机状态和第三方资源。修改配置时优先编辑仓库中的源文件；对自行回写且混合存储历史/凭据的应用，使用经过筛选的偏好快照。

## 本轮同步入口

| 实际路径 | 仓库来源 / 部署方式 |
| --- | --- |
| `~/.bashrc`、`~/.bash_profile`、`~/.vimrc`、`~/.gitconfig` | 仓库根目录的同名文件，逐文件软链接 |
| `~/.zshenv` | `.config/zsh/.zshenv` |
| `~/.config/starship/kitty-reference.toml` | `.config/starship` 包；Zsh 和 Fish 使用同一主题 |
| `~/.local/bin/clipsync-w2x` | `.local/local` 包 |
| `~/.local/share/fcitx5/rime/{rime_ice.custom.yaml,rime.lua}` | `.local/local` 包；依赖见 [Rime 说明](rime.md) |
| `~/.config/uv/uv.toml` | `.config/uv` 包 |
| `~/.config/Cursor/User/keybindings.json` | `.config/cursor` 包 |
| `~/.pi/agent/AGENTS.md` | `pi` 包；只同步操作规范 |
| DMS / Mark Shot / Cursor 用户偏好 | `presets/` 的字段快照，见 [使用说明](../presets/README.md) |
| 用户目录与 EDIFIER 耳机规则 | `hosts/desktop` 可选主机包，见 [主机说明](../hosts/desktop/README.md) |

新机器应先安装所需应用和依赖，再备份已有配置并部署。不要直接对整个 `$HOME/.config` 建立一个指向仓库的链接，也不要使用覆盖选项消除尚未审查的冲突。

GNU Stow 的 `--simulate` 只预览链接操作。以下示例需要在仓库根目录执行，并按实际需要选择包：

```sh
stow --simulate --verbose --no-folding --dir=.config --target="$HOME" zsh starship fish uv cursor
stow --simulate --verbose --no-folding --dir=.local --target="$HOME" local
stow --simulate --verbose --no-folding --dir=. --target="$HOME" pi
# 仅适用于当前桌面布局/设备：
stow --simulate --verbose --no-folding --dir=hosts --target="$HOME" desktop
```

检查预览并处理冲突后，去掉 `--simulate` 才会实际部署。根目录的 Bash/Vim/Git 文件需要单独建立链接，不能把整个仓库当作一个 Stow 包。已有整目录链接可以继续使用；新建配置优先逐文件链接，避免运行状态自动落入仓库。

## 音频服务

系统提供的 PipeWire/WirePlumber 单元不再复制到仓库。安装系统软件包后运行：

```sh
sh scripts/setup-audio-services.sh
```

脚本恢复用户服务启用链接，目标位于 `/usr/lib/systemd/user/`；不会立即启动或重启服务。当前机器已经改用这些链接，音频服务保持运行。

自定义 `xremap.service` 保留，使用 `%h` 表示当前用户 HOME。当前机器未安装 xremap，配置文件也只有示例，因此不自动启用。已有 PulseAudio 屏蔽链接指向 `/dev/null`，这是有意禁用服务，不是需要清理的失效链接。

## 依赖与行为边界

| 功能 | 需要 |
| --- | --- |
| 配置部署、偏好合并 | GNU Stow、Python 3（合并工具仅用标准库） |
| Zsh / Fish 提示符 | 对应 shell、Starship；唯一主题为 `kitty-reference.toml` |
| Wayland → X11 剪贴板同步 | `wl-clipboard`、`xclip`、`clipsync-w2x` |
| Vim 系统剪贴板 | 支持 `+clipboard_provider` 的 Vim、Wayland 会话、`wl-clipboard` |
| Niri 截图快捷键 | `mark-shot`；窗口截图需要在界面中点选，整屏直接进入标注 |
| DMS / Matugen 主题 | DMS、Matugen 及各模板依赖；壁纸与状态另行管理 |
| Rime 自定义输入方案 | 雾凇、万象语法模型、LLM 插件，详见 Rime 说明 |
| Git LFS 仓库 | `git-lfs`；当前普通 Git 可用，本机未安装 LFS 命令 |
| Kitty / Cursor 外观 | 设置中指定的字体、主题和图标扩展需另行安装 |

本机 Vim 虽为 `-clipboard` 构建，但支持 `+clipboard_provider`。`.vimrc` 已通过 `wl-copy` / `wl-paste` 接通 `"+`（系统剪贴板）和 `"*`（主选区）寄存器：`y`/`yy` 复制、`x` 剪切、`p`/`P` 粘贴继续沿用原有映射；插入模式可用 `Ctrl+R` 后按 `+` 粘贴。支持中文、多行文本，并保留同一 Vim 内复制的行/矩形选区类型。外部文本以末尾换行判断按行粘贴；读取非文本剪贴板会明确报错。修改后重新打开 Vim 即可生效，终端自身的 `Ctrl+Shift+V` 也可照常使用。其他机器若没有 provider 功能或 Wayland 工具，需要使用当地可用的原生剪贴板后端。

## 不纳入普通配置同步的内容

已停止跟踪但保留本机文件和仓库外备份：Fcitx5 布局缓存、拼音学习字典/历史、Thunar 窗口状态、光标主题缓存、旧 Neovim 配置备份、Kitty/Waybar 备份文件。共 60 个文件。

停止跟踪只影响当前版本，不会清除旧提交中的数据。本轮没有改写 Git 历史。

认证文件、SSH 私钥、云 API 凭据、AI 会话、浏览器资料、截图/剪贴板历史和 Rime 学习数据库继续在本机或加密备份中管理。DMS/Mark Shot/Cursor 的快照不会整体导出这些应用目录。

本次未新增 htop、lf、zathura、mpd、ncmpcpp 和 Zed 的遗留配置：当前命令不在 PATH，部分文件引用旧环境路径或未安装的辅助工具。它们在本机保留，恢复使用后再选择有意义的配置。

现有第三方光标、图标和主题资源暂时保留。Breeze 光标二进制约 14.5 MiB，是当前主要体积来源；其 `icon-theme.cache` 已排除。后续只有在确认上游地址、固定版本、许可证和可靠安装方式后，再用依赖安装取代资源副本，避免迁移后缺少外观资源。

Matugen/DMS 的部分主题输出仍作为启动快照保留，与手写配置分开提交。尚未保证首次部署能自动生成所有被引用文件，因此没有整体停止跟踪。Neovim 的 `lazy-lock.json` 是依赖版本锁定文件，应继续跟踪。

## 检查与备份

偏好合并工具的验证：

```sh
PYTHONDONTWRITEBYTECODE=1 python3 -m unittest discover -s tests -v
python3 scripts/app-settings.py check dms
python3 scripts/app-settings.py check mark-shot
python3 scripts/app-settings.py check cursor
niri validate -c "$HOME/.config/niri/config.kdl"
```

本轮操作前的文件保存在 `~/.local/state/dotfiles-backups/sync-maintenance-foo9ygiw/`。`removed-links.json` 记录已移除失效链接的旧目标；`untracked-files.json` 保存停止跟踪时的 SHA-256；`files/` 按 HOME 相对路径保存原文件和链接。备份目录不进入 Git。

仓库同时出现的 DMS/Clavis/Quickshell 切换工作另行保留。若该部署将整个 DMS 目录链接进仓库，本轮偏好工具可以检查/导出，但有差异时拒绝通过软链接执行合并；应先明确采用哪一种部署方式。
