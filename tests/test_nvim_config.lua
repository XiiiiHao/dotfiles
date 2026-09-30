-- Run from the repository root with the deployed user configuration:
-- nvim --headless -i NONE '+luafile tests/test_nvim_config.lua'
-- Does not install/update plugins or save buffers/sessions.
vim.defer_fn(function()
  local count = 0
  local function check(value, message)
    assert(value, message)
    count = count + 1
  end
  local ok, err = xpcall(function()
    -- Headless startup has no UIEnter; exercise the deferred user configuration too.
    if not package.loaded["config.autocmds"] then
      vim.api.nvim_exec_autocmds("User", { pattern = "VeryLazy", modeline = false })
    end
    local config = vim.fn.stdpath("config")
    for _, file in ipairs(vim.fn.glob(config .. "/lua/**/*.lua", false, true)) do
      local chunk, syntax_error = loadfile(file)
      check(chunk ~= nil, file .. ": " .. tostring(syntax_error))
    end
    local lazy = require("lazy.core.config")
    check(lazy.plugins["blink.cmp"] ~= nil, "blink.cmp must be active")
    check(lazy.plugins["nvim-cmp"] == nil, "Only one completion engine should be active")
    check(lazy.plugins["mason.nvim"].url:find("mason%-org/mason.nvim") ~= nil, "Mason owner")
    check(lazy.plugins["mason-lspconfig.nvim"].url:find("mason%-org/mason%-lspconfig.nvim") ~= nil, "Mason LSP owner")
    check(lazy.options.rocks.enabled == false, "Unused LuaRocks support should be off")
    require("lazy").load({ plugins = { "blink.cmp", "nvim-lspconfig", "nvim-treesitter" } })
    local blink = require("blink.cmp.config")
    local function enabled(value)
      if type(value) == "function" then
        return value({})
      end
      return value
    end
    check(enabled(blink.completion.list.selection.preselect) == false, "Do not preselect completions")
    check(enabled(blink.completion.list.selection.auto_insert) == false, "Do not insert previews")
    check(enabled(blink.completion.ghost_text.enabled) == false, "Ghost text stays off")
    check(blink.keymap["<CR>"][1] == "accept", "Enter only accepts selected items")
    check(blink.keymap["<C-n>"][1] == "show", "Ctrl-N opens completion")
    check(blink.keymap["<C-j>"][1] == "select_next", "Ctrl-J selects next item")
    check(blink.keymap["<C-k>"][1] == "select_prev", "Ctrl-K selects previous item")
    check(blink.keymap["<Tab>"][1] == "snippet_forward", "Tab navigates snippets")
    check(blink.snippets.preset == "luasnip", "LuaSnip integration")
    check(
      #vim.api.nvim_get_autocmds({ group = "lazyvim_python_filetype", event = "FileType" }) == 1,
      "Python autocmd is retained"
    )
    check(
      #vim.api.nvim_get_autocmds({ group = "lazyvim_c_filetype", event = "FileType" }) == 2,
      "C/C++ autocmd is retained"
    )
    for ft, width in pairs({ python = 4, c = 2, cpp = 2 }) do
      local buf = vim.api.nvim_create_buf(false, true)
      vim.api.nvim_buf_call(buf, function()
        vim.bo.shiftwidth = 8
        vim.bo.formatoptions = "cro"
        vim.bo.filetype = ft
        check(vim.bo.shiftwidth == width, ft .. " indentation")
        check(not vim.bo.formatoptions:find("o", 1, true), ft .. " comment continuation")
      end)
      vim.api.nvim_buf_delete(buf, { force = true })
    end
    local opts = LazyVim.opts("nvim-lspconfig")
    check(opts.servers.html ~= nil, "HTML server is managed by LazyVim")
    check(opts.servers["*"].keys ~= nil, "Use the current LSP keymap configuration")
    local disabled = {}
    for _, key in ipairs(opts.servers["*"].keys) do
      if key[2] == false then
        disabled[key[1]] = true
      end
    end
    check(disabled["<leader>ca"] and disabled["<leader>cr"] and disabled["<leader>cl"], "Keep buffer-close prefix free")
    check(vim.g.autoformat == false, "Keep manual formatting")
    check(require("conform").formatters.autopep8.prepend_args[2] == "158", "Keep Python formatting preferences")
    check(vim.v.errmsg == "", "Unexpected runtime error: " .. vim.v.errmsg)
  end, debug.traceback)
  for _, name in ipairs({ "persistence", "persisted" }) do
    if package.loaded[name] then
      pcall(package.loaded[name].stop)
    end
  end
  if not ok then
    vim.api.nvim_err_writeln(err)
    vim.cmd("cquit 1")
  else
    print("PASS: " .. count .. " Neovim configuration checks")
    vim.cmd("qa!")
  end
end, 1000)
