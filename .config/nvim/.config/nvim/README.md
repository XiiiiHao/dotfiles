# 💤 FanyLazyVim

My lazyvim config branch for arch linux specifically, and it also works on MacOS.

## 本机维护与验证

配置源位于 dotfiles 的 `.config/nvim/.config/nvim/`，`~/.config/nvim` 链接到这里。
当前配置使用 LazyVim 的 blink.cmp 补全引擎，个人补全按键在 `lua/plugins/blink.lua`；
Mason/LSP 沿用 LazyVim 的初始化流程。当前插件不依赖 LuaRocks，因此关闭该可选安装后端。

在 dotfiles 仓库根目录运行回归检查（需要已经安装插件）：

```sh
nvim --headless -i NONE '+luafile tests/test_nvim_config.lua'
```

检查包含 Lua 语法、延迟加载配置、补全按键、Python/C/C++ 缩进、LSP 设置和格式化偏好。
它验证本机配置，不连接远端服务器，也不主动安装或更新插件；不是全新机器安装测试。
交互启动后可运行 `:checkhealth lazy blink.cmp nvim-treesitter mason` 进一步检查依赖。

本次维护针对已安装插件修复配置，保留已有 `lazy-lock.json` 更新，不额外批量升级插件。
后续升级应先备份配置及锁文件，检查插件变更后再执行 `:Lazy update` 并重新运行回归检查。
LaTeX 外部工具需独立安装。本机已安装 `texlive-binextra`（提供 `latexmk`）、`zathura`
和 `zathura-pdf-mupdf`；已验证命令及 PDF 插件可加载，尚未验证实际文档编译。
换机器时需另外恢复这些系统依赖，Git 不保存已安装的软件包。

Based on the starter template for [LazyVim](https://github.com/LazyVim/LazyVim).
Refer to the [documentation](https://lazyvim.github.io/installation) to learn more about it.

Effects are as follows,

![](https://i.postimg.cc/MGL9Ld6G/2024-10-01-184754-hyprshot.png)

![](https://i.postimg.cc/XYzhMVx3/2024-10-01-185236-hyprshot.png)

![](https://i.postimg.cc/LsvVdvmP/2024-10-01-185547-hyprshot.png)

More notes about this config repo, see my [blog](https://fanlumaster.github.io/2023/11/25/Lazyvim-configure-from-scratch/).


