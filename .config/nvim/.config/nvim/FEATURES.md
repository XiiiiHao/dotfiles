# Neovim 配置功能说明

这份配置基于 LazyVim，使用 `lazy.nvim` 管理插件，并在此基础上加入了个人按键、UI、搜索、LSP、补全、终端、LaTeX、LeetCode 等工作流配置。

## 启动与插件管理

- 使用 `lazy.nvim` 启动和管理插件。
- 引入 LazyVim 默认插件集合。
- 自动检查插件更新，但不弹出更新通知。
- 禁用部分内置 runtime 插件以减少启动负担，例如 `gzip`、`tarPlugin`、`tohtml`、`tutor`、`zipPlugin`。
- 通过 `lazy-lock.json` 锁定插件版本。

## UI 与主题

- 默认主题使用 `catppuccin`。
- 同时安装了 `tokyonight.nvim` 和 `gruvbox.nvim`，可切换主题。
- `tokyonight` 针对普通终端和 Neovide 做了透明度与风格区分。
- 自定义 Visual 选区颜色。
- 自定义光标高亮颜色，并提供 `<leader><leader>t` 切换光标颜色。
- 使用 Snacks dashboard 作为启动页，带常用入口：
  - 查找文件
  - 新建文件
  - 查找文本
  - 最近文件
  - 配置目录
  - Lazy / LazyExtras
  - 恢复 Session
  - 退出 Neovim
- `noice.nvim` 已禁用。
- `mini.pairs` 已禁用。

## Neovide 支持

- 配置 Neovide 光标特效为 `pixiedust`。
- 禁用 Neovide floating shadow。
- 启用 Neovide 输入法支持。
- 设置光标粒子密度。
- 输入时隐藏鼠标。
- Neovide 下使用 `catppuccin` 主题。
- `<F11>` 可切换 Neovide 全屏。
- `<C-=>` / `<C-->` / `<C-0>` 调整或重置 Neovide 缩放。
- 新增 `neovide/config.toml`，保证 Neovide 配置目录存在，避免启动时监控配置目录报错。

## Which-Key 与 Leader 提示

- 使用 `folke/which-key.nvim` 显示按键提示。
- `<leader>` 和 `<localleader>` 用于触发按键提示。
- 配置了主要分组：
  - `<leader><leader>`：Hop / 快捷动作
  - `<leader>b`：Buffer
  - `<leader>c`：删除当前 Buffer
  - `<leader>d`：Duck / Debug
  - `<leader>f`：查找
  - `<leader>g`：Git
  - `<leader>l`：LSP
  - `<leader>L`：LeetCode
  - `<leader>q`：退出 / Session
  - `<leader>r`：运行命令
  - `<leader>s`：搜索
  - `<leader>t`：终端 / Tab
  - `<leader>u`：UI
  - `<leader>x`：诊断
- `<leader>w` 保存当前文件。
- `<leader>h` 清除搜索高亮。

## 搜索与文件查找

- 使用 Telescope 作为主要搜索工具。
- 自定义快捷键：
  - `<leader>ff` 查找文件
  - `<leader>fF` 查找所有文件，包含隐藏和 ignored 文件
  - `<leader>fw` 全局文本搜索
  - `<leader>fW` 全局文本搜索，包含隐藏和 ignored 文件
  - `<leader>fc` 查找命令
  - `<leader>fC` 搜索光标下单词
  - `<leader>fb` 查找 buffer
  - `<leader>fs` 查找历史 session
- Telescope 忽略大型目录和缓存目录，例如 `.git`、`node_modules`、`.cache`、浏览器配置目录等。
- Telescope 使用 `fd` 查找文件，使用 `rg` 做文本搜索。
- Telescope preview 窗口显示行号。

## 文件树与文件管理

- 使用 `neo-tree.nvim` 作为文件树。
- 快捷键：
  - `<leader>fe` 打开根目录文件树
  - `<leader>fE` 打开当前工作目录文件树
  - `<leader>e` 打开根目录文件树
  - `<leader>E` 打开当前工作目录文件树
  - `<leader>ge` 打开 Git 状态视图
  - `<leader>be` 打开 Buffer 视图
- Neo-tree 自动跟随当前文件。
- Neo-tree 启用 libuv 文件监听。
- Neo-tree 中支持 `zz`、`zt`、`zb` 调整视图位置。
- `yazi.nvim` 配置存在但当前禁用。

## Buffer 管理

- 使用 `bufferline.nvim` 显示 buffer 标签。
- 使用 `mini.bufremove` 删除 buffer。
- 快捷键：
  - `<leader>v` 强制关闭当前 buffer
  - `<leader>c` 删除当前 buffer，未保存时提示保存
  - `<leader>bd` 删除 buffer
  - `<leader>bD` 强制删除 buffer
  - `<b` 当前 buffer 左移
  - `>b` 当前 buffer 右移
- Session 恢复后会刷新 bufferline。

## Hop 快速跳转

- 使用 `hop.nvim` 进行快速跳转。
- 快捷键：
  - `<leader><leader>w` 跳到光标后面的单词开头
  - `<leader><leader>e` 跳到光标后面的单词结尾
  - `<leader><leader>b` 跳到光标前面的单词开头
  - `<leader><leader>v` 跳到光标前面的单词结尾
  - `<leader><leader>l` 按 camelCase 跳到后方单词位置
  - `<leader><leader>h` 按 camelCase 跳到前方单词位置
  - `<leader><leader>a` 跳到任意位置
  - `<leader><leader>j` 跳到下方行
  - `<leader><leader>k` 跳到上方行
- 禁用 LazyVim 默认的 `flash.nvim`。

## LSP 与 Mason

- 使用 `nvim-lspconfig`。
- 使用 `mason.nvim` 管理外部工具。
- 使用 `mason-lspconfig.nvim` 自动安装和配置 LSP。
- 默认安装：
  - `lua-language-server`
  - `pyright`
  - `html-lsp`
  - `clangd`
  - `prettier`
  - `autopep8`
- LSP 相关快捷键集中到 `<leader>l`：
  - `<leader>la` Code Action
  - `<leader>lA` Source Action
  - `<leader>ld` 当前行诊断
  - `<leader>lf` 格式化
  - `<leader>lF` 格式化 injected language
  - `<leader>ll` LspInfo
  - `<leader>lm` Mason
  - `<leader>lr` Rename
- 禁用了部分 LazyVim 默认 `<leader>c*` LSP 映射，避免和个人习惯冲突。

## 格式化

- 使用 `conform.nvim`。
- 默认关闭自动格式化。
- Python 使用 `autopep8`。
- CSS 和 HTML 使用 `prettier`。
- `autopep8` 额外参数：
  - 最大行宽 158
  - 忽略 `E402`

## 补全

- 使用 `nvim-cmp`。
- 补全源包括：
  - LSP
  - LuaSnip
  - path
  - buffer
- 补全性能优化：
  - 降低 debounce / throttle
  - 限制补全项数量
  - 大文件中禁用补全
  - 注释和字符串中禁用补全
- 不自动预选补全项。
- `<C-n>` 或 `<C-,>` 手动触发补全。
- `<C-j>` / `<C-k>` 选择补全项。
- `<CR>` 只确认已手动选择的项。
- `<C-y>` 强制确认补全项。
- `<Tab>` / `<S-Tab>` 用于 LuaSnip 跳转。
- 关闭 ghost text。

## Snippets

- 使用 LuaSnip。
- 加载来源：
  - snipmate snippets
  - Lua snippets
  - VS Code snippets
  - friendly-snippets
  - vim-snippets
- 额外定义了 C / C++ 常用代码片段：
  - `stm`
  - `fanymain`
  - `/*`
- 同时保留了 UltiSnips 配置，片段目录为 `UltiSnips`。

## Treesitter 与括号高亮

- 使用 `rainbow-delimiters.nvim` 做彩虹括号。
- 只在普通文件 buffer 且能成功创建 treesitter parser 时启用。
- 会跳过 Snacks notifier 等临时 buffer，避免 `parser` 为 nil 的报错。

## 终端

- 使用 `toggleterm.nvim`。
- 快捷键：
  - `<leader>th` 横向终端
  - `<leader>tf` 浮动终端
  - `<leader>tt` Tab 终端
  - `<leader>tv` 纵向终端
  - `<F7>` 打开 ToggleTerm
- 终端模式快捷键：
  - `<Esc><Esc>` 回到 Normal 模式
  - `<C-h/j/k/l>` 在窗口间移动
  - `<C-S-l>` 清理终端 buffer

## 代码运行

- `<leader>py` 运行当前 Python 文件。
- `<leader>rc` 使用 `cmake -P %` 运行当前 CMake 脚本。
- `<leader>ru` 执行 `cargo run`。

## LaTeX

- 使用 `vimtex`。
- PDF 查看器为 `zathura`。
- 编译器为 `latexmk`。
- 默认使用 `xelatex`。
- 开启 SyncTeX。
- 禁用连续自动编译，改为手动编译。
- 启用 PDF 自动预览。

## LeetCode

- 使用 `kawre/leetcode.nvim`。
- 默认语言为 C++。
- 题目面板在左侧，宽度 40%。
- 快捷键移动到 `<leader>L` 分组，避免覆盖 LSP：
  - `<leader>Lr` 运行
  - `<leader>Ls` 提交
  - `<leader>Lt` 测试
  - `<leader>Ll` 列表
  - `<leader>Ld` 每日题

## Git 与诊断

- 使用 LazyVim 默认 Git / Telescope Git 功能。
- 使用 `diffview.nvim` 查看 diff。
- 使用 `trouble.nvim` 查看诊断、quickfix、todo 等列表。
- 禁用了部分默认 `<leader>c*` Trouble / LSP 映射，避免冲突。
- 使用 `todo-comments.nvim`，并禁用了默认 `]t` / `[t` 映射，保留给 Tab 切换。

## Tab 与窗口

- `]t` 下一个 Tab。
- `[t` 上一个 Tab。
- `<leader>w` 保存当前文件。
- LazyVim 默认 window 分组中的部分 `<leader>w*` 映射被取消，以便 `<leader>w` 直接保存。

## Session

- 使用 `persisted.nvim`。
- `<leader>fs` 通过 Telescope 搜索历史 session。
- Dashboard 中提供恢复 session 和选择 session 入口。

## 输入法与编辑体验

- Markdown 和 git commit 中关闭 spell。
- Python 文件缩进宽度为 4。
- C / C++ 文件缩进宽度为 2。
- Python、C、C++ 中移除 `formatoptions` 的 `o`，避免用 `o` 新开一行时自动延续注释。
- InsertLeave 时自动解除 LuaSnip 当前 snippet。
- InsertLeave 时如果系统存在 `fcitx5-remote`，自动切换到英文输入法。
- Visual 模式粘贴时使用 `P`，避免替换后寄存器被覆盖。
- 禁用 modeline。
- 默认开启 wrap。
- 显示空格 listchar。
- shell 设置为 `zsh`。

## 自定义命令

- `:CpRelativePath` 复制当前文件相对路径。
- `:CpFileName` 复制当前文件名，不含后缀。
- `:CpAbsolutePath` 复制当前文件绝对路径。

## 其他插件

- `nvim-surround` 已安装，但默认 keymaps / surrounds / aliases 被清空，保留自定义空间。
- `nvim-autopairs` 在 InsertEnter 时加载。
- `markdown-preview.nvim` 已禁用。
- `duck.nvim` 提供趣味显示功能，并在 `<leader>d` 分组下提供快捷键。
