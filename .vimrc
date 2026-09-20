"显示行号
set number
"显示相对行号
set relativenumber
"高亮当前行
set cursorline
"语法高亮
syntax on 

" 开启自动缩进，新的一行会自动与上一行对齐
set autoindent
" 在输入搜索词时，实时高亮显示匹配项（增量搜索）
set incsearch

" 高亮显示所有搜索结果
set hlsearch

" 搜索时忽略大小写
set ignorecase

" 如果搜索词中包含了大写字母，则自动切换为大小写敏感搜索
set smartcase
" 开启持久化撤销（undo），即使关闭再打开文件，也能撤销之前的更改
set undofile

" undo目录
silent !mkdir -p ~/.cache/vim/undo
set undodir=~/.cache/vim/undo

" === Wayland 剪贴板：支持 +clipboard_provider 的 Vim 无需 +clipboard ===
if has('clipboard_provider') && exists('&clipmethod')
    let s:clipboard_cache = {}

    function! s:ClipboardAvailable() abort
        return !empty($WAYLAND_DISPLAY) && executable('wl-copy') && executable('wl-paste')
    endfunction

    function! s:ClipboardCopy(reg, type, lines) abort
        let l:text = join(a:lines, "\n") . (a:type ==# 'V' ? "\n" : '')
        let l:primary = a:reg ==# '*' ? ' --primary' : ''
        call system('wl-copy --type ' . shellescape('text/plain;charset=utf-8') . l:primary, l:text)
        if v:shell_error
            throw 'Wayland clipboard: wl-copy 写入失败'
        endif
        " 同一 Vim 内保留按行/矩形选区类型，外部程序仍收到普通文本。
        let s:clipboard_cache[a:reg] = [l:text, a:type]
    endfunction

    function! s:ClipboardPaste(reg) abort
        let l:primary = a:reg ==# '*' ? ' --primary' : ''
        let l:text = system('wl-paste --no-newline --type text' . l:primary)
        if v:shell_error
            throw 'Wayland clipboard: 无法读取剪贴板文本'
        endif
        let l:cached = get(s:clipboard_cache, a:reg, [])
        let l:type = !empty(l:cached) && l:cached[0] ==# l:text
                    \ ? l:cached[1] : (l:text =~# "\n$" ? 'V' : 'v')
        let l:lines = split(l:text, "\n", 1)
        if l:type ==# 'V'
            call remove(l:lines, -1)
        endif
        return [l:type, l:lines]
    endfunction

    let v:clipproviders['wl_clipboard'] = {
                \ 'available': function('s:ClipboardAvailable'),
                \ 'copy': {'+': function('s:ClipboardCopy'), '*': function('s:ClipboardCopy')},
                \ 'paste': {'+': function('s:ClipboardPaste'), '*': function('s:ClipboardPaste')},
                \ }
    " 优先使用 Wayland 工具；其他会话继续尝试 Vim 原有的后端。
    if index(split(&clipmethod, ','), 'wl_clipboard') < 0
        set clipmethod^=wl_clipboard
    endif
endif

" === 将 y (yank 复制) 映射到系统剪贴板 (+ 寄存器) ===
nnoremap y "+y
vnoremap y "+y
nnoremap Y "+Y

" === 将 x (剪切单个字符/选中块) 映射到系统剪贴板 ===
nnoremap x "+x
vnoremap x "+x

" === 可选：如果你希望 p (paste 粘贴) 默认从系统剪贴板粘贴 ===
" 因为你把 y 和 x 放到了系统剪贴板，你通常也会希望 p 直接粘贴系统剪贴板的内容
nnoremap p "+p
vnoremap p "+p
nnoremap P "+P
vnoremap P "+P

" 接管鼠标事件
set mouse=a

" === fcitx5 状态切换与恢复 ===
let g:fcitx_state = 1
autocmd InsertLeave * let g:fcitx_state = system("fcitx5-remote")[0] | call job_start("fcitx5-remote -c")
autocmd InsertEnter * if g:fcitx_state == '2' | call job_start("fcitx5-remote -o") | endif
autocmd VimEnter * call job_start("fcitx5-remote -c")
